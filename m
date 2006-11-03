From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH 1/2] [SCSI] Print only a single message "rejecting I/O to device being removed"
Date: Fri, 3 Nov 2006 13:29:59 +0100
Message-ID: <20061103122959.GG13555@kernel.dk>
References: <96894.60447.qm@web31813.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from brick.kernel.dk ([62.242.22.158]:49692 "EHLO kernel.dk")
	by vger.kernel.org with ESMTP id S1752724AbWKCM2F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Nov 2006 07:28:05 -0500
Content-Disposition: inline
In-Reply-To: <96894.60447.qm@web31813.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <ltuikov@yahoo.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Nov 03 2006, Luben Tuikov wrote:
> ... at device removal.
> 
> Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
> ---
>  drivers/scsi/scsi_lib.c    |   10 +++++++---
>  drivers/scsi/scsi_scan.c   |    1 +
>  include/scsi/scsi_device.h |    3 +++
>  3 files changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 7b0f9a3..f0de7ca 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1302,9 +1302,13 @@ static int scsi_prep_fn(struct request_q
>  			if(specials_only == SDEV_QUIESCE ||
>  					specials_only == SDEV_BLOCK)
>  				goto defer;
> -			
> -			sdev_printk(KERN_ERR, sdev,
> -				    "rejecting I/O to device being removed\n");
> +
> +			if (sdev->num_rej_messages > 0) {
> +				sdev->num_rej_messages--;
> +				sdev_printk(KERN_ERR, sdev,
> +					    "rejecting I/O to device "
> +					    "being removed\n");
> +			}

How about using some variant of printk_ratelimit() instead?


-- 
Jens Axboe

