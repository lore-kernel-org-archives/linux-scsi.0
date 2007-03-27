From: akpm@linux-foundation.org
Subject: [patch 23/28] mpt-fusion: reprogram spi state after host reset
Date: Mon, 26 Mar 2007 21:59:39 -0800
Message-ID: <200703270559.l2R5xdlY008690@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:40890 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934072AbXC0F7n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 27 Mar 2007 01:59:43 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, eric.moore@lsi.com, Eric.Moore@lsi.com, markh@linux-foundation.org

From: Eric Moore <eric.moore@lsi.com>

After host reset, the device are programmed to default asyn narrow nego. 
We need to reprogram the parameter back to previous values.  If the host
reset is called as a result of spi_dv_device() commands timing out, its
possible to get into an infinite loop of dv to host reset.  This will
prevent that case, as we merely program old values.  If host reset is
called outside context of domain validation, then we can call
spi_dv_device.  Please apply.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>
Cc: Mark Haverkamp <markh@linux-foundation.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/message/fusion/mptbase.h |    1 +
 drivers/message/fusion/mptspi.c  |   23 +++++++++++++++++++++--
 2 files changed, 22 insertions(+), 2 deletions(-)

diff -puN drivers/message/fusion/mptbase.h~scsi-spi-transport-scsi-domain-validation-after-reset drivers/message/fusion/mptbase.h
--- a/drivers/message/fusion/mptbase.h~scsi-spi-transport-scsi-domain-validation-after-reset
+++ a/drivers/message/fusion/mptbase.h
@@ -994,6 +994,7 @@ typedef struct _MPT_SCSI_HOST {
 	int			  scandv_wait_done;
 	long			  last_queue_full;
 	u16			  tm_iocstatus;
+	u16			  spi_pending;
 	struct list_head	  target_reset_list;
 } MPT_SCSI_HOST;
 
diff -puN drivers/message/fusion/mptspi.c~scsi-spi-transport-scsi-domain-validation-after-reset drivers/message/fusion/mptspi.c
--- a/drivers/message/fusion/mptspi.c~scsi-spi-transport-scsi-domain-validation-after-reset
+++ a/drivers/message/fusion/mptspi.c
@@ -676,7 +676,9 @@ static void mptspi_dv_device(struct _MPT
 		return;
 	}
 
+	hd->spi_pending |= (1 << sdev->id);
 	spi_dv_device(sdev);
+	hd->spi_pending &= ~(1 << sdev->id);
 
 	if (sdev->channel == 1 &&
 	    mptscsih_quiesce_raid(hd, 0, vtarget->channel, vtarget->id) < 0)
@@ -1202,11 +1204,27 @@ mptspi_dv_renegotiate_work(struct work_s
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
@@ -1452,6 +1470,7 @@ mptspi_probe(struct pci_dev *pdev, const
 	init_waitqueue_head(&hd->scandv_waitq);
 	hd->scandv_wait_done = 0;
 	hd->last_queue_full = 0;
+	hd->spi_pending = 0;
 
 	/* Some versions of the firmware don't support page 0; without
 	 * that we can't get the parameters */
_
