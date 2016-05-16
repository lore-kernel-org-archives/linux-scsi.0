From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/2] scsi: fix max discard sectors calculation
Date: Mon, 16 May 2016 15:44:48 -0700
Message-ID: <573A4D60.7080902@sandisk.com>
References: <1463424410-17196-1-git-send-email-mchristi@redhat.com>
 <1463424410-17196-2-git-send-email-mchristi@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1on0059.outbound.protection.outlook.com ([157.56.110.59]:52672
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751504AbcEPWo4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 May 2016 18:44:56 -0400
In-Reply-To: <1463424410-17196-2-git-send-email-mchristi@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: mchristi@redhat.com, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, socketpair@gmail.com
Cc: stable@vger.kernel.org

On 05/16/2016 11:46 AM, mchristi@redhat.com wrote:
> logical_block_size and max_blocks are 32 bits, so we can
> overflow when trying to convert SCSI device blocks to linux
> block layer sectors.
>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> Cc: stable@vger.kernel.org
>
> ---
>   drivers/scsi/sd.c | 3 ++-
>   1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f52b74c..1668e1d 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -690,7 +690,8 @@ static void sd_config_discard(struct scsi_disk *sdkp, unsigned int mode)
> -	blk_queue_max_discard_sectors(q, max_blocks * (logical_block_size >> 9));
> +	blk_queue_max_discard_sectors(q, (u64)max_blocks *
> +				      (logical_block_size >> 9));

Hello Mike,

As far as I can see max_blocks <= 0xffff (SD_MAX_WS10_BLOCKS) and 512 <= 
logical_block_size <= 4096. How can max_blocks * (logical_block_size >> 
9) be too large for a 32 bit integer?

Thanks,

Bart.
