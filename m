From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 11:57:33 +0100
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF302DE46@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:15233 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S262071AbVADK5h convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 05:57:37 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>, Arjan van de Ven <arjan@infradead.org>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Yes, that's the problem. I have to pass a physical address of
scp->sense_buffer to our controller firmware that the firmware can fill
that space with DMA after I/O. But cmdp->u.{raw,raw64}.sense_data does
not survive until we get to unmapping stuff in gdth_sync_event() because
there is only one cmdp structure per controller and the controller can
handle multiple commands. So I have to save the physical address
anywhere in the Scsi_Cmnd structure.
You are right, some pci_map...() checking stuff should be added.

> -----Original Message-----
> From: Al Viro [mailto:viro@www.linux.org.uk] On Behalf Of Al Viro
> Sent: Dienstag, 4. Januar 2005 11:30
> To: Arjan van de Ven
> Cc: Leubner, Achim; Christoph Hellwig; James Bottomley; SCSI Mailing
List
> Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
> 
> On Tue, Jan 04, 2005 at 10:32:41AM +0100, Arjan van de Ven wrote:
> > On Tue, 2005-01-04 at 10:29 +0100, Leubner, Achim wrote:
> > > You are right, in gdth_fill_raw_command() the driver is doing two
> > > different dma mappings, one for the data buffer stored in
> > > SCp.dma_handle, and the second for the sense buffer stored in
SCp.buffer
> > > and host_scribble. So reuse of dma_handle does not work here.
> >
> > Is there a way the driver can get rid of looking at the sense buffer
at
> > all and let the midlayer do this ?
> 
> AFAICS, hardware wants dma_address of that puppy passed to it.  Which
might
> be a solution of this problem, if that address is not clobbered and
can
> be read back from where we'd stored it.  But that's a question for
hardware
> folks - does the value of cmdp->u.{raw,raw64}.sense_data survive until
we
> get to unmapping stuff in gdth_sync_event()?
> 
> In any case, we really should check for failure of pci_map_...() and
be
> more careful with checking if two areas need to be unmapped...
