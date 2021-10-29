Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF047C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 01:33:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8F4F961166
	for <linux-scsi@archiver.kernel.org>; Fri, 29 Oct 2021 01:33:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbhJ2Bf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 21:35:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:21964 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230489AbhJ2Bf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 21:35:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635471180;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8oj4fyiyXkG+xWHY3UZohwql1+uMDTmQEs2CRVMjkdw=;
        b=OttkDeARrogvy0SeCZHjk08m4KvOfcki6S3qtijX7CFoN3k8S5z6kmyyZiVg6cT11a7q1X
        sJjnWNkIu0GJM93eEavci2PoA0ARLFNM+PrnAtNXhbqLcSZvyuLD86ZKo0Sb9Q8qJ+rtkC
        EDewJ6Vw7cG3/SptrFd1GOTkejsw6bY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-75-aaIoXy5kP6-7LrAwS6jEmA-1; Thu, 28 Oct 2021 21:32:57 -0400
X-MC-Unique: aaIoXy5kP6-7LrAwS6jEmA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4F705802B4F;
        Fri, 29 Oct 2021 01:32:55 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 08AED60BF1;
        Fri, 29 Oct 2021 01:32:41 +0000 (UTC)
Date:   Fri, 29 Oct 2021 09:32:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "huobean@gmail.com" <huobean@gmail.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ming.lei@redhat.com
Subject: Re: [PATCH] scsi: ufs: Fix proper API to send HPB pre-request
Message-ID: <YXtPNIDzeln8zBCn@T590>
References: <CGME20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
 <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211027223619epcms2p60bbc74c9ba9757c58709a99acd0892ff@epcms2p6>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 28, 2021 at 07:36:19AM +0900, Daejun Park wrote:
> This patch addresses the issue of using the wrong API to create a
> pre_request for HPB READ.
> HPB READ candidate that require a pre-request will try to allocate a
> pre-request only during request_timeout_ms (default: 0). Otherwise, it is

Can you explain about 'only during request_timeout_ms'?

From the following code in ufshpb_prep(), the pre-request is allocated
for each READ IO in case of (!ufshpb_is_legacy(hba) && ufshpb_is_required_wb(hpb,
transfer_len)).

   if (!ufshpb_is_legacy(hba) &&
            ufshpb_is_required_wb(hpb, transfer_len)) {
                err = ufshpb_issue_pre_req(hpb, cmd, &read_id);

> passed as normal READ, so deadlock problem can be resolved.
> 
> Signed-off-by: Daejun Park <daejun7.park@samsung.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 11 +++++------
>  drivers/scsi/ufs/ufshpb.h |  1 +
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index 02fb51ae8b25..3117bd47d762 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -548,8 +548,7 @@ static int ufshpb_execute_pre_req(struct ufshpb_lu *hpb, struct scsi_cmnd *cmd,
>  				 read_id);
>  	rq->cmd_len = scsi_command_size(rq->cmd);
>  
> -	if (blk_insert_cloned_request(q, req) != BLK_STS_OK)
> -		return -EAGAIN;
> +	blk_execute_rq_nowait(NULL, req, true, ufshpb_pre_req_compl_fn);

Be care with above change, blk_insert_cloned_request() allocates
driver tag and issues the request to LLD directly, then returns the
result. If anything fails in the code path, -EAGAIN is returned.

But blk_execute_rq_nowait() simply queued the request in block layer,
and run hw queue. It doesn't allocate driver tag, and doesn't issue it
to LLD.

So ufshpb_execute_pre_req() may think the pre-request is issued to LLD
successfully, but actually not, maybe never. What will happen after the
READ IO is issued to device, but the pre-request(write buffer) isn't
sent to device?

>  
>  	hpb->stats.pre_req_cnt++;
>  
> @@ -2315,19 +2314,19 @@ struct attribute_group ufs_sysfs_hpb_param_group = {
>  static int ufshpb_pre_req_mempool_init(struct ufshpb_lu *hpb)
>  {
>  	struct ufshpb_req *pre_req = NULL, *t;
> -	int qd = hpb->sdev_ufs_lu->queue_depth / 2;
>  	int i;
>  
>  	INIT_LIST_HEAD(&hpb->lh_pre_req_free);
>  
> -	hpb->pre_req = kcalloc(qd, sizeof(struct ufshpb_req), GFP_KERNEL);
> -	hpb->throttle_pre_req = qd;
> +	hpb->pre_req = kcalloc(HPB_INFLIGHT_PRE_REQ, sizeof(struct ufshpb_req),
> +			       GFP_KERNEL);
> +	hpb->throttle_pre_req = HPB_INFLIGHT_PRE_REQ;
>  	hpb->num_inflight_pre_req = 0;
>  
>  	if (!hpb->pre_req)
>  		goto release_mem;
>  
> -	for (i = 0; i < qd; i++) {
> +	for (i = 0; i < HPB_INFLIGHT_PRE_REQ; i++) {
>  		pre_req = hpb->pre_req + i;
>  		INIT_LIST_HEAD(&pre_req->list_req);
>  		pre_req->req = NULL;
> diff --git a/drivers/scsi/ufs/ufshpb.h b/drivers/scsi/ufs/ufshpb.h
> index a79e07398970..411a6d625f53 100644
> --- a/drivers/scsi/ufs/ufshpb.h
> +++ b/drivers/scsi/ufs/ufshpb.h
> @@ -50,6 +50,7 @@
>  #define HPB_RESET_REQ_RETRIES			10
>  #define HPB_MAP_REQ_RETRIES			5
>  #define HPB_REQUEUE_TIME_MS			0
> +#define HPB_INFLIGHT_PRE_REQ			4

Can you explain how this change solves the deadlock?

Thanks,
Ming

