From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 09/27] hpsa: correct transfer length for 6 byte
 read/write commands
Date: Wed, 04 Nov 2015 15:50:50 -0600
Message-ID: <20151104215050.15472.95520.stgit@brunhilda>
References: <20151104214910.15472.23179.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta02.pmc-sierra.com ([216.241.235.117]:60772 "EHLO
	bby1mta02.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030228AbbKDVym (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Nov 2015 16:54:42 -0500
In-Reply-To: <20151104214910.15472.23179.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, scott.benesh@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

handle block counts of 0. Cleanup block and block count calculations.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Justin Lindley <justin.lindley@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   19 ++++++-------------
 1 file changed, 6 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index ce0341a..ae9968b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4012,19 +4012,14 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
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
@@ -4410,9 +4405,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
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

