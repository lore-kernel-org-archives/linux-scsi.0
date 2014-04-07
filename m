From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: blk-mq queue selection and queue_rq preemption
Date: Mon, 07 Apr 2014 15:44:18 +0300
Message-ID: <53429DA2.4030708@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:60206 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754826AbaDGMoX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Apr 2014 08:44:23 -0400
Received: by mail-we0-f172.google.com with SMTP id t61so6759775wes.31
        for <linux-scsi@vger.kernel.org>; Mon, 07 Apr 2014 05:44:22 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>

Hey Jens, Christoph & Co,

I raised this question at LSF but didn't get a clear answer on this matter.
So it seems to me that the hctx selection and the actual request 
dispatch (queue_rq) are preemptive:
(1) blk_mq_get_ctx(q);
(2) map_queue(q, ctx->cpu);
...
(3) blk_mq_put_ctx(ctx);
(4) blk_mq_run_hw_queue(hctx, async);

It is possible that an MQ device driver may want to implement a lockless 
scheme counting on (running) CPU <-> hctx attachment.
Generally speaking, I think that LLDs will be more comfortable knowing 
that they are not preemptive in the dispatch flow.

My question is, is this a must? if so can you please explain why?

Is it possible to put the hctx (restoring preemption) after run_hw_queue 
allowing to LLDs to be sure that the selected queue
match the running CPU?

Thanks,

Sagi.
