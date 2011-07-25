From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [RFC PATCH 1/2] block: strict rq_affinity
Date: Mon, 25 Jul 2011 10:21:24 +0200
Message-ID: <4E2D2784.3060701@fusionio.com>
References: <20110722205736.17420.41366.stgit@localhost6.localdomain6> <20110722205938.17420.68621.stgit@localhost6.localdomain6> <4E2B15DB.4090302@fusionio.com> <CANejiEVMHhOW0N4Wn9LG0NAXMX3uOz5QzcRXZV4Ow4RTsMvN5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([66.114.96.31]:33430 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751074Ab1GYIVi (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2011 04:21:38 -0400
In-Reply-To: <CANejiEVMHhOW0N4Wn9LG0NAXMX3uOz5QzcRXZV4Ow4RTsMvN5Q@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: Dan Williams <dan.j.williams@intel.com>, Christoph Hellwig <hch@infradead.org>, Roland Dreier <roland@purestorage.com>, Dave Jiang <dave.jiang@intel.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2011-07-25 03:14, Shaohua Li wrote:
> 2011/7/24 Jens Axboe <jaxboe@fusionio.com>:
>> On 2011-07-22 22:59, Dan Williams wrote:
>>> Some storage controllers benefit from completions always being steered
>>> to the strict requester cpu rather than the looser "per-socket" steering
>>> that blk_cpu_to_group() attempts by default.
>>>
>>> echo 2 > /sys/block/<bdev>/queue/rq_affinity
>>
>> I have applied this one, with a modified patch description.
>>
>> I like the adaptive solution, but it should be rewritten to not declare
>> and expose softirq internals. Essentially have an API from
>> kernel/softirq.c that can return whether a given (or perhaps just local)
>> softirq handler is busy or not.
> Jens,
> I posted a similar patch about two years ago(
> http://marc.info/?l=linux-kernel&m=126136252929329&w=2).
> At that time, you actually did a lot of tests and said the same cpu
> approach will cause huge lock contention and bounce. Is that get fixed?

Yep, it's not ideal. But if we are running out of steam on a single
processor, there's really not much of an option currently.

-- 
Jens Axboe

