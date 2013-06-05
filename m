From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 05/10] qla2xxx: Remove a dead assignment in qla24xx_build_scsi_crc_2_iocbs()
Date: Wed, 05 Jun 2013 15:06:15 +0200
Message-ID: <51AF37C7.3080808@acm.org>
References: <51AF36BF.3030602@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from juliette.telenet-ops.be ([195.130.137.74]:34589 "EHLO
	juliette.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753648Ab3FENGQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 09:06:16 -0400
In-Reply-To: <51AF36BF.3030602@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>

Since the value of cur_seg is not used and since scsi_prot_sglist()
has no side effects it is safe to remove the statement
"cur_seg = scsi_prot_sglist(cmd)". Detected by Coverity.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Saurav Kashyap <saurav.kashyap@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 15e4080..b589d24 100644
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
1.7.10.4

