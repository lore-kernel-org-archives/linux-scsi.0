From: Eric Moore <eric.moore@lsil.com>
Subject: [PATCH] - fusion - mptfc bug fix's to prevent deadlock situations
Date: Tue, 25 Apr 2006 17:39:44 -0600
Message-ID: <20060425233944.GC9424@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:43764 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S932311AbWDYXk5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Apr 2006 19:40:57 -0400
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id k3PNYwNI027941
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:34:58 -0700 (PDT)
Received: from localhost (emoore-test1.co.lsil.com [172.21.48.27])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with ESMTP id k3PNeu31011044
	for <linux-scsi@vger.kernel.org>; Tue, 25 Apr 2006 16:40:57 -0700
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Here are various fix to prevent deadlock situations, forwarded from
Micheal Reed.

Changelog:

mptbase.h

	bump version number to 3.03.09

	remove unneeded flags
	define workq and remove old fc specific locks

mptbase.c

	initialize new lock and don't initialize two removed locks

mptscsih.c

	when firmware reports target is no longer there, return DID_REQUEUE
	for fc hosts so that i/o doesn't get killed until the transport
	has an opportunity to manage the loss via its dev loss timer

	when the "eh_abort" routine is called, check to see if the driver
	has the command or not before looking to see if a reset is pending.
	James Smart and I talked about this and believe that the API for
	this routine is: if driver doesn't have command, return SUCCESS.
	This change helps prevent a target from being taken offline.
	SUCCESS is returned because it's likely that the command completed
	after error recovery timed it out but before it could be aborted.

	provide a routine to queue work to newly created workq, and use it.

	remove "ioc" from mptscsih_abort()
	it was only used one time.  the other references
	were via hd->ioc, so I just moved it....
	net change in references to ioc via hd->ioc is zero

	move hd->resetPending test and hd->timeouts increment to after
	the test for whether the command to be aborted remains known to
	the driver

	Make certain that the workq exists before queuing work to it.

mptfc.c

	no longer need to lock rport data structures as I was able to
	single thread the code!  I fixed up the debug code to eliminate
	compilation messages due to type mismatch in the printk.  Got rid
	of some no longer needed rport flags.  Initialize and destroy the
	workq used for the rescan work.

	simplify the logic regarding the increment of fc_rescan_work_count.
	use post increment and test for zero vs. pre increment and test
	for one; eliminate work_count variable: queue_work can be called
	with the work_lock held as it doesn't sleep


Signed-off-by: Michael Reed <mdr@sgi.com>
Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2006-04-25 09:22:08.000000000 -0600
+++ a/drivers/message/fusion/mptbase.c	2006-04-25 09:25:18.000000000 -0600
@@ -1189,7 +1189,6 @@
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
 	spin_lock_init(&ioc->fc_rescan_work_lock);
-	spin_lock_init(&ioc->fc_rport_lock);
 	spin_lock_init(&ioc->initializing_hba_lock);
 
 	/* Initialize the event logging.
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2006-04-20 12:39:28.000000000 -0600
+++ a/drivers/message/fusion/mptbase.h	2006-04-21 15:27:36.000000000 -0600
@@ -76,8 +76,8 @@
 #define COPYRIGHT	"Copyright (c) 1999-2005 " MODULEAUTHOR
 #endif
 
-#define MPT_LINUX_VERSION_COMMON	"3.03.08"
-#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.08"
+#define MPT_LINUX_VERSION_COMMON	"3.03.09"
+#define MPT_LINUX_PACKAGE_NAME		"@(#)mptlinux-3.03.09"
 #define WHAT_MAGIC_STRING		"@" "(" "#" ")"
 
 #define show_mptmod_ver(s,ver)  \
@@ -489,7 +489,6 @@
 
 #define MPT_RPORT_INFO_FLAGS_REGISTERED	0x01	/* rport registered */
 #define MPT_RPORT_INFO_FLAGS_MISSING	0x02	/* missing from DevPage0 scan */
-#define MPT_RPORT_INFO_FLAGS_MAPPED_VDEV 0x04	/* target mapped in vdev */
 
 /*
  * data allocated for each fc rport device
@@ -501,7 +500,6 @@
 	struct scsi_target *starget;
 	FCDevicePage0_t pg0;
 	u8		flags;
-	u8		remap_needed;
 };
 
 /*
@@ -628,11 +626,11 @@
 	struct work_struct	 mptscsih_persistTask;
 
 	struct list_head	 fc_rports;
-	spinlock_t		 fc_rport_lock; /* list and ri flags */
 	spinlock_t		 fc_rescan_work_lock;
 	int			 fc_rescan_work_count;
 	struct work_struct	 fc_rescan_work;
-
+	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
+	struct workqueue_struct *fc_rescan_work_q;
 } MPT_ADAPTER;
 
 /*
diff -uarN b/drivers/message/fusion/mptfc.c a/drivers/message/fusion/mptfc.c
--- b/drivers/message/fusion/mptfc.c	2006-04-20 12:39:28.000000000 -0600
+++ a/drivers/message/fusion/mptfc.c	2006-04-21 15:27:36.000000000 -0600
@@ -355,15 +355,13 @@
 	struct fc_rport		*rport;
 	struct mptfc_rport_info	*ri;
 	int			new_ri = 1;
-	u64			pn;
-	unsigned long		flags;
+	u64			pn, nn;
 	VirtTarget		*vtarget;
 
 	if (mptfc_generate_rport_ids(pg0, &rport_ids) < 0)
 		return;
 
 	/* scan list looking for a match */
-	spin_lock_irqsave(&ioc->fc_rport_lock, flags);
 	list_for_each_entry(ri, &ioc->fc_rports, list) {
 		pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
 		if (pn == rport_ids.port_name) {	/* match */
@@ -373,11 +371,9 @@
 		}
 	}
 	if (new_ri) {	/* allocate one */
-		spin_unlock_irqrestore(&ioc->fc_rport_lock, flags);
 		ri = kzalloc(sizeof(struct mptfc_rport_info), GFP_KERNEL);
 		if (!ri)
 			return;
-		spin_lock_irqsave(&ioc->fc_rport_lock, flags);
 		list_add_tail(&ri->list, &ioc->fc_rports);
 	}
 
@@ -387,14 +383,11 @@
 	/* MPT_RPORT_INFO_FLAGS_REGISTERED - rport not previously deleted */
 	if (!(ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED)) {
 		ri->flags |= MPT_RPORT_INFO_FLAGS_REGISTERED;
-		spin_unlock_irqrestore(&ioc->fc_rport_lock, flags);
 		rport = fc_remote_port_add(ioc->sh, channel, &rport_ids);
-		spin_lock_irqsave(&ioc->fc_rport_lock, flags);
 		if (rport) {
 			ri->rport = rport;
 			if (new_ri) /* may have been reset by user */
 				rport->dev_loss_tmo = mptfc_dev_loss_tmo;
-			*((struct mptfc_rport_info **)rport->dd_data) = ri;
 			/*
 			 * if already mapped, remap here.  If not mapped,
 			 * target_alloc will allocate vtarget and map,
@@ -406,16 +399,20 @@
 					vtarget->target_id = pg0->CurrentTargetID;
 					vtarget->bus_id = pg0->CurrentBus;
 				}
-				ri->remap_needed = 0;
 			}
+			/* once dd_data is filled in, commands will issue to hardware */
+			*((struct mptfc_rport_info **)rport->dd_data) = ri;
+
+			pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
+			nn = (u64)ri->pg0.WWNN.High << 32 | (u64)ri->pg0.WWNN.Low;
 			dfcprintk ((MYIOC_s_INFO_FMT
 				"mptfc_reg_dev.%d: %x, %llx / %llx, tid %d, "
 				"rport tid %d, tmo %d\n",
 					ioc->name,
 					ioc->sh->host_no,
 					pg0->PortIdentifier,
-					pg0->WWNN,
-					pg0->WWPN,
+					(unsigned long long)nn,
+					(unsigned long long)pn,
 					pg0->CurrentTargetID,
 					ri->rport->scsi_target_id,
 					ri->rport->dev_loss_tmo));
@@ -425,8 +422,6 @@
 			ri = NULL;
 		}
 	}
-	spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
-
 }
 
 /*
@@ -476,7 +471,6 @@
 			vtarget->target_id = ri->pg0.CurrentTargetID;
 			vtarget->bus_id = ri->pg0.CurrentBus;
 			ri->starget = starget;
-			ri->remap_needed = 0;
 			rc = 0;
 		}
 	}
@@ -502,10 +496,10 @@
 	VirtDevice		*vdev;
 	struct scsi_target	*starget;
 	struct fc_rport		*rport;
-	unsigned long		flags;
 
 
-	rport = starget_to_rport(scsi_target(sdev));
+	starget = scsi_target(sdev);
+	rport = starget_to_rport(starget);
 
 	if (!rport || fc_remote_port_chkready(rport))
 		return -ENXIO;
@@ -519,10 +513,8 @@
 		return -ENOMEM;
 	}
 
-	spin_lock_irqsave(&hd->ioc->fc_rport_lock,flags);
 
 	sdev->hostdata = vdev;
-	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 
 	if (vtarget->num_luns == 0) {
@@ -535,14 +527,16 @@
 	vdev->vtarget = vtarget;
 	vdev->lun = sdev->lun;
 
-	spin_unlock_irqrestore(&hd->ioc->fc_rport_lock,flags);
-
 	vtarget->num_luns++;
 
+
 #ifdef DMPT_DEBUG_FC
-	 {
+	{
+	u64 nn, pn;
 	struct mptfc_rport_info *ri;
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
+	pn = (u64)ri->pg0.WWPN.High << 32 | (u64)ri->pg0.WWPN.Low;
+	nn = (u64)ri->pg0.WWNN.High << 32 | (u64)ri->pg0.WWNN.Low;
 	dfcprintk ((MYIOC_s_INFO_FMT
 		"mptfc_slv_alloc.%d: num_luns %d, sdev.id %d, "
 	        "CurrentTargetID %d, %x %llx %llx\n",
@@ -550,7 +544,9 @@
 		sdev->host->host_no,
 		vtarget->num_luns,
 		sdev->id, ri->pg0.CurrentTargetID,
-		ri->pg0.PortIdentifier, ri->pg0.WWPN, ri->pg0.WWNN));
+		ri->pg0.PortIdentifier,
+		(unsigned long long)pn,
+		(unsigned long long)nn));
 	}
 #endif
 
@@ -570,11 +566,31 @@
 		done(SCpnt);
 		return 0;
 	}
+
+	/* dd_data is null until finished adding target */
 	ri = *((struct mptfc_rport_info **)rport->dd_data);
-	if (unlikely(ri->remap_needed))
-		return SCSI_MLQUEUE_HOST_BUSY;
+	if (unlikely(!ri)) {
+		dfcprintk ((MYIOC_s_INFO_FMT
+			"mptfc_qcmd.%d: %d:%d, dd_data is null.\n",
+			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
+			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
+			SCpnt->device->id,SCpnt->device->lun));
+		SCpnt->result = DID_IMM_RETRY << 16;
+		done(SCpnt);
+		return 0;
+	}
 
-	return mptscsih_qcmd(SCpnt,done);
+	err = mptscsih_qcmd(SCpnt,done);
+#ifdef DMPT_DEBUG_FC
+	if (unlikely(err)) {
+		dfcprintk ((MYIOC_s_INFO_FMT
+			"mptfc_qcmd.%d: %d:%d, mptscsih_qcmd returns non-zero.\n",
+			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->name,
+			((MPT_SCSI_HOST *) SCpnt->device->host->hostdata)->ioc->sh->host_no,
+			SCpnt->device->id,SCpnt->device->lun));
+	}
+#endif
+	return err;
 }
 
 static void
@@ -615,18 +631,17 @@
 	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
 	int			ii;
 	int			work_to_do;
+	u64			pn;
 	unsigned long		flags;
 	struct mptfc_rport_info *ri;
 
 	do {
 		/* start by tagging all ports as missing */
-		spin_lock_irqsave(&ioc->fc_rport_lock,flags);
 		list_for_each_entry(ri, &ioc->fc_rports, list) {
 			if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
 				ri->flags |= MPT_RPORT_INFO_FLAGS_MISSING;
 			}
 		}
-		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
 
 		/*
 		 * now rescan devices known to adapter,
@@ -639,33 +654,24 @@
 		}
 
 		/* delete devices still missing */
-		spin_lock_irqsave(&ioc->fc_rport_lock, flags);
 		list_for_each_entry(ri, &ioc->fc_rports, list) {
 			/* if newly missing, delete it */
-			if ((ri->flags & (MPT_RPORT_INFO_FLAGS_REGISTERED |
-					  MPT_RPORT_INFO_FLAGS_MISSING))
-			  == (MPT_RPORT_INFO_FLAGS_REGISTERED |
-			      MPT_RPORT_INFO_FLAGS_MISSING)) {
+			if (ri->flags & MPT_RPORT_INFO_FLAGS_MISSING) {
 
 				ri->flags &= ~(MPT_RPORT_INFO_FLAGS_REGISTERED|
 					       MPT_RPORT_INFO_FLAGS_MISSING);
-				ri->remap_needed = 1;
-				fc_remote_port_delete(ri->rport);
-				/*
-				 * remote port not really deleted 'cause
-				 * binding is by WWPN and driver only
-				 * registers FCP_TARGETs but cannot trust
-				 * data structures.
-				 */
+				fc_remote_port_delete(ri->rport);	/* won't sleep */
 				ri->rport = NULL;
+
+				pn = (u64)ri->pg0.WWPN.High << 32 |
+				     (u64)ri->pg0.WWPN.Low;
 				dfcprintk ((MYIOC_s_INFO_FMT
 					"mptfc_rescan.%d: %llx deleted\n",
 					ioc->name,
 					ioc->sh->host_no,
-					ri->pg0.WWPN));
+					(unsigned long long)pn));
 			}
 		}
-		spin_unlock_irqrestore(&ioc->fc_rport_lock,flags);
 
 		/*
 		 * allow multiple passes as target state
@@ -870,10 +876,23 @@
 		goto out_mptfc_probe;
 	}
 
-	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-		mptfc_init_host_attr(ioc,ii);
-		mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
-	}
+	/* initialize workqueue */
+
+	snprintf(ioc->fc_rescan_work_q_name, KOBJ_NAME_LEN, "mptfc_wq_%d",
+		sh->host_no);
+	ioc->fc_rescan_work_q =
+		create_singlethread_workqueue(ioc->fc_rescan_work_q_name);
+	if (!ioc->fc_rescan_work_q)
+		goto out_mptfc_probe;
+
+	/*
+	 * scan for rports -
+	 *	by doing it via the workqueue, some locking is eliminated
+	 */
+
+	ioc->fc_rescan_work_count = 1;
+	queue_work(ioc->fc_rescan_work_q, &ioc->fc_rescan_work);
+	flush_workqueue(ioc->fc_rescan_work_q);
 
 	return 0;
 
@@ -949,8 +968,18 @@
 static void __devexit
 mptfc_remove(struct pci_dev *pdev)
 {
-	MPT_ADAPTER *ioc = pci_get_drvdata(pdev);
-	struct mptfc_rport_info *p, *n;
+	MPT_ADAPTER		*ioc = pci_get_drvdata(pdev);
+	struct mptfc_rport_info	*p, *n;
+	struct workqueue_struct *work_q;
+	unsigned long		flags;
+
+	/* destroy workqueue */
+	if ((work_q=ioc->fc_rescan_work_q)) {
+		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
+		ioc->fc_rescan_work_q = NULL;
+		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
+		destroy_workqueue(work_q);
+	}
 
 	fc_remove_host(ioc->sh);
 
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2006-04-21 10:53:19.000000000 -0600
+++ a/drivers/message/fusion/mptscsih.c	2006-04-21 15:27:36.000000000 -0600
@@ -632,7 +632,11 @@
 
 		case MPI_IOCSTATUS_SCSI_DEVICE_NOT_THERE:	/* 0x0043 */
 			/* Spoof to SCSI Selection Timeout! */
-			sc->result = DID_NO_CONNECT << 16;
+			if (ioc->bus_type != FC)
+				sc->result = DID_NO_CONNECT << 16;
+			/* else fibre, just stall until rescan event */
+			else
+				sc->result = DID_REQUEUE << 16;
 
 			if (hd->sel_timeout[pScsiReq->TargetID] < 0xFFFF)
 				hd->sel_timeout[pScsiReq->TargetID]++;
@@ -1645,7 +1649,6 @@
 mptscsih_abort(struct scsi_cmnd * SCpnt)
 {
 	MPT_SCSI_HOST	*hd;
-	MPT_ADAPTER	*ioc;
 	MPT_FRAME_HDR	*mf;
 	u32		 ctx2abort;
 	int		 scpnt_idx;
@@ -1663,14 +1666,6 @@
 		return FAILED;
 	}
 
-	ioc = hd->ioc;
-	if (hd->resetPending) {
-		return FAILED;
-	}
-
-	if (hd->timeouts < -1)
-		hd->timeouts++;
-
 	/* Find this command
 	 */
 	if ((scpnt_idx = SCPNT_TO_LOOKUP_IDX(SCpnt)) < 0) {
@@ -1684,6 +1679,13 @@
 		return SUCCESS;
 	}
 
+	if (hd->resetPending) {
+		return FAILED;
+	}
+
+	if (hd->timeouts < -1)
+		hd->timeouts++;
+
 	printk(KERN_WARNING MYNAM ": %s: attempting task abort! (sc=%p)\n",
 	       hd->ioc->name, SCpnt);
 	scsi_print_command(SCpnt);
@@ -1703,7 +1705,7 @@
 	vdev = SCpnt->device->hostdata;
 	retval = mptscsih_TMHandler(hd, MPI_SCSITASKMGMT_TASKTYPE_ABORT_TASK,
 		vdev->vtarget->bus_id, vdev->vtarget->target_id, vdev->lun,
-		ctx2abort, mptscsih_get_tm_timeout(ioc));
+		ctx2abort, mptscsih_get_tm_timeout(hd->ioc));
 
 	printk (KERN_WARNING MYNAM ": %s: task abort: %s (sc=%p)\n",
 		hd->ioc->name,
@@ -2521,15 +2523,15 @@
 
 		/* 7. FC: Rescan for blocked rports which might have returned.
 		 */
-		else if (ioc->bus_type == FC) {
-			int work_count;
-			unsigned long flags;
-
+		if (ioc->bus_type == FC) {
 			spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
-			work_count = ++ioc->fc_rescan_work_count;
+			if (ioc->fc_rescan_work_q) {
+				if (ioc->fc_rescan_work_count++ == 0) {
+					queue_work(ioc->fc_rescan_work_q,
+						   &ioc->fc_rescan_work);
+				}
+			}
 			spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
-			if (work_count == 1)
-				schedule_work(&ioc->fc_rescan_work);
 		}
 		dtmprintk((MYIOC_s_WARN_FMT "Post-Reset complete.\n", ioc->name));
 
@@ -2544,7 +2546,6 @@
 {
 	MPT_SCSI_HOST *hd;
 	u8 event = le32_to_cpu(pEvReply->Event) & 0xFF;
-	int work_count;
 	unsigned long flags;
 
 	devtverboseprintk((MYIOC_s_INFO_FMT "MPT event (=%02Xh) routed to SCSI host driver!\n",
@@ -2569,10 +2570,13 @@
 
 	case MPI_EVENT_RESCAN:				/* 06 */
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
-		work_count = ++ioc->fc_rescan_work_count;
+		if (ioc->fc_rescan_work_q) {
+			if (ioc->fc_rescan_work_count++ == 0) {
+				queue_work(ioc->fc_rescan_work_q,
+					   &ioc->fc_rescan_work);
+			}
+		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
-		if (work_count == 1)
-			schedule_work(&ioc->fc_rescan_work);
 		break;
 
 		/*
