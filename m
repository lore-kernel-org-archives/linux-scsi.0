Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 10D2CC2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:19:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E88E861413
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 16:19:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232636AbhEYQVB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 12:21:01 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:48856 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbhEYQVB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 May 2021 12:21:01 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id D1EBC2EA173;
        Tue, 25 May 2021 12:19:30 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id tXA+Cs4bRqab; Tue, 25 May 2021 11:57:29 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 5843E2EA275;
        Tue, 25 May 2021 12:19:30 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 40/51] scsi_debug: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210524030856.2824-1-bvanassche@acm.org>
 <20210524030856.2824-41-bvanassche@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <b7b1bc48-9c5e-f2e2-1af6-e2d5eb3ad0af@interlog.com>
Date:   Tue, 25 May 2021 12:19:29 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210524030856.2824-41-bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-05-23 11:08 p.m., Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>

> ---
>   drivers/scsi/scsi_debug.c | 13 +++++++------
>   1 file changed, 7 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index 6e2ad003c179..151b0d2f49a5 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4705,7 +4705,7 @@ static int resp_rwp_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
>   {
>   	u16 hwq;
> -	u32 tag = blk_mq_unique_tag(cmnd->request);
> +	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
>   
>   	hwq = blk_mq_unique_tag_to_hwq(tag);
>   
> @@ -4718,7 +4718,7 @@ static struct sdebug_queue *get_queue(struct scsi_cmnd *cmnd)
>   
>   static u32 get_tag(struct scsi_cmnd *cmnd)
>   {
> -	return blk_mq_unique_tag(cmnd->request);
> +	return blk_mq_unique_tag(scsi_cmd_to_rq(cmnd));
>   }
>   
>   /* Queued (deferred) command completions converge here. */
> @@ -5367,7 +5367,7 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   {
>   	bool new_sd_dp;
>   	bool inject = false;
> -	bool hipri = (cmnd->request->cmd_flags & REQ_HIPRI);
> +	bool hipri = scsi_cmd_to_rq(cmnd)->cmd_flags & REQ_HIPRI;
>   	int k, num_in_q, qdepth;
>   	unsigned long iflags;
>   	u64 ns_from_boot = 0;
> @@ -5570,8 +5570,9 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
>   		if (sdebug_statistics)
>   			sd_dp->issuing_cpu = raw_smp_processor_id();
>   		if (unlikely(sd_dp->aborted)) {
> -			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n", cmnd->request->tag);
> -			blk_abort_request(cmnd->request);
> +			sdev_printk(KERN_INFO, sdp, "abort request tag %d\n",
> +				    scsi_cmd_to_rq(cmnd)->tag);
> +			blk_abort_request(scsi_cmd_to_rq(cmnd));
>   			atomic_set(&sdeb_inject_pending, 0);
>   			sd_dp->aborted = false;
>   		}
> @@ -7397,7 +7398,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
>   					       (u32)cmd[k]);
>   		}
>   		sdev_printk(KERN_INFO, sdp, "%s: tag=%#x, cmd %s\n", my_name,
> -			    blk_mq_unique_tag(scp->request), b);
> +			    blk_mq_unique_tag(scsi_cmd_to_rq(scp)), b);
>   	}
>   	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
>   		return SCSI_MLQUEUE_HOST_BUSY;
> 

