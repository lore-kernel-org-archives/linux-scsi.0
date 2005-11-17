From: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Subject: [PATCH 1/7]  mptfusion - performance fix for U320
Date: Wed, 16 Nov 2005 18:54:10 -0700
Message-ID: <200511161854.10652.Eric.Moore@lsil.com>
Reply-To: Eric.Moore@lsil.com
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_CL+eDpoxkTp/yzM"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:3202 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S1161089AbVKQB7m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Nov 2005 20:59:42 -0500
Received: from milmhbs0.lsil.com (mhbs.lsil.com [147.145.1.30])
	by mail0.lsil.com (8.12.8/8.12.8) with ESMTP id jAH1t0SW011519
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:55:00 -0800 (PST)
Received: from mailmux (popmil.lsil.com [147.145.13.217])
	by milmhbs0.lsil.com (8.12.11/8.12.11) with SMTP id jAH1xfxB001906
	for <linux-scsi@vger.kernel.org>; Wed, 16 Nov 2005 17:59:41 -0800
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux scsi <linux-scsi@vger.kernel.org>


--Boundary-00=_CL+eDpoxkTp/yzM
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Syncronization for Domain Validation workqueue and the
initiation of the alternate controller. Its possible that dv could
be terminated if the workqueue on the 1st channel doesn complete
in time before the 2nd channel begins initialization.   

Signed-off-by: Eric Moore <Eric.Moore@lsil.com>


--Boundary-00=_CL+eDpoxkTp/yzM
Content-Type: text/x-diff;
  charset="us-ascii";
  name="1-perf-fix.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="1-perf-fix.patch"

diff -uarN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
--- b/drivers/message/fusion/mptbase.c	2005-11-16 12:54:28.000000000 -0700
+++ a/drivers/message/fusion/mptbase.c	2005-11-16 18:19:11.000000000 -0700
@@ -1118,6 +1118,70 @@
 	return -1;
 }
 
+/* remove this when SPI transport generic dv is introduced
+ *
+ * #ifdef MPTSCSIH_ENABLE_DOMAIN_VALIDATION
+ */
+int
+mpt_alt_ioc_wait(MPT_ADAPTER *ioc)
+{
+	int loop_count = 15 * 4;  /* Wait 15 seconds */
+	int status = -1; /* -1 means failed to get board READY */
+
+	do {
+		spin_lock(&ioc->initializing_hba_lock);
+		if (ioc->initializing_hba_lock_flag == 0) {
+			ioc->initializing_hba_lock_flag=1;
+			spin_unlock(&ioc->initializing_hba_lock);
+			status = 0;
+			break;
+		}
+		spin_unlock(&ioc->initializing_hba_lock);
+		schedule_timeout_interruptible(HZ/4);
+	} while (--loop_count);
+
+	return status;
+}
+
+/*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
+/*
+ *	mpt_bringup_adapter - This is a wrapper function for mpt_do_ioc_recovery
+ *	@ioc: Pointer to MPT adapter structure
+ *	@sleepFlag: Use schedule if CAN_SLEEP else use udelay.
+ *
+ *	This routine performs all the steps necessary to bring the IOC
+ *	to a OPERATIONAL state.
+ *
+ *      Special Note: This function was added with spin lock's so as to allow
+ *      the dv(domain validation) work thread to succeed on the other channel
+ *      that maybe occuring at the same time when this function is called.
+ *      Without this lock, the dv would fail when message frames were
+ *      requested during hba bringup on the alternate ioc.
+ */
+static int
+mpt_bringup_adapter(MPT_ADAPTER *ioc, int sleepFlag)
+{
+	int r;
+
+	if(ioc->alt_ioc) {
+		if((r=mpt_alt_ioc_wait(ioc->alt_ioc)!=0))
+			return r;
+	}
+
+	r = mpt_do_ioc_recovery(ioc, MPT_HOSTEVENT_IOC_BRINGUP,
+	    CAN_SLEEP);
+
+	if(ioc->alt_ioc) {
+		spin_lock(&ioc->alt_ioc->initializing_hba_lock);
+		ioc->alt_ioc->initializing_hba_lock_flag=0;
+		spin_unlock(&ioc->alt_ioc->initializing_hba_lock);
+	}
+
+return r;
+}
+//  #endif MPTSCSIH_ENABLE_DOMAIN_VALIDATION
+
+
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
  *	mpt_attach - Install a PCI intelligent MPT adapter.
@@ -1186,6 +1250,7 @@
 	ioc->pcidev = pdev;
 	ioc->diagPending = 0;
 	spin_lock_init(&ioc->diagLock);
+	spin_lock_init(&ioc->initializing_hba_lock);
 
 	/* Initialize the event logging.
 	 */
@@ -1408,8 +1473,7 @@
 	 */
 	mpt_detect_bound_ports(ioc, pdev);
 
-	if ((r = mpt_do_ioc_recovery(ioc,
-	  MPT_HOSTEVENT_IOC_BRINGUP, CAN_SLEEP)) != 0) {
+	if ((r = mpt_bringup_adapter(ioc, CAN_SLEEP)) != 0){
 		printk(KERN_WARNING MYNAM
 		  ": WARNING - %s did not initialize properly! (%d)\n",
 		  ioc->name, r);
@@ -6296,6 +6360,7 @@
 EXPORT_SYMBOL(mpt_alloc_fw_memory);
 EXPORT_SYMBOL(mpt_free_fw_memory);
 EXPORT_SYMBOL(mptbase_sas_persist_operation);
+EXPORT_SYMBOL(mpt_alt_ioc_wait);
 
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
diff -uarN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2005-11-16 12:54:28.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2005-11-16 17:18:36.000000000 -0700
@@ -611,6 +611,8 @@
 	int			 DoneCtx;
 	int			 TaskCtx;
 	int			 InternalCtx;
+	spinlock_t		 initializing_hba_lock;
+	int 	 		 initializing_hba_lock_flag;
 	struct list_head	 list;
 	struct net_device	*netdev;
 	struct list_head	 sas_topology;
@@ -1001,6 +1003,7 @@
 extern int	 mpt_findImVolumes(MPT_ADAPTER *ioc);
 extern int	 mpt_read_ioc_pg_3(MPT_ADAPTER *ioc);
 extern int	 mptbase_sas_persist_operation(MPT_ADAPTER *ioc, u8 persist_opcode);
+extern int	 mpt_alt_ioc_wait(MPT_ADAPTER *ioc);
 
 /*
  *  Public data decl's...
diff -uarN b/drivers/message/fusion/mptscsih.c a/drivers/message/fusion/mptscsih.c
--- b/drivers/message/fusion/mptscsih.c	2005-11-16 12:54:28.000000000 -0700
+++ a/drivers/message/fusion/mptscsih.c	2005-11-16 17:15:55.000000000 -0700
@@ -3787,11 +3787,20 @@
 		return -EFAULT;
 	}
 
+	if(mpt_alt_ioc_wait(hd->ioc)!=0) {
+		ddvprintk((MYIOC_s_WARN_FMT "alt_ioc busy!\n",
+		    hd->ioc->name));
+		return -EBUSY;
+	}
+
 	/* Get and Populate a free Frame
 	 */
 	if ((mf = mpt_get_msg_frame(hd->ioc->InternalCtx, hd->ioc)) == NULL) {
 		ddvprintk((MYIOC_s_WARN_FMT "No msg frames!\n",
 					hd->ioc->name));
+		spin_lock(&hd->ioc->initializing_hba_lock);
+		hd->ioc->initializing_hba_lock_flag=0;
+		spin_unlock(&hd->ioc->initializing_hba_lock);
 		return -EBUSY;
 	}
 
@@ -3881,6 +3890,9 @@
 	add_timer(&hd->timer);
 	mpt_put_msg_frame(hd->ioc->InternalCtx, hd->ioc, mf);
 	wait_event(hd->scandv_waitq, hd->scandv_wait_done);
+	spin_lock(&hd->ioc->initializing_hba_lock);
+	hd->ioc->initializing_hba_lock_flag=0;
+	spin_unlock(&hd->ioc->initializing_hba_lock);
 
 	if (hd->pLocal) {
 		rc = hd->pLocal->completion;

--Boundary-00=_CL+eDpoxkTp/yzM--
