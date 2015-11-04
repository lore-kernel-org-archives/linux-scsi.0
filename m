From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 05/27] hpsa: check for null arguments to dev_printk
Date: Wed, 04 Nov 2015 15:50:25 -0600
Message-ID: <20151104215025.15472.12183.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:53336 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965397AbbKDVyS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:18 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Check for NULLs.

Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Manoj Kumar <manoj@linux.vnet.ibm.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 5a996273..b64913f 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1138,6 +1138,9 @@ static int hpsa_find_target_lun(struct ctlr_info *h,
 static inline void hpsa_show_dev_msg(const char *level, struct ctlr_info *h,
 	struct hpsa_scsi_dev_t *dev, char *description)
 {
+	if (h == NULL || h->pdev == NULL || h->scsi_host == NULL)
+		return;
+
 	dev_printk(level, &h->pdev->dev,
 			"scsi %d:%d:%d:%d: %s %s %.8s %.16s RAID-%s SSDSmartPathCap%c En%c Exp=%d\n",
 			h->scsi_host->host_no, dev->bus, dev->target, dev->lun,

