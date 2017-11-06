From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH] mpt3sas: fix dma_addr_t casts
Date: Mon, 6 Nov 2017 10:20:24 -0700
Message-ID: <0083105ba2839c710c6455356c7e4086@mail.gmail.com>
References: <20171106133540.506572-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f193.google.com ([209.85.220.193]:43732 "EHLO
        mail-qk0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932083AbdKFRU0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2017 12:20:26 -0500
Received: by mail-qk0-f193.google.com with SMTP id 78so4911867qkz.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Nov 2017 09:20:25 -0800 (PST)
In-Reply-To: <20171106133540.506572-1-arnd@arndb.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Tomas Henzl <thenzl@redhat.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Hannes Reinecke <hare@suse.de>, Romain Perier <romain.perier@collabora.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Bart Van Assche <bart.vanassche@sandisk.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Acked-by: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>

-----Original Message-----
From: Arnd Bergmann [mailto:arnd@arndb.de]
Sent: Monday, November 6, 2017 6:35 AM
To: Sathya Prakash; Chaitra P B; Suganath Prabu Subramani; James E.J.
Bottomley; Martin K. Petersen
Cc: Arnd Bergmann; Tomas Henzl; Sreekanth Reddy; Hannes Reinecke; Romain
Perier; James Bottomley; Bart Van Assche;
MPT-FusionLinux.pdl@broadcom.com; linux-scsi@vger.kernel.org;
linux-kernel@vger.kernel.org
Subject: [PATCH] mpt3sas: fix dma_addr_t casts

The newly added base_make_prp_nvme function triggers a build warning on
some 32-bit configurations:

drivers/scsi/mpt3sas/mpt3sas_base.c: In function 'base_make_prp_nvme':
drivers/scsi/mpt3sas/mpt3sas_base.c:1664:13: error: cast from pointer to
integer of different size [-Werror=pointer-to-int-cast]
  msg_phys = (dma_addr_t)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);

After taking a closer look, I found that the problem is that the new code
mixes up pointers and dma_addr_t values unnecessarily.

This changes it to use the correct types consistently, which lets us get
rid of a lot of type casts in the process. I'm also renaming some
variables to avoid confusion between physical and dma address spaces that
are often distinct.

Fixes: 016d5c35e278 ("scsi: mpt3sas: SGL to PRP Translation for I/Os to
NVMe devices")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 62
+++++++++++++++++--------------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |  2 +-
 2 files changed, 30 insertions(+), 34 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 7a3f4d14f260..8027de465d47 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1437,11 +1437,11 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc,
u16 smid,
 	size_t data_in_sz)
 {
 	int		prp_size = NVME_PRP_SIZE;
-	__le64		*prp_entry, *prp1_entry, *prp2_entry,
*prp_entry_phys;
-	__le64		*prp_page, *prp_page_phys;
+	__le64		*prp_entry, *prp1_entry, *prp2_entry;
+	__le64		*prp_page;
+	dma_addr_t	prp_entry_dma, prp_page_dma, dma_addr;
 	u32		offset, entry_len;
 	u32		page_mask_result, page_mask;
-	dma_addr_t	paddr;
 	size_t		length;

 	/*
@@ -1465,7 +1465,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc,
u16 smid,
 	 * contiguous memory.
 	 */
 	prp_page = (__le64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
-	prp_page_phys = (__le64 *)mpt3sas_base_get_pcie_sgl_dma(ioc,
smid);
+	prp_page_dma = mpt3sas_base_get_pcie_sgl_dma(ioc, smid);

 	/*
 	 * Check if we are within 1 entry of a page boundary we don't @@
-1476,21 +1476,21 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16
smid,
 	if (!page_mask_result) {
 		/* Bump up to next page boundary. */
 		prp_page = (__le64 *)((u8 *)prp_page + prp_size);
-		prp_page_phys = (__le64 *)((u8 *)prp_page_phys +
prp_size);
+		prp_page_dma = prp_page_dma + prp_size;
 	}

 	/*
 	 * Set PRP physical pointer, which initially points to the current
PRP
 	 * DMA memory page.
 	 */
-	prp_entry_phys = prp_page_phys;
+	prp_entry_dma = prp_page_dma;

 	/* Get physical address and length of the data buffer. */
 	if (data_in_sz) {
-		paddr = data_in_dma;
+		dma_addr = data_in_dma;
 		length = data_in_sz;
 	} else {
-		paddr = data_out_dma;
+		dma_addr = data_out_dma;
 		length = data_out_sz;
 	}

@@ -1500,8 +1500,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc,
u16 smid,
 		 * Check if we need to put a list pointer here if we are
at
 		 * page boundary - prp_size (8 bytes).
 		 */
-		page_mask_result =
-		    (uintptr_t)((u8 *)prp_entry_phys + prp_size) &
page_mask;
+		page_mask_result = (prp_entry_dma + prp_size) & page_mask;
 		if (!page_mask_result) {
 			/*
 			 * This is the last entry in a PRP List, so we
need to @@ -1515,13 +1514,13 @@ _base_build_nvme_prp(struct
MPT3SAS_ADAPTER *ioc, u16 smid,
 			 *     contiguous, no need to get a new page -
it's
 			 *     just the next address.
 			 */
-			prp_entry_phys++;
-			*prp_entry =
cpu_to_le64((uintptr_t)prp_entry_phys);
+			prp_entry_dma++;
+			*prp_entry = cpu_to_le64(prp_entry_dma);
 			prp_entry++;
 		}

 		/* Need to handle if entry will be part of a page. */
-		offset = (u32)paddr & page_mask;
+		offset = dma_addr & page_mask;
 		entry_len = ioc->page_size - offset;

 		if (prp_entry == prp1_entry) {
@@ -1529,7 +1528,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc,
u16 smid,
 			 * Must fill in the first PRP pointer (PRP1)
before
 			 * moving on.
 			 */
-			*prp1_entry = cpu_to_le64((u64)paddr);
+			*prp1_entry = cpu_to_le64(dma_addr);

 			/*
 			 * Now point to the second PRP entry within the @@
-1549,8 +1548,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16
smid,
 				 * list will start at the beginning of the
 				 * contiguous buffer.
 				 */
-				*prp2_entry =
-
cpu_to_le64((uintptr_t)prp_entry_phys);
+				*prp2_entry = cpu_to_le64(prp_entry_dma);

 				/*
 				 * The next PRP Entry will be the start of
the @@ -1562,7 +1560,7 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER
*ioc, u16 smid,
 				 * After this, the PRP Entries are
complete.
 				 * This command uses 2 PRP's and no PRP
list.
 				 */
-				*prp2_entry = cpu_to_le64((u64)paddr);
+				*prp2_entry = cpu_to_le64(dma_addr);
 			}
 		} else {
 			/*
@@ -1572,16 +1570,16 @@ _base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc,
u16 smid,
 			 * all remaining PRP entries in a PRP List, one
per
 			 * each time through the loop.
 			 */
-			*prp_entry = cpu_to_le64((u64)paddr);
+			*prp_entry = cpu_to_le64(dma_addr);
 			prp_entry++;
-			prp_entry_phys++;
+			prp_entry_dma++;
 		}

 		/*
 		 * Bump the phys address of the command's data buffer by
the
 		 * entry_len.
 		 */
-		paddr += entry_len;
+		dma_addr += entry_len;

 		/* Decrement length accounting for last partial page. */
 		if (entry_len > length)
@@ -1610,11 +1608,10 @@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 		Mpi25SCSIIORequest_t *mpi_request,
 		u16 smid, int sge_count)
 {
-	int sge_len, offset, num_prp_in_chain = 0;
+	int sge_len, num_prp_in_chain = 0;
 	Mpi25IeeeSgeChain64_t *main_chain_element, *ptr_first_sgl;
 	__le64 *curr_buff;
-	dma_addr_t msg_phys;
-	u64 sge_addr;
+	dma_addr_t msg_dma, sge_addr, offset;
 	u32 page_mask, page_mask_result;
 	struct scatterlist *sg_scmd;
 	u32 first_prp_len;
@@ -1661,9 +1658,9 @@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 	 * page (4k).
 	 */
 	curr_buff = mpt3sas_base_get_pcie_sgl(ioc, smid);
-	msg_phys = (dma_addr_t)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
+	msg_dma = mpt3sas_base_get_pcie_sgl_dma(ioc, smid);

-	main_chain_element->Address = cpu_to_le64(msg_phys);
+	main_chain_element->Address = cpu_to_le64(msg_dma);
 	main_chain_element->NextChainOffset = 0;
 	main_chain_element->Flags = MPI2_IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 			MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR |
@@ -1675,7 +1672,7 @@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 	sge_addr = sg_dma_address(sg_scmd);
 	sge_len = sg_dma_len(sg_scmd);

-	offset = (u32)(sge_addr & page_mask);
+	offset = sge_addr & page_mask;
 	first_prp_len = nvme_pg_size - offset;

 	ptr_first_sgl->Address = cpu_to_le64(sge_addr); @@ -1693,7 +1690,7
@@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 	}

 	for (;;) {
-		offset = (u32)(sge_addr & page_mask);
+		offset = sge_addr & page_mask;

 		/* Put PRP pointer due to page boundary*/
 		page_mask_result = (uintptr_t)(curr_buff + 1) & page_mask;
@@ -1701,15 +1698,15 @@ base_make_prp_nvme(struct MPT3SAS_ADAPTER *ioc,
 			scmd_printk(KERN_NOTICE,
 				scmd, "page boundary curr_buff: 0x%p\n",
 				curr_buff);
-			msg_phys += 8;
-			*curr_buff = cpu_to_le64(msg_phys);
+			msg_dma += 8;
+			*curr_buff = cpu_to_le64(msg_dma);
 			curr_buff++;
 			num_prp_in_chain++;
 		}

 		*curr_buff = cpu_to_le64(sge_addr);
 		curr_buff++;
-		msg_phys += 8;
+		msg_dma += 8;
 		num_prp_in_chain++;

 		sge_addr += nvme_pg_size;
@@ -2755,11 +2752,10 @@ mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER
*ioc, u16 smid)
  *
  * Returns phys pointer to the address of the PCIe buffer.
  */
-void *
+dma_addr_t
 mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid)  {
-	return (void *)(uintptr_t)
-		(ioc->scsi_lookup[smid - 1].pcie_sg_list.pcie_sgl_dma);
+	return ioc->scsi_lookup[smid - 1].pcie_sg_list.pcie_sgl_dma;
 }

 /**
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h
b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 2d7d44281cb7..60f42ca3954f 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -1395,7 +1395,7 @@ void *mpt3sas_base_get_sense_buffer(struct
MPT3SAS_ADAPTER *ioc, u16 smid);
 __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
 void *mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER *ioc, u16 smid);
-void *mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16
smid);
+dma_addr_t mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc,
+u16 smid);
 void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);

 /* hi-priority queue */
--
2.9.0
