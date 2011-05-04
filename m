From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since
	writeq is not atomic
Date: Wed, 4 May 2011 13:42:20 -0600
Message-ID: <20110504194220.GA25875@parisc-linux.org>
References: <20110504110317.GA17855@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:34962 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab1EDTmX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 May 2011 15:42:23 -0400
Content-Disposition: inline
In-Reply-To: <20110504110317.GA17855@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, May 04, 2011 at 04:33:51PM +0530, Kashyap, Desai wrote:
> We need the 64 bit completed in one access pci memory write, else spin lock is required.
> Since it's going to be difficult to know which writeq was implemented in the kernel, 
> the driver is going to have to always acquire a spin lock each time we do 64bit write.
>   */
> -#ifndef writeq
>  static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>      spinlock_t *writeq_lock)
>  {
> @@ -1570,13 +1569,6 @@ static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>  	writel((u32)(data_out >> 32), (addr + 4));
>  	spin_unlock_irqrestore(writeq_lock, flags);
>  }
> -#else
> -static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
> -    spinlock_t *writeq_lock)
> -{
> -	writeq(cpu_to_le64(b), addr);
> -}
> -#endif
>  

Instead of taking out this optimisation (which is going to hurt massively
on 8-socket systems), why not simply change:

-#ifndef writeq
+#if BITS_PER_LONG < 64

(OK, there's an assumption that all 64-bit systems have an atomic 64-bit
MMIO store operation ... but I think that's a valid assumption).

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
