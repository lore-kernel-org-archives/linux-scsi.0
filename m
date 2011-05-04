From: "Desai, Kashyap" <Kashyap.Desai@lsi.com>
Subject: RE: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since writeq
 is not atomic
Date: Wed, 4 May 2011 17:02:00 +0530
Message-ID: <B2FD678A64EAAD45B089B123FDFC3ED70157F09DBB@inbmail01.lsi.com>
References: <20110504110317.GA17855@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35739 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752355Ab1EDLaf convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 4 May 2011 07:30:35 -0400
In-Reply-To: <20110504110317.GA17855@lsi.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "Moore, Eric" <Eric.Moore@lsi.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>

Please ignore this patch.
Subject line is messed up.

I am going to resend with subject line fixed.


> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Kashyap, Desai
> Sent: Wednesday, May 04, 2011 4:34 PM
> To: linux-scsi@vger.kernel.org
> Cc: James.Bottomley@HansenPartnership.com; Moore, Eric; Prakash, Sathya
> Subject: [PATCH 1/3] mpt2sas: removetheuseofwriteq@lsi.com, since
> writeq is not atomic
> 
> 
> The following code seems to be there in
> /usr/src/linux/arch/x86/include/asm/io.h.
> This is not going to work.
> 
> static inline void writeq(__u64 val, volatile void __iomem *addr)
> {
>         writel(val, addr);
>         writel(val >> 32, addr+4);
> }
> 
> So with this code turned on in the kernel, there is going to be race
> condition
> where multiple cpus can be writing to the request descriptor at the
> same time.
> 
> Meaning this could happen:
> (A) CPU A doest 32bit write
> (B) CPU B does 32 bit write
> (C) CPU A does 32 bit write
> (D) CPU B does 32 bit write
> 
> We need the 64 bit completed in one access pci memory write, else spin
> lock is required.
> Since it's going to be difficult to know which writeq was implemented
> in the kernel,
> the driver is going to have to always acquire a spin lock each time we
> do 64bit write.
> 
> Cc: stable@kernle.org
> Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
> ---
> diff --git a/drivers/scsi/mpt2sas/mpt2sas_base.c
> b/drivers/scsi/mpt2sas/mpt2sas_base.c
> index efa0255..5778334 100644
> --- a/drivers/scsi/mpt2sas/mpt2sas_base.c
> +++ b/drivers/scsi/mpt2sas/mpt2sas_base.c
> @@ -1558,7 +1558,6 @@ mpt2sas_base_free_smid(struct MPT2SAS_ADAPTER
> *ioc, u16 smid)
>   * care of 32 bit environment where its not quarenteed to send the
> entire word
>   * in one transfer.
>   */
> -#ifndef writeq
>  static inline void _base_writeq(__u64 b, volatile void __iomem *addr,
>      spinlock_t *writeq_lock)
>  {
> @@ -1570,13 +1569,6 @@ static inline void _base_writeq(__u64 b,
> volatile void __iomem *addr,
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
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
