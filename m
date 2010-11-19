From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: dma_mask on scsi_calculate_bounce_limit
Date: Fri, 19 Nov 2010 09:15:40 -0600
Message-ID: <1290179740.23556.13.camel@mulgrave.site>
References: <AANLkTin4V6ZZ5T5x+had0+4hL3JzGyR3sa68qaJeZBYv@mail.gmail.com>
	 <1290093715.3041.13.camel@mulgrave.site>
	 <AANLkTinHZC9iFjG1wyJTrRN_aMRkaGUgH=n2CF0wUG8f@mail.gmail.com>
	 <1290127944.11007.46.camel@mulgrave.site>
	 <AANLkTimb6iHPTUCco+stpPCGZJUGC3ePBTik6=GOaa6H@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:57128 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab0KSPPq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Nov 2010 10:15:46 -0500
In-Reply-To: <AANLkTimb6iHPTUCco+stpPCGZJUGC3ePBTik6=GOaa6H@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?=E7=8E=8B=E7=A5=9E?= <oujin.rera@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2010-11-19 at 12:11 +0530, =E7=8E=8B=E7=A5=9E wrote:
> On Fri, Nov 19, 2010 at 6:22 AM, James Bottomley
> <James.Bottomley@suse.de> wrote:
> > On Fri, 2010-11-19 at 01:54 +0800, =E7=8E=8B=E7=A5=9E wrote:
> >> On Thu, Nov 18, 2010 at 11:21 PM, James Bottomley
> >> <James.Bottomley@suse.de> wrote:
> >> > On Thu, 2010-11-18 at 14:20 +0530, =E7=8E=8B=E7=A5=9E wrote:
> >> >> Hi
> >> >>
> >> >> I have enabled DMA for my host device and when i connect a scsi=
 device
> >> >> to the host, it crashes in the following code..
> >> >>
> >> >> Function: scsi_calculate_bounce_limit
> >> >>
> >> >>  if (host_dev && host_dev->dma_mask)
> >> >>                 bounce_limit =3D *host_dev->dma_mask;
> >> >>
> >> >> "*dma_mask" is illegal pointer operation. I would like to under=
stand
> >> >> is this known and is there reason behind such a code ?
> >> >
> >> > It likely means you're operating on a new architecture and its g=
eneric
> >> > devices haven't been set up correctly.
> >>
> >> Could you please more specific on what is generic devices haven't =
been
> >> setup properly...
> >
> > It means the architecture setup code left a NULL pointer in the gen=
eric
> > device which shouldn't be there ... without knowing which architect=
ure
> > and seeing the code, it's pretty impossible to be more specific.
>=20
> It is for ARM and the error is not due to NULL pointer. The code just
> checks if it is host mode + dma enabled and it access a normal
> interger variable with indirection causing the crash;

OK, it's crashing because the pointer isn't set up correctly ... is tha=
t
more semantically accurate?

The pointer setup is done in the arch code, so that's where the problem
is.

> int dma_mask;

That's not the definition in struct device; this is:

        u64             *dma_mask;      /* dma mask (if dma'able device=
) */


> and accessing dma_mask as "*dma_mask" ??
>=20
> Anything I am missing :O

Yes, but you supply too little information to know what.  It's
definitely a problem somewhere in the arch setup code.

James


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
