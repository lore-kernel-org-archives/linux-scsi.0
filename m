From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 11/30] hpsa: eliminate unnecessary memcpys
Date: Thu, 04 Feb 2010 08:42:19 -0600
Message-ID: <20100204144219.10406.86923.stgit@beardog.cce.hp.com>
References: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:28608 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932722Ab0BDOjk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Feb 2010 09:39:40 -0500
In-Reply-To: <20100204144012.10406.14868.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org
Cc: mikem@beardog.cce.hp.com, brace@beardog.cce.hp.com, matthew.gates@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

hpsa: eliminate unnecessary memcpys

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
---
 drivers/scsi/hpsa.c |   11 +++--------
 1 files changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 4594200..ba3dead 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1483,14 +1483,11 @@ static void figure_bus_target_lun(struct ctlr_info *h,
 	u8 *lunaddrbytes, int *bus, int *target, int *lun,
 	struct hpsa_scsi_dev_t *device)
 {
-
 	u32 lunid;
 
 	if (is_logical_dev_addr_mode(lunaddrbytes)) {
 		/* logical device */
-		memcpy(&lunid, lunaddrbytes, sizeof(lunid));
-		lunid = le32_to_cpu(lunid);
-
+		lunid = le32_to_cpu(*((__le32 *) lunaddrbytes));
 		if (is_msa2xxx(h, device)) {
 			*bus = 1;
 			*target = (lunid >> 16) & 0x3fff;
@@ -1578,8 +1575,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 		dev_err(&h->pdev->dev, "report physical LUNs failed.\n");
 		return -1;
 	}
-	memcpy(nphysicals, &physdev->LUNListLength[0], sizeof(*nphysicals));
-	*nphysicals = be32_to_cpu(*nphysicals) / 8;
+	*nphysicals = be32_to_cpu(*((__be32 *)physdev->LUNListLength)) / 8;
 	if (*nphysicals > HPSA_MAX_PHYS_LUN) {
 		dev_warn(&h->pdev->dev, "maximum physical LUNs (%d) exceeded."
 			"  %d LUNs ignored.\n", HPSA_MAX_PHYS_LUN,
@@ -1590,8 +1586,7 @@ static int hpsa_gather_lun_info(struct ctlr_info *h,
 		dev_err(&h->pdev->dev, "report logical LUNs failed.\n");
 		return -1;
 	}
-	memcpy(nlogicals, &logdev->LUNListLength[0], sizeof(*nlogicals));
-	*nlogicals = be32_to_cpu(*nlogicals) / 8;
+	*nlogicals = be32_to_cpu(*((__be32 *) logdev->LUNListLength)) / 8;
 	/* Reject Logicals in excess of our max capability. */
 	if (*nlogicals > HPSA_MAX_LUN) {
 		dev_warn(&h->pdev->dev,

