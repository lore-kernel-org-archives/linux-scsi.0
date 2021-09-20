Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51C4BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 09:39:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39D4A60F6C
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Sep 2021 09:39:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234958AbhITJlS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Sep 2021 05:41:18 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3844 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235040AbhITJlP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Sep 2021 05:41:15 -0400
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HCfZd4c32z67lwm;
        Mon, 20 Sep 2021 17:36:25 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.8; Mon, 20 Sep 2021 11:39:05 +0200
Received: from [10.47.88.85] (10.47.88.85) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 20 Sep
 2021 10:39:04 +0100
Subject: Re: [PATCH 02/84] scsi: core: Rename scsi_mq_done() into scsi_done()
 and export it
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20210918000607.450448-1-bvanassche@acm.org>
 <20210918000607.450448-3-bvanassche@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ee1a1197-1fd1-e9d9-6b45-79108d56830b@huawei.com>
Date:   Mon, 20 Sep 2021 10:42:28 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210918000607.450448-3-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.88.85]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/09/2021 01:04, Bart Van Assche wrote:
> Since the removal of the legacy block layer there is only one completion
> function left in the SCSI core, namely scsi_mq_done(). Rename it into
> scsi_done().

It would be nice to remove "mq" from other symbol naming in scsi_lib.c 
as well then. Could be a separate job, I suppose.

Export that function to allow SCSI LLDs to call it directly.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/scsi_lib.c  | 5 +++--
>   include/scsi/scsi_cmnd.h | 2 ++
>   2 files changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index ba6d748a0246..c3a0283dbff0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1575,7 +1575,7 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	return scsi_cmd_to_driver(cmd)->init_command(cmd);
>   }
>   
> -static void scsi_mq_done(struct scsi_cmnd *cmd)
> +void scsi_done(struct scsi_cmnd *cmd)
>   {
>   	switch (cmd->submitter) {
>   	case BLOCK_LAYER:
> @@ -1593,6 +1593,7 @@ static void scsi_mq_done(struct scsi_cmnd *cmd)
>   	trace_scsi_dispatch_cmd_done(cmd);
>   	blk_mq_complete_request(scsi_cmd_to_rq(cmd));
>   }
> +EXPORT_SYMBOL(scsi_done);
>   
>   static void scsi_mq_put_budget(struct request_queue *q, int budget_token)
>   {
> @@ -1692,7 +1693,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
>   
>   	scsi_set_resid(cmd, 0);
>   	memset(cmd->sense_buffer, 0, SCSI_SENSE_BUFFERSIZE);
> -	cmd->scsi_done = scsi_mq_done;
> +	cmd->scsi_done = scsi_done;

I have gone to the end of the series, and we still set 
scsi_cmnd.scsi_done. So some drivers still rely on it. I thought that 
the idea was that we don't need this callback pointer any longer.

As an aside, this is the current declaration of scsi_cmnd.scsi_done:

/* Low-level done function - can be used by low-level driver to point
*        to completion function.  Not used by mid/upper level code. */
	void (*scsi_done) (struct scsi_cmnd *);

That does not sound right, as scsi_done is set by the mid-layer.

>   
>   	blk_mq_start_request(req);
>   	reason = scsi_dispatch_cmd(cmd);
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index 365d47a66c18..5b230d06527f 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -172,6 +172,8 @@ static inline struct scsi_driver *scsi_cmd_to_driver(struct scsi_cmnd *cmd)
>   	return *(struct scsi_driver **)rq->rq_disk->private_data;
>   }
>   
> +void scsi_done(struct scsi_cmnd *cmd);
> +
>   extern void scsi_finish_command(struct scsi_cmnd *cmd);
>   
>   extern void *scsi_kmap_atomic_sg(struct scatterlist *sg, int sg_count,
> .
> 

