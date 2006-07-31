From: Michael Reed <mdr@sgi.com>
Subject: [PATCH 3/4] fusion: fibre channel: correct out of order event processing
Date: Mon, 31 Jul 2006 12:19:50 -0500
Message-ID: <44CE3BB6.4040901@sgi.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070700080908000200040103"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:44737 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030270AbWGaRTw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jul 2006 13:19:52 -0400
Received: from cthulhu.engr.sgi.com (cthulhu.engr.sgi.com [192.26.80.2])
	by omx2.sgi.com (8.12.11/8.12.9/linux-outbound_gateway-1.1) with ESMTP id k6VJmOCY023214
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 12:48:25 -0700
Received: from [128.162.233.78] (hd28.americas.sgi.com [128.162.233.78])
	by cthulhu.engr.sgi.com (SGI-8.12.5/8.12.5) with ESMTP id k6VHJo2742991411
	for <linux-scsi@vger.kernel.org>; Mon, 31 Jul 2006 10:19:51 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.
--------------070700080908000200040103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

This patch corrects a problem in mptfc which can result in targets
being removed after executing an "lsiutil 99" reset of the fibre
channel ports.

The last rescan event was being processed before the setup reset work
due to an inappropriate optimization in the event processing logic.
Every rescan event is now queued for execution and the setup reset
work now executes in the proper sequence.

Signed-off-by: Michael Reed <mdr@sgi.com>



--------------070700080908000200040103
Content-Type: text/x-patch;
 name="fusion_out_of_order_fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="fusion_out_of_order_fix.patch"

--- srfu/drivers/message/fusion/mptbase.h	2006-07-19 11:12:34.000000000 -0500
+++ srf/drivers/message/fusion/mptbase.h	2006-07-28 16:31:03.285075366 -0500
@@ -640,7 +640,6 @@ typedef struct _MPT_ADAPTER
 	struct work_struct	 fc_setup_reset_work;
 	struct list_head	 fc_rports;
 	spinlock_t		 fc_rescan_work_lock;
-	int			 fc_rescan_work_count;
 	struct work_struct	 fc_rescan_work;
 	char			 fc_rescan_work_q_name[KOBJ_NAME_LEN];
 	struct workqueue_struct *fc_rescan_work_q;
--- srfu/drivers/message/fusion/mptfc.c	2006-07-28 16:30:32.334322405 -0500
+++ srf/drivers/message/fusion/mptfc.c	2006-07-28 16:43:43.350227030 -0500
@@ -966,59 +966,45 @@ mptfc_rescan_devices(void *arg)
 {
 	MPT_ADAPTER		*ioc = (MPT_ADAPTER *)arg;
 	int			ii;
-	int			work_to_do;
 	u64			pn;
-	unsigned long		flags;
 	struct mptfc_rport_info *ri;
 
-	do {
-		/* start by tagging all ports as missing */
-		list_for_each_entry(ri, &ioc->fc_rports, list) {
-			if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
-				ri->flags |= MPT_RPORT_INFO_FLAGS_MISSING;
-			}
+	/* start by tagging all ports as missing */
+	list_for_each_entry(ri, &ioc->fc_rports, list) {
+		if (ri->flags & MPT_RPORT_INFO_FLAGS_REGISTERED) {
+			ri->flags |= MPT_RPORT_INFO_FLAGS_MISSING;
 		}
+	}
 
-		/*
-		 * now rescan devices known to adapter,
-		 * will reregister existing rports
-		 */
-		for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
-			(void) mptfc_GetFcPortPage0(ioc, ii);
-			mptfc_init_host_attr(ioc,ii);	/* refresh */
-			mptfc_GetFcDevPage0(ioc,ii,mptfc_register_dev);
-		}
+	/*
+	 * now rescan devices known to adapter,
+	 * will reregister existing rports
+	 */
+	for (ii=0; ii < ioc->facts.NumberOfPorts; ii++) {
+		(void) mptfc_GetFcPortPage0(ioc, ii);
+		mptfc_init_host_attr(ioc, ii);	/* refresh */
+		mptfc_GetFcDevPage0(ioc, ii, mptfc_register_dev);
+	}
 
-		/* delete devices still missing */
-		list_for_each_entry(ri, &ioc->fc_rports, list) {
-			/* if newly missing, delete it */
-			if (ri->flags & MPT_RPORT_INFO_FLAGS_MISSING) {
-
-				ri->flags &= ~(MPT_RPORT_INFO_FLAGS_REGISTERED|
-					       MPT_RPORT_INFO_FLAGS_MISSING);
-				fc_remote_port_delete(ri->rport);	/* won't sleep */
-				ri->rport = NULL;
-
-				pn = (u64)ri->pg0.WWPN.High << 32 |
-				     (u64)ri->pg0.WWPN.Low;
-				dfcprintk ((MYIOC_s_INFO_FMT
-					"mptfc_rescan.%d: %llx deleted\n",
-					ioc->name,
-					ioc->sh->host_no,
-					(unsigned long long)pn));
-			}
+	/* delete devices still missing */
+	list_for_each_entry(ri, &ioc->fc_rports, list) {
+		/* if newly missing, delete it */
+		if (ri->flags & MPT_RPORT_INFO_FLAGS_MISSING) {
+
+			ri->flags &= ~(MPT_RPORT_INFO_FLAGS_REGISTERED|
+				       MPT_RPORT_INFO_FLAGS_MISSING);
+			fc_remote_port_delete(ri->rport);	/* won't sleep */
+			ri->rport = NULL;
+
+			pn = (u64)ri->pg0.WWPN.High << 32 |
+			     (u64)ri->pg0.WWPN.Low;
+			dfcprintk ((MYIOC_s_INFO_FMT
+				"mptfc_rescan.%d: %llx deleted\n",
+				ioc->name,
+				ioc->sh->host_no,
+				(unsigned long long)pn));
 		}
-
-		/*
-		 * allow multiple passes as target state
-		 * might have changed during scan
-		 */
-		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
-		if (ioc->fc_rescan_work_count > 2) 	/* only need one more */
-			ioc->fc_rescan_work_count = 2;
-		work_to_do = --ioc->fc_rescan_work_count;
-		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
-	} while (work_to_do);
+	}
 }
 
 static int
@@ -1230,7 +1216,6 @@ mptfc_probe(struct pci_dev *pdev, const 
 	 *	by doing it via the workqueue, some locking is eliminated
 	 */
 
-	ioc->fc_rescan_work_count = 1;
 	queue_work(ioc->fc_rescan_work_q, &ioc->fc_rescan_work);
 	flush_workqueue(ioc->fc_rescan_work_q);
 
@@ -1273,10 +1258,8 @@ mptfc_event_process(MPT_ADAPTER *ioc, Ev
 	case MPI_EVENT_RESCAN:
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		if (ioc->fc_rescan_work_q) {
-			if (ioc->fc_rescan_work_count++ == 0) {
-				queue_work(ioc->fc_rescan_work_q,
-					   &ioc->fc_rescan_work);
-			}
+			queue_work(ioc->fc_rescan_work_q,
+				   &ioc->fc_rescan_work);
 		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 		break;
@@ -1319,10 +1302,8 @@ mptfc_ioc_reset(MPT_ADAPTER *ioc, int re
 		mptfc_SetFcPortPage1_defaults(ioc);
 		spin_lock_irqsave(&ioc->fc_rescan_work_lock, flags);
 		if (ioc->fc_rescan_work_q) {
-			if (ioc->fc_rescan_work_count++ == 0) {
-				queue_work(ioc->fc_rescan_work_q,
-					   &ioc->fc_rescan_work);
-			}
+			queue_work(ioc->fc_rescan_work_q,
+				   &ioc->fc_rescan_work);
 		}
 		spin_unlock_irqrestore(&ioc->fc_rescan_work_lock, flags);
 	}


--------------070700080908000200040103--
