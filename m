From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.2-rc2
Date: Thu, 17 Nov 2011 10:47:24 -0600
Message-ID: <1321548444.3041.45.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:56168 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757824Ab1KQQr1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Nov 2011 11:47:27 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org

This is a missing allocation (leading to oops), a couple of warnings
silenced and some fixes for PCIe non-default power modes hanging I/O
cards.

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

The head sha1 is

commit e5a44df85e8d78e5c2d3d2e4f59b460905691e2f

The fix is available here:

git://bedivere.hansenpartnership.com/git/scsi-rc-fixes-2.6.git
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQEcBAEBAgAGBQJOxTpWAAoJEDeqqVYsXL0MWQQH/RUpPw3RXHoYyksMAzxSKW/n
rkbEzbUirJx6K5QO+lOIPZ8IQCV07IZ1UmX8Ab7ojYV0zjmNhExZqQ6W+yYjSty2
p5An5T2doMeVZtAygBIhFV+h/hulMBZJSaTG+VtP+8dA932NNc19bvH819rDMpDN
kpnTAGsJ/sXK80yvmM3bq6mrGB4yp4FMalqAtK97Aa18k9kDTO5t4giAEhfbu6Rr
FAh89Z/81giL9ZOeIuJbZr6o1IzAuj1J/7yVi5bHtoDednUynapfR8aBwCV9h1i3
exW8CHTp4ZfZLaja6VH485b175RhIp/+1Zr6qRx4wt4cV+g1EitTNNFxjZSC6CQ=
=Rvdl
-----END PGP SIGNATURE-----


The short changelog is

Dan Carpenter (1):
      mpt2sas: add missing allocation.

Hannes Reinecke (1):
      Silencing 'killing requests for dead queue'

James Bottomley (1):
      fix WARNING: at drivers/scsi/scsi_lib.c:1704

Matthew Garrett (1):
      hpsa: Disable ASPM

Vasily Averin (1):
      aacraid: controller hangs if kernel uses non-default ASPM policy

and the diffstat:

 drivers/scsi/aacraid/linit.c         |    4 ++++
 drivers/scsi/hpsa.c                  |    5 +++++
 drivers/scsi/mpt2sas/mpt2sas_scsih.c |    5 +++++
 drivers/scsi/scsi_lib.c              |    3 ++-
 drivers/scsi/scsi_scan.c             |    6 +-----
 5 files changed, 17 insertions(+), 6 deletions(-)

Full diff is below

James

---

diff --git a/drivers/scsi/aacraid/linit.c b/drivers/scsi/aacraid/linit.c
index 4aa76d6..705e13e 100644
--- a/drivers/scsi/aacraid/linit.c
+++ b/drivers/scsi/aacraid/linit.c
@@ -38,6 +38,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/slab.h>
 #include <linux/mutex.h>
 #include <linux/spinlock.h>
@@ -1109,6 +1110,9 @@ static int __devinit aac_probe_one(struct pci_dev *pdev,
 		unique_id++;
 	}
 
+	pci_disable_link_state(pdev, PCIE_LINK_STATE_L0S | PCIE_LINK_STATE_L1 |
+			       PCIE_LINK_STATE_CLKPM);
+
 	error = pci_enable_device(pdev);
 	if (error)
 		goto out;
diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e76107b..865d452 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -23,6 +23,7 @@
 #include <linux/interrupt.h>
 #include <linux/types.h>
 #include <linux/pci.h>
+#include <linux/pci-aspm.h>
 #include <linux/kernel.h>
 #include <linux/slab.h>
 #include <linux/delay.h>
@@ -3922,6 +3923,10 @@ static int __devinit hpsa_pci_init(struct ctlr_info *h)
 		dev_warn(&h->pdev->dev, "controller appears to be disabled\n");
 		return -ENODEV;
 	}
+
+	pci_disable_link_state(h->pdev, PCIE_LINK_STATE_L0S |
+			       PCIE_LINK_STATE_L1 | PCIE_LINK_STATE_CLKPM);
+
 	err = pci_enable_device(h->pdev);
 	if (err) {
 		dev_warn(&h->pdev->dev, "unable to enable PCI device\n");
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index 8889b1b..4e041f6 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -2802,6 +2802,11 @@ _scsih_error_recovery_delete_devices(struct MPT2SAS_ADAPTER *ioc)
 
 	if (ioc->is_driver_loading)
 		return;
+
+	fw_event = kzalloc(sizeof(struct fw_event_work), GFP_ATOMIC);
+	if (!fw_event)
+		return;
+
 	fw_event->event = MPT2SAS_REMOVE_UNRESPONDING_DEVICES;
 	fw_event->ioc = ioc;
 	_scsih_fw_event_add(ioc, fw_event);
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 06bc265..f85cfa6 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1409,6 +1409,8 @@ static void scsi_kill_request(struct request *req, struct request_queue *q)
 
 	blk_start_request(req);
 
+	scmd_printk(KERN_INFO, cmd, "killing request\n");
+
 	sdev = cmd->device;
 	starget = scsi_target(sdev);
 	shost = sdev->host;
@@ -1490,7 +1492,6 @@ static void scsi_request_fn(struct request_queue *q)
 	struct request *req;
 
 	if (!sdev) {
-		printk("scsi: killing requests for dead queue\n");
 		while ((req = blk_peek_request(q)) != NULL)
 			scsi_kill_request(req, q);
 		return;
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 72273a0..b3c6d95 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -319,11 +319,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	return sdev;
 
 out_device_destroy:
-	scsi_device_set_state(sdev, SDEV_DEL);
-	transport_destroy_device(&sdev->sdev_gendev);
-	put_device(&sdev->sdev_dev);
-	scsi_free_queue(sdev->request_queue);
-	put_device(&sdev->sdev_gendev);
+	__scsi_remove_device(sdev);
 out:
 	if (display_failure_msg)
 		printk(ALLOC_FAILURE_MSG, __func__);



