From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] scsi: megaraid_sas: handle dma_addr_t right on 32-bit
Date: Tue, 14 Feb 2017 22:21:51 +0100
Message-ID: <20170214212238.2696334-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Tomas Henzl <thenzl@redhat.com>, Hannes Reinecke <hare@suse.com>, Sasikumar Chandrasekaran <sasikumar.pc@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

When building with a dma_addr_t that is different from pointer size, we get
this warning:

drivers/scsi/megaraid/megaraid_sas_fusion.c: In function 'megasas_make_prp_nvme':
drivers/scsi/megaraid/megaraid_sas_fusion.c:1654:17: error: cast to pointer from integer of different size [-Werror=int-to-pointer-cast]

It's better to not pretend that the dma address is a pointer and instead
use a dma_addr_t consistently.

Fixes: 33203bc4d61b ("scsi: megaraid_sas: NVME fast path io support")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fusion.c b/drivers/scsi/megaraid/megaraid_sas_fusion.c
index 750090119f81..29650ba669da 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fusion.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fusion.c
@@ -1619,7 +1619,8 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
 {
 	int sge_len, offset, num_prp_in_chain = 0;
 	struct MPI25_IEEE_SGE_CHAIN64 *main_chain_element, *ptr_first_sgl;
-	u64 *ptr_sgl, *ptr_sgl_phys;
+	u64 *ptr_sgl;
+	dma_addr_t ptr_sgl_phys;
 	u64 sge_addr;
 	u32 page_mask, page_mask_result;
 	struct scatterlist *sg_scmd;
@@ -1651,14 +1652,14 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
 	 */
 	page_mask = mr_nvme_pg_size - 1;
 	ptr_sgl = (u64 *)cmd->sg_frame;
-	ptr_sgl_phys = (u64 *)cmd->sg_frame_phys_addr;
+	ptr_sgl_phys = cmd->sg_frame_phys_addr;
 	memset(ptr_sgl, 0, instance->max_chain_frame_sz);
 
 	/* Build chain frame element which holds all prps except first*/
 	main_chain_element = (struct MPI25_IEEE_SGE_CHAIN64 *)
 	    ((u8 *)sgl_ptr + sizeof(struct MPI25_IEEE_SGE_CHAIN64));
 
-	main_chain_element->Address = cpu_to_le64((uintptr_t)ptr_sgl_phys);
+	main_chain_element->Address = cpu_to_le64(ptr_sgl_phys);
 	main_chain_element->NextChainOffset = 0;
 	main_chain_element->Flags = IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 					IEEE_SGE_FLAGS_SYSTEM_ADDR |
@@ -1696,16 +1697,15 @@ megasas_make_prp_nvme(struct megasas_instance *instance, struct scsi_cmnd *scmd,
 			scmd_printk(KERN_NOTICE,
 				    scmd, "page boundary ptr_sgl: 0x%p\n",
 				    ptr_sgl);
-			ptr_sgl_phys++;
-			*ptr_sgl =
-				cpu_to_le64((uintptr_t)ptr_sgl_phys);
+			ptr_sgl_phys += 8;
+			*ptr_sgl = cpu_to_le64(ptr_sgl_phys);
 			ptr_sgl++;
 			num_prp_in_chain++;
 		}
 
 		*ptr_sgl = cpu_to_le64(sge_addr);
 		ptr_sgl++;
-		ptr_sgl_phys++;
+		ptr_sgl_phys += 8;
 		num_prp_in_chain++;
 
 		sge_addr += mr_nvme_pg_size;
-- 
2.9.0
