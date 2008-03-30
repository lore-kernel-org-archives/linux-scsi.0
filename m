From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI support for REQ_TYPE_LINUX_BLOCK requests
Date: Sun, 30 Mar 2008 18:39:32 +0300
Message-ID: <47EFB434.9000704@panasas.com>
References: <871w60j9ai.fsf@denkblock.local> <87r6dxy37a.fsf@denkblock.local>	<47EA689B.4080109@panasas.com> <87y783ula1.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:35367 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518AbYC3Pj7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 30 Mar 2008 11:39:59 -0400
In-Reply-To: <87y783ula1.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-scsi@vger.kernel.org

On Fri, Mar 28 2008 at 14:43 +0300, Elias Oltmanns <eo@nebensachen.de> wrote:
> Boaz Harrosh <bharrosh@panasas.com> wrote:
>> On Wed, Mar 26 2008 at 16:23 +0200, Elias Oltmanns <eo@nebensachen.de> wrote:
>>> Elias Oltmanns <eo@nebensachen.de> wrote:
>>>> Hi all,
>>>>
>>>> this patch adds support for REQ_TYPE_LINUX_BLOCK requests to the scsi
>>>> midlayer. Low level drivers have the option to register their own
>>>> handlers for these special requests if necessary.
>>>>
>>> [...]
>>>> +static void scsi_finish_lb_req(struct request *req)
>>>> +{
>>>> +	struct request_queue *q = req->q;
>>>> +	struct scsi_device *sdev = q->queuedata;
>>>> +	unsigned long flags;
>>>> +
>>>> +	spin_lock_irqsave(q->queue_lock, flags);
>>>> +	end_that_request_last(req, 1);
>>> That's obsolete, of course. Sorry for missing that. See the correct
>>> patch for 2.6.25-rc7 below.
>>>
>>> Regards,
>>>
>>> Elias
>>>
>>>
>> It looks to me like you can accomplish any of that (and more) with
>> regular BLOCK_PC commands plus the varlen facility I have sent:
>> (http://www.spinics.net/lists/linux-scsi/msg25202.html)
> 
> Thanks for the hint, the varlen facility certainly is a nice
> enhancement. However, I wonder whether this really is a replacement for
> REQ_TYPE_LINUX_BLOCK requests. This is a linux specific type of requests
> intended to be used as generic block layer messages. In my patch set,
> for instance, a REQ_TYPE_LINUX_BLOCK request is enqueued to notify LLDs
> that the queue has just been frozen / thawed. The block layer doesn't
> really care (or know, for that matter) whether the device is an SCSI,
> IDE, or an loop device. Thus, only the LLD itself can decide what kind
> of commands (if any) have to be executed in response to the generic
> block layer message.

You do have the same problem with you approach, and from what it looks
you have audited all users and changed them. Wherever a block device
did "if (REQ_TYPE_BLOCK_PC)" and so on, you added another else-if case 
and took care of the new type. You can just do the same but the 
if (linux_special_somthing()) will look inside the cdb now.
So you have not gained but have not lost on any particular block LLD.

In scsi however you can save a lot. By doing almost nothing, save the
special flag at host template. (See below)

> 
> Of course, the same can be achieved by means of the varlen facility if
> we could, for instance, reserve a certain range of codes in the service
> action of a variable length CDB for this kind of requests. Is that what
> you had in mind?
> 

You can easily brute force it. But you could also use the special format
and range the scsi standard reserves for vendor specific commands - Linux
vendor specific commands - You might even want to publish this command set
and then they can have a special status of: publicly available vendor specific
set.

If you decide to go the standard scsi way I'll point you to the right place in
the documentation.

> [...]
>> BLOCK_PC commands with-or-without data, are always completed at once.
> 
> ??? At once, as opposed to what? For all I know, they are enqueued for
> asynchronous completion.
> 

I mean, as opposed to FS_PC where a long request can be split into few
scsi-commands. BLOCK_PC is executed as one opaque piece.

>> The LLD in question will only need to filter for those special commands
>> at the .queuecommand entry and act accordingly.
>>
>> The only problem you might have is with a dumb initiator that might issue
>> commands to devices that do not know what to do with the new none-standard
>> commands. There is 3 things you can do.
> 
> This will be a common situation and we are not just talking about scsi
> devices either.
> 
>> 1. Make the Initiator smarter to only send these commands to good
>>    devices In a manner of a special flag or a registration process.
> 
> We wanted to avoid just that.

I did not see the complete patchset. But in the scsi patchset you did
just that. You have added a new call vector - lb_request_fn - at host
template. What I suggest is a bit-flag at host template of lets say,
.support_linux_specific_cmnd the transport is exactly the same as 
BLOCK_PC but a simple if will not send these commands to scsi LLDS that 
do not support them.

Something similar could be done for other block devices look at the the
QUEUE_FLAG_BIDI of how bsg driver checks if to allow bidi commands to
devices. However there is a safety mechanism to my block layer varlen
commands, that if a legacy driver is untouched, the varlen command will 
look like a zero length command, most drivers already just ignore these.
(OK with spiting some messages at times).

> 
>> 2. use commands that are bigger than 16 so .max_cmd_len of legacy
>>    drivers will not allow these commands through.
>> 3. Do nothing and let the setup process only setup the compatible
>>    devices to be issued the new commands.
>>
>> The bsg driver can already be used to issue such commands from user space.
>> Tell me if you need example code to easily issue such commands from kernel.
> 
> If you still think that all of the above can (and should) be
> accomplished using BLOCK_PC commands and the varlen facility, I'd be
> interested in some example code.
> 

It's easy, see below. In general scsi_libs's *_execute_* are good examples
they just issue commands through the block layer they have no special scsi stuff.
(almost) (also bsg driver is a good example)

> Regards,
> 
> Elias
> --

I think that in overall your code will be much smaller. And it is not hard to
audit all users to make sure they comply. 
You just need to define the right API at block level that says. what are the 
special commands and their format. The blk_lb_request(req) will inspects the ->cmd[] 
as well as the BLOCK_PC type.

If it was me I would define the above to also adhere to the scsi standard by 
defining it as a true scsi varlen / vendor specific command. To avoid any conflicts
with future command-sets. And again if it was me I would make high level helpers that
would encode/decode the different commands for me so if things change, they only 
change in one place.

Tell me if you need any help, and also point me to where you have the complete
body of work, including the initiators that use the code. I will have a look to
make sure every thing is safe.

Boaz

---
/* synchronuse execution of a dataless command */

int execute_nodata_command(struct request_queue *q, u8 *cmnd, ushort cmnd_len,
				int rw, gfp_t flags)
{
	struct request *req;
	u8 sense_buffer[SCSI_SENSE_BUFFERSIZE];
	int ret;

	req = blk_get_request(q, READ, flags); /* No data is a READ */
	if (!req) {
		ERROR("blk_get_request faild\n");
		return -ENOMEM;
	}

	req->cmd_type = REQ_TYPE_BLOCK_PC;
	req->timeout = SOME_TIMEOUT;
	req->retries = SOME_RETRIES;
	req->sense = &sense_buffer;
	req->sense_len = 0;

	/* send a special command that should be safe for
         * drivers that know nothing about these commands
         */
	rq_set_varlen_cdb(req, cmnd, cmnd_len);

	ret = blk_execute_rq(q, NULL, req, 0);
	blk_put_request(req);

	return ret;
}
