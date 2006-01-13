From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] fusion: convert semaphores to mutexes
Date: Fri, 13 Jan 2006 18:27:11 +0100
Message-ID: <20060113172711.GA2736@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:16348 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S1161546AbWAMR1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 12:27:18 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com, Eric.Moore@lsil.com
Cc: linux-scsi@vger.kernel.org


Signed-off-by: Christoph Hellwig <hch@lst.de>

Index: scsi-misc-2.6/drivers/message/fusion/mptbase.h
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptbase.h	2006-01-13 18:01:07.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptbase.h	2006-01-13 18:08:37.000000000 +0100
@@ -413,7 +413,7 @@
 	u8			 status;	/* current command status */
 	u8			 reset;		/* 1 if bus reset allowed */
 	u8			 target;	/* target for reset */
-	struct semaphore	 sem_ioc;
+	struct mutex		 ioctl_mutex;
 } MPT_IOCTL;
 
 #define MPT_SAS_MGMT_STATUS_RF_VALID	0x02	/* The Reply Frame is VALID */
@@ -421,7 +421,7 @@
 #define MPT_SAS_MGMT_STATUS_TM_FAILED	0x40	/* User TM request failed */
 
 typedef struct _MPT_SAS_MGMT {
-	struct semaphore	 mutex;
+	struct mutex		 mutex;
 	struct completion	 done;
 	u8			 reply[MPT_DEFAULT_FRAME_SIZE]; /* reply frame data */
 	u8			 status;	/* current command status */
Index: scsi-misc-2.6/drivers/message/fusion/mptctl.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptctl.c	2006-01-13 17:55:56.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptctl.c	2006-01-13 18:07:06.000000000 +0100
@@ -177,10 +177,10 @@
 	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down(%p,%d) called\n", ioc, nonblock));
 
 	if (nonblock) {
-		if (down_trylock(&ioc->ioctl->sem_ioc))
+		if (!mutex_trylock(&ioc->ioctl->ioctl_mutex))
 			rc = -EAGAIN;
 	} else {
-		if (down_interruptible(&ioc->ioctl->sem_ioc))
+		if (mutex_lock_interruptible(&ioc->ioctl->ioctl_mutex))
 			rc = -ERESTARTSYS;
 	}
 	dctlprintk((KERN_INFO MYNAM "::mptctl_syscall_down return %d\n", rc));
@@ -557,7 +557,7 @@
 	else
 		ret = -EINVAL;
 
-	up(&iocp->ioctl->sem_ioc);
+	mutex_unlock(&iocp->ioctl->ioctl_mutex);
 
 	return ret;
 }
@@ -2619,7 +2619,7 @@
 
 	ret = mptctl_do_fw_download(kfw.iocnum, kfw.bufp, kfw.fwlen);
 
-	up(&iocp->ioctl->sem_ioc);
+	mutex_unlock(&iocp->ioctl->ioctl_mutex);
 
 	return ret;
 }
@@ -2673,7 +2673,7 @@
 	 */
 	ret = mptctl_do_mpt_command (karg, &uarg->MF);
 
-	up(&iocp->ioctl->sem_ioc);
+	mutex_unlock(&iocp->ioctl->ioctl_mutex);
 
 	return ret;
 }
@@ -2743,7 +2743,7 @@
 	memset(mem, 0, sz);
 	ioc->ioctl = (MPT_IOCTL *) mem;
 	ioc->ioctl->ioc = ioc;
-	sema_init(&ioc->ioctl->sem_ioc, 1);
+	mutex_init(&ioc->ioctl->ioctl_mutex);
 	return 0;
 
 out_fail:
Index: scsi-misc-2.6/drivers/message/fusion/mptsas.c
===================================================================
--- scsi-misc-2.6.orig/drivers/message/fusion/mptsas.c	2006-01-13 18:03:15.000000000 +0100
+++ scsi-misc-2.6/drivers/message/fusion/mptsas.c	2006-01-13 18:08:22.000000000 +0100
@@ -457,7 +457,7 @@
 	if (phy->identify.target_port_protocols & SAS_PROTOCOL_SMP)
 		return -ENXIO;
 
-	if (down_interruptible(&ioc->sas_mgmt.mutex))
+	if (mutex_lock_interruptible(&ioc->sas_mgmt.mutex))
 		goto out;
 
 	mf = mpt_get_msg_frame(mptsasMgmtCtx, ioc);
@@ -508,7 +508,7 @@
 	error = 0;
 
  out_unlock:
-	up(&ioc->sas_mgmt.mutex);
+	mutex_unlock(&ioc->sas_mgmt.mutex);
  out:
 	return error;
 }
@@ -1477,7 +1477,7 @@
 	INIT_LIST_HEAD(&ioc->sas_topology);
 	mutex_init(&ioc->sas_topology_mutex);
 
-	init_MUTEX(&ioc->sas_mgmt.mutex);
+	mutex_init(&ioc->sas_mgmt.mutex);
 	init_completion(&ioc->sas_mgmt.done);
 
 	/* Verify that we won't exceed the maximum
