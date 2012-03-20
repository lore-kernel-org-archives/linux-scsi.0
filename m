From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 03/12] [SCSI] mpt2sas : Added multisegment mode support
 for Linux BSG Driver
Date: Tue, 20 Mar 2012 12:04:43 +0530
Message-ID: <201203200634.q2K6YCw2031957@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:41593 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754706Ab2CTGeS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:34:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

Added multisegment mode support for Linux BSG Driver
    
Added support for Block IO requests with multiple segments (vectors) in
the SMP handler of the SAS Transport Class. This is required by the
BSG driver. Multisegment support added for both, Request and Response.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index d0750eb..17763ca 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1830,7 +1830,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	struct MPT2SAS_ADAPTER *ioc = shost_priv(shost);
 	Mpi2SmpPassthroughRequest_t *mpi_request;
 	Mpi2SmpPassthroughReply_t *mpi_reply;
-	int rc;
+	int rc, i;
 	u16 smid;
 	u32 ioc_state;
 	unsigned long timeleft;
@@ -1839,24 +1839,20 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	u8 issue_reset = 0;
 	dma_addr_t dma_addr_in = 0;
 	dma_addr_t dma_addr_out = 0;
+	dma_addr_t pci_dma_in = 0;
+	dma_addr_t pci_dma_out = 0;
+	void *pci_addr_in = NULL;
+	void *pci_addr_out = NULL;
 	u16 wait_state_count;
 	struct request *rsp = req->next_rq;
+	struct bio_vec *bvec = NULL;
 
 	if (!rsp) {
 		printk(MPT2SAS_ERR_FMT "%s: the smp response space is "
 		    "missing\n", ioc->name, __func__);
 		return -EINVAL;
 	}
-
-	/* do we need to support multiple segments? */
-	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
-		printk(MPT2SAS_ERR_FMT "%s: multiple segments req %u %u, "
-		    "rsp %u %u\n", ioc->name, __func__, req->bio->bi_vcnt,
-		    blk_rq_bytes(req), rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
-		return -EINVAL;
-	}
-
-	if (ioc->shost_recovery) {
+	if (ioc->shost_recovery || ioc->pci_error_recovery) {
 		printk(MPT2SAS_INFO_FMT "%s: host reset in progress!\n",
 		    __func__, ioc->name);
 		return -EFAULT;
@@ -1874,6 +1870,59 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	}
 	ioc->transport_cmds.status = MPT2_CMD_PENDING;
 
+	/* Check if the request is split across multiple segments */
+	if (req->bio->bi_vcnt > 1) {
+		u32 offset = 0;
+
+		/* Allocate memory and copy the request */
+		pci_addr_out = pci_alloc_consistent(ioc->pdev,
+		    blk_rq_bytes(req), &pci_dma_out);
+		if (!pci_addr_out) {
+			printk(MPT2SAS_INFO_FMT "%s(): PCI Addr out = NULL\n",
+			    ioc->name, __func__);
+			rc = -ENOMEM;
+			goto out;
+		}
+
+		bio_for_each_segment(bvec, req->bio, i) {
+			memcpy(pci_addr_out + offset,
+			    page_address(bvec->bv_page) + bvec->bv_offset,
+			    bvec->bv_len);
+			offset += bvec->bv_len;
+		}
+	} else {
+		dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
+		    blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
+		if (!dma_addr_out) {
+			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr out = NULL\n",
+			    ioc->name, __func__);
+			rc = -ENOMEM;
+			goto free_pci;
+		}
+	}
+
+	/* Check if the response needs to be populated across
+	 * multiple segments */
+	if (rsp->bio->bi_vcnt > 1) {
+		pci_addr_in = pci_alloc_consistent(ioc->pdev, blk_rq_bytes(rsp),
+		    &pci_dma_in);
+		if (!pci_addr_in) {
+			printk(MPT2SAS_INFO_FMT "%s(): PCI Addr in = NULL\n",
+			    ioc->name, __func__);
+			rc = -ENOMEM;
+			goto unmap;
+		}
+	} else {
+		dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
+		    blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
+		if (!dma_addr_in) {
+			printk(MPT2SAS_INFO_FMT "%s(): DMA Addr in = NULL\n",
+			    ioc->name, __func__);
+			rc = -ENOMEM;
+			goto unmap;
+		}
+	}
+
 	wait_state_count = 0;
 	ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
 	while (ioc_state != MPI2_IOC_STATE_OPERATIONAL) {
@@ -1882,7 +1931,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 			    "%s: failed due to ioc not operational\n",
 			    ioc->name, __func__);
 			rc = -EFAULT;
-			goto out;
+			goto unmap;
 		}
 		ssleep(1);
 		ioc_state = mpt2sas_base_get_iocstate(ioc, 1);
@@ -1899,7 +1948,7 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		printk(MPT2SAS_ERR_FMT "%s: failed obtaining a smid\n",
 		    ioc->name, __func__);
 		rc = -EAGAIN;
-		goto out;
+		goto unmap;
 	}
 
 	rc = 0;
@@ -1921,16 +1970,14 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	sgl_flags = (MPI2_SGE_FLAGS_SIMPLE_ELEMENT |
 	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
-		blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_out) {
-		mpt2sas_base_free_smid(ioc, smid);
-		goto unmap;
+	if (req->bio->bi_vcnt > 1) {
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    (blk_rq_bytes(req) - 4), pci_dma_out);
+	} else {
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    (blk_rq_bytes(req) - 4), dma_addr_out);
 	}
 
-	ioc->base_add_sg_single(psge, sgl_flags | (blk_rq_bytes(req) - 4),
-	    dma_addr_out);
-
 	/* incr sgel */
 	psge += ioc->sge_size;
 
@@ -1939,16 +1986,14 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
 	    MPI2_SGE_FLAGS_END_OF_LIST);
 	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
-	dma_addr_in = pci_map_single(ioc->pdev, bio_data(rsp->bio),
-				     blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
-	if (!dma_addr_in) {
-		mpt2sas_base_free_smid(ioc, smid);
-		goto unmap;
+	if (rsp->bio->bi_vcnt > 1) {
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    (blk_rq_bytes(rsp) + 4), pci_dma_in);
+	} else {
+		ioc->base_add_sg_single(psge, sgl_flags |
+		    (blk_rq_bytes(rsp) + 4), dma_addr_in);
 	}
 
-	ioc->base_add_sg_single(psge, sgl_flags | (blk_rq_bytes(rsp) + 4),
-	    dma_addr_in);
-
 	dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT "%s - "
 	    "sending smp request\n", ioc->name, __func__));
 
@@ -1984,6 +2029,27 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		req->resid_len = 0;
 		rsp->resid_len -=
 		    le16_to_cpu(mpi_reply->ResponseDataLength);
+		/* check if the resp needs to be copied from the allocated
+		 * pci mem */
+		if (rsp->bio->bi_vcnt > 1) {
+			u32 offset = 0;
+			u32 bytes_to_copy =
+			    le16_to_cpu(mpi_reply->ResponseDataLength);
+			bio_for_each_segment(bvec, rsp->bio, i) {
+				if (bytes_to_copy <= bvec->bv_len) {
+					memcpy(page_address(bvec->bv_page) +
+					    bvec->bv_offset, pci_addr_in +
+					    offset, bytes_to_copy);
+					break;
+				} else {
+					memcpy(page_address(bvec->bv_page) +
+					    bvec->bv_offset, pci_addr_in +
+					    offset, bvec->bv_len);
+					bytes_to_copy -= bvec->bv_len;
+				}
+				offset += bvec->bv_len;
+			}
+		}
 	} else {
 		dtransportprintk(ioc, printk(MPT2SAS_INFO_FMT
 		    "%s - no reply\n", ioc->name, __func__));
@@ -2005,6 +2071,15 @@ _transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
 		pci_unmap_single(ioc->pdev, dma_addr_in, blk_rq_bytes(rsp),
 		    PCI_DMA_BIDIRECTIONAL);
 
+ free_pci:
+	if (pci_addr_out)
+		pci_free_consistent(ioc->pdev, blk_rq_bytes(req), pci_addr_out,
+		    pci_dma_out);
+
+	if (pci_addr_in)
+		pci_free_consistent(ioc->pdev, blk_rq_bytes(rsp), pci_addr_in,
+		    pci_dma_in);
+
  out:
 	ioc->transport_cmds.status = MPT2_CMD_NOT_USED;
 	mutex_unlock(&ioc->transport_cmds.mutex);
