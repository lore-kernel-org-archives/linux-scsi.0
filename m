From: Eric Moore <eric.moore@lsi.com>
Subject: RE: [PATCH] scsi spi transport: SCSI domain validation after reset
Date: Wed, 7 Feb 2007 16:51:40 -0700
Message-ID: <20070207235140.GA20920@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:65162 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422790AbXBGXwn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Feb 2007 18:52:43 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@SteelEye.com, markh@linux-foundation.org, linux-scsi@vger.kernel.org

> -----Original Message-----
> From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
> Sent: Monday, February 05, 2007 2:50 PM
> To: Mark Haverkamp
> Cc: linux-scsi; Moore, Eric
> Subject: Re: [PATCH] scsi spi transport: SCSI domain 
> validation after reset
> 
> On Mon, 2007-02-05 at 12:49 -0800, Mark Haverkamp wrote:
> > James,
> > 
> > Some months ago, I had problems with a mis-behaving disk that failed
> > domain validation on a fusion card resulting in an infinite loop of
> > domain validation.  At the time Eric proposed a patch to the mptspi
> > driver to reload devices with parameters previously 
> negotiated when a
> > reset occurred.  You indicated that a more generic solution 
> should be
> > done.
> > 
> > This patch updates spi_dv_device_internal() to check if domain
> > validation has already been performed on a device and just sets it
> > previously negotiated parameters.  This solved the "infinite domain
> > validation" loop for me when a reset is performed as a 
> result of command
> > timeout with the mis-behaving device.
> 
> Er,but this code basically disabled domain revalidation after a reset,
> doesn't it?  If we could do it that way, we could simply take 
> the calls
> to spi_dv_device() out of the fusion driver and instead set the
> parameters up in its place without having to modify the 
> transport class.
> 

Here is a patch that does exactly that.

After host reset, the device are programmed to default asyn narrow nego.
We need to reprogram the parameter back to previous values.  If the host
reset is called as a result of spi_dv_device() commands timing out, its
possible to get into an infinite loop of dv to host reset.  This will
prevent that case, as we merely program old values.  If host reset is
called outside context of domain validation, then we can  call
spi_dv_device. Please apply.

This applies over scsi-misc tree.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>


diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
--- b/drivers/message/fusion/mptbase.h	2007-02-07 15:20:35.000000000 -0700
+++ a/drivers/message/fusion/mptbase.h	2007-02-07 12:21:33.000000000 -0700
@@ -994,6 +994,7 @@ typedef struct _MPT_SCSI_HOST {
 	int			  scandv_wait_done;
 	long			  last_queue_full;
 	u16			  tm_iocstatus;
+	u16			  spi_pending;
 	struct list_head	  target_reset_list;
 } MPT_SCSI_HOST;
 
diff -uarpN b/drivers/message/fusion/mptspi.c a/drivers/message/fusion/mptspi.c
--- b/drivers/message/fusion/mptspi.c	2007-02-07 15:20:35.000000000 -0700
+++ a/drivers/message/fusion/mptspi.c	2007-02-07 12:24:35.000000000 -0700
@@ -678,7 +678,9 @@ static void mptspi_dv_device(struct _MPT
 		return;
 	}
 
+	hd->spi_pending |= (1 << sdev->id);
 	spi_dv_device(sdev);
+	hd->spi_pending &= ~(1 << sdev->id);
 
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 0, vtarget->channel, vtarget->id) < 0)
@@ -1204,11 +1206,27 @@ mptspi_dv_renegotiate_work(struct work_s
 		container_of(work, struct work_queue_wrapper, work);
 	struct _MPT_SCSI_HOST *hd = wqw->hd;
 	struct scsi_device *sdev;
+	struct scsi_target *starget;
+	struct _CONFIG_PAGE_SCSI_DEVICE_1 pg1;
+	u32 nego;
 
 	kfree(wqw);
 
-	shost_for_each_device(sdev, hd->ioc->sh)
-		mptspi_dv_device(hd, sdev);
+	if (hd->spi_pending) {
+		shost_for_each_device(sdev, hd->ioc->sh) {
+			if  (hd->spi_pending & (1 << sdev->id))
+				continue;
+			starget = scsi_target(sdev);
+			nego = mptspi_getRP(starget);
+			pg1.RequestedParameters = cpu_to_le32(nego);
+			pg1.Reserved = 0;
+			pg1.Configuration = 0;
+			mptspi_write_spi_device_pg1(starget, &pg1);
+		}
+	} else {
+		shost_for_each_device(sdev, hd->ioc->sh)
+			mptspi_dv_device(hd, sdev);
+	}
 }
 
 static void
@@ -1454,6 +1472,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
+	hd->spi_pending = 0;
 
 	/* Some versions of the firmware don't support page 0; without
 	 * that we can't get the parameters */

