From: Bart Van Assche <Bart.VanAssche@wdc.com>
Subject: Re: [PATCH 04/14] blk-mq-sched: improve dispatching from sw queue
Date: Tue, 1 Aug 2017 15:11:42 +0000
Message-ID: <1501600301.2475.1.camel@wdc.com>
References: <20170731165111.11536-1-ming.lei@redhat.com>
         <20170731165111.11536-6-ming.lei@redhat.com>
         <1501544074.2466.29.camel@wdc.com> <20170801101718.GB31452@ming.t460p>
         <20170801105013.GD31452@ming.t460p>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:32449 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751680AbdHAPMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 11:12:31 -0400
In-Reply-To: <20170801105013.GD31452@ming.t460p>
Content-Language: en-US
Content-ID: <5AD808312C254D4F894AD54BA845D3E1@namprd04.prod.outlook.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "ming.lei@redhat.com" <ming.lei@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>

On Tue, 2017-08-01 at 18:50 +0800, Ming Lei wrote:
> On Tue, Aug 01, 2017 at 06:17:18PM +0800, Ming Lei wrote:
> > How can we get the accurate 'number of requests in progress' efficientl=
y?

Hello Ming,

How about counting the number of bits that have been set in the tag set?
I am aware that these bits can be set and/or cleared concurrently with the
dispatch code but that count is probably a good starting point.

> > From my test data of mq-deadline on lpfc, the performance is good,
> > please see it in cover letter.
>=20
> Forget to mention, ctx->list is one per-cpu list and the lock is percpu
> lock, so changing to this way shouldn't be a performance issue.

Sorry but I don't consider this reply as sufficient. The latency of IB HCA'=
s
is significantly lower than that of any FC hardware I ran performance
measurements on myself. It's not because this patch series improves perform=
ance
for lpfc that that guarantees that there won't be a performance regression =
for
ib_srp, ib_iser or any other low-latency initiator driver for which q->dept=
h
!=3D 0.

Additionally, patch 03/14 most likely introduces a fairness problem. Should=
n't
blk_mq_dispatch_rq_from_ctxs() dequeue requests from the per-CPU queues in =
a
round-robin fashion instead of always starting at the first per-CPU queue i=
n
hctx->ctx_map?

Thanks,

Bart.
