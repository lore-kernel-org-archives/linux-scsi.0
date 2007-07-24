From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Mon, 23 Jul 2007 18:11:34 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D7088519D@NAMAIL4.ad.lsil.com>
References: <20070709125211U.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56231 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563AbXGXAMB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Jul 2007 20:12:01 -0400
Content-class: urn:content-classes:message
In-Reply-To: <20070709125211U.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

Tomo - do you have any documentation on how to specify a bsg device?  I
was trying to run the smp_rep_manufacture from sgv4_tools, and I got
that error.  Due to that, I have not able to test this patch.  However,
here are some feedback with regards to the patch:


On Sunday, July 08, 2007 9:52 PM, FUJITA Tomonori wrote: 

> +
> +        smpreq->RequestDataLength = req->data_len - 4;

Our firmware formats the data in little endian, so you'll need to
convert this inorder for it work under other endian formats, like sparc
and ppc.  So this code should be:

smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);


> +        smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
> +
> +	if (rphy)
> +		memcpy(&smpreq->SASAddress, &rphy->identify.sas_address,
> +		       sizeof(smpreq->SASAddress));

should be using cpu_to_le64 before the data is put into
smpreq->SASAddress

> +	else {
> +		struct mptsas_portinfo *port_info;
> +
> +		mutex_lock(&ioc->sas_topology_mutex);
> +		port_info = mptsas_find_portinfo_by_handle(ioc, 
> ioc->handle);
> +		if (port_info && port_info->phy_info)
> +			memcpy(&smpreq->SASAddress,
> +			       
> &(port_info->phy_info[0].phy->identify.sas_address),
> +			       sizeof(smpreq->SASAddress));
> +		mutex_unlock(&ioc->sas_topology_mutex);
> +	}

I'm not sure what the intent of this else case.  I think it should be
deleted, and replaced with a return of ENXIO.    The sas_topology is a
flat model, with the first object the intiatiator, and the other objects
in the list are expanders.    What your your attempting to obtain is the
first port object connected to the initiator, which could be anything,
for instance it could be an end device, instead of expander.    So I
think if your rphy object is not returning a valid sas_address, then
return instead of attempting to find something from the sas_topology.
I hope the API is making sure this is an expander before mptsas is even
called, is that handled?

> +	/* a reply frame is expected */
> +	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID)) {
> +		printk("%s: the smp response invalid!\n", __FUNCTION__);
> +		ret = -ENXIO;
> +	}
> +

I think in addition to having a valid reply, I think you should look at
the iocstatus to insure the reply itself was successfull, and that there
were no data underruns.

ioc_status = le16_to_cpu(smpReply->IOCStatus) & MPI_IOCSTATUS_MASK;
if ((ioc_status != MPI_IOCSTATUS_SUCCESS) &&
    (ioc_status != MPI_IOCSTATUS_SCSI_DATA_UNDERRUN)) {
	return -ENXIO;
}







