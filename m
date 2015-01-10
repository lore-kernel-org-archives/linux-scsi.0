From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 02/10] megaraid_sas: add missing __iomem annotations
Date: Sat, 10 Jan 2015 18:11:15 +0100
Message-ID: <1420909883-19479-3-git-send-email-hch@lst.de>
References: <1420909883-19479-1-git-send-email-hch@lst.de>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:34173 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434AbbAJRMS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Jan 2015 12:12:18 -0500
In-Reply-To: <1420909883-19479-1-git-send-email-hch@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sumit.Saxena@avagotech.com, kashyap.desai@avagotech.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas.h      | 2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c | 9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 14e5c7c..ecc4321 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1681,7 +1681,7 @@ struct megasas_instance {
 	spinlock_t crashdump_lock;
 
 	struct megasas_register_set __iomem *reg_set;
-	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
+	u32 __iomem *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 2eb5233..875db92 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -814,8 +814,8 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 {
 	u32			retry = 0 ;
 	u32			HostDiag;
-	u32			*seq_offset = &reg_set->seq_offset;
-	u32			*hostdiag_offset = &reg_set->host_diag;
+	u32 __iomem		*seq_offset = &reg_set->seq_offset;
+	u32 __iomem		*hostdiag_offset = &reg_set->host_diag;
 
 	if (instance->instancet == &megasas_instance_template_skinny) {
 		seq_offset = &reg_set->fusion_seq_offset;
@@ -4499,7 +4499,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	 * It is used for all MPT based Adapters.
 	 */
 	instance->reply_post_host_index_addr[0] =
-		(u32 *)((u8 *)instance->reg_set +
+		(u32 __iomem *)((u8 __iomem *)instance->reg_set +
 		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 
 	/* Check if MSI-X is supported while in ready state */
@@ -4531,7 +4531,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			 */
 			for (loop = 1; loop < MR_MAX_MSIX_REG_ARRAY; loop++) {
 				instance->reply_post_host_index_addr[loop] =
-					(u32 *)((u8 *)instance->reg_set +
+					(u32 __iomem *)
+					((u8 __iomem*)instance->reg_set +
 					MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
 					+ (loop * 0x10));
 			}
-- 
1.9.1

