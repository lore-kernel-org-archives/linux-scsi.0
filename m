Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52213C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 01:26:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 336FA61057
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 01:26:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233133AbhIMB2L (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Sep 2021 21:28:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:46948 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236696AbhIMB2K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 12 Sep 2021 21:28:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631496415;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JnmC4ls1XV9CkRZPqEmQ5Xb1rz/zwwpt+BLIzR3XI9I=;
        b=X1/6Pdh4HwjoUunBbBVnVfk7QO05FExGpkrOKfZeSJY/vyphnOgqRRDKzD0WFZugd2EnXR
        u5Wt7bg3L5hvEDZRvwaV/NHFNFlbSilCvtPJJi5+yMbME1tKqKJ2xuOy7IDHlF+XoWLBSh
        BdZEGOdjkdyev/7LJpMoGL6kXRZszLM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-559-rl9BYn3WN6GgbwRDz0UGfg-1; Sun, 12 Sep 2021 21:26:54 -0400
X-MC-Unique: rl9BYn3WN6GgbwRDz0UGfg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BE3A4362F8;
        Mon, 13 Sep 2021 01:26:52 +0000 (UTC)
Received: from T590 (ovpn-12-120.pek2.redhat.com [10.72.12.120])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3625510013C1;
        Mon, 13 Sep 2021 01:26:44 +0000 (UTC)
Date:   Mon, 13 Sep 2021 09:26:52 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        luojiaxing <luojiaxing@huawei.com>
Subject: Re: [PATCH] blk-mq: avoid to iterate over stale request
Message-ID: <YT6o3Lt8II2ZIOlf@T590>
References: <20210906065003.439019-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210906065003.439019-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 06, 2021 at 02:50:03PM +0800, Ming Lei wrote:
> blk-mq can't run allocating driver tag and updating ->rqs[tag]
> atomically, meantime blk-mq doesn't clear ->rqs[tag] after the driver
> tag is released.
> 
> So there is chance to iterating over one stale request just after the
> tag is allocated and before updating ->rqs[tag].
> 
> scsi_host_busy_iter() calls scsi_host_check_in_flight() to count scsi
> in-flight requests after scsi host is blocked, so no new scsi command can
> be marked as SCMD_STATE_INFLIGHT. However, driver tag allocation still can
> be run by blk-mq core. One request is marked as SCMD_STATE_INFLIGHT,
> but this request may have been kept in another slot of ->rqs[], meantime
> the slot can be allocated out but ->rqs[] isn't updated yet. Then this
> in-flight request is counted twice as SCMD_STATE_INFLIGHT. This way causes
> trouble in handling scsi error.
> 
> Fixes the issue by not iterating over stale request.
> 
> Cc: linux-scsi@vger.kernel.org
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Reported-by: luojiaxing <luojiaxing@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Hello Jens,

luojiaxiang has verified that this patch fixes his issue, any chance to
merge it?


Thanks,
Ming

