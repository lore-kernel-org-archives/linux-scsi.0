From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 13/17] scsi: push host_lock down into scsi_{host,target}_queue_ready
Date: Fri, 07 Feb 2014 11:42:06 +0100
Message-ID: <52F4B87E.1000408@acm.org>
References: <20140205123930.150608699@bombadil.infradead.org>		 <20140205124021.286457268@bombadil.infradead.org>	 <1391705819.22335.8.camel@dabdike> <52F3C21F.70409@acm.org> <1391712076.22335.13.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp03.stone-is.org ([87.238.162.65]:35214 "EHLO
	smtpgw.stone-is.be" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751382AbaBGKmK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Feb 2014 05:42:10 -0500
In-Reply-To: <1391712076.22335.13.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org

On 02/06/14 19:41, James Bottomley wrote:
> On Thu, 2014-02-06 at 18:10 +0100, Bart Van Assche wrote:
>> On 02/06/14 17:56, James Bottomley wrote:
>>> Could you benchmark this lot and show what the actual improvement is
>>> just for this series, if any?
>>
>> I see a performance improvement of 12% with the SRP protocol for the
>> SCSI core optimizations alone (I am still busy measuring the impact of
>> the blk-mq conversion but I can already see that it is really
>> significant). Please note that the performance impact depends a lot on
>> the workload (number of LUNs per SCSI host e.g.) so maybe the workload I
>> chose is not doing justice to Christoph's work. And it's also important
>> to mention that with the workload I ran I was saturating the target
>> system CPU (a quad core Intel i5). In other words, results might be
>> better with a more powerful target system.
> 
> On what?  Just the patches I indicated or the whole series?  My specific
> concern is that swapping a critical section for atomics may not buy us
> anything even on x86 and may slow down non-x86.  That's the bit I'd like
> benchmarks to explore.

The numbers I mentioned in my previous e-mail referred to the "SCSI data
path micro-optimizations" patch series and the "A different approach for
using blk-mq in the SCSI layer" series as a whole. I have run a new test
in which I compared the performance between a kernel with these two
patch series applied versus a kernel in which the four patches that
convert host_busy, target_busy and device_busy into atomics have been
reverted. For a workload with a single SCSI host, a single LUN, a block
size of 512 bytes, the SRP protocol and a single CPU thread submitting
I/O requests I see a performance improvement of 0.5% when using atomics.
For a workload with a single SCSI host, eight LUNs and eight CPU threads
submitting I/O I see a performance improvement of 3.8% when using
atomics. Please note that these measurements have been run on a single
socket system, that cache line misses are more expensive on NUMA systems
and hence that the performance impact of these patches on a NUMA system
will be more substantial.

Bart.

