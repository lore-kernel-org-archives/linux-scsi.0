From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] target: Fix SYNCHRONIZE_CACHE zero LBA + range breakage
Date: Thu, 11 Aug 2011 01:52:48 +0000
Message-ID: <1313027569-27640-3-git-send-email-nab@linux-iscsi.org>
References: <1313027569-27640-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:41710 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1HKCRj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Aug 2011 22:17:39 -0400
In-Reply-To: <1313027569-27640-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch fixes a SYNCHRONIZE_CACHE CDB handling bug with IBLOCK/FILEIO
backends where transport_cmd_get_valid_sectors() was incorrectly rejecting
a zero LBA + range CDB from being processed, and returning CHECK_CONDITION.

This includes changing transport_cmd_get_valid_sectors() to return '0' on
success and '-EINVAL' on failure (this makes more sense than sectors),
and to only check transport_cmd_get_valid_sectors() when a non zero LBA +
range SYNCHRONIZE_CACHE operation has been receieved for the non passthrough
case.

Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   14 +++++++-------
 1 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index ddd6df4..0abbf08 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -2855,12 +2855,10 @@ static int transport_cmd_get_valid_sectors(struct se_cmd *cmd)
 			" transport_dev_end_lba(): %llu\n",
 			cmd->t_task_lba, sectors,
 			transport_dev_end_lba(dev));
-		pr_err("  We should return CHECK_CONDITION"
-		       " but we don't yet\n");
-		return 0;
+		return -EINVAL;
 	}
 
-	return sectors;
+	return 0;
 }
 
 static int target_check_write_same_discard(unsigned char *flags, struct se_device *dev)
@@ -3352,10 +3350,12 @@ static int transport_generic_cmd_sequencer(
 		cmd->se_cmd_flags |= SCF_EMULATE_CDB_ASYNC;
 		/*
 		 * Check to ensure that LBA + Range does not exceed past end of
-		 * device.
+		 * device for IBLOCK and FILEIO ->do_sync_cache() backend calls
 		 */
-		if (!transport_cmd_get_valid_sectors(cmd))
-			goto out_invalid_cdb_field;
+		if ((cmd->t_task_lba != 0) || (sectors != 0)) {
+			if (transport_cmd_get_valid_sectors(cmd) < 0)
+				goto out_invalid_cdb_field;
+		}
 		break;
 	case UNMAP:
 		size = get_unaligned_be16(&cdb[7]);
-- 
1.7.2.5

