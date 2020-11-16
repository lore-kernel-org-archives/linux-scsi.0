Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A995DC61DD8
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:14:59 +0000 (UTC)
Received: from vger.kernel.org (unknown [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EFF520888
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 17:14:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3EFF520888
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=linux-scsi-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732594AbgKPROk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:14:40 -0500
Received: from verein.lst.de ([213.95.11.211]:55218 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731869AbgKPROk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 12:14:40 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id AC3176736F; Mon, 16 Nov 2020 18:14:35 +0100 (CET)
Date:   Mon, 16 Nov 2020 18:14:35 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Ming Lei <ming.lei@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        stable <stable@vger.kernel.org>, Can Guo <cang@codeaurora.org>
Subject: Re: [PATCH v2 1/9] block: Fix a race in the runtime power
 management code
Message-ID: <20201116171435.GA22007@lst.de>
References: <20201116030459.13963-1-bvanassche@acm.org> <20201116030459.13963-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201116030459.13963-2-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Nov 15, 2020 at 07:04:51PM -0800, Bart Van Assche wrote:
> With the current implementation the following race can happen:
> * blk_pre_runtime_suspend() calls blk_freeze_queue_start() and
>   blk_mq_unfreeze_queue().
> * blk_queue_enter() calls blk_queue_pm_only() and that function returns
>   true.
> * blk_queue_enter() calls blk_pm_request_resume() and that function does
>   not call pm_request_resume() because the queue runtime status is
>   RPM_ACTIVE.
> * blk_pre_runtime_suspend() changes the queue status into RPM_SUSPENDING.
> 
> Fix this race by changing the queue runtime status into RPM_SUSPENDING
> before switching q_usage_counter to atomic mode.

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
