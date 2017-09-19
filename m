From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/5] block: don't call blk_mq_delay_run_hw_queue() in case
 of BLK_STS_RESOURCE
Date: Wed, 20 Sep 2017 00:55:37 +0800
Message-ID: <CACVXFVNvGna59hYG+gF7O41tKNURdbb+gm0sW-FGemnJi0RrRg@mail.gmail.com>
References: <20170915164456.9803-1-ming.lei@redhat.com> <20170915164456.9803-2-ming.lei@redhat.com>
 <1505498249.3420.15.camel@wdc.com> <20170917124000.GB6289@ming.t460p>
 <1505747894.2685.6.camel@wdc.com> <20170919054308.GA2517@ming.t460p>
 <1505835394.2671.18.camel@wdc.com> <20170919155603.GB22809@redhat.com>
 <20170919160401.GC19830@ming.t460p> <1505839754.2671.42.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wr0-f179.google.com ([209.85.128.179]:47871 "EHLO
        mail-wr0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750733AbdISQzj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Sep 2017 12:55:39 -0400
In-Reply-To: <1505839754.2671.42.camel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "ming.lei@redhat.com" <ming.lei@redhat.com>, "snitzer@redhat.com" <snitzer@redhat.com>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "sagi@grimberg.me" <sagi@grimberg.me>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "loberman@redhat.com" <loberman@redhat.com>, "dm-devel@redhat.com" <dm-devel@redhat.com>

On Wed, Sep 20, 2017 at 12:49 AM, Bart Van Assche
<Bart.VanAssche@wdc.com> wrote:
> On Wed, 2017-09-20 at 00:04 +0800, Ming Lei wrote:
>> Run queue at end_io is definitely wrong, because blk-mq has SCHED_RESTART
>> to do that already.
>
> Sorry but I disagree. If SCHED_RESTART is set that causes the blk-mq core to
> reexamine the software queues and the hctx dispatch list but not the requeue
> list. If a block driver returns BLK_STS_RESOURCE then requests end up on the
> requeue list. Hence the following code in scsi_end_request():

That doesn't need SCHED_RESTART, because it is requeue's
responsibility to do that,
see blk_mq_requeue_work(), which will run hw queue at the end of this func.


-- 
Ming Lei
