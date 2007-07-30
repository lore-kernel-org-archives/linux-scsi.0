From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 31 Jul 2007 08:36:06 +0900
Message-ID: <20070731083606E.fujita.tomonori@lab.ntt.co.jp>
References: <20070729163656J.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D708B3ED9@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:45482 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759422AbXG3XgY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jul 2007 19:36:24 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B3ED9@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, tomof@acm.org, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Mon, 30 Jul 2007 11:10:07 -0600

> On Sunday, July 29, 2007 1:37 AM, FUJITA Tomonori wrote:
> > > Eric, can I get your ACK on this patch?
> > 
> > One comment on the the patch:
> > 
> > +	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_COMMAND_GOOD)) {
> > +		printk(KERN_ERR "%s: smp response invalid!\n", 
> > __FUNCTION__);
> > +		ret = -ENXIO;
> > +	}
> > 
> > We don't need this part since user-space can get mpt's reply, I think.
> >
> 
> Correct, this should be removed. The processing of the mpt reply has
> been pushed to user-space.    On another note, according to the mpi
> specification, its says there should always be a reply message frame
> returned for every smp passthru.  So I thinking this would be the best
> way to close out the end of this function.  What do you think?
> 
> 
> +	if (ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID) {
> +		SmpPassthroughReply_t *smprep;
> +
> +		smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
> +		memcpy(req->sense, smprep, sizeof(*smprep));
> +		req->sense_len = sizeof(*smprep);
> +	} else
> +		printk(KERN_ERR "%s: smp passthru reply failed to be
> returned\n", __FUNCTION__);
> +		ret = -ENXIO;
> +	}

Looks good for me.

Here's an updated version. Can you add your signed-off or acked-by?

---
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] mptsas: add SAS management protocol handler

This patch adds support for SAS Management Protocol (SMP) passthrough
support via bsg.

Like libsas's smp support, user-space tools can send a smp request
frame via sg_io_v4's dout_xferp and get a smp response frame via
din_xferp. In addition, user-space tools can get the mpt reply via
sg_io_v4's response field too if necessary.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptsas.c |  126 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 126 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 29add83..b9c69bf 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1312,11 +1312,137 @@ mptsas_get_bay_identifier(struct sas_rphy *rphy)
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
+	} else {
+		printk(KERN_ERR "%s: smp passthru reply failed to be returned\n",
+		       __FUNCTION__);
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
-- 
1.5.2.4


