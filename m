From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 05/24] target: Remove unneeded test of se_cmd
Date: Sat, 29 Jan 2011 10:36:05 -0800
Message-ID: <1296326184-16664-6-git-send-email-nab@linux-iscsi.org>
References: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm22-vm0.bullet.mail.ac4.yahoo.com ([98.139.53.218]:48705 "HELO
	nm22-vm0.bullet.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754278Ab1A2SgY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 Jan 2011 13:36:24 -0500
In-Reply-To: <1296326184-16664-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Roland Dreier <rolandd@cisco.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>

From: Roland Dreier <rolandd@cisco.com>

se_cmd is dereferenced unconditionally in many other parts of
transport_get_lun_for_cmd() so remove the last test whether se_cmd is NULL.

Signed-off-by: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
(cherry picked from commit 04763c76c8ea7ecea5c59ff80f076d6285a5b756)
(cherry picked from commit 722a630caa116fd5e51c31baba8dae662c0d1221)
---
 drivers/target/target_core_device.c |   22 +++++++++-------------
 1 files changed, 9 insertions(+), 13 deletions(-)

diff --git a/drivers/target/target_core_device.c b/drivers/target/target_core_device.c
index 317ce58..d94933d 100644
--- a/drivers/target/target_core_device.c
+++ b/drivers/target/target_core_device.c
@@ -69,21 +69,17 @@ int transport_get_lun_for_cmd(
 	deve = se_cmd->se_deve =
 			&SE_NODE_ACL(se_sess)->device_list[unpacked_lun];
 	if (deve->lun_flags & TRANSPORT_LUNFLAGS_INITIATOR_ACCESS) {
-		if (se_cmd) {
-			deve->total_cmds++;
-			deve->total_bytes += se_cmd->data_length;
-
-			if (se_cmd->data_direction == DMA_TO_DEVICE) {
-				if (deve->lun_flags &
-						TRANSPORT_LUNFLAGS_READ_ONLY) {
-					read_only = 1;
-					goto out;
-				}
-				deve->write_bytes += se_cmd->data_length;
-			} else if (se_cmd->data_direction ==
-				   DMA_FROM_DEVICE) {
-				deve->read_bytes += se_cmd->data_length;
+		deve->total_cmds++;
+		deve->total_bytes += se_cmd->data_length;
+
+		if (se_cmd->data_direction == DMA_TO_DEVICE) {
+			if (deve->lun_flags & TRANSPORT_LUNFLAGS_READ_ONLY) {
+				read_only = 1;
+				goto out;
 			}
+			deve->write_bytes += se_cmd->data_length;
+		} else if (se_cmd->data_direction == DMA_FROM_DEVICE) {
+			deve->read_bytes += se_cmd->data_length;
 		}
 		deve->deve_cmds++;
 
-- 
1.7.3.5

