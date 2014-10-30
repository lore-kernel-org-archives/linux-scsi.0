From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Thu, 30 Oct 2014 15:36:56 +0100
Message-ID: <54524D08.4040203@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from laurent.telenet-ops.be ([195.130.137.89]:45885 "EHLO
	laurent.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760376AbaJ3OhB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Oct 2014 10:37:01 -0400
In-Reply-To: <545248F8.8020102@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/30/14 15:19, Sagi Grimberg wrote:
> My impression here that in the default settings, on a 1 NUMA node with
> 8 cores, 2 different srp connections (using 4 channels each) will be
> associated with comp vectors 0-3. while it could potentially use
> vectors 4-7 and reduce possible mutual interference. right?

Hello Sagi,

That's correct. For this example if use of all completion vectors is 
desired additional configuration is required, e.g. by setting ch_count 
to 8 in /etc/modprobe.d/ib_srp.conf. By the way, I'm not sure it is 
possible to avoid manual configuration and tuning entirely. As an 
example, with a six core CPU at the initiator side and with 
hyperthreading enabled (12 CPU threads in total) I see higher IOPS 
results with ch_count=6 compared to ch_count=8 or ch_count=12. I have 
not tried to determine why but maybe this is because ch_count values 
that are below the number of CPU threads cause some interrupt coalescing.

Bart.
