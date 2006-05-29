From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [REPOST][PATCH 1/6] mpt fusion - fibre channel target
	discovery prematurely terminates
Date: Mon, 29 May 2006 12:38:31 -0500
Message-ID: <1148924311.3328.5.camel@mulgrave.il.steeleye.com>
References: <4474BCDE.5050107@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:1459 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1750727AbWE2Rih (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 13:38:37 -0400
In-Reply-To: <4474BCDE.5050107@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Moore, Eric Dean" <Eric.Moore@lsil.com>

On Wed, 2006-05-24 at 15:06 -0500, Michael Reed wrote:
> Reset processing sets ioc->active to zero.  This causes target discovery
> to be unable to read configuration pages which can result in fewer
> than the total number of targets being discovered.  This patch skips
> target discovery if ioc->active is zero.  The driver reschedules
> target discovery once ioc->active becomes non-zero.

This doesn't quite solve all cases, though, does it?  mpt_config()
returns -EAGAIN for both ioc->active set to zero *and* if we run out of
frames.

> This situation occurs when the lsiutil program is being used to reset
> the board.
> 
> (Logic change from previously posted 01-mptfc_eagain.patch.)

I was still thinking of something that made mpt_config() never return
-EAGAIN.  How does the following work out?  It's my first pass at
sorting out the frame and active logic in mptbase:

James

diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index a300840..585f42f 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -121,6 +121,11 @@ static int	mpt_base_index = -1;
 static int	last_drv_idx = -1;
 
 static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);
+/* This waitq is used for mpt_get_msg_frame failures which may be
+ * caused either by the ioc->active being zero or by the adapter being
+ * out of frames.  Receiving this event doesn't guarantee that a frame
+ * is available, so you must check */
+static DECLARE_WAIT_QUEUE_HEAD(mpt_config_waitq);
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /*
@@ -722,6 +727,13 @@ mpt_device_driver_deregister(int cb_idx)
 	MptDeviceDriverHandlers[cb_idx] = NULL;
 }
 
+static void
+mpt_ioc_activate(MPT_ADAPTER *ioc)
+{
+	ioc->active = 1;
+	wake_up(&mpt_config_waitq);
+}
+
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
 /**
@@ -835,6 +847,7 @@ #endif
 	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
 	dsgprintk((MYIOC_s_INFO_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
 	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
+	wake_up(&mpt_config_waitq);
 }
 
 /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
@@ -1582,7 +1595,7 @@ mpt_resume(struct pci_dev *pdev)
 
 	/* enable interrupts */
 	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
-	ioc->active = 1;
+	mpt_ioc_activate(ioc);
 
 	printk(MYIOC_s_INFO_FMT
 		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
@@ -1682,7 +1695,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 				dprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
 						ioc->alt_ioc->name));
 				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
-				ioc->alt_ioc->active = 1;
+				mpt_ioc_activate(ioc->alt_ioc);
 			}
 
 		} else {
@@ -1798,7 +1811,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 	if (ret == 0) {
 		/* Enable! (reply interrupt) */
 		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
-		ioc->active = 1;
+		mpt_ioc_activate(ioc);
 	}
 
 	if (reset_alt_ioc_active && ioc->alt_ioc) {
@@ -1806,7 +1819,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
 		dinitprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
 				ioc->alt_ioc->name));
 		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
-		ioc->alt_ioc->active = 1;
+		mpt_ioc_activate(ioc->alt_ioc);
 	}
 
 	/*  Enable MPT base driver management of EventNotification
@@ -4069,7 +4082,6 @@ #endif
  *	Return: 0 for success
  *	-ENOMEM if no memory available
  *		-EPERM if not allowed due to ISR context
- *		-EAGAIN if no msg frames currently available
  *		-EFAULT for non-successful reply or no reply (timeout)
  */
 static int
@@ -4181,7 +4193,6 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
  *	Return: 0 for success
  *	-ENOMEM if no memory available
  *		-EPERM if not allowed due to ISR context
- *		-EAGAIN if no msg frames currently available
  *		-EFAULT for non-successful reply or no reply (timeout)
  */
 int
@@ -4493,7 +4504,6 @@ mptbase_raid_process_event_data(MPT_ADAP
  *	Returns: 0 for success
  *	-ENOMEM if no memory available
  *		-EPERM if not allowed due to ISR context
- *		-EAGAIN if no msg frames currently available
  *		-EFAULT for non-successful reply or no reply (timeout)
  */
 static int
@@ -5156,7 +5166,6 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
  *
  *	Returns 0 for success
  *	-EPERM if not allowed due to ISR context
- *	-EAGAIN if no msg frames currently available
  *	-EFAULT for non-successful reply or no reply (timeout)
  */
 int
@@ -5182,10 +5191,10 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
 
 	/* Get and Populate a free Frame
 	 */
-	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
+	while ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
 		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
 				ioc->name));
-		return -EAGAIN;
+		wait_event(mpt_config_waitq, pCfg->wait_done);
 	}
 	pReq = (Config_t *)mf;
 	pReq->Action = pCfg->action;


