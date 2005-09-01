From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [RFC] libata new EH document
Date: Thu, 01 Sep 2005 19:17:14 -0400
Message-ID: <43178BFA.4040203@adaptec.com>
References: <20050901043850.15186.qmail@web51611.mail.yahoo.com>	 <43169520.6040008@gmail.com>  <20050901055421.GA23496@havoc.gtf.org> <1125581097.4834.5.camel@mulgrave> <4317755C.5080700@adaptec.com> <431776A0.2030107@pobox.com> <43177C0B.9040500@adaptec.com> <43178060.9030601@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43167 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1030468AbVIAXRY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Sep 2005 19:17:24 -0400
In-Reply-To: <43178060.9030601@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Tejun Heo <htejun@gmail.com>, ltuikov@yahoo.com, Albert Lee <albertcc@tw.ibm.com>, linux-ide@vger.kernel.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, Doug Maxey <dwm@maxeymade.com>

On 09/01/05 18:27, Jeff Garzik wrote:
>>I think it's only because "it's there" and that it provides
>>a uniform access -- provided by SCSI, _not_ by that particular
>>SCSI implementation.
> 
> 
> You're correct in one sense, but I still don't think you understand 
> Linux development at a fundamental level.
> 
> Linux is NOT about big designs.  Linus says "do what you must, and no 
> more."  Linux is a fluid, organic biological organism that evolves 
> through small changes over time.

Jeff, this is no longer true.

Maybe in the years 1991-1995, but this is _absolutely_ no longer true.
Far more so for SCSI Core.  Read Documentation/ManagingStyle.

Furthermore, take a look at the changes Christoph is about to
do now regarding, about and around struct scsi_target.

Those changes have been talked about _before_ Christoph
moved from XFS to SCSI Core and _before_ you moved from
8139too to SCSI Core, first by Justin Gibbs and then by, yours
truly.

Another expample, 64 bit LUNs.  First they are not supported,
second, they are _interpreted_ by SCSI Core in scsilun_to_int().
This is beyond wrong, this is incompetence.

I've been asking for those since 2000, after my work on iSCSI.

So, as you see, _you are right_, but only for *other* Linux
subsystems, where their maintaners operate on the Documentation/ManagingStyle
style.  Here at SCSI Core, the maintainers like to control everything,
and unless _they_ themselves came up with the idea, to reject it
immediately.

So over the years, a lot of "design features", "enhancements", etc
have stacked up, against the antiquated SCSI Core.  It is very sad
and unfortunate.

Had those been listened to and heeded to, we'd have the human
framework that you talk about.

The best thing you can have is maintainers who _listen_ to people
and _listen_ to core engineers who _live and breathe_ the industry.
This is the Documentation/ManagingStyle.

The worst thing you can have is maintainers who try to _guess_
and do their own designs and whims, without actually addressing
real problems which exist now and have existed for a long time.

The presense of channel/id in SCSI Core.  It is unthinkable to leave
that in and go and work on a "transport class", whatever that means.

Priorities need to be set straight.  The architecture (future) needs
to be studied or at least the maintainers should listen to vendors
and double check with others and then triple check with a spec.

Parallel SCSI is slowly and surely going away.

FC, USB, FireWire, SATA and SAS is coming our way and will completely
replace SPI.

You can join the future or you can steadfastly hang on to something
which you know will not cut it anywhich way you mess with it.

> So, yes, the reason is "it's there"   And that's a really good reason!
> 
> The future will bring other "baby steps" that evolve us towards a more 
> modular design where each LLD may register themselves with a storage 
> system, associate themselves with one or more transport classes, which 
> in turn create associations with device classes.

I have this working already _and_ it is T10 compliant.
It is modular and _layered_.

> Queueing, EH, transport classes (which should already be independent of 
> SCSI), maybe driver API, and other fun stuff.  :)

You'd better have one good and well thought out infrastructure...!
Of course you cannot do any of this unless a lot of specs have been
read and studied.... It's like writing papers -- you do if after having
read a lot of them.

As to your saying 
	"transport classes (which should already be independent of
	 SCSI)"
You see, this will _never_ happen.

First of all, them JB's "transport classes" were writting ONLY
to export *attributes*, and _never_ to provide a layer of abstraction
for the specific transport.

Second, as I mentioned in a previous email, you cannot create
a "superclass" of all transports. Because:
	- this is what SAM is,
	- this is what SCSI Core *should be*!

Third, they were never intended to *manage* a transport infrastructure.
Just look at the troubles they have with SAS's infrastructure.

Fourth, they are "hooked" at the _wrong_ level and indirection,
just as you say
	"transport classes (which should already be independent of
	 SCSI)".
They are NOT and will never be -- the mindset of their creators
is that they will control also the transports, instead of
concentrating on SCSI Core.

So all in all, a lot of thinking needs to be done. Add to this
a white sheet of paper, pencil on one side and a spec on the other.

	Luben







