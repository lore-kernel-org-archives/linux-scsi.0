From: "Leubner, Achim" <Achim_Leubner@adaptec.com>
Subject: RE: [PATCH] fix gcc warning on 64 bit compile of gdth
Date: Tue, 4 Jan 2005 13:08:09 +0100
Message-ID: <B51CDBDEB98C094BB6E1985861F53AF302DE47@nkse2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:63409 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261458AbVADMIO convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 4 Jan 2005 07:08:14 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@parcelfarce.linux.theplanet.co.uk>
Cc: Arjan van de Ven <arjan@infradead.org>, Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Agreed. Adding a new field in cmd_tab[] is a good possibility to solve
the problem.

gdth_ctr_vtab[] is used in kernel 2.4.x in gdth_proc_info()
(gdth_proc.c) to find the right ha and bus number. The background of
gdth_ctr_vtab[] is a problem of older cdrecord versions with controllers
with more than one bus. In this case the driver gave the possibility to
split the controller into multiple controllers with one bus each
(command line switch "virt_ctr:Y").


> -----Original Message-----
> From: Al Viro [mailto:viro@www.linux.org.uk] On Behalf Of Al Viro
> Sent: Dienstag, 4. Januar 2005 12:53
> To: Leubner, Achim
> Cc: Arjan van de Ven; Christoph Hellwig; James Bottomley; SCSI Mailing
List
> Subject: Re: [PATCH] fix gcc warning on 64 bit compile of gdth
> 
> On Tue, Jan 04, 2005 at 11:57:33AM +0100, Leubner, Achim wrote:
> > Yes, that's the problem. I have to pass a physical address of
> > scp->sense_buffer to our controller firmware that the firmware can
fill
> > that space with DMA after I/O. But cmdp->u.{raw,raw64}.sense_data
does
> > not survive until we get to unmapping stuff in gdth_sync_event()
because
> > there is only one cmdp structure per controller and the controller
can
> > handle multiple commands. So I have to save the physical address
> > anywhere in the Scsi_Cmnd structure.
> 
> Umm...   What about adding a new field to
>     struct {
>         Scsi_Cmnd       *cmnd;                  /* pending request */
>         ushort          service;                /* service */
>     } cmd_tab[GDTH_MAXCMDS];                    /* table of pend.
reques
> in gdth_ha_str?  It's not that we couldn't change size of that animal
and
> AFAICS anything that might be passed to gdth_sync_event() would have
to
> be extracted from ha->cmd_tab[] anyway...
> 
> BTW, what uses values stored in gdth_ctr_vtab[]?  It's static and
gdth.[ch]
> never read its elements, only set them...
