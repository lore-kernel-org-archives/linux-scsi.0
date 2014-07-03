From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 4/5] hpsa: fix 6-byte READ/WRITE with 0 length data xfer
Date: Thu, 03 Jul 2014 10:18:14 -0500
Message-ID: <20140703151814.22132.2083.stgit@beardog.cce.hp.com>
References: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3425.houston.hp.com ([15.201.208.53]:2417 "EHLO
	g4t3425.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758265AbaGCPTG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 11:19:06 -0400
In-Reply-To: <20140703151534.22132.49663.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@parallels.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, stephenmcameron@gmail.com, joseph.t.handzik@hp.com, thenzl@redhat.com, michael.miller@canonical.com, elliott@hp.com, scott.teel@hp.com, hch@lst.de

From: Stephen M. Cameron <scameron@beardog.cce.hp.com>

a 6-byte READ/WRITE CDB with a 0 block data transfer really
means a 256 block data transfer.  The RAID mapping code failed
to handle this case.  For 10/12/16 byte READ/WRITEs, 0 just means
no data should be transferred, and should not trigger BUG_ON.

Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
Reported-by: Robert Elliott <elliott@hp.com>
Reviewed-by: Robert Elliott <elliott@hp.com>
---
 drivers/scsi/hpsa.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 794d726..a97a7ff 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3686,6 +3686,8 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 			(((u64) cmd->cmnd[2]) << 8) |
 			cmd->cmnd[3];
 		block_cnt = cmd->cmnd[4];
+		if (block_cnt == 0)
+			block_cnt = 256;
 		break;
 	case WRITE_10:
 		is_write = 1;
@@ -3734,7 +3736,6 @@ static int hpsa_scsi_ioaccel_raid_map(struct ctlr_info *h,
 	default:
 		return IO_ACCEL_INELIGIBLE; /* process via normal I/O path */
 	}
-	BUG_ON(block_cnt == 0);
 	last_block = first_block + block_cnt - 1;
 
 	/* check for write to non-RAID-0 */

