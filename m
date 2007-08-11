From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 13/30] nsp32_restart_autoscsi(): remove error check
Date: Fri, 10 Aug 2007 21:03:52 -0400
Message-ID: <1186794232.6334.21.camel@localhost.localdomain>
References: <200708102150.l7ALoeZw011354@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:60672 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757723AbXHKBDy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Aug 2007 21:03:54 -0400
In-Reply-To: <200708102150.l7ALoeZw011354@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: linux-scsi@vger.kernel.org, bunk@stusta.de, yokota@netlab.is.tsukuba.ac.jp

On Fri, 2007-08-10 at 14:50 -0700, akpm@linux-foundation.org wrote:
> From: Adrian Bunk <bunk@stusta.de>
> 
> The Coverity checker noted that we'll anyway Oops later when we ran into
> this condition - and the error check didn't prevent that.
> 
> Considering that the error condition shouldn't be possible, and we are
> not able to handle it easily, this patch simply removes the pointless
> error check.
> 
> Signed-off-by: Adrian Bunk <bunk@stusta.de>
> Cc: <yokota@netlab.is.tsukuba.ac.jp>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> ---
> 
>  drivers/scsi/nsp32.c |    4 ----
>  1 files changed, 4 deletions(-)
> 
> diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
> --- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
> +++ a/drivers/scsi/nsp32.c
> @@ -1905,10 +1905,6 @@ static void nsp32_restart_autoscsi(struc
>  
>  	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
>  
> -	if (data->cur_target == NULL || data->cur_lunt == NULL) {
> -		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
> -	}
> -

I disagree pretty strongly with this ... you're not removing an error
check, you're removing a warning printk.  Before the driver would say
what the problem is and oops.  After, it will oops and you won't
necessarily know why.  I think that's a retrograde step.

James


