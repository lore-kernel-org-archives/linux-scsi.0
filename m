From: Hugh Dickins <hugh@veritas.com>
Subject: Re: [patch 14/28] scsi: fix CONFIG_SCSI_WAIT_SCAN=m
Date: Fri, 11 May 2007 13:26:21 +0100 (BST)
Message-ID: <Pine.LNX.4.64.0705111313190.3350@blonde.wat.veritas.com>
References: <200705110600.l4B60vwX008157@shell0.pdx.osdl.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from extu-mxob-1.symantec.com ([216.10.194.28]:49297 "EHLO
	extu-mxob-1.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755845AbXEKMx7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 May 2007 08:53:59 -0400
Received: from blonde.wat.veritas.com([10.10.97.163]) (2920 bytes) by megami.veritas.com
	via sendmail with P:esmtp/R:smart_host/T:smtp
	(sender: <hugh@veritas.com>)
	id <m1HmUCv-0000NeC@megami.veritas.com>
	for <linux-scsi@vger.kernel.org>; Fri, 11 May 2007 05:26:49 -0700 (PDT)
	(Smail-3.2.0.101 1997-Dec-17 #15 built 2001-Aug-30)
In-Reply-To: <200705110600.l4B60vwX008157@shell0.pdx.osdl.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org

On Thu, 10 May 2007, akpm@linux-foundation.org wrote:
> From: Hugh Dickins <hugh@veritas.com>
> 
> CONFIG_MODULES=y
> CONFIG_SCSI=y
> CONFIG_SCSI_SCAN_ASYNC=y
> CONFIG_SCSI_WAIT_SCAN=m
> 
> 2.6.21-rc5-mm2 VFS panics unable to find my root on /dev/sda2, but boots
> okay if I change drivers/scsi/Kconfig to "default y" instead of "default m"
> for SCSI_WAIT_SCAN.
> 
> Make sure there's a late_initcall to scsi_complete_async_scans when it's
> built in, so a monolithic SCSI_SCAN_ASYNC kernel can rely on the scans
> being completed before trying to mount root, even if they're slow.

Thanks for sending this through to James again, Andrew.
I'd been gearing up to report it to the regression police:
it's certainly still a problem in 2.6.21-git.

> 
> [akpm@linux-foundation.org: build fixes]
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> Cc: James Bottomley <James.Bottomley@steeleye.com>
> ---
> James sayeth "This isn't the right fix ...  this has to be invoked last in the
> call sequence ...  I can't see another way of doing this except yet another
> file added as a final component to the link."

I didn't reply to James' mail at the time, hoping "the right fix" was
about to follow.  I don't see what's wrong with the late_initcall myself.

Hugh

> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/scsi_scan.c |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff -puN drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m drivers/scsi/scsi_scan.c
> --- a/drivers/scsi/scsi_scan.c~scsi-fix-config_scsi_wait_scan=m
> +++ a/drivers/scsi/scsi_scan.c
> @@ -184,6 +184,15 @@ int scsi_complete_async_scans(void)
>  /* Only exported for the benefit of scsi_wait_scan */
>  EXPORT_SYMBOL_GPL(scsi_complete_async_scans);
>  
> +#ifndef MODULE
> +/*
> + * For async scanning we need to wait for all the scans to complete before
> + * trying to mount the root fs.  Otherwise non-modular drivers may not be ready
> + * yet.
> + */
> +late_initcall(scsi_complete_async_scans);
> +#endif
> +
>  /**
>   * scsi_unlock_floptical - unlock device via a special MODE SENSE command
>   * @sdev:	scsi device to send command to
> _
