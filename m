From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 05/29] qla2xxx: Use consistent DL mask for ELS/CT passthru requests.
Date: Thu, 9 Feb 2012 11:15:37 -0800
Message-ID: <1328814961-21866-6-git-send-email-chad.dupuis@qlogic.com>
References: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:3906
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758429Ab2BITcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:32:17 -0500
Received: from mail169-ch1 (localhost [127.0.0.1])	by
 mail169-ch1-R.bigfish.com (Postfix) with ESMTP id 7C9663406CA	for
 <linux-scsi@vger.kernel.org>; Thu,  9 Feb 2012 19:32:11 +0000 (UTC)
In-Reply-To: <1328814961-21866-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The driver is logging a slew of 'good' status requests for ELS/CT passthrough
commands.  Change some log messages from:

     * ql_log() -> ql_dbg()
     * ql_log_info -> ql_dbg_user

Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_isr.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
index 33e4fd3..d16b8dc 100644
--- a/drivers/scsi/qla2xxx/qla_isr.c
+++ b/drivers/scsi/qla2xxx/qla_isr.c
@@ -1072,7 +1072,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 		type = "ct pass-through";
 		break;
 	default:
-		ql_log(ql_log_warn, vha, 0x503e,
+		ql_dbg(ql_dbg_user, vha, 0x503e,
 		    "Unrecognized SRB: (%p) type=%d.\n", sp, sp->type);
 		return;
 	}
@@ -1093,7 +1093,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			bsg_job->reply->reply_payload_rcv_len =
 			    le16_to_cpu(((struct els_sts_entry_24xx *)pkt)->total_byte_count);
 
-			ql_log(ql_log_info, vha, 0x503f,
+			ql_dbg(ql_dbg_user, vha, 0x503f,
 			    "ELS-CT pass-through-%s error hdl=%x comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x total_byte = 0x%x.\n",
 			    type, sp->handle, comp_status, fw_status[1], fw_status[2],
@@ -1103,7 +1103,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
 		else {
-			ql_log(ql_log_info, vha, 0x5040,
+			ql_dbg(ql_dbg_user, vha, 0x5040,
 			    "ELS-CT pass-through-%s error hdl=%x comp_status-status=0x%x "
 			    "error subcode 1=0x%x error subcode 2=0x%x.\n",
 			    type, sp->handle, comp_status,
@@ -1116,7 +1116,7 @@ qla24xx_els_ct_entry(scsi_qla_host_t *vha, struct req_que *req,
 			fw_sts_ptr = ((uint8_t*)bsg_job->req->sense) + sizeof(struct fc_bsg_reply);
 			memcpy( fw_sts_ptr, fw_status, sizeof(fw_status));
 		}
-		ql_dump_buffer(ql_dbg_async + ql_dbg_buffer, vha, 0x5056,
+		ql_dump_buffer(ql_dbg_user + ql_dbg_buffer, vha, 0x5056,
 				(uint8_t *)pkt, sizeof(*pkt));
 	}
 	else {
-- 
1.6.0.2


