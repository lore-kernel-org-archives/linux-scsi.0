From: madhu.iyengar@qlogic.com
Subject: [PATCH 02/13] qla2xxx: Fix array subscript is above array bounds in qla2xx_build_scsi_type_6_iocbs().
Date: Wed, 23 Feb 2011 15:27:07 -0800
Message-ID: <1298503638-22396-3-git-send-email-madhu.iyengar@qlogic.com>
References: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vpn.pathscale.com ([198.186.3.75]:52601 "HELO mx.mv.qlogic.com"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with SMTP
	id S1754972Ab1BWXa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Feb 2011 18:30:29 -0500
In-Reply-To: <1298503638-22396-1-git-send-email-madhu.iyengar@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@suse.de
Cc: giridhar.malavali@qlogic.com, madhu.iyengar@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org, Chad Dupuis <chad.dupuis@qlogic.com>

From: Chad Dupuis <chad.dupuis@qlogic.com>

The additional increment of dsd_seg was causing the compiler to throw an array
out of bounds warning. This patch moves to a direct assignment of
cmd_pkt->fcp_data_dseg_len so that the compiler doesn't generate an array out
bounds warning.

Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
Signed-off-by: Madhuranath Iyengar <Madhu.Iyengar@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index fdb96a3..b37445d 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2547,7 +2547,7 @@ qla2xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 			dsd_seg = (uint32_t *)&cmd_pkt->fcp_data_dseg_address;
 			*dsd_seg++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*dsd_seg++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			*dsd_seg++ = dsd_list_len;
+			cmd_pkt->fcp_data_dseg_len = dsd_list_len;
 		} else {
 			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-- 
1.6.0.2

