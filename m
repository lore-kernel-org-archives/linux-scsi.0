From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH-v2] tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
Date: Fri, 18 Mar 2011 15:39:17 -0700
Message-ID: <1300487957-28800-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm10.bullet.mail.bf1.yahoo.com ([98.139.212.169]:24292 "HELO
	nm10.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932577Ab1CRWje (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Mar 2011 18:39:34 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Boaz Harrosh <bharrosh@panasas.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrew Morton <akpm@linux-foundation.org>, Douglas Gilbert <dgilbert@interlog.com>, Nicholas Bellinger <nab@linux-iscsi.org>

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

This patch adds the TCM_Loop Linux/SCSI LLD fabric module for accessing=
 TCM device
backstores as locally accessable SCSI LUNs in virtual SAS, FC, and iSCS=
I Target ports
using the generic fabric TransportID and Target Port WWN naming handler=
s from TCM's
target_core_fabric_lib.c  The TCM_Loop module uses the generic fabric c=
onfigfs infratructure
provided by target_core_fabric_configfs.c and adds a module dependent a=
ttribute for the
creation/release of the virtual I_T Nexus connected the TCM_Loop Target=
 and Initiator Ports.

TCM_Loop can also be used with scsi-generic and BSG drivers so that STG=
T userspace
fabric modules, QEMU-KVM and other hypervisor SCSI passthrough support =
can
access TCM device backstore and control CDB emulation.

=46or more information please see:

http://linux-iscsi.org/wiki/Tcm_loop

This patch has been updated with changes from Christoph's feedback.

Changed from v1 -> v2:

Remove dead extern prototypes and make all functions statically defined=
=2E

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 drivers/target/Kconfig             |    2 +
 drivers/target/Makefile            |    3 +
 drivers/target/loopback/Kconfig    |   11 +
 drivers/target/loopback/Makefile   |    1 +
 drivers/target/loopback/tcm_loop.c | 1580 ++++++++++++++++++++++++++++=
++++++++
 drivers/target/loopback/tcm_loop.h |   77 ++
 6 files changed, 1674 insertions(+), 0 deletions(-)
 create mode 100644 drivers/target/loopback/Kconfig
 create mode 100644 drivers/target/loopback/Makefile
 create mode 100644 drivers/target/loopback/tcm_loop.c
 create mode 100644 drivers/target/loopback/tcm_loop.h

diff --git a/drivers/target/Kconfig b/drivers/target/Kconfig
index 2fac3be..9ef2dbb 100644
--- a/drivers/target/Kconfig
+++ b/drivers/target/Kconfig
@@ -29,4 +29,6 @@ config TCM_PSCSI
 	Say Y here to enable the TCM/pSCSI subsystem plugin for non-buffered
 	passthrough access to Linux/SCSI device
=20
+source "drivers/target/loopback/Kconfig"
+
 endif
diff --git a/drivers/target/Makefile b/drivers/target/Makefile
index 4f3cb78..1178bbf 100644
--- a/drivers/target/Makefile
+++ b/drivers/target/Makefile
@@ -21,3 +21,6 @@ obj-$(CONFIG_TARGET_CORE)	+=3D target_core_mod.o
 obj-$(CONFIG_TCM_IBLOCK)	+=3D target_core_iblock.o
 obj-$(CONFIG_TCM_FILEIO)	+=3D target_core_file.o
 obj-$(CONFIG_TCM_PSCSI)		+=3D target_core_pscsi.o
+
+# Fabric modules
+obj-$(CONFIG_LOOPBACK_TARGET)	+=3D loopback/
diff --git a/drivers/target/loopback/Kconfig b/drivers/target/loopback/=
Kconfig
new file mode 100644
index 0000000..b31ea2f
--- /dev/null
+++ b/drivers/target/loopback/Kconfig
@@ -0,0 +1,11 @@
+config LOOPBACK_TARGET
+	tristate "TCM Virtual SAS target and Linux/SCSI LDD fabric loopback m=
odule"
+	help
+	Say Y here to enable the TCM Virtual SAS target and Linux/SCSI LLD
+	fabric loopback module.
+
+config LOOPBACK_TARGET_CDB_DEBUG
+	bool "TCM loopback fabric module CDB debug code"
+	depends on LOOPBACK_TARGET
+	help
+	Say Y here to enable the TCM loopback fabric module CDB debug code
diff --git a/drivers/target/loopback/Makefile b/drivers/target/loopback=
/Makefile
new file mode 100644
index 0000000..6abebdf
--- /dev/null
+++ b/drivers/target/loopback/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_LOOPBACK_TARGET)	+=3D tcm_loop.o
diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopba=
ck/tcm_loop.c
new file mode 100644
index 0000000..5671268
--- /dev/null
+++ b/drivers/target/loopback/tcm_loop.c
@@ -0,0 +1,1580 @@
+/*********************************************************************=
**********
+ *
+ * This file contains the Linux/SCSI LLD virtual SCSI initiator driver
+ * for emulated SAS initiator ports
+ *
+ * =C2=A9 Copyright 2011 RisingTide Systems LLC.
+ *
+ * Licensed to the Linux Foundation under the General Public License (=
GPL) version 2.=20
+ *=20
+ * Author: Nicholas A. Bellinger <nab@risingtidesystems.com>
+ *
+ * This program is free software; you can redistribute it and/or modif=
y
+ * it under the terms of the GNU General Public License as published b=
y
+ * the Free Software Foundation; either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *********************************************************************=
*******/
+
+#include <linux/module.h>
+#include <linux/moduleparam.h>
+#include <linux/init.h>
+#include <linux/slab.h>
+#include <linux/types.h>
+#include <linux/configfs.h>
+#include <scsi/scsi.h>
+#include <scsi/scsi_tcq.h>
+#include <scsi/scsi_host.h>
+#include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
+#include <scsi/libsas.h> /* For TASK_ATTR_* */
+
+#include <target/target_core_base.h>
+#include <target/target_core_transport.h>
+#include <target/target_core_fabric_ops.h>
+#include <target/target_core_fabric_configfs.h>
+#include <target/target_core_fabric_lib.h>
+#include <target/target_core_configfs.h>
+#include <target/target_core_device.h>
+#include <target/target_core_tpg.h>
+#include <target/target_core_tmr.h>
+
+#include "tcm_loop.h"
+
+#define to_tcm_loop_hba(hba)	container_of(hba, struct tcm_loop_hba, de=
v)
+
+/* Local pointer to allocated TCM configfs fabric module */
+static struct target_fabric_configfs *tcm_loop_fabric_configfs;
+
+static struct kmem_cache *tcm_loop_cmd_cache;
+
+static int tcm_loop_hba_no_cnt;
+
+/*=20
+ * Allocate a tcm_loop cmd descriptor from target_core_mod code
+ *
+ * Can be called from interrupt context in tcm_loop_queuecommand() bel=
ow
+ */
+static struct se_cmd *tcm_loop_allocate_core_cmd(
+	struct tcm_loop_hba *tl_hba,
+	struct se_portal_group *se_tpg,
+	struct scsi_cmnd *sc)
+{
+	struct se_cmd *se_cmd;
+	struct se_session *se_sess;
+	struct tcm_loop_nexus *tl_nexus =3D tl_hba->tl_nexus;
+	struct tcm_loop_cmd *tl_cmd;
+	int sam_task_attr;
+
+	if (!tl_nexus) {
+		scmd_printk(KERN_ERR, sc, "TCM_Loop I_T Nexus"
+				" does not exist\n");
+		set_host_byte(sc, DID_ERROR);
+		return NULL;
+	}
+	se_sess =3D tl_nexus->se_sess;
+
+	tl_cmd =3D kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_ATOMIC);
+	if (!tl_cmd) {
+		printk(KERN_ERR "Unable to allocate struct tcm_loop_cmd\n");
+		set_host_byte(sc, DID_ERROR);
+		return NULL;
+	}
+	se_cmd =3D &tl_cmd->tl_se_cmd;
+	/*
+	 * Save the pointer to struct scsi_cmnd *sc
+	 */
+	tl_cmd->sc =3D sc;
+	/*
+	 * Locate the SAM Task Attr from struct scsi_cmnd *
+	 */
+	if (sc->device->tagged_supported) {
+		switch (sc->tag) {
+		case HEAD_OF_QUEUE_TAG:
+			sam_task_attr =3D TASK_ATTR_HOQ;
+			break;
+		case ORDERED_QUEUE_TAG:
+			sam_task_attr =3D TASK_ATTR_ORDERED;
+			break;
+		default:
+			sam_task_attr =3D TASK_ATTR_SIMPLE;
+			break;
+		}
+	} else
+		sam_task_attr =3D TASK_ATTR_SIMPLE;
+
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess,
+			scsi_bufflen(sc), sc->sc_data_direction, sam_task_attr,
+			&tl_cmd->tl_sense_buf[0]);
+
+	/*
+	 * Signal BIDI usage with T_TASK(cmd)->t_tasks_bidi
+	 */
+	if (scsi_bidi_cmnd(sc))
+		T_TASK(se_cmd)->t_tasks_bidi =3D 1;
+	/*
+	 * Locate the struct se_lun pointer and attach it to struct se_cmd
+	 */
+	if (transport_get_lun_for_cmd(se_cmd, NULL, tl_cmd->sc->device->lun) =
< 0) {
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+		set_host_byte(sc, DID_NO_CONNECT);
+		return NULL;
+	}
+
+	transport_device_setup_cmd(se_cmd);
+	return se_cmd;
+}
+
+/*
+ * Called by struct target_core_fabric_ops->new_cmd_map()
+ *
+ * Always called in process context.  A non zero return value
+ * here will signal to handle an exception based on the return code.
+ */
+static int tcm_loop_new_cmd_map(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd =3D container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc =3D tl_cmd->sc;
+	void *mem_ptr, *mem_bidi_ptr =3D NULL;
+	u32 sg_no_bidi =3D 0;
+	int ret;
+	/*
+	 * Allocate the necessary tasks to complete the received CDB+data
+	 */
+	ret =3D transport_generic_allocate_tasks(se_cmd, tl_cmd->sc->cmnd);
+	if (ret =3D=3D -1) {
+		/* Out of Resources */
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+	} else if (ret =3D=3D -2) {
+		/*
+		 * Handle case for SAM_STAT_RESERVATION_CONFLICT
+		 */
+		if (se_cmd->se_cmd_flags & SCF_SCSI_RESERVATION_CONFLICT)
+			return PYX_TRANSPORT_RESERVATION_CONFLICT;
+		/*
+		 * Otherwise, return SAM_STAT_CHECK_CONDITION and return
+		 * sense data.
+		 */
+		return PYX_TRANSPORT_USE_SENSE_REASON;
+	}
+	/*
+	 * Setup the struct scatterlist memory from the received
+	 * struct scsi_cmnd.
+	 */
+	if (scsi_sg_count(sc)) {
+		se_cmd->se_cmd_flags |=3D SCF_PASSTHROUGH_SG_TO_MEM;
+		mem_ptr =3D (void *)scsi_sglist(sc);
+		/*
+		 * For BIDI commands, pass in the extra READ buffer
+		 * to transport_generic_map_mem_to_cmd() below..
+		 */
+		if (T_TASK(se_cmd)->t_tasks_bidi) {
+			struct scsi_data_buffer *sdb =3D scsi_in(sc);
+
+			mem_bidi_ptr =3D (void *)sdb->table.sgl;
+			sg_no_bidi =3D sdb->table.nents;
+		}
+	} else {
+		/*
+		 * Used for DMA_NONE
+		 */
+                mem_ptr =3D NULL;
+        }
+	/*
+	 * Map the SG memory into struct se_mem->page linked list using the s=
ame
+	 * physical memory at sg->page_link.
+	 */
+	ret =3D transport_generic_map_mem_to_cmd(se_cmd, mem_ptr,
+			scsi_sg_count(sc), mem_bidi_ptr, sg_no_bidi);
+	if (ret < 0)
+		return PYX_TRANSPORT_LU_COMM_FAILURE;
+
+	return 0;
+}
+
+/*
+ * Called from struct target_core_fabric_ops->check_stop_free()
+ */
+static void tcm_loop_check_stop_free(struct se_cmd *se_cmd)
+{
+	/*
+	 * Do not release struct se_cmd's containing a valid TMR
+	 * pointer.  These will be released directly in tcm_loop_device_reset=
()
+	 * with transport_generic_free_cmd().
+	 */
+	if (se_cmd->se_tmr_req)
+		return;
+	/*
+	 * Release the struct se_cmd, which will make a callback to release
+	 * struct tcm_loop_cmd * in tcm_loop_deallocate_core_cmd()
+	 */
+	transport_generic_free_cmd(se_cmd, 0, 1, 0);
+}
+
+/*
+ * Called from struct target_core_fabric_ops->release_cmd_to_pool()
+ */
+static void tcm_loop_deallocate_core_cmd(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd =3D container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+
+	kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+}
+
+static int tcm_loop_proc_info(struct Scsi_Host *host, char *buffer,
+				char **start, off_t offset,
+				int length, int inout)
+{
+	return sprintf(buffer, "tcm_loop_proc_info()\n");
+}
+
+static int tcm_loop_driver_probe(struct device *);
+static int tcm_loop_driver_remove(struct device *);
+
+static int pseudo_lld_bus_match(struct device *dev,
+				struct device_driver *dev_driver)
+{
+	return 1;
+}
+
+static struct bus_type tcm_loop_lld_bus =3D {
+	.name			=3D "tcm_loop_bus",
+	.match			=3D pseudo_lld_bus_match,
+	.probe			=3D tcm_loop_driver_probe,
+	.remove			=3D tcm_loop_driver_remove,
+};
+
+static struct device_driver tcm_loop_driverfs =3D {
+	.name			=3D "tcm_loop",
+	.bus			=3D &tcm_loop_lld_bus,
+};
+/*
+ * Used with root_device_register() in tcm_loop_alloc_core_bus() below
+ */
+struct device *tcm_loop_primary;
+
+/*
+ * Copied from drivers/scsi/libfc/fc_fcp.c:fc_change_queue_depth() and
+ * drivers/scsi/libiscsi.c:iscsi_change_queue_depth()
+ */
+static int tcm_loop_change_queue_depth(
+	struct scsi_device *sdev,
+	int depth,
+	int reason)
+{
+	switch (reason) {
+	case SCSI_QDEPTH_DEFAULT:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	case SCSI_QDEPTH_QFULL:
+		scsi_track_queue_full(sdev, depth);
+		break;
+	case SCSI_QDEPTH_RAMP_UP:
+		scsi_adjust_queue_depth(sdev, scsi_get_tag_type(sdev), depth);
+		break;
+	default:
+		return -EOPNOTSUPP;
+	}
+	return sdev->queue_depth;
+}
+
+/*
+ * Main entry point from struct scsi_host_template for incoming SCSI C=
DB+Data
+ * from Linux/SCSI subsystem for SCSI low level device drivers (LLDs)
+ */
+static int tcm_loop_queuecommand(
+	struct Scsi_Host *sh,
+	struct scsi_cmnd *sc)
+{
+	struct se_cmd *se_cmd;
+	struct se_portal_group *se_tpg;
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_tpg *tl_tpg;
+
+	TL_CDB_DEBUG("tcm_loop_queuecommand() %d:%d:%d:%d got CDB: 0x%02x"
+		" scsi_buf_len: %u\n", sc->device->host->host_no,
+		sc->device->id, sc->device->channel, sc->device->lun,
+		sc->cmnd[0], scsi_bufflen(sc));
+	/*
+	 * Locate the tcm_loop_hba_t pointer=20
+	 */
+	tl_hba =3D *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	tl_tpg =3D &tl_hba->tl_hba_tpgs[sc->device->id];
+	se_tpg =3D &tl_tpg->tl_se_tpg;
+	/*
+	 * Determine the SAM Task Attribute and allocate tl_cmd and
+	 * tl_cmd->tl_se_cmd from TCM infrastructure
+	 */
+	se_cmd =3D tcm_loop_allocate_core_cmd(tl_hba, se_tpg, sc);
+	if (!se_cmd) {
+		sc->scsi_done(sc);
+		return 0;
+	}
+	/*
+	 * Queue up the newly allocated to be processed in TCM thread context=
=2E
+	*/
+	transport_generic_handle_cdb_map(se_cmd);
+	return 0;
+}
+
+/*
+ * Called from SCSI EH process context to issue a LUN_RESET TMR
+ * to struct scsi_device
+ */
+static int tcm_loop_device_reset(struct scsi_cmnd *sc)
+{
+	struct se_cmd *se_cmd =3D NULL;
+	struct se_portal_group *se_tpg;
+	struct se_session *se_sess;
+	struct tcm_loop_cmd *tl_cmd =3D NULL;
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_nexus *tl_nexus;
+	struct tcm_loop_tmr *tl_tmr =3D NULL;
+	struct tcm_loop_tpg *tl_tpg;
+	int ret =3D FAILED;
+	/*
+	 * Locate the tcm_loop_hba_t pointer=20
+	 */
+	tl_hba =3D *(struct tcm_loop_hba **)shost_priv(sc->device->host);
+	/*
+	 * Locate the tl_nexus and se_sess pointers
+	 */
+	tl_nexus =3D tl_hba->tl_nexus;
+	if (!tl_nexus) {
+		printk(KERN_ERR "Unable to perform device reset without"
+				" active I_T Nexus\n");
+		return FAILED;
+	}
+	se_sess =3D tl_nexus->se_sess;
+	/*
+	 * Locate the tl_tpg and se_tpg pointers from TargetID in sc->device-=
>id
+	 */
+	tl_tpg =3D &tl_hba->tl_hba_tpgs[sc->device->id];
+	se_tpg =3D &tl_tpg->tl_se_tpg;
+
+	tl_cmd =3D kmem_cache_zalloc(tcm_loop_cmd_cache, GFP_KERNEL);
+	if (!tl_cmd) {
+		printk(KERN_ERR "Unable to allocate memory for tl_cmd\n");
+		return FAILED;
+	}
+
+	tl_tmr =3D kzalloc(sizeof(struct tcm_loop_tmr), GFP_KERNEL);
+	if (!tl_tmr) {
+		printk(KERN_ERR "Unable to allocate memory for tl_tmr\n");
+		goto release;
+	}
+	init_waitqueue_head(&tl_tmr->tl_tmr_wait);
+
+	se_cmd =3D &tl_cmd->tl_se_cmd;
+	/*
+	 * Initialize struct se_cmd descriptor from target_core_mod infrastru=
cture
+	 */
+	transport_init_se_cmd(se_cmd, se_tpg->se_tpg_tfo, se_sess, 0,
+				DMA_NONE, TASK_ATTR_SIMPLE,
+				&tl_cmd->tl_sense_buf[0]);
+	/*
+	 * Allocate the LUN_RESET TMR
+	 */
+	se_cmd->se_tmr_req =3D core_tmr_alloc_req(se_cmd, (void *)tl_tmr,
+				TMR_LUN_RESET);
+	if (!se_cmd->se_tmr_req)
+		goto release;
+	/*
+	 * Locate the underlying TCM struct se_lun from sc->device->lun
+	 */
+	if (transport_get_lun_for_tmr(se_cmd, sc->device->lun) < 0)
+		goto release;
+	/*
+	 * Queue the TMR to TCM Core and sleep waiting for tcm_loop_queue_tm_=
rsp()
+	 * to wake us up.
+	 */
+	transport_generic_handle_tmr(se_cmd);=09
+	wait_event(tl_tmr->tl_tmr_wait, atomic_read(&tl_tmr->tmr_complete));
+	/*
+	 * The TMR LUN_RESET has completed, check the response status and
+	 * then release allocations.
+	 */
+	ret =3D (se_cmd->se_tmr_req->response =3D=3D TMR_FUNCTION_COMPLETE) ?
+		SUCCESS : FAILED;
+release:
+	if (se_cmd)
+		transport_generic_free_cmd(se_cmd, 1, 1, 0);
+	else
+		kmem_cache_free(tcm_loop_cmd_cache, tl_cmd);
+	kfree(tl_tmr);
+	return ret;
+}
+
+static int tcm_loop_slave_alloc(struct scsi_device *sd)
+{
+	set_bit(QUEUE_FLAG_BIDI, &sd->request_queue->queue_flags);
+	return 0;
+}
+
+static int tcm_loop_slave_configure(struct scsi_device *sd)
+{
+	return 0;
+}
+
+static struct scsi_host_template tcm_loop_driver_template =3D {
+	.proc_info		=3D tcm_loop_proc_info,
+	.proc_name		=3D "tcm_loopback",
+	.name			=3D "TCM_Loopback",
+	.queuecommand		=3D tcm_loop_queuecommand,
+	.change_queue_depth	=3D tcm_loop_change_queue_depth,
+	.eh_device_reset_handler =3D tcm_loop_device_reset,
+	.can_queue		=3D TL_SCSI_CAN_QUEUE,
+	.this_id		=3D -1,
+	.sg_tablesize		=3D TL_SCSI_SG_TABLESIZE,
+	.cmd_per_lun		=3D TL_SCSI_CMD_PER_LUN,
+	.max_sectors		=3D TL_SCSI_MAX_SECTORS,
+	.use_clustering		=3D DISABLE_CLUSTERING,
+	.slave_alloc		=3D tcm_loop_slave_alloc,
+	.slave_configure	=3D tcm_loop_slave_configure,
+	.module			=3D THIS_MODULE,
+};
+
+static int tcm_loop_driver_probe(struct device *dev)
+{
+	struct tcm_loop_hba *tl_hba;
+	struct Scsi_Host *sh;
+	int error;
+
+	tl_hba =3D to_tcm_loop_hba(dev);
+
+	sh =3D scsi_host_alloc(&tcm_loop_driver_template,
+			sizeof(struct tcm_loop_hba));
+	if (!sh) {
+		printk(KERN_ERR "Unable to allocate struct scsi_host\n");
+		return -ENODEV;
+	}
+	tl_hba->sh =3D sh;
+
+	/*
+	 * Assign the struct tcm_loop_hba pointer to struct Scsi_Host->hostda=
ta
+	 */
+	*((struct tcm_loop_hba **)sh->hostdata) =3D tl_hba;
+	/*
+	 * Setup single ID, Channel and LUN for now..
+	 */
+	sh->max_id =3D 2;
+	sh->max_lun =3D 0;
+	sh->max_channel =3D 0;
+	sh->max_cmd_len =3D TL_SCSI_MAX_CMD_LEN;
+
+	error =3D scsi_add_host(sh, &tl_hba->dev);
+	if (error) {
+		printk(KERN_ERR "%s: scsi_add_host failed\n", __func__);
+		scsi_host_put(sh);
+		return -ENODEV;
+	}
+	return 0;
+}
+
+static int tcm_loop_driver_remove(struct device *dev)
+{
+	struct tcm_loop_hba *tl_hba;
+	struct Scsi_Host *sh;
+
+	tl_hba =3D to_tcm_loop_hba(dev);
+	sh =3D tl_hba->sh;
+
+	scsi_remove_host(sh);
+	scsi_host_put(sh);
+	return 0;
+}
+
+static void tcm_loop_release_adapter(struct device *dev)
+{
+	struct tcm_loop_hba *tl_hba =3D to_tcm_loop_hba(dev);
+
+	kfree(tl_hba);
+}
+
+/*
+ * Called from tcm_loop_make_scsi_hba() in tcm_loop_configfs.c
+ */
+static int tcm_loop_setup_hba_bus(struct tcm_loop_hba *tl_hba, int tcm=
_loop_host_id)
+{
+	int ret;
+
+	tl_hba->dev.bus =3D &tcm_loop_lld_bus;
+	tl_hba->dev.parent =3D tcm_loop_primary;
+	tl_hba->dev.release =3D &tcm_loop_release_adapter;
+	dev_set_name(&tl_hba->dev, "tcm_loop_adapter_%d", tcm_loop_host_id);
+
+	ret =3D device_register(&tl_hba->dev);
+	if (ret) {
+		printk(KERN_ERR "device_register() failed for"
+				" tl_hba->dev: %d\n", ret);
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
+/*
+ * Called from tcm_loop_fabric_init() in tcl_loop_fabric.c to load the=
 emulated
+ * tcm_loop SCSI bus.
+ */
+static int tcm_loop_alloc_core_bus(void)
+{
+	int ret;
+
+	tcm_loop_primary =3D root_device_register("tcm_loop_0");
+	if (IS_ERR(tcm_loop_primary)) {
+		printk(KERN_ERR "Unable to allocate tcm_loop_primary\n");
+		return PTR_ERR(tcm_loop_primary);
+	}
+=09
+	ret =3D bus_register(&tcm_loop_lld_bus);
+	if (ret) {
+		printk(KERN_ERR "bus_register() failed for tcm_loop_lld_bus\n");
+		goto dev_unreg;
+	}
+
+	ret =3D driver_register(&tcm_loop_driverfs);
+	if (ret) {
+		printk(KERN_ERR "driver_register() failed for"
+				"tcm_loop_driverfs\n");
+		goto bus_unreg;
+	}
+
+	printk(KERN_INFO "Initialized TCM Loop Core Bus\n");
+	return ret;
+
+bus_unreg:
+	bus_unregister(&tcm_loop_lld_bus);
+dev_unreg:
+	root_device_unregister(tcm_loop_primary);
+	return ret;
+}
+
+static void tcm_loop_release_core_bus(void)
+{
+	driver_unregister(&tcm_loop_driverfs);
+	bus_unregister(&tcm_loop_lld_bus);
+	root_device_unregister(tcm_loop_primary);
+
+	printk(KERN_INFO "Releasing TCM Loop Core BUS\n");
+}
+
+static char *tcm_loop_get_fabric_name(void)
+{
+	return "loopback";
+}
+
+static u8 tcm_loop_get_fabric_proto_ident(struct se_portal_group *se_t=
pg)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+	/*
+	 * tl_proto_id is set at tcm_loop_configfs.c:tcm_loop_make_scsi_hba()
+	 * time based on the protocol dependent prefix of the passed configfs=
 group.
+	 *
+	 * Based upon tl_proto_id, TCM_Loop emulates the requested fabric
+	 * ProtocolID using target_core_fabric_lib.c symbols.
+	 */
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_fabric_proto_ident(se_tpg);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_fabric_proto_ident(se_tpg);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_fabric_proto_ident(se_tpg);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_get_fabric_proto_ident(se_tpg);
+}
+
+static char *tcm_loop_get_endpoint_wwn(struct se_portal_group *se_tpg)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+		(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;=09
+	/*
+	 * Return the passed NAA identifier for the SAS Target Port
+	 */
+	return &tl_tpg->tl_hba->tl_wwn_address[0];
+}
+
+static u16 tcm_loop_get_tag(struct se_portal_group *se_tpg)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+		(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	/*
+	 * This Tag is used when forming SCSI Name identifier in EVPD=3D1 0x8=
3
+	 * to represent the SCSI Target Port.
+	 */
+	return tl_tpg->tl_tpgt;
+}
+
+static u32 tcm_loop_get_default_depth(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static u32 tcm_loop_get_pr_transport_id(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code,
+	unsigned char *buf)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+					format_code, buf);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_get_pr_transport_id(se_tpg, se_nacl, pr_reg,
+			format_code, buf);
+}
+
+static u32 tcm_loop_get_pr_transport_id_len(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl,
+	struct t10_pr_registration *pr_reg,
+	int *format_code)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	case SCSI_PROTOCOL_FCP:
+		return fc_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+					format_code);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_get_pr_transport_id_len(se_tpg, se_nacl, pr_reg,
+			format_code);
+}
+
+/*
+ * Used for handling SCSI fabric dependent TransportIDs in SPC-3 and a=
bove
+ * Persistent Reservation SPEC_I_PT=3D1 and PROUT REGISTER_AND_MOVE op=
erations.
+ */
+static char *tcm_loop_parse_pr_out_transport_id(
+	struct se_portal_group *se_tpg,
+	const char *buf,
+	u32 *out_tid_len,
+	char **port_nexus_ptr)
+{
+	struct tcm_loop_tpg *tl_tpg =3D
+			(struct tcm_loop_tpg *)se_tpg->se_tpg_fabric_ptr;
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	case SCSI_PROTOCOL_FCP:
+		return fc_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	case SCSI_PROTOCOL_ISCSI:
+		return iscsi_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+					port_nexus_ptr);
+	default:
+		printk(KERN_ERR "Unknown tl_proto_id: 0x%02x, using"
+			" SAS emulation\n", tl_hba->tl_proto_id);
+		break;
+	}
+
+	return sas_parse_pr_out_transport_id(se_tpg, buf, out_tid_len,
+			port_nexus_ptr);
+}
+
+/*
+ * Returning (1) here allows for target_core_mod struct se_node_acl to=
 be generated
+ * based upon the incoming fabric dependent SCSI Initiator Port
+ */
+static int tcm_loop_check_demo_mode(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static int tcm_loop_check_demo_mode_cache(struct se_portal_group *se_t=
pg)
+{
+	return 0;
+}
+
+/*
+ * Allow I_T Nexus full READ-WRITE access without explict Initiator No=
de ACLs for
+ * local virtual Linux/SCSI LLD passthrough into VM hypervisor guest
+ */
+static int tcm_loop_check_demo_mode_write_protect(struct se_portal_gro=
up *se_tpg)
+{
+	return 0;
+}
+
+/*
+ * Because TCM_Loop does not use explict ACLs and MappedLUNs, this wil=
l
+ * never be called for TCM_Loop by target_core_fabric_configfs.c code.
+ * It has been added here as a nop for target_fabric_tf_ops_check()
+ */
+static int tcm_loop_check_prod_mode_write_protect(struct se_portal_gro=
up *se_tpg)
+{
+	return 0;
+}
+
+static struct se_node_acl *tcm_loop_tpg_alloc_fabric_acl(
+	struct se_portal_group *se_tpg)
+{
+	struct tcm_loop_nacl *tl_nacl;
+
+	tl_nacl =3D kzalloc(sizeof( struct tcm_loop_nacl), GFP_KERNEL);
+	if (!tl_nacl) {
+		printk(KERN_ERR "Unable to allocate struct tcm_loop_nacl\n");
+		return NULL;
+	}
+
+	return &tl_nacl->se_node_acl;
+}
+
+static void tcm_loop_tpg_release_fabric_acl(
+	struct se_portal_group *se_tpg,
+	struct se_node_acl *se_nacl)
+{
+	struct tcm_loop_nacl *tl_nacl =3D container_of(se_nacl,
+				struct tcm_loop_nacl, se_node_acl);
+
+	kfree(tl_nacl);
+}
+
+static u32 tcm_loop_get_inst_index(struct se_portal_group *se_tpg)
+{
+	return 1;
+}
+
+static void tcm_loop_new_cmd_failure(struct se_cmd *se_cmd)
+{
+	/*
+	 * Since TCM_loop is already passing struct scatterlist data from
+	 * struct scsi_cmnd, no more Linux/SCSI failure dependent state need
+	 * to be handled here.
+	 */
+	return;
+}
+
+static int tcm_loop_is_state_remove(struct se_cmd *se_cmd)
+{
+	/*
+	 * Assume struct scsi_cmnd is not in remove state..
+	 */
+	return 0;
+}
+
+static int tcm_loop_sess_logged_in(struct se_session *se_sess)
+{
+	/*
+	 * Assume that TL Nexus is always active
+	 */
+	return 1;
+}
+
+static u32 tcm_loop_sess_get_index(struct se_session *se_sess)
+{
+	return 1;
+}
+
+static void tcm_loop_set_default_node_attributes(struct se_node_acl *s=
e_acl)
+{
+	return;
+}
+
+static u32 tcm_loop_get_task_tag(struct se_cmd *se_cmd)
+{
+	return 1;
+}
+
+static int tcm_loop_get_cmd_state(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd =3D container_of(se_cmd,
+			struct tcm_loop_cmd, tl_se_cmd);
+
+	return tl_cmd->sc_cmd_state;
+}
+
+static int tcm_loop_shutdown_session(struct se_session *se_sess)
+{
+	return 0;
+}
+
+static void tcm_loop_close_session(struct se_session *se_sess)
+{
+	return;
+};
+
+static void tcm_loop_stop_session(
+	struct se_session *se_sess,
+	int sess_sleep,
+	int conn_sleep)
+{
+	return;
+}
+
+static void tcm_loop_fall_back_to_erl0(struct se_session *se_sess)
+{
+	return;
+}
+
+static int tcm_loop_write_pending(struct se_cmd *se_cmd)
+{
+	/*
+	 * Since Linux/SCSI has already sent down a struct scsi_cmnd
+	 * sc->sc_data_direction of DMA_TO_DEVICE with struct scatterlist arr=
ay
+	 * memory, and memory has already been mapped to struct se_cmd->t_mem=
_list
+	 * format with transport_generic_map_mem_to_cmd().
+	 *
+	 * We now tell TCM to add this WRITE CDB directly into the TCM storag=
e
+	 * object execution queue.
+	 */
+	transport_generic_process_write(se_cmd);
+	return 0;
+}
+
+static int tcm_loop_write_pending_status(struct se_cmd *se_cmd)
+{
+	return 0;
+}
+
+static int tcm_loop_queue_data_in(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd =3D container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc =3D tl_cmd->sc;
+
+	TL_CDB_DEBUG( "tcm_loop_queue_data_in() called for scsi_cmnd: %p"
+			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
+
+	sc->result =3D SAM_STAT_GOOD;
+	set_host_byte(sc, DID_OK);
+	sc->scsi_done(sc);
+	return 0;
+}
+
+static int tcm_loop_queue_status(struct se_cmd *se_cmd)
+{
+	struct tcm_loop_cmd *tl_cmd =3D container_of(se_cmd,
+				struct tcm_loop_cmd, tl_se_cmd);
+	struct scsi_cmnd *sc =3D tl_cmd->sc;
+
+	TL_CDB_DEBUG("tcm_loop_queue_status() called for scsi_cmnd: %p"
+			" cdb: 0x%02x\n", sc, sc->cmnd[0]);
+
+	if (se_cmd->sense_buffer &&
+	   ((se_cmd->se_cmd_flags & SCF_TRANSPORT_TASK_SENSE) ||
+	    (se_cmd->se_cmd_flags & SCF_EMULATED_TASK_SENSE))) {
+
+		memcpy((void *)sc->sense_buffer, (void *)se_cmd->sense_buffer,
+				SCSI_SENSE_BUFFERSIZE);=09
+		sc->result =3D SAM_STAT_CHECK_CONDITION;
+		set_driver_byte(sc, DRIVER_SENSE);
+	} else
+		sc->result =3D se_cmd->scsi_status;
+
+	set_host_byte(sc, DID_OK);
+	sc->scsi_done(sc);
+	return 0;
+}
+
+static int tcm_loop_queue_tm_rsp(struct se_cmd *se_cmd)
+{
+	struct se_tmr_req *se_tmr =3D se_cmd->se_tmr_req;
+	struct tcm_loop_tmr *tl_tmr =3D (struct tcm_loop_tmr *)se_tmr->fabric=
_tmr_ptr;
+	/*
+	 * The SCSI EH thread will be sleeping on se_tmr->tl_tmr_wait, go ahe=
ad
+	 * and wake up the wait_queue_head_t in tcm_loop_device_reset()
+	 */
+	atomic_set(&tl_tmr->tmr_complete, 1);
+	wake_up(&tl_tmr->tl_tmr_wait);
+	return 0;
+}
+
+static u16 tcm_loop_set_fabric_sense_len(struct se_cmd *se_cmd, u32 se=
nse_length)
+{
+	return 0;
+}
+
+static u16 tcm_loop_get_fabric_sense_len(void)
+{
+	return 0;
+}
+
+static u64 tcm_loop_pack_lun(unsigned int lun)
+{
+	u64 result;
+
+	/* LSB of lun into byte 1 big-endian */
+	result =3D ((lun & 0xff) << 8);
+	/* use flat space addressing method */
+	result |=3D 0x40 | ((lun >> 8) & 0x3f);
+
+	return cpu_to_le64(result);
+}
+
+static char *tcm_loop_dump_proto_id(struct tcm_loop_hba *tl_hba)
+{
+	switch (tl_hba->tl_proto_id) {
+	case SCSI_PROTOCOL_SAS:
+		return "SAS";
+	case SCSI_PROTOCOL_FCP:
+		return "FCP";
+	case SCSI_PROTOCOL_ISCSI:
+		return "iSCSI";
+	default:
+		break;
+	}
+
+	return "Unknown";
+}
+
+/* Start items for tcm_loop_port_cit */
+
+static int tcm_loop_port_link(
+	struct se_portal_group *se_tpg,
+	struct se_lun *lun)
+{
+	struct tcm_loop_tpg *tl_tpg =3D container_of(se_tpg,
+				struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+
+	atomic_inc(&tl_tpg->tl_tpg_port_count);
+	smp_mb__after_atomic_inc();
+	/*
+	 * Add Linux/SCSI struct scsi_device by HCTL
+	 */
+	scsi_add_device(tl_hba->sh, 0, tl_tpg->tl_tpgt, lun->unpacked_lun);
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Link Successful\n");
+	return 0;
+}
+
+static void tcm_loop_port_unlink(
+	struct se_portal_group *se_tpg,
+	struct se_lun *se_lun)
+{
+	struct scsi_device *sd;
+	struct tcm_loop_hba *tl_hba;
+	struct tcm_loop_tpg *tl_tpg;
+
+	tl_tpg =3D container_of(se_tpg, struct tcm_loop_tpg, tl_se_tpg);
+	tl_hba =3D tl_tpg->tl_hba;=09
+
+	sd =3D scsi_device_lookup(tl_hba->sh, 0, tl_tpg->tl_tpgt,
+				se_lun->unpacked_lun);
+	if (!sd) {
+		printk(KERN_ERR "Unable to locate struct scsi_device for %d:%d:"
+			"%d\n", 0, tl_tpg->tl_tpgt, se_lun->unpacked_lun);
+		return;
+	}
+	/*
+	 * Remove Linux/SCSI struct scsi_device by HCTL
+	 */
+	scsi_remove_device(sd);=09
+	scsi_device_put(sd);
+=09
+	atomic_dec(&tl_tpg->tl_tpg_port_count);
+	smp_mb__after_atomic_dec();
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Port Unlink Successful\n");
+}
+
+/* End items for tcm_loop_port_cit */
+
+/* Start items for tcm_loop_nexus_cit */
+
+static int tcm_loop_make_nexus(
+	struct tcm_loop_tpg *tl_tpg,
+	const char *name)
+{
+	struct se_portal_group *se_tpg;
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+	struct tcm_loop_nexus *tl_nexus;
+
+	if (tl_tpg->tl_hba->tl_nexus) {
+		printk(KERN_INFO "tl_tpg->tl_hba->tl_nexus already exists\n");
+		return -EEXIST;
+	}
+	se_tpg =3D &tl_tpg->tl_se_tpg;
+
+	tl_nexus =3D kzalloc(sizeof(struct tcm_loop_nexus), GFP_KERNEL);
+	if (!tl_nexus) {
+		printk(KERN_ERR "Unable to allocate struct tcm_loop_nexus\n");
+		return -ENOMEM;
+	}
+	/*
+	 * Initialize the struct se_session pointer
+	 */
+	tl_nexus->se_sess =3D transport_init_session();
+	if (!tl_nexus->se_sess)
+		goto out;
+	/*
+	 * Since we are running in 'demo mode' this call with generate a
+	 * struct se_node_acl for the tcm_loop struct se_portal_group with th=
e SCSI
+	 * Initiator port name of the passed configfs group 'name'.
+	 */=09
+	tl_nexus->se_sess->se_node_acl =3D core_tpg_check_initiator_node_acl(
+				se_tpg, (unsigned char *)name);
+	if (!tl_nexus->se_sess->se_node_acl) {
+		transport_free_session(tl_nexus->se_sess);
+		goto out;
+	}
+	/*
+	 * Now, register the SAS I_T Nexus as active with the call to
+	 * transport_register_session()
+	 */
+	__transport_register_session(se_tpg, tl_nexus->se_sess->se_node_acl,
+			tl_nexus->se_sess, (void *)tl_nexus);
+	tl_tpg->tl_hba->tl_nexus =3D tl_nexus;
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Established I_T Nexus to emulate=
d"
+		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
+		name);
+	return 0;
+
+out:
+	kfree(tl_nexus);=09
+	return -ENOMEM;
+}
+
+static int tcm_loop_drop_nexus(
+	struct tcm_loop_tpg *tpg)
+{
+	struct se_session *se_sess;
+	struct tcm_loop_nexus *tl_nexus;
+	struct tcm_loop_hba *tl_hba =3D tpg->tl_hba;
+
+	tl_nexus =3D tpg->tl_hba->tl_nexus;
+	if (!tl_nexus)
+		return -ENODEV;
+
+	se_sess =3D tl_nexus->se_sess;
+	if (!se_sess)
+		return -ENODEV;
+
+	if (atomic_read(&tpg->tl_tpg_port_count)) {
+		printk(KERN_ERR "Unable to remove TCM_Loop I_T Nexus with"
+			" active TPG port count: %d\n",
+			atomic_read(&tpg->tl_tpg_port_count));
+		return -EPERM;
+	}
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Removing I_T Nexus to emulated"
+		" %s Initiator Port: %s\n", tcm_loop_dump_proto_id(tl_hba),
+		tl_nexus->se_sess->se_node_acl->initiatorname);
+	/*
+	 * Release the SCSI I_T Nexus to the emulated SAS Target Port
+	 */
+	transport_deregister_session(tl_nexus->se_sess);
+	tpg->tl_hba->tl_nexus =3D NULL;
+	kfree(tl_nexus);
+	return 0;
+}
+
+/* End items for tcm_loop_nexus_cit */
+
+static ssize_t tcm_loop_tpg_show_nexus(
+	struct se_portal_group *se_tpg,
+	char *page)
+{
+	struct tcm_loop_tpg *tl_tpg =3D container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_nexus *tl_nexus;
+	ssize_t ret;
+
+	tl_nexus =3D tl_tpg->tl_hba->tl_nexus;
+	if (!tl_nexus)
+		return -ENODEV;
+
+	ret =3D snprintf(page, PAGE_SIZE, "%s\n",
+		tl_nexus->se_sess->se_node_acl->initiatorname);
+
+	return ret;
+}
+
+static ssize_t tcm_loop_tpg_store_nexus(
+	struct se_portal_group *se_tpg,
+	const char *page,
+	size_t count)
+{
+	struct tcm_loop_tpg *tl_tpg =3D container_of(se_tpg,
+			struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_hba *tl_hba =3D tl_tpg->tl_hba;
+	unsigned char i_port[TL_WWN_ADDR_LEN], *ptr, *port_ptr;
+	int ret;
+	/*
+	 * Shutdown the active I_T nexus if 'NULL' is passed..
+	 */
+	if (!strncmp(page, "NULL", 4)) {
+		ret =3D tcm_loop_drop_nexus(tl_tpg);
+		return (!ret) ? count : ret;
+	}
+	/*
+	 * Otherwise make sure the passed virtual Initiator port WWN matches
+	 * the fabric protocol_id set in tcm_loop_make_scsi_hba(), and call
+	 * tcm_loop_make_nexus()
+	 */
+	if (strlen(page) > TL_WWN_ADDR_LEN) {
+		printk(KERN_ERR "Emulated NAA Sas Address: %s, exceeds"
+				" max: %d\n", page, TL_WWN_ADDR_LEN);
+		return -EINVAL;
+	}
+	snprintf(&i_port[0], TL_WWN_ADDR_LEN, "%s", page);
+
+	ptr =3D strstr(i_port, "naa.");
+	if (ptr) {
+		if (tl_hba->tl_proto_id !=3D SCSI_PROTOCOL_SAS) {
+			printk(KERN_ERR "Passed SAS Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr =3D &i_port[0];
+		goto check_newline;
+	}
+	ptr =3D strstr(i_port, "fc.");
+	if (ptr) {
+		if (tl_hba->tl_proto_id !=3D SCSI_PROTOCOL_FCP) {
+			printk(KERN_ERR "Passed FCP Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr =3D &i_port[3]; /* Skip over "fc." */
+		goto check_newline;
+	}
+	ptr =3D strstr(i_port, "iqn.");
+	if (ptr) {
+		if (tl_hba->tl_proto_id !=3D SCSI_PROTOCOL_ISCSI) {
+			printk(KERN_ERR "Passed iSCSI Initiator Port %s does not"
+				" match target port protoid: %s\n", i_port,
+				tcm_loop_dump_proto_id(tl_hba));
+			return -EINVAL;
+		}
+		port_ptr =3D &i_port[0];
+		goto check_newline;
+	}
+	printk(KERN_ERR "Unable to locate prefix for emulated Initiator Port:=
"
+			" %s\n", i_port);
+	return -EINVAL;
+	/*
+	 * Clear any trailing newline for the NAA WWN
+	 */
+check_newline:
+	if (i_port[strlen(i_port)-1] =3D=3D '\n')
+		i_port[strlen(i_port)-1] =3D '\0';
+	=09
+	ret =3D tcm_loop_make_nexus(tl_tpg, port_ptr);
+	if (ret < 0)
+		return ret;
+
+	return count;
+}
+
+TF_TPG_BASE_ATTR(tcm_loop, nexus, S_IRUGO | S_IWUSR);
+
+static struct configfs_attribute *tcm_loop_tpg_attrs[] =3D {
+	&tcm_loop_tpg_nexus.attr,
+	NULL,
+};
+
+/* Start items for tcm_loop_naa_cit */
+
+struct se_portal_group *tcm_loop_make_naa_tpg(
+	struct se_wwn *wwn,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_loop_hba *tl_hba =3D container_of(wwn,
+			struct tcm_loop_hba, tl_hba_wwn);
+	struct tcm_loop_tpg *tl_tpg;
+	char *tpgt_str, *end_ptr;
+	int ret;
+	unsigned short int tpgt;
+
+	tpgt_str =3D strstr(name, "tpgt_");
+	if (!tpgt_str) {
+		printk(KERN_ERR "Unable to locate \"tpgt_#\" directory"
+				" group\n");
+		return ERR_PTR(-EINVAL);
+	}
+	tpgt_str +=3D 5; /* Skip ahead of "tpgt_" */
+	tpgt =3D (unsigned short int) simple_strtoul(tpgt_str, &end_ptr, 0);
+
+	if (tpgt > TL_TPGS_PER_HBA) {
+		printk(KERN_ERR "Passed tpgt: %hu exceeds TL_TPGS_PER_HBA:"
+				" %u\n", tpgt, TL_TPGS_PER_HBA);
+		return ERR_PTR(-EINVAL);
+	}
+	tl_tpg =3D &tl_hba->tl_hba_tpgs[tpgt];
+	tl_tpg->tl_hba =3D tl_hba;
+	tl_tpg->tl_tpgt =3D tpgt;
+	/*
+	 * Register the tl_tpg as a emulated SAS TCM Target Endpoint
+	 */
+	ret =3D core_tpg_register(&tcm_loop_fabric_configfs->tf_ops,
+			wwn, &tl_tpg->tl_se_tpg, (void *)tl_tpg,
+			TRANSPORT_TPG_TYPE_NORMAL);
+	if (ret < 0)
+		return ERR_PTR(-ENOMEM);
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated Emulated %s"
+		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
+		config_item_name(&wwn->wwn_group.cg_item), tpgt);
+
+	return &tl_tpg->tl_se_tpg;
+}
+
+void tcm_loop_drop_naa_tpg(
+	struct se_portal_group *se_tpg)
+{
+	struct se_wwn *wwn =3D se_tpg->se_tpg_wwn;
+	struct tcm_loop_tpg *tl_tpg =3D container_of(se_tpg,
+				struct tcm_loop_tpg, tl_se_tpg);
+	struct tcm_loop_hba *tl_hba;
+	unsigned short tpgt;
+
+	tl_hba =3D tl_tpg->tl_hba;
+	tpgt =3D tl_tpg->tl_tpgt;
+	/*
+	 * Release the I_T Nexus for the Virtual SAS link if present
+	 */
+	tcm_loop_drop_nexus(tl_tpg);
+	/*
+	 * Deregister the tl_tpg as a emulated SAS TCM Target Endpoint
+	 */
+	core_tpg_deregister(se_tpg);
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated Emulated %s"
+		" Target Port %s,t,0x%04x\n", tcm_loop_dump_proto_id(tl_hba),
+		config_item_name(&wwn->wwn_group.cg_item), tpgt);
+}
+
+/* End items for tcm_loop_naa_cit */
+
+/* Start items for tcm_loop_cit */
+
+struct se_wwn *tcm_loop_make_scsi_hba(
+	struct target_fabric_configfs *tf,
+	struct config_group *group,
+	const char *name)
+{
+	struct tcm_loop_hba *tl_hba;
+	struct Scsi_Host *sh;
+	char *ptr;
+	int ret, off =3D 0;
+
+	tl_hba =3D kzalloc(sizeof(struct tcm_loop_hba), GFP_KERNEL);
+	if (!tl_hba) {
+		printk(KERN_ERR "Unable to allocate struct tcm_loop_hba\n");
+                return ERR_PTR(-ENOMEM);
+        }
+	/*
+	 * Determine the emulated Protocol Identifier and Target Port Name
+	 * based on the incoming configfs directory name.
+	 */
+	ptr =3D strstr(name, "naa.");
+	if (ptr) {
+		tl_hba->tl_proto_id =3D SCSI_PROTOCOL_SAS;
+		goto check_len;
+	}
+	ptr =3D strstr(name, "fc.");     =20
+	if (ptr) {
+		tl_hba->tl_proto_id =3D SCSI_PROTOCOL_FCP;
+		off =3D 3; /* Skip over "fc." */
+		goto check_len;
+	}
+	ptr =3D strstr(name, "iqn.");
+	if (ptr) {
+		tl_hba->tl_proto_id =3D SCSI_PROTOCOL_ISCSI;
+		goto check_len;
+	}
+
+	printk(KERN_ERR "Unable to locate prefix for emulated Target Port:"
+			" %s\n", name);
+	return ERR_PTR(-EINVAL);
+
+check_len:
+	if (strlen(name) > TL_WWN_ADDR_LEN) {
+		printk(KERN_ERR "Emulated NAA %s Address: %s, exceeds"
+			" max: %d\n", name, tcm_loop_dump_proto_id(tl_hba),
+			TL_WWN_ADDR_LEN);
+		kfree(tl_hba);
+		return ERR_PTR(-EINVAL);
+	}
+	snprintf(&tl_hba->tl_wwn_address[0], TL_WWN_ADDR_LEN, "%s", &name[off=
]);
+
+	/*
+	 * Call device_register(tl_hba->dev) to register the emulated
+	 * Linux/SCSI LLD of type struct Scsi_Host at tl_hba->sh after
+	 * device_register() callbacks in tcm_loop_driver_probe()
+	 */
+	ret =3D tcm_loop_setup_hba_bus(tl_hba, tcm_loop_hba_no_cnt);
+	if (ret)=20
+		goto out;
+
+	sh =3D tl_hba->sh;
+	tcm_loop_hba_no_cnt++;
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Allocated emulated Target"
+		" %s Address: %s at Linux/SCSI Host ID: %d\n",
+		tcm_loop_dump_proto_id(tl_hba), name, sh->host_no);
+
+	return &tl_hba->tl_hba_wwn;
+out:
+	kfree(tl_hba);
+	return ERR_PTR(ret);
+}
+
+void tcm_loop_drop_scsi_hba(
+	struct se_wwn *wwn)
+{
+	struct tcm_loop_hba *tl_hba =3D container_of(wwn,
+				struct tcm_loop_hba, tl_hba_wwn);
+	int host_no =3D tl_hba->sh->host_no;
+	/*
+	 * Call device_unregister() on the original tl_hba->dev.
+	 * tcm_loop_fabric_scsi.c:tcm_loop_release_adapter() will
+	 * release *tl_hba;
+	 */
+	device_unregister(&tl_hba->dev);
+
+	printk(KERN_INFO "TCM_Loop_ConfigFS: Deallocated emulated Target"
+		" SAS Address: %s at Linux/SCSI Host ID: %d\n",
+		config_item_name(&wwn->wwn_group.cg_item), host_no);
+}
+
+/* Start items for tcm_loop_cit */
+static ssize_t tcm_loop_wwn_show_attr_version(
+	struct target_fabric_configfs *tf,
+	char *page)
+{
+	return sprintf(page, "TCM Loopback Fabric module %s\n", TCM_LOOP_VERS=
ION);
+}
+
+TF_WWN_ATTR_RO(tcm_loop, version);
+
+static struct configfs_attribute *tcm_loop_wwn_attrs[] =3D {
+	&tcm_loop_wwn_version.attr,
+	NULL,
+};
+
+/* End items for tcm_loop_cit */
+
+static int tcm_loop_register_configfs(void)
+{
+	struct target_fabric_configfs *fabric;
+	struct config_group *tf_cg;
+	int ret;
+	/*
+	 * Set the TCM Loop HBA counter to zero
+	 */
+	tcm_loop_hba_no_cnt =3D 0;
+	/*
+	 * Register the top level struct config_item_type with TCM core
+	 */
+	fabric =3D target_fabric_configfs_init(THIS_MODULE, "loopback");
+	if (!fabric) {
+		printk(KERN_ERR "tcm_loop_register_configfs() failed!\n");
+		return -1;
+	}
+	/*
+	 * Setup the fabric API of function pointers used by target_core_mod
+	 */
+	fabric->tf_ops.get_fabric_name =3D &tcm_loop_get_fabric_name;
+	fabric->tf_ops.get_fabric_proto_ident =3D &tcm_loop_get_fabric_proto_=
ident;
+	fabric->tf_ops.tpg_get_wwn =3D &tcm_loop_get_endpoint_wwn;
+	fabric->tf_ops.tpg_get_tag =3D &tcm_loop_get_tag;
+	fabric->tf_ops.tpg_get_default_depth =3D &tcm_loop_get_default_depth;
+	fabric->tf_ops.tpg_get_pr_transport_id =3D &tcm_loop_get_pr_transport=
_id;
+	fabric->tf_ops.tpg_get_pr_transport_id_len =3D
+					&tcm_loop_get_pr_transport_id_len;
+	fabric->tf_ops.tpg_parse_pr_out_transport_id =3D
+					&tcm_loop_parse_pr_out_transport_id;
+	fabric->tf_ops.tpg_check_demo_mode =3D &tcm_loop_check_demo_mode;
+	fabric->tf_ops.tpg_check_demo_mode_cache =3D
+					&tcm_loop_check_demo_mode_cache;
+	fabric->tf_ops.tpg_check_demo_mode_write_protect =3D
+					&tcm_loop_check_demo_mode_write_protect;
+	fabric->tf_ops.tpg_check_prod_mode_write_protect =3D
+					&tcm_loop_check_prod_mode_write_protect;
+	/*
+	 * The TCM loopback fabric module runs in demo-mode to a local
+	 * virtual SCSI device, so fabric dependent initator ACLs are
+	 * not required.
+	 */
+	fabric->tf_ops.tpg_alloc_fabric_acl =3D &tcm_loop_tpg_alloc_fabric_ac=
l;
+	fabric->tf_ops.tpg_release_fabric_acl =3D
+					&tcm_loop_tpg_release_fabric_acl;
+	fabric->tf_ops.tpg_get_inst_index =3D &tcm_loop_get_inst_index;
+	/*
+	 * Since tcm_loop is mapping physical memory from Linux/SCSI
+	 * struct scatterlist arrays for each struct scsi_cmnd I/O,
+	 * we do not need TCM to allocate a iovec array for
+	 * virtual memory address mappings
+	 */
+	fabric->tf_ops.alloc_cmd_iovecs =3D NULL;
+	/*
+	 * Used for setting up remaining TCM resources in process context
+	 */
+	fabric->tf_ops.new_cmd_map =3D &tcm_loop_new_cmd_map;
+	fabric->tf_ops.check_stop_free =3D &tcm_loop_check_stop_free;
+	fabric->tf_ops.release_cmd_to_pool =3D &tcm_loop_deallocate_core_cmd;
+	fabric->tf_ops.release_cmd_direct =3D &tcm_loop_deallocate_core_cmd;
+	fabric->tf_ops.shutdown_session =3D &tcm_loop_shutdown_session;=20
+	fabric->tf_ops.close_session =3D &tcm_loop_close_session;
+	fabric->tf_ops.stop_session =3D &tcm_loop_stop_session;
+	fabric->tf_ops.fall_back_to_erl0 =3D &tcm_loop_fall_back_to_erl0;
+	fabric->tf_ops.sess_logged_in =3D &tcm_loop_sess_logged_in;
+	fabric->tf_ops.sess_get_index =3D &tcm_loop_sess_get_index;
+	fabric->tf_ops.sess_get_initiator_sid =3D NULL;
+	fabric->tf_ops.write_pending =3D &tcm_loop_write_pending;
+	fabric->tf_ops.write_pending_status =3D &tcm_loop_write_pending_statu=
s;
+	/*
+	 * Not used for TCM loopback
+	 */
+	fabric->tf_ops.set_default_node_attributes =3D
+					&tcm_loop_set_default_node_attributes;
+	fabric->tf_ops.get_task_tag =3D &tcm_loop_get_task_tag;
+	fabric->tf_ops.get_cmd_state =3D &tcm_loop_get_cmd_state;
+	fabric->tf_ops.new_cmd_failure =3D &tcm_loop_new_cmd_failure;
+	fabric->tf_ops.queue_data_in =3D &tcm_loop_queue_data_in;
+	fabric->tf_ops.queue_status =3D &tcm_loop_queue_status;
+	fabric->tf_ops.queue_tm_rsp =3D &tcm_loop_queue_tm_rsp;
+	fabric->tf_ops.set_fabric_sense_len =3D &tcm_loop_set_fabric_sense_le=
n;
+	fabric->tf_ops.get_fabric_sense_len =3D &tcm_loop_get_fabric_sense_le=
n;
+	fabric->tf_ops.is_state_remove =3D &tcm_loop_is_state_remove;
+	fabric->tf_ops.pack_lun =3D &tcm_loop_pack_lun;
+
+	tf_cg =3D &fabric->tf_group;
+	/*
+	 * Setup function pointers for generic logic in target_core_fabric_co=
nfigfs.c
+	 */
+	fabric->tf_ops.fabric_make_wwn =3D &tcm_loop_make_scsi_hba;
+	fabric->tf_ops.fabric_drop_wwn =3D &tcm_loop_drop_scsi_hba;
+	fabric->tf_ops.fabric_make_tpg =3D &tcm_loop_make_naa_tpg;
+	fabric->tf_ops.fabric_drop_tpg =3D &tcm_loop_drop_naa_tpg;
+	/*
+	 * fabric_post_link() and fabric_pre_unlink() are used for
+	 * registration and release of TCM Loop Virtual SCSI LUNs.
+	 */
+	fabric->tf_ops.fabric_post_link =3D &tcm_loop_port_link;
+	fabric->tf_ops.fabric_pre_unlink =3D &tcm_loop_port_unlink;
+	fabric->tf_ops.fabric_make_np =3D NULL;
+	fabric->tf_ops.fabric_drop_np =3D NULL;
+	/*
+	 * Setup default attribute lists for various fabric->tf_cit_tmpl
+	 */
+	TF_CIT_TMPL(fabric)->tfc_wwn_cit.ct_attrs =3D tcm_loop_wwn_attrs;
+	TF_CIT_TMPL(fabric)->tfc_tpg_base_cit.ct_attrs =3D tcm_loop_tpg_attrs=
;
+	TF_CIT_TMPL(fabric)->tfc_tpg_attrib_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_param_cit.ct_attrs =3D NULL;
+	TF_CIT_TMPL(fabric)->tfc_tpg_np_base_cit.ct_attrs =3D NULL;
+	/*
+	 * Once fabric->tf_ops has been setup, now register the fabric for
+	 * use within TCM
+	 */
+	ret =3D target_fabric_configfs_register(fabric);
+	if (ret < 0) {
+		printk(KERN_ERR "target_fabric_configfs_register() for"
+				" TCM_Loop failed!\n");
+		target_fabric_configfs_free(fabric);
+		return -1;
+	}
+	/*
+	 * Setup our local pointer to *fabric.
+	 */
+	tcm_loop_fabric_configfs =3D fabric;
+	printk(KERN_INFO "TCM_LOOP[0] - Set fabric ->"
+			" tcm_loop_fabric_configfs\n");
+	return 0;
+}
+
+static void tcm_loop_deregister_configfs(void)
+{
+	if (!tcm_loop_fabric_configfs)
+		return;
+
+	target_fabric_configfs_deregister(tcm_loop_fabric_configfs);
+	tcm_loop_fabric_configfs =3D NULL;
+	printk(KERN_INFO "TCM_LOOP[0] - Cleared"
+				" tcm_loop_fabric_configfs\n");
+}=09
+
+static int __init tcm_loop_fabric_init(void)
+{
+	int ret;
+
+	tcm_loop_cmd_cache =3D kmem_cache_create("tcm_loop_cmd_cache",
+				sizeof(struct tcm_loop_cmd),
+				__alignof__(struct tcm_loop_cmd),
+				0, NULL);
+	if (!tcm_loop_cmd_cache) {
+		printk(KERN_ERR "kmem_cache_create() for"
+			" tcm_loop_cmd_cache failed\n");
+		return -ENOMEM;
+	}
+
+	ret =3D tcm_loop_alloc_core_bus();
+	if (ret)
+		return ret;
+
+	ret =3D tcm_loop_register_configfs();
+	if (ret) {
+		tcm_loop_release_core_bus();
+		return ret;
+	}
+
+	return 0;
+}
+
+static void __exit tcm_loop_fabric_exit(void)
+{
+	tcm_loop_deregister_configfs();
+	tcm_loop_release_core_bus();
+	kmem_cache_destroy(tcm_loop_cmd_cache);
+}
+
+MODULE_DESCRIPTION("TCM loopback virtual Linux/SCSI fabric module");
+MODULE_AUTHOR("Nicholas A. Bellinger <nab@risingtidesystems.com>");
+MODULE_LICENSE("GPL");
+module_init(tcm_loop_fabric_init);
+module_exit(tcm_loop_fabric_exit);
+
diff --git a/drivers/target/loopback/tcm_loop.h b/drivers/target/loopba=
ck/tcm_loop.h
new file mode 100644
index 0000000..7e9f7ab
--- /dev/null
+++ b/drivers/target/loopback/tcm_loop.h
@@ -0,0 +1,77 @@
+#define TCM_LOOP_VERSION		"v2.1-rc1"
+#define TL_WWN_ADDR_LEN			256
+#define TL_TPGS_PER_HBA			32
+/*
+ * Defaults for struct scsi_host_template tcm_loop_driver_template
+ *
+ * We use large can_queue and cmd_per_lun here and let TCM enforce
+ * the underlying se_device_t->queue_depth.
+ */
+#define TL_SCSI_CAN_QUEUE		1024
+#define TL_SCSI_CMD_PER_LUN		1024
+#define TL_SCSI_MAX_SECTORS		1024
+#define TL_SCSI_SG_TABLESIZE		256
+/*
+ * Used in tcm_loop_driver_probe() for struct Scsi_Host->max_cmd_len
+ */
+#define TL_SCSI_MAX_CMD_LEN		32
+
+#ifdef CONFIG_LOOPBACK_TARGET_CDB_DEBUG
+# define TL_CDB_DEBUG(x...)		printk(KERN_INFO x)
+#else
+# define TL_CDB_DEBUG(x...)
+#endif
+
+struct tcm_loop_cmd {
+	/* State of Linux/SCSI CDB+Data descriptor */
+	u32 sc_cmd_state;
+	/* Pointer to the CDB+Data descriptor from Linux/SCSI subsystem */
+	struct scsi_cmnd *sc;
+	struct list_head *tl_cmd_list;
+	/* The TCM I/O descriptor that is accessed via container_of() */
+	struct se_cmd tl_se_cmd;
+	/* Sense buffer that will be mapped into outgoing status */
+	unsigned char tl_sense_buf[TRANSPORT_SENSE_BUFFER];
+};
+
+struct tcm_loop_tmr {
+	atomic_t tmr_complete;
+	wait_queue_head_t tl_tmr_wait;
+};
+
+struct tcm_loop_nexus {
+	int it_nexus_active;
+	/*
+	 * Pointer to Linux/SCSI HBA from linux/include/scsi_host.h
+	 */
+	struct scsi_host *sh;
+	/*
+	 * Pointer to TCM session for I_T Nexus
+	 */
+	struct se_session *se_sess;
+};
+
+struct tcm_loop_nacl {
+	struct se_node_acl se_node_acl;
+};
+
+struct tcm_loop_tpg {
+	unsigned short tl_tpgt;
+	atomic_t tl_tpg_port_count;
+	struct se_portal_group tl_se_tpg;
+	struct tcm_loop_hba *tl_hba;
+};
+
+struct tcm_loop_hba {
+	u8 tl_proto_id;
+	unsigned char tl_wwn_address[TL_WWN_ADDR_LEN];
+	struct se_hba_s *se_hba;
+	struct se_lun *tl_hba_lun;
+	struct se_port *tl_hba_lun_sep;
+	struct se_device_s *se_dev_hba_ptr;
+	struct tcm_loop_nexus *tl_nexus;
+	struct device dev;
+	struct Scsi_Host *sh;
+	struct tcm_loop_tpg tl_hba_tpgs[TL_TPGS_PER_HBA];
+	struct se_wwn tl_hba_wwn;
+};
--=20
1.7.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
