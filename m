From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Fri, 31 Oct 2014 10:19:25 +0100
Message-ID: <5453541D.7040206@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il> <54450690.709@acm.org> <544622FE.5040906@dev.mellanox.co.il> <544FE13A.60807@dev.mellanox.co.il> <5450C6FC.90908@acm.org> <545248F8.8020102@dev.mellanox.co.il> <54524D08.4040203@acm.org> <545253E3.7000009@dev.mellanox.co.il> <545256E5.9010501@acm.org> <5452765E.1040604@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:43819 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756137AbaJaJTe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Oct 2014 05:19:34 -0400
In-Reply-To: <5452765E.1040604@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/30/14 18:33, Sagi Grimberg wrote:
> Now I realize that we can hit serious problems here since we never
> solved the issue of srp polling routine that might poll forever within
> an interrupt (or at least until a hard lockup). Its interesting that
> you weren't able to hit that with a high workload. Did you try running
> this code on a virtual function (I witnessed this issue in iser on a VM).
>
> Moreover, the fairness issue is even more likely to be encountered in
> multichannel. Did you try to hit that? I really think this patchset
> *needs* to deal with the 2 issues I mentioned as the probability of
> hitting them increases with a faster IO stack.
>
> I remember this was discussed lately with consideration for using
> blk-iopoll or not. But I think that for now the initial approach of
> bailing out of the once we hit a budget is fine for now.

Hello Sagi,

As you mentioned so far this fairness issue has only caused trouble with 
iSER in a virtual machine guest. I have not yet seen anyone reporting a 
QP servicing fairness problem for the SRP initiator. Although analyzing 
and if needed limiting the maximum number of iterations in the SRP 
polling routine is on my to-do list, addressing that issue is outside of 
the scope of this patch series.

Regarding the impact of this patch series on QP handling fairness: the 
time spent in the SRP RDMA completion handler depends on the number of 
completions processed at once. This number depends on:
(a) The number of CPU cores in the initiator system that submit I/O and
     that are associated with a single RDMA channel.
(b) The target system processing speed per RDMA channel.

This patch series reduces (a) by a factor ch_count. (b) is either 
unaffected (linear scaling) or slightly reduced (less than linear 
scaling). My conclusion is that if this patch series has an impact on QP 
handling fairness that it will improve fairness since the number of 
completions processed at once either remains unchanged or that it is 
reduced.

Bart.
