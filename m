From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2 12/12] IB/srp: Add multichannel support
Date: Mon, 20 Oct 2014 14:56:48 +0200
Message-ID: <54450690.709@acm.org>
References: <5433E43D.3010107@acm.org> <5433E585.607@acm.org> <5443F69F.40606@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:55163 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaJTM46 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Oct 2014 08:56:58 -0400
In-Reply-To: <5443F69F.40606@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@infradead.org>
Cc: Jens Axboe <axboe@kernel.dk>, Sagi Grimberg <sagig@mellanox.com>, Sebastian Parschauer <sebastian.riemer@profitbricks.com>, Robert Elliott <Elliott@hp.com>, Ming Lei <ming.lei@canonical.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>

On 10/19/14 19:36, Sagi Grimberg wrote:
> On 10/7/2014 4:07 PM, Bart Van Assche wrote:
>>           * comp_vector, a number in the range 0..n-1 specifying the
>> -          MSI-X completion vector. Some HCA's allocate multiple (n)
>> -          MSI-X vectors per HCA port. If the IRQ affinity masks of
>> -          these interrupts have been configured such that each MSI-X
>> -          interrupt is handled by a different CPU then the comp_vector
>> -          parameter can be used to spread the SRP completion workload
>> -          over multiple CPU's.
>> +          MSI-X completion vector of the first RDMA channel. Some
>> +          HCA's allocate multiple (n) MSI-X vectors per HCA port. If
>> +          the IRQ affinity masks of these interrupts have been
>> +          configured such that each MSI-X interrupt is handled by a
>> +          different CPU then the comp_vector parameter can be used to
>> +          spread the SRP completion workload over multiple CPU's.
>
> This is fairly not trivial for the user...
>
> Aren't we requesting a bit too much awareness here?
> Can't we just "make it work"? The user hands out ch_count - why can't
> you do some least-used logic here?
>
> Maybe we can even go with per-cpu QPs and discard comp_vector argument?
> this would probably bring the best performance, wouldn't it?
> (fallback to least-used logic in case HW support less vectors)

Hello Sagi,

The only reason the comp_vector parameter is still supported is because 
of backwards compatibility. What I expect is that users will set the 
ch_count parameter but not the comp_vector parameter.

Using one QP per CPU thread does not necessarily result in the best 
performance. In the tests I ran performance was about 4% better when 
using one QP for each pair of CPU threads (with hyperthreading enabled).

>> +static unsigned ch_count;
>> +module_param(ch_count, uint, 0444);
>> +MODULE_PARM_DESC(ch_count,
>> +         "Number of RDMA channels to use for communication with an
>> SRP target. Using more than one channel improves performance if the
>> HCA supports multiple completion vectors. The default value is the
>> minimum of four times the number of online CPU sockets and the number
>> of completion vectors supported by the HCA.");
>
> Why? how did you get to this magic equation?

On the systems I have access to measurements have shown that this choice 
for the ch_count parameter results in a significant performance 
improvement without consuming too many system resources. The performance 
difference when using more than four channels was small. This means that 
the exact value of this parameter is not that important. What matters to 
me is that users can benefit from improved performance even if the 
ch_count kernel module parameter has been left to its default value.

Bart.
