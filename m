From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [RFC PATCH 3/3] block: add queue idle timer
Date: Wed, 16 May 2012 20:29:27 +0200
Message-ID: <4FB3F207.7020308@kernel.dk>
References: <Pine.LNX.4.44L0.1205161156480.1852-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:50892 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760076Ab2EPS3c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 16 May 2012 14:29:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.1205161156480.1852-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Lin Ming <ming.m.lin@intel.com>, Jeff Moyer <jmoyer@redhat.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org

On 2012-05-16 17:59, Alan Stern wrote:
> On Wed, 16 May 2012, Lin Ming wrote:
> 
>>> Lin, you should have more slack timer handling. Look at the blk-timeout
>>> handling of request timeouts for inspiration, and/or the thread that
>>> Jeff also references. Doing a timer add/del for each request put is a no
>>> go.
>>
>> You mentioned how to detect queue idle in the referenced thread:
>> 	
>> ===
>> So we could probably add an idle timer that is set to some suitable
>> timeout for this and would be added when the queue first goes empty. If
>> new requests come in, just let it simmer and defer checking the state to
>> when it actually fires.
> 
> That is basically how the runtime PM timer works, if you use it as I 
> described earlier.
> 
>> ===
>>
>> What do you mean of "the queue first goes empty"?
> 
> When the queue is first created, the timer is started.
> 
> Whenever the timer expires, the code checks to see if any requests have 
> been processed since the previous expiration.  If they have, the timer 
> is restarted.  If they haven't, you suspend the device.

That sounds ideal, since you don't have to manage it in the block layer
then.

Lin, you should just use that. My suggestion was that you add the timer
when the queue first goes idle, IFF it isn't already running. When it
expires, you check last activity and decide whether to suspend it or
reset the timer. This is a more optimal than continually adding and
deleting timers, or even just moving it forwards 20s all the time. But
if pm already has support for this type of functionality (and it does,
Alan says, which makes sense since this mechanism would be useful for
other edvices), then you should indeed just use that.

-- 
Jens Axboe

