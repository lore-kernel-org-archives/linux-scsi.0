From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] enclosure: add support for enclosure services
Date: Tue, 05 Feb 2008 09:01:56 -0600
Message-ID: <1202223716.3133.10.camel@localhost.localdomain>
References: <150265.33450.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <150265.33450.qm@web31808.mail.mud.yahoo.com>
Sender: linux-ide-owner@vger.kernel.org
To: ltuikov@yahoo.com
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-ide <linux-ide@vger.kernel.org>, "Accardi, Kristen C" <kristen.c.accardi@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Mon, 2008-02-04 at 21:35 -0800, Luben Tuikov wrote:
> > > I guess the same could be said for STGT and SCST,
> > right?
> > 
> > You mean both of their kernel pieces are modular? 
> > That's correct.
> 
> No, you know very well what I mean.
> 
> By the same logic you're preaching to include your
> solution part of the kernel, you can also apply to
> SCST.

Ah, but it's not ... the current patch is merely exporting an interface.
The debate in STGT vs SCST is not whether to export an interface but
where to draw the line.

You could also argue in the same vein that sd is redundant because a
filesystem could talk directly to the device via /dev/sgX (in fact OSD
based filesystems already do this).  The argument is true, but misses
the bigger picture that the interfaces exported by sd are more portable
(apply to non-SCSI block devices) and easier to use.

> > > Yes, for which the transport layer, implements the
> > > scsi device node for the SES device.  It doesn't
> > really
> > > matter if the SCSI commands sent to the SES device go
> > > over SGPIO or FC or SAS or Bluetooth or I2C, etc, the
> > > transport layer can implement that and present the
> > > /dev/sgX node.
> > 
> > But it does matter if the enclosure device doesn't
> > speak SCSI.
> 
> Enclosure management isn't as simple as you're
> portraying it here.  The enclosure management
> device speaks either SES or SAF-TE.  The transport
> protocol to access it could be SGPIO or I2C or...

Look, just read the spec; SGPIO is a bus for driving enclosures ... it
doesn't require SES or SAF-TE or even any SCSI protocol.

> >  SGPIO
> > isn't a SCSI protocol ... it's a general purpose
> > serial bus protocol.
> > It's pretty simple and register based, but it might (or
> > might not) be
> > accessible via a SCSI bridge.
> 
> I see.  You've just discovered SGPIO -- good for you.
> 
> At any rate, I told you already that what is needed
> is not what you've provided but a _device node_
> exported by the kernel, either a processor or
> enclosure type.

Wrong ... we don't export non-SCSI devices as SCSI (with the single and
rather annoying exception of ATA via SAT).

James


