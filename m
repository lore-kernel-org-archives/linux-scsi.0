From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since	writeq
 is not atomic
Date: Thu, 5 May 2011 12:29:50 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F09E3D@inbmail01.lsi.com>
References: <20110504110317.GA17855@lsi.com>
 <20110504194220.GA25875@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog112.obsmtp.com ([74.125.149.207]:45354 "EHLO
	na3sys009aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab1EEG61 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 May 2011 02:58:27 -0400
In-Reply-To: <20110504194220.GA25875@parisc-linux.org>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>



> -----Original Message-----
> From: Matthew Wilcox [mailto:matthew@wil.cx]
> Sent: Thursday, May 05, 2011 1:12 AM
> To: Desai, Kashyap
> Cc: linux-scsi@vger.kernel.org; James.Bottomley@HansenPartnership.com;
> Moore, Eric; Prakash, Sathya
> Subject: Re: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since
> writeq is not atomic
> 
> On Wed, May 04, 2011 at 04:33:51PM +0530, Kashyap, Desai wrote:
> > We need the 64 bit completed in one access pci memory write, else
> spin lock is required.
> > Since it's going to be difficult to know which writeq was implemented
> in the kernel,
> > the driver is going to have to always acquire a spin lock each time
> we do 64bit write.
> >   */
> > -#ifndef writeq
> >  static inline void _base_writeq(__u64 b, volatile void __iomem
> *addr,
> >      spinlock_t *writeq_lock)
> >  {
> > @@ -1570,13 +1569,6 @@ static inline void _base_writeq(__u64 b,
> volatile void __iomem *addr,
> >  	writel((u32)(data_out >> 32), (addr + 4));
> >  	spin_unlock_irqrestore(writeq_lock, flags);
> >  }
> > -#else
> > -static inline void _base_writeq(__u64 b, volatile void __iomem
> *addr,
> > -    spinlock_t *writeq_lock)
> > -{
> > -	writeq(cpu_to_le64(b), addr);
> > -}
> > -#endif
> >
> 
> Instead of taking out this optimisation (which is going to hurt
> massively
> on 8-socket systems), why not simply change:
> 
> -#ifndef writeq
> +#if BITS_PER_LONG < 64
> 
> (OK, there's an assumption that all 64-bit systems have an atomic 64-
> bit
> MMIO store operation ... but I think that's a valid assumption).

For powerpc64 arch " BITS_PER_LONG is defined as 64" and we have seen writeq() is not atomic for that particular case.
So question is for all 64 bit arch writeq() must be atomic. 


> 
> --
> Matthew Wilcox				Intel Open Source Technology Centre
> "Bill, look, we understand that you're interested in selling us this
> operating system, but compare it to ours.  We can't possibly take such
> a retrograde step."
