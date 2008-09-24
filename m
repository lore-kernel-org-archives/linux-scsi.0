From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [patch 15/17] drivers/scsi: Use DIV_ROUND_UP
Date: Wed, 24 Sep 2008 13:31:15 -0600
Message-ID: <20080924193115.GQ27204@parisc-linux.org>
References: <200809222156.m8MLupx2032307@imap1.linux-foundation.org> <20080923004345.GC27204@parisc-linux.org> <Pine.LNX.4.64.0809242125450.19914@ask.diku.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:37913 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116AbYIXTbb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Sep 2008 15:31:31 -0400
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0809242125450.19914@ask.diku.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Julia Lawall <julia@diku.dk>
Cc: akpm@linux-foundation.org, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

On Wed, Sep 24, 2008 at 09:26:48PM +0200, Julia Lawall wrote:
> --------------------
> 
> From: Julia Lawall <julia@diku.dk>
> 
> Use the macro DIV_ROUND_UP and eliminate the variable rounded_up, as
> suggested by Matthew Wilcox.
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>

Reviewed-by: Matthew Wilcox <willy@linux.intel.com>

> ---
> 
>  drivers/scsi/esp_scsi.c       |    6 ++----
>  1 files changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/esp_scsi.c b/drivers/scsi/esp_scsi.c
> index 62a4618..a680e18 100644
> --- a/drivers/scsi/esp_scsi.c
> +++ b/drivers/scsi/esp_scsi.c
> @@ -1453,7 +1453,7 @@ static void esp_msgin_sdtr(struct esp *esp, struct esp_target_data *tp)
>  		offset = 0;
>  
>  	if (offset) {
> -		int rounded_up, one_clock;
> +		int one_clock;
>  
>  		if (period > esp->max_period) {
>  			period = offset = 0;
> @@ -1463,9 +1463,7 @@ static void esp_msgin_sdtr(struct esp *esp, struct esp_target_data *tp)
>  			goto do_reject;
>  
>  		one_clock = esp->ccycle / 1000;
> -		rounded_up = (period << 2);
> -		rounded_up = (rounded_up + one_clock - 1) / one_clock;
> -		stp = rounded_up;
> +		stp = DIV_ROUND_UP(period << 2, one_clock);
>  		if (stp && esp->rev >= FAS236) {
>  			if (stp >= 50)
>  				stp--;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
