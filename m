From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [ANNOUNCE] MPT Fusion driver 3.02.06 update
Date: Tue, 26 Oct 2004 17:08:49 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20041026160849.GA14917@infradead.org>
References: <0E3FA95632D6D047BA649F95DAB60E57053AF0AE@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from phoenix.infradead.org ([81.187.226.98]:50445 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S261322AbUJZQJD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Oct 2004 12:09:03 -0400
Content-Disposition: inline
In-Reply-To: <0E3FA95632D6D047BA649F95DAB60E57053AF0AE@exa-atlanta>
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Emoore@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, jeremy@sgi.com, linux-scsi@vger.kernel.org

> This code code is ifdef'd with CPQ_CIM.  We currently have this is enabled
> in the fusion Makefile. Instead would it be possible to have this disabled
> for inclusion 
> in the kernel?  Applications are in place now used by several customers
> using this
> interface, and it would be difficult to have this remove at this stage, as
> our 
> customers are so close to shipment of product. 

This code isn't acceptable for kernel inclusion at all, dito for the
hooks it needs (e.g. the sas device list)

> > please don't put this under all kinds of ifdefs, also it's 
> > not working with
> > current mainline anymore anyway.
> 
> I don't know what you mean.  The fc_transport stuff was just added two weeks
> ago.  This was added by request of Jeremy Higdon.  This reports
> the port_id, port_name, and node_name.  This support is enabled in
> the fusion Makefile by MPT_ENABLE_FC_TRANSPORT. Its currently disabled for
> reason (1) the transport layer is only available after 2.6.6 kernel, and
> we are supporting kernels older such as SUSE 9.1 and SLES9, (2)
> we would not be able to build driver update disks due to the dependancy
> of fc_transport.ko. 

But the policy is to keep such ifdefs out of kernel drivers.  If SuSE
wants current FC drivers backported they'll need to backpor the full
transport attr infrastructure.

Also as I mentioned this code doesn't compile on 2.6.10-rc at all.

> > Any reason there's no SPI transport attribute support, it's 
> > rather asymetric
> > this way..
> > 
> 
> We are investigating into this, such as domain validation.  
> What other attributes do you suggest?

if possible all that are define, see include/scsi/scsi_transport_spi.h
in a current kernel.

