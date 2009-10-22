From: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>
Subject: Re: [PATCH] pmcraid: redundant check in
 pmcraid_check_ioctl_buffer()?
Date: Thu, 22 Oct 2009 13:37:39 -0700 (PDT)
Message-ID: <alpine.LNX.1.10.0910221336090.13237@rslab159.pmc-sierra.bc.ca>
References: <4ADF1D8A.1030906@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bby1mta03.pmc-sierra.com ([216.241.235.118]:34349 "EHLO
	bby1mta03.pmc-sierra.bc.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755906AbZJVVlA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Oct 2009 17:41:00 -0400
In-Reply-To: <4ADF1D8A.1030906@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roel Kluin <roel.kluin@gmail.com>
Cc: linux-scsi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, anil_ravindranath@pmc-sierra.com

I agree this check is not necessary.

Signed-off-by: Anil Ravindranath <anil_ravindranath@pmc-sierra.com>

On Wed, 21 Oct 2009, Roel Kluin wrote:

> struct pmcraid_ioctl_header member buffer_length is unsigned, so
> this check appears redundant.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
> Or should we replace it by a check like
> if (hdr->buffer_length > MAX) ... ?
> 
> diff --git a/drivers/scsi/pmcraid.c b/drivers/scsi/pmcraid.c
> index f7c70e2..e448776 100644
> --- a/drivers/scsi/pmcraid.c
> +++ b/drivers/scsi/pmcraid.c
> @@ -3731,12 +3731,6 @@ static int pmcraid_check_ioctl_buffer(
>  		return -EINVAL;
>  	}
>  
> -	/* buffer length can't be negetive */
> -	if (hdr->buffer_length < 0) {
> -		pmcraid_err("ioctl: invalid buffer length specified\n");
> -		return -EINVAL;
> -	}
> -
>  	/* check for appropriate buffer access */
>  	if ((_IOC_DIR(cmd) & _IOC_READ) == _IOC_READ)
>  		access = VERIFY_WRITE;
> 
