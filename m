From: Andy Grover <agrover@redhat.com>
Subject: [PATCH 12/20] target: Set WSNZ=1 in block limits VPD. Abort if WRITE_SAME sectors = 0
Date: Fri,  8 Jul 2011 18:18:41 -0700
Message-ID: <1310174329-22228-13-git-send-email-agrover@redhat.com>
References: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28887 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752611Ab1GIBTB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jul 2011 21:19:01 -0400
In-Reply-To: <1310078011-15504-1-git-send-email-agrover@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org

According to sbc3r27, WRITE SAME with sectors=0 either writes to the
end of the lun, or returns an error, depending on if WSNZ was set to 0 or
1 in the block limits VPD (0xB0). This patch sets that bit, and
returns the error. Previously we used the block size, I don't know why,
but it seems wrong.

Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/target_core_cdb.c       |    3 +++
 drivers/target/target_core_transport.c |   17 +++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 22684b6..6db1383 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -520,6 +520,9 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	buf[1] = 0xb0;
 	buf[3] = have_tp ? 0x3c : 0x10;
 
+	/* Set WSNZ to 1 */
+	buf[4] = 0x01;
+
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 92d3252..29c35ec 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3072,10 +3072,13 @@ static int transport_generic_cmd_sequencer(
 			if (sector_ret)
 				goto out_unsupported_cdb;
 			
-			if (sectors != 0)
+			if (sectors)
 				size = transport_get_size(sectors, cdb, cmd);
-			else
-				size = dev->se_sub_dev->se_dev_attrib.block_size;
+			else {
+				pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not"
+				       " supported\n");
+				goto out_invalid_cdb_field;
+			}
 
 			cmd->t_task_lba = get_unaligned_be64(&cdb[12]);
 			cmd->se_cmd_flags |= SCF_SCSI_CONTROL_SG_IO_CDB;
@@ -3349,10 +3352,12 @@ static int transport_generic_cmd_sequencer(
 		if (sector_ret)
 			goto out_unsupported_cdb;
 
-		if (sectors != 0)
+		if (sectors)
 			size = transport_get_size(sectors, cdb, cmd);
-		else
-			size = dev->se_sub_dev->se_dev_attrib.block_size;
+		else {
+			pr_err("WSNZ=1, WRITE_SAME w/sectors=0 not supported\n");
+			goto out_invalid_cdb_field;
+		}
 
 		cmd->t_task_lba = get_unaligned_be16(&cdb[2]);
 		passthrough = (dev->transport->transport_type ==
-- 
1.7.1

