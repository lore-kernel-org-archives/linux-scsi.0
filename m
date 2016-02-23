From: Junichi Nomura <j-nomura@ce.jp.nec.com>
Subject: Re: why is blk-mq requeue foricbly kicking stopped queues? [was:
 Re: dm-multipath test scripts]
Date: Tue, 23 Feb 2016 01:34:37 +0000
Message-ID: <56CBB72C.20309@ce.jp.nec.com>
References: <20151007053923.GA10749@xzibit.linux.bs1.fc.nec.co.jp>
 <20160218171745.GA15071@redhat.com> <56C662F1.8070407@ce.jp.nec.com>
 <56C6D45A.6060407@ce.jp.nec.com> <20160219194216.GB21133@redhat.com>
 <20160220061247.GA23333@redhat.com> <56CADA20.7050209@ce.jp.nec.com>
 <20160222150901.GA5043@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from TYO201.gate.nec.co.jp ([210.143.35.51]:34206 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755986AbcBWBgJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Feb 2016 20:36:09 -0500
In-Reply-To: <20160222150901.GA5043@redhat.com>
Content-Language: ja-JP
Content-ID: <8B2DC5F4CBC8834494EE62AFBE142630@gisp.nec.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Snitzer <snitzer@redhat.com>, "axboe@kernel.dk" <axboe@kernel.dk>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>

On 02/23/16 00:09, Mike Snitzer wrote:
> I should note that I applied this patch for 4.6:
> https://git.kernel.org/cgit/linux/kernel/git/device-mapper/linux-dm.git/commit/?h=dm-4.6&id=7db905b3d4294e5db4c2938fb7d0e5ba4bd798d6
> 
> (but it was purely a fallout of code-review, and looking at the nvme's
> use of blk_mq_requeue_request, I did't consider it to be a critical fix
> or anything)

The patch above contains following change:

> +static void dm_mq_requeue_request(struct request *rq)
> +{
> +	struct request_queue *q = rq->q;
> +	unsigned long flags;
> +
> +	blk_mq_requeue_request(rq);
> +	spin_lock_irqsave(q->queue_lock, flags);
> +	if (!blk_queue_stopped(q))
> +		blk_mq_kick_requeue_list(q);
> +	spin_unlock_irqrestore(q->queue_lock, flags);
> +}

If you make it conditional to call blk_mq_kick_requeue_list() here,
I think we have to call the function from start_queue(), too,
otherwise requeued requests might stay forever in q->requeue_list.

-- 
Jun'ichi Nomura, NEC Corporation
