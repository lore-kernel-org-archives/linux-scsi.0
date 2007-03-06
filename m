From: Douglas Gilbert <dougg@torque.net>
Subject: Re: bug or typo in scsi_debug.c
Date: Tue, 06 Mar 2007 09:22:54 -0500
Message-ID: <45ED793E.9050200@torque.net>
References: <B3E98EAC5926D5498DDD341AE4B7D21CD5289C@TUS1XCHCLUPIN06.enterprise.veritas.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:42588 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965059AbXCFOXl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2007 09:23:41 -0500
In-Reply-To: <B3E98EAC5926D5498DDD341AE4B7D21CD5289C@TUS1XCHCLUPIN06.enterprise.veritas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Harvey <mark_harvey@symantec.com>
Cc: linux-scsi@vger.kernel.org

Mark Harvey wrote:
> Looking thru this driver, I saw what looks to be a bug/typo if an error
> occurs when
> calling driver_register() from scsi_debug_init()
> 
> Cheers
> Mark
> 
> --- scsi_debug-orig.c   2007-03-03 19:38:23.000000000 +1100
> +++ scsi_debug.c        2007-03-03 19:39:51.000000000 +1100
> @@ -2841,7 +2841,7 @@
>         if (ret < 0) {
>                 printk(KERN_WARNING "scsi_debug: driver_register error:
> %d\n",
>                         ret);
> -               goto bus_unreg;
> +               goto driver_unreg;
>         }
>         ret = do_create_driverfs_files();
>         if (ret < 0) {
> @@ -2873,6 +2873,7 @@
> 
>  del_files:
>         do_remove_driverfs_files();
> +driver_unreg:
>         driver_unregister(&sdebug_driverfs_driver);
>  bus_unreg:
>         bus_unregister(&pseudo_lld_bus);


Mark,
Um, I know my name is on that driver (with Eric's)
but I didn't write the code in that function.

I don't understand why your patch wants to call
driver_unregister() after driver_register() has failed.

Doug Gilbert
