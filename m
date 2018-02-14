From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper
Date: Wed, 14 Feb 2018 12:01:30 -0800
Message-ID: <1518638490.3223.37.camel@linux.vnet.ibm.com>
References: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
         <1518637235.3223.32.camel@linux.vnet.ibm.com>
         <1518637717.22495.344.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:42484 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S967798AbeBNUC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 14 Feb 2018 15:02:29 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w1EK2IH2020067
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 15:02:28 -0500
Received: from e15.ny.us.ibm.com (e15.ny.us.ibm.com [129.33.205.205])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2g4te13ckh-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 15:02:21 -0500
Received: from localhost
        by e15.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Wed, 14 Feb 2018 15:01:36 -0500
In-Reply-To: <1518637717.22495.344.camel@linux.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, MPT-FusionLinux.pdl@broadcom.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

On Wed, 2018-02-14 at 21:48 +0200, Andy Shevchenko wrote:
> On Wed, 2018-02-14 at 11:40 -0800, James Bottomley wrote:
> > 
> > On Wed, 2018-02-14 at 20:10 +0200, Andy Shevchenko wrote:
> > > 
> > > Since we have a writeq() for 32-bit architectures as provided by
> > > IO
> > > non-atomic helpers, there is no need to open code it.
> > > 
> > > Moreover sparse complains about this:
> > > 
> > > drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: expected unsigned
> > > long
> > > long val
> > > drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: got restricted
> > > __le64
> > > <noident>
> > > 
> > > Fixing this by replacing custom writeq() with one provided by
> > > io-64-nonatomic-lo-hi.h header.
> > > 
> 
> > 
> > > 
> > > -#if defined(writeq) && defined(CONFIG_64BIT)
> > > -static inline void
> > > -_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > > *writeq_lock)
> > > -{
> > > -	writeq(cpu_to_le64(b), addr);
> > > -}
> > > -#else
> > >  static inline void
> > >  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > > *writeq_lock)
> > >  {
> > > @@ -2985,11 +2979,9 @@ _base_writeq(__u64 b, volatile void
> > > __iomem
> > > *addr, spinlock_t *writeq_lock)
> > >  	__u64 data_out = cpu_to_le64(b);
> > >  
> > >  	spin_lock_irqsave(writeq_lock, flags);
> > > -	writel((u32)(data_out), addr);
> > > -	writel((u32)(data_out >> 32), (addr + 4));
> > > +	writeq(data_out, addr);
> > >  	spin_unlock_irqrestore(writeq_lock, flags);
> > >  }
> > > -#endif
> > 
> > This would rather defeat the purpose of the original code, I think.
> 
> James, TBH, I don't see any value of that lock. What it's protecting
> from? simultaneous thread doing writeq()? But this is pointless if at
> the same time you will have writel() to the device.

The lock prevents two threads doing an interleaved write to this
specific address which could be caused by two threads writing to the
same address.  If I remember correctly the firmware hangs in that case.

> For my opinion perhaps complete removal of the custom writeq() and
> replacing it by just writeq() with enabled non-atomic helpers will do
> the job.
> 
> The code is very old, and I have no idea why it's done this (strange)
> way.

The write seems to trigger starting the engine on the HBA if you look
at the code, which is why it must be written completely and in order.
 It's equivalent to a mailbox post.

James
