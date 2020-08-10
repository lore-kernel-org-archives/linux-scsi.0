Return-Path: <SRS0=QZQu=BU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDF84C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 16:51:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8EE19207DE
	for <linux-scsi@archiver.kernel.org>; Mon, 10 Aug 2020 16:51:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Jrx/GSu1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727028AbgHJQvV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Aug 2020 12:51:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726720AbgHJQvU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2020 12:51:20 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 633BDC061756
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 09:51:20 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id b2so4541378qvp.9
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2020 09:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=j7Nx7N4OeE4KkW4jW5KoZv1rUhElZ3FsfhltIpm/oPA=;
        b=Jrx/GSu10mjBSWF2jZr+/m7e/fJA1rnd8TGZPs/A5pZIbFl6YUInjkQ8BOVVmw1aaD
         JEsc7ZzM8tkQscXbnK8Xls+9V4u0cQElwwTxzPWpc7SOB/Z4NR33t79fwvmuETwXawt6
         GTeskoGeAxf82hQPzpISEE4d4rxPChp762jC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=j7Nx7N4OeE4KkW4jW5KoZv1rUhElZ3FsfhltIpm/oPA=;
        b=LWAMTy7QwGaKN2kC2Lxbu5LtBwStAgufGgyWpQb1AlkvUXuzGtOWrgIgjplN4XoGvw
         JZ+iXZCg5znMCjtHe+zUjLF/iyVWTiiwrdgfvK2VR3T073I+gw+NWkf9PuIlGbc/AJOZ
         wS+BnKHQ5O4kg199HGpblW+L7d17EvvXb0Us0u9HMvka2AV54QrLYSOu7T7WxyBTVjwL
         HMeVZFFEHxbGPZV1jYnpmr4M1zk4BQULZdVjNe103crUybExZ1+t4cTkqX7QMMSI6Q7z
         YolM7xLivEFWbm16n61vkM6ZLRBhtN5F+3oKIufu0gSo9msQE0ymeAhN/CeAPPLiaBeE
         yGCA==
X-Gm-Message-State: AOAM530NWnptvVFu8ouN7X+apbtf42jAcBGm8T0pwgYAaBIbDeiOAwjo
        9T8xPQ7yDs4cUXtHRid8wqC0kEdi35ZIYw6jnMWKZA==
X-Google-Smtp-Source: ABdhPJxWwHQ4+VVD7ZA1DPCQQZe2AzFleL9gJSSX1Hdn4b/7UH0mn0IQslmGaUb9LxTFCqnvFHsxdbqVt0Eb+Dy37aM=
X-Received: by 2002:a0c:d981:: with SMTP id y1mr30169563qvj.124.1597078279461;
 Mon, 10 Aug 2020 09:51:19 -0700 (PDT)
From:   Kashyap Desai <kashyap.desai@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-3-git-send-email-john.garry@huawei.com>
 <20200611025759.GA453671@T590> <6ef76cdf-2fb3-0ce8-5b5a-0d7af0145901@huawei.com>
 <8ef58912-d480-a7e1-f04c-da9bd85ea0ae@huawei.com> <eaf188d5-dac0-da44-1c83-31ff2860d8fa@suse.de>
 e42da0e714c808c80e9a055f3f065e44@mail.gmail.com
In-Reply-To: e42da0e714c808c80e9a055f3f065e44@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQBVjmvxAE7FMYb7GtMRWGcwtMcECgJRJzAeAmYD0J0CUmtFnQMQPP3WAliipVSrhUrmoIBKbxJA
Date:   Mon, 10 Aug 2020 22:21:16 +0530
Message-ID: <3b80b46173103c62c2f94e25ff517058@mail.gmail.com>
Subject: RE: [PATCH RFC v7 02/12] blk-mq: rename blk_mq_update_tag_set_depth()
To:     Hannes Reinecke <hare@suse.de>, John Garry <john.garry@huawei.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> > Kashyap, I've also attached an updated patch for the elevator_count
> > patch; if you agree John can include it in the next version.
>
> Hannes - Patch looks good.   Header does not include problem statement.
> How about adding below in header ?
>
> High CPU utilization on "native_queued_spin_lock_slowpath" due to lock
> contention is possible in mq-deadline and bfq io scheduler when
> nr_hw_queues is more than one.
> It is because kblockd work queue can submit IO from all online CPUs
> (through
> blk_mq_run_hw_queues) even though only one hctx has pending commands.
> Elevator callback "has_work" for mq-deadline and bfq scheduler consider
> pending work if there are any IOs on request queue and it does not account
> hctx context.

Hannes/John - We need one more correction for below patch -

https://github.com/hisilicon/kernel-dev/commit/ff631eb80aa0449eaeb78a282fd7eff2a9e42f77

I noticed - that elevator_queued count goes negative mainly because there
are some case where IO was submitted from dispatch queue(not scheduler
queue) and request still has "RQF_ELVPRIV" flag set.
In such cases " dd_finish_request" is called without " dd_insert_request". I
think it is better to decrement counter once it is taken out from dispatched
queue. (Ming proposed to use dispatch path for decrementing counter, but I
somehow did not accounted assuming RQF_ELVPRIV will be set only if IO is
submitted from scheduler queue.)

Below is additional change. Can you merge this ?

diff --git a/block/mq-deadline.c b/block/mq-deadline.c
index 9d75374..bc413dd 100644
--- a/block/mq-deadline.c
+++ b/block/mq-deadline.c
@@ -385,6 +385,8 @@ static struct request *dd_dispatch_request(struct
blk_mq_hw_ctx *hctx)

        spin_lock(&dd->lock);
        rq = __dd_dispatch_request(dd);
+       if (rq)
+               atomic_dec(&rq->mq_hctx->elevator_queued);
        spin_unlock(&dd->lock);

        return rq;
@@ -574,7 +576,6 @@ static void dd_finish_request(struct request *rq)
                        blk_mq_sched_mark_restart_hctx(rq->mq_hctx);
                spin_unlock_irqrestore(&dd->zone_lock, flags);
        }
-       atomic_dec(&rq->mq_hctx->elevator_queued);
 }

 static bool dd_has_work(struct blk_mq_hw_ctx *hctx)
--
2.9.5

Kashyap
