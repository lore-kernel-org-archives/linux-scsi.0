From: Tejun Heo <tj@kernel.org>
Subject: Re: [RFC] Separating out libata out of SCSI (finally)
Date: Sat, 21 Jun 2008 08:47:56 +0900
Message-ID: <485C41AC.5010303@kernel.org>
References: <485B2CC6.6070201@kernel.org> <1213993737.3443.35.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hera.kernel.org ([140.211.167.34]:50289 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751642AbYFTX4Z (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Jun 2008 19:56:25 -0400
In-Reply-To: <1213993737.3443.35.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Jeff Garzik <jeff@garzik.org>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, brking@linux.vnet.ibm.com, Mark Lord <liml@rtr.ca>, Alan Cox <alan@lxorguk.ukuu.org.uk>, Jens Axboe <jens.axboe@oracle.com>

Hello, James.

James Bottomley wrote:
> On Fri, 2008-06-20 at 13:06 +0900, Tejun Heo wrote:
>> Hello, all.
>>
>> This item was on TODO list for years now.  People all agree that it's
>> necessary but it always had relatively low priority probably because
>> it's a bit difficult and isn't really necessary to make disks and
>> optical drives work.
>>
>> Anyways, I think it's about time to take some action as SAS-ATA
>> integration (Brian, sorry about staying so silent about this for long
>> time, I was following the threads but couldn't really think of a quick
>> solution) and other ATA specific things including link power
>> management and bunch of other deferred ones due to lack of proper
>> sysfs interface or high level driver (parallel probing, parallel
>> resume).
>>
>> Currently, my plan is...
>>
>> * Move high level driver handling to request_queue.
> 
> Actually, I already did quite a lot of that here:
> 
> commit 7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65
> Author: James Bottomley <James.Bottomley@steeleye.com>
> Date:   Sat Aug 4 10:06:25 2007 -0500
> 
>     [SCSI] move ULD attachment into the prep function
> 
> But there's still more to be done.  The way I was thinking of it was
> some type of protocol label (as in a ULD spits out protocols, like SCSI
> or ATA) and then passes them to a LLD which uses libraries (what libata
> and the scsi mid layer become) to process them.

That was what I was thinking too in a similar way PC commands are
carried.  There are things to think about tho like splitting single
request to multiple translated commands.

>> * Implement queue quiescing and other state management on request_queue.
>> * Implement block_queue_group which...
>> 	- Handles command scheduling.
>> 	- Handles grouped queue quiescing and EH handling
> 
> There's the beginnings of this in Jens' unmerged block timers work

Great, thanks for the pointer.

>> In the process, I'm planning to remove ata_host requirement and break
>> down libata EH into actions and sequencers so that SAS can use them
>> easily.
>>
>> The biggest problem is how to keep userland happy.  hdX -> sdX
>> transition was painful enough and I have a strong feeling that
>> everyone will come after and hunt down us if we try something like sdX
>> -> bdX now.  :-)
> 
> In theory mounting by label or ID should have fixed a lot of this.

Now that all the distros and users went through it once, maybe it's
easier second time around but I think it's best to minimize the chance
of breakage.  One transition was painful enough.

> However, if we need to head off a revolt, the sdX allocation algorithm
> can be placed into it's own module so both sd and a ULD ata driver could
> use it ...

Yeap, that was what I was thinking.  Separating out sdX allocation
algorithm and making it the disk device node allocation logic such that
/dev/sdX are the universal disk nodes, which is 90% true these days anyway.

> Could you, perhaps, make the port multipler visible in this as a new
> device, a bit like we do today for SAS expanders?

I was thinking about doing...

ata_link/P:0/P:0	: 1st fan-out
	/P:1/P:1	: 2nd fan-out
	/P:2/P:2	: 3rd fan-out
	...
	/P:15/P:15	: port multiplier

which is pretty much the internal representation.  Do you think there's
need for a separate PMP level inbetween?

>> The SCSI side of interface will remain as functional as now as it will
>> go through the same libata SAT layer.
> 
> Actually, surely we can mostly dump the SAT layer?  libsas should be
> made capable of taking ATA protocol packets straight from your ULD ATA
> driver and sending them out.

Maybe in a long long time but the SAT layer will need to stay there for
compatibility for now.  ie. programs which use lsscsi to locate ATA
devices and using matching /dev/sgX to issue SAT commands should keep
working.

> I could see us still needing it as an optional component so we can send
> SCSI SG_IO to ATA devices.

And for compatibility.  We can definitely make it optional.

>> So, what do you guys think?
> 
> I think the devil will be in the details, but that it certainly won't be
> obvious until the conversion is actually tried.

Alright, thanks for your comments.

-- 
tejun
