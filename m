Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50E28C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:55:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1D46A64F69
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 07:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbhCSHzN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 03:55:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:41438 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233993AbhCSHzF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Mar 2021 03:55:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 91312AE04;
        Fri, 19 Mar 2021 07:55:03 +0000 (UTC)
Subject: Re: [PATCH 1/3] scsi: check the whole result for reading write
 protect flag
To:     Jason Yan <yanaijie@huawei.com>, axboe@kernel.dk,
        ming.lei@redhat.com, hch@lst.de, keescook@chromium.org,
        kbusch@kernel.org, linux-block@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc:     linux-scsi@vger.kernel.org
References: <20210319030128.1345061-1-yanaijie@huawei.com>
 <20210319030128.1345061-2-yanaijie@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <078d47ac-907c-ec20-f600-7073bf375f1a@suse.de>
Date:   Fri, 19 Mar 2021 08:55:02 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210319030128.1345061-2-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/19/21 4:01 AM, Jason Yan wrote:
> When the scsi device status is offline, mode sense command will return a
> result with only DID_NO_CONNECT set. Then in sd_read_write_protect_flag(),
> only status byte of the result is checked, we still consider the command
> returned good, and read sdkp->write_prot from the buffer. And because of
> bug [1], garbage data is copied to the buffer, the disk sometimes
> be set readonly. When the scsi device is set running again, users cannot
> write data to the disk.
> 
> Fix this by check the whole result returned by the driver.
> 
> [1] https://patchwork.kernel.org/project/linux-block/patch/20210318122621.330010-1-yanaijie@huawei.com/
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/sd.c   |  6 +++---
>   include/scsi/scsi.h | 13 +++++++++++++
>   2 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index ed0b1bb99f08..16f8cd2895fd 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -2669,18 +2669,18 @@ sd_read_write_protect_flag(struct scsi_disk *sdkp, unsigned char *buffer)
>   		 * 5: Illegal Request, Sense Code 24: Invalid field in
>   		 * CDB.
>   		 */
> -		if (!scsi_status_is_good(res))
> +		if (!scsi_result_is_good(res))
>   			res = sd_do_mode_sense(sdkp, 0, 0, buffer, 4, &data, NULL);
>   
>   		/*
>   		 * Third attempt: ask 255 bytes, as we did earlier.
>   		 */
> -		if (!scsi_status_is_good(res))
> +		if (!scsi_result_is_good(res))
>   			res = sd_do_mode_sense(sdkp, 0, 0x3F, buffer, 255,
>   					       &data, NULL);
>   	}
>   
> -	if (!scsi_status_is_good(res)) {
> +	if (!scsi_result_is_good(res)) {
>   		sd_first_printk(KERN_WARNING, sdkp,
>   			  "Test WP failed, assume Write Enabled\n");
>   	} else {
> diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
> index e75cca25338a..db0f346a31b2 100644
> --- a/include/scsi/scsi.h
> +++ b/include/scsi/scsi.h
> @@ -55,6 +55,19 @@ static inline int scsi_status_is_good(int status)
>   		(status == SAM_STAT_COMMAND_TERMINATED));
>   }
>   
> +/** scsi_result_is_good - check the result return.
> + *
> + * @result: the result passed up from the driver (including host and
> + *          driver components)
> + *
> + * Drivers may only set other bytes but not status byte.
> + * This checks both the status byte and other bytes.
> + */
> +static inline int scsi_result_is_good(int result)
> +{
> +	return scsi_status_is_good(result) && (result & ~0xff) == 0;
> +}
> +
>   
>   /*
>    * standard mode-select header prepended to all mode-select commands
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
