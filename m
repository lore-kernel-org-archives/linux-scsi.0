Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 373E0C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 08:29:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230190AbiBXI3r (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 03:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232003AbiBXI3o (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 03:29:44 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E3FD277912;
        Thu, 24 Feb 2022 00:28:54 -0800 (PST)
Received: from fraeml743-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K45dG5nr9z67y1X;
        Thu, 24 Feb 2022 16:28:02 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml743-chm.china.huawei.com (10.206.15.224) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 09:28:52 +0100
Received: from [10.47.86.126] (10.47.86.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 24 Feb
 2022 08:28:51 +0000
Message-ID: <d94e5e8a-9793-ab48-88f8-6f6bb878cecd@huawei.com>
Date:   Thu, 24 Feb 2022 08:28:48 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220222140443.589882-4-hch@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.126]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2022 14:04, Christoph Hellwig wrote:
> Replace the big fat memset that requires saving and restoring various
> fields with just initializing those fields that need initialization.
> 
> All the clearing to 0 ismoved to scsi_prepare_cmd as scsi_ioctl_reset

nit: "is moved"?

> alreadly uses kzalloc to allocate a pre-zeroed command.
> 
> This is still conservative and can probably be optimizated further.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

FWIW:

Reviewed-by: John Garry <john.garry@huawei.com>

But just a comment below.

> ---
>   drivers/scsi/scsi_lib.c | 61 ++++++++++++++++++++---------------------
>   1 file changed, 29 insertions(+), 32 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index a1c18ba5e8d38..960795d469d8c 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1163,45 +1163,17 @@ static void scsi_cleanup_rq(struct request *rq)
>   /* Called before a request is prepared. See also scsi_mq_prep_fn(). */
>   void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>   {
> -	void *buf = cmd->sense_buffer;
> -	void *prot = cmd->prot_sdb;
>   	struct request *rq = scsi_cmd_to_rq(cmd);
> -	unsigned int flags = cmd->flags & SCMD_PRESERVED_FLAGS;
> -	unsigned long jiffies_at_alloc;
> -	int retries, to_clear;
> -	bool in_flight;
> -	int budget_token = cmd->budget_token;
> -
> -	if (!blk_rq_is_passthrough(rq) && !(flags & SCMD_INITIALIZED)) {
> -		flags |= SCMD_INITIALIZED;
> +
> +	if (!blk_rq_is_passthrough(rq) && !(cmd->flags & SCMD_INITIALIZED)) {
> +		cmd->flags |= SCMD_INITIALIZED;

Maybe I'm being dozy, but isn't this being cleared below *

>   		scsi_initialize_rq(rq);
>   	}
>   
> -	jiffies_at_alloc = cmd->jiffies_at_alloc;
> -	retries = cmd->retries;
> -	in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> -	/*
> -	 * Zero out the cmd, except for the embedded scsi_request. Only clear
> -	 * the driver-private command data if the LLD does not supply a
> -	 * function to initialize that data.
> -	 */
> -	to_clear = sizeof(*cmd) - sizeof(cmd->req);
> -	if (!dev->host->hostt->init_cmd_priv)
> -		to_clear += dev->host->hostt->cmd_size;
> -	memset((char *)cmd + sizeof(cmd->req), 0, to_clear);
> -
>   	cmd->device = dev;
> -	cmd->sense_buffer = buf;
> -	cmd->prot_sdb = prot;
> -	cmd->flags = flags;
> +	cmd->flags &= SCMD_PRESERVED_FLAGS;

*

>   	INIT_LIST_HEAD(&cmd->eh_entry);
>   	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
> -	cmd->jiffies_at_alloc = jiffies_at_alloc;
> -	cmd->retries = retries;
> -	if (in_flight)
> -		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> -	cmd->budget_token = budget_token;
> -
>   }
>   
>   static blk_status_t scsi_setup_scsi_cmnd(struct scsi_device *sdev,
> @@ -1586,10 +1558,35 @@ static blk_status_t scsi_prepare_cmd(struct request *req)
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>   	struct scsi_device *sdev = req->q->queuedata;
>   	struct Scsi_Host *shost = sdev->host;
> +	bool in_flight = test_bit(SCMD_STATE_INFLIGHT, &cmd->state);
>   	struct scatterlist *sg;
>   
>   	scsi_init_command(sdev, cmd);
>   
> +	cmd->eh_eflags = 0;
> +	cmd->allowed = 0;
> +	cmd->prot_type = 0;
> +	cmd->prot_flags = 0;
> +	cmd->submitter = 0;
> +	cmd->cmd_len = 0;
> +	cmd->cmnd = NULL;
> +	memset(&cmd->sdb, 0, sizeof(cmd->sdb));
> +	cmd->underflow = 0;
> +	cmd->transfersize = 0;
> +	cmd->host_scribble = NULL;
> +	cmd->result = 0;
> +	cmd->extra_len = 0;
> +	cmd->state = 0;
> +	if (in_flight)
> +		__set_bit(SCMD_STATE_INFLIGHT, &cmd->state);
> +
> +	/*
> +	 * Only clear the driver-private command data if the LLD does not supply
> +	 * a function to initialize that data.
> +	 */
> +	if (!shost->hostt->init_cmd_priv)
> +		memset(cmd + 1, 0, shost->hostt->cmd_size);
> +
>   	cmd->prot_op = SCSI_PROT_NORMAL;
>   	if (blk_rq_bytes(req))
>   		cmd->sc_data_direction = rq_dma_dir(req);

