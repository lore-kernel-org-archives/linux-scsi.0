From: Elias Oltmanns <eo@nebensachen.de>
Subject: Re: [PATCH] SCSI support for REQ_TYPE_LINUX_BLOCK requests
Date: Fri, 11 Apr 2008 00:47:36 +0200
Message-ID: <87r6ddxr7b.fsf@denkblock.local>
References: <871w60j9ai.fsf@denkblock.local> <87r6dxy37a.fsf@denkblock.local>
	<47EA689B.4080109@panasas.com> <87y783ula1.fsf@denkblock.local>
	<47EFB434.9000704@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nebensachen.de ([195.34.83.29]:49832 "EHLO mail.nebensachen.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437AbYDJWsK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Apr 2008 18:48:10 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>, Jens Axboe <jens.axboe@oracle.com>
Cc: linux-scsi@vger.kernel.org

Boaz Harrosh <bharrosh@panasas.com> wrote:
> On Fri, Mar 28 2008 at 14:43 +0300, Elias Oltmanns <eo@nebensachen.de> wrote:
>> Boaz Harrosh <bharrosh@panasas.com> wrote:
>>> On Wed, Mar 26 2008 at 16:23 +0200, Elias Oltmanns <eo@nebensachen.de> wrote:
>>>> Elias Oltmanns <eo@nebensachen.de> wrote:
>>>>> Hi all,
>>>>>
>>>>> this patch adds support for REQ_TYPE_LINUX_BLOCK requests to the scsi
>>>>> midlayer. Low level drivers have the option to register their own
>>>>> handlers for these special requests if necessary.
>>>>>
>>>> [...]
>>>>> +static void scsi_finish_lb_req(struct request *req)
>>>>> +{
>>>>> +	struct request_queue *q = req->q;
>>>>> +	struct scsi_device *sdev = q->queuedata;
>>>>> +	unsigned long flags;
>>>>> +
>>>>> +	spin_lock_irqsave(q->queue_lock, flags);
>>>>> +	end_that_request_last(req, 1);
>>>> That's obsolete, of course. Sorry for missing that. See the correct
>>>> patch for 2.6.25-rc7 below.
>>>>
>>>> Regards,
>>>>
>>>> Elias
>>>>
>>>>
>>> It looks to me like you can accomplish any of that (and more) with
>>> regular BLOCK_PC commands plus the varlen facility I have sent:
>>> (http://www.spinics.net/lists/linux-scsi/msg25202.html)
>> 
>> Thanks for the hint, the varlen facility certainly is a nice
>> enhancement. However, I wonder whether this really is a replacement for
>> REQ_TYPE_LINUX_BLOCK requests. This is a linux specific type of requests
>> intended to be used as generic block layer messages. In my patch set,
>> for instance, a REQ_TYPE_LINUX_BLOCK request is enqueued to notify LLDs
>> that the queue has just been frozen / thawed. The block layer doesn't
>> really care (or know, for that matter) whether the device is an SCSI,
>> IDE, or an loop device. Thus, only the LLD itself can decide what kind
>> of commands (if any) have to be executed in response to the generic
>> block layer message.
>
> You do have the same problem with you approach, and from what it looks
> you have audited all users and changed them. Wherever a block device
> did "if (REQ_TYPE_BLOCK_PC)" and so on, you added another else-if case 
> and took care of the new type. You can just do the same but the 
> if (linux_special_somthing()) will look inside the cdb now.
> So you have not gained but have not lost on any particular block LLD.

Jens, would you agree that variable length block pc commands could take
the place of REQ_TYPE_LINUX_BLOCK requests? Please see below.

>
> In scsi however you can save a lot. By doing almost nothing, save the
> special flag at host template. (See below)
>
>> 
>> Of course, the same can be achieved by means of the varlen facility if
>> we could, for instance, reserve a certain range of codes in the service
>> action of a variable length CDB for this kind of requests. Is that what
>> you had in mind?
>> 
>
> You can easily brute force it. But you could also use the special format
> and range the scsi standard reserves for vendor specific commands - Linux
> vendor specific commands - You might even want to publish this command set
> and then they can have a special status of: publicly available vendor specific
> set.

Well, this sounds all very appealing as it would certainly simplify
matters as far as scsi is concerned. There are just two things that
worry me a little:

1. Currently, the only LLDDs I care about are libata and the ide
   subsystem. I wonder whether an *scsi* variable length command, even
   if it is vendor specific, really is the right way to implement an ATA
   specific feature. Then again, a similar feature could pop up in a
   later version of the scsi standards famili, I suppose.
2. If we were going to use vendor specific variable length cdbs as a
   means to issue generic block layer messages, where would be the right
   place to define linux specific variable length cdbs? I don't suppose
   we'd want to load scsi.h in all LLDs of block devices.

>
> If you decide to go the standard scsi way I'll point you to the right
>place in
> the documentation.

It's in the latest scsi primary commands document, isn't it?

>
>> [...]
>>> BLOCK_PC commands with-or-without data, are always completed at once.
>> 
>> ??? At once, as opposed to what? For all I know, they are enqueued for
>> asynchronous completion.
>> 
>
> I mean, as opposed to FS_PC where a long request can be split into few
> scsi-commands. BLOCK_PC is executed as one opaque piece.

Right, I see.

[...]
> I think that in overall your code will be much smaller. And it is not hard to
> audit all users to make sure they comply. 
> You just need to define the right API at block level that says. what are the 
> special commands and their format. The blk_lb_request(req) will inspects the ->cmd[] 
> as well as the BLOCK_PC type.
>
> If it was me I would define the above to also adhere to the scsi standard by 
> defining it as a true scsi varlen / vendor specific command. To avoid any conflicts
> with future command-sets. And again if it was me I would make high level helpers that
> would encode/decode the different commands for me so if things change, they only 
> change in one place.
>
> Tell me if you need any help, and also point me to where you have the complete
> body of work, including the initiators that use the code. I will have a look to
> make sure every thing is safe.

I'm certainly grateful for your offer. At present the most pressing
question on my part is whether Jens will accept variable length cdbs
instead of REQ_TYPE_LINUX_BLOCK and whether this idea doesn't mix block
layer and scsi midlayer too much. James?

Thanks,

Elias
