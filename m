Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EDA8CDB47E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 00:26:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231441AbjJSA0a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSA03 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 20:26:29 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B1B0FE;
        Wed, 18 Oct 2023 17:26:28 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D029EC433C7;
        Thu, 19 Oct 2023 00:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697675187;
        bh=b/cBnj3VvbkNcjZuSy9SE3DQhh6HVRBaKXUB7BSALGo=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=uRk+r1HfWgXZdboY7G8TnEotsro1aAjvFqx4Cezyj2Q5H0HvKkVmS9hXaF8ZRDqnM
         ZooEPZWnQSCKE4joIlLtUH2slx89HsYHOf8tW1H+6AurUSFudTXQa8g3PN3i22O1nr
         DsR/+1PFviSLOfgaEdB4TwW9eU2Tku0GymU21+tYIuE6uJIbqiWYk3YJWoEnzVS/T5
         Zo6u6f3KKbphLDgpL7YG27jrqWAKuXrM5KKZYe2sK58xgYLC4ijYQ0yO0zVPyu70sL
         VDAPu3d7Qnb9twWK1PEr19wMC3/CVvx0g/wyMgzk3HH4Fmc3YkqOLv3wQX6R/Z3KeK
         U6AB8NRI4GR5w==
Message-ID: <88133920-cb0c-43ea-a735-dee63267ffc8@kernel.org>
Date:   Thu, 19 Oct 2023 09:26:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 10/18] scsi: sd_zbc: Only require an I/O scheduler if
 needed
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-11-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231018175602.2148415-11-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/23 02:54, Bart Van Assche wrote:
> An I/O scheduler that serializes zoned writes is only needed if the SCSI
> LLD does not preserve the write order. Hence only set
> ELEVATOR_F_ZBD_SEQ_WRITE if the LLD does not preserve the write order.
> 
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd_zbc.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
> index a25215507668..718b31bed878 100644
> --- a/drivers/scsi/sd_zbc.c
> +++ b/drivers/scsi/sd_zbc.c
> @@ -955,7 +955,9 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, u8 buf[SD_BUF_SIZE])
>  
>  	/* The drive satisfies the kernel restrictions: set it up */
>  	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, q);
> -	blk_queue_required_elevator_features(q, ELEVATOR_F_ZBD_SEQ_WRITE);
> +	if (!q->limits.driver_preserves_write_order)

Where is this limit introduced ? I do not see it anywhere in your patches. Did I
miss something ?

> +		blk_queue_required_elevator_features(q,
> +						     ELEVATOR_F_ZBD_SEQ_WRITE);
>  	if (sdkp->zones_max_open == U32_MAX)
>  		disk_set_max_open_zones(disk, 0);
>  	else

-- 
Damien Le Moal
Western Digital Research

