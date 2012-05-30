From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v2 4/4] scsi: cleanup usages of scsi_complete_async_scans
Date: Wed, 30 May 2012 23:41:21 +0200
Message-ID: <201205302341.21821.rjw@sisk.pl>
References: <20120530182016.23574.11056.stgit@dwillia2-linux.jf.intel.com> <20120530182145.23574.5156.stgit@dwillia2-linux.jf.intel.com> <201205302334.12247.rjw@sisk.pl>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ogre.sisk.pl ([193.178.161.156]:45209 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754199Ab2E3VgR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 May 2012 17:36:17 -0400
In-Reply-To: <201205302334.12247.rjw@sisk.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Len Brown <len.brown@intel.com>, mroos@linux.ee, Arjan van de Ven <arjan@linux.intel.com>, James Bottomley <JBottomley@parallels.com>

On Wednesday, May 30, 2012, Rafael J. Wysocki wrote:
> On Wednesday, May 30, 2012, Dan Williams wrote:
> > Now that scsi registers its async scan work with the async subsystem,
> > wait_for_device_probe() is sufficient for ensuring all scanning is
> > complete.
> > 
> > Cc: Arjan van de Ven <arjan@linux.intel.com>
> > Cc: Len Brown <len.brown@intel.com>
> > Cc: Rafael J. Wysocki <rjw@sisk.pl>
> > Cc: James Bottomley <JBottomley@parallels.com>
> > Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> > ---
> >  drivers/scsi/scsi_scan.c      |   12 ------------
> >  drivers/scsi/scsi_wait_scan.c |   15 +++++----------
> >  include/scsi/scsi_scan.h      |   11 -----------
> >  kernel/power/hibernate.c      |    8 --------
> >  kernel/power/user.c           |    2 --
> >  5 files changed, 5 insertions(+), 43 deletions(-)
> >  delete mode 100644 include/scsi/scsi_scan.h
> > 
> > diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > index fb42aa0..20c7108 100644
> > --- a/drivers/scsi/scsi_scan.c
> > +++ b/drivers/scsi/scsi_scan.c
> > @@ -184,18 +184,6 @@ int scsi_complete_async_scans(void)
> >  	return 0;
> >  }
> >  
> > -/* Only exported for the benefit of scsi_wait_scan */
> > -EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
> > -
> > -#ifndef MODULE
> > -/*
> > - * For async scanning we need to wait for all the scans to complete before
> > - * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
> > - * yet.
> > - */
> > -late_initcall(scsi_complete_async_scans);
> > -#endif
> > -
> >  /**
> >   * scsi_unlock_floptical - unlock device via a special MODE SENSE command
> >   * @sdev:	scsi device to send command to
> > diff --git a/drivers/scsi/scsi_wait_scan.c b/drivers/scsi/scsi_wait_scan.c
> > index 74708fc..57de24a 100644
> > --- a/drivers/scsi/scsi_wait_scan.c
> > +++ b/drivers/scsi/scsi_wait_scan.c
> > @@ -12,21 +12,16 @@
> >  
> >  #include <linux/module.h>
> >  #include <linux/device.h>
> > -#include <scsi/scsi_scan.h>
> >  
> >  static int __init wait_scan_init(void)
> >  {
> >  	/*
> > -	 * First we need to wait for device probing to finish;
> > -	 * the drivers we just loaded might just still be probing
> > -	 * and might not yet have reached the scsi async scanning
> > +	 * This will not return until all async work (system wide) is
> > +	 * quiesced.  Probing queues host-scanning work to the async
> > +	 * queue which is why we don't need a separate call to
> > +	 * scsi_complete_async_scans()
> >  	 */
> >  	wait_for_device_probe();
> > -	/*
> > -	 * and then we wait for the actual asynchronous scsi scan
> > -	 * to finish.
> > -	 */
> > -	scsi_complete_async_scans();
> >  	return 0;
> >  }
> >  
> > @@ -38,5 +33,5 @@ MODULE_DESCRIPTION("SCSI wait for scans");
> >  MODULE_AUTHOR("James Bottomley");
> >  MODULE_LICENSE("GPL");
> >  
> > -late_initcall(wait_scan_init);
> > +module_init(wait_scan_init);
> >  module_exit(wait_scan_exit);
> > diff --git a/include/scsi/scsi_scan.h b/include/scsi/scsi_scan.h
> > deleted file mode 100644
> > index 7889888..0000000
> > --- a/include/scsi/scsi_scan.h
> > +++ /dev/null
> > @@ -1,11 +0,0 @@
> > -#ifndef _SCSI_SCSI_SCAN_H
> > -#define _SCSI_SCSI_SCAN_H
> > -
> > -#ifdef CONFIG_SCSI
> > -/* drivers/scsi/scsi_scan.c */
> > -extern int scsi_complete_async_scans(void);
> > -#else
> > -static inline int scsi_complete_async_scans(void) { return 0; }
> > -#endif
> > -
> > -#endif /* _SCSI_SCSI_SCAN_H */
> > diff --git a/kernel/power/hibernate.c b/kernel/power/hibernate.c
> > index e09dfbf..821114a 100644
> > --- a/kernel/power/hibernate.c
> > +++ b/kernel/power/hibernate.c
> > @@ -25,7 +25,6 @@
> >  #include <linux/freezer.h>
> >  #include <linux/gfp.h>
> >  #include <linux/syscore_ops.h>
> > -#include <scsi/scsi_scan.h>
> >  
> >  #include "power.h"
> >  
> > @@ -735,13 +734,6 @@ static int software_resume(void)
> >  			async_synchronize_full();
> >  		}
> >  
> > -		/*
> > -		 * We can't depend on SCSI devices being available after loading
> > -		 * one of their modules until scsi_complete_async_scans() is
> > -		 * called and the resume device usually is a SCSI one.
> > -		 */
> > -		scsi_complete_async_scans();
> > -
> 
> I believe this is wrong.  You're going to introduce a regression on systems
> using built-in hibernation and built-in SCSI stack.

Ah, wait.  Do I understand correctly that wait_for_device_probe()
is now going to do an equivalent of scsi_complete_async_scans()?

If so, that should work, in which case please disregard my previous
messages in this thread.

Thanks,
Rafael

