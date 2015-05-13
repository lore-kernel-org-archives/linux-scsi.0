From: Mark Hounschell <markh@compro.net>
Subject: Re: [PATCH] sd: Disable support for 256 byte/sector disks
Date: Wed, 13 May 2015 08:55:30 -0400
Message-ID: <555349C2.2020203@compro.net>
References: <1431506949-11398-1-git-send-email-hare@suse.de>
Reply-To: markh@compro.net
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp126.ord1c.emailsrvr.com ([108.166.43.126]:42077 "EHLO
	smtp126.ord1c.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933335AbbEMNBi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 13 May 2015 09:01:38 -0400
In-Reply-To: <1431506949-11398-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, James Bottomley <jbottomley@parallels.com>
Cc: Mark Hounschell <dmarkh@cfl.rr.com>, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>

On 05/13/2015 04:49 AM, Hannes Reinecke wrote:
> 256 bytes per sector support has been broken since 2.6.X,
> and no-one stepped up to fix this.
> So disable support for it.
>
> Signed-off-by: Mark Hounschell <dmarkh@cfl.rr.com>
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>   drivers/scsi/sd.c | 19 +++++--------------
>   1 file changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 79beebf..7f9d65f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1600,6 +1600,7 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>   {
>   	u64 start_lba = blk_rq_pos(scmd->request);
>   	u64 end_lba = blk_rq_pos(scmd->request) + (scsi_bufflen(scmd) / 512);
> +	u64 factor = scmd->device->sector_size / 512;
>   	u64 bad_lba;
>   	int info_valid;
>   	/*
> @@ -1621,16 +1622,9 @@ static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>   	if (scsi_bufflen(scmd) <= scmd->device->sector_size)
>   		return 0;
>
> -	if (scmd->device->sector_size < 512) {
> -		/* only legitimate sector_size here is 256 */
> -		start_lba <<= 1;
> -		end_lba <<= 1;
> -	} else {
> -		/* be careful ... don't want any overflows */
> -		unsigned int factor = scmd->device->sector_size / 512;
> -		do_div(start_lba, factor);
> -		do_div(end_lba, factor);
> -	}
> +	/* be careful ... don't want any overflows */
> +	do_div(start_lba, factor);
> +	do_div(end_lba, factor);
>
>   	/* The bad lba was reported incorrectly, we have no idea where
>   	 * the error is.
> @@ -2188,8 +2182,7 @@ got_data:
>   	if (sector_size != 512 &&
>   	    sector_size != 1024 &&
>   	    sector_size != 2048 &&
> -	    sector_size != 4096 &&
> -	    sector_size != 256) {
> +	    sector_size != 4096) {
>   		sd_printk(KERN_NOTICE, sdkp, "Unsupported sector size %d.\n",
>   			  sector_size);
>   		/*
> @@ -2244,8 +2237,6 @@ got_data:
>   		sdkp->capacity <<= 2;
>   	else if (sector_size == 1024)
>   		sdkp->capacity <<= 1;
> -	else if (sector_size == 256)
> -		sdkp->capacity >>= 1;
>
>   	blk_queue_physical_block_size(sdp->request_queue,
>   				      sdkp->physical_block_size);
>

Tested-by: Mark Hounschell <dmarkh@cfl.rr.com>

Mark
