From: Andrew Morton <akpm@digeo.com>
Subject: Re: aic7xxx woes in 2.5
Date: Mon, 16 Dec 2002 11:08:46 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFE24BE.A8E3755F@digeo.com>
References: <3DFD9F89.4B994586@digeo.com> <32310000.1040064745@aslan.btc.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from digeo-nav01.digeo.com (digeo-nav01.digeo.com [192.168.1.233])
	by packet.digeo.com (8.9.3+Sun/8.9.3) with SMTP id LAA25371
	for <linux-scsi@vger.kernel.org>; Mon, 16 Dec 2002 11:08:48 -0800 (PST)
List-Id: linux-scsi@vger.kernel.org
To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Cc: linux-scsi@vger.kernel.org

"Justin T. Gibbs" wrote:
> 
> > The driver still has a serious bug in ahc_linux_queue_recovery_cmd().
> > It does
> >
> >       ahc_unlock(ahc, &s);
> 
> The sole ahc_unlock() in that routine looks like this:
> 
> #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
>                 ahc_unlock(ahc, &s);
> #else
>                 spin_unlock_irq(ahc->platform_data->host->host_lock);
> #endif
> 
> Since you are running 2.5.X, the ahc_unlock never occurs.
> In 2.4.X, ahd_midlayer_entrypoint_lock() saves the cpu flags
> for us, so the variable is never uninitialized in the case
> where it actually is compiled in.

In 2.5.52 uniprocessor a

	make drivers/scsi/aic7xxx/aic7xxx_linux.i

gives:

static __inline void
ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
{
        do { do { (void)(  &ahc->platform_data->spin_lock  ); } while(0) ; __asm__ __volatile__("pushl %0 ; popfl":   :"g" (   *flags  ):"memory", "cc") ; do { } while (0) ; } while (0) ;
}

Which is loading *flags into the CPU's interrupt status register.

On 2.5.52 SMP:

static __inline void
ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
{
        do { _raw_spin_unlock( &ahc->platform_data->spin_lock ); __asm__ __volatile__("pushl %0 ; popfl":   :"g" (   *flags  ):"memory", "cc") ; do { } while (0) ; } while (0) ;
}

ditto.


And it is being called from ahc_linux_queue_recovery_cmd:

        if (wait) {
                struct timer_list timer;
                int ret;

                ahc_unlock(ahc, &s);
                init_timer(&timer);

So I think the problem is still there.

> ..
> >
> > 1571                    while (slabp->inuse < cachep->num && batchcount--)
> > 1572                            ac_entry(ac)[ac->avail++] =
> > 1573                                    cache_alloc_one_tail(cachep,
> > slabp);
> >
> > Presumably due to errors in use of slab-allocated memory.
> 
> I'll look into this today.

Thanks.
 
> > I can debug further if you like, but would really appreciate unified
> > diffs, thanks.
> 
> Against???

The current devel kernel.  Nobody uses anything else, and if they
do, integration of diffs is much easier than a wholesale overwrite.

This is why everyone uses them.
