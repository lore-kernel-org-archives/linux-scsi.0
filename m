From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Wed, 18 May 2011 09:35:56 -0600
Message-ID: <4565AEA676113A449269C2F3A549520F80B66280@cosmail03.lsi.com>
References: <20110504115324.GE17855@lsi.com>
	 <1305616571.6008.23.camel@mulgrave.site>
	 <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
	 <20110518041551.GL15227@parisc-linux.org>
	 <1305692584.2580.3.camel@mulgrave.site>	<1305702010.2781.33.camel@pasglop>
 <mpt2sas-writeq-powerpc64@mdm.bga.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:50659 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756584Ab1ERPf6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 May 2011 11:35:58 -0400
In-Reply-To: <mpt2sas-writeq-powerpc64@mdm.bga.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Milton Miller <miltonm@bga.com>, "Desai, Kashyap" <Kashyap.Desai@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Matthew Wilcox <matthew@wil.cx>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "paulus@samba.org" <paulus@samba.org>, "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>

On Wednesday, May 18, 2011 2:24 AM, Milton Miller wrote:
> On Wed, 18 May 2011 around 17:00:10 +1000, Benjamin Herrenschmidt wrote:
> > (Just adding Milton to the CC list, he suspects races in the
> > driver instead).
> >
> > On Wed, 2011-05-18 at 08:23 +0400, James Bottomley wrote:
> > > On Tue, 2011-05-17 at 22:15 -0600, Matthew Wilcox wrote:
> > > > On Wed, May 18, 2011 at 09:37:08AM +0530, Desai, Kashyap wrote:
> > > > > On Wed, 2011-05-04 at 17:23 +0530, Kashyap, Desai wrote:
> > > > > > The following code seems to be there in
> /usr/src/linux/arch/x86/include/asm/io.h.
> > > > > > This is not going to work.
> > > > > >
> > > > > > static inline void writeq(__u64 val, volatile void __iomem *addr)
> > > > > > {
> > > > > >         writel(val, addr);
> > > > > >         writel(val >> 32, addr+4);
> > > > > > }
> > > > > >
> > > > > > So with this code turned on in the kernel, there is going to be
> race condition
> > > > > > where multiple cpus can be writing to the request descriptor at
> the same time.
> > > > > >
> > > > > > Meaning this could happen:
> > > > > > (A) CPU A doest 32bit write
> > > > > > (B) CPU B does 32 bit write
> > > > > > (C) CPU A does 32 bit write
> > > > > > (D) CPU B does 32 bit write
> > > > > >
> > > > > > We need the 64 bit completed in one access pci memory write, else
> spin lock is required.
> > > > > > Since it's going to be difficult to know which writeq was
> implemented in the kernel,
> > > > > > the driver is going to have to always acquire a spin lock each
> time we do 64bit write.
> > > > > >
> > > > > > Cc: stable@kernle.org
> > > > > > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > > > > > ---
> > > > > > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > > > > index efa0255..5778334 100644
> > > > > > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > > > > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > > > > > @@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct
> MPT2SAS_ADAPTER *ioc, u16 smid)
> > > > > >   * care of 32 bit environment where its not quarenteed to send
> the entire word
> > > > > >   * in one transfer.
> > > > > >   */
> > > > > > -#ifndef writeq
> > > > >
> > > > > Why not make this #ifndef CONFIG_64BIT?  You know that all 64 bit
> > > > > systems have writeq implemented correctly; you suspect 32 bit
> systems
> > > > > don't.
> > > > >
> > > > > James
> > > > >
> > > > > James, This issue was observed on PPC64 system. So what you have
> suggested will not solve this issue.
> > > > > If we are sure that writeq() is atomic across all architecture, we
> can use it safely. As we have seen issue on ppc64, we are not confident to
> use
> > > > > "writeq" call.
> > > >
> > > > So have you told the powerpc people that they have a broken writeq?
> > >
> > > I'm just in the process of finding them now on IRC so I can demand an
> > > explanation: this is a really serious API problem because writeq is
> > > supposed to be atomic on 64 bit.
> > >
> > > > And why do you obfuscate your report by talking about i386 when it's
> > > > really about powerpc64?
> > >
> > > James
> 
> I checked the assembly for my complied output and it ends up with
> a single std (store doubleword aka 64 bits) instruction with offset
> 192 decimal (0xc0) from the base register obtained from the structure.
> 
> An aligned doubleword store is atomic on 64 bit powerpc.
> 
> So I would really like more details if you are blaming 64 bit
> powerpc of a non-atomic store.
> 
> That said, the patch will affect the code by adding barriers.
> Specifically, while powerpc has a sync before doing the store as part
> of writeq, wrapping in a spinlock adds a sync before releasing the lock
> whenever a writeq (or writex x=b,w,d,q) was issued inside the lock.
> 
> (sync orders all reads and all writes to both memory and devices from
> that cpu).
> 
> But looking further at the code, I see such things as:
> 
> drivers/scsi/mpt2sas/mpt2sas_base.c  line 2944
> 
>         mpt2sas_base_put_smid_default(ioc, smid);
>         init_completion(&ioc->base_cmds.done);
>         timeleft = wait_for_completion_timeout(&ioc->base_cmds.done,
> 
> where mpt2sas_base_put_smid_default is a routine that has a call to
> _base_writeq.  This will initiate io to the adapter, then initialize
> the completion, then hope that the timeout is long enough to let the io
> complete and be marked done but short enough to not be a problem when
> the timeout occurs because we initialized the compeltion after the irq
> came in.
> 
> The code then looks at a status flag, but there is no indication how
> the access to that field is serialized between the interrupt handler
> and the submission routine.  It may mostly work due to barriers in
> the primitives but I don't see any statement of rules.
> 
> Also, while I see a few wmb before writel in _base_interrupt, I don't
> see any rmb, which I would expect between establishing a element is
> valid and reading other fields in that element.
> 
> So I'd really like to hear more about what your symptoms were and how
> you determined writeq on 64 bit powerpc was not atomic.
> 
> Milton


I worked the original defect a couple months ago, and Kashyap is now getting around to posting my patch's.

This original defect has nothing to do with PPC64.  The original problem was only on x86.    It only became a problem on PPC64 when I tried to fix the original x86 issue by copying the writeq code from the linux headers, then it broke PPC64.   I doubt that broken patch was ever posted. Anyways, back to the original defect.  The reason it because a problem for x86 is because the kernel headers had a implementation of writeq in the arch/x86 headers, which means our internal implementation of writeq is not being used.  The writeq implementation in the kernel is total wrong for arch/x86 because it doesn't not have spin locks, and if two processor simultaneously doing two separate 32bit pci writes, then what is received by controller firmware is out of order.   This change occurs between Red Ha
 t RHEL5 and RHEL6.  In RHEL5, this writeq was not implemented in arch/x86 headers, and our driver internal implementation of write was used.

Eric



