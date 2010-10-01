From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 4/19]: SCST main management files and private headers
Date: Sat, 02 Oct 2010 01:39:58 +0400
Message-ID: <4CA6552E.2070109@vlnb.net>
References: <4CA653F0.1010008@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4CA653F0.1010008@vlnb.net>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, James Bottomley <James.Bottomley@HansenPartnership.com>, Andrew Morton <akpm@linux-foundation.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Vu Pham <vuhuong@mellanox.com>, Bart Van Assche <bart.vanassche@gmail.com>, James Smart <James.Smart@Emulex.Com>, Joe Eykholt <jeykholt@cisco.com>, Andy Yan <ayan@marvell.com>, Chetan Loke <generationgnu@yahoo.com>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, Hannes Reinecke <hare@suse.de>, Richard Sharpe <realrichardsharpe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

This patch contains main management files and private headers.

File scst_main.c contains management functions to create and destroy
target drivers, targets, sessions, device drivers, devices and threads.

A typical life-circle of a target driver:

1. scst_register_target_template()

2. scst_register_target() for each target

3. scst_register_session() for each incoming session.

4. Serving commands:

4.1. scst_rx_cmd() on a new command

4.2. scst_cmd_init_done() after the command's initialization finished

4.3. For WRITE-direction commands only:

4.3.1. rdy_to_xfer() callback to receive data into prepared buffer

4.3.2. scst_rx_data() to notify SCST core that all the data received

4.4. xmit_response() callback to transfer response with (possibly) data
to the initiator

4.5. scst_tgt_cmd_done() - to notify SCST core that the response has sent

4.6. on_free_cmd() callback to notify that the command is about to be freed

5. scst_unregister_session() when initiator disconnects

6. scst_unregister_target()

7. scst_unregister_target_template()


A typical lifecircle of a virtual dev handler:

1. scst_register_virtual_dev_driver()

2. scst_register_virtual_device() for each virtual device as requested user space
configurator

3. Serving commands:

3.1. parse() callback to ensure that command initialized correctly and initialize
what's not initialized yet. Particularly, data transfer direction and data transfer size.

3.2. exec() callback to execute the command

3.3. Calling cmd->scst_cmd_done() to notify SCST core that the command finished.

3.4. dev_done() callback to notify that SCST core finished post processing of the
command

3.5. on_free_cmd() callback to notify that the command is about to be freed

4. scst_unregister_virtual_device()

5. scst_register_virtual_dev_driver()

Signed-off-by: Vladislav Bolkhovitin <vst@vlnb.net>
---
 scst_main.c   | 2105 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 scst_module.c |   63 +
 scst_priv.h   |  606 ++++++++++++++++
 3 files changed, 2774 insertions(+)

diff -uprN orig/linux-2.6.35/drivers/scst/scst_main.c linux-2.6.35/drivers/scst/scst_main.c
--- orig/linux-2.6.35/drivers/scst/scst_main.c
+++ linux-2.6.35/drivers/scst/scst_main.c
@@ -0,0 +1,2105 @@
+/*
+ *  scst_main.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+
+#include <linux/init.h>
+#include <linux/kernel.h>
+#include <linux/errno.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/unistd.h>
+#include <linux/string.h>
+#include <linux/kthread.h>
+#include <linux/delay.h>
+
+#include <scst/scst.h>
+#include "scst_priv.h"
+#include "scst_mem.h"
+#include "scst_pres.h"
+
+#if defined(CONFIG_HIGHMEM4G) || defined(CONFIG_HIGHMEM64G)
+#warning "HIGHMEM kernel configurations are fully supported, but not\
+ recommended for performance reasons. Consider changing VMSPLIT\
+ option or use a 64-bit configuration instead. See README file for\
+ details."
+#endif
+
+/**
+ ** SCST global variables. They are all uninitialized to have their layout in
+ ** memory be exactly as specified. Otherwise compiler puts zero-initialized
+ ** variable separately from nonzero-initialized ones.
+ **/
+
+/*
+ * Main SCST mutex. All targets, devices and dev_types management is done
+ * under this mutex.
+ *
+ * It must NOT be used in any works (schedule_work(), etc.), because
+ * otherwise a deadlock (double lock, actually) is possible, e.g., with
+ * scst_user detach_tgt(), which is called under scst_mutex and calls
+ * flush_scheduled_work().
+ */
+struct mutex scst_mutex;
+EXPORT_SYMBOL_GPL(scst_mutex);
+
+/*
+ * Secondary level main mutex, inner for scst_mutex. Needed for
+ * __scst_pr_register_all_tg_pt(), since we can't use scst_mutex there,
+ * because of the circular locking dependency with dev_pr_mutex.
+ */
+struct mutex scst_mutex2;
+
+/* Both protected by scst_mutex or scst_mutex2 on read and both on write */
+struct list_head scst_template_list;
+struct list_head scst_dev_list;
+
+/* Protected by scst_mutex */
+struct list_head scst_dev_type_list;
+struct list_head scst_virtual_dev_type_list;
+
+spinlock_t scst_main_lock;
+
+static struct kmem_cache *scst_mgmt_cachep;
+mempool_t *scst_mgmt_mempool;
+static struct kmem_cache *scst_mgmt_stub_cachep;
+mempool_t *scst_mgmt_stub_mempool;
+static struct kmem_cache *scst_ua_cachep;
+mempool_t *scst_ua_mempool;
+static struct kmem_cache *scst_sense_cachep;
+mempool_t *scst_sense_mempool;
+static struct kmem_cache *scst_aen_cachep;
+mempool_t *scst_aen_mempool;
+struct kmem_cache *scst_tgtd_cachep;
+struct kmem_cache *scst_sess_cachep;
+struct kmem_cache *scst_acgd_cachep;
+
+unsigned int scst_setup_id;
+
+spinlock_t scst_init_lock;
+wait_queue_head_t scst_init_cmd_list_waitQ;
+struct list_head scst_init_cmd_list;
+unsigned int scst_init_poll_cnt;
+
+struct kmem_cache *scst_cmd_cachep;
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+unsigned long scst_trace_flag;
+#endif
+
+unsigned long scst_flags;
+atomic_t scst_cmd_count;
+
+struct scst_cmd_threads scst_main_cmd_threads;
+
+struct scst_tasklet scst_tasklets[NR_CPUS];
+
+spinlock_t scst_mcmd_lock;
+struct list_head scst_active_mgmt_cmd_list;
+struct list_head scst_delayed_mgmt_cmd_list;
+wait_queue_head_t scst_mgmt_cmd_list_waitQ;
+
+wait_queue_head_t scst_mgmt_waitQ;
+spinlock_t scst_mgmt_lock;
+struct list_head scst_sess_init_list;
+struct list_head scst_sess_shut_list;
+
+wait_queue_head_t scst_dev_cmd_waitQ;
+
+static struct mutex scst_suspend_mutex;
+/* protected by scst_suspend_mutex */
+static struct list_head scst_cmd_threads_list;
+
+int scst_threads;
+static struct task_struct *scst_init_cmd_thread;
+static struct task_struct *scst_mgmt_thread;
+static struct task_struct *scst_mgmt_cmd_thread;
+
+static int suspend_count;
+
+static int scst_virt_dev_last_id; /* protected by scst_mutex */
+
+cpumask_t default_cpu_mask;
+
+static unsigned int scst_max_cmd_mem;
+unsigned int scst_max_dev_cmd_mem;
+
+module_param_named(scst_threads, scst_threads, int, 0);
+MODULE_PARM_DESC(scst_threads, "SCSI target threads count");
+
+module_param_named(scst_max_cmd_mem, scst_max_cmd_mem, int, S_IRUGO);
+MODULE_PARM_DESC(scst_max_cmd_mem, "Maximum memory allowed to be consumed by "
+	"all SCSI commands of all devices at any given time in MB");
+
+module_param_named(scst_max_dev_cmd_mem, scst_max_dev_cmd_mem, int, S_IRUGO);
+MODULE_PARM_DESC(scst_max_dev_cmd_mem, "Maximum memory allowed to be consumed "
+	"by all SCSI commands of a device at any given time in MB");
+
+struct scst_dev_type scst_null_devtype = {
+	.name = "none",
+	.threads_num = -1,
+};
+
+static void __scst_resume_activity(void);
+
+/**
+ * __scst_register_target_template() - register target template.
+ * @vtt:	target template
+ * @version:	SCST_INTERFACE_VERSION version string to ensure that
+ *		SCST core and the target driver use the same version of
+ *		the SCST interface
+ *
+ * Description:
+ *    Registers a target template and returns 0 on success or appropriate
+ *    error code otherwise.
+ *
+ *    Target drivers supposed to behave sanely and not call register()
+ *    and unregister() randomly sinultaneously.
+ */
+int __scst_register_target_template(struct scst_tgt_template *vtt,
+	const char *version)
+{
+	int res = 0;
+	struct scst_tgt_template *t;
+
+	INIT_LIST_HEAD(&vtt->tgt_list);
+
+	if (strcmp(version, SCST_INTERFACE_VERSION) != 0) {
+		PRINT_ERROR("Incorrect version of target %s", vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (!vtt->detect) {
+		PRINT_ERROR("Target driver %s must have "
+			"detect() method.", vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (!vtt->release) {
+		PRINT_ERROR("Target driver %s must have "
+			"release() method.", vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (!vtt->xmit_response) {
+		PRINT_ERROR("Target driver %s must have "
+			"xmit_response() method.", vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (vtt->get_initiator_port_transport_id == NULL)
+		PRINT_WARNING("Target driver %s doesn't support Persistent "
+			"Reservations", vtt->name);
+
+	if (vtt->threads_num < 0) {
+		PRINT_ERROR("Wrong threads_num value %d for "
+			"target \"%s\"", vtt->threads_num,
+			vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if ((!vtt->enable_target || !vtt->is_target_enabled) &&
+	    !vtt->enabled_attr_not_needed)
+		PRINT_WARNING("Target driver %s doesn't have enable_target() "
+			"and/or is_target_enabled() method(s). This is unsafe "
+			"and can lead that initiators connected on the "
+			"initialization time can see an unexpected set of "
+			"devices or no devices at all!", vtt->name);
+
+	if (((vtt->add_target != NULL) && (vtt->del_target == NULL)) ||
+	    ((vtt->add_target == NULL) && (vtt->del_target != NULL))) {
+		PRINT_ERROR("Target driver %s must either define both "
+			"add_target() and del_target(), or none.", vtt->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (vtt->rdy_to_xfer == NULL)
+		vtt->rdy_to_xfer_atomic = 1;
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0)
+		goto out;
+	list_for_each_entry(t, &scst_template_list, scst_template_list_entry) {
+		if (strcmp(t->name, vtt->name) == 0) {
+			PRINT_ERROR("Target driver %s already registered",
+				vtt->name);
+			mutex_unlock(&scst_mutex);
+			goto out_unlock;
+		}
+	}
+	mutex_unlock(&scst_mutex);
+
+	res = scst_tgtt_sysfs_create(vtt);
+	if (res)
+		goto out;
+
+	mutex_lock(&scst_mutex);
+	mutex_lock(&scst_mutex2);
+	list_add_tail(&vtt->scst_template_list_entry, &scst_template_list);
+	mutex_unlock(&scst_mutex2);
+	mutex_unlock(&scst_mutex);
+
+	TRACE_DBG("%s", "Calling target driver's detect()");
+	res = vtt->detect(vtt);
+	TRACE_DBG("Target driver's detect() returned %d", res);
+	if (res < 0) {
+		PRINT_ERROR("%s", "The detect() routine failed");
+		res = -EINVAL;
+		goto out_del;
+	}
+
+	PRINT_INFO("Target template %s registered successfully", vtt->name);
+
+out:
+	return res;
+
+out_del:
+	scst_tgtt_sysfs_del(vtt);
+
+	mutex_lock(&scst_mutex);
+
+	mutex_lock(&scst_mutex2);
+	list_del(&vtt->scst_template_list_entry);
+	mutex_unlock(&scst_mutex2);
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(__scst_register_target_template);
+
+static int scst_check_non_gpl_target_template(struct scst_tgt_template *vtt)
+{
+	int res;
+
+	if (vtt->task_mgmt_affected_cmds_done || vtt->threads_num ||
+	    vtt->on_hw_pending_cmd_timeout) {
+		PRINT_ERROR("Not allowed functionality in non-GPL version for "
+			"target template %s", vtt->name);
+		res = -EPERM;
+		goto out;
+	}
+
+	res = 0;
+
+out:
+	return res;
+}
+
+/**
+ * __scst_register_target_template_non_gpl() - register target template,
+ *					      non-GPL version
+ * @vtt:	target template
+ * @version:	SCST_INTERFACE_VERSION version string to ensure that
+ *		SCST core and the target driver use the same version of
+ *		the SCST interface
+ *
+ * Description:
+ *    Registers a target template and returns 0 on success or appropriate
+ *    error code otherwise.
+ *
+ *    Note: *vtt must be static!
+ */
+int __scst_register_target_template_non_gpl(struct scst_tgt_template *vtt,
+	const char *version)
+{
+	int res;
+
+	res = scst_check_non_gpl_target_template(vtt);
+	if (res != 0)
+		goto out;
+
+	res = __scst_register_target_template(vtt, version);
+
+out:
+	return res;
+}
+EXPORT_SYMBOL(__scst_register_target_template_non_gpl);
+
+/**
+ * scst_unregister_target_template() - unregister target template
+ *
+ * Target drivers supposed to behave sanely and not call register()
+ * and unregister() randomly sinultaneously. Also it is supposed that
+ * no attepts to create new targets for this vtt will be done in a race
+ * with this function.
+ */
+void scst_unregister_target_template(struct scst_tgt_template *vtt)
+{
+	struct scst_tgt *tgt;
+	struct scst_tgt_template *t;
+	int found = 0;
+
+	mutex_lock(&scst_mutex);
+
+	list_for_each_entry(t, &scst_template_list, scst_template_list_entry) {
+		if (strcmp(t->name, vtt->name) == 0) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		PRINT_ERROR("Target driver %s isn't registered", vtt->name);
+		goto out_err_up;
+	}
+
+	mutex_lock(&scst_mutex2);
+	list_del(&vtt->scst_template_list_entry);
+	mutex_unlock(&scst_mutex2);
+
+	/* Wait for outstanding sysfs mgmt calls completed */
+	while (vtt->tgtt_active_sysfs_works_count > 0) {
+		mutex_unlock(&scst_mutex);
+		msleep(100);
+		mutex_lock(&scst_mutex);
+	}
+
+restart:
+	list_for_each_entry(tgt, &vtt->tgt_list, tgt_list_entry) {
+		mutex_unlock(&scst_mutex);
+		scst_unregister_target(tgt);
+		mutex_lock(&scst_mutex);
+		goto restart;
+	}
+
+	mutex_unlock(&scst_mutex);
+
+	scst_tgtt_sysfs_del(vtt);
+
+	PRINT_INFO("Target template %s unregistered successfully", vtt->name);
+
+out:
+	return;
+
+out_err_up:
+	mutex_unlock(&scst_mutex);
+	goto out;
+}
+EXPORT_SYMBOL(scst_unregister_target_template);
+
+/**
+ * scst_register_target() - register target
+ *
+ * Registers a target for template vtt and returns new target structure on
+ * success or NULL otherwise.
+ */
+struct scst_tgt *scst_register_target(struct scst_tgt_template *vtt,
+	const char *target_name)
+{
+	struct scst_tgt *tgt;
+	int rc = 0;
+
+	rc = scst_alloc_tgt(vtt, &tgt);
+	if (rc != 0)
+		goto out;
+
+	if (target_name != NULL) {
+
+		tgt->tgt_name = kmalloc(strlen(target_name) + 1, GFP_KERNEL);
+		if (tgt->tgt_name == NULL) {
+			TRACE(TRACE_OUT_OF_MEM, "Allocation of tgt name %s failed",
+				target_name);
+			rc = -ENOMEM;
+			goto out_free_tgt;
+		}
+		strcpy(tgt->tgt_name, target_name);
+	} else {
+		static int tgt_num; /* protected by scst_mutex */
+		int len = strlen(vtt->name) +
+			strlen(SCST_DEFAULT_TGT_NAME_SUFFIX) + 11 + 1;
+
+		tgt->tgt_name = kmalloc(len, GFP_KERNEL);
+		if (tgt->tgt_name == NULL) {
+			TRACE(TRACE_OUT_OF_MEM, "Allocation of tgt name failed "
+				"(template name %s)", vtt->name);
+			rc = -ENOMEM;
+			goto out_free_tgt;
+		}
+		sprintf(tgt->tgt_name, "%s%s%d", vtt->name,
+			SCST_DEFAULT_TGT_NAME_SUFFIX, tgt_num++);
+	}
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0) {
+		rc = -EINTR;
+		goto out_free_tgt;
+	}
+
+	rc = scst_tgt_sysfs_create(tgt);
+	if (rc < 0)
+		goto out_unlock;
+
+	tgt->default_acg = scst_alloc_add_acg(tgt, tgt->tgt_name, false);
+	if (tgt->default_acg == NULL)
+		goto out_sysfs_del;
+
+	mutex_lock(&scst_mutex2);
+	list_add_tail(&tgt->tgt_list_entry, &vtt->tgt_list);
+	mutex_unlock(&scst_mutex2);
+
+	mutex_unlock(&scst_mutex);
+
+	PRINT_INFO("Target %s for template %s registered successfully",
+		tgt->tgt_name, vtt->name);
+
+	TRACE_DBG("tgt %p", tgt);
+
+out:
+	return tgt;
+
+out_sysfs_del:
+	mutex_unlock(&scst_mutex);
+	scst_tgt_sysfs_del(tgt);
+	goto out_free_tgt;
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+
+out_free_tgt:
+	/* In case of error tgt_name will be freed in scst_free_tgt() */
+	scst_free_tgt(tgt);
+	tgt = NULL;
+	goto out;
+}
+EXPORT_SYMBOL(scst_register_target);
+
+static inline int test_sess_list(struct scst_tgt *tgt)
+{
+	int res;
+	mutex_lock(&scst_mutex);
+	res = list_empty(&tgt->sess_list);
+	mutex_unlock(&scst_mutex);
+	return res;
+}
+
+/**
+ * scst_unregister_target() - unregister target.
+ *
+ * It is supposed that no attepts to create new sessions for this
+ * target will be done in a race with this function.
+ */
+void scst_unregister_target(struct scst_tgt *tgt)
+{
+	struct scst_session *sess;
+	struct scst_tgt_template *vtt = tgt->tgtt;
+	struct scst_acg *acg, *acg_tmp;
+
+	TRACE_DBG("%s", "Calling target driver's release()");
+	tgt->tgtt->release(tgt);
+	TRACE_DBG("%s", "Target driver's release() returned");
+
+	mutex_lock(&scst_mutex);
+again:
+	list_for_each_entry(sess, &tgt->sess_list, sess_list_entry) {
+		if (sess->shut_phase == SCST_SESS_SPH_READY) {
+			/*
+			 * Sometimes it's hard for target driver to track all
+			 * its sessions (see scst_local, eg), so let's help it.
+			 */
+			mutex_unlock(&scst_mutex);
+			scst_unregister_session(sess, 0, NULL);
+			mutex_lock(&scst_mutex);
+			goto again;
+		}
+	}
+	mutex_unlock(&scst_mutex);
+
+	TRACE_DBG("%s", "Waiting for sessions shutdown");
+	wait_event(tgt->unreg_waitQ, test_sess_list(tgt));
+	TRACE_DBG("%s", "wait_event() returned");
+
+	scst_suspend_activity(false);
+	mutex_lock(&scst_mutex);
+
+	mutex_lock(&scst_mutex2);
+	list_del(&tgt->tgt_list_entry);
+	mutex_unlock(&scst_mutex2);
+
+	del_timer_sync(&tgt->retry_timer);
+
+	scst_del_free_acg(tgt->default_acg);
+
+	list_for_each_entry_safe(acg, acg_tmp, &tgt->tgt_acg_list,
+					acg_list_entry) {
+		scst_del_free_acg(acg);
+	}
+
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+
+	scst_tgt_sysfs_del(tgt);
+
+	PRINT_INFO("Target %s for template %s unregistered successfully",
+		tgt->tgt_name, vtt->name);
+
+	scst_free_tgt(tgt);
+
+	TRACE_DBG("Unregistering tgt %p finished", tgt);
+	return;
+}
+EXPORT_SYMBOL(scst_unregister_target);
+
+static int scst_susp_wait(bool interruptible)
+{
+	int res = 0;
+
+	if (interruptible) {
+		res = wait_event_interruptible_timeout(scst_dev_cmd_waitQ,
+			(atomic_read(&scst_cmd_count) == 0),
+			SCST_SUSPENDING_TIMEOUT);
+		if (res <= 0) {
+			__scst_resume_activity();
+			if (res == 0)
+				res = -EBUSY;
+		} else
+			res = 0;
+	} else
+		wait_event(scst_dev_cmd_waitQ,
+			   atomic_read(&scst_cmd_count) == 0);
+
+	TRACE_MGMT_DBG("wait_event() returned %d", res);
+	return res;
+}
+
+/**
+ * scst_suspend_activity() - globally suspend any activity
+ *
+ * Description:
+ *    Globally suspends any activity and doesn't return, until there are any
+ *    active commands (state after SCST_CMD_STATE_INIT). If "interruptible"
+ *    is true, it returns after SCST_SUSPENDING_TIMEOUT or if it was interrupted
+ *    by a signal with the corresponding error status < 0. If "interruptible"
+ *    is false, it will wait virtually forever. On success returns 0.
+ *
+ *    New arriving commands stay in the suspended state until
+ *    scst_resume_activity() is called.
+ */
+int scst_suspend_activity(bool interruptible)
+{
+	int res = 0;
+	bool rep = false;
+
+	if (interruptible) {
+		if (mutex_lock_interruptible(&scst_suspend_mutex) != 0) {
+			res = -EINTR;
+			goto out;
+		}
+	} else
+		mutex_lock(&scst_suspend_mutex);
+
+	TRACE_MGMT_DBG("suspend_count %d", suspend_count);
+	suspend_count++;
+	if (suspend_count > 1)
+		goto out_up;
+
+	set_bit(SCST_FLAG_SUSPENDING, &scst_flags);
+	set_bit(SCST_FLAG_SUSPENDED, &scst_flags);
+	/*
+	 * Assignment of SCST_FLAG_SUSPENDING and SCST_FLAG_SUSPENDED must be
+	 * ordered with scst_cmd_count. Otherwise lockless logic in
+	 * scst_translate_lun() and scst_mgmt_translate_lun() won't work.
+	 */
+	smp_mb__after_set_bit();
+
+	/*
+	 * See comment in scst_user.c::dev_user_task_mgmt_fn() for more
+	 * information about scst_user behavior.
+	 *
+	 * ToDo: make the global suspending unneeded (switch to per-device
+	 * reference counting? That would mean to switch off from lockless
+	 * implementation of scst_translate_lun().. )
+	 */
+
+	if (atomic_read(&scst_cmd_count) != 0) {
+		PRINT_INFO("Waiting for %d active commands to complete... This "
+			"might take few minutes for disks or few hours for "
+			"tapes, if you use long executed commands, like "
+			"REWIND or FORMAT. In case, if you have a hung user "
+			"space device (i.e. made using scst_user module) not "
+			"responding to any commands, if might take virtually "
+			"forever until the corresponding user space "
+			"program recovers and starts responding or gets "
+			"killed.", atomic_read(&scst_cmd_count));
+		rep = true;
+	}
+
+	res = scst_susp_wait(interruptible);
+	if (res != 0)
+		goto out_clear;
+
+	clear_bit(SCST_FLAG_SUSPENDING, &scst_flags);
+	/* See comment about smp_mb() above */
+	smp_mb__after_clear_bit();
+
+	TRACE_MGMT_DBG("Waiting for %d active commands finally to complete",
+		atomic_read(&scst_cmd_count));
+
+	res = scst_susp_wait(interruptible);
+	if (res != 0)
+		goto out_clear;
+
+	if (rep)
+		PRINT_INFO("%s", "All active commands completed");
+
+out_up:
+	mutex_unlock(&scst_suspend_mutex);
+
+out:
+	return res;
+
+out_clear:
+	clear_bit(SCST_FLAG_SUSPENDING, &scst_flags);
+	/* See comment about smp_mb() above */
+	smp_mb__after_clear_bit();
+	goto out_up;
+}
+EXPORT_SYMBOL_GPL(scst_suspend_activity);
+
+static void __scst_resume_activity(void)
+{
+	struct scst_cmd_threads *l;
+
+	suspend_count--;
+	TRACE_MGMT_DBG("suspend_count %d left", suspend_count);
+	if (suspend_count > 0)
+		goto out;
+
+	clear_bit(SCST_FLAG_SUSPENDED, &scst_flags);
+	/*
+	 * The barrier is needed to make sure all woken up threads see the
+	 * cleared flag. Not sure if it's really needed, but let's be safe.
+	 */
+	smp_mb__after_clear_bit();
+
+	list_for_each_entry(l, &scst_cmd_threads_list, lists_list_entry) {
+		wake_up_all(&l->cmd_list_waitQ);
+	}
+	wake_up_all(&scst_init_cmd_list_waitQ);
+
+	spin_lock_irq(&scst_mcmd_lock);
+	if (!list_empty(&scst_delayed_mgmt_cmd_list)) {
+		struct scst_mgmt_cmd *m;
+		m = list_entry(scst_delayed_mgmt_cmd_list.next, typeof(*m),
+				mgmt_cmd_list_entry);
+		TRACE_MGMT_DBG("Moving delayed mgmt cmd %p to head of active "
+			"mgmt cmd list", m);
+		list_move(&m->mgmt_cmd_list_entry, &scst_active_mgmt_cmd_list);
+	}
+	spin_unlock_irq(&scst_mcmd_lock);
+	wake_up_all(&scst_mgmt_cmd_list_waitQ);
+
+out:
+	return;
+}
+
+/**
+ * scst_resume_activity() - globally resume all activities
+ *
+ * Resumes suspended by scst_suspend_activity() activities.
+ */
+void scst_resume_activity(void)
+{
+
+	mutex_lock(&scst_suspend_mutex);
+	__scst_resume_activity();
+	mutex_unlock(&scst_suspend_mutex);
+	return;
+}
+EXPORT_SYMBOL_GPL(scst_resume_activity);
+
+static int scst_register_device(struct scsi_device *scsidp)
+{
+	int res = 0;
+	struct scst_device *dev, *d;
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0) {
+		res = -EINTR;
+		goto out;
+	}
+
+	res = scst_alloc_device(GFP_KERNEL, &dev);
+	if (res != 0)
+		goto out_unlock;
+
+	dev->type = scsidp->type;
+
+	dev->virt_name = kmalloc(50, GFP_KERNEL);
+	if (dev->virt_name == NULL) {
+		PRINT_ERROR("%s", "Unable to alloc device name");
+		res = -ENOMEM;
+		goto out_free_dev;
+	}
+	snprintf(dev->virt_name, 50, "%d:%d:%d:%d", scsidp->host->host_no,
+		scsidp->channel, scsidp->id, scsidp->lun);
+
+	list_for_each_entry(d, &scst_dev_list, dev_list_entry) {
+		if (strcmp(d->virt_name, dev->virt_name) == 0) {
+			PRINT_ERROR("Device %s already exists", dev->virt_name);
+			res = -EEXIST;
+			goto out_free_dev;
+		}
+	}
+
+	dev->scsi_dev = scsidp;
+
+	list_add_tail(&dev->dev_list_entry, &scst_dev_list);
+
+	mutex_unlock(&scst_mutex);
+
+	res = scst_dev_sysfs_create(dev);
+	if (res != 0)
+		goto out_del;
+
+	PRINT_INFO("Attached to scsi%d, channel %d, id %d, lun %d, "
+		"type %d", scsidp->host->host_no, scsidp->channel,
+		scsidp->id, scsidp->lun, scsidp->type);
+
+out:
+	return res;
+
+out_del:
+	list_del(&dev->dev_list_entry);
+
+out_free_dev:
+	scst_free_device(dev);
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	goto out;
+}
+
+static void scst_unregister_device(struct scsi_device *scsidp)
+{
+	struct scst_device *d, *dev = NULL;
+	struct scst_acg_dev *acg_dev, *aa;
+
+	scst_suspend_activity(false);
+	mutex_lock(&scst_mutex);
+
+	list_for_each_entry(d, &scst_dev_list, dev_list_entry) {
+		if (d->scsi_dev == scsidp) {
+			dev = d;
+			TRACE_DBG("Device %p found", dev);
+			break;
+		}
+	}
+	if (dev == NULL) {
+		PRINT_ERROR("SCST device for SCSI device %d:%d:%d:%d not found",
+			scsidp->host->host_no, scsidp->channel, scsidp->id,
+			scsidp->lun);
+		goto out_unlock;
+	}
+
+	list_del(&dev->dev_list_entry);
+
+	scst_assign_dev_handler(dev, &scst_null_devtype);
+
+	list_for_each_entry_safe(acg_dev, aa, &dev->dev_acg_dev_list,
+				 dev_acg_dev_list_entry) {
+		scst_acg_del_lun(acg_dev->acg, acg_dev->lun, true);
+	}
+
+	mutex_unlock(&scst_mutex);
+
+	scst_resume_activity();
+
+	scst_dev_sysfs_del(dev);
+
+	PRINT_INFO("Detached from scsi%d, channel %d, id %d, lun %d, type %d",
+		scsidp->host->host_no, scsidp->channel, scsidp->id,
+		scsidp->lun, scsidp->type);
+
+	scst_free_device(dev);
+
+out:
+	return;
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+	goto out;
+}
+
+static int scst_dev_handler_check(struct scst_dev_type *dev_handler)
+{
+	int res = 0;
+
+	if (dev_handler->parse == NULL) {
+		PRINT_ERROR("scst dev handler %s must have "
+			"parse() method.", dev_handler->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (((dev_handler->add_device != NULL) &&
+	     (dev_handler->del_device == NULL)) ||
+	    ((dev_handler->add_device == NULL) &&
+	     (dev_handler->del_device != NULL))) {
+		PRINT_ERROR("Dev handler %s must either define both "
+			"add_device() and del_device(), or none.",
+			dev_handler->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (dev_handler->alloc_data_buf == NULL)
+		dev_handler->alloc_data_buf_atomic = 1;
+
+	if (dev_handler->dev_done == NULL)
+		dev_handler->dev_done_atomic = 1;
+
+out:
+	return res;
+}
+
+static int scst_check_device_name(const char *dev_name)
+{
+	int res = 0;
+
+	if (strchr(dev_name, '/') != NULL) {
+		PRINT_ERROR("Dev name %s contains illegal character '/'",
+			dev_name);
+		res = -EINVAL;
+	}
+	return res;
+}
+
+/**
+ * scst_register_virtual_device() - register a virtual device.
+ * @dev_handler: the device's device handler
+ * @dev_name:	the new device name, NULL-terminated string. Must be uniq
+ *              among all virtual devices in the system.
+ *
+ * Registers a virtual device and returns assinged to the device ID on
+ * success, or negative value otherwise
+ */
+int scst_register_virtual_device(struct scst_dev_type *dev_handler,
+	const char *dev_name)
+{
+	int res, rc;
+	struct scst_device *dev, *d;
+	bool sysfs_del = false;
+
+	if (dev_handler == NULL) {
+		PRINT_ERROR("%s: valid device handler must be supplied",
+			    __func__);
+		res = -EINVAL;
+		goto out;
+	}
+
+	if (dev_name == NULL) {
+		PRINT_ERROR("%s: device name must be non-NULL", __func__);
+		res = -EINVAL;
+		goto out;
+	}
+
+	res = scst_check_device_name(dev_name);
+	if (res != 0)
+		goto out;
+
+	res = scst_dev_handler_check(dev_handler);
+	if (res != 0)
+		goto out;
+
+	res = scst_suspend_activity(true);
+	if (res != 0)
+		goto out;
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0) {
+		res = -EINTR;
+		goto out_resume;
+	}
+
+	res = scst_alloc_device(GFP_KERNEL, &dev);
+	if (res != 0)
+		goto out_unlock;
+
+	dev->type = dev_handler->type;
+	dev->scsi_dev = NULL;
+	dev->virt_name = kstrdup(dev_name, GFP_KERNEL);
+	if (dev->virt_name == NULL) {
+		PRINT_ERROR("Unable to allocate virt_name for dev %s",
+			dev_name);
+		res = -ENOMEM;
+		goto out_free_dev;
+	}
+
+	while (1) {
+		dev->virt_id = scst_virt_dev_last_id++;
+		if (dev->virt_id > 0)
+			break;
+		scst_virt_dev_last_id = 1;
+	}
+
+	res = dev->virt_id;
+
+	rc = scst_pr_init_dev(dev);
+	if (rc != 0) {
+		res = rc;
+		goto out_free_dev;
+	}
+
+	/*
+	 * We can drop scst_mutex, because we have not yet added the dev in
+	 * scst_dev_list, so it "doesn't exist" yet.
+	 */
+	mutex_unlock(&scst_mutex);
+
+	res = scst_dev_sysfs_create(dev);
+	if (res != 0)
+		goto out_lock_pr_clear_dev;
+
+	mutex_lock(&scst_mutex);
+
+	list_for_each_entry(d, &scst_dev_list, dev_list_entry) {
+		if (strcmp(d->virt_name, dev_name) == 0) {
+			PRINT_ERROR("Device %s already exists", dev_name);
+			res = -EEXIST;
+			sysfs_del = true;
+			goto out_pr_clear_dev;
+		}
+	}
+
+	rc = scst_assign_dev_handler(dev, dev_handler);
+	if (rc != 0) {
+		res = rc;
+		sysfs_del = true;
+		goto out_pr_clear_dev;
+	}
+
+	list_add_tail(&dev->dev_list_entry, &scst_dev_list);
+
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+
+	res = dev->virt_id;
+
+	PRINT_INFO("Attached to virtual device %s (id %d)",
+		dev_name, res);
+
+out:
+	return res;
+
+out_lock_pr_clear_dev:
+	mutex_lock(&scst_mutex);
+
+out_pr_clear_dev:
+	scst_pr_clear_dev(dev);
+
+out_free_dev:
+	mutex_unlock(&scst_mutex);
+	if (sysfs_del)
+		scst_dev_sysfs_del(dev);
+	scst_free_device(dev);
+	goto out_resume;
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+
+out_resume:
+	scst_resume_activity();
+	goto out;
+}
+EXPORT_SYMBOL_GPL(scst_register_virtual_device);
+
+/**
+ * scst_unregister_virtual_device() - unegister a virtual device.
+ * @id:		the device's ID, returned by the registration function
+ */
+void scst_unregister_virtual_device(int id)
+{
+	struct scst_device *d, *dev = NULL;
+	struct scst_acg_dev *acg_dev, *aa;
+
+	scst_suspend_activity(false);
+	mutex_lock(&scst_mutex);
+
+	list_for_each_entry(d, &scst_dev_list, dev_list_entry) {
+		if (d->virt_id == id) {
+			dev = d;
+			TRACE_DBG("Virtual device %p (id %d) found", dev, id);
+			break;
+		}
+	}
+	if (dev == NULL) {
+		PRINT_ERROR("Virtual device (id %d) not found", id);
+		goto out_unlock;
+	}
+
+	list_del(&dev->dev_list_entry);
+
+	scst_pr_clear_dev(dev);
+
+	scst_assign_dev_handler(dev, &scst_null_devtype);
+
+	list_for_each_entry_safe(acg_dev, aa, &dev->dev_acg_dev_list,
+				 dev_acg_dev_list_entry) {
+		scst_acg_del_lun(acg_dev->acg, acg_dev->lun, true);
+	}
+
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+
+	scst_dev_sysfs_del(dev);
+
+	PRINT_INFO("Detached from virtual device %s (id %d)",
+		dev->virt_name, dev->virt_id);
+
+	scst_free_device(dev);
+
+out:
+	return;
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+	goto out;
+}
+EXPORT_SYMBOL_GPL(scst_unregister_virtual_device);
+
+/**
+ * __scst_register_dev_driver() - register pass-through dev handler driver
+ * @dev_type:	dev handler template
+ * @version:	SCST_INTERFACE_VERSION version string to ensure that
+ *		SCST core and the dev handler use the same version of
+ *		the SCST interface
+ *
+ * Description:
+ *    Registers a pass-through dev handler driver. Returns 0 on success
+ *    or appropriate error code otherwise.
+ */
+int __scst_register_dev_driver(struct scst_dev_type *dev_type,
+	const char *version)
+{
+	int res, exist;
+	struct scst_dev_type *dt;
+
+	if (strcmp(version, SCST_INTERFACE_VERSION) != 0) {
+		PRINT_ERROR("Incorrect version of dev handler %s",
+			dev_type->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	res = scst_dev_handler_check(dev_type);
+	if (res != 0)
+		goto out;
+
+	if (mutex_lock_interruptible(&scst_mutex) != 0) {
+		res = -EINTR;
+		goto out;
+	}
+
+	exist = 0;
+	list_for_each_entry(dt, &scst_dev_type_list, dev_type_list_entry) {
+		if (strcmp(dt->name, dev_type->name) == 0) {
+			PRINT_ERROR("Device type handler \"%s\" already "
+				"exist", dt->name);
+			exist = 1;
+			break;
+		}
+	}
+	if (exist)
+		goto out_unlock;
+
+	list_add_tail(&dev_type->dev_type_list_entry, &scst_dev_type_list);
+
+	mutex_unlock(&scst_mutex);
+
+	res = scst_devt_sysfs_create(dev_type);
+	if (res < 0)
+		goto out;
+
+	PRINT_INFO("Device handler \"%s\" for type %d registered "
+		"successfully", dev_type->name, dev_type->type);
+
+out:
+	return res;
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	goto out;
+}
+EXPORT_SYMBOL_GPL(__scst_register_dev_driver);
+
+/**
+ * scst_unregister_dev_driver() - unregister pass-through dev handler driver
+ */
+void scst_unregister_dev_driver(struct scst_dev_type *dev_type)
+{
+	struct scst_device *dev;
+	struct scst_dev_type *dt;
+	int found = 0;
+
+	scst_suspend_activity(false);
+	mutex_lock(&scst_mutex);
+
+	list_for_each_entry(dt, &scst_dev_type_list, dev_type_list_entry) {
+		if (strcmp(dt->name, dev_type->name) == 0) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		PRINT_ERROR("Dev handler \"%s\" isn't registered",
+			dev_type->name);
+		goto out_up;
+	}
+
+	list_for_each_entry(dev, &scst_dev_list, dev_list_entry) {
+		if (dev->handler == dev_type) {
+			scst_assign_dev_handler(dev, &scst_null_devtype);
+			TRACE_DBG("Dev handler removed from device %p", dev);
+		}
+	}
+
+	list_del(&dev_type->dev_type_list_entry);
+
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+
+	scst_devt_sysfs_del(dev_type);
+
+	PRINT_INFO("Device handler \"%s\" for type %d unloaded",
+		   dev_type->name, dev_type->type);
+
+out:
+	return;
+
+out_up:
+	mutex_unlock(&scst_mutex);
+	scst_resume_activity();
+	goto out;
+}
+EXPORT_SYMBOL_GPL(scst_unregister_dev_driver);
+
+/**
+ * __scst_register_virtual_dev_driver() - register virtual dev handler driver
+ * @dev_type:	dev handler template
+ * @version:	SCST_INTERFACE_VERSION version string to ensure that
+ *		SCST core and the dev handler use the same version of
+ *		the SCST interface
+ *
+ * Description:
+ *    Registers a virtual dev handler driver. Returns 0 on success or
+ *    appropriate error code otherwise.
+ */
+int __scst_register_virtual_dev_driver(struct scst_dev_type *dev_type,
+	const char *version)
+{
+	int res;
+
+	if (strcmp(version, SCST_INTERFACE_VERSION) != 0) {
+		PRINT_ERROR("Incorrect version of virtual dev handler %s",
+			dev_type->name);
+		res = -EINVAL;
+		goto out;
+	}
+
+	res = scst_dev_handler_check(dev_type);
+	if (res != 0)
+		goto out;
+
+	mutex_lock(&scst_mutex);
+	list_add_tail(&dev_type->dev_type_list_entry, &scst_virtual_dev_type_list);
+	mutex_unlock(&scst_mutex);
+
+	res = scst_devt_sysfs_create(dev_type);
+	if (res < 0)
+		goto out;
+
+	if (dev_type->type != -1) {
+		PRINT_INFO("Virtual device handler %s for type %d "
+			"registered successfully", dev_type->name,
+			dev_type->type);
+	} else {
+		PRINT_INFO("Virtual device handler \"%s\" registered "
+			"successfully", dev_type->name);
+	}
+
+out:
+	return res;
+}
+EXPORT_SYMBOL_GPL(__scst_register_virtual_dev_driver);
+
+/**
+ * scst_unregister_virtual_dev_driver() - unregister virtual dev driver
+ */
+void scst_unregister_virtual_dev_driver(struct scst_dev_type *dev_type)
+{
+
+	mutex_lock(&scst_mutex);
+
+	/* Disable sysfs mgmt calls (e.g. addition of new devices) */
+	list_del(&dev_type->dev_type_list_entry);
+
+	/* Wait for outstanding sysfs mgmt calls completed */
+	while (dev_type->devt_active_sysfs_works_count > 0) {
+		mutex_unlock(&scst_mutex);
+		msleep(100);
+		mutex_lock(&scst_mutex);
+	}
+
+	mutex_unlock(&scst_mutex);
+
+	scst_devt_sysfs_del(dev_type);
+
+	PRINT_INFO("Device handler \"%s\" unloaded", dev_type->name);
+	return;
+}
+EXPORT_SYMBOL_GPL(scst_unregister_virtual_dev_driver);
+
+/* scst_mutex supposed to be held */
+int scst_add_threads(struct scst_cmd_threads *cmd_threads,
+	struct scst_device *dev, struct scst_tgt_dev *tgt_dev, int num)
+{
+	int res = 0, i;
+	struct scst_cmd_thread_t *thr;
+	int n = 0, tgt_dev_num = 0;
+
+	if (num == 0) {
+		res = 0;
+		goto out;
+	}
+
+	list_for_each_entry(thr, &cmd_threads->threads_list, thread_list_entry) {
+		n++;
+	}
+
+	TRACE_DBG("cmd_threads %p, dev %p, tgt_dev %p, num %d, n %d",
+		cmd_threads, dev, tgt_dev, num, n);
+
+	if (tgt_dev != NULL) {
+		struct scst_tgt_dev *t;
+		list_for_each_entry(t, &tgt_dev->dev->dev_tgt_dev_list,
+				dev_tgt_dev_list_entry) {
+			if (t == tgt_dev)
+				break;
+			tgt_dev_num++;
+		}
+	}
+
+	for (i = 0; i < num; i++) {
+		thr = kmalloc(sizeof(*thr), GFP_KERNEL);
+		if (!thr) {
+			res = -ENOMEM;
+			PRINT_ERROR("Fail to allocate thr %d", res);
+			goto out_wait;
+		}
+
+		if (dev != NULL) {
+			char nm[14]; /* to limit the name's len */
+			strlcpy(nm, dev->virt_name, ARRAY_SIZE(nm));
+			thr->cmd_thread = kthread_create(scst_cmd_thread,
+				cmd_threads, "%s%d", nm, n++);
+		} else if (tgt_dev != NULL) {
+			char nm[11]; /* to limit the name's len */
+			int rc;
+			strlcpy(nm, tgt_dev->dev->virt_name, ARRAY_SIZE(nm));
+			thr->cmd_thread = kthread_create(scst_cmd_thread,
+				cmd_threads, "%s%d_%d", nm, tgt_dev_num, n++);
+			rc = set_cpus_allowed_ptr(thr->cmd_thread,
+				&tgt_dev->sess->acg->acg_cpu_mask);
+			if (rc != 0)
+				PRINT_ERROR("Setting CPU affinity failed: "
+					"%d", rc);
+		} else
+			thr->cmd_thread = kthread_create(scst_cmd_thread,
+				cmd_threads, "scstd%d", n++);
+
+		if (IS_ERR(thr->cmd_thread)) {
+			res = PTR_ERR(thr->cmd_thread);
+			PRINT_ERROR("kthread_create() failed: %d", res);
+			kfree(thr);
+			goto out_wait;
+		}
+
+		list_add(&thr->thread_list_entry, &cmd_threads->threads_list);
+		cmd_threads->nr_threads++;
+
+		TRACE_DBG("Added thr %p to threads list (nr_threads %d, n %d)",
+			thr, cmd_threads->nr_threads, n);
+
+		wake_up_process(thr->cmd_thread);
+	}
+
+out_wait:
+	if (cmd_threads != &scst_main_cmd_threads) {
+		/*
+		 * Wait for io_context gets initialized to avoid possible races
+		 * for it from the sharing it tgt_devs.
+		 */
+		while (!*(volatile bool*)&cmd_threads->io_context_ready) {
+			TRACE_DBG("Waiting for io_context for cmd_threads %p "
+				"initialized", cmd_threads);
+			msleep(50);
+		}
+	}
+
+	if (res != 0)
+		scst_del_threads(cmd_threads, i);
+
+out:
+	return res;
+}
+
+/* scst_mutex supposed to be held */
+void scst_del_threads(struct scst_cmd_threads *cmd_threads, int num)
+{
+	struct scst_cmd_thread_t *ct, *tmp;
+
+	if (num == 0)
+		goto out;
+
+	list_for_each_entry_safe_reverse(ct, tmp, &cmd_threads->threads_list,
+				thread_list_entry) {
+		int rc;
+		struct scst_device *dev;
+
+		rc = kthread_stop(ct->cmd_thread);
+		if (rc < 0)
+			TRACE_MGMT_DBG("kthread_stop() failed: %d", rc);
+
+		list_del(&ct->thread_list_entry);
+
+		list_for_each_entry(dev, &scst_dev_list, dev_list_entry) {
+			struct scst_tgt_dev *tgt_dev;
+			list_for_each_entry(tgt_dev, &dev->dev_tgt_dev_list,
+					dev_tgt_dev_list_entry) {
+				scst_del_thr_data(tgt_dev, ct->cmd_thread);
+			}
+		}
+
+		kfree(ct);
+
+		cmd_threads->nr_threads--;
+
+		--num;
+		if (num == 0)
+			break;
+	}
+
+	EXTRACHECKS_BUG_ON((cmd_threads->nr_threads == 0) &&
+		(cmd_threads->io_context != NULL));
+
+out:
+	return;
+}
+
+/* The activity supposed to be suspended and scst_mutex held */
+void scst_stop_dev_threads(struct scst_device *dev)
+{
+	struct scst_tgt_dev *tgt_dev;
+
+	list_for_each_entry(tgt_dev, &dev->dev_tgt_dev_list,
+				dev_tgt_dev_list_entry) {
+		scst_tgt_dev_stop_threads(tgt_dev);
+	}
+
+	if ((dev->threads_num > 0) &&
+	    (dev->threads_pool_type == SCST_THREADS_POOL_SHARED))
+		scst_del_threads(&dev->dev_cmd_threads, -1);
+	return;
+}
+
+/* The activity supposed to be suspended and scst_mutex held */
+int scst_create_dev_threads(struct scst_device *dev)
+{
+	int res = 0;
+	struct scst_tgt_dev *tgt_dev;
+
+	list_for_each_entry(tgt_dev, &dev->dev_tgt_dev_list,
+			dev_tgt_dev_list_entry) {
+		res = scst_tgt_dev_setup_threads(tgt_dev);
+		if (res != 0)
+			goto out_err;
+	}
+
+	if ((dev->threads_num > 0) &&
+	    (dev->threads_pool_type == SCST_THREADS_POOL_SHARED)) {
+		res = scst_add_threads(&dev->dev_cmd_threads, dev, NULL,
+			dev->threads_num);
+		if (res != 0)
+			goto out_err;
+	}
+
+out:
+	return res;
+
+out_err:
+	scst_stop_dev_threads(dev);
+	goto out;
+}
+
+/* The activity supposed to be suspended and scst_mutex held */
+int scst_assign_dev_handler(struct scst_device *dev,
+	struct scst_dev_type *handler)
+{
+	int res = 0;
+	struct scst_tgt_dev *tgt_dev;
+	LIST_HEAD(attached_tgt_devs);
+
+	BUG_ON(handler == NULL);
+
+	if (dev->handler == handler)
+		goto out;
+
+	if (dev->handler == NULL)
+		goto assign;
+
+	if (dev->handler->detach_tgt) {
+		list_for_each_entry(tgt_dev, &dev->dev_tgt_dev_list,
+				dev_tgt_dev_list_entry) {
+			TRACE_DBG("Calling dev handler's detach_tgt(%p)",
+				tgt_dev);
+			dev->handler->detach_tgt(tgt_dev);
+			TRACE_DBG("%s", "Dev handler's detach_tgt() returned");
+		}
+	}
+
+	/*
+	 * devt_dev sysfs must be created AFTER attach() and deleted BEFORE
+	 * detach() to avoid calls from sysfs for not yet ready or already dead
+	 * objects.
+	 */
+	scst_devt_dev_sysfs_del(dev);
+
+	if (dev->handler->detach) {
+		TRACE_DBG("%s", "Calling dev handler's detach()");
+		dev->handler->detach(dev);
+		TRACE_DBG("%s", "Old handler's detach() returned");
+	}
+
+	scst_stop_dev_threads(dev);
+
+assign:
+	dev->handler = handler;
+
+	if (handler == NULL)
+		goto out;
+
+	dev->threads_num = handler->threads_num;
+	dev->threads_pool_type = handler->threads_pool_type;
+
+	if (handler->attach) {
+		TRACE_DBG("Calling new dev handler's attach(%p)", dev);
+		res = handler->attach(dev);
+		TRACE_DBG("New dev handler's attach() returned %d", res);
+		if (res != 0) {
+			PRINT_ERROR("New device handler's %s attach() "
+				"failed: %d", handler->name, res);
+			goto out;
+		}
+	}
+
+	res = scst_devt_dev_sysfs_create(dev);
+	if (res != 0)
+		goto out_detach;
+
+	if (handler->attach_tgt) {
+		list_for_each_entry(tgt_dev, &dev->dev_tgt_dev_list,
+				dev_tgt_dev_list_entry) {
+			TRACE_DBG("Calling dev handler's attach_tgt(%p)",
+				tgt_dev);
+			res = handler->attach_tgt(tgt_dev);
+			TRACE_DBG("%s", "Dev handler's attach_tgt() returned");
+			if (res != 0) {
+				PRINT_ERROR("Device handler's %s attach_tgt() "
+				    "failed: %d", handler->name, res);
+				goto out_err_remove_sysfs;
+			}
+			list_add_tail(&tgt_dev->extra_tgt_dev_list_entry,
+				&attached_tgt_devs);
+		}
+	}
+
+	res = scst_create_dev_threads(dev);
+	if (res != 0)
+		goto out_err_detach_tgt;
+
+out:
+	return res;
+
+out_err_detach_tgt:
+	if (handler && handler->detach_tgt) {
+		list_for_each_entry(tgt_dev, &attached_tgt_devs,
+				 extra_tgt_dev_list_entry) {
+			TRACE_DBG("Calling handler's detach_tgt(%p)",
+				tgt_dev);
+			handler->detach_tgt(tgt_dev);
+			TRACE_DBG("%s", "Handler's detach_tgt() returned");
+		}
+	}
+
+out_err_remove_sysfs:
+	scst_devt_dev_sysfs_del(dev);
+
+out_detach:
+	if (handler && handler->detach) {
+		TRACE_DBG("%s", "Calling handler's detach()");
+		handler->detach(dev);
+		TRACE_DBG("%s", "Handler's detach() returned");
+	}
+
+	dev->handler = &scst_null_devtype;
+	dev->threads_num = scst_null_devtype.threads_num;
+	dev->threads_pool_type = scst_null_devtype.threads_pool_type;
+	goto out;
+}
+
+/**
+ * scst_init_threads() - initialize SCST processing threads pool
+ *
+ * Initializes scst_cmd_threads structure
+ */
+void scst_init_threads(struct scst_cmd_threads *cmd_threads)
+{
+
+	spin_lock_init(&cmd_threads->cmd_list_lock);
+	INIT_LIST_HEAD(&cmd_threads->active_cmd_list);
+	init_waitqueue_head(&cmd_threads->cmd_list_waitQ);
+	INIT_LIST_HEAD(&cmd_threads->threads_list);
+
+	mutex_lock(&scst_suspend_mutex);
+	list_add_tail(&cmd_threads->lists_list_entry,
+		&scst_cmd_threads_list);
+	mutex_unlock(&scst_suspend_mutex);
+	return;
+}
+EXPORT_SYMBOL_GPL(scst_init_threads);
+
+/**
+ * scst_deinit_threads() - deinitialize SCST processing threads pool
+ *
+ * Deinitializes scst_cmd_threads structure
+ */
+void scst_deinit_threads(struct scst_cmd_threads *cmd_threads)
+{
+
+	mutex_lock(&scst_suspend_mutex);
+	list_del(&cmd_threads->lists_list_entry);
+	mutex_unlock(&scst_suspend_mutex);
+
+	BUG_ON(cmd_threads->io_context);
+	return;
+}
+EXPORT_SYMBOL_GPL(scst_deinit_threads);
+
+static void scst_stop_global_threads(void)
+{
+
+	mutex_lock(&scst_mutex);
+
+	scst_del_threads(&scst_main_cmd_threads, -1);
+
+	if (scst_mgmt_cmd_thread)
+		kthread_stop(scst_mgmt_cmd_thread);
+	if (scst_mgmt_thread)
+		kthread_stop(scst_mgmt_thread);
+	if (scst_init_cmd_thread)
+		kthread_stop(scst_init_cmd_thread);
+
+	mutex_unlock(&scst_mutex);
+	return;
+}
+
+/* It does NOT stop ran threads on error! */
+static int scst_start_global_threads(int num)
+{
+	int res;
+
+	mutex_lock(&scst_mutex);
+
+	res = scst_add_threads(&scst_main_cmd_threads, NULL, NULL, num);
+	if (res < 0)
+		goto out_unlock;
+
+	scst_init_cmd_thread = kthread_run(scst_init_thread,
+		NULL, "scst_initd");
+	if (IS_ERR(scst_init_cmd_thread)) {
+		res = PTR_ERR(scst_init_cmd_thread);
+		PRINT_ERROR("kthread_create() for init cmd failed: %d", res);
+		scst_init_cmd_thread = NULL;
+		goto out_unlock;
+	}
+
+	scst_mgmt_cmd_thread = kthread_run(scst_tm_thread,
+		NULL, "scsi_tm");
+	if (IS_ERR(scst_mgmt_cmd_thread)) {
+		res = PTR_ERR(scst_mgmt_cmd_thread);
+		PRINT_ERROR("kthread_create() for TM failed: %d", res);
+		scst_mgmt_cmd_thread = NULL;
+		goto out_unlock;
+	}
+
+	scst_mgmt_thread = kthread_run(scst_global_mgmt_thread,
+		NULL, "scst_mgmtd");
+	if (IS_ERR(scst_mgmt_thread)) {
+		res = PTR_ERR(scst_mgmt_thread);
+		PRINT_ERROR("kthread_create() for mgmt failed: %d", res);
+		scst_mgmt_thread = NULL;
+		goto out_unlock;
+	}
+
+out_unlock:
+	mutex_unlock(&scst_mutex);
+	return res;
+}
+
+/**
+ * scst_get() - increase global SCST ref counter
+ *
+ * Increases global SCST ref counter that prevents from entering into suspended
+ * activities stage, so protects from any global management operations.
+ */
+void scst_get(void)
+{
+	__scst_get(0);
+}
+EXPORT_SYMBOL(scst_get);
+
+/**
+ * scst_put() - decrease global SCST ref counter
+ *
+ * Decreses global SCST ref counter that prevents from entering into suspended
+ * activities stage, so protects from any global management operations. On
+ * zero, if suspending activities is waiting, they will be suspended.
+ */
+void scst_put(void)
+{
+	__scst_put();
+}
+EXPORT_SYMBOL(scst_put);
+
+/**
+ * scst_get_setup_id() - return SCST setup ID
+ *
+ * Returns SCST setup ID. This ID can be used for multiple
+ * setups with the same configuration.
+ */
+unsigned int scst_get_setup_id(void)
+{
+	return scst_setup_id;
+}
+EXPORT_SYMBOL_GPL(scst_get_setup_id);
+
+static int scst_add(struct device *cdev, struct class_interface *intf)
+{
+	struct scsi_device *scsidp;
+	int res = 0;
+
+	scsidp = to_scsi_device(cdev->parent);
+
+	if ((scsidp->host->hostt->name == NULL) ||
+	    (strcmp(scsidp->host->hostt->name, SCST_LOCAL_NAME) != 0))
+		res = scst_register_device(scsidp);
+	return res;
+}
+
+static void scst_remove(struct device *cdev, struct class_interface *intf)
+{
+	struct scsi_device *scsidp;
+
+	scsidp = to_scsi_device(cdev->parent);
+
+	if ((scsidp->host->hostt->name == NULL) ||
+	    (strcmp(scsidp->host->hostt->name, SCST_LOCAL_NAME) != 0))
+		scst_unregister_device(scsidp);
+	return;
+}
+
+static struct class_interface scst_interface = {
+	.add_dev = scst_add,
+	.remove_dev = scst_remove,
+};
+
+static void __init scst_print_config(void)
+{
+	char buf[128];
+	int i, j;
+
+	i = snprintf(buf, sizeof(buf), "Enabled features: ");
+	j = i;
+
+#ifdef CONFIG_SCST_STRICT_SERIALIZING
+	i += snprintf(&buf[i], sizeof(buf) - i, "STRICT_SERIALIZING");
+#endif
+
+#ifdef CONFIG_SCST_EXTRACHECKS
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sEXTRACHECKS",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_TRACING
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sTRACING",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sDEBUG",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG_TM
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sDEBUG_TM",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG_RETRY
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sDEBUG_RETRY",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG_OOM
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sDEBUG_OOM",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_DEBUG_SN
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sDEBUG_SN",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_USE_EXPECTED_VALUES
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sUSE_EXPECTED_VALUES",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_TEST_IO_IN_SIRQ
+	i += snprintf(&buf[i], sizeof(buf) - i,
+		"%sTEST_IO_IN_SIRQ",
+		(j == i) ? "" : ", ");
+#endif
+
+#ifdef CONFIG_SCST_STRICT_SECURITY
+	i += snprintf(&buf[i], sizeof(buf) - i, "%sSTRICT_SECURITY",
+		(j == i) ? "" : ", ");
+#endif
+
+	if (j != i)
+		PRINT_INFO("%s", buf);
+}
+
+static int __init init_scst(void)
+{
+	int res, i;
+	int scst_num_cpus;
+
+	{
+		struct scsi_sense_hdr *shdr;
+		BUILD_BUG_ON(SCST_SENSE_BUFFERSIZE < sizeof(*shdr));
+	}
+	{
+		struct scst_tgt_dev *t;
+		struct scst_cmd *c;
+		BUILD_BUG_ON(sizeof(t->curr_sn) != sizeof(t->expected_sn));
+		BUILD_BUG_ON(sizeof(c->sn) != sizeof(t->expected_sn));
+	}
+
+	mutex_init(&scst_mutex);
+	mutex_init(&scst_mutex2);
+	INIT_LIST_HEAD(&scst_template_list);
+	INIT_LIST_HEAD(&scst_dev_list);
+	INIT_LIST_HEAD(&scst_dev_type_list);
+	INIT_LIST_HEAD(&scst_virtual_dev_type_list);
+	spin_lock_init(&scst_main_lock);
+	spin_lock_init(&scst_init_lock);
+	init_waitqueue_head(&scst_init_cmd_list_waitQ);
+	INIT_LIST_HEAD(&scst_init_cmd_list);
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	scst_trace_flag = SCST_DEFAULT_LOG_FLAGS;
+#endif
+	atomic_set(&scst_cmd_count, 0);
+	spin_lock_init(&scst_mcmd_lock);
+	INIT_LIST_HEAD(&scst_active_mgmt_cmd_list);
+	INIT_LIST_HEAD(&scst_delayed_mgmt_cmd_list);
+	init_waitqueue_head(&scst_mgmt_cmd_list_waitQ);
+	init_waitqueue_head(&scst_mgmt_waitQ);
+	spin_lock_init(&scst_mgmt_lock);
+	INIT_LIST_HEAD(&scst_sess_init_list);
+	INIT_LIST_HEAD(&scst_sess_shut_list);
+	init_waitqueue_head(&scst_dev_cmd_waitQ);
+	mutex_init(&scst_suspend_mutex);
+	INIT_LIST_HEAD(&scst_cmd_threads_list);
+	cpus_setall(default_cpu_mask);
+
+	scst_init_threads(&scst_main_cmd_threads);
+
+	res = scst_lib_init();
+	if (res != 0)
+		goto out_deinit_threads;
+
+	scst_num_cpus = num_online_cpus();
+
+	/* ToDo: register_cpu_notifier() */
+
+	if (scst_threads == 0)
+		scst_threads = scst_num_cpus;
+
+	if (scst_threads < 1) {
+		PRINT_ERROR("%s", "scst_threads can not be less than 1");
+		scst_threads = scst_num_cpus;
+	}
+
+#define INIT_CACHEP(p, s, o) do {					\
+		p = KMEM_CACHE(s, SCST_SLAB_FLAGS);			\
+		TRACE_MEM("Slab create: %s at %p size %zd", #s, p,	\
+			  sizeof(struct s));				\
+		if (p == NULL) {					\
+			res = -ENOMEM;					\
+			goto o;						\
+		}							\
+	} while (0)
+
+	INIT_CACHEP(scst_mgmt_cachep, scst_mgmt_cmd, out_lib_exit);
+	INIT_CACHEP(scst_mgmt_stub_cachep, scst_mgmt_cmd_stub,
+			out_destroy_mgmt_cache);
+	INIT_CACHEP(scst_ua_cachep, scst_tgt_dev_UA,
+			out_destroy_mgmt_stub_cache);
+	{
+		struct scst_sense { uint8_t s[SCST_SENSE_BUFFERSIZE]; };
+		INIT_CACHEP(scst_sense_cachep, scst_sense,
+			    out_destroy_ua_cache);
+	}
+	INIT_CACHEP(scst_aen_cachep, scst_aen, out_destroy_sense_cache);
+	INIT_CACHEP(scst_cmd_cachep, scst_cmd, out_destroy_aen_cache);
+	INIT_CACHEP(scst_sess_cachep, scst_session, out_destroy_cmd_cache);
+	INIT_CACHEP(scst_tgtd_cachep, scst_tgt_dev, out_destroy_sess_cache);
+	INIT_CACHEP(scst_acgd_cachep, scst_acg_dev, out_destroy_tgt_cache);
+
+	scst_mgmt_mempool = mempool_create(64, mempool_alloc_slab,
+		mempool_free_slab, scst_mgmt_cachep);
+	if (scst_mgmt_mempool == NULL) {
+		res = -ENOMEM;
+		goto out_destroy_acg_cache;
+	}
+
+	/*
+	 * All mgmt stubs, UAs and sense buffers are bursty and loosing them
+	 * may have fatal consequences, so let's have big pools for them.
+	 */
+
+	scst_mgmt_stub_mempool = mempool_create(1024, mempool_alloc_slab,
+		mempool_free_slab, scst_mgmt_stub_cachep);
+	if (scst_mgmt_stub_mempool == NULL) {
+		res = -ENOMEM;
+		goto out_destroy_mgmt_mempool;
+	}
+
+	scst_ua_mempool = mempool_create(512, mempool_alloc_slab,
+		mempool_free_slab, scst_ua_cachep);
+	if (scst_ua_mempool == NULL) {
+		res = -ENOMEM;
+		goto out_destroy_mgmt_stub_mempool;
+	}
+
+	scst_sense_mempool = mempool_create(1024, mempool_alloc_slab,
+		mempool_free_slab, scst_sense_cachep);
+	if (scst_sense_mempool == NULL) {
+		res = -ENOMEM;
+		goto out_destroy_ua_mempool;
+	}
+
+	scst_aen_mempool = mempool_create(100, mempool_alloc_slab,
+		mempool_free_slab, scst_aen_cachep);
+	if (scst_aen_mempool == NULL) {
+		res = -ENOMEM;
+		goto out_destroy_sense_mempool;
+	}
+
+	res = scst_sysfs_init();
+	if (res != 0)
+		goto out_destroy_aen_mempool;
+
+	if (scst_max_cmd_mem == 0) {
+		struct sysinfo si;
+		si_meminfo(&si);
+#if BITS_PER_LONG == 32
+		scst_max_cmd_mem = min(
+			(((uint64_t)(si.totalram - si.totalhigh) << PAGE_SHIFT)
+				>> 20) >> 2, (uint64_t)1 << 30);
+#else
+		scst_max_cmd_mem = (((si.totalram - si.totalhigh) << PAGE_SHIFT)
+					>> 20) >> 2;
+#endif
+	}
+
+	if (scst_max_dev_cmd_mem != 0) {
+		if (scst_max_dev_cmd_mem > scst_max_cmd_mem) {
+			PRINT_ERROR("scst_max_dev_cmd_mem (%d) > "
+				"scst_max_cmd_mem (%d)",
+				scst_max_dev_cmd_mem,
+				scst_max_cmd_mem);
+			scst_max_dev_cmd_mem = scst_max_cmd_mem;
+		}
+	} else
+		scst_max_dev_cmd_mem = scst_max_cmd_mem * 2 / 5;
+
+	res = scst_sgv_pools_init(
+		((uint64_t)scst_max_cmd_mem << 10) >> (PAGE_SHIFT - 10), 0);
+	if (res != 0)
+		goto out_sysfs_cleanup;
+
+	res = scsi_register_interface(&scst_interface);
+	if (res != 0)
+		goto out_destroy_sgv_pool;
+
+	for (i = 0; i < (int)ARRAY_SIZE(scst_tasklets); i++) {
+		spin_lock_init(&scst_tasklets[i].tasklet_lock);
+		INIT_LIST_HEAD(&scst_tasklets[i].tasklet_cmd_list);
+		tasklet_init(&scst_tasklets[i].tasklet,
+			     (void *)scst_cmd_tasklet,
+			     (unsigned long)&scst_tasklets[i]);
+	}
+
+	TRACE_DBG("%d CPUs found, starting %d threads", scst_num_cpus,
+		scst_threads);
+
+	res = scst_start_global_threads(scst_threads);
+	if (res < 0)
+		goto out_thread_free;
+
+	res = scst_pr_check_pr_path();
+	if (res != 0)
+		goto out_thread_free;
+
+	PRINT_INFO("SCST version %s loaded successfully (max mem for "
+		"commands %dMB, per device %dMB)", SCST_VERSION_STRING,
+		scst_max_cmd_mem, scst_max_dev_cmd_mem);
+
+	scst_print_config();
+
+out:
+	return res;
+
+out_thread_free:
+	scst_stop_global_threads();
+
+	scsi_unregister_interface(&scst_interface);
+
+out_destroy_sgv_pool:
+	scst_sgv_pools_deinit();
+
+out_sysfs_cleanup:
+	scst_sysfs_cleanup();
+
+out_destroy_aen_mempool:
+	mempool_destroy(scst_aen_mempool);
+
+out_destroy_sense_mempool:
+	mempool_destroy(scst_sense_mempool);
+
+out_destroy_ua_mempool:
+	mempool_destroy(scst_ua_mempool);
+
+out_destroy_mgmt_stub_mempool:
+	mempool_destroy(scst_mgmt_stub_mempool);
+
+out_destroy_mgmt_mempool:
+	mempool_destroy(scst_mgmt_mempool);
+
+out_destroy_acg_cache:
+	kmem_cache_destroy(scst_acgd_cachep);
+
+out_destroy_tgt_cache:
+	kmem_cache_destroy(scst_tgtd_cachep);
+
+out_destroy_sess_cache:
+	kmem_cache_destroy(scst_sess_cachep);
+
+out_destroy_cmd_cache:
+	kmem_cache_destroy(scst_cmd_cachep);
+
+out_destroy_aen_cache:
+	kmem_cache_destroy(scst_aen_cachep);
+
+out_destroy_sense_cache:
+	kmem_cache_destroy(scst_sense_cachep);
+
+out_destroy_ua_cache:
+	kmem_cache_destroy(scst_ua_cachep);
+
+out_destroy_mgmt_stub_cache:
+	kmem_cache_destroy(scst_mgmt_stub_cachep);
+
+out_destroy_mgmt_cache:
+	kmem_cache_destroy(scst_mgmt_cachep);
+
+out_lib_exit:
+	scst_lib_exit();
+
+out_deinit_threads:
+	scst_deinit_threads(&scst_main_cmd_threads);
+	goto out;
+}
+
+static void __exit exit_scst(void)
+{
+
+	/* ToDo: unregister_cpu_notifier() */
+
+	scst_stop_global_threads();
+
+	scst_deinit_threads(&scst_main_cmd_threads);
+
+	scsi_unregister_interface(&scst_interface);
+
+	scst_sgv_pools_deinit();
+
+	scst_sysfs_cleanup();
+
+#define DEINIT_CACHEP(p) do {		\
+		kmem_cache_destroy(p);	\
+		p = NULL;		\
+	} while (0)
+
+	mempool_destroy(scst_mgmt_mempool);
+	mempool_destroy(scst_mgmt_stub_mempool);
+	mempool_destroy(scst_ua_mempool);
+	mempool_destroy(scst_sense_mempool);
+	mempool_destroy(scst_aen_mempool);
+
+	DEINIT_CACHEP(scst_mgmt_cachep);
+	DEINIT_CACHEP(scst_mgmt_stub_cachep);
+	DEINIT_CACHEP(scst_ua_cachep);
+	DEINIT_CACHEP(scst_sense_cachep);
+	DEINIT_CACHEP(scst_aen_cachep);
+	DEINIT_CACHEP(scst_cmd_cachep);
+	DEINIT_CACHEP(scst_sess_cachep);
+	DEINIT_CACHEP(scst_tgtd_cachep);
+	DEINIT_CACHEP(scst_acgd_cachep);
+
+	scst_lib_exit();
+
+	PRINT_INFO("%s", "SCST unloaded");
+	return;
+}
+
+module_init(init_scst);
+module_exit(exit_scst);
+
+MODULE_AUTHOR("Vladislav Bolkhovitin");
+MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("SCSI target core");
+MODULE_VERSION(SCST_VERSION_STRING);
diff -uprN orig/linux-2.6.35/drivers/scst/scst_module.c linux-2.6.35/drivers/scst/scst_module.c
--- orig/linux-2.6.35/drivers/scst/scst_module.c
+++ linux-2.6.35/drivers/scst/scst_module.c
@@ -0,0 +1,63 @@
+/*
+ *  scst_module.c
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  Support for loading target modules. The usage is similar to scsi_module.c
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/init.h>
+
+#include <scst.h>
+
+static int __init init_this_scst_driver(void)
+{
+	int res;
+
+	res = scst_register_target_template(&driver_target_template);
+	TRACE_DBG("scst_register_target_template() returned %d", res);
+	if (res < 0)
+		goto out;
+
+#ifdef SCST_REGISTER_INITIATOR_DRIVER
+	driver_template.module = THIS_MODULE;
+	scsi_register_module(MODULE_SCSI_HA, &driver_template);
+	TRACE_DBG("driver_template.present=%d",
+	      driver_template.present);
+	if (driver_template.present == 0) {
+		res = -ENODEV;
+		MOD_DEC_USE_COUNT;
+		goto out;
+	}
+#endif
+
+out:
+	return res;
+}
+
+static void __exit exit_this_scst_driver(void)
+{
+
+#ifdef SCST_REGISTER_INITIATOR_DRIVER
+	scsi_unregister_module(MODULE_SCSI_HA, &driver_template);
+#endif
+
+	scst_unregister_target_template(&driver_target_template);
+	return;
+}
+
+module_init(init_this_scst_driver);
+module_exit(exit_this_scst_driver);
diff -uprN orig/linux-2.6.35/drivers/scst/scst_priv.h linux-2.6.35/drivers/scst/scst_priv.h
--- orig/linux-2.6.35/drivers/scst/scst_priv.h
+++ linux-2.6.35/drivers/scst/scst_priv.h
@@ -0,0 +1,606 @@
+/*
+ *  scst_priv.h
+ *
+ *  Copyright (C) 2004 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *  Copyright (C) 2004 - 2005 Leonid Stoljar
+ *  Copyright (C) 2007 - 2010 ID7 Ltd.
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#ifndef __SCST_PRIV_H
+#define __SCST_PRIV_H
+
+#include <linux/types.h>
+
+#include <scsi/scsi.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/scsi_driver.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_host.h>
+
+#define LOG_PREFIX "scst"
+
+#include <scst/scst_debug.h>
+
+#define TRACE_RTRY              0x80000000
+#define TRACE_SCSI_SERIALIZING  0x40000000
+/** top being the edge away from the interupt */
+#define TRACE_SND_TOP		0x20000000
+#define TRACE_RCV_TOP		0x01000000
+/** bottom being the edge toward the interupt */
+#define TRACE_SND_BOT		0x08000000
+#define TRACE_RCV_BOT		0x04000000
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+#define trace_flag scst_trace_flag
+extern unsigned long scst_trace_flag;
+#endif
+
+#ifdef CONFIG_SCST_DEBUG
+
+#define SCST_DEFAULT_LOG_FLAGS (TRACE_OUT_OF_MEM | TRACE_MINOR | TRACE_PID | \
+	TRACE_LINE | TRACE_FUNCTION | TRACE_SPECIAL | TRACE_MGMT | \
+	TRACE_MGMT_DEBUG | TRACE_RTRY)
+
+#define TRACE_RETRY(args...)	TRACE_DBG_FLAG(TRACE_RTRY, args)
+#define TRACE_SN(args...)	TRACE_DBG_FLAG(TRACE_SCSI_SERIALIZING, args)
+#define TRACE_SEND_TOP(args...)	TRACE_DBG_FLAG(TRACE_SND_TOP, args)
+#define TRACE_RECV_TOP(args...)	TRACE_DBG_FLAG(TRACE_RCV_TOP, args)
+#define TRACE_SEND_BOT(args...)	TRACE_DBG_FLAG(TRACE_SND_BOT, args)
+#define TRACE_RECV_BOT(args...)	TRACE_DBG_FLAG(TRACE_RCV_BOT, args)
+
+#else /* CONFIG_SCST_DEBUG */
+
+# ifdef CONFIG_SCST_TRACING
+#define SCST_DEFAULT_LOG_FLAGS (TRACE_OUT_OF_MEM | TRACE_MGMT | \
+	TRACE_SPECIAL)
+# else
+#define SCST_DEFAULT_LOG_FLAGS 0
+# endif
+
+#define TRACE_RETRY(args...)
+#define TRACE_SN(args...)
+#define TRACE_SEND_TOP(args...)
+#define TRACE_RECV_TOP(args...)
+#define TRACE_SEND_BOT(args...)
+#define TRACE_RECV_BOT(args...)
+
+#endif
+
+/**
+ ** Bits for scst_flags
+ **/
+
+/*
+ * Set if new commands initialization is being suspended for a while.
+ * Used to let TM commands execute while preparing the suspend, since
+ * RESET or ABORT could be necessary to free SCSI commands.
+ */
+#define SCST_FLAG_SUSPENDING		     0
+
+/* Set if new commands initialization is suspended for a while */
+#define SCST_FLAG_SUSPENDED		     1
+
+/**
+ ** Return codes for cmd state process functions. Codes are the same as
+ ** for SCST_EXEC_* to avoid translation to them and, hence, have better code.
+ **/
+#define SCST_CMD_STATE_RES_CONT_NEXT         SCST_EXEC_COMPLETED
+#define SCST_CMD_STATE_RES_CONT_SAME         SCST_EXEC_NOT_COMPLETED
+#define SCST_CMD_STATE_RES_NEED_THREAD       (SCST_EXEC_NOT_COMPLETED+1)
+
+/**
+ ** Maximum count of uncompleted commands that an initiator could
+ ** queue on any device. Then it will start getting TASK QUEUE FULL status.
+ **/
+#define SCST_MAX_TGT_DEV_COMMANDS            48
+
+/**
+ ** Maximum count of uncompleted commands that could be queued on any device.
+ ** Then initiators sending commands to this device will start getting
+ ** TASK QUEUE FULL status.
+ **/
+#define SCST_MAX_DEV_COMMANDS                256
+
+#define SCST_TGT_RETRY_TIMEOUT               (3/2*HZ)
+
+/* Definitions of symbolic constants for LUN addressing method */
+#define SCST_LUN_ADDR_METHOD_PERIPHERAL	0
+#define SCST_LUN_ADDR_METHOD_FLAT	1
+
+/* Activities suspending timeout */
+#define SCST_SUSPENDING_TIMEOUT			(90 * HZ)
+
+extern struct mutex scst_mutex2;
+
+extern int scst_threads;
+
+extern unsigned int scst_max_dev_cmd_mem;
+
+extern mempool_t *scst_mgmt_mempool;
+extern mempool_t *scst_mgmt_stub_mempool;
+extern mempool_t *scst_ua_mempool;
+extern mempool_t *scst_sense_mempool;
+extern mempool_t *scst_aen_mempool;
+
+extern struct kmem_cache *scst_cmd_cachep;
+extern struct kmem_cache *scst_sess_cachep;
+extern struct kmem_cache *scst_tgtd_cachep;
+extern struct kmem_cache *scst_acgd_cachep;
+
+extern spinlock_t scst_main_lock;
+
+extern struct scst_sgv_pools scst_sgv;
+
+extern unsigned long scst_flags;
+extern atomic_t scst_cmd_count;
+extern struct list_head scst_template_list;
+extern struct list_head scst_dev_list;
+extern struct list_head scst_dev_type_list;
+extern struct list_head scst_virtual_dev_type_list;
+extern wait_queue_head_t scst_dev_cmd_waitQ;
+
+extern unsigned int scst_setup_id;
+
+extern spinlock_t scst_init_lock;
+extern struct list_head scst_init_cmd_list;
+extern wait_queue_head_t scst_init_cmd_list_waitQ;
+extern unsigned int scst_init_poll_cnt;
+
+extern struct scst_cmd_threads scst_main_cmd_threads;
+
+extern spinlock_t scst_mcmd_lock;
+/* The following lists protected by scst_mcmd_lock */
+extern struct list_head scst_active_mgmt_cmd_list;
+extern struct list_head scst_delayed_mgmt_cmd_list;
+extern wait_queue_head_t scst_mgmt_cmd_list_waitQ;
+
+struct scst_tasklet {
+	spinlock_t tasklet_lock;
+	struct list_head tasklet_cmd_list;
+	struct tasklet_struct tasklet;
+};
+extern struct scst_tasklet scst_tasklets[NR_CPUS];
+
+extern wait_queue_head_t scst_mgmt_waitQ;
+extern spinlock_t scst_mgmt_lock;
+extern struct list_head scst_sess_init_list;
+extern struct list_head scst_sess_shut_list;
+
+extern cpumask_t default_cpu_mask;
+
+struct scst_cmd_thread_t {
+	struct task_struct *cmd_thread;
+	struct list_head thread_list_entry;
+};
+
+static inline bool scst_set_io_context(struct scst_cmd *cmd,
+	struct io_context **old)
+{
+	bool res;
+
+#ifdef CONFIG_SCST_TEST_IO_IN_SIRQ
+	return false;
+#endif
+
+	if (cmd->cmd_threads == &scst_main_cmd_threads) {
+		EXTRACHECKS_BUG_ON(in_interrupt());
+		/*
+		 * No need for any ref counting action, because io_context
+		 * supposed to be cleared in the end of the caller function.
+		 */
+		current->io_context = cmd->tgt_dev->async_io_context;
+		res = true;
+		TRACE_DBG("io_context %p (tgt_dev %p)", current->io_context,
+			cmd->tgt_dev);
+		EXTRACHECKS_BUG_ON(current->io_context == NULL);
+	} else
+		res = false;
+
+	return res;
+}
+
+static inline void scst_reset_io_context(struct scst_tgt_dev *tgt_dev,
+	struct io_context *old)
+{
+	current->io_context = old;
+	TRACE_DBG("io_context %p reset", current->io_context);
+	return;
+}
+
+/*
+ * Converts string presentation of threads pool type to enum.
+ * Returns SCST_THREADS_POOL_TYPE_INVALID if the string is invalid.
+ */
+extern enum scst_dev_type_threads_pool_type scst_parse_threads_pool_type(
+	const char *p, int len);
+
+extern int scst_add_threads(struct scst_cmd_threads *cmd_threads,
+	struct scst_device *dev, struct scst_tgt_dev *tgt_dev, int num);
+extern void scst_del_threads(struct scst_cmd_threads *cmd_threads, int num);
+
+extern int scst_create_dev_threads(struct scst_device *dev);
+extern void scst_stop_dev_threads(struct scst_device *dev);
+
+extern int scst_tgt_dev_setup_threads(struct scst_tgt_dev *tgt_dev);
+extern void scst_tgt_dev_stop_threads(struct scst_tgt_dev *tgt_dev);
+
+extern bool scst_del_thr_data(struct scst_tgt_dev *tgt_dev,
+	struct task_struct *tsk);
+
+extern struct scst_dev_type scst_null_devtype;
+
+extern struct scst_cmd *__scst_check_deferred_commands(
+	struct scst_tgt_dev *tgt_dev);
+
+/* Used to save the function call on the fast path */
+static inline struct scst_cmd *scst_check_deferred_commands(
+	struct scst_tgt_dev *tgt_dev)
+{
+	if (tgt_dev->def_cmd_count == 0)
+		return NULL;
+	else
+		return __scst_check_deferred_commands(tgt_dev);
+}
+
+static inline void scst_make_deferred_commands_active(
+	struct scst_tgt_dev *tgt_dev)
+{
+	struct scst_cmd *c;
+
+	c = __scst_check_deferred_commands(tgt_dev);
+	if (c != NULL) {
+		TRACE_SN("Adding cmd %p to active cmd list", c);
+		spin_lock_irq(&c->cmd_threads->cmd_list_lock);
+		list_add_tail(&c->cmd_list_entry,
+			&c->cmd_threads->active_cmd_list);
+		wake_up(&c->cmd_threads->cmd_list_waitQ);
+		spin_unlock_irq(&c->cmd_threads->cmd_list_lock);
+	}
+
+	return;
+}
+
+void scst_inc_expected_sn(struct scst_tgt_dev *tgt_dev, atomic_t *slot);
+int scst_check_hq_cmd(struct scst_cmd *cmd);
+
+void scst_unblock_deferred(struct scst_tgt_dev *tgt_dev,
+	struct scst_cmd *cmd_sn);
+
+void scst_on_hq_cmd_response(struct scst_cmd *cmd);
+void scst_xmit_process_aborted_cmd(struct scst_cmd *cmd);
+
+int scst_cmd_thread(void *arg);
+void scst_cmd_tasklet(long p);
+int scst_init_thread(void *arg);
+int scst_tm_thread(void *arg);
+int scst_global_mgmt_thread(void *arg);
+
+void scst_zero_write_rest(struct scst_cmd *cmd);
+void scst_limit_sg_write_len(struct scst_cmd *cmd);
+void scst_adjust_resp_data_len(struct scst_cmd *cmd);
+
+int scst_queue_retry_cmd(struct scst_cmd *cmd, int finished_cmds);
+
+int scst_alloc_tgt(struct scst_tgt_template *tgtt, struct scst_tgt **tgt);
+void scst_free_tgt(struct scst_tgt *tgt);
+
+int scst_alloc_device(gfp_t gfp_mask, struct scst_device **out_dev);
+void scst_free_device(struct scst_device *dev);
+
+struct scst_acg *scst_alloc_add_acg(struct scst_tgt *tgt,
+	const char *acg_name, bool tgt_acg);
+void scst_del_free_acg(struct scst_acg *acg);
+
+struct scst_acg *scst_tgt_find_acg(struct scst_tgt *tgt, const char *name);
+struct scst_acg *scst_find_acg(const struct scst_session *sess);
+
+void scst_check_reassign_sessions(void);
+
+int scst_sess_alloc_tgt_devs(struct scst_session *sess);
+void scst_sess_free_tgt_devs(struct scst_session *sess);
+void scst_nexus_loss(struct scst_tgt_dev *tgt_dev, bool queue_UA);
+
+int scst_acg_add_lun(struct scst_acg *acg, struct kobject *parent,
+	struct scst_device *dev, uint64_t lun, int read_only,
+	bool gen_scst_report_luns_changed, struct scst_acg_dev **out_acg_dev);
+int scst_acg_del_lun(struct scst_acg *acg, uint64_t lun,
+	bool gen_scst_report_luns_changed);
+
+int scst_acg_add_acn(struct scst_acg *acg, const char *name);
+void scst_del_free_acn(struct scst_acn *acn, bool reassign);
+struct scst_acn *scst_find_acn(struct scst_acg *acg, const char *name);
+
+/* The activity supposed to be suspended and scst_mutex held */
+static inline bool scst_acg_sess_is_empty(struct scst_acg *acg)
+{
+	return list_empty(&acg->acg_sess_list);
+}
+
+int scst_prepare_request_sense(struct scst_cmd *orig_cmd);
+int scst_finish_internal_cmd(struct scst_cmd *cmd);
+
+void scst_store_sense(struct scst_cmd *cmd);
+
+int scst_assign_dev_handler(struct scst_device *dev,
+	struct scst_dev_type *handler);
+
+struct scst_session *scst_alloc_session(struct scst_tgt *tgt, gfp_t gfp_mask,
+	const char *initiator_name);
+void scst_free_session(struct scst_session *sess);
+void scst_free_session_callback(struct scst_session *sess);
+
+struct scst_cmd *scst_alloc_cmd(gfp_t gfp_mask);
+void scst_free_cmd(struct scst_cmd *cmd);
+static inline void scst_destroy_cmd(struct scst_cmd *cmd)
+{
+	kmem_cache_free(scst_cmd_cachep, cmd);
+	return;
+}
+
+void scst_check_retries(struct scst_tgt *tgt);
+
+int scst_alloc_space(struct scst_cmd *cmd);
+
+int scst_lib_init(void);
+void scst_lib_exit(void);
+
+__be64 scst_pack_lun(const uint64_t lun, unsigned int addr_method);
+uint64_t scst_unpack_lun(const uint8_t *lun, int len);
+
+struct scst_mgmt_cmd *scst_alloc_mgmt_cmd(gfp_t gfp_mask);
+void scst_free_mgmt_cmd(struct scst_mgmt_cmd *mcmd);
+void scst_done_cmd_mgmt(struct scst_cmd *cmd);
+
+static inline void scst_devt_cleanup(struct scst_dev_type *devt) { }
+
+int scst_sysfs_init(void);
+void scst_sysfs_cleanup(void);
+int scst_tgtt_sysfs_create(struct scst_tgt_template *tgtt);
+void scst_tgtt_sysfs_del(struct scst_tgt_template *tgtt);
+int scst_tgt_sysfs_create(struct scst_tgt *tgt);
+void scst_tgt_sysfs_prepare_put(struct scst_tgt *tgt);
+void scst_tgt_sysfs_del(struct scst_tgt *tgt);
+int scst_sess_sysfs_create(struct scst_session *sess);
+void scst_sess_sysfs_del(struct scst_session *sess);
+int scst_recreate_sess_luns_link(struct scst_session *sess);
+int scst_sgv_sysfs_create(struct sgv_pool *pool);
+void scst_sgv_sysfs_del(struct sgv_pool *pool);
+int scst_devt_sysfs_create(struct scst_dev_type *devt);
+void scst_devt_sysfs_del(struct scst_dev_type *devt);
+int scst_dev_sysfs_create(struct scst_device *dev);
+void scst_dev_sysfs_del(struct scst_device *dev);
+int scst_tgt_dev_sysfs_create(struct scst_tgt_dev *tgt_dev);
+void scst_tgt_dev_sysfs_del(struct scst_tgt_dev *tgt_dev);
+int scst_devt_dev_sysfs_create(struct scst_device *dev);
+void scst_devt_dev_sysfs_del(struct scst_device *dev);
+int scst_acg_sysfs_create(struct scst_tgt *tgt,
+	struct scst_acg *acg);
+void scst_acg_sysfs_del(struct scst_acg *acg);
+int scst_acg_dev_sysfs_create(struct scst_acg_dev *acg_dev,
+	struct kobject *parent);
+void scst_acg_dev_sysfs_del(struct scst_acg_dev *acg_dev);
+int scst_acn_sysfs_create(struct scst_acn *acn);
+void scst_acn_sysfs_del(struct scst_acn *acn);
+
+void __scst_dev_check_set_UA(struct scst_device *dev, struct scst_cmd *exclude,
+	const uint8_t *sense, int sense_len);
+static inline void scst_dev_check_set_UA(struct scst_device *dev,
+	struct scst_cmd *exclude, const uint8_t *sense, int sense_len)
+{
+	spin_lock_bh(&dev->dev_lock);
+	__scst_dev_check_set_UA(dev, exclude, sense, sense_len);
+	spin_unlock_bh(&dev->dev_lock);
+	return;
+}
+void scst_dev_check_set_local_UA(struct scst_device *dev,
+	struct scst_cmd *exclude, const uint8_t *sense, int sense_len);
+
+#define SCST_SET_UA_FLAG_AT_HEAD	1
+#define SCST_SET_UA_FLAG_GLOBAL		2
+
+void scst_check_set_UA(struct scst_tgt_dev *tgt_dev,
+	const uint8_t *sense, int sense_len, int flags);
+int scst_set_pending_UA(struct scst_cmd *cmd);
+
+void scst_report_luns_changed(struct scst_acg *acg);
+
+void scst_abort_cmd(struct scst_cmd *cmd, struct scst_mgmt_cmd *mcmd,
+	bool other_ini, bool call_dev_task_mgmt_fn);
+void scst_process_reset(struct scst_device *dev,
+	struct scst_session *originator, struct scst_cmd *exclude_cmd,
+	struct scst_mgmt_cmd *mcmd, bool setUA);
+
+bool scst_is_ua_global(const uint8_t *sense, int len);
+void scst_requeue_ua(struct scst_cmd *cmd);
+
+struct scst_aen *scst_alloc_aen(struct scst_session *sess,
+	uint64_t unpacked_lun);
+void scst_free_aen(struct scst_aen *aen);
+
+void scst_gen_aen_or_ua(struct scst_tgt_dev *tgt_dev,
+	int key, int asc, int ascq);
+
+static inline bool scst_is_implicit_hq(struct scst_cmd *cmd)
+{
+	return (cmd->op_flags & SCST_IMPLICIT_HQ) != 0;
+}
+
+static inline bool scst_is_implicit_ordered(struct scst_cmd *cmd)
+{
+	return (cmd->op_flags & SCST_IMPLICIT_ORDERED) != 0;
+}
+
+/*
+ * Some notes on devices "blocking". Blocking means that no
+ * commands will go from SCST to underlying SCSI device until it
+ * is unblocked. But we don't care about all commands that
+ * already on the device.
+ */
+
+extern void scst_block_dev(struct scst_device *dev);
+extern void scst_unblock_dev(struct scst_device *dev);
+
+extern bool __scst_check_blocked_dev(struct scst_cmd *cmd);
+
+static inline bool scst_check_blocked_dev(struct scst_cmd *cmd)
+{
+	if (unlikely(cmd->dev->block_count > 0) ||
+	    unlikely(cmd->dev->dev_double_ua_possible))
+		return __scst_check_blocked_dev(cmd);
+	else
+		return false;
+}
+
+/* No locks */
+static inline void scst_check_unblock_dev(struct scst_cmd *cmd)
+{
+	if (unlikely(cmd->unblock_dev)) {
+		TRACE_MGMT_DBG("cmd %p (tag %llu): unblocking dev %p", cmd,
+			       (long long unsigned int)cmd->tag, cmd->dev);
+		cmd->unblock_dev = 0;
+		scst_unblock_dev(cmd->dev);
+	}
+	return;
+}
+
+static inline void __scst_get(int barrier)
+{
+	atomic_inc(&scst_cmd_count);
+	TRACE_DBG("Incrementing scst_cmd_count(new value %d)",
+		atomic_read(&scst_cmd_count));
+
+	/* See comment about smp_mb() in scst_suspend_activity() */
+	if (barrier)
+		smp_mb__after_atomic_inc();
+}
+
+static inline void __scst_put(void)
+{
+	int f;
+	f = atomic_dec_and_test(&scst_cmd_count);
+	/* See comment about smp_mb() in scst_suspend_activity() */
+	if (f && unlikely(test_bit(SCST_FLAG_SUSPENDED, &scst_flags))) {
+		TRACE_MGMT_DBG("%s", "Waking up scst_dev_cmd_waitQ");
+		wake_up_all(&scst_dev_cmd_waitQ);
+	}
+	TRACE_DBG("Decrementing scst_cmd_count(new value %d)",
+	      atomic_read(&scst_cmd_count));
+}
+
+void scst_sched_session_free(struct scst_session *sess);
+
+static inline void scst_sess_get(struct scst_session *sess)
+{
+	atomic_inc(&sess->refcnt);
+	TRACE_DBG("Incrementing sess %p refcnt (new value %d)",
+		sess, atomic_read(&sess->refcnt));
+}
+
+static inline void scst_sess_put(struct scst_session *sess)
+{
+	TRACE_DBG("Decrementing sess %p refcnt (new value %d)",
+		sess, atomic_read(&sess->refcnt)-1);
+	if (atomic_dec_and_test(&sess->refcnt))
+		scst_sched_session_free(sess);
+}
+
+static inline void __scst_cmd_get(struct scst_cmd *cmd)
+{
+	atomic_inc(&cmd->cmd_ref);
+	TRACE_DBG("Incrementing cmd %p ref (new value %d)",
+		cmd, atomic_read(&cmd->cmd_ref));
+}
+
+static inline void __scst_cmd_put(struct scst_cmd *cmd)
+{
+	TRACE_DBG("Decrementing cmd %p ref (new value %d)",
+		cmd, atomic_read(&cmd->cmd_ref)-1);
+	if (atomic_dec_and_test(&cmd->cmd_ref))
+		scst_free_cmd(cmd);
+}
+
+extern void scst_throttle_cmd(struct scst_cmd *cmd);
+extern void scst_unthrottle_cmd(struct scst_cmd *cmd);
+
+#ifdef CONFIG_SCST_DEBUG_TM
+extern void tm_dbg_check_released_cmds(void);
+extern int tm_dbg_check_cmd(struct scst_cmd *cmd);
+extern void tm_dbg_release_cmd(struct scst_cmd *cmd);
+extern void tm_dbg_task_mgmt(struct scst_device *dev, const char *fn,
+	int force);
+extern int tm_dbg_is_release(void);
+#else
+static inline void tm_dbg_check_released_cmds(void) {}
+static inline int tm_dbg_check_cmd(struct scst_cmd *cmd)
+{
+	return 0;
+}
+static inline void tm_dbg_release_cmd(struct scst_cmd *cmd) {}
+static inline void tm_dbg_task_mgmt(struct scst_device *dev, const char *fn,
+	int force) {}
+static inline int tm_dbg_is_release(void)
+{
+	return 0;
+}
+#endif /* CONFIG_SCST_DEBUG_TM */
+
+#ifdef CONFIG_SCST_DEBUG_SN
+void scst_check_debug_sn(struct scst_cmd *cmd);
+#else
+static inline void scst_check_debug_sn(struct scst_cmd *cmd) {}
+#endif
+
+static inline int scst_sn_before(uint32_t seq1, uint32_t seq2)
+{
+	return (int32_t)(seq1-seq2) < 0;
+}
+
+int gen_relative_target_port_id(uint16_t *id);
+bool scst_is_relative_target_port_id_unique(uint16_t id,
+	const struct scst_tgt *t);
+
+#ifdef CONFIG_SCST_MEASURE_LATENCY
+
+void scst_set_start_time(struct scst_cmd *cmd);
+void scst_set_cur_start(struct scst_cmd *cmd);
+void scst_set_parse_time(struct scst_cmd *cmd);
+void scst_set_alloc_buf_time(struct scst_cmd *cmd);
+void scst_set_restart_waiting_time(struct scst_cmd *cmd);
+void scst_set_rdy_to_xfer_time(struct scst_cmd *cmd);
+void scst_set_pre_exec_time(struct scst_cmd *cmd);
+void scst_set_exec_time(struct scst_cmd *cmd);
+void scst_set_dev_done_time(struct scst_cmd *cmd);
+void scst_set_xmit_time(struct scst_cmd *cmd);
+void scst_set_tgt_on_free_time(struct scst_cmd *cmd);
+void scst_set_dev_on_free_time(struct scst_cmd *cmd);
+void scst_update_lat_stats(struct scst_cmd *cmd);
+
+#else
+
+static inline void scst_set_start_time(struct scst_cmd *cmd) {}
+static inline void scst_set_cur_start(struct scst_cmd *cmd) {}
+static inline void scst_set_parse_time(struct scst_cmd *cmd) {}
+static inline void scst_set_alloc_buf_time(struct scst_cmd *cmd) {}
+static inline void scst_set_restart_waiting_time(struct scst_cmd *cmd) {}
+static inline void scst_set_rdy_to_xfer_time(struct scst_cmd *cmd) {}
+static inline void scst_set_pre_exec_time(struct scst_cmd *cmd) {}
+static inline void scst_set_exec_time(struct scst_cmd *cmd) {}
+static inline void scst_set_dev_done_time(struct scst_cmd *cmd) {}
+static inline void scst_set_xmit_time(struct scst_cmd *cmd) {}
+static inline void scst_set_tgt_on_free_time(struct scst_cmd *cmd) {}
+static inline void scst_set_dev_on_free_time(struct scst_cmd *cmd) {}
+static inline void scst_update_lat_stats(struct scst_cmd *cmd) {}
+
+#endif /* CONFIG_SCST_MEASURE_LATENCY */
+
+#endif /* __SCST_PRIV_H */
