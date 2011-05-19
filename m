From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Thu, 19 May 2011 08:46:00 +0400
Message-ID: <1305780360.2576.20.camel@mulgrave.site>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
	 <1305692584.2580.3.camel@mulgrave.site> <1305702010.2781.33.camel@pasglop>
	 <mpt2sas-writeq-powerpc64@mdm.bga.com>
	 <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
	 <x86-32-writeq-is-broken@mdm.bga.com>
	 <4565AEA676113A449269C2F3A549520F80BE7F37@cosmail03.lsi.com>
	 <BANLkTin4w1QyL1NyTyrZARPWASai45W_4Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <BANLkTin4w1QyL1NyTyrZARPWASai45W_4Q@mail.gmail.com>
Sender: linux-arch-owner@vger.kernel.org
To: Hitoshi Mitake <h.mitake@gmail.com>
Cc: "Moore, Eric" <Eric.Moore@lsi.com>, Milton Miller <miltonm@bga.com>, Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Matthew Wilcox <matthew@wil.cx>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linux scsi dev <linux-scsi@vger.kernel.org>, "paulus@samba.org" <paulus@samba.org>, linux powerpc dev <linuxppc-dev@lists.ozlabs.org>, linux pci <linux-pci@vger.kernel.org>, linux kernel <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-19 at 13:08 +0900, Hitoshi Mitake wrote:
> On Thu, May 19, 2011 at 04:11, Moore, Eric <Eric.Moore@lsi.com> wrote:
> > On Wednesday, May 18, 2011 12:31 PM Milton Miller wrote:
> >> Ingo I would propose the following commits added in 2.6.29 be reverted.
> >> I think the current concensus is drivers must know if the writeq is
> >> not atomic so they can provide their own locking or other workaround.
> >>
> >
> >
> > Exactly.
> >
> 
> The original motivation of preparing common readq/writeq is that
> letting each driver
> have their own readq/writeq is bad for maintenance of source code.
> 
> But if you really dislike them, there might be two solutions:
> 
> 1. changing the name of readq/writeq to readq_nonatomic/writeq_nonatomic

This is fine, but not really very useful

> 2. adding new C file to somewhere and defining spinlock for them.
>     With spin_lock_irqsave() and spin_unlock_irqrestore() on the spinlock,
>     readq/writeq can be atomic.

This can't really be done generically.  There are several considerations
to do with hardware requirements.  I can see some hw requiring a
specific write order (I think this applies more to read order, though).

The specific mpt2sas problem is that if we write a 64 bit register non
atomically, we can't allow any interleaving writes for any other region
on the chip, otherwise the HW will take the write as complete in the 64
bit register and latch the wrong value.  The only way to achieve that
given the semantics of writeq is a global static spinlock.

> How do you think about them? If you cannot agree with the above two
> solutions, I'll agree with reverting them.

Having x86 roll its own never made any sense, so I think they need
reverting anyway.  This is a driver/platform bus problem not an
architecture problem.  The assumption we can make is that the platform
CPU can write atomically at its chip width.  We *may* be able to make
the assumption that the bus controller can translate an atomic chip
width transaction to a single atomic bus transaction; I think that
assumption holds true for at least PCI and on the parisc legacy busses,
so if we can agree on semantics, this should be a global define
somewhere.  If there are problems with the bus assumption, we'll likely
need some type of opt-in (or just not bother).

James
