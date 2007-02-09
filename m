From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 0/2] convert sg to use block layer helpers
Date: Fri, 09 Feb 2007 12:37:28 -0600
Message-ID: <45CCBF68.9060802@cs.wisc.edu>
References: <1171010063.3713.26.camel@max> <45CCA6D2.10008@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36187 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1946582AbXBIShz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Feb 2007 13:37:55 -0500
In-Reply-To: <45CCA6D2.10008@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: jens.axboe@oracle.com, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Mike Christie wrote:
>> sg duplicates a lot of block layer dio and copying code. The block layer
>> is missing some things like mmap helpers and a way to support sg and
>> st's reserve buffer. The next two patches move move functionality from
>> sg to the block layer so later st and osst can use it, and then coverts
>> sg to use the block layer helper.
>>
>> The goal is to kill scsi_execute_async and friends and covert the ULDs
>> to use the block layer functions directly. This is nice because
>> scsi_execute_async sucks and it actually duplicates block layer code,
>> and in the end the scsi layer does not have to do any bio processing
>> (which irks Jens :)), and we have common code for all ULDs.
>>
>> The patches were made over Jens's bsg branch in his block layer git tree
>> on kernel.org. Sorry for the large patches. The sg conversion patch rips
>> out alot of code duplicated in the block layer and the patch to add some
>> missing functionality to the block layer has conversions to bsg, tgt,
>> etc so git bisect works on it.
> 
> Mike,
> Might I suggest ripping all the scatter gather list
> handling out of the block layer and putting it in
> a library (a bit like libata). That way when the
> block layer paradigm doesn't apply, we don't lose
> all the useful things that have been put in there.

I think this might be a good idea. We want to do something similar for
target requests. For tgt, we allocate a request_queue, and at one point
were using it to queue requests from the host to the userspace code (the
queue was to communicate with the host instead of specific device). We
now only use the queue for scatterlist building, so if you are talking
about making a new struct which holds those q limits that a
request_queue or some other object could use, then making some things
like max_sectors less block layerish, then we might be talking about the
same thing.

But we may not be thinking about the same thing or maybe we are :) When
I saw convert sg to block layer helpers, I do not mean exactly block
layer. The code we are using is based off the request_queue and that
does not need something like a block_device. You could interact with a
request_queue through sysfs or netlink (tgt did both at different points
:)). The queue, as we use it for scatterlist building, has some values
which are blockish like max_sectors, but for values like that we need a
way to for the LLDs to tell upper layers the max size command (any
command) a card can take. Maybe some people would say it is unfortunate
it has to be based on values like sectors which do not make sense for a
command like inquiry and maybe others will say what other values should
we use. I asked about just expressing it in bytes the other day when
asking about transport level commands but did not get any replies/ideas.
When going over the block sg code I noticed we assume 512 byte sectors
in some places so the code needs some changes.

What about moving the queue limits that are used for scatterlist
building: like max_phys_segments, max_hw_segments, dma alignments,
max_sectors, max_segment size, etc to a new struct "struct sg_limits".
The request queue could have one and any other objects like tgt could
use one. The block layer helpers we use would take a sg_limit struct
instead of a request_queue. And the functions like blk_rq_*_user,
blk_rq_map_sg, etc could be renamed to something without the blk prefix
and moved to some new file. Would this be a cleaner abstraction or do
you guys think it would just be a lot of code movement for just a big
name change? And of course max_sectors can be made less block layerish.
