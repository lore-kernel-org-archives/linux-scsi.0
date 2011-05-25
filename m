From: Roland Dreier <roland@kernel.org>
Subject: Re: [patch 3/6] scsi, fnic: require DMA support for Cisco FNIC
Date: Wed, 25 May 2011 12:28:33 -0700
Message-ID: <BANLkTi=Jc11hO3KXWFUaX1pia-MGa2SV+A@mail.gmail.com>
References: <alpine.DEB.2.00.1105241650230.29780@chino.kir.corp.google.com>
 <alpine.DEB.2.00.1105241651350.29780@chino.kir.corp.google.com> <20110525080409.GA16582@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110525080409.GA16582@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: David Rientjes <rientjes@google.com>, "James E.J. Bottomley" <James.Bottomley@suse.de>, Pekka Enberg <penberg@kernel.org>, Christoph Lameter <cl@linux.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Abhijeet Joglekar <abjoglek@cisco.com>, Joe Eykholt <jeykholt@cisco.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, May 25, 2011 at 1:04 AM, Christoph Hellwig <hch@infradead.org> =
wrote:
>> The Cisco FNIC driver requires creating a SLAB_CACHE_DMA cache, whic=
h is
>> not possible if CONFIG_ZONE_DMA is disasbled. =A0Avoid compiling it =
without
>> DMA support.
>
> And you're sure it actually needs it and isn't some sort of typo? =A0=
It
> might help to Cc the maintainer to figure that out.

Yes, almost certainly it is due to a misunderstanding of what
SLAB_CACHE_DMA means.
(fnic is a modern PCIe device that doesn't have 24-bit DMA restrictions=
 ;)

So the correct fix would likely be to delete the SLAB_CACHE_DMA from th=
e driver.

In any case cc'ing Cisco people as hch suggested...

 - R.
