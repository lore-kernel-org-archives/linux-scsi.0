From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 094/103] target: Set WSNZ=1 in block limits VPD. Abort if WRITE_SAME sectors = 0
Date: Thu, 21 Jul 2011 07:05:26 +0000
Message-ID: <1311231935-24635-95-git-send-email-nab@linux-iscsi.org>
References: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:51677 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1GUH3Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jul 2011 03:29:25 -0400
In-Reply-To: <1311231935-24635-90-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

According to sbc3r27, WRITE SAME with sectors=0 either writes to the
end of the lun, or returns an error, depending on if WSNZ was set to 0 or
1 in the block limits VPD (0xB0). This patch sets that bit, and
returns the error. Previously we used the block size, I don't know why,
but it seems wrong.

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_cdb.c       |    3 +++
 drivers/target/target_core_transport.c |   17 +++++++++++------
 2 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_cdb.c b/drivers/target/target_core_cdb.c
index 1867db7..d03eebc 100644
--- a/drivers/target/target_core_cdb.c
+++ b/drivers/target/target_core_cdb.c
@@ -491,6 +491,9 @@ target_emulate_evpd_b0(struct se_cmd *cmd, unsigned char *buf)
 	buf[0] = dev->transport->get_device_type(dev);
 	buf[3] = have_tp ? 0x3c : 0x10;
 
+	/* Set WSNZ to 1 */
+	buf[4] = 0x01;
+
 	/*
 	 * Set OPTIMAL TRANSFER LENGTH GRANULARITY
 	 */
diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 6a93a58..ef64052 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3066,10 +3066,13 @@ static int transport_generic_cmd_sequencer(
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
@@ -3343,10 +3346,12 @@ static int transport_generic_cmd_sequencer(
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
1.7.6

