From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Sun, 09 Oct 2005 12:25:51 -0400
Message-ID: <4349448F.6040309@adaptec.com>
References: <20051005231912.79866.qmail@web31807.mail.mud.yahoo.com>	 <1128647235.4623.28.camel@mulgrave>  <4346EA4C.3020602@adaptec.com> <1128781859.4824.14.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:1422 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1750888AbVJIQZz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Oct 2005 12:25:55 -0400
In-Reply-To: <1128781859.4824.14.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: ltuikov@yahoo.com, Jeff Garzik <jgarzik@pobox.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

On 10/08/05 10:30, James Bottomley wrote:
> But it doesn't represent a SCSI domain; it represents a particular type
> of SCSI domain (as you say yourself, SAS or SATA).  I'm trying to eject

That's true.

> transport specific knowledge from the mid-layer, so a domain device that
> would be used in the mid-layer should be capable of representing any
> SCSI domain (FC/SPI/SBP etc ..).  I suppose in the worst case, anything
> that comes back to the mid-layer from the transports should be relevant
> to at least two separate transports.

struct scsi_domain_device { ... }; (to be created) is your friend.

The only way that that design
	"should be capable of representing any 
	 SCSI domain (FC/SPI/SBP etc ..)"

Is if it _does not_ have any knowlege about the underlying
physical domain -- just as it is shown in SAM (and that is the whole point).
Else you get in this neverending cat-and-mouse game.  If you have the
abstraction right, then whatever new transport comes along, it would
be properly represented.

> That's why I want SAS to prove itself to be quirk free.  If we have to
> add them, then all we get is a parallel version of scsi_scan_target with
> a parallel quirk table ... which is highly undesirable.

Well, this way we get into the chicken and the egg problem.

Pessimistically: "Yeah, SAS will have all the same problems, so might
as well crud it up good, let's kill it from the get go."

Optimistically: "No, SAS will not have the same problems.  FW writers
have gotten smarter, they've read SAS and SAM at least once.  I'll
give them the benefit of the doubt."

Naturally (as an engineer), I'm on optimist, plus this is what
I've observed with beta and release FW.

> Let Jeff come up with the incorporation scheme and see how it looks.

Hmm, I haven't seen or heard anything from Jeff.  Have you?

I have no idea what his plans are.  If the idea is to create
struct scsi_domain_device { ... }; and start from there,
then I'd like to be involved since this was what I'd wanted
for SCSI since 2002.

> I know.  But, in the presence of quirks, this is wrong.  We need an
> inquiry first so we have something to look up in the quirk capabilities
> table.  report luns doesn't return enough information ... and since one
> of the quirks is that report luns returns incorrect information ...

Yes, it gets very messy.

On a different note: I'd love to _buy_ a device which returns
_incorrect_ REPORT LUNS.  Who hires those people?  (Or do they
get the job because of politics? ;-) )

> Nothing in the standard mandates exactly how discovery be done.  But for
> the quirk reason outlined above, inquiry has to be first.

That's true.  But think about it: you've just discovered
a device on the SCSI Domain (using protocol) and you don't know
anything about it (as stated in my code's comments).  The first
thing you want to do is REPORT LUNS to figure out how many
LUs are there.  LUs in a SCSI Device do not necessarily have to
be homogeneous.

As to quirks, I guess you're right.

But SCSI Core has come to a breaking point: being so SPI-centric
and outdated, full of quirks and legacy stuff.

SCSI Core has a chance now with SAS to become what it had
needed to start becoming in 2002: native target support,
64 bit LUNs, etc.

Note: when I say "native" target support, I do _not_ mean
"struct scsi_target", but "struct scsi_domain_device" (to be
created).  That is, the "native" indicates that the "target",
"SCSI Device", can only be addressed by the transport --
SCSI Core doesn't not know how to address the device (only
LUs).  All the while, struct scsi_target has HCIL in it.

> It takes time for standards to bubble into the field.  There are still
> manufacturers today producing devices claiming scsi-2 compliance (I
> suspect they tried scsi-3 found a problem in testing and "corrected" it
> by dropping back to scsi-2, but they're still rolling off the production
> lines).  Of all the arrays I see certified in my day job, one claims
> SCSI-2, one claims SPC-3 and the rest seem to have a 50/50 split between
> SPC and SPC-2.  So, fully 50% of these devices are not required to
> support report LUNs; if they were single LUN devices, then the vast
> majority wouldn't be required to support it.
> 
> The point to all this is that the version of the standard matters a lot,
> especially where the actual standards differ from version to version
> because we have to provide support for what the devices were built to,
> not what the latest standard says.

Well, this sounds good, but I'd say give SAS a chance, let's be optimistic.

	Luben
-- 
http://linux.adaptec.com/sas/
Disclaimer: Opinions stated in this email are my own, not of my employer.
For inquiries write to: luben_tuikov@adaptec.com or ltuikov@yahoo.com.
