From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] SCSI support for REQ_TYPE_LINUX_BLOCK requests
Date: Wed, 26 Mar 2008 17:15:39 +0200
Message-ID: <47EA689B.4080109@panasas.com>
References: <871w60j9ai.fsf@denkblock.local> <87r6dxy37a.fsf@denkblock.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:36043 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752497AbYCZPQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Mar 2008 11:16:03 -0400
In-Reply-To: <87r6dxy37a.fsf@denkblock.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Elias Oltmanns <eo@nebensachen.de>
Cc: linux-scsi@vger.kernel.org

On Wed, Mar 26 2008 at 16:23 +0200, Elias Oltmanns <eo@nebensachen.de> wrote:
> Elias Oltmanns <eo@nebensachen.de> wrote:
>> Hi all,
>>
>> this patch adds support for REQ_TYPE_LINUX_BLOCK requests to the scsi
>> midlayer. Low level drivers have the option to register their own
>> handlers for these special requests if necessary.
>>
> [...]
>> +static void scsi_finish_lb_req(struct request *req)
>> +{
>> +	struct request_queue *q = req->q;
>> +	struct scsi_device *sdev = q->queuedata;
>> +	unsigned long flags;
>> +
>> +	spin_lock_irqsave(q->queue_lock, flags);
>> +	end_that_request_last(req, 1);
> 
> That's obsolete, of course. Sorry for missing that. See the correct
> patch for 2.6.25-rc7 below.
> 
> Regards,
> 
> Elias
> 
> 

It looks to me like you can accomplish any of that (and more) with
regular BLOCK_PC commands plus the varlen facility I have sent:
(http://www.spinics.net/lists/linux-scsi/msg25202.html)

If you want a request with no BIO's and any arbitrary data this can
be just a varlen command. In the presence of varlen commands block
or scsi layers will not assume anything about the passed CDB and will
just channel it all the way to the LLD.

But if you also need mapped buffers you allocate a BIO with right 
direction (or bidi) and the mid-layers will also take care of that in 
the regular way.

BLOCK_PC commands with-or-without data, are always completed at once.

The LLD in question will only need to filter for those special commands
at the .queuecommand entry and act accordingly.

The only problem you might have is with a dumb initiator that might issue
commands to devices that do not know what to do with the new none-standard
commands. There is 3 things you can do.
1. Make the Initiator smarter to only send these commands to good devices
   In a manner of a special flag or a registration process.
2. use commands that are bigger than 16 so .max_cmd_len of legacy drivers
   will not allow these commands through.
3. Do nothing and let the setup process only setup the compatible devices
   to be issued the new commands.

The bsg driver can already be used to issue such commands from user space.
Tell me if you need example code to easily issue such commands from kernel.

Boaz

