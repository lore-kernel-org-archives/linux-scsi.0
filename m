From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/7] hpsa: do not get enclosure info for external devices
Date: Tue, 23 Feb 2016 15:16:09 -0600
Message-ID: <20160223211609.5968.35948.stgit@brunhilda>
References: <20160223210957.5968.6998.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:37131 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755328AbcBWVQL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Feb 2016 16:16:11 -0500
In-Reply-To: <20160223210957.5968.6998.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@odin.com, Viswas.G@pmcs.com, scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, Mahesh.Rajashekhara@pmcs.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

Stop annoying "Error, could not get enclosure information"
messages.

Reviewed-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Justin Lindley <justin.lindley@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 38ce0e3..098e8de 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3208,8 +3208,10 @@ static void hpsa_get_enclosure_info(struct ctlr_info *h,
 
 	bmic_device_index = GET_BMIC_DRIVE_NUMBER(&rle->lunid[0]);
 
-	if (bmic_device_index == 0xFF00)
+	if (bmic_device_index == 0xFF00 || MASKED_DEVICE(&rle->lunid[0])) {
+		rc = IO_OK;
 		goto out;
+	}
 
 	bssbp = kzalloc(sizeof(*bssbp), GFP_KERNEL);
 	if (!bssbp)
@@ -4197,7 +4199,8 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			ncurrent++;
 			break;
 		case TYPE_ENCLOSURE:
-			hpsa_get_enclosure_info(h, lunaddrbytes,
+			if (!this_device->external)
+				hpsa_get_enclosure_info(h, lunaddrbytes,
 						physdev_list, phys_dev_index,
 						this_device);
 			ncurrent++;

