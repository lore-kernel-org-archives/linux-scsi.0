From: "Moore, Eric Dean" <Emoore@lsil.com>
Subject: RE: [PATCH] fusion: streamline ->queuecommand
Date: Tue, 5 Oct 2004 18:38:29 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0E3FA95632D6D047BA649F95DAB60E570526235F@exa-atlanta>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:50939 "EHLO mail0.lsil.com")
	by vger.kernel.org with ESMTP id S266252AbUJEWjK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Oct 2004 18:39:10 -0400
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Stephens, Larry" <larry.stephens@lsil.com>, "Shirron, Stephen" <Stephen.Shirron@lsil.com>, "Gibbons, Terry" <Terry.Gibbons@lsil.com>
Cc: Christoph Hellwig <hch@infradead.org>, Matthew Wilcox <matthew@wil.cx>, Christoph Hellwig <hch@lst.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>


On Monday, October 04, 2004 3:57 PM, James Bottomley wrote: 

> > (3) How will a generic negotiation be done for raid 
> volumes?  The MPT driver
> > supports RAID levels
> > 0, 1, and 0+1.  The driver does DV via RAID passthru to the 
> individual
> > devices. 
> 
> As long as real scsi_device devices exist for the 
> passthrough, it would
> also be able to do dv for those.


The physical devices hiddend in a RAID array are 
not going to be exported as real scsi_devices to the layer
above the LLD.  Only the virtual volume represting the RAID array will be.
Therefore it will be impossible for DV to be handled from a layer
outside the LLD for RAID arrays. 

> 
> > (4) The MPT driver has several work arounds in DV path to 
> take advantage of
> > the
> > full inquiries that are passed as part of its alogirthm.  
> The problem in
> > older kernels
> > were some distro's such as SuSE was only sending 36 bytes 
> of inquiry data
> > during Scaning the bus,
> > and we are needing 57 bytes to determine if device has IU 
> and QAS set, as
> > well as detecting 
> > if the devices is a safte device.  In addition, with IU set 
> or not, the
> > driver will know whether 64 or 256 luns
> > can be scanned for.
> 
> This is obsolete and needs removing ... the mid layer does a 2 phase
> inquiry and sets the capability support based on this.  No 
> device should
> be doing inquiry snooping.


Can we assume that all linux distributions provide at least 57 bytes of
inquiry data
during the scsi bus scan?   I don't know if Suse has solved this, but they
were
in 2.4 kernel only sending 36 bytes of inquiry data.

> 
> > (5) We only do DV for SCSI HBA's. DV is not done for Fiber 
> or SAS, which is
> > also handled by this driver.
> 
> DV is part of the SPI transport class only ... it's not an option for
> the others.
> 
> > (6) DV algorithm works, and well tested, and accepted by 
> our OEMS. Nothing
> > is broke. Why break it?    
> 
> Because sharing code and thus increasing its usage is good.

That is not a risk that LSI Logic is willing to take;   
currently there is not a 2.7 kernel testbed for this. 
Having someone outside LSI blindly posting a patch removing our
DV and not having throughly tested could have grave results. 
The DV currently in place has been thru many test cycles in our own
test labs, and these drivers are well accepted by our customer base.
Other LSI employees copied on this email can comment futher on that.

Eric

