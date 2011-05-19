From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Thu, 19 May 2011 15:36:13 +1000
Message-ID: <1305783373.7481.44.camel@pasglop>
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
	 <1305780360.2576.20.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arch-owner@vger.kernel.org>
In-Reply-To: <1305780360.2576.20.camel@mulgrave.site>
Sender: linux-arch-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Hitoshi Mitake <h.mitake@gmail.com>, "Moore, Eric" <Eric.Moore@lsi.com>, Milton Miller <miltonm@bga.com>, Sam Ravnborg <sam@ravnborg.org>, Ingo Molnar <mingo@elte.hu>, Ingo Molnar <mingo@redhat.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, Matthew Wilcox <matthew@wil.cx>, linux scsi dev <linux-scsi@vger.kernel.org>, "paulus@samba.org" <paulus@samba.org>, linux powerpc dev <linuxppc-dev@lists.ozlabs.org>, linux pci <linux-pci@vger.kernel.org>, linux kernel <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Roland Dreier <roland@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-05-19 at 08:46 +0400, James Bottomley wrote:
> This can't really be done generically.  There are several considerations
> to do with hardware requirements.  I can see some hw requiring a
> specific write order (I think this applies more to read order, though).

Right. Or there can be a need for a completely different access pattern
to do 32-bit, or maybe write only one half because both might have a
side effect etc etc etc ...

Also a global lock would be suboptimal vs. a per device lock burried in
the driver.

> The specific mpt2sas problem is that if we write a 64 bit register non
> atomically, we can't allow any interleaving writes for any other region
> on the chip, otherwise the HW will take the write as complete in the 64
> bit register and latch the wrong value.  The only way to achieve that
> given the semantics of writeq is a global static spinlock.
> 
> > How do you think about them? If you cannot agree with the above two
> > solutions, I'll agree with reverting them.
> 
> Having x86 roll its own never made any sense, so I think they need
> reverting anyway. 

Agreed.

>  This is a driver/platform bus problem not an
> architecture problem.  The assumption we can make is that the platform
> CPU can write atomically at its chip width.  We *may* be able to make
> the assumption that the bus controller can translate an atomic chip
> width transaction to a single atomic bus transaction; I think that
> assumption holds true for at least PCI and on the parisc legacy busses,
> so if we can agree on semantics, this should be a global define
> somewhere.  If there are problems with the bus assumption, we'll likely
> need some type of opt-in (or just not bother).

And we want a well defined #ifdef drivers test to know whether there's a
writeq/readq (just #define writeq/readq itself is fine even if it's an
inline function, we do that elsewhere) so they can have a fallback
scenario.

This is important as these can be used in very performance critical code
path.

Cheers,
Ben.
