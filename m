From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI support for REQ_TYPE_LINUX_BLOCK requests
Date: Fri, 28 Mar 2008 12:43:02 +0100
Message-ID: <87y783ula1.fsf@denkblock.local>
References: <871w60j9ai.fsf@denkblock.local> <87r6dxy37a.fsf@denkblock.local>
	<47EA689B.4080109@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:47851 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758431AbYC1OlK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 28 Mar 2008 10:41:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Wed, Mar 26 2008 at 16:23 +0200, Elias Oltmanns <eo@nebensachen.de> wrote:
>> Elias Oltmanns <eo@nebensachen.de> wrote:
>>> Hi all,
>>>
>>> this patch adds support for REQ_TYPE_LINUX_BLOCK requests to the scsi
>>> midlayer. Low level drivers have the option to register their own
>>> handlers for these special requests if necessary.
>>>
>> [...]
>>> +static void scsi_finish_lb_req(struct request *req)
>>> +{
>>> +	struct request_queue *q = req->q;
>>> +	struct scsi_device *sdev = q->queuedata;
>>> +	unsigned long flags;
>>> +
>>> +	spin_lock_irqsave(q->queue_lock, flags);
>>> +	end_that_request_last(req, 1);
>> 
>> That's obsolete, of course. Sorry for missing that. See the correct
>> patch for 2.6.25-rc7 below.
>> 
>> Regards,
>> 
>> Elias
>> 
>> 
>
> It looks to me like you can accomplish any of that (and more) with
> regular BLOCK_PC commands plus the varlen facility I have sent:
> (http://www.spinics.net/lists/linux-scsi/msg25202.html)

Thanks for the hint, the varlen facility certainly is a nice
enhancement. However, I wonder whether this really is a replacement for
REQ_TYPE_LINUX_BLOCK requests. This is a linux specific type of requests
intended to be used as generic block layer messages. In my patch set,
for instance, a REQ_TYPE_LINUX_BLOCK request is enqueued to notify LLDs
that the queue has just been frozen / thawed. The block layer doesn't
really care (or know, for that matter) whether the device is an SCSI,
IDE, or an loop device. Thus, only the LLD itself can decide what kind
of commands (if any) have to be executed in response to the generic
block layer message.

Of course, the same can be achieved by means of the varlen facility if
we could, for instance, reserve a certain range of codes in the service
action of a variable length CDB for this kind of requests. Is that what
you had in mind?

[...]
> BLOCK_PC commands with-or-without data, are always completed at once.

??? At once, as opposed to what? For all I know, they are enqueued for
asynchronous completion.

>
> The LLD in question will only need to filter for those special commands
> at the .queuecommand entry and act accordingly.
>
> The only problem you might have is with a dumb initiator that might issue
> commands to devices that do not know what to do with the new none-standard
> commands. There is 3 things you can do.

This will be a common situation and we are not just talking about scsi
devices either.

> 1. Make the Initiator smarter to only send these commands to good
>    devices In a manner of a special flag or a registration process.

We wanted to avoid just that.

> 2. use commands that are bigger than 16 so .max_cmd_len of legacy
>    drivers will not allow these commands through.
> 3. Do nothing and let the setup process only setup the compatible
>    devices to be issued the new commands.
>
> The bsg driver can already be used to issue such commands from user space.
> Tell me if you need example code to easily issue such commands from kernel.

If you still think that all of the above can (and should) be
accomplished using BLOCK_PC commands and the varlen facility, I'd be
interested in some example code.

Regards,

Elias
