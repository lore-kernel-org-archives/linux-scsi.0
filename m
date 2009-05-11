From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 08/11] block: cleanup rq->data_len usages
Date: Mon, 11 May 2009 15:02:13 +0300
Message-ID: <4A0813C5.2080403@panasas.com>
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-9-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1241423927-11871-9-git-send-email-tj@kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org, linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com, sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com, stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp, zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com, sfr@canb.auug.org.au, grant.likely@secretlab.ca, paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com, adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org, schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net, rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com, "Darrick J. Wong" <djwong@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On 05/04/2009 10:58 AM, Tejun Heo wrote:
> With recent unification of fields, it's now guaranteed that
> rq->data_len always equals blk_rq_bytes().  Convert all non-IDE direct
> users to accessors.  IDE will be converted in a separate patch.
> 
> Boaz: spotted incorrect data_len/resid_len conversion in osd.
> 
> [ Impact: convert direct rq->data_len usages to blk_rq_bytes() ]
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Cc: Pete Zaitcev <zaitcev@redhat.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Markus Lidel <Markus.Lidel@shadowconnect.com>
> Cc: Darrick J. Wong <djwong@us.ibm.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Eric Moore <Eric.Moore@lsi.com>
> Cc: Boaz Harrosh <bharrosh@panasas.com>
> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
> ---
>  drivers/ata/libata-scsi.c                |    2 +-
>  drivers/block/ub.c                       |    8 ++++----
>  drivers/message/fusion/mptsas.c          |   20 ++++++++++----------
>  drivers/message/i2o/i2o_block.c          |    2 +-
>  drivers/scsi/libsas/sas_expander.c       |    8 ++++----
>  drivers/scsi/libsas/sas_host_smp.c       |   18 +++++++++---------
>  drivers/scsi/mpt2sas/mpt2sas_transport.c |   21 +++++++++++----------
>  drivers/scsi/osd/osd_initiator.c         |    4 ++--
>  drivers/scsi/scsi_lib.c                  |   13 ++++++-------
>  drivers/scsi/scsi_tgt_lib.c              |    2 +-
>  10 files changed, 49 insertions(+), 49 deletions(-)
> 
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2733b0c..6e4c600 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1084,7 +1084,7 @@ static int atapi_drain_needed(struct request *rq)
>  	if (likely(!blk_pc_request(rq)))
>  		return 0;
>  
> -	if (!rq->data_len || (rq->cmd_flags & REQ_RW))
> +	if (!blk_rq_bytes(rq) || (rq->cmd_flags & REQ_RW))
>  		return 0;
>  
>  	return atapi_cmd_type(rq->cmd[0]) == ATAPI_MISC;
> diff --git a/drivers/block/ub.c b/drivers/block/ub.c
> index dc3b899..1591f61 100644
> --- a/drivers/block/ub.c
> +++ b/drivers/block/ub.c
> @@ -747,7 +747,7 @@ static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
>  {
>  	struct request *rq = urq->rq;
>  
> -	if (rq->data_len == 0) {
> +	if (blk_rq_bytes(rq) == 0) {
>  		cmd->dir = UB_DIR_NONE;
>  	} else {
>  		if (rq_data_dir(rq) == WRITE)
> @@ -762,7 +762,7 @@ static void ub_cmd_build_packet(struct ub_dev *sc, struct ub_lun *lun,
>  	memcpy(&cmd->cdb, rq->cmd, rq->cmd_len);
>  	cmd->cdb_len = rq->cmd_len;
>  
> -	cmd->len = rq->data_len;
> +	cmd->len = blk_rq_bytes(rq);
>  
>  	/*
>  	 * To reapply this to every URB is not as incorrect as it looks.
> @@ -783,8 +783,8 @@ static void ub_rw_cmd_done(struct ub_dev *sc, struct ub_scsi_cmd *cmd)
>  
>  	if (cmd->error == 0) {
>  		if (blk_pc_request(rq)) {
> -			if (cmd->act_len < rq->data_len)
> -				rq->resid_len = rq->data_len - cmd->act_len;
> +			if (cmd->act_len < blk_rq_bytes(rq))
> +				rq->resid_len = blk_rq_bytes(rq) - cmd->act_len;
>  			scsi_status = 0;
>  		} else {
>  			if (cmd->act_len != cmd->len) {
> diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
> index 5d5f347..4e6fcf0 100644
> --- a/drivers/message/fusion/mptsas.c
> +++ b/drivers/message/fusion/mptsas.c
> @@ -1277,8 +1277,8 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	/* do we need to support multiple segments? */
>  	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
>  		printk(MYIOC_s_ERR_FMT "%s: multiple segments req %u %u, rsp %u %u\n",
> -		    ioc->name, __func__, req->bio->bi_vcnt, req->data_len,
> -		    rsp->bio->bi_vcnt, rsp->data_len);
> +		    ioc->name, __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
> +		    rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
>  		return -EINVAL;
>  	}
>  
> @@ -1295,7 +1295,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	smpreq = (SmpPassthroughRequest_t *)mf;
>  	memset(smpreq, 0, sizeof(*smpreq));
>  
> -	smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);
> +	smpreq->RequestDataLength = cpu_to_le16(blk_rq_bytes(req) - 4);
>  	smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
>  
>  	if (rphy)
> @@ -1321,10 +1321,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  		       MPI_SGE_FLAGS_END_OF_BUFFER |
>  		       MPI_SGE_FLAGS_DIRECTION |
>  		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
> -	flagsLength |= (req->data_len - 4);
> +	flagsLength |= (blk_rq_bytes(req) - 4);
>  
>  	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
> -				      req->data_len, PCI_DMA_BIDIRECTIONAL);
> +				      blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
>  	if (!dma_addr_out)
>  		goto put_mf;
>  	mpt_add_sge(psge, flagsLength, dma_addr_out);
> @@ -1332,9 +1332,9 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  
>  	/* response */
>  	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
> -	flagsLength |= rsp->data_len + 4;
> +	flagsLength |= blk_rq_bytes(rsp) + 4;
>  	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
> -				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
> +				      blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
>  	if (!dma_addr_in)
>  		goto unmap;
>  	mpt_add_sge(psge, flagsLength, dma_addr_in);
> @@ -1357,7 +1357,7 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
>  		memcpy(req->sense, smprep, sizeof(*smprep));
>  		req->sense_len = sizeof(*smprep);
> -		rsp->resid_len = rsp->data_len - smprep->ResponseDataLength;
> +		rsp->resid_len = blk_rq_bytes(rsp) - smprep->ResponseDataLength;
>  	} else {
>  		printk(MYIOC_s_ERR_FMT "%s: smp passthru reply failed to be returned\n",
>  		    ioc->name, __func__);
> @@ -1365,10 +1365,10 @@ static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	}
>  unmap:
>  	if (dma_addr_out)
> -		pci_unmap_single(ioc->pcidev, dma_addr_out, req->data_len,
> +		pci_unmap_single(ioc->pcidev, dma_addr_out, blk_rq_bytes(req),
>  				 PCI_DMA_BIDIRECTIONAL);
>  	if (dma_addr_in)
> -		pci_unmap_single(ioc->pcidev, dma_addr_in, rsp->data_len,
> +		pci_unmap_single(ioc->pcidev, dma_addr_in, blk_rq_bytes(rsp),
>  				 PCI_DMA_BIDIRECTIONAL);
>  put_mf:
>  	if (mf)
> diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
> index 510eb47..6b61d28 100644
> --- a/drivers/message/i2o/i2o_block.c
> +++ b/drivers/message/i2o/i2o_block.c
> @@ -430,7 +430,7 @@ static void i2o_block_end_request(struct request *req, int error,
>  		int leftover = (blk_rq_sectors(req) << KERNEL_SECTOR_SHIFT);
>  
>  		if (blk_pc_request(req))
> -			leftover = req->data_len;
> +			leftover = blk_rq_bytes(req);
>  
>  		if (error)
>  			blk_end_request(req, -EIO, leftover);

Note:
  This can be blk_end_request_all() and "int leftover =" dropped.

> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 6605ec9..531af9e 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1927,13 +1927,13 @@ int sas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	/* do we need to support multiple segments? */
>  	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
>  		printk("%s: multiple segments req %u %u, rsp %u %u\n",
> -		       __func__, req->bio->bi_vcnt, req->data_len,
> -		       rsp->bio->bi_vcnt, rsp->data_len);
> +		       __func__, req->bio->bi_vcnt, blk_rq_bytes(req),
> +		       rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
>  		return -EINVAL;
>  	}
>  
> -	ret = smp_execute_task(dev, bio_data(req->bio), req->data_len,
> -			       bio_data(rsp->bio), rsp->data_len);
> +	ret = smp_execute_task(dev, bio_data(req->bio), blk_rq_bytes(req),
> +			       bio_data(rsp->bio), blk_rq_bytes(rsp));
>  	if (ret > 0) {
>  		/* positive number is the untransferred residual */
>  		rsp->resid_len = ret;
> diff --git a/drivers/scsi/libsas/sas_host_smp.c b/drivers/scsi/libsas/sas_host_smp.c
> index 89952ed..be9a951 100644
> --- a/drivers/scsi/libsas/sas_host_smp.c
> +++ b/drivers/scsi/libsas/sas_host_smp.c
> @@ -137,21 +137,21 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  	int error = -EINVAL;
>  
>  	/* eight is the minimum size for request and response frames */
> -	if (req->data_len < 8 || rsp->data_len < 8)
> +	if (blk_rq_bytes(req) < 8 || blk_rq_bytes(rsp) < 8)
>  		goto out;
>  
> -	if (bio_offset(req->bio) + req->data_len > PAGE_SIZE ||
> -	    bio_offset(rsp->bio) + rsp->data_len > PAGE_SIZE) {
> +	if (bio_offset(req->bio) + blk_rq_bytes(req) > PAGE_SIZE ||
> +	    bio_offset(rsp->bio) + blk_rq_bytes(rsp) > PAGE_SIZE) {
>  		shost_printk(KERN_ERR, shost,
>  			"SMP request/response frame crosses page boundary");
>  		goto out;
>  	}
>  
> -	req_data = kzalloc(req->data_len, GFP_KERNEL);
> +	req_data = kzalloc(blk_rq_bytes(req), GFP_KERNEL);
>  
>  	/* make sure frame can always be built ... we copy
>  	 * back only the requested length */
> -	resp_data = kzalloc(max(rsp->data_len, 128U), GFP_KERNEL);
> +	resp_data = kzalloc(max(blk_rq_bytes(rsp), 128U), GFP_KERNEL);
>  
>  	if (!req_data || !resp_data) {
>  		error = -ENOMEM;
> @@ -160,7 +160,7 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  
>  	local_irq_disable();
>  	buf = kmap_atomic(bio_page(req->bio), KM_USER0) + bio_offset(req->bio);
> -	memcpy(req_data, buf, req->data_len);
> +	memcpy(req_data, buf, blk_rq_bytes(req));
>  	kunmap_atomic(buf - bio_offset(req->bio), KM_USER0);
>  	local_irq_enable();
>  
> @@ -176,8 +176,8 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  	resp_data[1] = req_data[1];
>  	resp_data[2] = SMP_RESP_FUNC_UNK;
>  
> -	req->resid_len = req->data_len;
> -	rsp->resid_len = rsp->data_len;
> +	req->resid_len = blk_rq_bytes(req);
> +	rsp->resid_len = blk_rq_bytes(rsp);
>  
>  	switch (req_data[1]) {
>  	case SMP_REPORT_GENERAL:
> @@ -264,7 +264,7 @@ int sas_smp_host_handler(struct Scsi_Host *shost, struct request *req,
>  
>  	local_irq_disable();
>  	buf = kmap_atomic(bio_page(rsp->bio), KM_USER0) + bio_offset(rsp->bio);
> -	memcpy(buf, resp_data, rsp->data_len);
> +	memcpy(buf, resp_data, blk_rq_bytes(rsp));
>  	flush_kernel_dcache_page(bio_page(rsp->bio));
>  	kunmap_atomic(buf - bio_offset(rsp->bio), KM_USER0);
>  	local_irq_enable();
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> index 53759c5..af95a44 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
> @@ -1041,7 +1041,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
>  		printk(MPT2SAS_ERR_FMT "%s: multiple segments req %u %u, "
>  		    "rsp %u %u\n", ioc->name, __func__, req->bio->bi_vcnt,
> -		    req->data_len, rsp->bio->bi_vcnt, rsp->data_len);
> +		    blk_rq_bytes(req), rsp->bio->bi_vcnt, blk_rq_bytes(rsp));
>  		return -EINVAL;
>  	}
>  
> @@ -1104,7 +1104,7 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	*((u64 *)&mpi_request->SASAddress) = (rphy) ?
>  	    cpu_to_le64(rphy->identify.sas_address) :
>  	    cpu_to_le64(ioc->sas_hba.sas_address);
> -	mpi_request->RequestDataLength = cpu_to_le16(req->data_len - 4);
> +	mpi_request->RequestDataLength = cpu_to_le16(blk_rq_bytes(req) - 4);
>  	psge = &mpi_request->SGL;
>  
>  	/* WRITE sgel first */
> @@ -1112,13 +1112,13 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	    MPI2_SGE_FLAGS_END_OF_BUFFER | MPI2_SGE_FLAGS_HOST_TO_IOC);
>  	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
>  	dma_addr_out = pci_map_single(ioc->pdev, bio_data(req->bio),
> -	      req->data_len, PCI_DMA_BIDIRECTIONAL);
> +		blk_rq_bytes(req), PCI_DMA_BIDIRECTIONAL);
>  	if (!dma_addr_out) {
>  		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
>  		goto unmap;
>  	}
>  
> -	ioc->base_add_sg_single(psge, sgl_flags | (req->data_len - 4),
> +	ioc->base_add_sg_single(psge, sgl_flags | (blk_rq_bytes(req) - 4),
>  	    dma_addr_out);
>  
>  	/* incr sgel */
> @@ -1129,14 +1129,14 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  	    MPI2_SGE_FLAGS_LAST_ELEMENT | MPI2_SGE_FLAGS_END_OF_BUFFER |
>  	    MPI2_SGE_FLAGS_END_OF_LIST);
>  	sgl_flags = sgl_flags << MPI2_SGE_FLAGS_SHIFT;
> -	dma_addr_in =  pci_map_single(ioc->pdev, bio_data(rsp->bio),
> -	      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
> +	dma_addr_in = pci_map_single(ioc->pdev, bio_data(rsp->bio),
> +				     blk_rq_bytes(rsp), PCI_DMA_BIDIRECTIONAL);
>  	if (!dma_addr_in) {
>  		mpt2sas_base_free_smid(ioc, le16_to_cpu(smid));
>  		goto unmap;
>  	}
>  
> -	ioc->base_add_sg_single(psge, sgl_flags | (rsp->data_len + 4),
> +	ioc->base_add_sg_single(psge, sgl_flags | (blk_rq_bytes(rsp) + 4),
>  	    dma_addr_in);
>  
>  	dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT "%s - "
> @@ -1170,7 +1170,8 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  
>  		memcpy(req->sense, mpi_reply, sizeof(*mpi_reply));
>  		req->sense_len = sizeof(*mpi_reply);
> -		rsp->resid_len = rsp->data_len - mpi_reply->ResponseDataLength;
> +		rsp->resid_len = blk_rq_bytes(rsp) -
> +				 mpi_reply->ResponseDataLength;
>  	} else {
>  		dtransportprintk(ioc, printk(MPT2SAS_DEBUG_FMT
>  		    "%s - no reply\n", ioc->name, __func__));
> @@ -1186,10 +1187,10 @@ transport_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
>  
>   unmap:
>  	if (dma_addr_out)
> -		pci_unmap_single(ioc->pdev, dma_addr_out, req->data_len,
> +		pci_unmap_single(ioc->pdev, dma_addr_out, blk_rq_bytes(req),
>  		    PCI_DMA_BIDIRECTIONAL);
>  	if (dma_addr_in)
> -		pci_unmap_single(ioc->pdev, dma_addr_in, rsp->data_len,
> +		pci_unmap_single(ioc->pdev, dma_addr_in, blk_rq_bytes(rsp),
>  		    PCI_DMA_BIDIRECTIONAL);
>  
>   out:
> diff --git a/drivers/scsi/osd/osd_initiator.c b/drivers/scsi/osd/osd_initiator.c
> index 2a5f077..d178a8b 100644
> --- a/drivers/scsi/osd/osd_initiator.c
> +++ b/drivers/scsi/osd/osd_initiator.c
> @@ -1299,7 +1299,7 @@ int osd_finalize_request(struct osd_request *or,
>  			return ret;
>  		}
>  		OSD_DEBUG("out bytes=%llu (bytes_req=%u)\n",
> -			_LLU(or->out.total_bytes), or->out.req->data_len);
> +			_LLU(or->out.total_bytes), blk_rq_bytes(or->out.req));
>  	}
>  	if (or->in.bio) {
>  		ret = blk_rq_append_bio(or->request->q, or->in.req, or->in.bio);
> @@ -1308,7 +1308,7 @@ int osd_finalize_request(struct osd_request *or,
>  			return ret;
>  		}
>  		OSD_DEBUG("in bytes=%llu (bytes_req=%u)\n",
> -			_LLU(or->in.total_bytes), or->in.req->data_len);
> +			_LLU(or->in.total_bytes), blk_rq_bytes(or->in.req));
>  	}
>  
>  	or->out.pad_buff = sg_out_pad_buffer;

Ack-by: Boaz Harrosh <bharrosh@panasas.com>

Stupid prints. I'll Q a patch that removes them once this is accepted.
Thanks.

> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 39b3acf..3d16c70 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -682,14 +682,13 @@ EXPORT_SYMBOL(scsi_release_buffers);
>  static void scsi_end_bidi_request(struct scsi_cmnd *cmd)
>  {
>  	struct request *req = cmd->request;
> -	unsigned int dlen = req->data_len;
> -	unsigned int next_dlen = req->next_rq->data_len;
>  
>  	req->resid_len = scsi_out(cmd)->resid;
>  	req->next_rq->resid_len = scsi_in(cmd)->resid;
>  
>  	/* The req and req->next_rq have not been completed */
> -	BUG_ON(blk_end_bidi_request(req, 0, dlen, next_dlen));
> +	BUG_ON(blk_end_bidi_request(req, 0, blk_rq_bytes(req),
> +				    blk_rq_bytes(req->next_rq)));
>  
>  	scsi_release_buffers(cmd);
>  
> @@ -966,7 +965,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>  	BUG_ON(count > sdb->table.nents);
>  	sdb->table.nents = count;
>  	if (blk_pc_request(req))
> -		sdb->length = req->data_len;
> +		sdb->length = blk_rq_bytes(req);
>  	else
>  		sdb->length = blk_rq_sectors(req) << 9;
>  	return BLKPREP_OK;
> @@ -1087,21 +1086,21 @@ int scsi_setup_blk_pc_cmnd(struct scsi_device *sdev, struct request *req)
>  		if (unlikely(ret))
>  			return ret;
>  	} else {
> -		BUG_ON(req->data_len);
> +		BUG_ON(blk_rq_bytes(req));
>  
>  		memset(&cmd->sdb, 0, sizeof(cmd->sdb));
>  		req->buffer = NULL;
>  	}
>  
>  	cmd->cmd_len = req->cmd_len;
> -	if (!req->data_len)
> +	if (!blk_rq_bytes(req))
>  		cmd->sc_data_direction = DMA_NONE;
>  	else if (rq_data_dir(req) == WRITE)
>  		cmd->sc_data_direction = DMA_TO_DEVICE;
>  	else
>  		cmd->sc_data_direction = DMA_FROM_DEVICE;
>  	
> -	cmd->transfersize = req->data_len;
> +	cmd->transfersize = blk_rq_bytes(req);
>  	cmd->allowed = req->retries;
>  	return BLKPREP_OK;
>  }

Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>

> diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
> index 48ba413..1030327 100644
> --- a/drivers/scsi/scsi_tgt_lib.c
> +++ b/drivers/scsi/scsi_tgt_lib.c
> @@ -387,7 +387,7 @@ static int scsi_map_user_pages(struct scsi_tgt_cmd *tcmd, struct scsi_cmnd *cmd,
>  	 * we use REQ_TYPE_BLOCK_PC so scsi_init_io doesn't set the
>  	 * length for us.
>  	 */
> -	cmd->sdb.length = rq->data_len;
> +	cmd->sdb.length = blk_rq_bytes(rq);

Note to self:
  This code and the comment is wrong scsi_init_io does set everything right. It should be dropped.
  Once everything settles, I'll send a patch to remove this.

>  
>  	return 0;
>  

I've reviewed all the scsi parts.

(We had a 24 hours internet  outage so these replys where delayed)

Thanks
Boaz
