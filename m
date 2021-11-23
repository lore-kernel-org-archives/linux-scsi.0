Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FE6CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Nov 2021 19:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236928AbhKWTpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Nov 2021 14:45:08 -0500
Received: from mail-pg1-f180.google.com ([209.85.215.180]:41919 "EHLO
        mail-pg1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234047AbhKWTpF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Nov 2021 14:45:05 -0500
Received: by mail-pg1-f180.google.com with SMTP id 28so44178pgq.8
        for <linux-scsi@vger.kernel.org>; Tue, 23 Nov 2021 11:41:56 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZybFKEdEdT9bb+3Vv17hz7BIhbjWKIbGQ4WW8Kkh9L8=;
        b=4v4EdRn37+x1oTsY9MmccR5glSyHdY8J4tK6S9dck3bj4fm9wJqP+wp7mXt5muxoBt
         rphIfLfyCdH6nNi0QbKZiF/ulLBdkYcHWh9s1Z2OV4yqUc+6Hf9BGm5HMmFqcg5gQD9I
         aGfWBFW31eXahflJGbBPMZ5pL+9fT1eJOU89el9WLO5ZqUInBo+tmqePDvyGXSIzfuk/
         2Ujy6vMKttxMUrO1Scam8T8VhiPZ0ZgIoKdNvDoDIt8Ish49o+CdMbe13KxZUve6/iIP
         Y8PztVBwKGJkt0TGKyw0RNGAeZ66R3YY1BbP2oWRaSrGy3cIOll36KfYdj/7reVEkbQp
         Q8Uw==
X-Gm-Message-State: AOAM533oeOZhfVRbzG4rT/yUyvwXjqrDlSWd5U/ySWoH78CyAIvQtuIJ
        kiCxePB0Fs+rG0Gb2jjjjak=
X-Google-Smtp-Source: ABdhPJzEM8wA8Gcj5wExUa2DvXXgqwadhwxIW9cV7U3St7WMkPYVE4mQ1sRPVifQD7lii9iYo5dGOg==
X-Received: by 2002:a05:6a00:14cb:b0:49f:c028:aea6 with SMTP id w11-20020a056a0014cb00b0049fc028aea6mr7844330pfu.48.1637696516301;
        Tue, 23 Nov 2021 11:41:56 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:58e8:6593:938:2bea])
        by smtp.gmail.com with ESMTPSA id o185sm13061889pfg.113.2021.11.23.11.41.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Nov 2021 11:41:55 -0800 (PST)
Subject: Re: [PATCH v2 11/20] scsi: ufs: Switch to
 scsi_(get|put)_internal_cmd()
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Asutosh Das <asutoshd@codeaurora.org>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-12-bvanassche@acm.org>
 <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <09fc22b5-d654-4aa1-0afa-a9b99c526460@acm.org>
Date:   Tue, 23 Nov 2021 11:41:54 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <5dc2cf927a0e196067b7207ee1800a09cd769de6.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/23/21 4:20 AM, Bean Huo wrote:
> Calling blk_mq_start_request() will inject the trace print of the block
> issued, but we do not have its paired completion trace print.
> In addition, blk_mq_tag_idle() will not be called after the device
> management request is completed, it will be called after the timer
> expires.
> 
> I remember that we used to not allow this kind of LLD internal commands
> to be attached to the block layer. I now find that to be correct way.

Hi Bean,

How about modifying the block layer such that blk_mq_tag_busy() is not
called for requests with operation type REQ_OP_DRV_*? I think that will
allow to leave out the blk_mq_start_request() calls from the UFS driver.
These are the changes I currently have in mind (on top of this patch
series):

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3ab34c4f20da..a7090b509f2d 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -433,6 +433,7 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data,

  static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
  {
+	const bool is_passthrough = blk_op_is_passthrough(data->cmd_flags);
  	struct request_queue *q = data->q;
  	u64 alloc_time_ns = 0;
  	struct request *rq;
@@ -455,8 +456,7 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
  		 * dispatch list. Don't include reserved tags in the
  		 * limiting, as it isn't useful.
  		 */
-		if (!op_is_flush(data->cmd_flags) &&
-		    !blk_op_is_passthrough(data->cmd_flags) &&
+		if (!op_is_flush(data->cmd_flags) && !is_passthrough &&
  		    e->type->ops.limit_depth &&
  		    !(data->flags & BLK_MQ_REQ_RESERVED))
  			e->type->ops.limit_depth(data->cmd_flags, data);
@@ -465,7 +465,7 @@ static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
  retry:
  	data->ctx = blk_mq_get_ctx(q);
  	data->hctx = blk_mq_map_queue(q, data->cmd_flags, data->ctx);
-	if (!(data->rq_flags & RQF_ELV))
+	if (!(data->rq_flags & RQF_ELV) && !is_passthrough)
  		blk_mq_tag_busy(data->hctx);

  	/*
@@ -575,10 +575,10 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
  	cpu = cpumask_first_and(data.hctx->cpumask, cpu_online_mask);
  	data.ctx = __blk_mq_get_ctx(q, cpu);

-	if (!q->elevator)
-		blk_mq_tag_busy(data.hctx);
-	else
+	if (q->elevator)
  		data.rq_flags |= RQF_ELV;
+	else if (!blk_op_is_passthrough(data.cmd_flags))
+		blk_mq_tag_busy(data.hctx);

  	ret = -EWOULDBLOCK;
  	tag = blk_mq_get_tag(&data);
@@ -1369,7 +1369,8 @@ static bool __blk_mq_alloc_driver_tag(struct request *rq)
  	unsigned int tag_offset = rq->mq_hctx->tags->nr_reserved_tags;
  	int tag;

-	blk_mq_tag_busy(rq->mq_hctx);
+	if (!blk_rq_is_passthrough(rq))
+		blk_mq_tag_busy(rq->mq_hctx);

  	if (blk_mq_tag_is_reserved(rq->mq_hctx->sched_tags, rq->internal_tag)) {
  		bt = &rq->mq_hctx->tags->breserved_tags;
diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index fcecbc4ee81b..2c9e9c79ca34 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -1360,25 +1360,6 @@ static int ufshcd_devfreq_target(struct device *dev,
  	return ret;
  }

-static bool ufshcd_is_busy(struct request *req, void *priv, bool reserved)
-{
-	int *busy = priv;
-
-	WARN_ON_ONCE(reserved);
-	(*busy)++;
-	return false;
-}
-
-/* Whether or not any tag is in use by a request that is in progress. */
-static bool ufshcd_any_tag_in_use(struct ufs_hba *hba)
-{
-	struct request_queue *q = hba->host->internal_queue;
-	int busy = 0;
-
-	blk_mq_tagset_busy_iter(q->tag_set, ufshcd_is_busy, &busy);
-	return busy;
-}
-
  static int ufshcd_devfreq_get_dev_status(struct device *dev,
  		struct devfreq_dev_status *stat)
  {
@@ -1778,7 +1759,7 @@ static void ufshcd_gate_work(struct work_struct *work)

  	if (hba->clk_gating.active_reqs
  		|| hba->ufshcd_state != UFSHCD_STATE_OPERATIONAL
-		|| ufshcd_any_tag_in_use(hba) || hba->outstanding_tasks
+		|| hba->outstanding_reqs || hba->outstanding_tasks
  		|| hba->active_uic_cmd || hba->uic_async_done)
  		goto rel_lock;

@@ -2996,12 +2977,6 @@ static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
  	req = scsi_cmd_to_rq(scmd);
  	tag = req->tag;
  	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
-	/*
-	 * Start the request such that blk_mq_tag_idle() is called when the
-	 * device management request finishes.
-	 */
-	blk_mq_start_request(req);
-
  	lrbp = &hba->lrb[tag];
  	WARN_ON(lrbp->cmd);
  	err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
@@ -6792,12 +6767,6 @@ static int ufshcd_issue_devman_upiu_cmd(struct ufs_hba *hba,
  	req = scsi_cmd_to_rq(scmd);
  	tag = req->tag;
  	WARN_ONCE(tag < 0 || tag >= hba->nutrs, "Invalid tag %d\n", tag);
-	/*
-	 * Start the request such that blk_mq_tag_idle() is called when the
-	 * device management request finishes.
-	 */
-	blk_mq_start_request(req);
-
  	lrbp = &hba->lrb[tag];
  	WARN_ON(lrbp->cmd);
  	lrbp->cmd = NULL;

Thanks,

Bart.
