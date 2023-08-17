Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C64E5C2FC14
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:13:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349392AbjHQLNT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350111AbjHQLNH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:13:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8AE41BFB;
        Thu, 17 Aug 2023 04:13:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CD9C646BE;
        Thu, 17 Aug 2023 11:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA33DC433C8;
        Thu, 17 Aug 2023 11:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692270784;
        bh=j++qvIsEejLemCzAddeAvR1I1WNg2cARlj5F6HextN4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=db0Uscq4caQ02wKNBesmoxsSTNW4epELgdjs/Rmbt+m2QgGddd0YUQzVZDkp68ypD
         0dDum/dWf3gf7RUjmmakjkTTzLuWrRrEzm2USPO0TzaA28Tdc5imJPKZDUzrqXFzxM
         AKUR06BS8MWzPcgWwB26XD/P6N4WQG6OniTE2XmSoq8b8/pUwktQfzZ0Ly43nX9c1p
         5eYzY4x/kHFSezNffWQYNRzmOIVijY6G31Senzwar8wl+yrF+SqcwxaB2Bpb7K8697
         RajzbzxhslAdakl03XRCJQW69dBZOMusap2wE4ZsCOEaM9z1uY7Ryon6Ns9jGY7YUh
         BtYbWUus+LmUA==
Message-ID: <84e5531b-f6ae-8454-9079-39aeec09c6ed@kernel.org>
Date:   Thu, 17 Aug 2023 20:13:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 06/17] scsi: sd: Sort commands by LBA before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-7-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Sort SCSI commands by LBA before the SCSI error handler resubmits
> these commands. This is necessary when resubmitting zoned writes
> (REQ_OP_WRITE) if multiple writes have been queued for a single zone.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.c | 35 +++++++++++++++++++++++++++++++++++
>  1 file changed, 35 insertions(+)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 3c668cfb146d..8a4b0874e7fe 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -47,6 +47,7 @@
>  #include <linux/blkpg.h>
>  #include <linux/blk-pm.h>
>  #include <linux/delay.h>
> +#include <linux/list_sort.h>
>  #include <linux/major.h>
>  #include <linux/mutex.h>
>  #include <linux/string_helpers.h>
> @@ -117,6 +118,7 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt);
>  static int sd_done(struct scsi_cmnd *);
>  static void sd_eh_reset(struct scsi_cmnd *);
>  static int sd_eh_action(struct scsi_cmnd *, int);
> +static void sd_prepare_resubmit(struct list_head *cmd_list);
>  static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
>  static void scsi_disk_release(struct device *cdev);
>  
> @@ -617,6 +619,7 @@ static struct scsi_driver sd_template = {
>  	.done			= sd_done,
>  	.eh_action		= sd_eh_action,
>  	.eh_reset		= sd_eh_reset,
> +	.eh_prepare_resubmit	= sd_prepare_resubmit,
>  };
>  
>  /*
> @@ -2018,6 +2021,38 @@ static int sd_eh_action(struct scsi_cmnd *scmd, int eh_disp)
>  	return eh_disp;
>  }
>  
> +static int sd_cmp_sector(void *priv, const struct list_head *_a,
> +			 const struct list_head *_b)
> +{
> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
> +	struct request *rq_a = scsi_cmd_to_rq(a);
> +	struct request *rq_b = scsi_cmd_to_rq(b);
> +	bool use_zwl_a = rq_a->q->limits.use_zone_write_lock;
> +	bool use_zwl_b = rq_b->q->limits.use_zone_write_lock;
> +
> +	/*
> +	 * Order the commands that need zone write locking after the commands
> +	 * that do not need zone write locking. Order the commands that do not
> +	 * need zone write locking by LBA. Do not reorder the commands that
> +	 * need zone write locking. See also the comment above the list_sort()
> +	 * definition.
> +	 */
> +	if (use_zwl_a || use_zwl_b)
> +		return use_zwl_a > use_zwl_b;
> +	return blk_rq_pos(rq_a) > blk_rq_pos(rq_b);
> +}
> +
> +static void sd_prepare_resubmit(struct list_head *cmd_list)
> +{
> +	/*
> +	 * Sort pending SCSI commands in starting sector order. This is
> +	 * important if one of the SCSI devices associated with @shost is a
> +	 * zoned block device for which zone write locking is disabled.
> +	 */
> +	list_sort(NULL, cmd_list, sd_cmp_sector);

We should not need to do this for regular devices or zoned devices using zone
write locking. So returning doing nothing would be better but the callback
lacks a pointer to the scsi_device to test that.

> +}
> +
>  static unsigned int sd_completed_bytes(struct scsi_cmnd *scmd)
>  {
>  	struct request *req = scsi_cmd_to_rq(scmd);

-- 
Damien Le Moal
Western Digital Research

