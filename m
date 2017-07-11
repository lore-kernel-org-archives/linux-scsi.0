From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 02/13] mpt3sas: SGL to PRP Translation for I/Os to NVMe  devices
Date: Tue, 11 Jul 2017 14:25:02 +0530
Message-ID: <1499763313-7214-3-git-send-email-suganath-prabu.subramani@broadcom.com>
References: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1499763313-7214-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@Parallels.com, jejb@kernel.org, hch@infradead.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, Sathya.Prakash@broadcom.com, kashyap.desai@broadcom.com, linux-kernel@vger.kernel.org, suganath-prabu.subramani@broadcom.com, chaitra.basappa@broadcom.com, sreekanth.reddy@broadcom.com, linux-nvme@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

* Added support for translating the SGLs associated with incoming
commands either to IEE SGL or NVMe PRPs for NVMe devices.

* The hardware translation of IEEE SGL to NVMe PRPs has limitation
and if a command cannot be translated by hardware then it will go
to firmware and the firmware needs to translate it. And this will
have a performance reduction. To avoid that driver proactively
checks whether the translation will be done in hardware or not,
if not then driver try to translate inside the driver.

Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c  |  623 +++++++++++++++++++++++++++++++++-
 drivers/scsi/mpt3sas/mpt3sas_base.h  |   43 +++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c   |    1 +
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |   12 +-
 4 files changed, 666 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 18039bb..b67212c 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -59,6 +59,7 @@
 #include <linux/time.h>
 #include <linux/ktime.h>
 #include <linux/kthread.h>
+#include <asm/page.h>        /* To get host page size per arch */
 #include <linux/aer.h>
 
 
@@ -1347,6 +1348,502 @@ _base_build_sg(struct MPT3SAS_ADAPTER *ioc, void *psge,
 /* IEEE format sgls */
 
 /**
+ * _base_build_nvme_prp - This function is called for NVMe end devices to build
+ * a native SGL (NVMe PRP). The native SGL is built starting in the first PRP
+ * entry of the NVMe message (PRP1).  If the data buffer is small enough to be
+ * described entirely using PRP1, then PRP2 is not used.  If needed, PRP2 is
+ * used to describe a larger data buffer.  If the data buffer is too large to
+ * describe using the two PRP entriess inside the NVMe message, then PRP1
+ * describes the first data memory segment, and PRP2 contains a pointer to a PRP
+ * list located elsewhere in memory to describe the remaining data memory
+ * segments.  The PRP list will be contiguous.
+
+ * The native SGL for NVMe devices is a Physical Region Page (PRP).  A PRP
+ * consists of a list of PRP entries to describe a number of noncontigous
+ * physical memory segments as a single memory buffer, just as a SGL does.  Note
+ * however, that this function is only used by the IOCTL call, so the memory
+ * given will be guaranteed to be contiguous.  There is no need to translate
+ * non-contiguous SGL into a PRP in this case.  All PRPs will describe
+ * contiguous space that is one page size each.
+ *
+ * Each NVMe message contains two PRP entries.  The first (PRP1) either contains
+ * a PRP list pointer or a PRP element, depending upon the command.  PRP2
+ * contains the second PRP element if the memory being described fits within 2
+ * PRP entries, or a PRP list pointer if the PRP spans more than two entries.
+ *
+ * A PRP list pointer contains the address of a PRP list, structured as a linear
+ * array of PRP entries.  Each PRP entry in this list describes a segment of
+ * physical memory.
+ *
+ * Each 64-bit PRP entry comprises an address and an offset field.  The address
+ * always points at the beginning of a 4KB physical memory page, and the offset
+ * describes where within that 4KB page the memory segment begins.  Only the
+ * first element in a PRP list may contain a non-zero offest, implying that all
+ * memory segments following the first begin at the start of a 4KB page.
+ *
+ * Each PRP element normally describes 4KB of physical memory, with exceptions
+ * for the first and last elements in the list.  If the memory being described
+ * by the list begins at a non-zero offset within the first 4KB page, then the
+ * first PRP element will contain a non-zero offset indicating where the region
+ * begins within the 4KB page.  The last memory segment may end before the end
+ * of the 4KB segment, depending upon the overall size of the memory being
+ * described by the PRP list.
+ *
+ * Since PRP entries lack any indication of size, the overall data buffer length
+ * is used to determine where the end of the data memory buffer is located, and
+ * how many PRP entries are required to describe it.
+ *
+ * @ioc: per adapter object
+ * @smid: system request message index for getting asscociated SGL
+ * @nvme_encap_request: the NVMe request msg frame pointer
+ * @data_out_dma: physical address for WRITES
+ * @data_out_sz: data xfer size for WRITES
+ * @data_in_dma: physical address for READS
+ * @data_in_sz: data xfer size for READS
+ *
+ * Returns nothing.
+ */
+static void
+_base_build_nvme_prp(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request,
+	dma_addr_t data_out_dma, size_t data_out_sz, dma_addr_t data_in_dma,
+	size_t data_in_sz)
+{
+	int		prp_size = NVME_PRP_SIZE;
+	u64		*prp_entry, *prp1_entry, *prp2_entry, *prp_entry_phys;
+	u64		*prp_page, *prp_page_phys;
+	u32		offset, entry_len;
+	u32		page_mask_result, page_mask;
+	dma_addr_t	paddr;
+	size_t		length;
+
+	/*
+	 * Not all commands require a data transfer. If no data, just return
+	 * without constructing any PRP.
+	 */
+	if (!data_in_sz && !data_out_sz)
+		return;
+	/*
+	 * Set pointers to PRP1 and PRP2, which are in the NVMe command.
+	 * PRP1 is located at a 24 byte offset from the start of the NVMe
+	 * command.  Then set the current PRP entry pointer to PRP1.
+	 */
+	prp1_entry = (u64 *)(nvme_encap_request->NVMe_Command +
+	    NVME_CMD_PRP1_OFFSET);
+	prp2_entry = (u64 *)(nvme_encap_request->NVMe_Command +
+	    NVME_CMD_PRP2_OFFSET);
+	prp_entry = prp1_entry;
+	/*
+	 * For the PRP entries, use the specially allocated buffer of
+	 * contiguous memory.
+	 */
+	prp_page = (u64 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
+	prp_page_phys = (u64 *)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
+
+	/*
+	 * Check if we are within 1 entry of a page boundary we don't
+	 * want our first entry to be a PRP List entry.
+	 */
+	page_mask = ioc->page_size - 1;
+	page_mask_result = (uintptr_t)((u8 *)prp_page + prp_size) & page_mask;
+	if (!page_mask_result) {
+		/* Bump up to next page boundary. */
+		prp_page = (u64 *)((u8 *)prp_page + prp_size);
+		prp_page_phys = (u64 *)((u8 *)prp_page_phys + prp_size);
+	}
+
+	/*
+	 * Set PRP physical pointer, which initially points to the current PRP
+	 * DMA memory page.
+	 */
+	prp_entry_phys = prp_page_phys;
+
+	/* Get physical address and length of the data buffer. */
+	if (data_in_sz) {
+		paddr = data_in_dma;
+		length = data_in_sz;
+	} else {
+		paddr = data_out_dma;
+		length = data_out_sz;
+	}
+
+	/* Loop while the length is not zero. */
+	while (length) {
+		/*
+		 * Check if we need to put a list pointer here if we are at
+		 * page boundary - prp_size (8 bytes).
+		 */
+		page_mask_result =
+		    (uintptr_t)((u8 *)prp_entry_phys + prp_size) & page_mask;
+		if (!page_mask_result) {
+			/*
+			 * This is the last entry in a PRP List, so we need to
+			 * put a PRP list pointer here.  What this does is:
+			 *   - bump the current memory pointer to the next
+			 *     address, which will be the next full page.
+			 *   - set the PRP Entry to point to that page.  This
+			 *     is now the PRP List pointer.
+			 *   - bump the PRP Entry pointer the start of the
+			 *     next page.  Since all of this PRP memory is
+			 *     contiguous, no need to get a new page - it's
+			 *     just the next address.
+			 */
+			prp_entry_phys++;
+			*prp_entry = cpu_to_le64((uintptr_t)prp_entry_phys);
+			prp_entry++;
+		}
+
+		/* Need to handle if entry will be part of a page. */
+		offset = (u32)paddr & page_mask;
+		entry_len = ioc->page_size - offset;
+
+		if (prp_entry == prp1_entry) {
+			/*
+			 * Must fill in the first PRP pointer (PRP1) before
+			 * moving on.
+			 */
+			*prp1_entry = cpu_to_le64((u64)paddr);
+
+			/*
+			 * Now point to the second PRP entry within the
+			 * command (PRP2).
+			 */
+			prp_entry = prp2_entry;
+		} else if (prp_entry == prp2_entry) {
+			/*
+			 * Should the PRP2 entry be a PRP List pointer or just
+			 * a regular PRP pointer?  If there is more than one
+			 * more page of data, must use a PRP List pointer.
+			 */
+			if (length > ioc->page_size) {
+				/*
+				 * PRP2 will contain a PRP List pointer because
+				 * more PRP's are needed with this command. The
+				 * list will start at the beginning of the
+				 * contiguous buffer.
+				 */
+				*prp2_entry =
+				    cpu_to_le64((uintptr_t)prp_entry_phys);
+
+				/*
+				 * The next PRP Entry will be the start of the
+				 * first PRP List.
+				 */
+				prp_entry = prp_page;
+			} else {
+				/*
+				 * After this, the PRP Entries are complete.
+				 * This command uses 2 PRP's and no PRP list.
+				 */
+				*prp2_entry = cpu_to_le64((u64)paddr);
+			}
+		} else {
+			/*
+			 * Put entry in list and bump the addresses.
+			 *
+			 * After PRP1 and PRP2 are filled in, this will fill in
+			 * all remaining PRP entries in a PRP List, one per
+			 * each time through the loop.
+			 */
+			*prp_entry = cpu_to_le64((u64)paddr);
+			prp_entry++;
+			prp_entry_phys++;
+		}
+
+		/*
+		 * Bump the phys address of the command's data buffer by the
+		 * entry_len.
+		 */
+		paddr += entry_len;
+
+		/* Decrement length accounting for last partial page. */
+		if (entry_len > length)
+			length = 0;
+		else
+			length -= entry_len;
+	}
+}
+
+/**
+ * _base_check_pcie_native_sgl - This function is called for PCIe end devices to
+ * determine if the driver needs to build a native SGL.  If so, that native
+ * SGL is built in the special contiguous buffers allocated especially for
+ * PCIe SGL creation.  If the driver will not build a native SGL, return
+ * TRUE and a normal IEEE SGL will be built.  Currently this routine
+ * supports NVMe.
+ * @ioc: per adapter object
+ * @mpi_request: mf request pointer
+ * @smid: system request message index
+ * @scmd: scsi command
+ * @pcie_device: points to the PCIe device's info
+ *
+ * Returns 0 if native SGL was built, 1 if no SGL was built
+ */
+static int
+_base_check_pcie_native_sgl(struct MPT3SAS_ADAPTER *ioc,
+	Mpi25SCSIIORequest_t *mpi_request, u16 smid, struct scsi_cmnd *scmd,
+	struct _pcie_device *pcie_device)
+{
+	struct scatterlist *sg_scmd;
+	int sges_left;
+	u32 i, sge_dwords, length, offset, entry_len, num_entries;
+	u32 buff_len, sges_in_segment, page_mask;
+	u32 page_mask_result;
+	u32 *curr_buff, *ptr_sgl, *ptr_first_sgl;
+	u32 first_page_offset, first_page_data_size, end_residual;
+	u64 *msg_phys;
+	dma_addr_t paddr;
+	int build_native_sgl = 0, first_prp_entry;
+	Mpi25IeeeSgeChain64_t *main_chain_element = NULL;
+
+	/* Get the SG list pointer and info. */
+	sg_scmd = scsi_sglist(scmd);
+	sges_left = scsi_dma_map(scmd);
+	if (sges_left < 0) {
+		sdev_printk(KERN_ERR, scmd->device,
+			"scsi_dma_map failed: request for %d bytes!\n",
+			scsi_bufflen(scmd));
+		return 1;
+	}
+	buff_len = cpu_to_le32(scsi_bufflen(scmd));
+
+	/*
+	 * For NVMe, check if the data transfer length exceeds the MDTS (Maximum
+	 * Data Transfer Size) for this device.  If so, just return 1 so a
+	 * normal IEEE SGL is built.  F/W will break up the I/O into multiple
+	 * I/O's.  [nvme_mdts = 0 means unlimited]
+	 */
+	if ((pcie_device->nvme_mdts > 0) && (buff_len > pcie_device->nvme_mdts))
+		goto out;
+
+
+	/* Create page_mask (to get offset within page) */
+	page_mask = ioc->page_size - 1;
+
+	/*
+	 * Check if the number of elements exceeds the max number that can be
+	 * put in the main message frame (H/W can only translate an SGL that
+	 * is contained entirely in the main message frame).
+	 */
+	sges_in_segment = (ioc->request_sz -
+	    offsetof(Mpi25SCSIIORequest_t, SGL))/ioc->sge_size_ieee;
+	if (sges_left > sges_in_segment)
+		build_native_sgl = 1;
+	else {
+		/*
+		 * NVMe uses one PRP for each physical page (or part of
+		 * physical page)
+		 * look at the data length
+		 *    if 4 pages or less then IEEE is OK
+		 *    if > 5 pages then we need to build a native SGL
+		 *    if > 4 and <= 5 pages, then check the physical
+		 *      address of the first SG entry, then if this
+		 *      first size in the page is >= the residual beyond
+		 *      4 pages then use IEEE, otherwise use native SGL
+		 */
+		if (buff_len > (ioc->page_size * 5))
+			build_native_sgl = 1;
+		else if ((buff_len > (ioc->page_size * 4)) &&
+		    (buff_len <= (ioc->page_size * 5))) {
+			msg_phys = (u64 *) sg_dma_address(sg_scmd);
+			first_page_offset = ((u32)(u64)msg_phys & page_mask);
+			first_page_data_size = ioc->page_size -
+			    first_page_offset;
+			end_residual = buff_len % ioc->page_size;
+
+			/*
+			 * If offset into first page pushes the end of
+			 * the data beyond end of the 5th page, we need
+			 * the extra PRP list
+			 */
+			if (first_page_data_size < end_residual)
+				build_native_sgl = 1;
+
+			/*
+			 * Check if first SG entry size is < residual
+			 * beyond 4 pages.
+			 */
+			if (sg_dma_len(sg_scmd) <
+			    (buff_len - (ioc->page_size * 4)))
+				build_native_sgl = 1;
+		}
+	}
+
+	/* check if native SGL is needed */
+	if (!build_native_sgl)
+		goto out;
+
+	/*
+	 * Native SGL is needed.
+	 * Put a chain element in main message frame that points to the first
+	 * chain buffer.
+	 *
+	 * NOTE:  The ChainOffset field must be 0 when using a chain pointer to
+	 *        a native SGL.
+	 */
+
+	/* Set main message chain element pointer */
+	main_chain_element = (pMpi25IeeeSgeChain64_t)&mpi_request->SGL;
+
+	/*
+	 * For NVMe the chain element needs to be the 2nd SG entry in the main
+	 * message.
+	 */
+	main_chain_element = (Mpi25IeeeSgeChain64_t *)
+	    ((u8 *)main_chain_element + sizeof(MPI25_IEEE_SGE_CHAIN64));
+
+	/*
+	 * For the PRP entries, use the specially allocated buffer of
+	 * contiguous memory.  Normal chain buffers can't be used
+	 * because each chain buffer would need to be the size of an OS
+	 * page (4k).
+	 */
+	curr_buff = (u32 *)mpt3sas_base_get_pcie_sgl(ioc, smid);
+	msg_phys = (u64 *)mpt3sas_base_get_pcie_sgl_dma(ioc, smid);
+
+	/*
+	 * Check if we are within 1 entry of a page boundary we don't
+	 * want our first entry to be a PRP List entry.
+	 */
+	page_mask_result = (uintptr_t)((u8 *)curr_buff + 8) & page_mask;
+	if (!page_mask_result) {
+		/* Bump up to next page boundary. */
+		curr_buff = (u32 *)((u8 *)curr_buff + 8);
+		msg_phys = (u64 *)((u8 *)msg_phys + 8);
+	}
+
+	/*
+	 * Fill in the chain element and make it an NVMe segment type.
+	 */
+	main_chain_element->Address = cpu_to_le64((uintptr_t)msg_phys);
+	main_chain_element->NextChainOffset = 0;
+	main_chain_element->Flags = MPI2_IEEE_SGE_FLAGS_CHAIN_ELEMENT |
+		MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR |
+		MPI26_IEEE_SGE_FLAGS_NSF_NVME_PRP;
+
+	/* Set SGL pointer to start of contiguous PCIe buffer. */
+	ptr_sgl = curr_buff;
+	sge_dwords = 2;
+	num_entries = 0;
+
+	/*
+	 * NVMe has a very convoluted PRP format.  One PRP is required
+	 * for each page or partial page.  We need to split up OS SG
+	 * entries if they are longer than one page or cross a page
+	 * boundary.  We also have to insert a PRP list pointer entry as
+	 * the last entry in each physical page of the PRP list.
+	 *
+	 * NOTE: The first PRP "entry" is actually placed in the first
+	 * SGL entry in the main message in IEEE 64 format.  The 2nd
+	 * entry in the main message is the chain element, and the rest
+	 * of the PRP entries are built in the contiguous PCIe buffer.
+	 */
+	first_prp_entry = 1;
+	ptr_first_sgl = (u32 *)&mpi_request->SGL;
+
+	for (i = 0; i < sges_left; i++) {
+		/* Get physical address and length of this SG entry. */
+		paddr = sg_dma_address(sg_scmd);
+		length = sg_dma_len(sg_scmd);
+
+		/* Except the first PRP all other PRP entries should be page
+		 * aligned for NVMe drives, if not the I/O need to be split
+		 * into multiple I/Os. Let the firmware do the split by sending
+		 * IEEE SGEs for the case of non first SGE having a page
+		 * unaligned address. Watch this if there is a performance
+		 * issue with NVMe drives.
+		 */
+		if ((paddr & page_mask) && i)
+			goto out;
+
+		/* Apart from last SGE, if any other SGE boundary is not page
+		 * aligned then it means that hole exists. Existence of hole
+		 * leads to data corruption. So fallback to IEEE SGEs.
+		 */
+		if (i != (sges_left - 1))
+			if ((paddr + length) & page_mask)
+				goto out;
+
+		/* Loop while the length is not zero. */
+		while (length) {
+			/*
+			 * Check if we need to put a list pointer here
+			 * if we are at page boundary - 8.
+			 */
+			page_mask_result =
+			    (uintptr_t)((u8 *)ptr_sgl + 8) & page_mask;
+			if (!page_mask_result) {
+				/*
+				 * Need to put a PRP list pointer here.
+				 */
+				msg_phys = (u64 *)((u8 *)msg_phys + 8);
+				*ptr_sgl =
+				    cpu_to_le32((uintptr_t)msg_phys);
+				*(ptr_sgl+1) = cpu_to_le32(
+				    (u64)(uintptr_t)msg_phys >> 32);
+				ptr_sgl += sge_dwords;
+				num_entries++;
+			}
+
+			/*
+			 * Need to handle if entry will be part of a
+			 * page.
+			 */
+			offset = (u32)paddr & page_mask;
+			entry_len = ioc->page_size - offset;
+
+			if (first_prp_entry) {
+				/*
+				 * Put IEEE entry in 1st SGE in main
+				 * message.  (Simple element, System
+				 * addr, not end of list.)
+				 */
+				*ptr_first_sgl = cpu_to_le32((u32)paddr);
+				*(ptr_first_sgl+1) =
+					cpu_to_le32((u32)(paddr >> 32));
+				*(ptr_first_sgl+2) = cpu_to_le32(entry_len);
+				*(ptr_first_sgl+3) = 0;
+				/* No longer the first PRP entry. */
+				first_prp_entry = 0;
+			} else {
+				/* Put entry in list. */
+				*ptr_sgl = cpu_to_le32((u32)paddr);
+				*(ptr_sgl+1) = cpu_to_le32((u32)(paddr >> 32));
+				/*
+				 * Bump ptr_SGL, msg_phys, and
+				 * num_entries.
+				 */
+				ptr_sgl += sge_dwords;
+				msg_phys = (u64 *)((u8 *)msg_phys + 8);
+				num_entries++;
+			}
+
+			/* Bump the phys address by the entry_len. */
+			paddr += entry_len;
+
+			/*
+			 * Decrement length accounting for last partial
+			 * page.
+			 */
+			if (entry_len > length)
+				length = 0;
+			else
+				length -= entry_len;
+		}
+
+		/* Done with this SG entry, get the next one. */
+		sg_scmd = sg_next(sg_scmd);
+	}
+	/* Set chain element Length. */
+	main_chain_element->Length = cpu_to_le32(num_entries * 8);
+out:
+	scsi_dma_unmap(scmd);
+
+	/* Return 0, indicating we built a native SGL. */
+	return 1;
+}
+
+/**
  * _base_add_sg_single_ieee - add sg element for IEEE format
  * @paddr: virtual address for SGE
  * @flags: SGE flags
@@ -1391,9 +1888,11 @@ _base_build_zero_len_sge_ieee(struct MPT3SAS_ADAPTER *ioc, void *paddr)
 
 /**
  * _base_build_sg_scmd - main sg creation routine
+ *		pcie_device is unused here!
  * @ioc: per adapter object
  * @scmd: scsi command
  * @smid: system request message index
+ * @unused: unused pcie_device pointer
  * Context: none.
  *
  * The main routine that builds scatter gather table from a given
@@ -1403,7 +1902,7 @@ _base_build_zero_len_sge_ieee(struct MPT3SAS_ADAPTER *ioc, void *paddr)
  */
 static int
 _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
-		struct scsi_cmnd *scmd, u16 smid)
+	struct scsi_cmnd *scmd, u16 smid, struct _pcie_device *unused)
 {
 	Mpi2SCSIIORequest_t *mpi_request;
 	dma_addr_t chain_dma;
@@ -1537,6 +2036,8 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
  * @ioc: per adapter object
  * @scmd: scsi command
  * @smid: system request message index
+ * @pcie_device: Pointer to pcie_device. If set, the pcie native sgl will be
+ * constructed on need.
  * Context: none.
  *
  * The main routine that builds scatter gather table from a given
@@ -1546,9 +2047,9 @@ _base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
  */
 static int
 _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
-	struct scsi_cmnd *scmd, u16 smid)
+	struct scsi_cmnd *scmd, u16 smid, struct _pcie_device *pcie_device)
 {
-	Mpi2SCSIIORequest_t *mpi_request;
+	Mpi25SCSIIORequest_t *mpi_request;
 	dma_addr_t chain_dma;
 	struct scatterlist *sg_scmd;
 	void *sg_local, *chain;
@@ -1571,6 +2072,13 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 	chain_sgl_flags = MPI2_IEEE_SGE_FLAGS_CHAIN_ELEMENT |
 	    MPI2_IEEE_SGE_FLAGS_SYSTEM_ADDR;
 
+	/* Check if we need to build a native SG list. */
+	if ((pcie_device) && (_base_check_pcie_native_sgl(ioc, mpi_request,
+	    smid, scmd, pcie_device) == 0)) {
+		/* We built a native SG list, just return. */
+		return 0;
+	}
+
 	sg_scmd = scsi_sglist(scmd);
 	sges_left = scsi_dma_map(scmd);
 	if (sges_left < 0) {
@@ -1582,12 +2090,12 @@ _base_build_sg_scmd_ieee(struct MPT3SAS_ADAPTER *ioc,
 
 	sg_local = &mpi_request->SGL;
 	sges_in_segment = (ioc->request_sz -
-	    offsetof(Mpi2SCSIIORequest_t, SGL))/ioc->sge_size_ieee;
+		   offsetof(Mpi25SCSIIORequest_t, SGL))/ioc->sge_size_ieee;
 	if (sges_left <= sges_in_segment)
 		goto fill_in_last_segment;
 
 	mpi_request->ChainOffset = (sges_in_segment - 1 /* chain element */) +
-	    (offsetof(Mpi2SCSIIORequest_t, SGL)/ioc->sge_size_ieee);
+	    (offsetof(Mpi25SCSIIORequest_t, SGL)/ioc->sge_size_ieee);
 
 	/* fill in main message segment when there is a chain following */
 	while (sges_in_segment > 1) {
@@ -2267,6 +2775,33 @@ mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid)
 }
 
 /**
+ * mpt3sas_base_get_pcie_sgl - obtain a PCIe SGL virt addr
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns virt pointer to a PCIe SGL.
+ */
+void *
+mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return (void *)(ioc->scsi_lookup[smid - 1].pcie_sg_list.pcie_sgl);
+}
+
+/**
+ * mpt3sas_base_get_pcie_sgl_dma - obtain a PCIe SGL dma addr
+ * @ioc: per adapter object
+ * @smid: system request message index
+ *
+ * Returns phys pointer to the address of the PCIe buffer.
+ */
+void *
+mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid)
+{
+	return (void *)(uintptr_t)
+	    (ioc->scsi_lookup[smid - 1].pcie_sg_list.pcie_sgl_dma);
+}
+
+/**
  * mpt3sas_base_get_reply_virt_addr - obtain reply frames virt address
  * @ioc: per adapter object
  * @phys_addr: lower 32 physical addr of the reply
@@ -2945,6 +3480,11 @@ _base_display_ioc_capabilities(struct MPT3SAS_ADAPTER *ioc)
 
 	_base_display_OEMs_branding(ioc);
 
+	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_NVME_DEVICES) {
+		pr_info("%sNVMe", i ? "," : "");
+		i++;
+	}
+
 	pr_info(MPT3SAS_FMT "Protocol=(", ioc->name);
 
 	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_SCSI_INITIATOR) {
@@ -3249,6 +3789,17 @@ _base_release_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		kfree(ioc->reply_post);
 	}
 
+	if (ioc->pcie_sgl_dma_pool) {
+		for (i = 0; i < ioc->scsiio_depth; i++) {
+			if (ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl)
+				pci_pool_free(ioc->pcie_sgl_dma_pool,
+				ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl,
+				ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl_dma);
+		}
+		if (ioc->pcie_sgl_dma_pool)
+			pci_pool_destroy(ioc->pcie_sgl_dma_pool);
+	}
+
 	if (ioc->config_page) {
 		dexitprintk(ioc, pr_info(MPT3SAS_FMT
 		    "config_page(0x%p): free\n", ioc->name,
@@ -3291,7 +3842,7 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 	u16 chains_needed_per_io;
 	u32 sz, total_sz, reply_post_free_sz;
 	u32 retry_sz;
-	u16 max_request_credit;
+	u16 max_request_credit, nvme_blocks_needed;
 	unsigned short sg_tablesize;
 	u16 sge_size;
 	int i;
@@ -3627,7 +4178,52 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc)
 		"internal(0x%p): depth(%d), start smid(%d)\n",
 		ioc->name, ioc->internal,
 	    ioc->internal_depth, ioc->internal_smid));
+	/*
+	 * The number of NVMe page sized blocks needed is:
+	 *     (((sg_tablesize * 8) - 1) / (page_size - 8)) + 1
+	 * ((sg_tablesize * 8) - 1) is the max PRP's minus the first PRP entry
+	 * that is placed in the main message frame.  8 is the size of each PRP
+	 * entry or PRP list pointer entry.  8 is subtracted from page_size
+	 * because of the PRP list pointer entry at the end of a page, so this
+	 * is not counted as a PRP entry.  The 1 added page is a round up.
+	 *
+	 * To avoid allocation failures due to the amount of memory that could
+	 * be required for NVMe PRP's, only each set of NVMe blocks will be
+	 * contiguous, so a new set is allocated for each possible I/O.
+	 */
+	if (ioc->facts.ProtocolFlags & MPI2_IOCFACTS_PROTOCOL_NVME_DEVICES) {
+		nvme_blocks_needed =
+			(ioc->shost->sg_tablesize * NVME_PRP_SIZE) - 1;
+		nvme_blocks_needed /= (ioc->page_size - NVME_PRP_SIZE);
+		nvme_blocks_needed++;
+
+		sz = nvme_blocks_needed * ioc->page_size;
+		ioc->pcie_sgl_dma_pool =
+			pci_pool_create("PCIe SGL pool", ioc->pdev, sz, 16, 0);
+		if (!ioc->pcie_sgl_dma_pool) {
+			pr_info(MPT3SAS_FMT
+			    "PCIe SGL pool: pci_pool_create failed\n",
+			    ioc->name);
+			goto out;
+		}
+		for (i = 0; i < ioc->scsiio_depth; i++) {
+			ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl =
+					pci_pool_alloc(ioc->pcie_sgl_dma_pool,
+					GFP_KERNEL,
+				&ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl_dma);
+			if (!ioc->scsi_lookup[i].pcie_sg_list.pcie_sgl) {
+				pr_info(MPT3SAS_FMT
+				    "PCIe SGL pool: pci_pool_alloc failed\n",
+				    ioc->name);
+				goto out;
+			}
+		}
 
+		dinitprintk(ioc, pr_info(MPT3SAS_FMT "PCIe sgl pool depth(%d), "
+			"element_size(%d), pool_size(%d kB)\n", ioc->name,
+			ioc->scsiio_depth, sz, (sz * ioc->scsiio_depth)/1024));
+		total_sz += sz * ioc->scsiio_depth;
+	}
 	/* sense buffers, 4 byte align */
 	sz = ioc->scsiio_depth * SCSI_SENSE_BUFFERSIZE;
 	ioc->sense_dma_pool = pci_pool_create("sense pool", ioc->pdev, sz, 4,
@@ -4472,6 +5068,19 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc)
 	    le16_to_cpu(mpi_reply.HighPriorityCredit);
 	facts->ReplyFrameSize = mpi_reply.ReplyFrameSize;
 	facts->MaxDevHandle = le16_to_cpu(mpi_reply.MaxDevHandle);
+	facts->CurrentHostPageSize = mpi_reply.CurrentHostPageSize;
+
+	/*
+	 * Get the Page Size from IOC Facts. If it's 0, default to 4k.
+	 */
+	ioc->page_size = 1 << facts->CurrentHostPageSize;
+	if (ioc->page_size == 1) {
+		pr_info(MPT3SAS_FMT "CurrentHostPageSize is 0: Setting "
+			"default host page size to 4k\n", ioc->name);
+		ioc->page_size = 1 << MPT3SAS_HOST_PAGE_SIZE_4K;
+	}
+	dinitprintk(ioc, pr_info(MPT3SAS_FMT "CurrentHostPageSize(%d)\n",
+		ioc->name, facts->CurrentHostPageSize));
 
 	dinitprintk(ioc, pr_info(MPT3SAS_FMT
 		"hba queue depth(%d), max chains per io(%d)\n",
@@ -4511,6 +5120,7 @@ _base_send_ioc_init(struct MPT3SAS_ADAPTER *ioc)
 	mpi_request.VP_ID = 0;
 	mpi_request.MsgVersion = cpu_to_le16(ioc->hba_mpi_version_belonged);
 	mpi_request.HeaderVersion = cpu_to_le16(MPI2_HEADER_VERSION);
+	mpi_request.HostPageSize = MPT3SAS_HOST_PAGE_SIZE_4K;
 
 	if (_base_is_controller_msix_enabled(ioc))
 		mpi_request.HostMSIxVectors = ioc->reply_queue_count;
@@ -5379,6 +5989,7 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 		 */
 		ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
 		ioc->build_sg = &_base_build_sg_ieee;
+		ioc->build_nvme_prp = &_base_build_nvme_prp;
 		ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
 		ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
 
diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.h b/drivers/scsi/mpt3sas/mpt3sas_base.h
index 60fa7b6..cebdd8e 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.h
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.h
@@ -54,6 +54,7 @@
 #include "mpi/mpi2_raid.h"
 #include "mpi/mpi2_tool.h"
 #include "mpi/mpi2_sas.h"
+#include "mpi/mpi2_pci.h"
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
@@ -113,6 +114,7 @@
 #define MPT3SAS_RAID_QUEUE_DEPTH	128
 
 #define MPT3SAS_RAID_MAX_SECTORS	8192
+#define MPT3SAS_HOST_PAGE_SIZE_4K	12
 
 #define MPT_NAME_LENGTH			32	/* generic length of strings */
 #define MPT_STRING_LENGTH		64
@@ -131,6 +133,14 @@
 #define DEFAULT_NUM_FWCHAIN_ELEMTS	8
 
 /*
+ * NVMe defines
+ */
+#define	NVME_PRP_SIZE			8	/* PRP size */
+#define	NVME_CMD_PRP1_OFFSET		24	/* PRP1 offset in NVMe cmd */
+#define	NVME_CMD_PRP2_OFFSET		32	/* PRP2 offset in NVMe cmd */
+#define	NVME_ERROR_RESPONSE_SIZE	16	/* Max NVME Error Response */
+
+/*
  * reset phases
  */
 #define MPT3_IOC_PRE_RESET		1 /* prior to host reset */
@@ -159,6 +169,7 @@
 #define MPT_TARGET_FLAGS_VOLUME		0x02
 #define MPT_TARGET_FLAGS_DELETED	0x04
 #define MPT_TARGET_FASTPATH_IO		0x08
+#define MPT_TARGET_FLAGS_PCIE_DEVICE	0x10
 
 #define SAS2_PCI_DEVICE_B0_REVISION	(0x01)
 #define SAS3_PCI_DEVICE_C0_REVISION	(0x02)
@@ -689,6 +700,16 @@ enum reset_type {
 };
 
 /**
+ * struct pcie_sg_list - PCIe SGL buffer (contiguous per I/O)
+ * @pcie_sgl: PCIe native SGL for NVMe devices
+ * @pcie_sgl_dma: physical address
+ */
+struct pcie_sg_list {
+	void            *pcie_sgl;
+	dma_addr_t      pcie_sgl_dma;
+};
+
+/**
  * struct chain_tracker - firmware chain tracker
  * @chain_buffer: chain buffer
  * @chain_buffer_dma: physical address
@@ -714,6 +735,7 @@ struct scsiio_tracker {
 	struct scsi_cmnd *scmd;
 	u8	cb_idx;
 	u8	direct_io;
+	struct pcie_sg_list pcie_sg_list;
 	struct list_head chain_list;
 	struct list_head tracker_list;
 	u16     msix_io;
@@ -787,13 +809,19 @@ typedef void (*MPT_ADD_SGE)(void *paddr, u32 flags_length, dma_addr_t dma_addr);
 
 /* SAS3.0 support */
 typedef int (*MPT_BUILD_SG_SCMD)(struct MPT3SAS_ADAPTER *ioc,
-		struct scsi_cmnd *scmd, u16 smid);
+	struct scsi_cmnd *scmd, u16 smid, struct _pcie_device *pcie_device);
 typedef void (*MPT_BUILD_SG)(struct MPT3SAS_ADAPTER *ioc, void *psge,
 		dma_addr_t data_out_dma, size_t data_out_sz,
 		dma_addr_t data_in_dma, size_t data_in_sz);
 typedef void (*MPT_BUILD_ZERO_LEN_SGE)(struct MPT3SAS_ADAPTER *ioc,
 		void *paddr);
 
+/* SAS3.5 support */
+typedef void (*NVME_BUILD_PRP)(struct MPT3SAS_ADAPTER *ioc, u16 smid,
+	Mpi26NVMeEncapsulatedRequest_t *nvme_encap_request,
+	dma_addr_t data_out_dma, size_t data_out_sz, dma_addr_t data_in_dma,
+	size_t data_in_sz);
+
 /* To support atomic and non atomic descriptors*/
 typedef void (*PUT_SMID_IO_FP_HIP) (struct MPT3SAS_ADAPTER *ioc, u16 smid,
 	u16 funcdep);
@@ -836,6 +864,7 @@ struct mpt3sas_facts {
 	u16			MaxDevHandle;
 	u16			MaxPersistentEntries;
 	u16			MinDevHandle;
+	u8			CurrentHostPageSize;
 };
 
 struct mpt3sas_port_facts {
@@ -1107,6 +1136,9 @@ struct MPT3SAS_ADAPTER {
 	MPT_BUILD_SG    build_sg_mpi;
 	MPT_BUILD_ZERO_LEN_SGE build_zero_len_sge_mpi;
 
+	/* function ptr for NVMe PRP elements only */
+	NVME_BUILD_PRP  build_nvme_prp;
+
 	/* event log */
 	u32		event_type[MPI2_EVENT_NOTIFY_EVENTMASK_WORDS];
 	u32		event_context;
@@ -1175,6 +1207,12 @@ struct MPT3SAS_ADAPTER {
 	int		pending_io_count;
 	wait_queue_head_t reset_wq;
 
+	/* PCIe SGL */
+	struct dma_pool *pcie_sgl_dma_pool;
+
+	/* Host Page Size */
+	u32		page_size;
+
 	/* chain */
 	struct chain_tracker *chain_lookup;
 	struct list_head free_chain_list;
@@ -1308,7 +1346,8 @@ void *mpt3sas_base_get_msg_frame(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void *mpt3sas_base_get_sense_buffer(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 __le32 mpt3sas_base_get_sense_buffer_dma(struct MPT3SAS_ADAPTER *ioc,
 	u16 smid);
-
+void *mpt3sas_base_get_pcie_sgl(struct MPT3SAS_ADAPTER *ioc, u16 smid);
+void *mpt3sas_base_get_pcie_sgl_dma(struct MPT3SAS_ADAPTER *ioc, u16 smid);
 void mpt3sas_base_sync_reply_irqs(struct MPT3SAS_ADAPTER *ioc);
 
 /* hi-priority queue */
diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
index bdffb69..0c18831 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
@@ -299,6 +299,7 @@ mpt3sas_ctl_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index,
 			}
 		}
 	}
+
 	_ctl_display_some_debug(ioc, smid, "ctl_done", mpi_reply);
 	ioc->ctl_cmds.status &= ~MPT3_CMD_PENDING;
 	complete(&ioc->ctl_cmds.done);
diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
index cf2b35f..45b8d94 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
@@ -4207,7 +4207,8 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	struct _raid_device *raid_device;
 	struct request *rq = scmd->request;
 	int class;
-	Mpi2SCSIIORequest_t *mpi_request;
+	Mpi25SCSIIORequest_t *mpi_request;
+	struct _pcie_device *pcie_device = NULL;
 	u32 mpi_control;
 	u16 smid;
 	u16 handle;
@@ -4295,7 +4296,7 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 		goto out;
 	}
 	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
-	memset(mpi_request, 0, sizeof(Mpi2SCSIIORequest_t));
+	memset(mpi_request, 0, ioc->request_sz);
 	_scsih_setup_eedp(ioc, scmd, mpi_request);
 
 	if (scmd->cmd_len == 32)
@@ -4314,13 +4315,14 @@ scsih_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *scmd)
 	mpi_request->SenseBufferLength = SCSI_SENSE_BUFFERSIZE;
 	mpi_request->SenseBufferLowAddress =
 	    mpt3sas_base_get_sense_buffer_dma(ioc, smid);
-	mpi_request->SGLOffset0 = offsetof(Mpi2SCSIIORequest_t, SGL) / 4;
+	mpi_request->SGLOffset0 = offsetof(Mpi25SCSIIORequest_t, SGL) / 4;
 	int_to_scsilun(sas_device_priv_data->lun, (struct scsi_lun *)
 	    mpi_request->LUN);
 	memcpy(mpi_request->CDB.CDB32, scmd->cmnd, scmd->cmd_len);
 
 	if (mpi_request->DataLength) {
-		if (ioc->build_sg_scmd(ioc, scmd, smid)) {
+		pcie_device = sas_target_priv_data->pcie_dev;
+		if (ioc->build_sg_scmd(ioc, scmd, smid, pcie_device)) {
 			mpt3sas_base_free_smid(ioc, smid);
 			goto out;
 		}
@@ -4791,7 +4793,7 @@ out_unlock:
 static u8
 _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
 {
-	Mpi2SCSIIORequest_t *mpi_request;
+	Mpi25SCSIIORequest_t *mpi_request;
 	Mpi2SCSIIOReply_t *mpi_reply;
 	struct scsi_cmnd *scmd;
 	u16 ioc_status;
-- 
1.7.1
