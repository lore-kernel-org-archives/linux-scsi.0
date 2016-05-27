From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH] Use the correct size to set block max sectors
Date: Thu, 26 May 2016 19:18:35 -0700
Message-ID: <aad00979-740e-b844-64fb-4bfa646796e5@sandisk.com>
References: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0081.outbound.protection.outlook.com ([157.56.110.81]:18848
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932104AbcE0CSs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 May 2016 22:18:48 -0400
In-Reply-To: <1464307708-4315-1-git-send-email-longli@microsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Long Li <longli@microsoft.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: KY Srinivasan <kys@microsoft.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 05/26/16 17:08, Long Li wrote:
> The block sector size should be in unit of 512 bytes, not in bytes.
>
> Signed-off-by: Long Li <longli@microsoft.com>
>
> ---
>  drivers/scsi/sd.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 428c03e..4bce17e 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2862,9 +2862,11 @@ static int sd_revalidate_disk(struct gendisk *disk)
>  	if (sdkp->opt_xfer_blocks &&
>  	    sdkp->opt_xfer_blocks <= dev_max &&
>  	    sdkp->opt_xfer_blocks <= SD_DEF_XFER_BLOCKS &&
> -	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE)
> -		rw_max = q->limits.io_opt =
> +	    sdkp->opt_xfer_blocks * sdp->sector_size >= PAGE_SIZE) {
> +		q->limits.io_opt =
>  			sdkp->opt_xfer_blocks * sdp->sector_size;
> +		rw_max = (q->limits.io_opt >> 9);
> +	}
>  	else
>  		rw_max = BLK_DEF_MAX_SECTORS;

Isn't this a duplicate of a patch Martin Petersen posted three weeks 
ago? See also http://thread.gmane.org/gmane.linux.scsi/113746.

Bart.



