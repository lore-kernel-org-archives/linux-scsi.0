From: Saurav Kashyap <saurav.kashyap@qlogic.com>
Subject: [PATCH 11/16] qla2xxx: Remove a dead assignment in qla24xx_build_scsi_crc_2_iocbs().
Date: Tue, 25 Jun 2013 11:27:26 -0400
Message-ID: <1372174051-4211-12-git-send-email-saurav.kashyap@qlogic.com>
References: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:51876
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752183Ab3FYPxx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jun 2013 11:53:53 -0400
Received: from mail169-co9 (localhost [127.0.0.1])	by
 mail169-co9-R.bigfish.com (Postfix) with ESMTP id 53C3A4000A1	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:52 +0000 (UTC)
Received: from CO9EHSMHS026.bigfish.com (unknown [10.236.132.234])	by
 mail169-co9.bigfish.com (Postfix) with ESMTP id ECA0890004E	for
 <linux-scsi@vger.kernel.org>; Tue, 25 Jun 2013 15:53:50 +0000 (UTC)
In-Reply-To: <1372174051-4211-1-git-send-email-saurav.kashyap@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, saurav.kashyap@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Bart Van Assche <bvanassche@acm.org>

Since the value of cur_seg is not used and since scsi_prot_sglist()
has no side effects it is safe to remove the statement
"cur_seg = scsi_port_sglist(cmd)". Detected by Coverity.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 9de372f..42ef481 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1189,7 +1189,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 	uint32_t		*cur_dsd, *fcp_dl;
 	scsi_qla_host_t		*vha;
 	struct scsi_cmnd	*cmd;
-	struct scatterlist	*cur_seg;
 	int			sgc;
 	uint32_t		total_bytes = 0;
 	uint32_t		data_bytes;
@@ -1396,7 +1395,6 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 
 	if (bundling && tot_prot_dsds) {
 		/* Walks dif segments */
-		cur_seg = scsi_prot_sglist(cmd);
 		cmd_pkt->control_flags |=
 			__constant_cpu_to_le16(CF_DIF_SEG_DESCR_ENABLE);
 		cur_dsd = (uint32_t *) &crc_ctx_pkt->u.bundling.dif_address;
-- 
1.7.7


