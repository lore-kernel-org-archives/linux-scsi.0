From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 1/2] qla2xxx: fix sparse warning "large integer implicitly truncated to unsigned type"
Date: Tue, 23 Apr 2013 14:10:11 -0400
Message-ID: <1366740612-3561-2-git-send-email-saurav.kashyap@qlogic.com>
References: <1366740612-3561-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from am1ehsobe001.messaging.microsoft.com ([213.199.154.204]:33576
	"EHLO am1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758527Ab3DXWOT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 18:14:19 -0400
Received: from mail8-am1 (localhost [127.0.0.1])	by mail8-am1-R.bigfish.com
 (Postfix) with ESMTP id BFDD31C00AF	for <linux-scsi@vger.kernel.org>; Wed, 24
 Apr 2013 22:14:17 +0000 (UTC)
In-Reply-To: <1366740612-3561-1-git-send-email-saurav.kashyap@qlogic.com>
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


