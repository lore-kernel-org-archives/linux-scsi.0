From: hare@suse.de (Hannes Reinecke)
Subject: [PATCH 5/9] Fixup LLDDs to check for valid hostdata pointer
Date: Wed, 23 May 2007 10:55:38 +0200
Message-ID: <20070523085538.1764ED44CB@pentland.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:35155 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758427AbXEWIzj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 May 2007 04:55:39 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: linux-scsi@vger.kernel.org


slave_destory() is now called asynchronously, hence we have to
check if the ->hostdata pointer is valid before accessing it.
Fixup all LLDDs to verify the hostdata pointer.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/message/fusion/mptscsih.c   |    2 ++
 drivers/s390/scsi/zfcp_scsi.c       |    3 ---
 drivers/scsi/53c700.c               |    6 ++++--
 drivers/scsi/aic7xxx_old.c          |    8 +++++---
 drivers/scsi/esp_scsi.c             |    6 ++++--
 drivers/scsi/sym53c8xx_2/sym_glue.c |    2 ++
 6 files changed, 17 insertions(+), 10 deletions(-)

diff --git a/drivers/message/fusion/mptscsih.c b/drivers/message/fusion/mptscsih.c
index fa0f776..2907489 100644
--- a/drivers/message/fusion/mptscsih.c
+++ b/drivers/message/fusion/mptscsih.c
@@ -2314,6 +2314,8 @@ mptscsih_slave_destroy(struct scsi_devic
 	starget = scsi_target(sdev);
 	vtarget = starget->hostdata;
 	vdevice = sdev->hostdata;
+	if (!vdevice)
+		return;
 
 	mptscsih_search_running_cmds(hd, vdevice);
 	vtarget->num_luns--;
diff --git a/drivers/s390/scsi/zfcp_scsi.c b/drivers/s390/scsi/zfcp_scsi.c
index 16e2d64..bae2093 100644
--- a/drivers/s390/scsi/zfcp_scsi.c
+++ b/drivers/s390/scsi/zfcp_scsi.c
@@ -189,9 +189,6 @@ static void zfcp_scsi_slave_destroy(stru
 		unit->device = NULL;
 		zfcp_erp_unit_failed(unit);
 		zfcp_unit_put(unit);
-	} else {
-		ZFCP_LOG_NORMAL("bug: no unit associated with SCSI device at "
-				"address %p\n", sdpnt);
 	}
 }
 
diff --git a/drivers/scsi/53c700.c b/drivers/scsi/53c700.c
index cb02656..50a5d92 100644
--- a/drivers/scsi/53c700.c
+++ b/drivers/scsi/53c700.c
@@ -2103,8 +2103,10 @@ NCR_700_slave_configure(struct scsi_devi
 STATIC void
 NCR_700_slave_destroy(struct scsi_device *SDp)
 {
-	kfree(SDp->hostdata);
-	SDp->hostdata = NULL;
+	if (SDp->hostdata) {
+		kfree(SDp->hostdata);
+		SDp->hostdata = NULL;
+	}
 }
 
 static int
diff --git a/drivers/scsi/aic7xxx_old.c b/drivers/scsi/aic7xxx_old.c
index a988d5a..fcc0dfa 100644
--- a/drivers/scsi/aic7xxx_old.c
+++ b/drivers/scsi/aic7xxx_old.c
@@ -6733,9 +6733,11 @@ aic7xxx_slave_destroy(struct scsi_device
 {
   struct aic_dev_data *aic_dev = SDptr->hostdata;
 
-  list_del(&aic_dev->list);
-  SDptr->hostdata = NULL;
-  kfree(aic_dev);
+  if (aic_dev) {
+    list_del(&aic_dev->list);
+    SDptr->hostdata = NULL;
+    kfree(aic_dev);
+  }
   return;
 }
 
diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
index ec71061..b32595f 100644
--- a/drivers/scsi/esp_scsi.c
+++ b/drivers/scsi/esp_scsi.c
@@ -2416,8 +2416,10 @@ static void esp_slave_destroy(struct scs
 {
 	struct esp_lun_data *lp = dev->hostdata;
 
-	kfree(lp);
-	dev->hostdata = NULL;
+	if (dev->hostdata) {
+		kfree(lp);
+		dev->hostdata = NULL;
+	}
 }
 
 static int esp_eh_abort_handler(struct scsi_cmnd *cmd)
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 4d78c7e..bba2df1 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -983,6 +983,8 @@ static void sym53c8xx_slave_destroy(stru
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
 	struct sym_lcb *lp = sym_lp(&np->target[sdev->id], sdev->lun);
 
+	if (!lp)
+		return;
 	if (lp->itlq_tbl)
 		sym_mfree_dma(lp->itlq_tbl, SYM_CONF_MAX_TASK * 4, "ITLQ_TBL");
 	kfree(lp->cb_tags);
-- 
1.4.3.4

