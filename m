From: madhu.iyengar@qlogic.com
Subject: [PATCH 1/5] qla2xxx: Populate Command Type 6 LUN field properly.
Date: Tue, 23 Nov 2010 16:52:46 -0800
Message-ID: <1290559970-12123-2-git-send-email-madhu.iyengar@qlogic.com>
References: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:59502 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754484Ab0KXBCi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2010 20:02:38 -0500
In-Reply-To: <1290559970-12123-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Mike Hernandez <michael.hernandez@qlogic.com>

From: Mike Hernandez <michael.hernandez@qlogic.com>

Use the host_to_fcp_swap call to correctly populate the LUN field
in the Command Type 6 path.  This field is used during LUN reset
cleanup and must match the field used in the FCP command.

Cc: stable@kernel.org
Signed-off-by: Mike Hernandez <michael.hernandez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_iocb.c |    1 +
 drivers/scsi/qla2xxx/qla_nx.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
index 5f94430..4c1ba62 100644
--- a/drivers/scsi/qla2xxx/qla_iocb.c
+++ b/drivers/scsi/qla2xxx/qla_iocb.c
@@ -1061,6 +1061,7 @@ qla24xx_build_scsi_crc_2_iocbs(srb_t *sp, struct cmd_type_crc_2 *cmd_pkt,
 		fcp_cmnd->additional_cdb_len |= 2;
 
 	int_to_scsilun(sp->cmd->device->lun, &fcp_cmnd->lun);
+	host_to_fcp_swap((uint8_t *)&fcp_cmnd->lun, sizeof(fcp_cmnd->lun));
 	memcpy(fcp_cmnd->cdb, cmd->cmnd, cmd->cmd_len);
 	cmd_pkt->fcp_cmnd_dseg_len = cpu_to_le16(fcp_cmnd_len);
 	cmd_pkt->fcp_cmnd_dseg_address[0] = cpu_to_le32(
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 8d9edfb..ae2acac 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2749,6 +2749,7 @@ sufficient_dsds:
 			goto queuing_error_fcp_cmnd;
 
 		int_to_scsilun(sp->cmd->device->lun, &cmd_pkt->lun);
+		host_to_fcp_swap((uint8_t *)&cmd_pkt->lun, sizeof(cmd_pkt->lun));
 
 		/* build FCP_CMND IU */
 		memset(ctx->fcp_cmnd, 0, sizeof(struct fcp_cmnd));
-- 
1.6.0.2

