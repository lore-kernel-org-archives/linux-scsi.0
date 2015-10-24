From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 04/21] hpsa: correct transfer length for 6 byte read/write
 commands
Date: Sat, 24 Oct 2015 14:52:50 -0500
Message-ID: <20151024195250.17127.75934.stgit@brunhilda>
References: <20151024193306.17127.7819.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:55196 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752336AbbJXT4c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 24 Oct 2015 15:56:32 -0400
In-Reply-To: <20151024193306.17127.7819.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

handle block counts of 0. Cleanup block and block count calculations.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index e1ee06d..3520d75 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4005,19 +4005,14 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 	case READ_6:
 	case READ_12:
 		if (*cdb_len == 6) {
-			block = (((u32) cdb[2]) << 8) | cdb[3];
+			block = get_unaligned_be16(&cdb[2]);
 			block_cnt = cdb[4];
+			if (block_cnt == 0)
+				block_cnt = 256;
 		} else {
 			BUG_ON(*cdb_len != 12);
-			block = (((u32) cdb[2]) << 24) |
-				(((u32) cdb[3]) << 16) |
-				(((u32) cdb[4]) << 8) |
-				cdb[5];
-			block_cnt =
-				(((u32) cdb[6]) << 24) |
-				(((u32) cdb[7]) << 16) |
-				(((u32) cdb[8]) << 8) |
-				cdb[9];
+			block = get_unaligned_be32(&cdb[2]);
+			block_cnt = get_unaligned_be32(&cdb[6]);
 		}
 		if (block_cnt > 0xffff)
 			return IO_ACCEL_INELIGIBLE;
@@ -4403,9 +4398,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	case WRITE_6:
 		is_write = 1;
 	case READ_6:
-		first_block =
-			(((u64) cmd->cmnd[2]) << 8) |
-			cmd->cmnd[3];
+		first_block = get_unaligned_be16(&cmd->cmnd[2]);
 		block_cnt = cmd->cmnd[4];
 		if (block_cnt == 0)
 			block_cnt = 256;

