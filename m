From: Christoph Hellwig <hch@lst.de>
Subject: Re: [ANNOUNCE] QLogic qla2xxx driver update available (v8.00.00b6).
Date: Mon, 17 Nov 2003 13:18:32 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031117121832.GA16528@lst.de>
References: <B179AE41C1147041AA1121F44614F0B060ED62@AVEXCH02.qlogic.org> <20031114115847.GA32664@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([212.34.189.10]:52678 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S263475AbTKQMTI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 07:19:08 -0500
Content-Disposition: inline
In-Reply-To: <20031114115847.GA32664@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Nov 14, 2003 at 12:58:47PM +0100, Christoph Hellwig wrote:
> Here's a patch to split the driver into a common qla2xxx.ko and a
> qla2?00.ko for each HBA type - the latter modules are only very small
> wrappers, mostly for the firmware images, all the meat is in the common
> qla2xxx.ko.
> 
> WARNING: the patch is only compile-tested due to lack of hardware, use
> at your own risk.

And here's another one to make the failover code optional.  It's ontop
of the previous patch

diff -uNr qla6hch/Makefile qla6nofo/Makefile
--- qla6hch/Makefile	2003-11-13 22:53:28.000000000 +0100
+++ qla6nofo/Makefile	2003-11-15 16:41:45.050000000 +0100
@@ -2,8 +2,12 @@
 EXTRA_CFLAGS += -Idrivers/scsi -DUNIQUE_FW_NAME
 
 qla2xxx-y := qla_os.o qla_init.o qla_mbx.o qla_iocb.o qla_isr.o qla_gs.o \
-	     qla_dbg.o qla_sup.o qla_rscn.o qla_xioct.o qla_inioct.o \
-	     qla_fo.o qla_cfg.o qla_cfgln.o
+	     qla_dbg.o qla_sup.o qla_rscn.o qla_xioct.o qla_inioct.o
+
+# failover code, optional
+#EXTRA_CFLAGS += -DHAVE_FAILOVER
+#qla2xxx-y += qla_fo.o qla_foln.o qla_cfg.o qla_cfgln.o
+
 qla2100-y := ql2100.o ql2100_fw.o
 qla2200-y := ql2200.o ql2200_fw.o
 qla2300-y := ql2300.o ql2300_fw.o
diff -uNr qla6hch/qla_cfg.c qla6nofo/qla_cfg.c
--- qla6hch/qla_cfg.c	2003-11-15 16:13:01.950000000 +0100
+++ qla6nofo/qla_cfg.c	2003-11-15 16:33:46.700000000 +0100
@@ -107,6 +107,11 @@
 {
 	int	rval;
 
+	if (ConfigRequired > 0)
+		mp_config_required = 1;
+	else
+		mp_config_required = 0;
+
 	ENTER("qla2x00_cfg_init");
 	set_bit(CFG_ACTIVE, &ha->cfg_flags);
 	if (!mp_initialized) {
@@ -386,7 +391,7 @@
 	DEBUG9(printk("%s(%ld): found matching ha inst %d.\n",
 	    __func__, ha->host_no, bp->HbaInstance);)
 
-	if (ha->flags.failover_enabled)
+	if (qla2x00_failover_enabled(ha)) {
 		if ((host = qla2x00_cfg_find_host(ha)) == NULL) {
 			cmd->Status = EXT_STATUS_DEV_NOT_FOUND;
 			cmd->DetailStatus = EXT_DSTATUS_HBA_INST;
@@ -397,6 +402,7 @@
 
 			return rval;
 		}
+	}
 
 	paths = (FO_PATHS_INFO *)qla2x00_kmem_zalloc(
 	    sizeof(FO_PATHS_INFO), GFP_ATOMIC, 20);
@@ -413,7 +419,7 @@
 	DEBUG9(printk("%s(%ld): found matching ha inst %d.\n",
 	    __func__, ha->host_no, bp->HbaInstance);)
 
-	if (!ha->flags.failover_enabled) {
+	if (!qla2x00_failover_enabled(ha)) {
 		/* non-fo case. There's only one path. */
 
 		mp_path_list_t	*ptmp_plist;
@@ -716,7 +722,7 @@
 		return (rval);
 	}
 
-	if (!ha->flags.failover_enabled) {
+	if (!qla2x00_failover_enabled(ha)) {
 		/* non-failover mode. nothing to be done. */
 		DEBUG9_10(printk("%s(%ld): non-failover driver mode.\n",
 		    __func__, ha->host_no);)
@@ -3017,7 +3023,7 @@
 
 	vis_host = vis_path->host;
 	if ((lq = qla2x00_lun_alloc(vis_host->ha, dp->dev_id, lun)) != NULL) {
-		qla2x00_delay_lun(vis_host->ha, lq, recoveryTime);
+		qla2x00_delay_lun(vis_host->ha, lq, ql2xrecoveryTime);
 		qla2x00_flush_failover_q(vis_host->ha, lq);
 		qla2x00_reset_lun_fo_counts(vis_host->ha, lq);
 	}
@@ -3323,48 +3329,40 @@
 }
 
 int
-qla2x00_is_fcport_in_config(scsi_qla_host_t *ha, fc_port_t *fcport)
+__qla2x00_is_fcport_in_config(scsi_qla_host_t *ha, fc_port_t *fcport)
 {
-	if (!ha->flags.failover_enabled) {
-		if (fcport->flags & FCF_PERSISTENT_BOUND)
-			return(TRUE);
-	} else {
-		mp_device_t	*dp;
-		mp_host_t	*host;
-		mp_path_t	*path;
-		mp_path_list_t	*pathlist;
-		uint16_t	dev_no;
+	mp_device_t	*dp;
+	mp_host_t	*host;
+	mp_path_t	*path;
+	mp_path_list_t	*pathlist;
+	uint16_t	dev_no;
 
-		if ((host = qla2x00_cfg_find_host(ha)) == NULL) {
-			/* no configured devices */
-			return (FALSE);
-		}
+	/* no configured devices */
+	host = qla2x00_cfg_find_host(ha);
+	if (!host)
+		return (FALSE);
 
-		for (dev_no = 0; dev_no < MAX_MP_DEVICES; dev_no++) {
-			dp = host->mp_devs[dev_no];
+	for (dev_no = 0; dev_no < MAX_MP_DEVICES; dev_no++) {
+		dp = host->mp_devs[dev_no];
 
-			if (dp == NULL)
-				continue;
+		if (dp == NULL)
+			continue;
 
-			/* Sanity check */
-			if (qla2x00_is_wwn_zero(dp->nodename))
-				continue;
+		/* Sanity check */
+		if (qla2x00_is_wwn_zero(dp->nodename))
+			continue;
 
-			if ((pathlist = dp->path_list) == NULL)
-				continue;
+		if ((pathlist = dp->path_list) == NULL)
+			continue;
 
-			path = qla2x00_find_path_by_name(host, dp->path_list,
-			    fcport->port_name);
-			if (path != NULL) {
-				/* found path for port */
-				if (path->config == TRUE) {
-					return (TRUE);
-				} else {
-					break;
-				}
-			}
+		path = qla2x00_find_path_by_name(host, dp->path_list,
+		    fcport->port_name);
+		if (path != NULL) {
+			/* found path for port */
+			if (path->config == TRUE)
+				return (TRUE);
+			break;
 		}
-
 	}
 
 	return (FALSE);
diff -uNr qla6hch/qla_def.h qla6nofo/qla_def.h
--- qla6hch/qla_def.h	2003-11-13 22:21:17.000000000 +0100
+++ qla6nofo/qla_def.h	2003-11-15 16:26:38.330000000 +0100
@@ -2229,7 +2229,6 @@
 		// UNUSED and UNASSIGNED
 		uint32_t     port_name_used          :1;   /* 4 */
 
-		uint32_t     failover_enabled        :1;   /* 5 */
 		uint32_t     watchdog_enabled        :1;   /* 6 */
 		uint32_t     cfg_suspended   	     :1;   /* 7 */
 
@@ -2501,8 +2500,7 @@
  */
 #define FLASH_IMAGE_SIZE	131072
 
-#include "qla_fo.h"
-#include "qla_cfg.h"
+#include "qla_foln.h"
 #include "qla_gbl.h"
 #include "qla_dbg.h"
 #include "qla_inline.h"
diff -uNr qla6hch/qla_fo.c qla6nofo/qla_fo.c
--- qla6hch/qla_fo.c	2003-11-13 22:19:46.000000000 +0100
+++ qla6nofo/qla_fo.c	2003-11-15 16:27:39.830000000 +0100
@@ -230,7 +230,7 @@
 	DEBUG4(printk("%s: hba %p, buff %p bp->HbaInstance(%x).\n",
 	    __func__, ha, bp, (int)bp->HbaInstance));
 
-	if (ha->flags.failover_enabled) {
+	if (qla2x00_failover_enabled(ha)) {
 		if ((host = qla2x00_cfg_find_host(ha)) == NULL) {
 			if (list_empty(&ha->fcports)) {
 				DEBUG2_9_10(printk(
@@ -353,7 +353,7 @@
 	u_entry = &u_list->DataEntry[0];
 
 	/* find the correct fcport list */
-	if (!ha->flags.failover_enabled)
+	if (!qla2x00_failover_enabled(ha))
 		fcports = &ha->fcports;
 	else
 		fcports = host->fcports;
@@ -428,7 +428,7 @@
 			continue;
 		}
 
-		if (!ha->flags.failover_enabled) {
+		if (!qla2x00_failover_enabled(ha)) {
 			/*
 			 * Failover disabled. Just return LUN mask info
 			 * in lun data entry of this port.
@@ -684,13 +684,14 @@
 	DEBUG9(printk("%s: ha inst %ld, buff %p.\n",
 	    __func__, ha->instance, bp);)
 
-	if (ha->flags.failover_enabled)
+	if (qla2x00_failover_enabled(ha)) {
 		if ((host = qla2x00_cfg_find_host(ha)) == NULL) {
 			DEBUG2_9_10(printk("%s: no HOST for ha inst %ld.\n",
 			    __func__, ha->instance);)
 			pext->Status = EXT_STATUS_DEV_NOT_FOUND;
 			return (ret);
 		}
+	}
 
 	list = (FO_LUN_DATA_LIST *)qla2x00_kmem_zalloc(
 	    sizeof(FO_LUN_DATA_LIST), GFP_ATOMIC, 13);
@@ -757,7 +758,7 @@
 			break;
 		}
 
-		if (!ha->flags.failover_enabled) {
+		if (!qla2x00_failover_enabled(ha)) {
 			/*
 			 * Failover disabled. Just find the port and set
 			 * LUN mask values in lun_mask field of this port.
@@ -876,7 +877,7 @@
 	DEBUG9(printk("%s: ha inst %ld, buff %p.\n",
 	    __func__, ha->instance, bp);)
 
-	if (ha->flags.failover_enabled)
+	if (qla2x00_failover_enabled(ha)) {
 		if ((host = qla2x00_cfg_find_host(ha)) == NULL &&
 		    list_empty(&ha->fcports)) {
 			DEBUG2_9_10(printk("%s: no HOST for ha inst %ld.\n",
@@ -884,6 +885,7 @@
 			pext->Status = EXT_STATUS_DEV_NOT_FOUND;
 			return (ret);
 		}
+	}
 
 	if ((entry = (FO_DEVICE_DATA *)kmalloc(sizeof(FO_DEVICE_DATA),
 	    GFP_ATOMIC)) == NULL) {
@@ -894,7 +896,7 @@
 	}
 
 	/* Return data accordingly. */
-	if (!ha->flags.failover_enabled)
+	if (!qla2x00_failover_enabled(ha))
 		ret = qla2x00_std_get_tgt(ha, pext, entry);
 	else
 		ret = qla2x00_fo_get_tgt(host, ha, pext, entry);
@@ -1464,7 +1466,7 @@
 	DEBUG9(printk("%s: ha inst %ld, buff %p.\n",
 	    __func__, ha->instance, bp);)
 
-	if (!ha->flags.failover_enabled)
+	if (!qla2x00_failover_enabled(ha))
 		/* non-failover mode. nothing to be done. */
 		return 0;
 
@@ -2318,12 +2320,7 @@
 uint8_t
 qla2x00_fo_enabled(scsi_qla_host_t *ha, int instance)
 {
-	uint8_t enable = FALSE;
-
-	if (ha->flags.failover_enabled)
-		enable = TRUE;
-
-	return enable;
+	return qla2x00_failover_enabled(ha);
 }
 
 /*
diff -uNr qla6hch/qla_foln.c qla6nofo/qla_foln.c
--- qla6hch/qla_foln.c	1970-01-01 01:00:00.000000000 +0100
+++ qla6nofo/qla_foln.c	2003-11-15 16:39:16.560000000 +0100
@@ -0,0 +1,294 @@
+/********************************************************************************
+*                  QLOGIC LINUX SOFTWARE
+*
+* QLogic ISP2x00 device driver for Linux 2.6.x
+* Copyright (C) 2003 QLogic Corporation
+* (www.qlogic.com)
+*
+* This program is free software; you can redistribute it and/or modify it
+* under the terms of the GNU General Public License as published by the
+* Free Software Foundation; either version 2, or (at your option) any
+* later version.
+*
+* This program is distributed in the hope that it will be useful, but
+* WITHOUT ANY WARRANTY; without even the implied warranty of
+* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+* General Public License for more details.
+*
+******************************************************************************/
+
+#include "qla_os.h"
+#include "qla_def.h"
+
+
+int ql2xfailover = 0;
+module_param(ql2xfailover, int, 0);
+MODULE_PARM_DESC(ql2xfailover,
+		"Driver failover support: 0 to disable; 1 to enable.");
+
+int ql2xrecoveryTime = MAX_RECOVERYTIME;
+module_param_named(recoveryTime, ql2xrecoveryTime, int, 0);
+MODULE_PARM_DESC(recoveryTime,
+		"Recovery time in seconds before a target device is sent I/O "
+		"after a failback is performed.");
+
+int ql2xfailbackTime = MAX_FAILBACKTIME;
+module_param_named(failbackTime, ql2xfailbackTime, int, 0);
+MODULE_PARM_DESC(failbackTime,
+		"Delay in seconds before a failback is performed.");
+
+
+/*
+ * qla2x00_check_for_devices_online
+ *
+ *	Check fcport state of all devices to make sure online.
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *
+ * Return:
+ *	None.
+ *
+ * Context:
+ */
+static uint8_t
+qla2x00_check_for_devices_online(scsi_qla_host_t *ha) 
+{
+	fc_port_t	*fcport;
+
+	list_for_each_entry(fcport, &ha->fcports, list) {
+		if ((atomic_read(&fcport->state) == FCS_ONLINE) ||
+		    (atomic_read(&fcport->state) == FCS_DEVICE_DEAD))
+			continue;
+		return 0;
+	}
+
+	return 1;
+}
+
+/*
+ *  qla2x00_failover_cleanup
+ *	Cleanup queues after a failover.
+ *
+ * Input:
+ *	sp = command pointer
+ *
+ * Context:
+ *	Interrupt context.
+ */
+static void
+qla2x00_failover_cleanup(srb_t *sp) 
+{
+	sp->cmd->result = DID_BUS_BUSY << 16;
+	sp->cmd->host_scribble = (unsigned char *) NULL;
+
+	/* turn-off all failover flags */
+	sp->flags = sp->flags & ~(SRB_RETRY|SRB_FAILOVER|SRB_FO_CANCEL);
+}
+
+
+/*
+ *  qla2x00_process_failover
+ *	Process any command on the failover queue.
+ *
+ * Input:
+ *	ha = adapter block pointer.
+ *
+ * Context:
+ *	Interrupt context.
+ */
+static void
+qla2x00_process_failover(scsi_qla_host_t *ha) 
+{
+
+	os_tgt_t	*tq;
+	os_lun_t	*lq;
+	srb_t       *sp;
+	fc_port_t *fcport;
+	struct list_head *list, *temp;
+	unsigned long flags;
+	unsigned int	t, l;
+	scsi_qla_host_t *vis_ha = NULL;
+
+	DEBUG(printk("scsi(%ld): Processing failover for hba.\n", ha->host_no));
+
+	/*
+	 * Process all the commands in the failover queue. Attempt to failover
+	 * then either complete the command as is or requeue for retry.
+	 */
+
+	/* Prevent or allow acceptance of new I/O requests. */
+	spin_lock_irqsave(&ha->list_lock, flags);
+
+	/*
+	 * Get first entry to find our visible adapter.  We could never get
+	 * here if the list is empty
+	 */
+	list = ha->failover_queue.next;
+	sp = list_entry(list, srb_t, list);
+	vis_ha = (scsi_qla_host_t *) sp->cmd->device->host->hostdata;
+	list_for_each_safe(list, temp, &ha->failover_queue) {
+		sp = list_entry(list, srb_t, list);
+
+		tq = sp->tgt_queue;
+		lq = sp->lun_queue;
+		fcport = lq->fclun->fcport;
+
+		/* Remove srb from failover queue. */
+		__del_from_failover_queue(ha, sp);
+
+		DEBUG2(printk("%s(): pid %ld retrycnt=%d\n",
+		    __func__, sp->cmd->serial_number, sp->cmd->retries));
+
+		/*** Select an alternate path ***/
+		/* 
+		 * If the path has already been change by a previous request
+		 * sp->fclun != lq->fclun
+		 */
+		if (sp->fclun != lq->fclun ||
+		    atomic_read(&fcport->state) != FCS_DEVICE_DEAD) {
+
+			qla2x00_failover_cleanup(sp);
+
+		} else if (qla2x00_cfg_failover(ha, lq->fclun, tq, sp) ==
+		    NULL) {
+			/*
+			 * We ran out of paths, so just post the status which
+			 * is already set in the cmd.
+			 */
+			printk(KERN_INFO
+			    "scsi(%ld): Ran out of paths - pid %ld\n",
+			    ha->host_no, sp->cmd->serial_number);
+		} else {
+			qla2x00_failover_cleanup(sp);
+
+		}
+		__add_to_done_queue(ha, sp);
+	} /* list_for_each_safe */
+	spin_unlock_irqrestore(&ha->list_lock, flags);
+
+	for (t = 0; t < vis_ha->max_targets; t++) {
+		if ((tq = vis_ha->otgt[t]) == NULL)
+			continue;
+		for (l = 0; l < vis_ha->max_luns; l++) {
+			if ((lq = (os_lun_t *) tq->olun[l]) == NULL)
+				continue;
+
+			if( test_and_clear_bit(LUN_MPIO_BUSY, &lq->q_flag) ) {
+				/* EMPTY */
+				DEBUG(printk("scsi(%ld): remove suspend for "
+				    "lun %d\n", ha->host_no, lq->fclun->lun));
+			}
+		}
+	}
+
+	//qla2x00_restart_queues(ha,TRUE);
+	qla2x00_restart_queues(ha, FALSE);
+
+	DEBUG(printk("%s() - done", __func__));
+}
+
+int
+qla2x00_search_failover_queue(scsi_qla_host_t *ha, struct scsi_cmnd *cmd)
+{
+	struct list_head *list, *temp;
+	unsigned long flags;
+	srb_t *sp;
+
+	DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in "
+				"failover queue.\n", sp);)
+
+	spin_lock_irqsave(&ha->list_lock, flags);
+	list_for_each_safe(list, temp, &ha->failover_queue) {
+		sp = list_entry(list, srb_t, list);
+
+		if (cmd == sp->cmd)
+			goto found;
+
+	}
+	spin_unlock_irqrestore(&ha->list_lock, flags);
+
+	return 0;
+
+ found:
+	/* Remove srb from failover queue. */
+	__del_from_failover_queue(ha, sp);
+	cmd->result = DID_ABORT << 16;
+	__add_to_done_queue(ha, sp);
+
+	spin_unlock_irqrestore(&ha->list_lock, flags);
+	return 1;
+}
+
+/*
+ * If we are not processing a ioctl or one of
+ * the ports are still MISSING or need a resync
+ * then process the failover event.
+ */  
+void
+qla2x00_process_failover_event(scsi_qla_host_t *ha)
+{
+	if (test_bit(CFG_ACTIVE, &ha->cfg_flags))
+		return;
+	if (qla2x00_check_for_devices_online(ha)) {
+		if (test_and_clear_bit(FAILOVER_EVENT, &ha->dpc_flags)) {
+			if (ha->flags.online)
+				qla2x00_cfg_event_notify(ha, ha->failover_type);
+		}
+	}
+
+	/*
+	 * Get any requests from failover queue
+	 */
+	if (test_and_clear_bit(FAILOVER_NEEDED, &ha->dpc_flags))
+		qla2x00_process_failover(ha);
+}
+
+int
+qla2x00_do_fo_check(scsi_qla_host_t *ha, srb_t *sp, scsi_qla_host_t *vis_ha)
+{
+	/*
+	 * This routine checks for DID_NO_CONNECT to decide
+	 * whether to failover to another path or not. We only
+	 * failover on that status.
+	 */
+	if (!qla2x00_fo_check(ha, sp))
+		return 0;
+
+	if ((sp->state != SRB_FAILOVER_STATE)) {
+		/*
+		 * Retry the command on this path
+		 * several times before selecting a new
+		 * path.
+		 */
+		add_to_pending_queue_head(vis_ha, sp);
+		qla2x00_next(vis_ha);
+	} else
+		qla2x00_extend_timeout(sp->cmd, EXTEND_CMD_TIMEOUT);
+
+	return 1;
+}
+
+void
+qla2xxx_start_all_adapters(scsi_qla_host_t *ha)
+{
+	struct list_head *hal;
+	scsi_qla_host_t *vis_ha;
+
+	/* Try and start all visible adapters */
+	read_lock(&qla_hostlist_lock);
+	list_for_each(hal, &qla_hostlist) {
+		vis_ha = list_entry(hal, scsi_qla_host_t, list);
+
+		if (!list_empty(&vis_ha->pending_queue))
+			qla2x00_next(vis_ha);
+
+		DEBUG2(printk("host(%ld):Commands busy=%d "
+				"failed=%d\neh_active=%d\n ",
+				vis_ha->host_no,
+				vis_ha->host->host_busy,
+				vis_ha->host->host_failed,
+				vis_ha->host->eh_active);)	
+	}
+	read_unlock(&qla_hostlist_lock);
+}
diff -uNr qla6hch/qla_foln.h qla6nofo/qla_foln.h
--- qla6hch/qla_foln.h	1970-01-01 01:00:00.000000000 +0100
+++ qla6nofo/qla_foln.h	2003-11-15 16:37:00.800000000 +0100
@@ -0,0 +1,119 @@
+/******************************************************************************
+ *                  QLOGIC LINUX SOFTWARE
+ *
+ * QLogic ISP2x00 device driver for Linux 2.6.x
+ * Copyright (C) 2003 QLogic Corporation
+ * (www.qlogic.com)
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms of the GNU General Public License as published by the
+ * Free Software Foundation; either version 2, or (at your option) any
+ * later version.
+ *
+ * This program is distributed in the hope that it will be useful, but
+ * WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ * General Public License for more details.
+ *
+ ******************************************************************************/
+
+#ifndef __QLA_FOLN_H
+#define	__QLA_FOLN_H
+
+#ifdef HAVE_FAILOVER
+
+#include "qla_fo.h"
+#include "qla_cfg.h"
+
+/*
+ * Global Data in qla_fo.c source file.
+ */
+extern SysFoParams_t qla_fo_params;
+
+/*
+ * Global Function Prototypes in qla_fo.c source file.
+ */
+extern scsi_qla_host_t *qla2x00_get_hba(unsigned long);
+extern uint32_t qla2x00_send_fo_notification(fc_lun_t *fclun_p, fc_lun_t *olun_p);
+extern void qla2x00_fo_init_params(scsi_qla_host_t *ha);
+extern uint8_t qla2x00_fo_enabled(scsi_qla_host_t *ha, int instance);
+extern int qla2x00_fo_ioctl(scsi_qla_host_t *, int, EXT_IOCTL *, int);
+
+extern int qla2x00_fo_missing_port_summary(scsi_qla_host_t *,
+    EXT_DEVICEDATAENTRY *, void *, uint32_t, uint32_t *, uint32_t *);
+
+/*
+ * Global Data in qla_cfg.c source file.
+ */
+extern mp_host_t  *mp_hosts_base;
+extern uint8_t   mp_config_required;
+/*
+ * Global Function Prototypes in qla_cfg.c source file.
+ */
+extern mp_host_t * qla2x00_cfg_find_host(scsi_qla_host_t *);
+extern uint8_t qla2x00_is_portname_in_device(mp_device_t *, uint8_t *);
+extern int qla2x00_cfg_path_discovery(scsi_qla_host_t *ha);
+extern int qla2x00_cfg_event_notify(scsi_qla_host_t *ha, uint32_t i_type);
+extern fc_lun_t *qla2x00_cfg_failover(scsi_qla_host_t *ha, fc_lun_t *fp,
+					      os_tgt_t *tgt, srb_t *sp);
+extern int qla2x00_cfg_get_paths( EXT_IOCTL *, FO_GET_PATHS *, int);
+extern int qla2x00_cfg_set_current_path( EXT_IOCTL *,
+			FO_SET_CURRENT_PATH *, int);
+extern void qla2x00_fo_properties(scsi_qla_host_t *ha);
+extern mp_host_t * qla2x00_add_mp_host(uint8_t *);
+extern mp_host_t * qla2x00_alloc_host(scsi_qla_host_t *);
+extern uint8_t qla2x00_fo_check(scsi_qla_host_t *ha, srb_t *sp);
+extern mp_path_t *qla2x00_find_path_by_name(mp_host_t *, mp_path_list_t *,
+			uint8_t *name);
+
+extern int __qla2x00_is_fcport_in_config(scsi_qla_host_t *, fc_port_t *);
+extern int qla2x00_cfg_init(scsi_qla_host_t *ha);
+extern void qla2x00_cfg_mem_free(scsi_qla_host_t *ha);
+
+/*
+ * Global Function Prototypes in qla_cfgln.c source file.
+ */
+extern void qla2x00_cfg_build_path_tree( scsi_qla_host_t *ha);
+extern uint8_t qla2x00_update_mp_device(mp_host_t *,
+    fc_port_t  *, uint16_t, uint16_t);
+extern void qla2x00_cfg_display_devices(void);
+
+
+/*
+ * Global Function Prototypes in qla_foln.c source file.
+ */
+extern int qla2x00_search_failover_queue(scsi_qla_host_t *, struct scsi_cmnd *);
+extern void qla2x00_process_failover_event(scsi_qla_host_t *);
+extern int qla2x00_do_fo_check(scsi_qla_host_t *, srb_t *, scsi_qla_host_t *);
+extern void qla2xxx_start_all_adapters(scsi_qla_host_t *);
+
+extern int ql2xrecoveryTime;
+extern int ql2xfailbackTime;
+extern int ql2xfailover;
+#define qla2x00_failover_enabled(ha)				(ql2xfailover)
+
+#else
+#define __qla2x00_is_fcport_in_config(ha, fcport)		(0)
+#define qla2x00_fo_missing_port_summary(ha, e, s, m, c, r)	(0)
+/* qla2x00_cfg_init() is declared int but the retval isn't checked.. */
+#define qla2x00_cfg_init(ha)					do { } while (0)
+#define qla2x00_cfg_mem_free(ha)				do { } while (0)
+#define qla2x00_cfg_display_devices()				do { } while (0)
+#define qla2x00_process_failover_event(ha)			do { } while (0)
+#define qla2xxx_start_all_adapters(ha)				do { } while (0)
+#define qla2x00_search_failover_queue(ha, cmd)			(0)
+#define qla2x00_do_fo_check(ha, sp, vis_ha)			(0)
+#define qla2x00_failover_enabled(ha)				(0)
+#endif /* HAVE_FAILOVER */
+
+static __inline int
+qla2x00_is_fcport_in_config(scsi_qla_host_t *ha, fc_port_t *fcport)
+{
+	if (qla2x00_failover_enabled(ha))
+		return __qla2x00_is_fcport_in_config(ha, fcport);
+	else if (fcport->flags & FCF_PERSISTENT_BOUND)
+		return 1;
+	return 0;
+}
+
+#endif /* __QLA_FOLN_H */
diff -uNr qla6hch/qla_gbl.h qla6nofo/qla_gbl.h
--- qla6hch/qla_gbl.h	2003-11-13 21:54:58.000000000 +0100
+++ qla6nofo/qla_gbl.h	2003-11-15 16:36:46.130000000 +0100
@@ -70,11 +70,7 @@
 extern int ql2xplogiabsentdevice;
 extern int ql2xintrdelaytimer;
 
-extern int ql2xfailover;
-
 extern int ConfigRequired;
-extern int recoveryTime;
-extern int failbackTime;
 
 extern int Bind;
 extern int ql2xsuspendcount;
@@ -260,60 +256,9 @@
 #endif
 
 /*
- * Global Data in qla_fo.c source file.
- */
-extern SysFoParams_t qla_fo_params;
-
-/*
- * Global Function Prototypes in qla_fo.c source file.
- */
-extern scsi_qla_host_t *qla2x00_get_hba(unsigned long);
-extern uint32_t qla2x00_send_fo_notification(fc_lun_t *fclun_p, fc_lun_t *olun_p);
-extern void qla2x00_fo_init_params(scsi_qla_host_t *ha);
-extern uint8_t qla2x00_fo_enabled(scsi_qla_host_t *ha, int instance);
-
-/*
- * Global Data in qla_cfg.c source file.
- */
-extern mp_host_t  *mp_hosts_base;
-extern uint8_t   mp_config_required;
-/*
- * Global Function Prototypes in qla_cfg.c source file.
- */
-extern mp_host_t * qla2x00_cfg_find_host(scsi_qla_host_t *);
-extern uint8_t qla2x00_is_portname_in_device(mp_device_t *, uint8_t *);
-extern int qla2x00_cfg_init (scsi_qla_host_t *ha);
-extern int qla2x00_cfg_path_discovery(scsi_qla_host_t *ha);
-extern int qla2x00_cfg_event_notify(scsi_qla_host_t *ha, uint32_t i_type);
-extern fc_lun_t *qla2x00_cfg_failover(scsi_qla_host_t *ha, fc_lun_t *fp,
-					      os_tgt_t *tgt, srb_t *sp);
-extern int qla2x00_cfg_get_paths( EXT_IOCTL *, FO_GET_PATHS *, int);
-extern int qla2x00_cfg_set_current_path( EXT_IOCTL *,
-			FO_SET_CURRENT_PATH *, int);
-extern void qla2x00_fo_properties(scsi_qla_host_t *ha);
-extern mp_host_t * qla2x00_add_mp_host(uint8_t *);
-extern void qla2x00_cfg_mem_free(scsi_qla_host_t *ha);
-extern mp_host_t * qla2x00_alloc_host(scsi_qla_host_t *);
-extern uint8_t qla2x00_fo_check(scsi_qla_host_t *ha, srb_t *sp);
-extern mp_path_t *qla2x00_find_path_by_name(mp_host_t *, mp_path_list_t *,
-			uint8_t *name);
-extern int qla2x00_is_fcport_in_config(scsi_qla_host_t *, fc_port_t *);
-
-/*
- * Global Function Prototypes in qla_cfgln.c source file.
- */
-extern void qla2x00_cfg_build_path_tree( scsi_qla_host_t *ha);
-extern uint8_t qla2x00_update_mp_device(mp_host_t *,
-    fc_port_t  *, uint16_t, uint16_t);
-extern void qla2x00_cfg_display_devices(void);
-
-/*
  * Global Function Prototypes in qla_xioctl.c source file.
  */
 extern void qla2x00_enqueue_aen(scsi_qla_host_t *, uint16_t, void *);
-extern int qla2x00_fo_ioctl(scsi_qla_host_t *, int, EXT_IOCTL *, int);
-extern int qla2x00_fo_missing_port_summary(scsi_qla_host_t *,
-    EXT_DEVICEDATAENTRY *, void *, uint32_t, uint32_t *, uint32_t *);
 extern int qla2x00_alloc_ioctl_mem(scsi_qla_host_t *);
 extern void qla2x00_free_ioctl_mem(scsi_qla_host_t *);
 extern int qla2x00_get_ioctl_scrap_mem(scsi_qla_host_t *, void **, uint32_t);
diff -uNr qla6hch/qla_init.c qla6nofo/qla_init.c
--- qla6hch/qla_init.c	2003-11-13 22:17:25.000000000 +0100
+++ qla6nofo/qla_init.c	2003-11-15 16:36:37.880000000 +0100
@@ -143,7 +143,7 @@
 	 */
 	if (ql2xdevconf) {
 		ha->cmdline = ql2xdevconf;
-		if (!ha->flags.failover_enabled)
+		if (!qla2x00_failover_enabled(ha))
 			qla2x00_get_properties(ha, ql2xdevconf);
 	}
 
@@ -1585,23 +1585,24 @@
 	if (!atomic_read(&ha->loop_down_timer) &&
 	    !(test_bit(LOOP_RESYNC_NEEDED, &ha->dpc_flags))) {
 
-		if (!ha->flags.failover_enabled)
+		if (!qla2x00_failover_enabled(ha))
 			qla2x00_config_os(ha);
 
 		/* If we found all devices then go ready */
 		if (!(test_bit(LOGIN_RETRY_NEEDED, &ha->dpc_flags))) {
 			ha->loop_state = LOOP_READY;
 
-			if (ha->flags.failover_enabled) {
+#ifdef HAVE_FAILOVER
+			if (qla2x00_failover_enabled(ha)) {
 				DEBUG(printk("scsi(%ld): schedule FAILBACK "
 				    "EVENT\n", ha->host_no));
 				if (!(test_and_set_bit(FAILOVER_EVENT_NEEDED,
 				    &ha->dpc_flags))) {
-					ha->failback_delay = failbackTime;
+					ha->failback_delay = ql2xfailbackTime;
 				}
 				ha->failover_type = MP_NOTIFY_LOOP_UP;
 			}
-
+#endif
 			DEBUG(printk("scsi(%ld): LOOP READY\n", ha->host_no));
 		} else {
 			if (test_bit(LOCAL_LOOP_UPDATE, &save_flags))
@@ -3113,9 +3114,6 @@
 	int		pending_q_cnt = 0;
 	struct list_head *list, *temp;
 	unsigned long flags = 0;
-	struct list_head *hal;
-	scsi_qla_host_t *vis_ha;
-
 
 	ENTER(__func__);
 
@@ -3176,25 +3174,8 @@
 			ha->failover_cnt,
 			ha->scsi_retry_q_cnt);)
 
-	if (ha->flags.failover_enabled) {
-		/* Try and start all visible adapters */
-		read_lock(&qla_hostlist_lock);
-		list_for_each(hal, &qla_hostlist) {
-			vis_ha = list_entry(hal, scsi_qla_host_t, list);
-
-			if (!list_empty(&vis_ha->pending_queue))
-				qla2x00_next(vis_ha);
-
-			DEBUG2(printk("host(%ld):Commands busy=%d "
-					"failed=%d\neh_active=%d\n ",
-					vis_ha->host_no,
-					vis_ha->host->host_busy,
-					vis_ha->host->host_failed,
-					vis_ha->host->eh_active);)	
-		}
-		read_unlock(&qla_hostlist_lock);
-	}
-
+	if (qla2x00_failover_enabled(ha))
+		qla2xxx_start_all_adapters(ha);
 	if (!list_empty(&ha->done_queue))
 		qla2x00_done(ha);
 
@@ -3353,7 +3334,7 @@
 		tq->flags |= TQF_ONLINE;
 		tq->port_down_retry_count = ha->port_down_retry_count;
 
-		if (!ha->flags.failover_enabled)
+		if (!qla2x00_failover_enabled(ha))
 			qla2x00_get_lun_mask_from_config(ha, fcport, tgt, 0);
 	}
 
diff -uNr qla6hch/qla_os.c qla6nofo/qla_os.c
--- qla6hch/qla_os.c	2003-11-13 21:56:37.000000000 +0100
+++ qla6nofo/qla_os.c	2003-11-15 16:38:20.500000000 +0100
@@ -44,11 +44,7 @@
  */
 
 char *ql2xdevconf = NULL;
-#if MPIO_SUPPORT
-int ql2xretrycount = 30;
-#else
 int ql2xretrycount = 20;
-#endif
 int qla2xenbinq = 1;
 int ql2xlogintimeout = 20;
 int qlport_down_retry = 0;
@@ -58,15 +54,7 @@
 int ql2xintrdelaytimer = 10;
 
 /* Enable for failover */
-#if MPIO_SUPPORT
-int ql2xfailover = 1;
-#else
-int ql2xfailover = 0;
-#endif
-
 int ConfigRequired = 0;
-int recoveryTime = MAX_RECOVERYTIME;
-int failbackTime = MAX_FAILBACKTIME;
 
 /* Persistent binding type */
 int Bind = BIND_BY_PORT_NAME;
@@ -85,12 +73,6 @@
 MODULE_PARM_DESC(ql2xopts,
 		"Additional driver options.");
 
-MODULE_PARM(ql2xfailover, "i");
-MODULE_PARM_DESC(ql2xfailover,
-		"Driver failover support: 0 to disable; 1 to enable. "
-		"Default behaviour based on compile-time option "
-		"MPIO_SUPPORT.");
-
 MODULE_PARM(ql2xmaxqdepth, "i");
 MODULE_PARM_DESC(ql2xmaxqdepth,
 		"Maximum queue depth to report for target devices.");
@@ -107,13 +89,12 @@
 MODULE_PARM(ql2xretrycount,"i");
 MODULE_PARM_DESC(ql2xretrycount,
 		"Maximum number of mid-layer retries allowed for a command.  "
-		"Default value in non-failover mode is 20, "
-		"in failover mode, 30.");
+		"Default value is 20, ");
 
 MODULE_PARM(displayConfig, "i");
 MODULE_PARM_DESC(displayConfig,
-		"If 1 then display the configuration used in "
-		"/etc/modules.conf.");
+		"If 1 then display the configuration used in /etc/modules.conf.");
+
 MODULE_PARM(ql2xplogiabsentdevice, "i");
 MODULE_PARM_DESC(ql2xplogiabsentdevice,
 		"Option to enable PLOGI to devices that are not present after "
@@ -130,15 +111,6 @@
 		"If 1, then only configured devices passed in through the"
 		"ql2xopts parameter will be presented to the OS");
 
-MODULE_PARM(recoveryTime, "i");
-MODULE_PARM_DESC(recoveryTime,
-		"Recovery time in seconds before a target device is sent I/O "
-		"after a failback is performed.");
-
-MODULE_PARM(failbackTime, "i");
-MODULE_PARM_DESC(failbackTime,
-		"Delay in seconds before a failback is performed.");
-
 MODULE_PARM(Bind, "i");
 MODULE_PARM_DESC(Bind,
 		"Target persistent binding method: "
@@ -495,12 +467,9 @@
 }
 
 static int qla2x00_do_dpc(void *data);
-static uint8_t qla2x00_check_for_devices_online(scsi_qla_host_t *);
 
 static void qla2x00_rst_aen(scsi_qla_host_t *);
 
-static void qla2x00_process_failover(scsi_qla_host_t *);
-
 static uint8_t qla2x00_mem_alloc(scsi_qla_host_t *);
 static void qla2x00_mem_free(scsi_qla_host_t *ha);
 int qla2x00_allocate_sp_pool( scsi_qla_host_t *ha);
@@ -1085,7 +1054,6 @@
 	return (return_status);	
 }
 
-
 /**************************************************************************
 * qla2xxx_eh_abort
 *
@@ -1140,7 +1108,7 @@
 	}
 
 	vis_ha = (scsi_qla_host_t *) cmd->device->host->hostdata;
-	if (vis_ha->flags.failover_enabled)
+	if (qla2x00_failover_enabled(vis_ha))
 		/* Get Actual HA pointer */
 		ha = (scsi_qla_host_t *)sp->ha;
 	else
@@ -1222,66 +1190,40 @@
 	/*
 	 * See if this command is in the retry queue
 	 */
-	if (!found) {
-		DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in retry "
+	DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in retry "
 		    "queue.\n", sp);)
 
-		spin_lock_irqsave(&ha->list_lock, flags);
-		list_for_each_safe(list, temp, &ha->retry_queue) {
-			rp = list_entry(list, srb_t, list);
+	spin_lock_irqsave(&ha->list_lock, flags);
+	list_for_each_safe(list, temp, &ha->retry_queue) {
+		rp = list_entry(list, srb_t, list);
 
-			if (cmd != rp->cmd)
-				continue;
+		if (cmd != rp->cmd)
+			continue;
 
 
-			DEBUG2(printk("qla2xxx_eh_abort: found "
-			    "in retry queue. SP=%p\n", sp);)
+		DEBUG2(printk("qla2xxx_eh_abort: found "
+		    "in retry queue. SP=%p\n", sp);)
 
-			__del_from_retry_queue(ha, rp);
-			cmd->result = DID_ABORT << 16;
-			__add_to_done_queue(ha, rp);
+		__del_from_retry_queue(ha, rp);
+		cmd->result = DID_ABORT << 16;
+		__add_to_done_queue(ha, rp);
 
-			return_status = SUCCESS;
-			found++;
+		return_status = SUCCESS;
+		found++;
 
-			break;
+		break;
 
-		} /* list_for_each_safe() */
-		spin_unlock_irqrestore(&ha->list_lock, flags);
-	}
+	} 
+	spin_unlock_irqrestore(&ha->list_lock, flags);
 
 	/*
 	 * Search failover queue
 	 */
-	if (ha->flags.failover_enabled) {
-		if (!found) {
-			DEBUG3(printk("qla2xxx_eh_abort: searching sp %p in "
-			    "failover queue.\n", sp);)
-
-			spin_lock_irqsave(&ha->list_lock, flags);
-			list_for_each_safe(list, temp, &ha->failover_queue) {
-				rp = list_entry(list, srb_t, list);
-
-				if (cmd != rp->cmd)
-					continue;
-
-				DEBUG2(printk(KERN_WARNING
-				    "qla2xxx_eh_abort: found in failover "
-				    "queue. SP=%p\n", sp);)
-
-				/* Remove srb from failover queue. */
-				__del_from_failover_queue(ha, rp);
-				cmd->result = DID_ABORT << 16;
-				__add_to_done_queue(ha, rp);
-
-				return_status = SUCCESS;
-				found++;
-
-				break;
-
-			} /* list_for_each_safe() */
-			spin_unlock_irqrestore(&ha->list_lock, flags);
-		} /*End of if !found */
+	if (qla2x00_failover_enabled(ha)) {
+		if (!found && qla2x00_search_failover_queue(ha, cmd)) {
+			return_status = SUCCESS;
+			found++;
+		}
 	}
 
 	/*
@@ -1805,8 +1747,8 @@
 	ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
 	/* Find actual ha */
 	sp = (srb_t *)CMD_SP(cmd);
-	if (ha->flags.failover_enabled && sp != NULL &&
-	    ha->host->eh_active == EH_ACTIVE)
+	if (qla2x00_failover_enabled(ha) && sp &&
+			ha->host->eh_active == EH_ACTIVE)
 		ha = sp->ha;
 	else
 		ha = (scsi_qla_host_t *)cmd->device->host->hostdata;
@@ -2233,11 +2175,6 @@
 	INIT_LIST_HEAD(&ha->failover_queue);
 	INIT_LIST_HEAD(&ha->pending_queue);
 
-	if (ql2xfailover)
-		ha->flags.failover_enabled = 1;
-	else
-		ha->flags.failover_enabled = 0;
-
 	/*
 	 * These locks are used to prevent more than one CPU
 	 * from modifying the queue at the same time. The
@@ -2324,17 +2261,8 @@
 	/*
 	 * if failover is enabled read the user configuration
 	 */
-	if (ha->flags.failover_enabled) {
-		if (ConfigRequired > 0)
-			mp_config_required = 1;
-		else
-			mp_config_required = 0;
-
-		DEBUG(printk("qla2x00_detect: qla2x00_cfg_init for hba %ld\n",
-		    ha->instance));
-
+	if (qla2x00_failover_enabled(ha))
 		qla2x00_cfg_init(ha);
-	}
 
 	/* Enable chip interrupts. */
 	qla2x00_enable_intrs(ha);
@@ -2361,16 +2289,17 @@
 		schedule_timeout(5);
 	}
 
-	/* List the target we have found */
-	if (displayConfig && (!ha->flags.failover_enabled))
-		qla2x00_display_fc_names(ha);
-
 	pci_set_drvdata(pdev, ha);
 	ha->init_done = 1;
 	num_hosts++;
 
- 	if (displayConfig && ha->flags.failover_enabled)
-		qla2x00_cfg_display_devices();
+	/* List the target we have found */
+	if (displayConfig) {
+		if (qla2x00_failover_enabled(ha))
+			qla2x00_cfg_display_devices();
+		else
+			qla2x00_display_fc_names(ha);
+	}
 
 	if (scsi_add_host(host, &pdev->dev))
 		goto probe_failed;
@@ -2456,7 +2385,7 @@
 
 	qla2x00_mem_free(ha);
 
-	if (ha->flags.failover_enabled)
+	if (qla2x00_failover_enabled(ha))
 		qla2x00_cfg_mem_free(ha);
 
 	ha->flags.online = FALSE;
@@ -2659,7 +2588,7 @@
 	    ha->qthreads, ha->retry_q_cnt,
 	    ha->done_q_cnt, ha->scsi_retry_q_cnt);
 
-	if (ha->flags.failover_enabled) {
+	if (qla2x00_failover_enabled(ha)) {
 		copy_info(&info,
 		    "Number of reqs in failover_q= %d\n",
 		    ha->failover_cnt);
@@ -2743,7 +2672,7 @@
 		if ((tq = TGT_Q(ha, i)) == NULL)
 			continue;
 
-		if (ha->flags.failover_enabled) {
+		if (qla2x00_failover_enabled(ha)) {
 			copy_info(&info,
 			    "scsi-qla%d-port-%d="
 			    "%02x%02x%02x%02x%02x%02x%02x%02x:"
@@ -3539,8 +3468,6 @@
 	}
 }
 
-
-
 /**************************************************************************
 * qla2x00_do_dpc
 *   This kernel thread is a task that is schedule by the interrupt handler
@@ -3835,42 +3762,8 @@
 			    ha->host_no));
 		}
 
-		if (ha->flags.failover_enabled) {
-			/*
-			 * If we are not processing a ioctl or one of
-			 * the ports are still MISSING or need a resync
-			 * then process the failover event.
-			*/  
-			if (!test_bit(CFG_ACTIVE, &ha->cfg_flags)) {
-				if (qla2x00_check_for_devices_online(ha)) {
-					if (test_and_clear_bit(FAILOVER_EVENT, &ha->dpc_flags)) {
-
-						DEBUG(printk("scsi(%ld): qla2x00_cfg_event_notify()\n",
-						    ha->host_no));
-
-						if (ha->flags.online) {
-							qla2x00_cfg_event_notify(ha, ha->failover_type);
-						}
-
-						DEBUG(printk("scsi(%ld): qla2x00_cfg_event_notify - end\n",
-						    ha->host_no));
-					}
-				}
-
-				if (test_and_clear_bit(FAILOVER_NEEDED, &ha->dpc_flags)) {
-					/*
-					 * Get any requests from failover queue
-					 */
-					DEBUG(printk("scsi(%ld): qla2x00_process_failover()\n",
-					    ha->host_no));
-
-					qla2x00_process_failover(ha);
-
-					DEBUG(printk("scsi(%ld): qla2x00_process_failover - end\n",
-					    ha->host_no));
-				}
-			}
-		}
+		if (qla2x00_failover_enabled(ha))
+			qla2x00_process_failover_event(ha);
 
 		if (test_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags)) {
 			DEBUG(printk("scsi(%ld): qla2x00_restart_queues()\n",
@@ -3970,47 +3863,6 @@
 }
 
 /*
- * qla2x00_check_for_devices_online
- *
- *	Check fcport state of all devices to make sure online.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Return:
- *	None.
- *
- * Context:
- */
-static uint8_t
-qla2x00_check_for_devices_online(scsi_qla_host_t *ha) 
-{
-	struct list_head	*fcpl;
-	fc_port_t	*fcport;
-	int		found, cnt;
-
-	found = 0;
-	cnt = 0;
-
-	list_for_each(fcpl, &ha->fcports) {
-		fcport = list_entry(fcpl, fc_port_t, list);
-
-		if ((atomic_read(&fcport->state) == FCS_ONLINE) ||
-			(atomic_read(&fcport->state) == FCS_DEVICE_DEAD))
-			found++;
-
-		cnt++;
-	}
-	if (cnt == found) {
-		DEBUG5(printk("%s(%ld): all online\n",
-				__func__,
-				ha->host_no);)
-		return 1;
-	} else
-		return 0;
-}
-
-/*
 *  qla2x00_rst_aen
 *      Processes asynchronous reset.
 *
@@ -4293,8 +4145,9 @@
 
 			set_bit(RESTART_QUEUES_NEEDED, &ha->dpc_flags);
 			start_dpc++;
-			if (!(ha->device_flags & DFLG_NO_CABLE) &&
-			    qla2x00_reinit && !ha->flags.failover_enabled) {
+
+			if (!qla2x00_failover_enabled(ha) && qla2x00_reinit &&
+				!(ha->device_flags & DFLG_NO_CABLE)) {
 
 				DEBUG(printk("scsi(%ld): Loop down - "
 				    "aborting ISP.\n",
@@ -4500,7 +4353,7 @@
 		 * DID_NO_CONNECT status.  Otherwise set the host_byte to
 		 * DID_BUS_BUSY to let the OS  retry this cmd.
 		 */
-		if (dest_ha->flags.failover_enabled) {
+		if (qla2x00_failover_enabled(dest_ha))  {
 			cmd->result = DID_BUS_BUSY << 16;
 		} else {
 			if ((atomic_read(&fcport->state) == FCS_DEVICE_DEAD) ||
@@ -4635,31 +4488,9 @@
 			}
 		}
 
-		if (!(sp->flags & SRB_IOCTL) && ha->flags.failover_enabled) {
-			/*
-			 * This routine checks for DID_NO_CONNECT to decide
-			 * whether to failover to another path or not. We only
-			 * failover on that status.
-			 */
-			if (qla2x00_fo_check(ha, sp)) {
-				if ((sp->state != SRB_FAILOVER_STATE)) {
-					/*
-					 * Retry the command on this path
-					 * several times before selecting a new
-					 * path.
-					 */
-					add_to_pending_queue_head(vis_ha, sp);
-					qla2x00_next(vis_ha);
-				}
-				else {
-					/* we failover this path */
-					qla2x00_extend_timeout(cmd,
-					    EXTEND_CMD_TIMEOUT);
-				}
+		if (qla2x00_failover_enabled(ha) && !(sp->flags & SRB_IOCTL))
+			if (qla2x00_do_fo_check(ha, sp, vis_ha))
 				continue;
-			}
-			
-		}
 
 		switch (host_byte(cmd->result)) {
 			case DID_OK:
@@ -4887,7 +4718,7 @@
 		/* Process response_queue if ZIO support is enabled*/ 
 		qla2x00_process_response_queue_in_zio_mode(vis_ha);
 
-		if (dest_ha && dest_ha->flags.failover_enabled)
+		if (dest_ha && qla2x00_failover_enabled(dest_ha))
 			qla2x00_process_response_queue_in_zio_mode(dest_ha);
 	}
 }
@@ -4980,128 +4811,6 @@
 	spin_unlock_irqrestore(&ha->list_lock, flags);
 }
 
-/*
- *  qla2x00_failover_cleanup
- *	Cleanup queues after a failover.
- *
- * Input:
- *	sp = command pointer
- *
- * Context:
- *	Interrupt context.
- */
-static void
-qla2x00_failover_cleanup(srb_t *sp) 
-{
-	sp->cmd->result = DID_BUS_BUSY << 16;
-	sp->cmd->host_scribble = (unsigned char *) NULL;
-
-	/* turn-off all failover flags */
-	sp->flags = sp->flags & ~(SRB_RETRY|SRB_FAILOVER|SRB_FO_CANCEL);
-}
-
-
-/*
- *  qla2x00_process_failover
- *	Process any command on the failover queue.
- *
- * Input:
- *	ha = adapter block pointer.
- *
- * Context:
- *	Interrupt context.
- */
-static void
-qla2x00_process_failover(scsi_qla_host_t *ha) 
-{
-
-	os_tgt_t	*tq;
-	os_lun_t	*lq;
-	srb_t       *sp;
-	fc_port_t *fcport;
-	struct list_head *list, *temp;
-	unsigned long flags;
-	unsigned int	t, l;
-	scsi_qla_host_t *vis_ha = NULL;
-
-	DEBUG(printk("scsi(%ld): Processing failover for hba.\n", ha->host_no));
-
-	/*
-	 * Process all the commands in the failover queue. Attempt to failover
-	 * then either complete the command as is or requeue for retry.
-	 */
-
-	/* Prevent or allow acceptance of new I/O requests. */
-	spin_lock_irqsave(&ha->list_lock, flags);
-
-	/*
-	 * Get first entry to find our visible adapter.  We could never get
-	 * here if the list is empty
-	 */
-	list = ha->failover_queue.next;
-	sp = list_entry(list, srb_t, list);
-	vis_ha = (scsi_qla_host_t *) sp->cmd->device->host->hostdata;
-	list_for_each_safe(list, temp, &ha->failover_queue) {
-		sp = list_entry(list, srb_t, list);
-
-		tq = sp->tgt_queue;
-		lq = sp->lun_queue;
-		fcport = lq->fclun->fcport;
-
-		/* Remove srb from failover queue. */
-		__del_from_failover_queue(ha, sp);
-
-		DEBUG2(printk("%s(): pid %ld retrycnt=%d\n",
-		    __func__, sp->cmd->serial_number, sp->cmd->retries));
-
-		/*** Select an alternate path ***/
-		/* 
-		 * If the path has already been change by a previous request
-		 * sp->fclun != lq->fclun
-		 */
-		if (sp->fclun != lq->fclun ||
-		    atomic_read(&fcport->state) != FCS_DEVICE_DEAD) {
-
-			qla2x00_failover_cleanup(sp);
-
-		} else if (qla2x00_cfg_failover(ha, lq->fclun, tq, sp) ==
-		    NULL) {
-			/*
-			 * We ran out of paths, so just post the status which
-			 * is already set in the cmd.
-			 */
-			printk(KERN_INFO
-			    "scsi(%ld): Ran out of paths - pid %ld\n",
-			    ha->host_no, sp->cmd->serial_number);
-		} else {
-			qla2x00_failover_cleanup(sp);
-
-		}
-		__add_to_done_queue(ha, sp);
-	} /* list_for_each_safe */
-	spin_unlock_irqrestore(&ha->list_lock, flags);
-
-	for (t = 0; t < vis_ha->max_targets; t++) {
-		if ((tq = vis_ha->otgt[t]) == NULL)
-			continue;
-		for (l = 0; l < vis_ha->max_luns; l++) {
-			if ((lq = (os_lun_t *) tq->olun[l]) == NULL)
-				continue;
-
-			if( test_and_clear_bit(LUN_MPIO_BUSY, &lq->q_flag) ) {
-				/* EMPTY */
-				DEBUG(printk("scsi(%ld): remove suspend for "
-				    "lun %d\n", ha->host_no, lq->fclun->lun));
-			}
-		}
-	}
-
-	//qla2x00_restart_queues(ha,TRUE);
-	qla2x00_restart_queues(ha, FALSE);
-
-	DEBUG(printk("%s() - done", __func__));
-}
-
 /**************************************************************************
 *   qla2x00_check_tgt_status
 *
diff -uNr qla6hch/qla_settings.h qla6nofo/qla_settings.h
--- qla6hch/qla_settings.h	2003-11-12 14:07:03.000000000 +0100
+++ qla6nofo/qla_settings.h	2003-11-15 16:30:16.920000000 +0100
@@ -37,7 +37,6 @@
 #define VSA			0	/* Volume Set Addressing */
 
 /* Failover options */
-#define MPIO_SUPPORT		0
 #define MAX_RECOVERYTIME	10	/*
 					 * Max suspend time for a lun recovery
 					 * time
diff -uNr qla6hch/qla_xioct.c qla6nofo/qla_xioct.c
--- qla6hch/qla_xioct.c	2003-11-13 21:56:05.000000000 +0100
+++ qla6nofo/qla_xioct.c	2003-11-15 16:43:11.210000000 +0100
@@ -584,6 +584,7 @@
 	   break;
 	 */
 
+#ifdef HAVE_FAILOVER
 	/* Failover IOCTLs */
 	case FO_CC_GET_PARAMS:
 	case FO_CC_SET_PARAMS:
@@ -600,6 +601,7 @@
 		qla2x00_fo_ioctl(ha, cmd, pext, mode);
 
 		break;
+#endif
 
 	default:
 	fail:
@@ -1388,10 +1390,12 @@
 
 	ptmp_hba_node->InterfaceType = EXT_DEF_FC_INTF_TYPE;
 	ptmp_hba_node->PortCount = 1;
+	ptmp_hba_node->DriverAttr = 0;
 
-
-	ptmp_hba_node->DriverAttr = (ha->flags.failover_enabled) ?
-	    DRVR_FO_ENABLED : 0;
+#ifdef HAVE_FAILOVER
+	if (qla2x00_failover_enabled(ha))
+		ptmp_hba_node->DriverAttr |= DRVR_FO_ENABLED;
+#endif
 
 	ret = verify_area(VERIFY_WRITE, (void  *)pext->ResponseAdr,
 	    sizeof(EXT_HBA_NODE));
@@ -2486,7 +2490,7 @@
 	 * in config file which don't actually exist (missing).
 	 */
 	if (ret == 0) {
-		if (!ha->flags.failover_enabled) {
+		if (!qla2x00_failover_enabled(ha)) {
 #if 0
 			ret = qla2x00_std_missing_port_summary(ha, pdd_entry,
 			    start_of_entry_list, usr_no_of_entries,
