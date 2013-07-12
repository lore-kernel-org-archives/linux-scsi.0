From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 2/2] qla2xxx: Properly set the tagging for commands.
Date: Fri, 12 Jul 2013 14:47:51 -0400
Message-ID: <1373654871-29081-3-git-send-email-saurav.kashyap@qlogic.com>
References: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe002.messaging.microsoft.com ([207.46.163.25]:8240 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753009Ab3GLTOu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Jul 2013 15:14:50 -0400
Received: from mail185-co9 (localhost [127.0.0.1])	by
 mail185-co9-R.bigfish.com (Postfix) with ESMTP id 56805B60603	for
 <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2013 19:14:48 +0000 (UTC)
Received: from CO9EHSMHS023.bigfish.com (unknown [10.236.132.254])	by
 mail185-co9.bigfish.com (Postfix) with ESMTP id 50782480055	for
 <linux-scsi@vger.kernel.org>; Fri, 12 Jul 2013 19:14:46 +0000 (UTC)
In-Reply-To: <1373654871-29081-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

Reported-by: Jack Hill <jackhill@jackhill.us>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Giridhar Malavali <giridhar.malavali@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |   11 +++++++++--
 1 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 42ef481..ef0a548 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -419,6 +419,8 @@ qla2x00_start_scsi(srb_t *sp)
 			    __constant_cpu_to_le16(CF_SIMPLE_TAG);
 			break;
 		}
+	} else {
+		cmd_pkt->control_flags = __constant_cpu_to_le16(CF_SIMPLE_TAG);
 	}
 
 	/* Load SCSI command packet. */
@@ -1307,11 +1309,11 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		    fcp_cmnd->task_attribute = TSK_ORDERED;
 		    break;
 		default:
-		    fcp_cmnd->task_attribute = 0;
+		    fcp_cmnd->task_attribute = TSK_SIMPLE;
 		    break;
 		}
 	} else {
-		fcp_cmnd->task_attribute = 0;
+		fcp_cmnd->task_attribute = TSK_SIMPLE;
 	}
 
 	cmd_pkt->fcp_rsp_dseg_len = 0; /* Let response come in status iocb */
@@ -1525,7 +1527,12 @@ qla24xx_start_scsi(srb_t *sp)
 		case ORDERED_QUEUE_TAG:
 			cmd_pkt->task = TSK_ORDERED;
 			break;
+		default:
+		    cmd_pkt->task = TSK_SIMPLE;
+		    break;
 		}
+	} else {
+		cmd_pkt->task = TSK_SIMPLE;
 	}
 
 	/* Load SCSI command packet. */
-- 
1.7.7


