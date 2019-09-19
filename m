Return-Path: <SRS0=4FRQ=XO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64E27C49ED7
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:19:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3809221928
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Sep 2019 14:19:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389933AbfISOTv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Sep 2019 10:19:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38818 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388006AbfISOTv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 19 Sep 2019 10:19:51 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 39F4260149;
        Thu, 19 Sep 2019 14:19:51 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E66C66060D;
        Thu, 19 Sep 2019 14:19:40 +0000 (UTC)
Date:   Thu, 19 Sep 2019 22:19:36 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org,
        Hans Holmberg <hans.holmberg@wdc.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH 1/2] blk-mq: fixup request re-insert in
 blk_mq_try_issue_list_directly()
Message-ID: <20190919141934.GA11207@ming.t460p>
References: <20190919094547.67194-1-hare@suse.de>
 <20190919094547.67194-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190919094547.67194-2-hare@suse.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 19 Sep 2019 14:19:51 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 19, 2019 at 11:45:46AM +0200, Hannes Reinecke wrote:
> From: Hannes Reinecke <hare@suse.com>
> 
> When blk_mq_request_issue_directly() returns BLK_STS_RESOURCE we
> need to requeue the I/O, but adding it to the global request list
> will mess up with the passed-in request list. So re-add the request

We always add request to hctx->dispatch_list after .queue_rq() returns
BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE, so what is the messing up?

> to the original list and leave it to the caller to handle situations
> where the list wasn't completely emptied.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.com>
> ---
>  block/blk-mq.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index b038ec680e84..44ff3c1442a4 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -1899,8 +1899,7 @@ void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
>  		if (ret != BLK_STS_OK) {
>  			if (ret == BLK_STS_RESOURCE ||
>  					ret == BLK_STS_DEV_RESOURCE) {
> -				blk_mq_request_bypass_insert(rq,
> -							list_empty(list));
> +				list_add(list, &rq->queuelist);

This way may let this request(DONTPREP set) to be merged with other rq
or bio, and potential data corruption may be caused, please see commit:

	c616cbee97ae blk-mq: punt failed direct issue to dispatch list


Thanks,
Ming
