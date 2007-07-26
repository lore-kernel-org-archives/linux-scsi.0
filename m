From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Thu, 26 Jul 2007 19:09:13 +0900
Message-ID: <20070726190913A.fujita.tomonori@lab.ntt.co.jp>
References: <20070725094740H.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D708B399D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama55.ecl.ntt.co.jp ([129.60.39.103]:48177 "EHLO
	tama55.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760355AbXGZKO2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Jul 2007 06:14:28 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D708B399D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Wed, 25 Jul 2007 18:21:38 -0600

> > > > # ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/expander-0:1
> > > > 
> > > > 
> > > > I think that James tested this with aic94xx, however, I guess that
> > > > nobody has tested this with mptsas.
> > > > 
> > > 
> > > I got garbage (I'm using the 2.6.23-git11 patch from last 
> > week, before
> > > rc1):
> > > 
> > > # ./smp_rep_manufacturer /sys/class/bsg/expander-2:0
> > >   SAS-1.1 format: 1
> > >   vendor identification: _BUS_ADD
> > >   product identification: RESS=unix:abstra
> > >   product revision level: ct=/
> > >   component vendor identification: tmp/dbus
> > >   component id: 11609
> > >   component revision level: 69
> > > 
> > > With Doug Gilberts tools it works:
> > > 
> > > # smp_rep_manufacturer --sa=0x500605b0000016b0 /dev/mptctl
> > > Report manufacturer response:
> > >   SAS-1.1 format: 0
> > >   vendor identification: LSILOGIC
> > >   product identification: SASx12 A.0
> > >   product revision level:
> > > 
> > > 
> > > Also, unloading and reloading the driver resulted in two expander
> > > entryies in /sys/class/bsg.    The old entry was not deleted when I
> > > unloaded the driver.  When I tryied to run 
> > smp_rep_manufacture on the
> > > old expander instance, it panicked.
> 
> With a sas analyzer, I figured out today why the bsg version of
> smp_rep_manufacture is not working.    There is a bug in
> mptsas_smp_handler. The calculation of the first scatter gather element
> size for the outbound data is incorrect.   Its being set to the resonse
> data length, when instead it should be the request data legth.
> 
> This is incorrect:
> 
> +	flagsLength |= (rsp->data_len - 4);
> 
> It should be 
> 
> +	flagsLength |= (smpreq->RequestDataLength);

Sorry for the bug.

Do we need to use (req->data_len - 4)? As you said, we set
smpreq->RequestDataLength with cpu_to_le16.


> > But probably, the tool still don't work against an expander. Does it
> > work against the Virtual SMP Port?
> > 
> 
> I tried out this by passing /sys/class/bsg/sas_host0, and I saw it
> return Virtual SMP.  I guess this can be left in.

Nice. With that fix, bsg's smp_rep_manufacturer works against an
expander too?


> > Oh, I thought that LSI wants to send the smp_reply back to user space
> > since Doug's smp-utils does. But If you don't want, I'll just put the
> > response check code that you suggested in the previous mail.
> > 
> 
> On second thought, It would be nice to have iocstatus, iocloginfo, and
> sasstatus available in user space, that way the appliacation will have a
> better understanding of what error occurred.

Yeah.


> Without that info, how will you it know if the response data you
> receive is valid data?  For instance, before I identified the bug in
> the sgel size, you were displaying garbage.

The SMP response's function result wasn't set correctly? bsg's
smp_rep_manufacturer didn't check the result so it showed garbase, I
guess.

BTW, I took the code to check the result from Doug's smp_utils and put
bsg's smp_rep_manufacturer:

http://www.kernel.org/pub/linux/kernel/people/tomo/smp/

or

git://git.kernel.org/pub/scm/linux/kernel/git/tomo/sgv4-tools.git


> The driver could have prevented that by returning -ENXIO I guess,
> instead how about pushing up that info to user space.

Agree.

> what do you think?    maybe there should be some translation to common
> error returns code between the varous sas vendors supporting this
> portal.

aic94xx gives only the smp response. It doesn't have its unique
reply. I like the idea that user-space tools can simply put a smp
reqeust frame to out-buffer and get a smp response frame from
in-buffer. I'm not sure about inventing our smp response header and
putting it with a smp response frame to in-buffer.

That's the reason why I said before, sense buffer is not used for smp
and using sense buffer would be the easiest way to push up the mpt
unique response to userspace.

Here's an updated patch.


diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index d506646..f2965e7 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -1328,11 +1328,139 @@ mptsas_get_bay_identifier(struct sas_rphy *rphy)
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
+	int ret;
+	int flagsLength;
+	unsigned long timeleft;
+	char *psge;
+	dma_addr_t dma_addr_in = 0;
+	dma_addr_t dma_addr_out = 0;
+	u16 ioc_status;
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
+	/* a reply frame is expected */
+	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID)) {
+		printk(KERN_ERR "%s: smp response invalid!\n", __FUNCTION__);
+		ret = -ENXIO;
+	}
+
+	smprep = (SmpPassthroughReply_t *)ioc->sas_mgmt.reply;
+	ioc_status = le16_to_cpu(smprep->IOCStatus) & MPI_IOCSTATUS_MASK;
+	if ((ioc_status != MPI_IOCSTATUS_SUCCESS) &&
+	    (ioc_status != MPI_IOCSTATUS_SCSI_DATA_UNDERRUN))
+		return -ENXIO;
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
