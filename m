From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: [PATCH RESEND 08/25] mpt3sas: For an IO, build MPI SGL LIST on GEN2 HBA's and build IEEE SGL LIST on GEN3 HBA's
Date: Wed, 11 Nov 2015 17:30:24 +0530
Message-ID: <1447243241-10912-9-git-send-email-Sreekanth.Reddy@avagotech.com>
References: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447243241-10912-1-git-send-email-Sreekanth.Reddy@avagotech.com>
Sender: linux-kernel-owner@vger.kernel.org
To: jejb@kernel.org
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org, JBottomley@Parallels.com, Sathya.Prakash@avagotech.com, kashyap.desai@avagotech.com, linux-kernel@vger.kernel.org, hch@infradead.org, chaitra.basappa@avagotech.com, suganath-prabu.subramani@avagotech.com, Sreekanth Reddy <sreekanth.reddy@avagotech.com>, Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
List-Id: linux-scsi@vger.kernel.org

From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>

Gen2 HBA's uses MPI Scatter Gather Lists where as Gen3 HBA's uses
IEEE Scatter Gather Lists. So modify the common code part in such
a way that it will build IEEE SGL table for Gen3 HBA's and it will
build MPI SGL table for Gen2 HBA's.

Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
---
 drivers/scsi/mpt3sas/mpt3sas_base.c | 181 +++++++++++++++++++++++++++++++++---
 1 file changed, 168 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
index 31d0ca8..62dc312 100644
--- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -1318,6 +1318,149 @@ _base_build_zero_len_sge_ieee(struct MPT3SAS_ADAPTER *ioc, void *paddr)
 }
 
 /**
+ * _base_build_sg_scmd - main sg creation routine
+ * @ioc: per adapter object
+ * @scmd: scsi command
+ * @smid: system request message index
+ * Context: none.
+ *
+ * The main routine that builds scatter gather table from a given
+ * scsi request sent via the .queuecommand main handler.
+ *
+ * Returns 0 success, anything else error
+ */
+static int
+_base_build_sg_scmd(struct MPT3SAS_ADAPTER *ioc,
+		struct scsi_cmnd *scmd, u16 smid)
+{
+	Mpi2SCSIIORequest_t *mpi_request;
+	dma_addr_t chain_dma;
+	struct scatterlist *sg_scmd;
+	void *sg_local, *chain;
+	u32 chain_offset;
+	u32 chain_length;
+	u32 chain_flags;
+	int sges_left;
+	u32 sges_in_segment;
+	u32 sgl_flags;
+	u32 sgl_flags_last_element;
+	u32 sgl_flags_end_buffer;
+	struct chain_tracker *chain_req;
+
+	mpi_request = mpt3sas_base_get_msg_frame(ioc, smid);
+
+	/* init scatter gather flags */
+	sgl_flags = MPI2_SGE_FLAGS_SIMPLE_ELEMENT;
+	if (scmd->sc_data_direction == DMA_TO_DEVICE)
+		sgl_flags |= MPI2_SGE_FLAGS_HOST_TO_IOC;
+	sgl_flags_last_element = (sgl_flags | MPI2_SGE_FLAGS_LAST_ELEMENT)
+	    << MPI2_SGE_FLAGS_SHIFT;
+	sgl_flags_end_buffer = (sgl_flags | MPI2_SGE_FLAGS_LAST_ELEMENT |
+	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_END_OF_LIST)
+	    << MPI2_SGE_FLAGS_SHIFT;
+	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
+
+	sg_scmd = scsi_sglist(scmd);
+	sges_left = scsi_dma_map(scmd);
+	if (sges_left < 0) {
+		sdev_printk(KERN_ERR, scmd->device,
+		 "pci_map_sg failed: request for %d bytes!\n",
+		 scsi_bufflen(scmd));
+		return -ENOMEM;
+	}
+
+	sg_local = &mpi_request->SGL;
+	sges_in_segment = ioc->max_sges_in_main_message;
+	if (sges_left <= sges_in_segment)
+		goto fill_in_last_segment;
+
+	mpi_request->ChainOffset = (offsetof(Mpi2SCSIIORequest_t, SGL) +
+	    (sges_in_segment * ioc->sge_size))/4;
+
+	/* fill in main message segment when there is a chain following */
+	while (sges_in_segment) {
+		if (sges_in_segment == 1)
+			ioc->base_add_sg_single(sg_local,
+			    sgl_flags_last_element | sg_dma_len(sg_scmd),
+			    sg_dma_address(sg_scmd));
+		else
+			ioc->base_add_sg_single(sg_local, sgl_flags |
+			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+		sg_scmd = sg_next(sg_scmd);
+		sg_local += ioc->sge_size;
+		sges_left--;
+		sges_in_segment--;
+	}
+
+	/* initializing the chain flags and pointers */
+	chain_flags = MPI2_SGE_FLAGS_CHAIN_ELEMENT << MPI2_SGE_FLAGS_SHIFT;
+	chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+	if (!chain_req)
+		return -1;
+	chain = chain_req->chain_buffer;
+	chain_dma = chain_req->chain_buffer_dma;
+	do {
+		sges_in_segment = (sges_left <=
+		    ioc->max_sges_in_chain_message) ? sges_left :
+		    ioc->max_sges_in_chain_message;
+		chain_offset = (sges_left == sges_in_segment) ?
+		    0 : (sges_in_segment * ioc->sge_size)/4;
+		chain_length = sges_in_segment * ioc->sge_size;
+		if (chain_offset) {
+			chain_offset = chain_offset <<
+			    MPI2_SGE_CHAIN_OFFSET_SHIFT;
+			chain_length += ioc->sge_size;
+		}
+		ioc->base_add_sg_single(sg_local, chain_flags | chain_offset |
+		    chain_length, chain_dma);
+		sg_local = chain;
+		if (!chain_offset)
+			goto fill_in_last_segment;
+
+		/* fill in chain segments */
+		while (sges_in_segment) {
+			if (sges_in_segment == 1)
+				ioc->base_add_sg_single(sg_local,
+				    sgl_flags_last_element |
+				    sg_dma_len(sg_scmd),
+				    sg_dma_address(sg_scmd));
+			else
+				ioc->base_add_sg_single(sg_local, sgl_flags |
+				    sg_dma_len(sg_scmd),
+				    sg_dma_address(sg_scmd));
+			sg_scmd = sg_next(sg_scmd);
+			sg_local += ioc->sge_size;
+			sges_left--;
+			sges_in_segment--;
+		}
+
+		chain_req = _base_get_chain_buffer_tracker(ioc, smid);
+		if (!chain_req)
+			return -1;
+		chain = chain_req->chain_buffer;
+		chain_dma = chain_req->chain_buffer_dma;
+	} while (1);
+
+
+ fill_in_last_segment:
+
+	/* fill the last segment */
+	while (sges_left) {
+		if (sges_left == 1)
+			ioc->base_add_sg_single(sg_local, sgl_flags_end_buffer |
+			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+		else
+			ioc->base_add_sg_single(sg_local, sgl_flags |
+			    sg_dma_len(sg_scmd), sg_dma_address(sg_scmd));
+		sg_scmd = sg_next(sg_scmd);
+		sg_local += ioc->sge_size;
+		sges_left--;
+	}
+
+	return 0;
+}
+
+/**
  * _base_build_sg_scmd_ieee - main sg creation routine for IEEE format
  * @ioc: per adapter object
  * @scmd: scsi command
@@ -2850,8 +2993,12 @@ _base_allocate_memory_pools(struct MPT3SAS_ADAPTER *ioc,  int sleep_flag)
 	/* command line tunables for max sgl entries */
 	if (max_sgl_entries != -1)
 		sg_tablesize = max_sgl_entries;
-	else
-		sg_tablesize = MPT3SAS_SG_DEPTH;
+	else {
+		if (ioc->hba_mpi_version_belonged == MPI2_VERSION)
+			sg_tablesize = MPT2SAS_SG_DEPTH;
+		else
+			sg_tablesize = MPT3SAS_SG_DEPTH;
+	}
 
 	if (sg_tablesize < MPT_MIN_PHYS_SEGMENTS)
 		sg_tablesize = MPT_MIN_PHYS_SEGMENTS;
@@ -4878,17 +5025,25 @@ mpt3sas_base_attach(struct MPT3SAS_ADAPTER *ioc)
 	if (r)
 		goto out_free_resources;
 
-	/*
-	 * In SAS3.0,
-	 * SCSI_IO, SMP_PASSTHRU, SATA_PASSTHRU, Target Assist, and
-	 * Target Status - all require the IEEE formated scatter gather
-	 * elements.
-	 */
-
-	ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
-	ioc->build_sg = &_base_build_sg_ieee;
-	ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
-	ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
+	switch (ioc->hba_mpi_version_belonged) {
+	case MPI2_VERSION:
+		ioc->build_sg_scmd = &_base_build_sg_scmd;
+		ioc->build_sg = &_base_build_sg;
+		ioc->build_zero_len_sge = &_base_build_zero_len_sge;
+		break;
+	case MPI25_VERSION:
+		/*
+		 * In SAS3.0,
+		 * SCSI_IO, SMP_PASSTHRU, SATA_PASSTHRU, Target Assist, and
+		 * Target Status - all require the IEEE formated scatter gather
+		 * elements.
+		 */
+		ioc->build_sg_scmd = &_base_build_sg_scmd_ieee;
+		ioc->build_sg = &_base_build_sg_ieee;
+		ioc->build_zero_len_sge = &_base_build_zero_len_sge_ieee;
+		ioc->sge_size_ieee = sizeof(Mpi2IeeeSgeSimple64_t);
+		break;
+	}
 
 	/*
 	 * These function pointers for other requests that don't
-- 
2.0.2
