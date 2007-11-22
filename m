From: Adrian Bunk <bunk@kernel.org>
Subject: Re: [patch 02/23] nsp32_restart_autoscsi(): remove error check
Date: Thu, 22 Nov 2007 09:28:51 +0100
Message-ID: <20071122082851.GA18535@stusta.de>
References: <200711212312.lALNCFLO014108@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:33516 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751646AbXKVI3J (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Nov 2007 03:29:09 -0500
Content-Disposition: inline
In-Reply-To: <200711212312.lALNCFLO014108@imap1.linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org
Cc: James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, yokota@netlab.is.tsukuba.ac.jp

AFAIR, this was the nsp32_msg() James wanted to keep, and the patch 
should therefore be dropped.

cu
Adrian


On Wed, Nov 21, 2007 at 03:12:15PM -0800, akpm@linux-foundation.org wrote:
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
>  1 file changed, 4 deletions(-)
> 
> diff -puN drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check drivers/scsi/nsp32.c
> --- a/drivers/scsi/nsp32.c~nsp32_restart_autoscsi-remove-error-check
> +++ a/drivers/scsi/nsp32.c
> @@ -1906,10 +1906,6 @@ static void nsp32_restart_autoscsi(struc
>  
>  	nsp32_dbg(NSP32_DEBUG_RESTART, "enter");
>  
> -	if (data->cur_target == NULL || data->cur_lunt == NULL) {
> -		nsp32_msg(KERN_ERR, "Target or Lun is invalid");
> -	}
> -
>  	/*
>  	 * set SYNC_REG
>  	 * Don't set BM_START_ADR before setting this register.
> _

