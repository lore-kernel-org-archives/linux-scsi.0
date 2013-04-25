From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: fix sparse warning "large integer implicitly truncated to unsigned type"
Date: Thu, 25 Apr 2013 01:29:18 -0400
Message-ID: <1366867759-3562-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1366867759-3562-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [216.32.181.184] ([216.32.181.184]:34486 "EHLO
	ch1outboundpool.messaging.microsoft.com" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1750866Ab3DYFy3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Apr 2013 01:54:29 -0400
Received: from mail212-ch1 (localhost [127.0.0.1])	by
 mail212-ch1-R.bigfish.com (Postfix) with ESMTP id 679F2300246	for
 <linux-scsi@vger.kernel.org>; Thu, 25 Apr 2013 05:53:17 +0000 (UTC)
In-Reply-To: <1366867759-3562-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Armen Baloyan <armen.baloyan@qlogic.com>

Signed-off-by: Armen Baloyan <armen.baloyan@qlogic.com>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_mr.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_mr.c b/drivers/scsi/qla2xxx/qla_mr.c
index 729b743..937fed8 100644
--- a/drivers/scsi/qla2xxx/qla_mr.c
+++ b/drivers/scsi/qla2xxx/qla_mr.c
@@ -3003,12 +3003,10 @@ qlafx00_build_scsi_iocbs(srb_t *sp, struct cmd_type_7_fx00 *cmd_pkt,
 
 	/* Set transfer direction */
 	if (cmd->sc_data_direction == DMA_TO_DEVICE) {
-		lcmd_pkt->cntrl_flags =
-		    __constant_cpu_to_le16(TMF_WRITE_DATA);
+		lcmd_pkt->cntrl_flags = TMF_WRITE_DATA;
 		vha->qla_stats.output_bytes += scsi_bufflen(cmd);
 	} else if (cmd->sc_data_direction == DMA_FROM_DEVICE) {
-		lcmd_pkt->cntrl_flags =
-		    __constant_cpu_to_le16(TMF_READ_DATA);
+		lcmd_pkt->cntrl_flags = TMF_READ_DATA;
 		vha->qla_stats.input_bytes += scsi_bufflen(cmd);
 	}
 
-- 
1.7.7


