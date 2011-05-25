From: "Abhijeet Joglekar (abjoglek)" <abjoglek@cisco.com>
Subject: RE: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Wed, 25 May 2011 18:35:10 -0500
Message-ID: <13EBEADFAA5B5041B7FC8A3311E7DD1C044D22F3@XMB-RCD-104.cisco.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com> <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org> <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@infradead.org>
Cc: David Rientjes <rientjes@google.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: roland@purestorage.com [mailto:roland@purestorage.com] On Behal=
f
> Of Roland Dreier
> Sent: Wednesday, May 25, 2011 12:29 PM
> To: Christoph Hellwig
> Cc: David Rientjes; James E.J. Bottomley; Pekka Enberg; Christoph
> Lameter; linux-scsi@vger.kernel.org; linux-kernel@vger.kernel.org;
> Abhijeet Joglekar (abjoglek); Joe Eykholt
> Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FN=
IC
>=20
> On Wed, May 25, 2011 at 1:04 AM, Christoph Hellwig <hch@infradead.org=
>
> wrote:
> >> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache,
> which is
> >> not possible if CONFIG_ZONE_DMA is disasbled. =A0Avoid compiling i=
t
> without
> >> DMA support.
> >
> > And you're sure it actually needs it and isn't some sort of typo? =A0=
It
> > might help to Cc the maintainer to figure that out.
>=20
> Yes, almost certainly it is due to a misunderstanding of what
> SLAB_CACHE_DMA means.
> (fnic is a modern PCIe device that doesn't have 24-bit DMA restrictio=
ns
> ;)
>=20
> So the correct fix would likely be to delete the SLAB_CACHE_DMA from
> the driver.
>=20
> In any case cc'ing Cisco people as hch suggested...
>=20
>  - R.

You are right, fnic hardware does not have any 24-bit DMA restrictions.=
 When I coded it up, I misunderstood the flag as something that is requ=
ired for allocating memory that hardware DMAs in/out of.

As Roland indicated, the correct fix would be to remove the SLAB_CACHE_=
DMA flag from the call to kmem_cache, and the GFP_DMA from the call to =
the mempool allocation routine.

I can create a patch (attributing the fix to David and Roland) and send=
 out for review. Or if David wants, he can modify the patch he submitte=
d to include this fix. David, please let me know how you want to procee=
d.

Thanks
-- abhijeet
