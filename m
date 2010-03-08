From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 2/3] [TCM]: Make legacy RESERVE_* and RELEASE_* use se_cmd_t->transport_emulate_cdb()
Date: Mon,  8 Mar 2010 11:51:07 -0800
Message-ID: <1268077867-19757-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp125.sbc.mail.sp1.yahoo.com ([69.147.65.184]:21228 "HELO
	smtp125.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755086Ab0CHTvJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Mar 2010 14:51:09 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, Douglas Gilbert <dgilbert@interlog.com>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch changes RESERVE_* and RELEASE_* handling in transport_generic_cmd_sequencer()
to setup se_cmd_t->transport_emulate_cdb() for processing the legacy SPC-2 reservations
and >= SPC-3 compatible reservation handling (CRH=1) logic in target_core_pr.c:core_scsi2_emulate_crh().

This patch also removes the now unused ->t10_reserve() and ->t10_release() function pointers from
target_core_base.h:t10_reservation_template_t.

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   25 +++++++++++++++----------
 include/target/target_core_base.h      |    2 --
 2 files changed, 15 insertions(+), 12 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 880055c..1217a7d 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -5563,14 +5563,17 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_allocate_resources =
 				&transport_generic_allocate_none;
 		transport_get_maps(cmd);
-
-		ret = T10_RES(su_dev)->t10_reserve(cmd);
-		if (ret != 0) {
-			if (ret > 0)
-				return 5; /* RESERVATION_CONFILIT */
-			else
-				return 7; /* ILLEGAL_REQUEST */
-		}
+		/*
+		 * Setup the legacy emulated handler for SPC-2 and
+		 * >= SPC-3 compatible reservation handling (CRH=1)
+		 * Otherwise, we assume the underlying SCSI logic is
+		 * is running in SPC_PASSTHROUGH, and wants reservations
+		 * emulation disabled.
+		 */
+		cmd->transport_emulate_cdb =
+				(T10_RES(su_dev)->res_type !=
+				 SPC_PASSTHROUGH) ?
+				&core_scsi2_emulate_crh : NULL;
 		ret = 3;
 		break;
 	case RELEASE:
@@ -5588,8 +5591,10 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_allocate_resources =
 				&transport_generic_allocate_none;
 		transport_get_maps(cmd);
-
-		T10_RES(su_dev)->t10_release(cmd);
+		cmd->transport_emulate_cdb =
+				(T10_RES(su_dev)->res_type !=
+				 SPC_PASSTHROUGH) ?
+				&core_scsi2_emulate_crh : NULL;
 		ret = 3;
 		break;
 	case ALLOW_MEDIUM_REMOVAL:
diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
index 74772cd..17bc2fe 100644
--- a/include/target/target_core_base.h
+++ b/include/target/target_core_base.h
@@ -379,8 +379,6 @@ typedef struct t10_reservation_template_s {
 	struct list_head registration_list;
 	struct list_head aptpl_reg_list;
 	int (*t10_reservation_check)(struct se_cmd_s *, u32 *);
-	int (*t10_reserve)(struct se_cmd_s *);
-	int (*t10_release)(struct se_cmd_s *);
 	int (*t10_seq_non_holder)(struct se_cmd_s *, unsigned char *, u32);
 	int (*t10_pr_register)(struct se_cmd_s *);
 	int (*t10_pr_clear)(struct se_cmd_s *);
-- 
1.5.6.5

