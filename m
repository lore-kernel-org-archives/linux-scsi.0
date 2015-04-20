From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH RESEND 11/18] megaraid_sas : add missing __iomem
 annotations
Date: Mon, 20 Apr 2015 18:04:10 +0530
Message-ID: <201504201236.t3KCaM54016622@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1blp0183.outbound.protection.outlook.com ([207.46.163.183]:62432
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752946AbbDTPdE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2015 11:33:04 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index 225d806..c0cd256 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1694,7 +1694,7 @@ struct megasas_instance {
 	spinlock_t crashdump_lock;
 
 	struct megasas_register_set __iomem *reg_set;
-	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
+	u32 __iomem *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index 0381833..3aa5b5b 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -808,8 +808,8 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 {
 	u32			retry = 0 ;
 	u32			HostDiag;
-	u32			*seq_offset = &reg_set->seq_offset;
-	u32			*hostdiag_offset = &reg_set->host_diag;
+	u32 __iomem		*seq_offset = &reg_set->seq_offset;
+	u32 __iomem		*hostdiag_offset = &reg_set->host_diag;
 
 	if (instance->instancet == &megasas_instance_template_skinny) {
 		seq_offset = &reg_set->fusion_seq_offset;
@@ -4550,7 +4550,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	 * It is used for all MPT based Adapters.
 	 */
 	instance->reply_post_host_index_addr[0] =
-		(u32 *)((u8 *)instance->reg_set +
+		(u32 __iomem *)((u8 __iomem *)instance->reg_set +
 		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 
 	/* Check if MSI-X is supported while in ready state */
@@ -4582,7 +4582,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
 			 */
 			for (loop = 1; loop < MR_MAX_MSIX_REG_ARRAY; loop++) {
 				instance->reply_post_host_index_addr[loop] =
-					(u32 *)((u8 *)instance->reg_set +
+					(u32 __iomem *)
+					((u8 __iomem *)instance->reg_set +
 					MPI2_SUP_REPLY_POST_HOST_INDEX_OFFSET
 					+ (loop * 0x10));
 			}
-- 
1.7.1

