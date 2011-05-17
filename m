From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/3] mpt2sas: remove the use of writeq, since writeq is
 not atomic
Date: Tue, 17 May 2011 11:16:11 +0400
Message-ID: <1305616571.6008.23.camel@mulgrave.site>
References: <20110504115324.GE17855@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35542 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752687Ab1EQHQS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2011 03:16:18 -0400
In-Reply-To: <20110504115324.GE17855@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Wed, 2011-05-04 at 17:23 +0530, Kashyap, Desai wrote:
> The following code seems to be there in /usr/src/linux/arch/x86/include/asm/io.h.
> This is not going to work.
> 
> static inline void writeq(__u64 val, volatile void __iomem *addr)
> {
>         writel(val, addr);
>         writel(val >> 32, addr+4);
> }
> 
> So with this code turned on in the kernel, there is going to be race condition 
> where multiple cpus can be writing to the request descriptor at the same time.
> 
> Meaning this could happen:
> (A) CPU A doest 32bit write
> (B) CPU B does 32 bit write
> (C) CPU A does 32 bit write
> (D) CPU B does 32 bit write
> 
> We need the 64 bit completed in one access pci memory write, else spin lock is required.
> Since it's going to be difficult to know which writeq was implemented in the kernel, 
> the driver is going to have to always acquire a spin lock each time we do 64bit write.
> 
> Cc: stable@kernle.org
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index efa0255..5778334 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER *ioc, u16 smid)
>   * care of 32 bit environment where its not quarenteed to send the entire word
>   * in one transfer.
>   */
> -#ifndef writeq

Why not make this #ifndef CONFIG_64BIT?  You know that all 64 bit
systems have writeq implemented correctly; you suspect 32 bit systems
don't.

James

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
>  /**
>   * mpt2sas_base_put_smid_scsi_io - send SCSI_IO request to firmware
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


