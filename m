From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: scsi-mq prototype
Date: Mon, 09 Dec 2013 13:05:51 -0800
Message-ID: <1386623151.20247.43.camel@haakon3.risingtidesystems.com>
References: <1373588612.7397.447.camel@haakon3.risingtidesystems.com>
	 <52989FF6.4020307@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48944 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755833Ab3LIVFT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Dec 2013 16:05:19 -0500
In-Reply-To: <52989FF6.4020307@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Fri, 2013-11-29 at 15:08 +0100, Bart Van Assche wrote:
> On 07/12/13 02:23, Nicholas A. Bellinger wrote:
> > [ ... ] I would like to discuss scsi-mq, a high performance SCSI
> > initiator prototype that utilizes blk-mq [ ... ]
> 
> (replying to an e-mail of four months ago)
> 
> It took a while but I finally found some time to look further into
> blk-mq and scsi-mq. Did I see correctly that the scsi-mq prototype
> implements the so-called hw queues in the SCSI core and not in the SCSI
> LLDs ?

No.  The hw queues are coming from blk-mq, and there is no extra queues
implemented by scsi-mq.

>  Sorry but that approach looks wrong to me. Several high-end
> storage adapters already support multiple queues today. E.g. the NVMe
> specification supports up to 64.000 I/O queues. With InfiniBand HCA's it
> is possible to create multiple queues between initiator and target for
> e.g. the iSER and SRP protocols to increase throughput. When there are
> multiple queues between initiator and target there is a potential that
> SCSI commands get reordered. The SCSI specifications define whether or
> not it is allowed to change the submission order of commands. As an
> example, if two atomic writes are submitted by the same CPU neither the
> block layer nor the SCSI core nor the SCSI LLD nor the SCSI target is
> allowed to reorder these. With the scsi-mq prototype present in your
> repo the only way for a SCSI LLD to guarantee that SCSI commands for
> which the submission order must be preserved do not get reordered is
> either to limit the queue depth to one or to use a single queue for
> communication with the target. I don't think this is what we want.
> 

In case you haven't already noticed, all of the scsi-mq logic is running
with nr_hw_queues=1, which by itself gives a huge performance + latency
improvement vs. existing scsi_request_fn() based logic.

Frankly, getting this to work properly for all cases is currently higher
on my priority list than enabling nr_hw_queues > 1.

> In other words, the so-called hw queue concept must be mapped onto
> queues managed by the SCSI LLD and not onto queues managed by the SCSI
> core. That will allow the block layer and the SCSI core to preserve SCSI
> command submission order when necessary by queueing ordered commands on
> the same hardware queue.
> 

Perhaps once nr_hw_queues > 1 logic is enabled in scsi-mq, you can send
a patch series to address your concerns.

Without patches, your observations aren't particular helpful.

--nab

