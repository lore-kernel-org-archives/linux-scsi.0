Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C95C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 18:18:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243256AbhKXSVa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 13:21:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45068 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230396AbhKXSV1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Nov 2021 13:21:27 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB5F9C061574
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 10:18:17 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id 137so3315534wma.1
        for <linux-scsi@vger.kernel.org>; Wed, 24 Nov 2021 10:18:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=8rLg0gQjRcuJSuEZFV5gXDfhFGVEiXQZBU1uQnpBH9o=;
        b=G/QNzn/OOV1FUDpoYw1CQXrJ6tBHlYiAgoAtnwT+z1ftrfvLAOlF8oEf1jtoa+THDG
         W1NSBddagKkd8fd2dESta/oJkUTdiB8Ox4jCFGb9vECUOWbOAbFGM4Lt4UiUmGnFvkAF
         nOVDcPoDhjflucpVpiEZTgxgJljXO/oxxUL4dBralS2IK8H+Lvoge6zbeMSk5k6sXAzg
         t6jhUcpSzUD/l4Ful/csOiQCCh3oAjCtgQZ5sktkFhaiu0mZHbkAMRHl5NqGXlaALpYB
         OP2C3g89DUeCmGBufFLVip4v3i7j7rRcfTsqKE7vs6Z0xjQryTDxYCAnCSDY3eHYhKlY
         97Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=8rLg0gQjRcuJSuEZFV5gXDfhFGVEiXQZBU1uQnpBH9o=;
        b=c0ZCHF1dne+tXDHEFvNPrFPmZe563jVRW75HXMU/X+UhA8LuF4TQBEcpnct9PWXGwC
         kDoN6Bjwi4/wn+lxSk0302Rpn42ifTUl1l46oXOMqcdbOQM/BGjL7M9ZYKLPLhGrHy7b
         aRFxOG9h2cyKjZGWHxctPD8iE2zCrdP5S4TwujZYgajvstUja5JIDP2k8Oq17PrUVgVT
         oNBdVT0n2QUBo5fOl1FDoHDOCCTwaPM128Y7gICgoeY/t77Xadzl3mFxod37IPd/IaPH
         6DAYZq9uqeWDhCRoQml8I/+Y+VIKpiuYPeTaWjAiuWocwVUOKh91QqOeCmKtCk0ZBM43
         74CA==
X-Gm-Message-State: AOAM533uQulvJL6NkVERhVhg8t5IE31jJvyIY3paB1t3w3jGV2chJXYd
        WH0y/f2bIO29U6eRu3sIa18=
X-Google-Smtp-Source: ABdhPJzcT9cDdM/EUZdSdUaQUyqkP1aBwLhrZLsBQ01iLCpfKOgqWt6HoITyRRi9e90J7uRdwZae2A==
X-Received: by 2002:a7b:c1d5:: with SMTP id a21mr17608791wmj.14.1637777896244;
        Wed, 24 Nov 2021 10:18:16 -0800 (PST)
Received: from p200300e94719c9965ac0d8c2d4c25ef2.dip0.t-ipconnect.de (p200300e94719c9965ac0d8c2d4c25ef2.dip0.t-ipconnect.de. [2003:e9:4719:c996:5ac0:d8c2:d4c2:5ef2])
        by smtp.googlemail.com with ESMTPSA id f8sm6622367wmf.2.2021.11.24.10.18.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 10:18:15 -0800 (PST)
Message-ID: <8a841ac7504a1520cfaee7d673441ceb7f3cf4b4.camel@gmail.com>
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
Date:   Wed, 24 Nov 2021 19:18:14 +0100
In-Reply-To: <09fc22b5-d654-4aa1-0afa-a9b99c526460@acm.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
         <20211119195743.2817-12-bvanassche@acm.org>
         <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
         <09fc22b5-d654-4aa1-0afa-a9b99c526460@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-11-23 at 11:41 -0800, Bart Van Assche wrote:
> On 11/23/21 4:20 AM, Bean Huo wrote:
> > Calling blk_mq_start_request() will inject the trace print of the
> > block
> > issued, but we do not have its paired completion trace print.
> > In addition, blk_mq_tag_idle() will not be called after the device
> > management request is completed, it will be called after the timer
> > expires.
> > 
> > I remember that we used to not allow this kind of LLD internal
> > commands
> > to be attached to the block layer. I now find that to be correct
> > way.
> 
> Hi Bean,
> 
> How about modifying the block layer such that blk_mq_tag_busy() is
> not
> called for requests with operation type REQ_OP_DRV_*? I think that
> will
> allow to leave out the blk_mq_start_request() calls from the UFS
> driver.
> These are the changes I currently have in mind (on top of this patch
> series):
> 

Hi Bart,

Yes, the following patch can solve these two problems, but you need to
change block layer code. Why do we have to fly to the block layer to
get this tag? and what is the benefit? This is a device management
request. As for the patch recommended by Adrian, that is the way I
think.


Kind regards,
Bean

> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 3ab34c4f20da..a7090b509f2d 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -433,6 +433,7 @@ __blk_mq_alloc_requests_batch(struct
> blk_mq_alloc_data *data,
> 
>   static struct request *__blk_mq_alloc_requests(struct
> blk_mq_alloc_data *data)
>   {
> +	const bool is_passthrough = blk_op_is_passthrough(data-
> >cmd_flags);
>   	struct request_queue *q = data->q;
>   	u64 alloc_time_ns = 0;
>   	struct request *rq;
> @@ -455,8 +456,7 @@ static struct request
> *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
>   		 * dispatch list. Don't include reserved tags in the
>   		 * limiting, as it isn't useful.
>   		 */
> -		if (!op_is_flush(data->cmd_flags) &&
> -		    !blk_op_is_passthrough(data->cmd_flags) &&
> +		if (!op_is_flush(data->cmd_flags) && !is_passthrough &&
>   		    e->type->ops.limit_depth &&
>   		    !(data->flags & BLK_MQ_REQ_RESERVED))
>   			e->type->ops.limit_depth(data->cmd_flags,
> data);
> @@ -465,7 +465,7 @@ static struct request
> *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
>   retry:
>   	data->ctx = blk_mq_get_ctx(q);
>   	data->hctx = blk_mq_map_queue(q, data->cmd_flags, data->ctx);
> -	if (!(data->rq_flags & RQF_ELV))
> +	if (!(data->rq_flags & RQF_ELV) && !is_passthrough)
>   		blk_mq_tag_busy(data->hctx);
> 
>   	/*
> @@ -575,10 +575,10 @@ struct request
> *blk_mq_alloc_request_hctx(struct request_queue *q,
>   	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
>   	data.ctx = __blk_mq_get_ctx(q, cpu);
> 
> -	if (!q->elevator)
> -		blk_mq_tag_busy(data.hctx);
> -	else
> +	if (q->elevator)
>   		data.rq_flags |= RQF_ELV;
> +	else if (!blk_op_is_passthrough(data.cmd_flags))
> +		blk_mq_tag_busy(data.hctx);
> 
>   	ret = -EWOULDBLOCK;
>   	tag = blk_mq_get_tag(&data);
> @@ -1369,7 +1369,8 @@ static bool __blk_mq_alloc_driver_tag(struct
> request *rq)
>   	unsigned int tag_offset = rq->mq_hctx->tags->nr_reserved_tags;
>   	int tag;
> 
> -	blk_mq_tag_busy(rq->mq_hctx);
> +	if (!blk_rq_is_passthrough(rq))
> +		blk_mq_tag_busy(rq->mq_hctx);
> 
>   	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq-
> >internal_tag)) {
>   		bt = &rq->mq_hctx->tags->breserved_tags;
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index fcecbc4ee81b..2c9e9c79ca34 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -1360,25 +1360,6 @@ static int ufshcd_devfreq_target(struct device
> *dev,
>   	return ret;
>   }
> 
> -static bool ufshcd_is_busy(struct request *req, void *priv, bool
> reserved)
> -{
> -	int *busy = priv;
> -
> -	WARN_ON_ONCE(reserved);
> -	(*busy)++;
> -	return false;
> -}
> -
> -/* Whether or not any tag is in use by a request that is in
> progress. */
> -static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
> -{
> -	struct request_queue *q = hba->host->internal_queue;
> -	int busy = 0;
> -
> -	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
> -	return busy;
> -}
> -
>   static int ufshcd_devfreq_get_dev_status(struct device *dev,
>   		struct devfreq_dev_status *stat)
>   {
> @@ -1778,7 +1759,7 @@ static void ufshcd_gate_work(struct work_struct
> *work)
> 
>   	if (hba->clk_gating.active_reqs
>   		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
> -		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
> +		|| hba->outstanding_reqs || hba->outstanding_tasks
>   		|| hba->active_uic_cmd || hba->uic_async_done)
>   		goto rel_lock;
> 
> @@ -2996,12 +2977,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba
> *hba,
>   	req = scsi_cmd_to_rq(scmd);
>   	tag = req->tag;
>   	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n",
> tag);
> -	/*
> -	 * Start the request such that blk_mq_tag_idle() is called when
> the
> -	 * device management request finishes.
> -	 */
> -	blk_mq_start_request(req);
> -
>   	lrbp = &hba->lrb[tag];
>   	WARN_ON(lrbp->cmd);
>   	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
> @@ -6792,12 +6767,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct
> ufs_hba *hba,
>   	req = scsi_cmd_to_rq(scmd);
>   	tag = req->tag;
>   	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n",
> tag);
> -	/*
> -	 * Start the request such that blk_mq_tag_idle() is called when
> the
> -	 * device management request finishes.
> -	 */
> -	blk_mq_start_request(req);
> -
>   	lrbp = &hba->lrb[tag];
>   	WARN_ON(lrbp->cmd);
>   	lrbp->cmd = NULL;
> 
> Thanks,
> 
> Bart.

