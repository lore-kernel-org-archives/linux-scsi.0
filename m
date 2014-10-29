From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Wed, 29 Oct 2014 13:36:25 +0100
Message-ID: <5450DF49.3090904@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <54462403.70700@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:43970 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932514AbaJ2Mg3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Oct 2014 08:36:29 -0400
In-Reply-To: <54462403.70700@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/21/14 11:14, Sagi Grimberg wrote:
> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>               spin_lock_irqsave(&ch->lock, flags);
>>               ch->req_lim += be32_to_cpu(rsp->req_lim_delta);
>> @@ -1906,7 +1970,7 @@ static int srp_queuecommand(struct Scsi_Host
>> *shost, struct scsi_cmnd *scmnd)
>>           goto err;
>
> Bart,
>
> Any chance you can share some perf output on this code?
> I'm interested of knowing the contention on target->lock that is
> still taken on the IO path across channels.
>
> Can we think on how to avoid it?
>
> Also would like to understand the where did the bottleneck transition.

Hello Sagi,

Are you referring to target->lock ? That lock isn't taken anywhere in 
the hot path. More in general, I haven't seen any lock contention in the 
perf output that was caused by the block layer, SCSI core, SRP initiator 
or HCA (mlx4) drivers. The code that showed up highest in the perf 
output was the direct I/O code, the code that is triggered by fio to 
submit I/O requests.

Bart.

