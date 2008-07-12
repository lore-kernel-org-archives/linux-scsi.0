From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PATCH] (hopefully) final SCSI bug fixes for 2.6.26-rc9
Date: Sat, 12 Jul 2008 10:37:23 -0500
Message-ID: <1215877043.3360.4.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35486 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753402AbYGLPh1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 12 Jul 2008 11:37:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

These represent what I think are the essential fixes before we go
2.6.26.  All except two fix basic oopses.  One of the non-oops fixes is
the bogus data erase which makes certain USB devices no longer read
only; the other is to turn off MSI on fusion FC and SPI.  This fixes
quite a lot of hung boots because of lost interrupts.

The patch is available from:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git

The short changelog is:

Alan Stern (1):
      erase invalid data returned by device

Brian King (1):
      ipr: Fix HDIO_GET_IDENTITY oops for SATA devices

James Bottomley (3):
      bsg: fix oops on remove
      fusion: default MSI to disabled for SPI and FC controllers
      mptspi: fix oops in mptspi_dv_renegotiate_work()

The diffstat is:

 block/bsg.c                      |    3 ++-
 drivers/message/fusion/mptbase.c |   11 ++++++++---
 drivers/message/fusion/mptspi.c  |    9 +++++++--
 drivers/scsi/ipr.c               |    6 +++++-
 drivers/scsi/scsi_lib.c          |    9 +++++++++
 5 files changed, 31 insertions(+), 7 deletions(-)

And the entire diff is attached below.

James

---

diff --git a/block/bsg.c b/block/bsg.c
index f0b7cd3..54d617f 100644
--- a/block/bsg.c
+++ b/block/bsg.c
@@ -709,11 +709,12 @@ static void bsg_kref_release_function(struct kref *kref)
 {
 	struct bsg_class_device *bcd =
 		container_of(kref, struct bsg_class_device, ref);
+	struct device *parent = bcd->parent;
 
 	if (bcd->release)
 		bcd->release(bcd->parent);
 
-	put_device(bcd->parent);
+	put_device(parent);
 }
 
 static int bsg_put_device(struct bsg_device *bd)
diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
index db3c892..d40d6d1 100644
--- a/drivers/message/fusion/mptbase.c
+++ b/drivers/message/fusion/mptbase.c
@@ -1686,9 +1686,14 @@ mpt_attach(struct pci_dev *pdev, const struct pci_device_id *id)
 		ioc->bus_type = SAS;
 	}
 
-	if (ioc->bus_type == SAS && mpt_msi_enable == -1)
-		ioc->msi_enable = 1;
-	else
+	if (mpt_msi_enable == -1) {
+		/* Enable on SAS, disable on FC and SPI */
+		if (ioc->bus_type == SAS)
+			ioc->msi_enable = 1;
+		else
+			ioc->msi_enable = 0;
+	} else
+		/* follow flag: 0 - disable; 1 - enable */
 		ioc->msi_enable = mpt_msi_enable;
 
 	if (ioc->errata_flag_1064)
diff --git a/drivers/message/fusion/mptspi.c b/drivers/message/fusion/mptspi.c
index 25bcfcf..1effca4 100644
--- a/drivers/message/fusion/mptspi.c
+++ b/drivers/message/fusion/mptspi.c
@@ -1266,13 +1266,18 @@ mptspi_dv_renegotiate(struct _MPT_SCSI_HOST *hd)
 static int
 mptspi_ioc_reset(MPT_ADAPTER *ioc, int reset_phase)
 {
-	struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
 	int rc;
 
 	rc = mptscsih_ioc_reset(ioc, reset_phase);
 
-	if (reset_phase == MPT_IOC_POST_RESET)
+	/* only try to do a renegotiation if we're properly set up
+	 * if we get an ioc fault on bringup, ioc->sh will be NULL */
+	if (reset_phase == MPT_IOC_POST_RESET &&
+	    ioc->sh) {
+		struct _MPT_SCSI_HOST *hd = shost_priv(ioc->sh);
+
 		mptspi_dv_renegotiate(hd);
+	}
 
 	return rc;
 }
diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 999e91e..e7a3a65 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -71,6 +71,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/libata.h>
+#include <linux/hdreg.h>
 #include <asm/io.h>
 #include <asm/irq.h>
 #include <asm/processor.h>
@@ -4913,8 +4914,11 @@ static int ipr_ioctl(struct scsi_device *sdev, int cmd, void __user *arg)
 	struct ipr_resource_entry *res;
 
 	res = (struct ipr_resource_entry *)sdev->hostdata;
-	if (res && ipr_is_gata(res))
+	if (res && ipr_is_gata(res)) {
+		if (cmd == HDIO_GET_IDENTITY)
+			return -ENOTTY;
 		return ata_scsi_ioctl(sdev, cmd, arg);
+	}
 
 	return -EINVAL;
 }
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index a82d2fe..cbf55d5 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -207,6 +207,15 @@ int scsi_execute(struct scsi_device *sdev, const unsigned char *cmd,
 	 */
 	blk_execute_rq(req->q, NULL, req, 1);
 
+	/*
+	 * Some devices (USB mass-storage in particular) may transfer
+	 * garbage data together with a residue indicating that the data
+	 * is invalid.  Prevent the garbage from being misinterpreted
+	 * and prevent security leaks by zeroing out the excess data.
+	 */
+	if (unlikely(req->data_len > 0 && req->data_len <= bufflen))
+		memset(buffer + (bufflen - req->data_len), 0, req->data_len);
+
 	ret = req->errors;
  out:
 	blk_put_request(req);


