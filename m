From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 13:03:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E57053AF0CB@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:45952 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S261340AbUJZREP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 13:04:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, jeremy@sgi.com
Cc: linux-scsi@vger.kernel.org

> > This code code is ifdef'd with CPQ_CIM.  We currently have 
> this is enabled
> > in the fusion Makefile. Instead would it be possible to 
> have this disabled
> > for inclusion 
> > in the kernel?  Applications are in place now used by 
> several customers
> > using this
> > interface, and it would be difficult to have this remove at 
> this stage, as
> > our 
> > customers are so close to shipment of product. 
> 
> This code isn't acceptable for kernel inclusion at all, dito for the
> hooks it needs (e.g. the sas device list)
> 

We have to ship with these IOCTLS. Are there any compromise?
Sounds like you shot down my backup idea; e.g putting this code into 
seperate file which isn't provided for inclusion, but can be recompiled 
to link into mptctl?  I don't think we time to pursue your the idea of 
re-invent everything into the sas-transport layer.
 
> > > please don't put this under all kinds of ifdefs, also it's 
> > > not working with
> > > current mainline anymore anyway.
> > 
> > I don't know what you mean.  The fc_transport stuff was 
> just added two weeks
> > ago.  This was added by request of Jeremy Higdon.  This reports
> > the port_id, port_name, and node_name.  This support is enabled in
> > the fusion Makefile by MPT_ENABLE_FC_TRANSPORT. Its 
> currently disabled for
> > reason (1) the transport layer is only available after 
> 2.6.6 kernel, and
> > we are supporting kernels older such as SUSE 9.1 and SLES9, (2)
> > we would not be able to build driver update disks due to 
> the dependancy
> > of fc_transport.ko. 
> 
> But the policy is to keep such ifdefs out of kernel drivers.  If SuSE
> wants current FC drivers backported they'll need to backpor the full
> transport attr infrastructure.
> 
> Also as I mentioned this code doesn't compile on 2.6.10-rc at all.
> 


Jeremy Higdon asked me to add this, not SuSE.

We provide pre-built drivers to customers that ship Suse on
their servers, and having fc attributes enabled in the driver
means the driver fail's to compile in the older versions of the
kernel.  

The failures to compiled in 2.6.10-rc is due to someone changing
the defines in scsi_transport_fc.h.

2.6.9				2.6.10-rc				
---------			---------
fc_port_id			fc_starget_port_id
fc_node_name		fc_starget_node_name
fc_port_name		fc_starget_port_name
		







