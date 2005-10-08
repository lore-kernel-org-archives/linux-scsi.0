From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Sat, 08 Oct 2005 09:30:59 -0500
Message-ID: <1128781859.4824.14.camel@mulgrave>
References: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com>
	 <1128647235.4623.28.camel@mulgrave>  <4346EA4C.3020602@adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:33971 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S932143AbVJHObJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 8 Oct 2005 10:31:09 -0400
In-Reply-To: <4346EA4C.3020602@adaptec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On Fri, 2005-10-07 at 17:36 -0400, Luben Tuikov wrote: 
> On 10/06/05 21:07, James Bottomley wrote:
> > 1. The domain device as you have implemented it requires a lot of
> 
> The domain device as I've implemented it, is exactly a SAS domain
> device, supporting expanders, SAS, SATA, SATA PM, etc. devices.  It
> doesn't add any cruft, it is the minimum of what it should be.

But it doesn't represent a SCSI domain; it represents a particular type
of SCSI domain (as you say yourself, SAS or SATA).  I'm trying to eject
transport specific knowledge from the mid-layer, so a domain device that
would be used in the mid-layer should be capable of representing any
SCSI domain (FC/SPI/SBP etc ..).  I suppose in the worst case, anything
that comes back to the mid-layer from the transports should be relevant
to at least two separate transports.

> I'm not sure that you can "refine" (take stuff out) from
> struct domain_device.
> 
> You're better off creating struct scsi_domain_device { ... }; and starting
> from there.
> 
> In effect struct scsi_domain_device { ... }; (non existant yet)
> would be a superclass (in OO sense) of the SAS struct domain_device, shown
> above.

Exactly ... the transport independent abstraction of a domain device.

> In contrast to "templates", the OO sense can be kept _by design_,
> by _SCSI_ design, not by code enforcement (i.e. struct template_abcd...).
> 
> > 2. sas_do_lu_discovery() duplicates a lot of existing functionality, but
> > also lacks a lot of quirk processing.  I know the argument is that SAS
> 
> It doesn't duplicate a lot of functionality.  While the code
> in SCSI Core does do LU discovery, the infrastructure is very broken
> in that
>   1) there is no native "target" (i.e. SCSI Device with Target port)
>      support (struct domain_device), and
>   2) that code uses HCIL, by scsi_scan_target definition and from
>      seeing things like:
> 
> 	if (shost->this_id == id)
> 		/*
> 		 * Don't scan the host adapter
> 		 */
> 		return;
> 
> As to SAS, the comment is about the size of the function:
[...]

> > won't have any quirks, but I'd like to have this proven in the field
> > before I take it as read.
> 
> Indeed, it doesn't have quirks (because there are none yet out there).
> 
> Let's include it _without_ quirks, and add them as new devices come
> to the market, instead of crudding the code unnecessarily.  This gives
> more freedom of future "patching" and future "design".
> 
> The reason is that if all you have is the SAS/SATA chip, then you do not
> need all the legacy quirks, code bloat, bigger binary.

That's why I want SAS to prove itself to be quirk free.  If we have to
add them, then all we get is a parallel version of scsi_scan_target with
a parallel quirk table ... which is highly undesirable.

> > I'm sure you're aware that not responding on either LUN 0 or the report
> > luns WLUN is a violation of SAM  ... however, if we really already have
> 
> I am. I've repeated this about 100 million times on this list,
> and it is in the SAS code comments at sas_do_lu_discovery().
> 
> > broken SAS devices with this problem, then you're welcome to expand
> > scsi_scan_target() to cope.
> 
> I don't have a problem working on scsi_scan_target().
> But I have a problem with it using _HCIL_.
> 
> What do you suggest?

Let Jeff come up with the incorporation scheme and see how it looks.

> > WLUN support is really the only piece that scsi_scan_target() doesn't
> > currently possess and, as has been discussed before, that only really
> 
> -------------------------------------------------------------------------
> > matters if we get a target that's not going to respond to an INQUIRY on
> > LUN0 (I expect most of them, even if they have no LUN0 will respond with
> > PQ 3 to the inquiry and thus be caught by scsi_scan_target() anyway).
> -------------------------------------------------------------------------
> 
> I think you clarify your point below but as far as SAM-4 and
> thus SAS devices are concerned:
> 
> REPORT LUNS is sent first, to figure out what LUs are contained
> in the SCSI device, and then for each LU, send an INQUIRY to the LU.
> >From the code:

I know.  But, in the presence of quirks, this is wrong.  We need an
inquiry first so we have something to look up in the quirk capabilities
table.  report luns doesn't return enough information ... and since one
of the quirks is that report luns returns incorrect information ...

> Also the order of operations... "initial INQUIRY comes back
> SCSI_SCAN_NO_RESPONSE then fire off a WLUN report lun scan anyway".
> 
> When in fact REPORT LUNS should be the first thing sent, then if that
> fails we assume that LUN 0 is present anyway as you can see I've done
> in sas_do_lu_discovery() above.

Nothing in the standard mandates exactly how discovery be done.  But for
the quirk reason outlined above, inquiry has to be first.

> So it gets really messy if you can see what I mean.
> 
> >>P.S. REPORT LUNS is Mandatory as per SPC, so newer devices
> >>(SAS) support it.  Furthermore if their LUs are sparse they
> >>(really) support REPORT LUNS.
> > 
> > 
> > Actually, it's optional per SPC; it's mandatory in SPC-2 but *only* if
> > your device is multi-LUN; and it finally became mandatory for everything
> > in SPC-3 (or I should say "becomes" since SPC-3 isn't ratified yet).
> 
> "Actually" when I say SPC, I mean SPC-latest.  When I say SAM, I mean
> SAM-latest, when I say SCSI, I mean SCSI-3 which T10 says means SCSI.

It takes time for standards to bubble into the field.  There are still
manufacturers today producing devices claiming scsi-2 compliance (I
suspect they tried scsi-3 found a problem in testing and "corrected" it
by dropping back to scsi-2, but they're still rolling off the production
lines).  Of all the arrays I see certified in my day job, one claims
SCSI-2, one claims SPC-3 and the rest seem to have a 50/50 split between
SPC and SPC-2.  So, fully 50% of these devices are not required to
support report LUNs; if they were single LUN devices, then the vast
majority wouldn't be required to support it.

The point to all this is that the version of the standard matters a lot,
especially where the actual standards differ from version to version
because we have to provide support for what the devices were built to,
not what the latest standard says.

James


