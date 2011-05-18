From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
	not atomic
Date: Tue, 17 May 2011 22:15:52 -0600
Message-ID: <20110518041551.GL15227@parisc-linux.org>
References: <20110504115324.GE17855@lsi.com> <1305616571.6008.23.camel@mulgrave.site> <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34272 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab1EREPx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 May 2011 00:15:53 -0400
Content-Disposition: inline
In-Reply-To: <B2FD678A64EAAD45B089B123FDFC3ED70157F7BCE5@inbmail01.lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>, benh@kernel.crashing.org, paulus@samba.org, linuxppc-dev@lists.ozlabs.org

On Wed, May 18, 2011 at 09:37:08AM +0530, Desai, Kashyap wrote:
> On Wed, 2011-05-04 at 17:23 +0530, Kashyap, Desai wrote:
> > The following code seems to be there in /usr/src/linux/arch/x86/include/asm/io.h.
> > This is not going to work.
> > 
> > static inline void writeq(__u64 val, volatile void __iomem *addr)
> > {
> >         writel(val, addr);
> >         writel(val >> 32, addr+4);
> > }
> > 
> > So with this code turned on in the kernel, there is going to be race condition 
> > where multiple cpus can be writing to the request descriptor at the same time.
> > 
> > Meaning this could happen:
> > (A) CPU A doest 32bit write
> > (B) CPU B does 32 bit write
> > (C) CPU A does 32 bit write
> > (D) CPU B does 32 bit write
> > 
> > We need the 64 bit completed in one access pci memory write, else spin lock is required.
> > Since it's going to be difficult to know which writeq was implemented in the kernel, 
> > the driver is going to have to always acquire a spin lock each time we do 64bit write.
> > 
> > Cc: stable@kernle.org
> > Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> > ---
> > diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > index efa0255..5778334 100644
> > --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> > +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> > @@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
> >   * care of 32 bit environment where its not quarenteed to send the entire word
> >   * in one transfer.
> >   */
> > -#ifndef writeq
> 
> Why not make this #ifndef CONFIG_64BIT?  You know that all 64 bit
> systems have writeq implemented correctly; you suspect 32 bit systems
> don't.
> 
> James
> 
> James, This issue was observed on PPC64 system. So what you have suggested will not solve this issue.
> If we are sure that writeq() is atomic across all architecture, we can use it safely. As we have seen issue on ppc64, we are not confident to use
> "writeq" call.

So have you told the powerpc people that they have a broken writeq?
And why do you obfuscate your report by talking about i386 when it's
really about powerpc64?

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
