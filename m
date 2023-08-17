Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8423EC2FC0E
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 11:11:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350111AbjHQLLL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 07:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350158AbjHQLKj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 07:10:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1344E2D71;
        Thu, 17 Aug 2023 04:10:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4B9D60FAB;
        Thu, 17 Aug 2023 11:10:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F9D9C433C8;
        Thu, 17 Aug 2023 11:10:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692270637;
        bh=9QUTAHW0L15A1WuXrJtMu4nEnnUnYOFVpX4z/2cd1m0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ixg8QeanGgVVdvREM0KgXNTbxWFjb/S4XniaNIA3pWfdtEPNWKDz2/VzV+fAUnDP3
         6L5VQcAZvr7AeGeSxH+QuX6q0GzKgpQ+m/bzm9cEMtv/XxE6K0ynqXWNW1Y+qKXMzT
         WYmSyD/tkxSD+dvKSYI3NhXnbteNCOdA3buMtGJG//VL48O9Yr7Ic79OuOAObit4qK
         ozj9jdrnw2zJRth9aUrz3C+hNerh/u0HEgaMUjPcTJaBLA+Mwd/6gOt5iaiCAJfNSR
         mm9nkrLBOWXBJ3KVi3uZW9H5M0MsQqEiWaQkYl8twg37rMvrDAdVG1+6QfgSD9gG9k
         +w7wpwmowDykg==
Message-ID: <201ae2be-3829-97ad-caa5-6f6f3a41e6db@kernel.org>
Date:   Thu, 17 Aug 2023 20:10:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v9 04/17] scsi: core: Call .eh_prepare_resubmit() before
 resubmitting
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230816195447.3703954-1-bvanassche@acm.org>
 <20230816195447.3703954-5-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20230816195447.3703954-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/17/23 04:53, Bart Van Assche wrote:
> Introduce the .eh_prepare_resubmit function pointer in struct scsi_driver.
> Make the error handler call .eh_prepare_resubmit() before resubmitting
> commands. A later patch will use this functionality to sort SCSI commands
> by LBA from inside the SCSI disk driver.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c  | 65 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_priv.h   |  1 +
>  include/scsi/scsi_driver.h |  1 +
>  3 files changed, 67 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c67cdcdc3ba8..4393a7fd8a07 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -27,6 +27,7 @@
>  #include <linux/blkdev.h>
>  #include <linux/delay.h>
>  #include <linux/jiffies.h>
> +#include <linux/list_sort.h>
>  
>  #include <scsi/scsi.h>
>  #include <scsi/scsi_cmnd.h>
> @@ -2186,6 +2187,68 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
>  
> +/*
> + * Returns true if the commands in @done_q should be sorted in LBA order
> + * before being resubmitted.
> + */
> +static bool scsi_needs_sorting(struct list_head *done_q)
> +{
> +	struct scsi_cmnd *scmd;
> +
> +	list_for_each_entry(scmd, done_q, eh_entry) {
> +		struct request *rq = scsi_cmd_to_rq(scmd);
> +
> +		if (!rq->q->limits.use_zone_write_lock &&
> +		    blk_rq_is_seq_zoned_write(rq))
> +			return true;
> +	}
> +
> +	return false;
> +}
> +
> +/*
> + * Comparison function that allows to sort SCSI commands by ULD driver.
> + */
> +static int scsi_cmp_uld(void *priv, const struct list_head *_a,
> +			const struct list_head *_b)
> +{
> +	struct scsi_cmnd *a = list_entry(_a, typeof(*a), eh_entry);
> +	struct scsi_cmnd *b = list_entry(_b, typeof(*b), eh_entry);
> +
> +	/* See also the comment above the list_sort() definition. */
> +	return scsi_cmd_to_driver(a) > scsi_cmd_to_driver(b);
> +}
> +
> +void scsi_call_prepare_resubmit(struct list_head *done_q)
> +{
> +	struct scsi_cmnd *scmd, *next;
> +
> +	if (!scsi_needs_sorting(done_q))
> +		return;

This is strange. The eh_prepare_resubmit callback is generic and its name does
not indicate anything related to sorting by LBAs. So this check would prevent
other actions not related to sorting by LBA. This should go away.

In patch 6, based on the device characteristics, the sd driver should decides
if it needs to set .eh_prepare_resubmit or not.

And ideally, if all ULDs have eh_prepare_resubmit == NULL, this function should
return here before going through the list of commands to resubmit. Given that
this list should generally be small, going through it and doing nothing should
be OK though...

> +
> +	/* Sort pending SCSI commands by ULD. */
> +	list_sort(NULL, done_q, scsi_cmp_uld);
> +
> +	/*
> +	 * Call .eh_prepare_resubmit for each range of commands with identical
> +	 * ULD driver pointer.
> +	 */
> +	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
> +		struct scsi_driver *uld = scsi_cmd_to_driver(scmd);
> +		struct list_head *prev, uld_cmd_list;
> +
> +		while (&next->eh_entry != done_q &&
> +		       scsi_cmd_to_driver(next) == uld)
> +			next = list_next_entry(next, eh_entry);
> +		if (!uld->eh_prepare_resubmit)
> +			continue;
> +		prev = scmd->eh_entry.prev;
> +		list_cut_position(&uld_cmd_list, prev, next->eh_entry.prev);
> +		uld->eh_prepare_resubmit(&uld_cmd_list);
> +		list_splice(&uld_cmd_list, prev);
> +	}
> +}
> +
>  /**
>   * scsi_eh_flush_done_q - finish processed commands or retry them.
>   * @done_q:	list_head of processed commands.
> @@ -2194,6 +2257,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>  {
>  	struct scsi_cmnd *scmd, *next;
>  
> +	scsi_call_prepare_resubmit(done_q);
> +
>  	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>  		list_del_init(&scmd->eh_entry);
>  		if (scsi_device_online(scmd->device) &&
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index f42388ecb024..df4af4645430 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  		      struct list_head *done_q);
>  bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
>  void scsi_eh_done(struct scsi_cmnd *scmd);
> +void scsi_call_prepare_resubmit(struct list_head *done_q);
>  
>  /* scsi_lib.c */
>  extern int scsi_maybe_unblock_host(struct scsi_device *sdev);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 4ce1988b2ba0..2b11be896eee 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -18,6 +18,7 @@ struct scsi_driver {
>  	int (*done)(struct scsi_cmnd *);
>  	int (*eh_action)(struct scsi_cmnd *, int);
>  	void (*eh_reset)(struct scsi_cmnd *);
> +	void (*eh_prepare_resubmit)(struct list_head *cmd_list);
>  };
>  #define to_scsi_driver(drv) \
>  	container_of((drv), struct scsi_driver, gendrv)

-- 
Damien Le Moal
Western Digital Research

