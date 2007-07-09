From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Mon, 09 Jul 2007 12:52:11 +0900
Message-ID: <20070709125211U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:60500 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758631AbXGIDwo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Jul 2007 23:52:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, Eric.Moore@lsi.com, jens.axboe@oracle.com

This patch adds support for SAS Management Protocol (SMP) passthrough
support via bsg.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/message/fusion/mptsas.c |  121 +++++++++++++++++++++++++++++++++++++++
 1 files changed, 121 insertions(+), 0 deletions(-)

diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index 1d2d03f..e5645ad 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1327,11 +1327,132 @@ mptsas_get_bay_identifier(struct sas_rphy *rphy)
 	return rc;
 }
 
+static int mptsas_smp_handler(struct Scsi_Host *shost, struct sas_rphy *rphy,
+			      struct request *req)
+{
+	MPT_ADAPTER *ioc = ((MPT_SCSI_HOST *) shost->hostdata)->ioc;
+	MPT_FRAME_HDR *mf;
+	SmpPassthroughRequest_t *smpreq;
+	SmpPassthroughReply_t *smprep;
+	struct request *rsp = req->next_rq;
+	int ret, flagsLength;
+	unsigned long timeleft;
+	char *psge;
+	dma_addr_t dma_addr_in, dma_addr_out;
+
+	if (!rsp) {
+		printk("%s: the smp response space is missing\n", __FUNCTION__);
+		return -EINVAL;
+	}
+
+	/* do we need to support multiple segments? */
+	if (req->bio->bi_vcnt > 1 || rsp->bio->bi_vcnt > 1) {
+		printk("%s: multiple segments req %u %u, rsp %u %u\n",
+		       __FUNCTION__, req->bio->bi_vcnt, req->data_len,
+		       rsp->bio->bi_vcnt, rsp->data_len);
+		return -EINVAL;
+	}
+
+	/* can we use this? */
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
+        smpreq->RequestDataLength = req->data_len - 4;
+        smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
+
+	if (rphy)
+		memcpy(&smpreq->SASAddress, &rphy->identify.sas_address,
+		       sizeof(smpreq->SASAddress));
+	else {
+		struct mptsas_portinfo *port_info;
+
+		mutex_lock(&ioc->sas_topology_mutex);
+		port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
+		if (port_info && port_info->phy_info)
+			memcpy(&smpreq->SASAddress,
+			       &(port_info->phy_info[0].phy->identify.sas_address),
+			       sizeof(smpreq->SASAddress));
+		mutex_unlock(&ioc->sas_topology_mutex);
+	}
+
+	dma_addr_in = dma_addr_out = 0;
+
+	psge = (char *)(((int *) mf) + (offsetof(SmpPassthroughRequest_t, SGL) / 4));
+
+	/* request */
+	flagsLength = (MPI_SGE_FLAGS_SIMPLE_ELEMENT |
+		       MPI_SGE_FLAGS_END_OF_BUFFER |
+		       MPI_SGE_FLAGS_DIRECTION |
+		       mpt_addr_size()) << MPI_SGE_FLAGS_SHIFT;
+	flagsLength |= (rsp->data_len - 4);
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
+		printk("%s: smp timeout!\n", __FUNCTION__);
+		/* On timeout reset the board */
+		mpt_HardResetHandler(ioc, CAN_SLEEP);
+		ret = -ETIMEDOUT;
+		goto unmap;
+	}
+	mf = NULL;
+
+	/* a reply frame is expected */
+	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID)) {
+		printk("%s: the smp response invalid!\n", __FUNCTION__);
+		ret = -ENXIO;
+	}
+
+	smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
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
1.4.4.4

