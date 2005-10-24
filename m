From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [patch 0/6] marginalize HCIL a bit
Date: Mon, 24 Oct 2005 13:18:38 -0400
Message-ID: <435D176E.5000201@adaptec.com>
References: <20051023013618.GA18201@havoc.gtf.org>	 <1130081372.3437.33.camel@mulgrave>  <435D0283.40505@adaptec.com> <1130172627.3325.57.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:2178 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751184AbVJXRSp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 13:18:45 -0400
In-Reply-To: <1130172627.3325.57.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org

On 10/24/05 12:50, James Bottomley wrote:
> On Mon, 2005-10-24 at 11:49 -0400, Luben Tuikov wrote:
> 
>>On 10/23/05 11:29, James Bottomley wrote:
>>
>>>There's an unaddressed lifetime problem in all of this:  Originally the
>>>target object exists solely internally and has its lifetime managed by
>>>the mid-layer (it actually exists only as long as there are LUNs on it).
>>
>>And this has always been wrong and I objected to this back when it
>>was introduced a few years ago.
> 
> 
> Only in your opinion.  The reason it was done this way was to protect
> drivers from lifetime management, as I explained when it was done.

No, not only in my opinion.

What I wanted and still want is _true_ domain device representation.
"scsi_target" doesn't describe a "target" or domain device.

If you want finer control and better representation (one follows
the other) then you'd need to have a proper represention of
a domain device.  This will also help you get rid of HCIL, which
I've been asking for since 2002/3.

>>The new struct scsi_domain_device { } would be a logial (not imposed)
>>superclass around the transport's domain device representation.
>>The Transport Layer _registers_ a struct scsi_domain_device { };
>>and then SCSI Core scans for LUs and does LU bookkeeping.
> 
> 
> That's what scsi_scan_target() does.

HCIL.  It needs to be passed a stuct scsi_domain_device { }, where
this device could be on any domain whatsoever: USB, SBP, SAS, FC, etc.

Then when SCSI Core starts scanning for LU, the Transport Layer
knows how to route those: USB, SBP, SAS, FC, etc.

>>LUs -> SCSI Core
>>SCSI Domain Targets -> Transport Layer around its own domain device
>>representation:
>>
>>struct scsi_domain_device {
>>	void *domain_device;    /* opaque to SCSI Core */
>>	
>>	struct list_head LU_list;
>>	...
>>};
>>
>>All of this functionality and infrastructure is present in the
>>SAS Stack and could be taken almost as is.
> 
> 
> Amazingly enough, it's also already present in the transport classes
> (see vanilla linux kernel source code).

1. What are we talking about here?
2. File location, name and line please.  Thank you.

> If you look at your domain device with all the sas pieces removed,
> you'll see that scsi_target actually covers all the remaining bits
> (there are one or two pieces covered by struct generic_device which you
> have to have extra components for because you implemented kobjects
> instead of a generic device).

And there is a reason for this: domain devices are NOT and WILL NEVER
BE "generic device".  Domain device representations exist only in
the Transport Layer.  What you seem to suggest with your "transport
attributes" is this "appendages-modules" which intersperse everywhere
in SCSI Core and LLDD like octopus's arms.  See USB Storage and SBP.

> scsi_target contains a variable space for
> the transport classes to use for their transport specific pieces (which
> is where you could have put all the sas specific bits).

Absolutely NOT.  Those "transport specific pieces" should be completely
OPAQUE to SCSI Core -- as you saw in my previous email, the
"transport specific pieces" as you called them were 
"void *domain_device;  /* opaque to SCSI Core */".

I guess the proper question to ask now is: "Can you envision it?"

> The only real difference is that under the current infrastructure scsi
> targets aren't designed to stack.  Realistically, the way you have it
> implemented, you have several different devices lumped into your domain
> device (end, edge, fanout, sata) with different initialisations and

1. How this is implemented is Layer dependent (USB/SBP/FC/SAS/iSCSI/etc).
2. A struct domain_device can be _only_ one of end/edge/fanout/sata/etc,
   and only one of those.
Only devices which _make_sense_ to SCSI Core are registered with SCSI Core,
i.e. end devices.  Other type of devices (e.g. expanders) that are
NOT SCSI devices are not registered with SCSI Core, neither should they
be visible anywhere outside of the respective Layer (SAS in this case).

> behaviours, so scsi_target maps exactly to end devices.  I'm really not
> a huge fan of object type overloading unless there's a good reason for
> it, so in the generic device world, you'd probably have different
> structures for the other device types (although nothing precludes
> implementation as an overloaded type).

All this is _outside_ of the scope of a Transport Layer/Stack,
e.g. see USB Storage and SBP.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
