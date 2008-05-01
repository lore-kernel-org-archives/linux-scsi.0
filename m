From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 2/4] isd200: Use new scsi_allocate_command()
Date: Thu, 01 May 2008 16:58:46 +0300
Message-ID: <4819CC96.4070803__39819.8190647692$1209650401$gmane$org@panasas.com>
References: <4819C9DB.60104@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:6190 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754709AbYEAN7C (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2008 09:59:02 -0400
In-Reply-To: <4819C9DB.60104@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, USB list <linux-usb@vger.kernel.org>, Alan Stern <stern@rowland.harvard.edu>
Cc: Andi Kleen <andi@firstfloor.org>


Don't let isd200 struggle with scsi_cmnd allocation and construction.
Use the new scsi_allocate_command()/scsi_free_command() for that.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
CC: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
---
 drivers/usb/storage/isd200.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/storage/isd200.c b/drivers/usb/storage/isd200.c
index 971d13d..756d30f 100644
--- a/drivers/usb/storage/isd200.c
+++ b/drivers/usb/storage/isd200.c
@@ -292,7 +292,7 @@ struct isd200_info {
 
 	/* maximum number of LUNs supported */
 	unsigned char MaxLUNs;
-	struct scsi_cmnd srb;
+	struct scsi_cmnd *srb;
 	struct scatterlist sg;
 };
 
@@ -414,7 +414,7 @@ static void isd200_build_sense(struct us_data *us, struct scsi_cmnd *srb)
 static void isd200_set_srb(struct isd200_info *info,
 	enum dma_data_direction dir, void* buff, unsigned bufflen)
 {
-	struct scsi_cmnd *srb = &info->srb;
+	struct scsi_cmnd *srb = info->srb;
 
 	if (buff)
 		sg_init_one(&info->sg, buff, bufflen);
@@ -445,7 +445,7 @@ static int isd200_action( struct us_data *us, int action,
 	union ata_cdb ata;
 	struct scsi_device srb_dev;
 	struct isd200_info *info = (struct isd200_info *)us->extra;
-	struct scsi_cmnd *srb = &info->srb;
+	struct scsi_cmnd *srb = info->srb;
 	int status;
 
 	memset(&ata, 0, sizeof(ata));
@@ -1470,7 +1470,8 @@ static void isd200_free_info_ptrs(void *info_)
 	if (info) {
 		kfree(info->id);
 		kfree(info->RegsBuf);
-		kfree(info->srb.sense_buffer);
+		if (info->srb)
+			scsi_free_command(info->srb);
 	}
 }
 
@@ -1496,9 +1497,8 @@ static int isd200_init_info(struct us_data *us)
 				kzalloc(sizeof(struct hd_driveid), GFP_KERNEL);
 		info->RegsBuf = (unsigned char *)
 				kmalloc(sizeof(info->ATARegs), GFP_KERNEL);
-		info->srb.sense_buffer =
-				kmalloc(SCSI_SENSE_BUFFERSIZE, GFP_KERNEL);
-		if (!info->id || !info->RegsBuf || !info->srb.sense_buffer) {
+		info->srb = scsi_allocate_command(GFP_KERNEL);
+		if (!info->id || !info->RegsBuf || !info->srb) {
 			isd200_free_info_ptrs(info);
 			kfree(info);
 			retStatus = ISD200_ERROR;
-- 
1.5.3.3


