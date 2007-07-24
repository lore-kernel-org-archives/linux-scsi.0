From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Tue, 24 Jul 2007 14:27:57 +0900
Message-ID: <20070724142757F.fujita.tomonori@lab.ntt.co.jp>
References: <20070709125211U.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D7088519D@NAMAIL4.ad.lsil.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tama5.ecl.ntt.co.jp ([129.60.39.102]:46663 "EHLO
	tama5.ecl.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750944AbXGXF2c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jul 2007 01:28:32 -0400
In-Reply-To: <664A4EBB07F29743873A87CF62C26D7088519D@NAMAIL4.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Mon, 23 Jul 2007 18:11:34 -0600

> Tomo - do you have any documentation on how to specify a bsg device?

Sorry, I don't. But it's not difficult.

With 2.6.23-rc1 + mptsas smp patch, you get directories /sys/class/bsg
like:

fujita@nice:/sys/class/bsg$ ls
0:0:0:0  0:0:1:0  end_device-0:0  end_device-0:1  sas_host0

I don't have any expanders but if you have, you have a directory like
expander-0:1 under /sys/class/bsg.

I can run smp_rep_manufacturer against "invisible" SMP target in my
LSI SAS HBA like this:

nice:/home/fujita# ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/sas_host0
  SAS-1.1 format: 0
  vendor identification: LSI
  product identification: Virtual SMP Port
  product revision level:

Hopefully, you can do against expanders:

# ./sgv4-tools/smp_rep_manufacturer /sys/class/bsg/expander-0:1


I think that James tested this with aic94xx, however, I guess that
nobody has tested this with mptsas.


> I was trying to run the smp_rep_manufacture from sgv4_tools, and I
> got that error.  Due to that, I have not able to test this patch.

What is the error message?


> However, here are some feedback with regards to the patch:

Thanks.

> 
> On Sunday, July 08, 2007 9:52 PM, FUJITA Tomonori wrote: 
> 
> > +
> > +        smpreq->RequestDataLength = req->data_len - 4;
> 
> Our firmware formats the data in little endian, so you'll need to
> convert this inorder for it work under other endian formats, like sparc
> and ppc.  So this code should be:
> 
> smpreq->RequestDataLength = cpu_to_le16(req->data_len - 4);

I see. I'll fix it.


> > +        smpreq->Function = MPI_FUNCTION_SMP_PASSTHROUGH;
> > +
> > +	if (rphy)
> > +		memcpy(&smpreq->SASAddress, &rphy->identify.sas_address,
> > +		       sizeof(smpreq->SASAddress));
> 
> should be using cpu_to_le64 before the data is put into
> smpreq->SASAddress

Thanks, I will fix it.


> > +	else {
> > +		struct mptsas_portinfo *port_info;
> > +
> > +		mutex_lock(&ioc->sas_topology_mutex);
> > +		port_info = mptsas_find_portinfo_by_handle(ioc, 
> > ioc->handle);
> > +		if (port_info && port_info->phy_info)
> > +			memcpy(&smpreq->SASAddress,
> > +			       
> > &(port_info->phy_info[0].phy->identify.sas_address),
> > +			       sizeof(smpreq->SASAddress));
> > +		mutex_unlock(&ioc->sas_topology_mutex);
> > +	}
> 
> I'm not sure what the intent of this else case.

This code is for an "invisible" SMP target in LSI SAS HBAs. There are
better ways to get the target's address, I think. Any suggestions?


>  I think it should be
> deleted, and replaced with a return of ENXIO.    The sas_topology is a
> flat model, with the first object the intiatiator, and the other objects
> in the list are expanders.    What your your attempting to obtain is the
> first port object connected to the initiator, which could be anything,
> for instance it could be an end device, instead of expander.    So I
> think if your rphy object is not returning a valid sas_address, then
> return instead of attempting to find something from the sas_topology.
> I hope the API is making sure this is an expander before mptsas is even
> called, is that handled?

> > +	/* a reply frame is expected */
> > +	if (!(ioc->sas_mgmt.status & MPT_IOCTL_STATUS_RF_VALID)) {
> > +		printk("%s: the smp response invalid!\n", __FUNCTION__);
> > +		ret = -ENXIO;
> > +	}
> > +
> 
> I think in addition to having a valid reply, I think you should look at
> the iocstatus to insure the reply itself was successfull, and that there
> were no data underruns.
> 
> ioc_status = le16_to_cpu(smpReply->IOCStatus) & MPI_IOCSTATUS_MASK;
> if ((ioc_status != MPI_IOCSTATUS_SUCCESS) &&
>     (ioc_status != MPI_IOCSTATUS_SCSI_DATA_UNDERRUN)) {
> 	return -ENXIO;
> }

Yeah, I guess that it would be better to send mpt's smpReply to user
space then user-space tools can examine it. You know, That's what mpt
ioctl and Doug' smp_utils do. But we can't use the in-buffer for this
since it's used for the smp response. We could use sense buffer for
this.
