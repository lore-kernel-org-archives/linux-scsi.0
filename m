From: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Subject: RE: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper
Date: Wed, 14 Feb 2018 15:15:34 -0700
Message-ID: <012d4d61d1ea05a90f48738f3744fae9@mail.gmail.com>
References: <20180214181034.36529-1-andriy.shevchenko@linux.intel.com>
         <1518637235.3223.32.camel@linux.vnet.ibm.com>   <1518637717.22495.344.camel@linux.intel.com>
 <1518638490.3223.37.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:44929 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1031527AbeBNWPg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Feb 2018 17:15:36 -0500
Received: by mail-ot0-f195.google.com with SMTP id 79so1596607oth.11
        for <linux-scsi@vger.kernel.org>; Wed, 14 Feb 2018 14:15:36 -0800 (PST)
In-Reply-To: <1518638490.3223.37.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@linux.vnet.ibm.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, PDL-MPT-FUSIONLINUX <mpt-fusionlinux.pdl@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

The writeq is defined to ensure both the registers are written without any
interleaved access in between the two writels in 32 bit systems.  Also we
want to retain the order of writing the registers.  If needed I can dig out
the issue we have faced using writeq in 32 bit systems (happened five/six
years back).  So I would prefer leave the code as it is.

Thanks
Sathya
-----Original Message-----
From: mpt-fusionlinux.pdl@broadcom.com
[mailto:mpt-fusionlinux.pdl@broadcom.com] On Behalf Of James Bottomley
Sent: Wednesday, February 14, 2018 1:02 PM
To: Andy Shevchenko; Sathya Prakash; Chaitra P B; Suganath Prabu Subramani;
MPT-FusionLinux.pdl@broadcom.com; Martin K. Petersen;
linux-scsi@vger.kernel.org
Subject: Re: [PATCH v1] scsi: mpt3sas: Use lo_hi_writeq() helper

On Wed, 2018-02-14 at 21:48 +0200, Andy Shevchenko wrote:
> On Wed, 2018-02-14 at 11:40 -0800, James Bottomley wrote:
> >
> > On Wed, 2018-02-14 at 20:10 +0200, Andy Shevchenko wrote:
> > >
> > > Since we have a writeq() for 32-bit architectures as provided by
> > > IO non-atomic helpers, there is no need to open code it.
> > >
> > > Moreover sparse complains about this:
> > >
> > > drivers/scsi/mpt3sas/mpt3sas_base.c:2975:16: expected unsigned
> > > long long val
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
> > > -#if defined(writeq) && defined(CONFIG_64BIT) -static inline void
> > > -_base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > > *writeq_lock)
> > > -{
> > > -	writeq(cpu_to_le64(b), addr);
> > > -}
> > > -#else
> > >  static inline void
> > >  _base_writeq(__u64 b, volatile void __iomem *addr, spinlock_t
> > > *writeq_lock)
> > >  {
> > > @@ -2985,11 +2979,9 @@ _base_writeq(__u64 b, volatile void __iomem
> > > *addr, spinlock_t *writeq_lock)
> > >  	__u64 data_out = cpu_to_le64(b);
> > >
> > >  	spin_lock_irqsave(writeq_lock, flags);
> > > -	writel((u32)(data_out), addr);
> > > -	writel((u32)(data_out >> 32), (addr + 4));
> > > +	writeq(data_out, addr);
> > >  	spin_unlock_irqrestore(writeq_lock, flags);
> > >  }
> > > -#endif
> >
> > This would rather defeat the purpose of the original code, I think.
>
> James, TBH, I don't see any value of that lock. What it's protecting
> from? simultaneous thread doing writeq()? But this is pointless if at
> the same time you will have writel() to the device.

The lock prevents two threads doing an interleaved write to this specific
address which could be caused by two threads writing to the same address.
If I remember correctly the firmware hangs in that case.

> For my opinion perhaps complete removal of the custom writeq() and
> replacing it by just writeq() with enabled non-atomic helpers will do
> the job.
>
> The code is very old, and I have no idea why it's done this (strange)
> way.

The write seems to trigger starting the engine on the HBA if you look at the
code, which is why it must be written completely and in order.
 It's equivalent to a mailbox post.

James
