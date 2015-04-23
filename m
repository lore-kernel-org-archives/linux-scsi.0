From: <Sumit.Saxena@avagotech.com>
Subject: [PATCH v3 11/18] megaraid_sas : add missing __iomem annotations
Date: Thu, 23 Apr 2015 16:32:39 +0530
Message-ID: <201504231104.t3NB4tUo030393@palmhbs0.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2lp0212.outbound.protection.outlook.com ([207.46.163.212]:3840
	"EHLO na01-bl2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756799AbbDWLCs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2015 07:02:48 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: thenzl@redhat.com, martin.petersen@oracle.com, hch@infradead.org, jbottomley@parallels.com, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

From: Christoph Hellwig <hch@lst.de>

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sumit Saxena <sumit.saxena@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
---
 drivers/scsi/megaraid/megaraid_sas.h      |    2 +-
 drivers/scsi/megaraid/megaraid_sas_base.c |    9 +++++----
 2 files changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas.h b/drivers/scsi/megaraid/megaraid_sas.h
index ab488e0..fc9ab5b 100644
--- a/drivers/scsi/megaraid/megaraid_sas.h
+++ b/drivers/scsi/megaraid/megaraid_sas.h
@@ -1693,7 +1693,7 @@ struct megasas_instance {
 	spinlock_t crashdump_lock;
 
 	struct megasas_register_set __iomem *reg_set;
-	u32 *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
+	u32 __iomem *reply_post_host_index_addr[MR_MAX_MSIX_REG_ARRAY];
 	struct megasas_pd_list          pd_list[MEGASAS_MAX_PD];
 	struct megasas_pd_list          local_pd_list[MEGASAS_MAX_PD];
 	u8 ld_ids[MEGASAS_MAX_LD_IDS];
diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi/megaraid/megaraid_sas_base.c
index aafbfb0..050784d 100644
--- a/drivers/scsi/megaraid/megaraid_sas_base.c
+++ b/drivers/scsi/megaraid/megaraid_sas_base.c
@@ -802,8 +802,8 @@ megasas_adp_reset_gen2(struct megasas_instance *instance,
 {
 	u32			retry = 0 ;
 	u32			HostDiag;
-	u32			*seq_offset = &reg_set->seq_offset;
-	u32			*hostdiag_offset = &reg_set->host_diag;
+	u32 __iomem		*seq_offset = &reg_set->seq_offset;
+	u32 __iomem		*hostdiag_offset = &reg_set->host_diag;
 
 	if (instance->instancet == &megasas_instance_template_skinny) {
 		seq_offset = &reg_set->fusion_seq_offset;
@@ -4579,7 +4579,7 @@ static int megasas_init_fw(struct megasas_instance *instance)
 	 * It is used for all MPT based Adapters.
 	 */
 	instance->reply_post_host_index_addr[0] =
-		(u32 *)((u8 *)instance->reg_set +
+		(u32 __iomem *)((u8 __iomem *)instance->reg_set +
 		MPI2_REPLY_POST_HOST_INDEX_OFFSET);
 
 	/* Check if MSI-X is supported while in ready state */
@@ -4611,7 +4611,8 @@ static int megasas_init_fw(struct megasas_instance *instance)
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

