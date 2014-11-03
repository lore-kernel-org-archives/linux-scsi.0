From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Mon, 3 Nov 2014 01:46:33 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B402959354E19@G9W0745.americas.hpqcorp.net>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org>
 <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org>
 <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il>
 <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il>
 <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il>
 <545256E5.9010501@acm.org> <5452765E.1040604@dev.mellanox.co.il>
 <5453541D.7040206@acm.org> <54562B9C.3040004@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:18854 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752046AbaKCBrV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Nov 2014 20:47:21 -0500
In-Reply-To: <54562B9C.3040004@dev.mellanox.co.il>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>



> -----Original Message-----
> From: Sagi Grimberg [mailto:sagig@dev.mellanox.co.il]
> Sent: Sunday, November 02, 2014 7:03 AM
> To: Bart Van Assche; Christoph Hellwig
> Cc: Jens Axboe; Sagi Grimberg; Sebastian Parschauer; Elliott, Robert
> (Server Storage); Ming Lei; linux-scsi@vger.kernel.org; linux-rdma
> Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
> 
...
> IMHO, this is not iSER specific issue, it is easily indicated from the
> code that a specific workload SRP will poll recv completion queue
> forever in an interrupt context.
> 
> I encountered this issue on a virtual guest in a high workload (80+
> sessions with heavy traffic on all) because qemu smp_affinity setting
> was broken (might still be, didn't check that for a while). This caused
> all completion vectors to fire interrupts to core 0 causing a high
> events contention on a single event queue (causing lockup situations
> and starvation of other CQs). Using more completion queues will enhance
> this situation.
> 
> I think running multichannel code when all MSIX vectors affinity are
> directed to a single CPU can invoke what I'm talking about.

That's not an SRP specific problem either.  If you ask just one CPU to
service interrupts and block layer completions for submissions from lots
of other CPUs, it's bound to become overloaded.

Setting rq_affinity=2 helps quite a bit for the block layer completion
work.  This patch proposed making that the default for blk-mq:
	https://lkml.org/lkml/2014/9/9/931

For SRP interrupt processing, irqbalance recently changed its default 
to ignore the affinity_hint; you now need to pass an option to honor
the hint, or provide a policy script to do so for selected irqs.  For
multi-million IOPS workloads, irqbalance takes far too long to reroute
them based on activity; you're likely to overload a CPU with 100% 
hardirq processing, creating self-detected stalls for the submitting
processes on that CPU and other problems.  Sending interrupts back 
to the submitting CPU provides self-throttling.

