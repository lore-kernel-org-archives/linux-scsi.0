From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH] hpsa: correct scsi 6byte lba calculation
Date: Fri, 16 Sep 2016 14:54:23 -0500
Message-ID: <147405566295.22004.7072671003857458219.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0075.outbound.protection.outlook.com ([104.47.40.75]:13376
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S933663AbcIPTz1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Sep 2016 15:55:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

From: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>

Missing 5 bits of byte 1 in the LBA issued by SML

Reported-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Mahesh Rajashekhara <mahesh.rajashekhara@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 71c08684..2bfebd9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4602,7 +4602,9 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 	case READ_6:
 	case READ_12:
 		if (*cdb_len == 6) {
-			block = get_unaligned_be16(&cdb[2]);
+			block = (((cdb[1] & 0x1F) << 16) |
+				(cdb[2] << 8) |
+				cdb[3]);
 			block_cnt = cdb[4];
 			if (block_cnt == 0)
 				block_cnt = 256;
@@ -4762,9 +4764,11 @@ static void set_encrypt_ioaccel2(struct ctlr_info *h,
 	 */
 	switch (cmd->cmnd[0]) {
 	/* Required? 6-byte cdbs eliminated by fixup_ioaccel_cdb */
-	case WRITE_6:
 	case READ_6:
-		first_block = get_unaligned_be16(&cmd->cmnd[2]);
+	case WRITE_6:
+		first_block = (((cmd->cmnd[1] & 0x1F) << 16) |
+				(cmd->cmnd[2] << 8) |
+				cmd->cmnd[3]);
 		break;
 	case WRITE_10:
 	case READ_10:
@@ -5014,7 +5018,9 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	case WRITE_6:
 		is_write = 1;
 	case READ_6:
-		first_block = get_unaligned_be16(&cmd->cmnd[2]);
+		first_block = (((cmd->cmnd[1] & 0x1F) << 16) |
+				(cmd->cmnd[2] << 8) |
+				cmd->cmnd[3]);
 		block_cnt = cmd->cmnd[4];
 		if (block_cnt == 0)
 			block_cnt = 256;

