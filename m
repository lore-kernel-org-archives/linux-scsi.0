From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH] ibmvscsis: Add initial TCM I/O path handoff logic
Date: Sat, 30 Oct 2010 20:13:50 -0700
Message-ID: <1288494830-30416-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm17-vm0.bullet.mail.ne1.yahoo.com ([98.138.91.58]:20758 "HELO
	nm17-vm0.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753738Ab0JaDOD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 30 Oct 2010 23:14:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: Brian King <brking@linux.vnet.ibm.com>, Linda Xie <lxie@us.ibm.com>, Robert C Jennings <rcjenn@us.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>, James Bottomley <James.Bottomley@suse.de>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings Tomo-san and Co,

This patch adds initial support for TCM I/O path logic in tcm_queuecommand()
using proper struct target_core_fabric_ops callbacks using TRANSPORT_NEW_CMD_MAP
-> ibmvscsis_new_cmd_map() for setup in TCM process context and the normal
TFO completion callbacks.

This includes introducing struct ibmvscsis_cmd I/O desciptor containing
struct scsi_cmnd and struct se_cmd members used by IBMVSCSIS to interact
with libsrp and TCM respective.  The allocation of struct ibmvscsis_cmd
is performed in ibmvscsis_queuecommand() for both internal and TCM CDB
handling cases.  This patch also adds the explict TFO->check_stop_free
caller to release each struct ibmvscsis in ibmvscsis_release_cmd().

Also in ibmvscsis_queuecommand(), this patch removes the now unnecessary
START_STOP, READ_CAPACITY and READ_6 internal CDB emulation, and leaves the
internal INQUIRY, REPORT_LUNS and MODE_SENSE CDB emulation being handled by
ibmvscsis_queuecommand().

Inside of the ibmvscsis_write_pending() and ibmvscsis_queue_data_in() TFO
callers, the struct ibmvscsis->sc (struct scsi_cmnd) is used by libsrp ->
srp_transfer_data(), and this code uses transport_do_task_sg_chain() for
a single walkable SGL list or T_TASK(se_cmd)->t_tasks_sg_bounce for
non SG/IO cases.  For the SCSI WRITE case transport_generic_process_write()
is called to execute the underlying struct se_tasks, and for SCSI READ our
fabric callback will call ibmvscsis_cmd_done() to post our struct scsi_cmnd back to
libsrp and VIO LPAR logic.

Finally, this path adds the ibmvscsis_queue_status() callback that also
sets up our struct scsi_cmnd to be posted back to libsrp via
ibmvscsis_cmd_done().  It also copies any present SENSE data into
struct scsi_cmnd->sense_buffer and sets the approach sc->result for the
ibmvscsis_cmd_done() -> libsrp callback.

So far this has been compile tested, but I think should be pretty close to
functional on real hardware.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/scsi/ibmvscsi/ibmvscsis.c |  479 +++++++++++++++++++++++++++---------
 1 files changed, 359 insertions(+), 120 deletions(-)

diff --git a/drivers/scsi/ibmvscsi/ibmvscsis.c b/drivers/scsi/ibmvscsi/ibmvscsis.c
index 396de44..b4735a8 100644
--- a/drivers/scsi/ibmvscsi/ibmvscsis.c
+++ b/drivers/scsi/ibmvscsi/ibmvscsis.c
@@ -1,3 +1,30 @@
+/*
+ * IBM eServer i/pSeries Virtual SCSI Target Driver
+ *
+ * Copyright (C) 2005-2006, 2010 FUJITA Tomonori <tomof@acm.org>
+ * Copyright (C) 2010 Nicholas A. Bellinger <nab@kernel.org>
+ *
+ * Based on ibmvstgt.c by:
+ * Copyright (C) 2003-2005 Dave Boutcher (boutcher@us.ibm.com) IBM Corp.
+ * 			   Santiago Leon (santil@us.ibm.com) IBM Corp.
+ *			   Linda Xie (lxie@us.ibm.com) IBM Corp.
+ * 
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, write to the Free Software
+ * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307
+ * USA
+ */
+
 #include <linux/slab.h>
 #include <linux/kthread.h>
 #include <linux/types.h>
@@ -13,6 +40,7 @@
 #include <scsi/scsi_cmnd.h>
 #include <scsi/scsi_tcq.h>
 #include <scsi/libsrp.h>
+#include <scsi/libsas.h> /* For TASK_ATTR_* */
 #include <generated/utsrelease.h>
 
 #include <target/target_core_base.h>
@@ -34,6 +62,7 @@
 
 #define IBMVSCSIS_VERSION  "v0.1"
 #define IBMVSCSIS_NAMELEN 32
+#define IBMVSCSIS_TPGS_PER_TPORT 32
 
 #define	INITIAL_SRP_LIMIT	16
 #define	DEFAULT_MAX_SECTORS	256
@@ -58,9 +87,20 @@ static char system_id[64] = "";
 static char partition_name[97] = "UNKNOWN";
 static unsigned int partition_number = -1;
 
+struct kmem_cache *ibmvscsis_cmd_cache;
+
 static LIST_HEAD(tcm_vdev_list);
 static DEFINE_SPINLOCK(tcm_vdev_lock);
 
+struct ibmvscsis_cmd {
+	/* Used for libsrp processing callbacks */
+	struct scsi_cmnd sc;
+	/* Used for TCM Core operations */
+	struct se_cmd se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char sense_buf[TRANSPORT_SENSE_BUFFER];
+};
+
 struct ibmvscsis_nexus {
 	/* Binary World Wide unique Port Name for SRP Initiator port */
 	u64 iport_wwpn;
@@ -91,6 +131,8 @@ struct ibmvscsis_tport {
 	struct ibmvscsis_nexus *tport_nexus;
 	struct ibmvscsis_vdev *tport_vdev;
 
+	struct ibmvscsis_tpg tport_tpgs[IBMVSCSIS_TPGS_PER_TPORT];
+
 	/* Returned by ibmvscsis_make_tport() */
 	struct se_wwn tport_wwn;
 };
@@ -119,6 +161,11 @@ struct ibmvscsis_vdev {
 	struct srp_target srpt;
 };
 
+static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
+{
+	return (union viosrp_iu *) (iue->sbuf->buf);
+}
+
 static int ibmvscsis_check_true(struct se_portal_group *se_tpg)
 {
 	return 1;
@@ -276,9 +323,34 @@ static u32 ibmvscsis_tpg_get_inst_index(struct se_portal_group *se_tpg)
 	return 1;
 }
 
+/*
+ * Called from struct target_core_fabric_ops->check_stop_free()
+ */
+static void ibmvscsis_check_stop_free(struct se_cmd *se_cmd)
+{
+	/*
+	 * Do not release struct se_cmd's containing a valid TMR
+	 * pointer.  These will be released directly in tcm_loop_device_reset()
+	 * with transport_generic_free_cmd().
+	 */
+	if (se_cmd->se_tmr_req)
+		return;
+	/*
+	 * Release the struct se_cmd, which will make a callback to release
+	 * struct ibmvscsis_cmd * in ibmvscsis_release_cmd()
+	 */
+	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+}
+
+/*
+ * Called from struct target_core_fabric_ops->release_cmd_to_pool()
+ */
 static void ibmvscsis_release_cmd(struct se_cmd *se_cmd)
 {
-	return;
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+			struct ibmvscsis_cmd, se_cmd);
+
+	kmem_cache_free(ibmvscsis_cmd_cache, cmd);
 }
 
 static int ibmvscsis_shutdown_session(struct se_session *se_sess)
@@ -312,8 +384,56 @@ static u32 ibmvscsis_sess_get_index(struct se_session *se_sess)
 	return 0;
 }
 
+int ibmvscsis_cmd_done(struct scsi_cmnd *, int);
+int ibmvscsis_rdma(struct scsi_cmnd *, struct scatterlist *, int nsg,
+		struct srp_direct_buf *, int, enum dma_data_direction,
+		unsigned int);
+
 static int ibmvscsis_write_pending(struct se_cmd *se_cmd)
 {
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+			struct ibmvscsis_cmd, se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	int ret;
+
+	sc->sdb.length = se_cmd->data_length;
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+
+		sc->sdb.table.nents = 1;
+		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	}
+	/*
+	 * Perform the SCSI WRITE data transfer from VIO LPAR memory into
+	 * sc->sdb.table.  This will occur via libsrp in the
+	 * ibmvscsis_rdma() callback
+	 */
+	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1, 1);
+	if (ret) {
+		printk(KERN_ERR "srp_transfer_data() failed: %d\n", ret);
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	}
+	/*
+	 * We now tell TCM to add this WRITE CDB directly into the TCM storage
+	 * object execution queue.
+	 */
+	transport_generic_process_write(se_cmd);
 	return 0;
 }
 
@@ -344,11 +464,83 @@ static void ibmvscsis_new_cmd_failure(struct se_cmd *se_cmd)
 
 static int ibmvscsis_queue_data_in(struct se_cmd *se_cmd)
 {
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+			struct ibmvscsis_cmd, se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
+	int ret;
+	/*
+	 * Check for overflow residual count
+	 */
+	if (se_cmd->se_cmd_flags & SCF_OVERFLOW_BIT)
+		scsi_set_resid(sc, se_cmd->residual_count);
+
+	sc->sdb.length = se_cmd->data_length;
+	/*
+	 * Setup the struct se_task->task_sg[] chained SG list
+	 */
+	if ((se_cmd->se_cmd_flags & SCF_SCSI_DATA_SG_IO_CDB) ||
+	    (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_SG_IO_CDB)) {
+		transport_do_task_sg_chain(se_cmd);
+
+		sc->sdb.table.nents = T_TASK(se_cmd)->t_tasks_sg_chained_no;
+		sc->sdb.table.sgl = T_TASK(se_cmd)->t_tasks_sg_chained;
+	} else if (se_cmd->se_cmd_flags & SCF_SCSI_CONTROL_NONSG_IO_CDB) {
+		/*
+		 * Use T_TASK(se_cmd)->t_tasks_sg_bounce for control CDBs
+		 * using a contigious buffer
+		 */             
+		sg_init_table(&T_TASK(se_cmd)->t_tasks_sg_bounce, 1);
+		sg_set_buf(&T_TASK(se_cmd)->t_tasks_sg_bounce,
+			T_TASK(se_cmd)->t_task_buf, se_cmd->data_length);
+
+		sc->sdb.table.nents = 1;
+		sc->sdb.table.sgl = &T_TASK(se_cmd)->t_tasks_sg_bounce;
+	}
+	/*
+	 * Perform the SCSI READ data transfer from sc->sdb.table into
+	 * VIO LPAR memory.  This will occur via libsrp in the
+	 * ibmvscsis_rdma() callback
+	 */
+	ret = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1, 1);
+	if (ret) {
+		printk(KERN_ERR "srp_transfer_data() failed: %d, returning"
+				" DID_ERROR\n", ret);
+		sc->result = host_byte(DID_ERROR) | se_cmd->scsi_status;
+	} else
+		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
+	/*
+	 * This will call srp_transfer_data() and post the response
+	 * to VIO via libsrp.
+	 */
+	ibmvscsis_cmd_done(sc, 1);
 	return 0;
 }
 
 static int ibmvscsis_queue_status(struct se_cmd *se_cmd)
 {
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+			struct ibmvscsis_cmd, se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	/*
+	 * Copy any generated SENSE data into sc->sense_buffer and
+	 * set the appropiate sc->result to be translated by
+	 * ibmvscsis_cmd_done()
+	 */
+	if (se_cmd->sense_buffer &&
+	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
+	    (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
+		
+		memcpy((void *)sc->sense_buffer, (void *)se_cmd->sense_buffer,
+				SCSI_SENSE_BUFFERSIZE);
+		sc->result = host_byte(DID_OK) | driver_byte(DRIVER_SENSE) |
+				SAM_STAT_CHECK_CONDITION;
+	} else
+		sc->result = host_byte(DID_OK) | se_cmd->scsi_status;
+	/*
+	 * Finally post the response to VIO via libsrp.
+	 */
+	ibmvscsis_cmd_done(sc, 1);
 	return 0;
 }
 
@@ -578,20 +770,20 @@ static struct se_portal_group *ibmvscsis_make_tpg(struct se_wwn *wwn,
 		return ERR_PTR(-EINVAL);
 	}
 
-	tpg = kzalloc(sizeof(*tpg), GFP_KERNEL);
-	if (!(tpg))
-		return ERR_PTR(-ENOMEM);
-
+	if (tpgt > IBMVSCSIS_TPGS_PER_TPORT) {
+		printk(KERN_ERR "Passed tpgt: %lu exceeds IBMVSCSIS_TPGS_PER_TPORT:"
+			" %u\n", tpgt, IBMVSCSIS_TPGS_PER_TPORT);
+		return ERR_PTR(-EINVAL);
+	}
+	tpg = &tport->tport_tpgs[tpgt];
 	tpg->tpg_tport = tport;
 	tpg->tpgt = (unsigned short)tpgt;
 
 	ret = core_tpg_register(&ibmvscsis_fabric_configfs->tf_ops, wwn,
 				&tpg->se_tpg, (void *)tpg,
 				TRANSPORT_TPG_TYPE_NORMAL);
-	if (ret) {
-		kfree(tpg);
+	if (ret)
 		return ERR_PTR(-ENOMEM);
-	}
 
 	printk(KERN_INFO "IBMVSCSI_ConfigFS: Allocated VIO Target Port"
 		" %s,t,0x%04x\n", config_item_name(&wwn->wwn_group.cg_item),
@@ -617,8 +809,6 @@ static void ibmvscsis_drop_tpg(struct se_portal_group *se_tpg)
 	printk(KERN_INFO "IBMVSCSI_ConfigFS: Deallocated VIO Target Port"
 		" %s,t,0x%04x\n", config_item_name(&wwn->wwn_group.cg_item),
 		tpg->tpgt);
-
-	kfree(tpg);
 }
 
 /*
@@ -696,7 +886,7 @@ static ssize_t ibmvscsis_wwn_show_attr_version(struct target_fabric_configfs *tf
 					       char *page)
 {
 	return sprintf(page, "IBMVSCSIS fabric module %s on %s/%s"
-		"on "UTS_RELEASE"\n", IBMVSCSIS_VERSION, utsname()->sysname,
+		" on "UTS_RELEASE"\n", IBMVSCSIS_VERSION, utsname()->sysname,
 		utsname()->machine);
 }
 
@@ -707,6 +897,8 @@ static struct configfs_attribute *ibmvscsis_wwn_attrs[] = {
 	NULL,
 };
 
+int ibmvscsis_new_cmd_map(struct se_cmd *);
+
 static struct target_core_fabric_ops ibmvscsis_ops = {
 	.get_fabric_name		= ibmvscsis_get_fabric_name,
 	.get_fabric_proto_ident		= ibmvscsis_get_fabric_proto_ident,
@@ -723,6 +915,8 @@ static struct target_core_fabric_ops ibmvscsis_ops = {
 	.tpg_alloc_fabric_acl		= ibmvscsis_alloc_fabric_acl,
 	.tpg_release_fabric_acl		= ibmvscsis_release_fabric_acl,
 	.tpg_get_inst_index		= ibmvscsis_tpg_get_inst_index,
+	.new_cmd_map			= ibmvscsis_new_cmd_map,
+	.check_stop_free		= ibmvscsis_check_stop_free,
 	.release_cmd_to_pool		= ibmvscsis_release_cmd,
 	.release_cmd_direct		= ibmvscsis_release_cmd,
 	.shutdown_session		= ibmvscsis_shutdown_session,
@@ -760,11 +954,6 @@ static struct target_core_fabric_ops ibmvscsis_ops = {
 	.fabric_drop_nodeacl		= NULL,
 };
 
-static inline union viosrp_iu *vio_iu(struct iu_entry *iue)
-{
-	return (union viosrp_iu *) (iue->sbuf->buf);
-}
-
 static int send_iu(struct iu_entry *iue, u64 length, u8 format)
 {
 	struct srp_target *target = iue->target;
@@ -1092,45 +1281,59 @@ static inline struct viosrp_crq *next_crq(struct crq_queue *queue)
 	return crq;
 }
 
-#if 0
-static int srp_queuecommand(struct ibmvscsis_tpg *tpg,
+/*
+ * Used to setup and queue CMD descriptors headed for TCM Core processing
+ */
+static int tcm_queuecommand(struct ibmvscsis_tpg *tpg,
+			    struct ibmvscsis_cmd *vcmd,
 			    struct srp_cmd *cmd)
 {
-	struct se_cmd *se_cmd;
+	struct se_cmd *se_cmd = &vcmd->se_cmd;
+	struct se_portal_group *se_tpg = &tpg->se_tpg;
+	struct se_session *se_sess;
+	struct ibmvscsis_nexus *nexus;
 	int attr;
 	int data_len;
 	int ret;
+	/*
+	 * Locate our active struct ibmvscsis_nexus setup before hand in
+	 * ibmvscsis_tpg_store_nexus()
+	 */
+	nexus = tpg->tpg_tport->tport_nexus;
+	if (!(nexus)) {
+		printk(KERN_ERR "Unable to locate struct ibmvscsis_nexus *\n");
+		return -EINVAL;
+	}
+	se_sess = nexus->se_sess;
 
-	/* TODO: pre-allocate */
-	vcmd = kzalloc(sizeof(*vcmd), GFP_ATOMIC);
-	if (!vcmd)
-		return -ENOMEM;
-
+	/*
+	 * Locate the SAM Task Attr from struct srp_cmd
+	 */
 	switch (cmd->task_attr) {
 	case SRP_SIMPLE_TASK:
-		attr = MSG_SIMPLE_TAG;
+		attr = TASK_ATTR_SIMPLE;
 		break;
 	case SRP_ORDERED_TASK:
-		attr = MSG_ORDERED_TAG;
+		attr = TASK_ATTR_ORDERED;
 		break;
 	case SRP_HEAD_TASK:
-		attr = MSG_HEAD_TAG;
+		attr = TASK_ATTR_HOQ;
 		break;
 	default:
 		printk(KERN_WARNING "Task attribute %d not supported\n",
 		       cmd->task_attr);
-		attr = MSG_SIMPLE_TAG;
+		attr = TASK_ATTR_SIMPLE;
 	}
-
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastructure
+	 */
 	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
-
-	se_cmd = &vcmd->se_cmd;
-
-	transport_init_se_cmd(se_cmd,
-			      &ibmvscsis_fabric_configfs->tf_ops,
-			      tpg->se_sess, data_len, srp_cmd_direction(cmd),
-			      attr, vcmd->sense);
-
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+				data_len, srp_cmd_direction(cmd), attr,
+				&vcmd->sense_buf[0]);
+	/*
+	 * Locate the struct se_lun pointer and attach it to struct se_cmd
+	 */
 	ret = transport_get_lun_for_cmd(se_cmd, NULL, cmd->lun);
 	if (ret) {
 		printk(KERN_ERR "invalid lun %lu\n", (unsigned long)cmd->lun);
@@ -1139,14 +1342,56 @@ static int srp_queuecommand(struct ibmvscsis_tpg *tpg,
 							 0);
 		return ret;
 	}
-
+	/*
+	 * Make early call to setup se_cmd->transport_add_cmd_to_queue() pointer
+	 */
 	transport_device_setup_cmd(se_cmd);
-
+	/*
+	 * Queue up the se_cmd to be processed by TCM Core, calling with
+	 * TRANSPORT_NEW_CMD_MAP means that ibmvscsis_new_cmd_map() will
+	 * be called in TCM thread process context to complete the setup.
+	 */
 	se_cmd->transport_add_cmd_to_queue(se_cmd, TRANSPORT_NEW_CMD_MAP);
+	return 0;
+}
+
+/*
+ * Called by struct target_core_fabric_ops->new_cmd_map()
+ *
+ * Always called in process context.  A non zero return value
+ * here will signal to handle an exception based on the return code.
+ */
+int ibmvscsis_new_cmd_map(struct se_cmd *se_cmd)
+{
+	struct ibmvscsis_cmd *cmd = container_of(se_cmd,
+			struct ibmvscsis_cmd, se_cmd);
+	struct scsi_cmnd *sc = &cmd->sc;
+	struct iu_entry *iue = (struct iu_entry *)sc->SCp.ptr;
+	int ret;
+	/*
+	 * Allocate the necessary tasks to complete the received CDB+data
+	 */
+	ret = transport_generic_allocate_tasks(se_cmd,
+			(unsigned char *)&vio_iu(iue)->srp.cmd);
+	if (ret == -1) {
+		/* Out of Resources */
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	} else if (ret == -2) {
+		/*
+		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
+		 */
+		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
+			return PYX_TRANSPORT_RESERVATION_CONFLICT;
+		/*
+		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
+		 * sense data
+		 */
+		return PYX_TRANSPORT_USE_SENSE_REASON;
+	}
 
 	return 0;
 }
-#endif
+
 
 #define GETTARGET(x) ((int)((((u64)(x)) >> 56) & 0x003f))
 #define GETBUS(x) ((int)((((u64)(x)) >> 53) & 0x0007))
@@ -1318,37 +1563,10 @@ done:
 	return SAM_STAT_CHECK_CONDITION;
 }
 
-static int ibmvscsis_read_capacity(struct ibmvscsis_tpg *tpg,
-				   struct srp_cmd *cmd, char *data)
-{
-	struct se_portal_group *se_tpg = &tpg->se_tpg;
-	u64 unpacked_lun;
-	struct se_lun *lun;
-	u32 blocks;
-
-	unpacked_lun = scsi_lun_to_int(cmd->lun);
-
-	spin_lock(&se_tpg->tpg_lun_lock);
-
-	lun = &se_tpg->tpg_lun_list[unpacked_lun];
-
-	blocks = TRANSPORT(lun->lun_se_dev)->get_blocks(lun->lun_se_dev);
-
-	printk(KERN_INFO "%s %d: %p %u\n",
-	       __func__, __LINE__, se_tpg, blocks);
-
-	put_unaligned_be32(blocks - 1, data);
-	put_unaligned_be32(512, data + 4);
-
-	spin_unlock(&se_tpg->tpg_lun_lock);
-
-	return 8;
-}
-
 static int ibmvscsis_mode_sense(struct ibmvscsis_tpg *tpg,
 				   struct srp_cmd *cmd, char *mode)
 {
-	int bytes;
+	int bytes = 0;
 	struct se_portal_group *se_tpg = &tpg->se_tpg;
 	u64 unpacked_lun;
 	struct se_lun *lun;
@@ -1418,9 +1636,9 @@ static int ibmvscsis_mode_sense(struct ibmvscsis_tpg *tpg,
 	return bytes;
 }
 
-static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
-			  struct srp_direct_buf *md, int nmd,
-			  enum dma_data_direction dir, unsigned int rest)
+int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
+		  struct srp_direct_buf *md, int nmd,
+		  enum dma_data_direction dir, unsigned int rest)
 {
 	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
 	struct srp_target *target = iue->target;
@@ -1485,7 +1703,10 @@ static int ibmvscsis_rdma(struct scsi_cmnd *sc, struct scatterlist *sg, int nsg,
 	return 0;
 }
 
-static int ibmvscsis_cmd_done(struct scsi_cmnd *sc)
+/*
+ * Callback to complete I/O descriptor back into libsrp.
+ */
+int ibmvscsis_cmd_done(struct scsi_cmnd *sc, int async)
 {
 	unsigned long flags;
 	struct iu_entry *iue = (struct iu_entry *) sc->SCp.ptr;
@@ -1495,7 +1716,12 @@ static int ibmvscsis_cmd_done(struct scsi_cmnd *sc)
 	/* printk(KERN_INFO "%p %p %x %u\n", iue, target, vio_iu(iue)->srp.cmd.cdb[0], */
 	/*        scsi_sg_count(sc)); */
 
-	if (scsi_sg_count(sc))
+	/*
+	 * For descriptors being completed by ibmvscsis_queuecommand() context,
+	 * we call srp_transfer_data() directly.  Otherwise this logic will be called
+	 * directly from asynchronous completion callbacks.
+	 */
+	if (!(async) && scsi_sg_count(sc))
 		err = srp_transfer_data(sc, &vio_iu(iue)->srp.cmd, ibmvscsis_rdma, 1, 1);
 
 	spin_lock_irqsave(&target->lock, flags);
@@ -1517,59 +1743,66 @@ static int ibmvscsis_cmd_done(struct scsi_cmnd *sc)
 static int ibmvscsis_queuecommand(struct ibmvscsis_vdev *vdev,
 				  struct iu_entry *iue)
 {
-	int data_len;
 	struct srp_cmd *cmd = iue->sbuf->buf;
+	struct ibmvscsis_cmd *vcmd;
 	struct scsi_cmnd *sc;
+	struct ibmvscsis_tport *tport = vdev->vio_tport;
+	struct ibmvscsis_tpg *tpg;
+	struct se_portal_group *se_tpg;
 	struct page *pg;
-
+	int data_len, ret = 0;
+	/*
+	 * Locate the struct ibmvscsis_tpg pointer based on the reported
+	 * vdev->vio_tpgt used by ibmvscsis_make_tpg().
+	 */
+	tpg = &tport->tport_tpgs[vdev->vio_tpgt];
+	se_tpg = &tpg->se_tpg;
+	
 	data_len = srp_data_length(cmd, srp_cmd_direction(cmd));
 
 	printk("%s %d: %x %u %u %lu\n",
 	       __func__, __LINE__, cmd->cdb[0], data_len,
 	       srp_cmd_direction(cmd), (unsigned long)cmd->lun);
 
-#warning Use ibmvscsis_cmd->sc descriptor
-	sc = kzalloc(sizeof(*sc), GFP_KERNEL);
+	vcmd = kmem_cache_zalloc(ibmvscsis_cmd_cache, GFP_KERNEL);
+	if (!(vcmd))
+		return -ENOMEM;
+	/*
+	 * Setup the struct scsi_cmnd required for libsrp operations
+	 * and save struct iu_entry *iue pointer
+	 */
+	sc = &vcmd->sc;
 	sc->cmnd = cmd->cdb;
 	sc->SCp.ptr = (char *)iue;
-
+	/*
+	 * The INQUIRY, REPORT_LUNS and MODE_SENSE CDB emulation currently
+	 * requires internal handling in order to make legacy non Linux VIO
+	 * Initiator guest cases 'just work'.
+	 *
+	 * For everything else we setup a proper struct se_cmd and perform
+	 * the struct se_lun association and hand it off to finish up
+	 * setup in TCM thread process context.
+	 */
 	switch (cmd->cdb[0]) {
-#if 0
 	case INQUIRY:
 		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
 		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		sc->sdb.length = ibmvscsis_inquery(tpg, cmd, page_address(pg));
 		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
-		ibmvscsis_cmd_done(sc);
+		ibmvscsis_cmd_done(sc, 0);
 		sg_free_table(&sc->sdb.table);
 		__free_page(pg);
-		kfree(sc);
+		ibmvscsis_release_cmd(&vcmd->se_cmd);
 		break;
 	case REPORT_LUNS:
 		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
 		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		sc->sdb.length = ibmvscsis_report_luns(tpg, cmd, page_address(pg));
 		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
-		ibmvscsis_cmd_done(sc);
+		ibmvscsis_cmd_done(sc, 0);
 		sg_free_table(&sc->sdb.table);
 		__free_page(pg);
-		kfree(sc);
-		break;
-	case START_STOP:
-		/* fixme: needs to use tcm */
-		ibmvscsis_cmd_done(sc);
-		kfree(sc);
-		break;
-	case READ_CAPACITY:
-		/* fixme: needs to use tcm */
-		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
-		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
-		sc->sdb.length = ibmvscsis_read_capacity(tpg, cmd, page_address(pg));
-		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
-		ibmvscsis_cmd_done(sc);
-		sg_free_table(&sc->sdb.table);
-		__free_page(pg);
-		kfree(sc);
+		ibmvscsis_release_cmd(&vcmd->se_cmd);
 		break;
 	case MODE_SENSE:
 		/* fixme: needs to use tcm */
@@ -1577,39 +1810,30 @@ static int ibmvscsis_queuecommand(struct ibmvscsis_vdev *vdev,
 		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
 		sc->sdb.length = ibmvscsis_mode_sense(tpg, cmd, page_address(pg));
 		sg_set_page(sc->sdb.table.sgl, pg, sc->sdb.length, 0);
-		ibmvscsis_cmd_done(sc);
-		sg_free_table(&sc->sdb.table);
-		__free_page(pg);
-		kfree(sc);
-		break;
-	case READ_6:
-		/* fixme: needs to use tcm */
-		sg_alloc_table(&sc->sdb.table, 1, GFP_KERNEL);
-		pg = alloc_page(GFP_KERNEL|__GFP_ZERO);
-		sc->sdb.length = data_len;
-		sg_set_page(sc->sdb.table.sgl, pg, data_len, 0);
-		ibmvscsis_cmd_done(sc);
+		ibmvscsis_cmd_done(sc, 0);
 		sg_free_table(&sc->sdb.table);
 		__free_page(pg);
-		kfree(sc);
+		ibmvscsis_release_cmd(&vcmd->se_cmd);
 		break;
-#endif
 	default:
-		/* fixme: needs to use tcm */
-		sc->result = COMMAND_TERMINATED;
-		ibmvscsis_cmd_done(sc);
-		kfree(sc);
+		/*
+		 * By default we will pass along incoming struct srp_cmd ->
+		 * struct ibmvscsis_cmd descriptors into TCM Core.  This
+		 * completion will happen asynchronously via TFO->queue_data_in()
+		 * and TFO->queue_status() callbacks.
+		 */
+		ret = tcm_queuecommand(tpg, vcmd, cmd);
 		break;
 	}
 
-	return 0;
+	return ret;
 }
 
 static void handle_cmd_queue(struct ibmvscsis_vdev *vdev)
 {
 	struct srp_target *target = &vdev->srpt;
 	struct iu_entry *iue;
-	struct srp_cmd *cmd;
+	struct srp_cmd *cmd = NULL;
 	unsigned long flags;
 	int err;
 
@@ -1950,9 +2174,23 @@ static int __init ibmvscsis_init(void)
 	if (ret)
 		return ret;
 
+	ibmvscsis_cmd_cache = kmem_cache_create("ibmvscsis_cmd_cache",
+				sizeof(struct ibmvscsis_cmd),
+				__alignof__(struct ibmvscsis_cmd),
+				0, NULL);
+	if (!(ibmvscsis_cmd_cache)) {
+		printk(KERN_ERR "kmem_cache_create() for"
+			" ibmvscsis_cmd_cache failed\n");
+		vio_unregister_driver(&ibmvscsis_driver);
+		return -ENOMEM;
+	}
+
 	ret = ibmvscsis_register_configfs();
-	if (ret < 0)
+	if (ret < 0) {
+		vio_unregister_driver(&ibmvscsis_driver);
+		kmem_cache_destroy(ibmvscsis_cmd_cache);
 		return ret;
+	}
 
 	return 0;
 };
@@ -1960,6 +2198,7 @@ static int __init ibmvscsis_init(void)
 static void ibmvscsis_exit(void)
 {
 	vio_unregister_driver(&ibmvscsis_driver);
+	kmem_cache_destroy(ibmvscsis_cmd_cache);
 	ibmvscsis_deregister_configfs();
 };
 
-- 
1.5.6

