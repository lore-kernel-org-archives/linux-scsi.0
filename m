From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build fix] Re: [GIT PATCH] SCSI part 1
Date: Wed, 16 Jul 2008 16:18:05 +0200
Message-ID: <20080716141805.GB22631@elte.hu>
References: <1216138543.3312.60.camel@localhost.localdomain> <20080716101634.GA8494@elte.hu> <20080716103337.GA22931@elte.hu> <20080716131543.GA3673@elte.hu> <1216216320.3230.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:47021 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756751AbYGPOSS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 16 Jul 2008 10:18:18 -0400
Content-Disposition: inline
In-Reply-To: <1216216320.3230.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>


* James Bottomley <James.Bottomley@HansenPartnership.com> wrote:

> On Wed, 2008-07-16 at 15:15 +0200, Ingo Molnar wrote:
> > * Ingo Molnar <mingo@elte.hu> wrote:
> > 
> > > > scsi_cmnd.h depends on symbols defined in blkdev.h. The fix is to 
> > > > include blkdev.h as well.
> > > 
> > > that wont work - a better replacement fix is the one below. The 
> > > problem is that scsi.h is included even on !CONFIG_BLOCK and then the 
> > > BLK_MAX_CDB symbol is meaningless.
> > 
> > -v3 .. the new methods need to be under #ifdef CONFIG_BLOCK as well. 
> > Note my patch is just a quick RFC, this can probably be done 
> > cleaner.
> 
> Erm, Ingo, if you'd just follow linux-next instead of your own tree, 
> you'd see there's already a fix for this.

Erm, no. In the merge window i follow upstream -git, not "my tree", and 
i searched lkml for the build failure signature and it had nothing 
there. Then i looked at the commit and it said that it was created just 
1 day before the merge window started:

 commit feac6a07c4a3578bffd6769bb4927e8a7e1f3ffe
 Author:     Martin Petermann <martin@linux.vnet.ibm.com>
 AuthorDate: Wed Jul 2 10:56:35 2008 +0200
 Commit:     James Bottomley <James.Bottomley@HansenPartnership.com>
 CommitDate: Sat Jul 12 08:22:34 2008 -0500
                 ^^^^^^

So i didnt even think of it having hit linux-next so i didnt look into 
the linux-next archives. lkml should have been Cc:-ed in this case, 
that's where people look for in case of upstream breakages. You would 
have saved me some effort via that - please try to do it in the future, 
it's very helpful to testers.

btw., about the technical aspects of the solution, i'm not sure i like 
these big #ifdef blocks:

> --- linux-next-20080708.orig/fs/compat_ioctl.c
> +++ linux-next-20080708/fs/compat_ioctl.c
> @@ -68,9 +68,11 @@
>  #include <linux/capi.h>
>  #include <linux/gigaset_dev.h>
>  
> +#ifdef CONFIG_BLOCK
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_ioctl.h>
>  #include <scsi/sg.h>
> +#endif
>  
>  #include <asm/uaccess.h>
>  #include <linux/ethtool.h>
> @@ -1965,6 +1967,7 @@ COMPATIBLE_IOCTL(GIO_UNISCRNMAP)
>  COMPATIBLE_IOCTL(PIO_UNISCRNMAP)
>  COMPATIBLE_IOCTL(PIO_FONTRESET)
>  COMPATIBLE_IOCTL(PIO_UNIMAPCLR)
> +#ifdef CONFIG_BLOCK
>  /* Big S */
>  COMPATIBLE_IOCTL(SCSI_IOCTL_GET_IDLUN)
>  COMPATIBLE_IOCTL(SCSI_IOCTL_DOORLOCK)
> @@ -1974,6 +1977,7 @@ COMPATIBLE_IOCTL(SCSI_IOCTL_GET_BUS_NUMB
>  COMPATIBLE_IOCTL(SCSI_IOCTL_SEND_COMMAND)
>  COMPATIBLE_IOCTL(SCSI_IOCTL_PROBE_HOST)
>  COMPATIBLE_IOCTL(SCSI_IOCTL_GET_PCI)
> +#endif
>  /* Big T */
>  COMPATIBLE_IOCTL(TUNSETNOCSUM)
>  COMPATIBLE_IOCTL(TUNSETDEBUG)
> @@ -2044,6 +2048,7 @@ COMPATIBLE_IOCTL(SIOCGIFVLAN)
>  COMPATIBLE_IOCTL(SIOCSIFVLAN)
>  COMPATIBLE_IOCTL(SIOCBRADDBR)
>  COMPATIBLE_IOCTL(SIOCBRDELBR)
> +#ifdef CONFIG_BLOCK
>  /* SG stuff */
>  COMPATIBLE_IOCTL(SG_SET_TIMEOUT)
>  COMPATIBLE_IOCTL(SG_GET_TIMEOUT)
> @@ -2068,6 +2073,7 @@ COMPATIBLE_IOCTL(SG_SCSI_RESET)
>  COMPATIBLE_IOCTL(SG_GET_REQUEST_TABLE)
>  COMPATIBLE_IOCTL(SG_SET_KEEP_ORPHAN)
>  COMPATIBLE_IOCTL(SG_GET_KEEP_ORPHAN)
> +#endif
>  /* PPP stuff */
>  COMPATIBLE_IOCTL(PPPIOCGFLAGS)
>  COMPATIBLE_IOCTL(PPPIOCSFLAGS)

the clean solution we use everywhere else is to push such #ifdefs into 
the headers, to make them generally includable. For example you can 
include lockdep.h even if you dont have lockdep enabled, you can include 
smp.h even on UP-only files, etc. etc.

	Ingo
