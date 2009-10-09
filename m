From: "Ed Lin" <ed.lin@promise.com>
Subject: [PATCH] scsi: fix inconsistent usage of max_lun
Date: Fri, 9 Oct 2009 15:23:27 -0700
Message-ID: <200910091523266186177@promise.com>
Reply-To: ed.lin@promise.com
Mime-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gateway.promise.com ([67.111.72.2]:35350 "EHLO
	nonamew.ptu.promise.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S934014AbZJIWYV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Oct 2009 18:24:21 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James.Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>


max_lun in struct Scsi_Host is used as actual max lun
plus 1 in scsi_sequential_lun_scan()(scsi_scan.c).
However it is also used as actual max lun in some
other cases.

According to the comment in the definition of struct
Scsi_Host, max_lun should be set to 1 more than the
actual max lun, just like max_id. Fix the problem
according to this definition.

Signed-off-by: Ed Lin <ed.lin@promise.com>
---

 drivers/scsi/3w-xxxx.c           |    2 +-
 drivers/scsi/scsi_scan.c         |    4 ++--
 drivers/scsi/scsi_transport_fc.c |    2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/3w-xxxx.c b/drivers/scsi/3w-xxxx.c
index faa0fcf..4e91650 100644
--- a/drivers/scsi/3w-xxxx.c
+++ b/drivers/scsi/3w-xxxx.c
@@ -2321,7 +2321,7 @@ static int __devinit tw_probe(struct pci_dev *pdev, const struct pci_device_id *
 	host->max_cmd_len = TW_MAX_CDB_LEN;
 
 	/* Luns and channels aren't supported by adapter */
-	host->max_lun = 0;
+	host->max_lun = 1;
 	host->max_channel = 0;
 
 	/* Register the card with the kernel SCSI layer */
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index c447838..cb6338f 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1468,7 +1468,7 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 			for (i = 0; i < sizeof(struct scsi_lun); i++)
 				printk("%02x", data[i]);
 			printk(" has a LUN larger than currently supported.\n");
-		} else if (lun > sdev->host->max_lun) {
+		} else if (lun >= sdev->host->max_lun) {
 			printk(KERN_WARNING "scsi: %s lun%d has a LUN larger"
 			       " than allowed by the host adapter\n",
 			       devname, lun);
@@ -1681,7 +1681,7 @@ int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
-	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+	    ((lun != SCAN_WILD_CARD) && (lun >= shost->max_lun)))
 		return -EINVAL;
 
 	mutex_lock(&shost->scan_mutex);
diff --git a/drivers/scsi/scsi_transport_fc.c b/drivers/scsi/scsi_transport_fc.c
index b98885d..e7518a2 100644
--- a/drivers/scsi/scsi_transport_fc.c
+++ b/drivers/scsi/scsi_transport_fc.c
@@ -1992,7 +1992,7 @@ fc_user_scan(struct Scsi_Host *shost, uint channel, uint id, uint lun)
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id >= shost->max_id)) ||
-	    ((lun != SCAN_WILD_CARD) && (lun > shost->max_lun)))
+	    ((lun != SCAN_WILD_CARD) && (lun >= shost->max_lun)))
 		return -EINVAL;
 
 	if (channel == SCAN_WILD_CARD) {


