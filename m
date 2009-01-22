From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] bsg: Add support for submitting requests at tail of queue
Date: Thu, 22 Jan 2009 10:57:35 +0200
Message-ID: <497834FF.6020302@panasas.com>
References: <4976F067.8000501@panasas.com> <20090122082314G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:28520 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752017AbZAVI5k (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jan 2009 03:57:40 -0500
In-Reply-To: <20090122082314G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, dougg@torque.net, linux-scsi@vger.kernel.org, osd-dev@open-osd.org

FUJITA Tomonori wrote:
> On Wed, 21 Jan 2009 11:52:39 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Currently inherited from sg.c bsg will submit asynchronous request
>> at the head-of-the-queue, (using "at_head" set in the call to
>> blk_execute_rq_nowait()). This is bad in situation where we want
>> to keep the queues full but need the requests to execute in order.
> 
> As I wrote, I think that blk_execute_rq_nowait inserts a request and
> plugs a queue. So how can you keep the queue full? On the completion
> of blk_execute_rq_nowait, the queue is empty.

If it's so then why does the "at_head" matters why does it exist?
Let me say it this way, if it does not matter then could we just
reverse it? you just said it does not matter, lets reverse it
to be 0 and not 1.

I don't understand what you are saying. bsg::write can accept an
array of commands lets say I have this sequence in the array:

command1:command2:command3

And for the sake of the argument lets say the hosts queue is full,
has can_queue commands waiting response. Let say from other clients.

if I use at_head==0, the target will surly see this sequence:
command1:command2:command3

But if I use at_head==1, the way I read the code, the target will see"
command3:command2:command1 and some times
command1:command3:command2 or command2:command1:command3
It all depends on the random completions of the other commands
in flight.

This is the way I read the code, If I read it wrong, please explain
what will be the actual behavior and what is the effect of at_head?

Thanks
Boaz
