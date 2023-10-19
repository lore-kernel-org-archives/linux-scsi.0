Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43D59CDB47E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Oct 2023 00:24:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbjJSAYK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 20:24:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbjJSAYJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 20:24:09 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FEF3FA;
        Wed, 18 Oct 2023 17:24:08 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0135C433C8;
        Thu, 19 Oct 2023 00:24:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697675047;
        bh=qSt752qo9f/9keT34nl3gZ57QzTJAE9kUJGDmOTuT6A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=P9rHbYMgS6Ebeq77OeQplfox6NKNplO4buyZ2u2TYBozLdO7himqGRDpE2OHFz92d
         q/ppkTl724FTp0GkpyvJ2mMHLh6ioQV8ZKlRaNVziMUEkv/zzgfkvY0lXZwRb49M5N
         0s14TQHRfBDtLQMoELDI3J4b1iAFDJnbkM3IjX8jt0YRrbD7BuGTsfw+WVj7ViJpZP
         CuATYVTs3bcp+dhYyYpNjf1bF+eJaE4GIoY8J177map+se4bHwXrGunwYd5ozp1loR
         8gzuK5/KBDXFxpXnhtWsM8+5/8IN2NdmXHNrLoCBBy0EZtz8hPgZuvQSg53DB/k6mz
         +o1FJMBVSq2WA==
Message-ID: <9ee7edc0-5edb-4e17-abae-bb7ffcf0f147@kernel.org>
Date:   Thu, 19 Oct 2023 09:24:05 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 05/18] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20231018175602.2148415-1-bvanassche@acm.org>
 <20231018175602.2148415-6-bvanassche@acm.org>
From:   Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20231018175602.2148415-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/23 02:54, Bart Van Assche wrote:
> Introduce the .eh_needs_prepare_resubmit and the .eh_prepare_resubmit
> function pointers in struct scsi_driver. Make the error handler call
> .eh_prepare_resubmit() before resubmitting commands if any of the
> .eh_needs_prepare_resubmit() invocations return true. A later patch
> will use this functionality to sort SCSI commands by LBA from inside
> the SCSI disk driver before these are resubmitted by the error handler.
> 
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Damien Le Moal <dlemoal@kernel.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c  | 72 ++++++++++++++++++++++++++++++++++++++
>  drivers/scsi/scsi_priv.h   |  1 +
>  include/scsi/scsi_driver.h |  2 ++
>  3 files changed, 75 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index c67cdcdc3ba8..c877db23a72d 100644
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
> @@ -2186,6 +2187,75 @@ void scsi_eh_ready_devs(struct Scsi_Host *shost,
>  }
>  EXPORT_SYMBOL_GPL(scsi_eh_ready_devs);
>  
> +/*
> + * Returns true if .eh_prepare_resubmit should be called for the commands in
> + * @done_q.
> + */
> +static bool scsi_needs_preparation(struct list_head *done_q)
> +{
> +	struct scsi_cmnd *scmd;
> +
> +	list_for_each_entry(scmd, done_q, eh_entry) {
> +		struct scsi_driver *uld;
> +		bool (*npr)(struct scsi_cmnd *scmd);
> +
> +		if (!scmd->device)
> +			continue;
> +		uld = scsi_cmd_to_driver(scmd);
> +		if (!uld)
> +			continue;
> +		npr = uld->eh_needs_prepare_resubmit;
> +		if (npr && npr(scmd))
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
> +	if (!scsi_needs_preparation(done_q))
> +		return;

This function will always go through the list of commands in done_q. That could
hurt performance for scsi hosts that do not need this prepare resubmit, which I
think is UFS only for now. So can't we just add a flag or something to avoid that ?

> +
> +	/* Sort pending SCSI commands by ULD. */
> +	list_sort(NULL, done_q, scsi_cmp_uld);
> +
> +	/*
> +	 * Call .eh_prepare_resubmit for each range of commands with identical
> +	 * ULD driver pointer.
> +	 */
> +	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
> +		struct scsi_driver *uld =
> +			scmd->device ? scsi_cmd_to_driver(scmd) : NULL;
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
> @@ -2194,6 +2264,8 @@ void scsi_eh_flush_done_q(struct list_head *done_q)
>  {
>  	struct scsi_cmnd *scmd, *next;
>  
> +	scsi_call_prepare_resubmit(done_q);
> +
>  	list_for_each_entry_safe(scmd, next, done_q, eh_entry) {
>  		list_del_init(&scmd->eh_entry);
>  		if (scsi_device_online(scmd->device) &&
> diff --git a/drivers/scsi/scsi_priv.h b/drivers/scsi/scsi_priv.h
> index 3f0dfb97db6b..64070e530c4d 100644
> --- a/drivers/scsi/scsi_priv.h
> +++ b/drivers/scsi/scsi_priv.h
> @@ -101,6 +101,7 @@ int scsi_eh_get_sense(struct list_head *work_q,
>  		      struct list_head *done_q);
>  bool scsi_noretry_cmd(struct scsi_cmnd *scmd);
>  void scsi_eh_done(struct scsi_cmnd *scmd);
> +void scsi_call_prepare_resubmit(struct list_head *done_q);
>  
>  /* scsi_lib.c */
>  extern void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 4ce1988b2ba0..00ffa470724a 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -18,6 +18,8 @@ struct scsi_driver {
>  	int (*done)(struct scsi_cmnd *);
>  	int (*eh_action)(struct scsi_cmnd *, int);
>  	void (*eh_reset)(struct scsi_cmnd *);
> +	bool (*eh_needs_prepare_resubmit)(struct scsi_cmnd *cmd);
> +	void (*eh_prepare_resubmit)(struct list_head *cmd_list);
>  };
>  #define to_scsi_driver(drv) \
>  	container_of((drv), struct scsi_driver, gendrv)

-- 
Damien Le Moal
Western Digital Research

