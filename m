From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: why does x86 "make defconfig" build a single, lonely module?
Date: Mon, 14 May 2007 09:31:36 -0500
Message-ID: <1179153096.3703.23.camel@mulgrave.il.steeleye.com>
References: <Pine.LNX.4.64.0705131106160.3197@localhost.localdomain>
	 <20070513160608.GA29024@redhat.com>
	 <1179072655.3723.42.camel@mulgrave.il.steeleye.com>
	 <1179073116.3723.45.camel@mulgrave.il.steeleye.com>
	 <a781481a0705140235h6a96563cw63ed2c7a85a4f736@mail.gmail.com>
	 <a781481a0705140245s6823df32l5bbf81abf92b0347@mail.gmail.com>
	 <a781481a0705140500q32a891d6g69b40c2d45ec40c6@mail.gmail.com>
	 <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:38750 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754532AbXENObt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 May 2007 10:31:49 -0400
In-Reply-To: <a781481a0705140523y789e012bj2ec317565e34366f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Satyam Sharma <satyam.sharma@gmail.com>
Cc: Dave Jones <davej@redhat.com>, "Robert P. J. Day" <rpjday@mindspring.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, 2007-05-14 at 17:53 +0530, Satyam Sharma wrote:
> > I guess this is probably the behaviour that James wanted originally?

No ... you're still not reading the explanation in the thread:

The wait scan module is designed to wait for scans of driver modules.
Whether SCSI=y or m has no effect on this ... you can still have modular
drivers with built in SCSI.

> > Anyway, attached patch (subsumes previous one) cleans up all this.
> > Now, scsi_wait_scan is the only guy who controls waiting upon async
> > scans to complete:
> >
> > If SCSI=n, SCSI_WAIT_SCAN=n, obviously.
> >
> > If SCSI=y, SCSI_WAIT_SCAN=y, so it gets built-in and is run at
> > late_initcall.
> >
> > If SCSI=m, SCSI_WAIT_SCAN=m too and would hopefully be run
> > by the initrd/initramfs scripts to wait for async SCSI bus scans to
> > finish before allowing the boot to proceed.
> >
> > [ Attached patch does _not_ expose SCSI_WAIT_SCAN to the
> > user at kernel configuration time, so if somebody wants it to be
> > built as a module even when SCSI=y (why would anybody
> > want that, doesn't make much sense to me to modprobe
> > scsi_wait_scan _after_ boot-up), it would not be possible to
> > do so. But if someone really wants that, let me know, we can
> > add a depends, tristate "..." and help in this Kconfig option to
> > accomplish that too. ]
> 
> This has sadly become a one-person thread, but Robert informs
> me in private mail that we can further clean/simplify the patch:
> 
> [subsumes both previous patches]
> 
> Signed-off-by: Satyam Sharma <satyam.sharma@gmail.com>
> 
> ---
> 
>  drivers/scsi/Kconfig     |    3 +--
>  drivers/scsi/scsi_scan.c |    5 +----
>  2 files changed, 2 insertions(+), 6 deletions(-)
> 
> ---
> 
> diff -ruNp a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> --- a/drivers/scsi/Kconfig	2007-05-10 23:19:32.000000000 +0530
> +++ b/drivers/scsi/Kconfig	2007-05-14 17:59:51.000000000 +0530
> @@ -243,9 +243,8 @@ config SCSI_SCAN_ASYNC
> 
>  config SCSI_WAIT_SCAN
>  	tristate
> -	default m
>  	depends on SCSI
> -	depends on MODULES
> +	default SCSI
> 
>  menu "SCSI Transports"
>  	depends on SCSI
> diff -ruNp a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c	2007-05-14 16:06:43.000000000 +0530
> +++ b/drivers/scsi/scsi_scan.c	2007-05-14 16:10:34.000000000 +0530
> @@ -184,14 +184,11 @@ int scsi_complete_async_scans(void)
>  /* Only exported for the benefit of scsi_wait_scan */
>  EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
> 
> -#ifndef MODULE
>  /*
>   * For async scanning we need to wait for all the scans to complete before
>   * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
> - * yet.
> + * yet.  This is done by scsi_wait_scan.
>   */
> -late_initcall(scsi_complete_async_scans);
> -#endif

This is actually not in mainline.  It's an incorrect patch in -mm.  The
problem with late_initcall is that they queue in link order ... so any
SCSI module (and there a few) linked after this won't benefit from it.
The obvious hack is to have a separate file with this in the final link.
However, Matthew Wilcox thinks he can do better.

James


