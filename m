From: "Justin T. Gibbs" <gibbs@scsiguy.com>
Subject: Re: aic7xxx woes in 2.5
Date: Mon, 16 Dec 2002 12:26:27 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <54180000.1040066787@aslan.btc.adaptec.com>
References: <3DFD9F89.4B994586@digeo.com>
 <32310000.1040064745@aslan.btc.adaptec.com> <3DFE24BE.A8E3755F@digeo.com>
Reply-To: "Justin T. Gibbs" <gibbs@scsiguy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFE24BE.A8E3755F@digeo.com>
Content-Disposition: inline
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

>> Since you are running 2.5.X, the ahc_unlock never occurs.
>> In 2.4.X, ahd_midlayer_entrypoint_lock() saves the cpu flags
>> for us, so the variable is never uninitialized in the case
>> where it actually is compiled in.
> 
> In 2.5.52 uniprocessor a
> 
> 	make drivers/scsi/aic7xxx/aic7xxx_linux.i
> 
> gives:
> 
> static __inline void
> ahc_unlock(struct ahc_softc *ahc, unsigned long *flags)
> {
>         do { do { (void)(  &ahc->platform_data->spin_lock  ); } while(0)
> ; __asm__ __volatile__("pushl %0 ; popfl":   :"g" (   *flags  ):"memory",
> "cc") ; do { } while (0) ; } while (0) ; }
> 
> Which is loading *flags into the CPU's interrupt status register.

Since I wrote the routine, I'm well aware of how it operates.

> And it is being called from ahc_linux_queue_recovery_cmd:
> 
>         if (wait) {
>                 struct timer_list timer;
>                 int ret;
> 
>                 ahc_unlock(ahc, &s);
>                 init_timer(&timer);

You must have botched the integration of the latest driver from here:
http://people.FreeBSD.org/~gibbs/linux/SRC.

I just downloaded it again (both the archive from the 10th and the 13th)
and neither use ahc_unlock under 2.5.X in ahc_linux_queue_recovery_cmd().
What are the $Id$ strings at the top of the file?

--
Justin
