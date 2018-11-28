From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Subject: [PATCH 15/41] scsi: hpsa: mark expected switch fall-throughs
Date: Tue, 27 Nov 2018 22:29:07 -0600
Message-ID: <991ec154d1a1da019442e4fd025a39fa2ad2bebb.1543374820.git.gustavo@embeddedor.com>
References: <cover.1543374820.git.gustavo@embeddedor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cover.1543374820.git.gustavo@embeddedor.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Don Brace <don.brace@microsemi.com>, esc.storagedev@microsemi.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <gustavo@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

In preparation to enabling -Wimplicit-fallthrough, mark switch cases
where we are expecting to fall through.

Addresses-Coverity-ID: 1195463 ("Missing break in switch")
Addresses-Coverity-ID: 1195464 ("Missing break in switch")
Addresses-Coverity-ID: 1195465 ("Missing break in switch")
Addresses-Coverity-ID: 1195466 ("Missing break in switch")
Addresses-Coverity-ID: 1357338 ("Missing break in switch")
Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
---
 drivers/scsi/hpsa.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index c9cccf35e9d7..bc64e8a0449d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4663,6 +4663,7 @@ static int fixup_ioaccel_cdb(u8 *cdb, int *cdb_len)
 	case WRITE_6:
 	case WRITE_12:
 		is_write = 1;
+		/* fall through */
 	case READ_6:
 	case READ_12:
 		if (*cdb_len == 6) {
@@ -5093,6 +5094,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	switch (cmd->cmnd[0]) {
 	case WRITE_6:
 		is_write = 1;
+		/* fall through */
 	case READ_6:
 		first_block = (((cmd->cmnd[1] & 0x1F) << 16) |
 				(cmd->cmnd[2] << 8) |
@@ -5103,6 +5105,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_10:
 		is_write = 1;
+		/* fall through */
 	case READ_10:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 24) |
@@ -5115,6 +5118,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_12:
 		is_write = 1;
+		/* fall through */
 	case READ_12:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 24) |
@@ -5129,6 +5133,7 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 		break;
 	case WRITE_16:
 		is_write = 1;
+		/* fall through */
 	case READ_16:
 		first_block =
 			(((u64) cmd->cmnd[2]) << 56) |
-- 
2.17.1
