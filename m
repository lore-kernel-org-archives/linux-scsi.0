From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper
Date: Wed, 14 Feb 2018 11:40:35 -0800
Message-ID: <1518637235.3223.32.camel@linux.vnet.ibm.com>
References: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50244 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1162873AbeBNTks (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 14:40:48 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1EJdxg8133405
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 14:40:48 -0500
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2g4r9r0djk-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 14:40:42 -0500
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 14 Feb 2018 14:40:41 -0500
In-Reply-To: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Wed, 2018-02-14 at 20:10 +0200, Andy Shevchenko wrote:
> Since we have a writeq() for 32-bit architectures as provided by IO
> non-atomic helpers, there is no need to open code it.
> 
> Moreover sparse complains about this:
> 
> drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: expected unsigned long
> long val
> drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: got restricted __le64
> <noident>
> 
> Fixing this by replacing custom writeq() with one provided by
> io-64-nonatomic-lo-hi.h header.
> 
> Reported-by: kbuild test robot <fengguang.wu@intel.com>
> Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> ---
>  drivers/scsi/mpt3sas/mpt3sas_base.c | 14 +++-----------
>  1 file changed, 3 insertions(+), 11 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c
> b/drivers/scsi/mpt3sas/mpt3sas_base.c
> index 59a87ca328d3..a92ab4a801d7 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
> @@ -56,6 +56,7 @@
>  #include <linux/interrupt.h>
>  #include <linux/dma-mapping.h>
>  #include <linux/io.h>
> +#include <linux/io-64-nonatomic-lo-hi.h>
>  #include <linux/time.h>
>  #include <linux/ktime.h>
>  #include <linux/kthread.h>
> @@ -2968,16 +2969,9 @@ mpt3sas_base_free_smid(struct MPT3SAS_ADAPTER
> *ioc, u16 smid)
>   * @writeq_lock: spin lock
>   *
>   * Glue for handling an atomic 64 bit word to MMIO. This special
> handling takes
> - * care of 32 bit environment where its not quarenteed to send the
> entire word
> + * care of 32 bit environment where its not guaranteed to send the
> entire word
>   * in one transfer.
>   */
> -#if defined(writeq) && defined(CONFIG_64BIT)
> -static inline void
> -_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> *writeq_lock)
> -{
> -	writeq(cpu_to_le64(b), addr);
> -}
> -#else
>  static inline void
>  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> *writeq_lock)
>  {
> @@ -2985,11 +2979,9 @@ _base_writeq(__u64 b, volatile void __iomem
> *addr, spinlock_t *writeq_lock)
>  	__u64 data_out = cpu_to_le64(b);
>  
>  	spin_lock_irqsave(writeq_lock, flags);
> -	writel((u32)(data_out), addr);
> -	writel((u32)(data_out >> 32), (addr + 4));
> +	writeq(data_out, addr);
>  	spin_unlock_irqrestore(writeq_lock, flags);
>  }
> -#endif

This would rather defeat the purpose of the original code, I think.
 The coding seems to indicate that if the platform can do a writeq
atomically (i.e. it's 64 bit and has the primitive) then it should and
not take the hit of using a lock.  Otherwise the 64 bit value is
updated by two 32 bit writes protected by a lock to ensure we don't get
interleaving of the write.

So I think you can replace the double writel with a lo_hi_writeq but
you have to lose the lock if the platform supports the atomic 64 bit
write for performance reasons.

James
