From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Fri, 27 Jul 2007 09:43:45 +0900
Message-ID: <20070726043933K.tomof@acm.org>
References: <20070726020657P.tomof@acm.org>
	<664A4EBB07F29743873A87CF62C26D708B3B83@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:59585 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753949AbXG0AoB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 20:44:01 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3B83@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Thu, 26 Jul 2007 16:05:32 -0600

> On Thursday, July 26, 2007 11:09 AM, FUJITA Tomonori wrote:
> > For smp request/response, we use:
> > 
> > request -> not used
> > response -> not used
> > dout_xferp -> pointer to a smp request frame
> > din_xferp -> pointer to a smp response frame
> > 
> > 
> > So we could use response field to send vendor's unique response to
> > user space.
> > 
> > bsg wrongly assues the response field is used for sense buffer so the
> > maxium length is SCSI_SENSE_BUFFERSIZE, 96 bytes. I think that it's a
> > bit small for mpt's unique response. But, I'll fix the length
> > limitation bug soon.
> 
> Well that's cool.   It would be better the application had a description
> of failures, rather than returning a vague ENXIO. Looks like 7 bytes
> covers ioc_status(2 bytes), log_info (4 bytes), and sas_status(1 byte),
> or better yet, lets return the entire mf reply, which looks to be 28
> bytes. It doesn't matter.   However, I'm not sure how to copy smprep
> into sg_io_v4->response..I noticed that request frame is obtained from
> rsp->bio, and the reply frame is returned via rsp->bio.  Any
> suggestions?

Does this work for you? Sorry, I'm not at the lab now and can't test
it. But I can do next week.

I also updated bsg's smp_rep_manufacturer to print the mpi's
replay. You can get it from the git tree.


diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d506646..2533dad 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1328,11 +1328,138 @@ mptsas_get_bay_identifier(struct sas_rphy *rphy)
 	return rc;
 }
 
+static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			      struct request *req)
+{
+	MPT_ADAPTER *ioc = ((MPT_SCSI_HOST *) shost->hostdata)->ioc;
+	MPT_FRAME_HDR *mf;
+	SmpPassthroughRequest_t *smpreq;
+	struct request *rsp = req->next_rq;
+	int ret;
+	int flagsLength;
+	unsigned long timeleft;
+	char *psge;
+	dma_addr_t dma_addr_in = 0;
+	dma_addr_t dma_addr_out = 0;
+	u64 sas_address = 0;
+
+	if (!rsp) {
+		printk(KERN_ERR "%s: the smp response space is missing\n",
+		       __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* do we need to support multiple segments? */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk(KERN_ERR "%s: multiple segments req %u %u, rsp %u %u\n",
+		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       rsp->bio->bi_vcnt, rsp->data_len);
+		return -EINVAL;
+	}
+
+	ret = mutex_lock_interruptible(&ioc->sas_mgmt.mutex);
+	if (ret)
+		goto out;
+
+	mf = mpt_get_msg_frame(mptsasMgmtCtx, ioc);
+	if (!mf) {
+		ret = -ENOMEM;
+		goto out_unlock;
+	}
+
+	smpreq = (SmpPassthroughRequest_t *)mf;
+	memset(smpreq, 0, sizeof(*smpreq));
+
+	smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);
+	smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
+
+	if (rphy)
+		sas_address = rphy->identify.sas_address;
+	else {
+		struct mptsas_portinfo *port_info;
+
+		mutex_lock(&ioc->sas_topology_mutex);
+		port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
+		if (port_info && port_info->phy_info)
+			sas_address =
+				port_info->phy_info[0].phy->identify.sas_address;
+		mutex_unlock(&ioc->sas_topology_mutex);
+	}
+
+	*((u64 *)&smpreq->SASAddress) = cpu_to_le64(sas_address);
+
+	psge = (char *)
+		(((int *) mf) + (offsetof(SmpPassthroughRequest_t, SGL) / 4));
+
+	/* request */
+	flagsLength = (MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+		       MPI_SGE_FLAGS_END_OF_BUFFER |
+		       MPI_SGE_FLAGS_DIRECTION |
+		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
+	flagsLength |= (req->data_len - 4);
+
+	dma_addr_out = pci_map_single(ioc->pcidev, bio_data(req->bio),
+				      req->data_len, PCI_DMA_BIDIRECTIONAL);
+	if (!dma_addr_out)
+		goto put_mf;
+	mpt_add_sge(psge, flagsLength, dma_addr_out);
+	psge += (sizeof(u32) + sizeof(dma_addr_t));
+
+	/* response */
+	flagsLength = MPT_SGE_FLAGS_SSIMPLE_READ;
+	flagsLength |= rsp->data_len + 4;
+	dma_addr_in =  pci_map_single(ioc->pcidev, bio_data(rsp->bio),
+				      rsp->data_len, PCI_DMA_BIDIRECTIONAL);
+	if (!dma_addr_in)
+		goto unmap;
+	mpt_add_sge(psge, flagsLength, dma_addr_in);
+
+	mpt_put_msg_frame(mptsasMgmtCtx, ioc, mf);
+
+	timeleft = wait_for_completion_timeout(&ioc->sas_mgmt.done, 10 * HZ);
+	if (!timeleft) {
+		printk(KERN_ERR "%s: smp timeout!\n", __FUNCTION__);
+		/* On timeout reset the board */
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		ret = -ETIMEDOUT;
+		goto unmap;
+	}
+	mf = NULL;
+
+	if (ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID) {
+		SmpPassthroughReply_t *smprep;
+
+		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
+		memcpy(req->sense, smprep, sizeof(*smprep));
+		req->sense_len = sizeof(*smprep);
+	}
+
+	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_COMMAND_GOOD)) {
+		printk(KERN_ERR "%s: smp response invalid!\n", __FUNCTION__);
+		ret = -ENXIO;
+	}
+unmap:
+	if (dma_addr_out)
+		pci_unmap_single(ioc->pcidev, dma_addr_out, req->data_len,
+				 PCI_DMA_BIDIRECTIONAL);
+	if (dma_addr_in)
+		pci_unmap_single(ioc->pcidev, dma_addr_in, rsp->data_len,
+				 PCI_DMA_BIDIRECTIONAL);
+put_mf:
+	if (mf)
+		mpt_free_msg_frame(ioc, mf);
+out_unlock:
+	mutex_unlock(&ioc->sas_mgmt.mutex);
+out:
+	return ret;
+}
+
 static struct sas_function_template mptsas_transport_functions = {
 	.get_linkerrors		= mptsas_get_linkerrors,
 	.get_enclosure_identifier = mptsas_get_enclosure_identifier,
 	.get_bay_identifier	= mptsas_get_bay_identifier,
 	.phy_reset		= mptsas_phy_reset,
+	.smp_handler		= mptsas_smp_handler,
 };
 
 static struct scsi_transport_template *mptsas_transport_template;
