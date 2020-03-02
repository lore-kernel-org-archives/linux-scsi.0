Return-Path: <SRS0=R5J5=4T=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AA98C3F2D1
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 10:58:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D94972166E
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Mar 2020 10:58:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727593AbgCBK66 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Mar 2020 05:58:58 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2487 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727027AbgCBK66 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 2 Mar 2020 05:58:58 -0500
Received: from LHREML714-CAH.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id AB272627DB1C52721B3B;
        Mon,  2 Mar 2020 10:58:56 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 LHREML714-CAH.china.huawei.com (10.201.108.37) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Mon, 2 Mar 2020 10:58:56 +0000
Received: from [127.0.0.1] (10.202.226.45) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Mon, 2 Mar 2020
 10:58:56 +0000
Subject: Re: [PATCH] scsi: avoid to fetch scsi host template instance in IO
 path
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Sumanesh Samanta <sumanesh.samanta@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>,
        Christoph Hellwig <hch@lst.de>
References: <20200228093346.31213-1-ming.lei@redhat.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <f23daab7-7aa0-1c34-8137-7abead09016c@huawei.com>
Date:   Mon, 2 Mar 2020 10:58:55 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200228093346.31213-1-ming.lei@redhat.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.45]
X-ClientProxiedBy: lhreml725-chm.china.huawei.com (10.201.108.76) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 28/02/2020 09:33, Ming Lei wrote:
> scsi host template struct is quite big, and the following three
> fields are needed in SCSI IO path:
> 
> - queuecommand
> - commit_rqs
> - cmd_size

Would it have been nearly as good to reorganise Scsi host template 
structure to ensure that these are adjacent?

I say nearly, as it avoids the shost->hostt read.

> 
> Cache them into scsi host intance, so that we can avoid to fetch
> big scsi host template instance in IO path.
> 
> 40% IOPS boost can be observed in my scsi_debug performance test after
> applying this change.
> 
> Cc: Sumanesh Samanta <sumanesh.samanta@broadcom.com>
> Cc: Ewan D . Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   drivers/scsi/hosts.c     |  4 ++++
>   drivers/scsi/scsi_lib.c  | 10 +++++-----
>   include/scsi/scsi_host.h | 11 ++++++++++-
>   3 files changed, 19 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 1d669e47b692..8012c1db092e 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -466,6 +466,10 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>   	if (sht->virt_boundary_mask)
>   		shost->virt_boundary_mask = sht->virt_boundary_mask;
>   
> +	shost->cmd_size = sht->cmd_size;
> +	shost->queuecommand = sht->queuecommand;
> +	shost->commit_rqs = sht->commit_rqs;
> +
>   	device_initialize(&shost->shost_gendev);
>   	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>   	shost->shost_gendev.bus = &scsi_bus_type;
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index e7fbf3a9a6aa..f4243ae1d4a9 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1148,7 +1148,7 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>   	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   	/* zero out the cmd, except for the embedded scsi_request */
>   	memset((char *)cmd + sizeof(cmd->req), 0,
> -		sizeof(*cmd) - sizeof(cmd->req) + dev->host->hostt->cmd_size);
> +		sizeof(*cmd) - sizeof(cmd->req) + dev->host->cmd_size);
>   
>   	cmd->device = dev;
>   	cmd->sense_buffer = buf;
> @@ -1547,7 +1547,7 @@ static int scsi_dispatch_cmd(struct scsi_cmnd *cmd)
>   	}
>   
>   	trace_scsi_dispatch_cmd_start(cmd);
> -	rtn = host->hostt->queuecommand(host, cmd);
> +	rtn = host->queuecommand(host, cmd);
>   	if (rtn) {
>   		trace_scsi_dispatch_cmd_error(cmd, rtn);
>   		if (rtn != SCSI_MLQUEUE_DEVICE_BUSY &&
> @@ -1584,7 +1584,7 @@ static blk_status_t scsi_mq_prep_fn(struct request *req)
>   	cmd->tag = req->tag;
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   
> -	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->hostt->cmd_size;
> +	sg = (void *)cmd + sizeof(struct scsi_cmnd) + shost->cmd_size;
>   	cmd->sdb.table.sgl = sg;
>   
>   	if (scsi_host_get_prot(shost)) {
> @@ -1752,7 +1752,7 @@ static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct request *rq,
>   
>   	if (scsi_host_get_prot(shost)) {
>   		sg = (void *)cmd + sizeof(struct scsi_cmnd) +
> -			shost->hostt->cmd_size;
> +			shost->cmd_size;
>   		cmd->prot_sdb = (void *)sg + scsi_mq_inline_sgl_size(shost);
>   	}
>   
> @@ -1844,7 +1844,7 @@ static void scsi_commit_rqs(struct blk_mq_hw_ctx *hctx)
>   	struct scsi_device *sdev = q->queuedata;
>   	struct Scsi_Host *shost = sdev->host;
>   
> -	shost->hostt->commit_rqs(shost, hctx->queue_num);
> +	shost->commit_rqs(shost, hctx->queue_num);
>   }
>   
>   static const struct blk_mq_ops scsi_mq_ops = {
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index f577647bf5f2..ccd5b9a5de2a 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
> @@ -522,7 +522,16 @@ struct Scsi_Host {
>   	 */
>   	struct list_head	__devices;
>   	struct list_head	__targets;
> -	
> +
> +	/*
> +	 * cacahe the three fields from scsi_host_template, so that
> +	 * the big host template  instance needn't to be fetched in
> +	 * IO path. Big IOPS boost can be observed by this way.
> +	 */
> +	unsigned int cmd_size;

any reason not to add cacheline alignment? And I think function pointers 
will be at least same size as unsigned int, so it may make more sense to 
put cmd_size last.

> +	int (*queuecommand)(struct Scsi_Host *, struct scsi_cmnd *);
> +	void (*commit_rqs)(struct Scsi_Host *, u16);
> +
>   	struct list_head	starved_list;
>   
>   	spinlock_t		default_lock;
> 

