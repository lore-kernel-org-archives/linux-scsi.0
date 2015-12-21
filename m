From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 1/3] hpsa: fix path_info_show
Date: Mon, 21 Dec 2015 11:21:33 -0600
Message-ID: <20151221172133.14423.27809.stgit@brunhilda>
References: <20151221171516.14423.37938.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:60832 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751233AbbLURWV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2015 12:22:21 -0500
In-Reply-To: <20151221171516.14423.37938.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com, james.bottomley@parallels.com
Cc: linux-scsi@vger.kernel.org

left off some changes from Rasmus Villemoes where he changed
snprintf to scnprintf

Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Reviewed-by: Hannes Reinecke <hare@suse.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index a386036..f8370b8 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -795,7 +795,7 @@ static ssize_t path_info_show(struct device *dev,
 		if (hdev->external ||
 			hdev->devtype == TYPE_RAID ||
 			is_logical_device(hdev)) {
-			output_len += snprintf(buf + output_len,
+			output_len += scnprintf(buf + output_len,
 						PAGE_SIZE - output_len,
 						"%s\n", active);
 			continue;
@@ -809,28 +809,28 @@ static ssize_t path_info_show(struct device *dev,
 		if (phys_connector[1] < '0')
 			phys_connector[1] = '0';
 		if (hdev->phys_connector[i] > 0)
-			output_len += snprintf(buf + output_len,
+			output_len += scnprintf(buf + output_len,
 				PAGE_SIZE - output_len,
 				"PORT: %.2s ",
 				phys_connector);
 		if (hdev->devtype == TYPE_DISK && hdev->expose_device) {
 			if (box == 0 || box == 0xFF) {
-				output_len += snprintf(buf + output_len,
+				output_len += scnprintf(buf + output_len,
 					PAGE_SIZE - output_len,
 					"BAY: %hhu %s\n",
 					bay, active);
 			} else {
-				output_len += snprintf(buf + output_len,
+				output_len += scnprintf(buf + output_len,
 					PAGE_SIZE - output_len,
 					"BOX: %hhu BAY: %hhu %s\n",
 					box, bay, active);
 			}
 		} else if (box != 0 && box != 0xFF) {
-			output_len += snprintf(buf + output_len,
+			output_len += scnprintf(buf + output_len,
 				PAGE_SIZE - output_len, "BOX: %hhu %s\n",
 				box, active);
 		} else
-			output_len += snprintf(buf + output_len,
+			output_len += scnprintf(buf + output_len,
 				PAGE_SIZE - output_len, "%s\n", active);
 	}
 

