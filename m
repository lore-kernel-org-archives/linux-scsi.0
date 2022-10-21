Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF59BC433FE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Oct 2022 18:21:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiJUSVf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Oct 2022 14:21:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57502 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiJUSVe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Oct 2022 14:21:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74AE922B39A
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 11:21:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1666376491;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sNGH9z+eh0ypQ19asQ2X+zJFPnQXrVNXPHMyra1epkI=;
        b=XjHZksdjcr7zsn9Whh18B/Yr55N82gwp24UQ/9BYCJY3gw4XhqrUgixvRZMw2ZEISMGCPW
        GN+P62HKK69E0k5UyXFWQbWHc9spJ/Y7ZxB13/A/ofgb2L2nzHxVpp5w0tcr0Ghm89qTwX
        sH93asmBBVdKygKj6g2OIGnKdpXJ7jE=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-149-a0SRvCEYNiaCrnHhkeGXLA-1; Fri, 21 Oct 2022 14:21:30 -0400
X-MC-Unique: a0SRvCEYNiaCrnHhkeGXLA-1
Received: by mail-ed1-f71.google.com with SMTP id t5-20020a056402524500b0045cf8249863so3380687edd.4
        for <linux-scsi@vger.kernel.org>; Fri, 21 Oct 2022 11:21:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sNGH9z+eh0ypQ19asQ2X+zJFPnQXrVNXPHMyra1epkI=;
        b=F2060eYqeOjrGOn10jSBLH9EwRasQWVNhr8wThZv3cuJMjh9Ma93S6mv7qXd3yfjZx
         yIGCDwNz+Lx4H7rqmXc99hEVDhbX/mWci+O+vJetwZHwLZA8BrQxyY7sFx62Fc3N8IL3
         5zlmBUBmMH6gTImY4yE47t/ZO4B/kzDxtl1CX6ruxDCn0SNaUoNclJ1GR9sAefFD2wWX
         bm6/ngsBsU9K+cgrI0os4z8W0UbSqvzwV126FuE9NWM03rUuUbQapRh7E1y/0JSPLYFV
         5JtTCQijMF9a654n/rBFogNByPRuVC/3nydpdQQKJI5suYKKY/pdX2KenFW6aAHHHK+m
         /0bw==
X-Gm-Message-State: ACrzQf3bISe5DX5nCN+shN98kJQWr6IYwYjuS8srwy1YDMv+K5AnF09Q
        JhSgFKwHJ4BxRksbgrnCepUHg+VB42fR9rwAJ5HYLwQRPhu7rBlfditOnvLe9t8Bj7l/wjlbc+g
        jBR3M0acTB0phejVanjLMicANZaHWAmkvFb+A/w==
X-Received: by 2002:a05:6402:2201:b0:44f:443e:2a78 with SMTP id cq1-20020a056402220100b0044f443e2a78mr18399035edb.76.1666376489038;
        Fri, 21 Oct 2022 11:21:29 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM7aBfhIanno4mBihgGOTmZ60qsyNp5zSVNSATwSqwsqFUmrQlF6JNovRIAd/E97DiLinAjcrKoJYn8Emb6Pno0=
X-Received: by 2002:a05:6402:2201:b0:44f:443e:2a78 with SMTP id
 cq1-20020a056402220100b0044f443e2a78mr18399019edb.76.1666376488861; Fri, 21
 Oct 2022 11:21:28 -0700 (PDT)
MIME-Version: 1.0
References: <Y1EQdafQlKNAsutk@T590> <Y1Ktf2jRTlPMQwJR@kbusch-mbp.dhcp.thefacebook.com>
In-Reply-To: <Y1Ktf2jRTlPMQwJR@kbusch-mbp.dhcp.thefacebook.com>
From:   David Jeffery <djeffery@redhat.com>
Date:   Fri, 21 Oct 2022 14:21:17 -0400
Message-ID: <CA+-xHTHL3G5kvFf-h1jNJj+KxWEU3iru3s6NK7CDR7EgwuUD2g@mail.gmail.com>
Subject: Re: [Bug] double ->queue_rq() because of timeout in ->queue_rq()
To:     Keith Busch <kbusch@kernel.org>
Cc:     Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>, stefanha@redhat.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

blk_On Fri, Oct 21, 2022 at 10:40 AM Keith Busch <kbusch@kernel.org> wrote:
>
> The blk_mq_wait_quiesce_done() will only wait for tasks that entered
> just before calling that function. It will not wait for tasks that
> entered immediately after.

Right. The design was depending on saving a jiffies value before the
blk_mq_wait_quiesce_done() call and deadline behavior to avoid having
to care about queue_rq calls starting after
blk_mq_wait_quiesce_done().

> If I correctly understand the problem you're describing, the hypervisor
> may prevent any guest process from running. If so, the timeout work may
> be stalled after the quiesce, and if a queue_rq() process also stalled
> after starting quiesce_done(), then we're in the same situation you're
> trying to prevent, right?

For handling this condition and avoiding the issue, the code was
depending on the deadline value and rq->state value.
blk_mq_start_request sets a deadline then sets MQ_RQ_IN_FLIGHT, while
blk_mq_req_expired checks for MQ_RQ_IN_FLIGHT then checks the
deadline. A new queue_rq call would then not count as expired from
these checks from either its deadline being updated to be in the
future or from missing MQ_RQ_IN_FLIGHT .

However, there are no memory barriers ensuring this ordering. So it
looks like it should prevent an issue with a new queue_rq on x86 cpus
but could race on cpus with weaker memory ordering.


> I agree with your idea that this is a lower level driver responsibility:
> it should reclaim all started requests before allowing new queuing.
> Perhaps the block layer should also raise a clear warning if it's
> queueing a request that's already started.
>

If I understand what you are saying, that is roughly how the old scsi
timeout handling used to work before the async-abort changes. It
prevented new requests and drained everything (though HBA-wide not
just request_queue-wide) before doing anything with timed out
commands. The current implementation makes avoiding race conditions
more difficult but reduces the performance impact of a lone
misbehaving request.

So a driver under the block layer could potentially avoid the current
races by properly quiescing the request_queue before handling any
timed out requests. But I was trying to come up with a solution which
avoided that requirement.

David Jeffery

