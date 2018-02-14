From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: Re: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper
Date: Wed, 14 Feb 2018 21:48:37 +0200
Message-ID: <1518637717.22495.344.camel@linux.intel.com>
References: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
         <1518637235.3223.32.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:8486 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1163075AbeBNTsl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 14:48:41 -0500
In-Reply-To: <1518637235.3223.32.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Wed, 2018-02-14 at 11:40 -0800, James Bottomley wrote:
> On Wed, 2018-02-14 at 20:10 +0200, Andy Shevchenko wrote:
> > Since we have a writeq() for 32-bit architectures as provided by IO
> > non-atomic helpers, there is no need to open code it.
> > 
> > Moreover sparse complains about this:
> > 
> > drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: expected unsigned long
> > long val
> > drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: got restricted __le64
> > <noident>
> > 
> > Fixing this by replacing custom writeq() with one provided by
> > io-64-nonatomic-lo-hi.h header.
> > 

> > -#if defined(writeq) && defined(CONFIG_64BIT)
> > -static inline void
> > -_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > *writeq_lock)
> > -{
> > -	writeq(cpu_to_le64(b), addr);
> > -}
> > -#else
> >  static inline void
> >  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > *writeq_lock)
> >  {
> > @@ -2985,11 +2979,9 @@ _base_writeq(__u64 b, volatile void __iomem
> > *addr, spinlock_t *writeq_lock)
> >  	__u64 data_out = cpu_to_le64(b);
> >  
> >  	spin_lock_irqsave(writeq_lock, flags);
> > -	writel((u32)(data_out), addr);
> > -	writel((u32)(data_out >> 32), (addr + 4));
> > +	writeq(data_out, addr);
> >  	spin_unlock_irqrestore(writeq_lock, flags);
> >  }
> > -#endif
> 
> This would rather defeat the purpose of the original code, I think.

James, TBH, I don't see any value of that lock. What it's protecting
from? simultaneous thread doing writeq()? But this is pointless if at
the same time you will have writel() to the device.

For my opinion perhaps complete removal of the custom writeq() and
replacing it by just writeq() with enabled non-atomic helpers will do
the job.

The code is very old, and I have no idea why it's done this (strange)
way.

>  The coding seems to indicate that if the platform can do a writeq
> atomically (i.e. it's 64 bit and has the primitive) then it should and
> not take the hit of using a lock.  Otherwise the 64 bit value is
> updated by two 32 bit writes protected by a lock to ensure we don't
> get
> interleaving of the write.
> 
> So I think you can replace the double writel with a lo_hi_writeq but
> you have to lose the lock if the platform supports the atomic 64 bit
> write for performance reasons.


-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
