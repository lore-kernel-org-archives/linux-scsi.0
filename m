From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 1 03/25] hpsa: check for null arguments to dev_printk
Date: Wed, 28 Oct 2015 17:04:47 -0500
Message-ID: <20151028220447.5323.79638.stgit@brunhilda>
References: <20151028215206.5323.84194.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:48767 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752688AbbJ1WId (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Oct 2015 18:08:33 -0400
In-Reply-To: <20151028215206.5323.84194.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Check for NULLs.

Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    6 ++++++
 drivers/scsi/hpsa.h |    2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 864fb03..6b6e9bb 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1139,6 +1139,12 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *dev, char *description)
 {
+	if (dev == NULL)
+		return;
+
+	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
+		return;
+
 	dev_printk(level, &h->pdev->dev,
 			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,
diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 27debb3..d6c4ebf 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -34,7 +34,7 @@ struct access_method {
 };
 
 struct hpsa_scsi_dev_t {
-	int devtype;
+	unsigned int devtype;
 	int bus, target, lun;		/* as presented to the OS */
 	unsigned char scsi3addr[8];	/* as presented to the HW */
 #define RAID_CTLR_LUNID "\0\0\0\0\0\0\0\0"

