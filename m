From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 023/103] target: Function pointers don't need to use '&' to be assigned
Date: Thu, 21 Jul 2011 00:04:59 -0700
Message-ID: <1311231979-6631-24-git-send-email-nab@linux-iscsi.org>
References: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm4.bullet.mail.bf1.yahoo.com ([98.139.212.163]:40150 "HELO
	nm4.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752326Ab1GUHH0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Jul 2011 03:07:26 -0400
In-Reply-To: <1311231979-6631-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Andy Grover <agrover@redhat.com>

From: Andy Grover <agrover@redhat.com>

Signed-off-by: Andy Grover <agrover@redhat.com>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_transport.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
index 72e4726..acb5ef7 100644
--- a/drivers/target/target_core_transport.c
+++ b/drivers/target/target_core_transport.c
@@ -3226,7 +3226,7 @@ static int transport_generic_cmd_sequencer(
 				cmd->transport_emulate_cdb =
 				(T10_ALUA(su_dev)->alua_type ==
 				 SPC3_ALUA_EMULATED) ?
-				&core_emulate_report_target_port_groups :
+				core_emulate_report_target_port_groups :
 				NULL;
 			}
 			size = (cdb[6] << 24) | (cdb[7] << 16) |
@@ -3273,7 +3273,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_emulate_cdb =
 			(T10_RES(su_dev)->res_type ==
 			 SPC3_PERSISTENT_RESERVATIONS) ?
-			&core_scsi3_emulate_pr : NULL;
+			core_scsi3_emulate_pr : NULL;
 		size = (cdb[7] << 8) + cdb[8];
 		cmd->se_cmd_flags |= SCF_SCSI_CONTROL_NONSG_IO_CDB;
 		break;
@@ -3296,7 +3296,7 @@ static int transport_generic_cmd_sequencer(
 				cmd->transport_emulate_cdb =
 				(T10_ALUA(su_dev)->alua_type ==
 					SPC3_ALUA_EMULATED) ?
-				&core_emulate_set_target_port_groups :
+				core_emulate_set_target_port_groups :
 				NULL;
 			}
 
@@ -3393,7 +3393,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_emulate_cdb =
 				(T10_RES(su_dev)->res_type !=
 				 SPC_PASSTHROUGH) ?
-				&core_scsi2_emulate_crh : NULL;
+				core_scsi2_emulate_crh : NULL;
 		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
 		break;
 	case RELEASE:
@@ -3410,7 +3410,7 @@ static int transport_generic_cmd_sequencer(
 		cmd->transport_emulate_cdb =
 				(T10_RES(su_dev)->res_type !=
 				 SPC_PASSTHROUGH) ?
-				&core_scsi2_emulate_crh : NULL;
+				core_scsi2_emulate_crh : NULL;
 		cmd->se_cmd_flags |= SCF_SCSI_NON_DATA_CDB;
 		break;
 	case SYNCHRONIZE_CACHE:
@@ -3516,7 +3516,7 @@ static int transport_generic_cmd_sequencer(
 		break;
 	case REPORT_LUNS:
 		cmd->transport_emulate_cdb =
-				&transport_core_report_lun_response;
+				transport_core_report_lun_response;
 		size = (cdb[6] << 24) | (cdb[7] << 16) | (cdb[8] << 8) | cdb[9];
 		/*
 		 * Do implict HEAD_OF_QUEUE processing for REPORT_LUNS
-- 
1.7.6

