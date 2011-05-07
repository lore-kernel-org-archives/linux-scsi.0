From: madhu.iyengar@qlogic.com
Subject: [PATCH 1/4] qla2xxx: Properly set the dsd_list_len for dsd_chaining in cmd type 6.
Date: Fri,  6 May 2011 17:30:08 -0700
Message-ID: <1304728223-30817-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:32825 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1753877Ab1EGAnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 6 May 2011 20:43:11 -0400
In-Reply-To: <1304728223-30817-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Andrew Vasquez <andrew.vasquez@qlogic.com>

The firmware spec has the fcp_data_dseg_len defined as a 32-bit
value, while the corresponding field in the driver structure has
it defined as a 16-bit value.

Cc: stable@kernel.org
Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_fw.h |    3 +--
 drivers/scsi/qla2xxx/qla_nx.c |    4 ++--
 2 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h
index 73888ae..691783a 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -416,8 +416,7 @@ struct cmd_type_6 {
 	uint8_t vp_index;
 
 	uint32_t fcp_data_dseg_address[2];	/* Data segment address. */
-	uint16_t fcp_data_dseg_len;		/* Data segment length. */
-	uint16_t reserved_1;			/* MUST be set to 0. */
+	uint32_t fcp_data_dseg_len;		/* Data segment length. */
 };
 
 #define COMMAND_TYPE_7	0x18		/* Command Type 7 entry */
diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index acd1ad3..8b217f3 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2563,11 +2563,11 @@ qla2xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 			dsd_seg = (uint32_t *)&cmd_pkt->fcp_data_dseg_address;
 			*dsd_seg++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*dsd_seg++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			cmd_pkt->fcp_data_dseg_len = dsd_list_len;
+			*dsd_seg++ = cpu_to_le32(dsd_list_len);
 		} else {
 			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			*cur_dsd++ = dsd_list_len;
+			*cur_dsd++ = cpu_to_le32(dsd_list_len);
 		}
 		cur_dsd = (uint32_t *)next_dsd;
 		while (avail_dsds) {
-- 
1.6.0.2

