From: Chad Dupuis <chad.dupuis@qlogic.com>
Subject: [PATCH 06/12] qla2xxx: Fix array out of bound warning.
Date: Tue, 16 Aug 2011 11:31:49 -0700
Message-ID: <1313519515-23122-7-git-send-email-chad.dupuis@qlogic.com>
References: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tx2ehsobe003.messaging.microsoft.com ([65.55.88.13]:49384 "EHLO
	TX2EHSOBE006.bigfish.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HPSpI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Aug 2011 14:45:08 -0400
In-Reply-To: <1313519515-23122-1-git-send-email-chad.dupuis@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com
Cc: giridhar.malavali@qlogic.com, chad.dupuis@qlogic.com, andrew.vasquez@qlogic.com, linux-scsi@vger.kernel.org

From: Saurav Kashyap <saurav.kashyap@qlogic.com>

Signed-off-by: Saurav Kashyap <saurav.kashyap@qlogic.com>
Signed-off-by: Chad Dupuis <chad.dupuis@qlogic.com>
---
 drivers/scsi/qla2xxx/qla_nx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
index 385b6b7..8620cb4 100644
--- a/drivers/scsi/qla2xxx/qla_nx.c
+++ b/drivers/scsi/qla2xxx/qla_nx.c
@@ -2608,7 +2608,7 @@ qla2xx_build_scsi_type_6_iocbs(srb_t *sp, struct cmd_type_6 *cmd_pkt,
 			dsd_seg = (uint32_t *)&cmd_pkt->fcp_data_dseg_address;
 			*dsd_seg++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*dsd_seg++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-			*dsd_seg++ = cpu_to_le32(dsd_list_len);
+			cmd_pkt->fcp_data_dseg_len = cpu_to_le32(dsd_list_len);
 		} else {
 			*cur_dsd++ = cpu_to_le32(LSD(dsd_ptr->dsd_list_dma));
 			*cur_dsd++ = cpu_to_le32(MSD(dsd_ptr->dsd_list_dma));
-- 
1.6.0.2


