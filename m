From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 13:29:07 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E5129F3.2040807@splentec.com>
References: <3E495862.3050709@splentec.com>	<20030211212048.GC1114@beaverton.ibm.com>	<3E49698D.3030402@splentec.com>	<20030211224119.A23149@infradead.org>	<3E4AAA3F.8040002@splentec.com>	<20030212204634.A17425@infradead.org>	<3E4AC0B5.9030208@splentec.com>	<20030213154748.A1965@infradead.org>	<3E4BEA13.50402@splentec.com>	<20030213192440.A6660@redhat.com>	<20030214165827.GA1165@beaverton.ibm.com>	 <3E4D44EB.1090402@splentec.com>	<1045257640.1726.23.camel@mulgrave>  <3E5119EC.7080907@splentec.com> <1045504719.1749.77.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Mon, 2003-02-17 at 12:20, Luben Tuikov wrote:
> 
>>There is no ``locking hierarchy'' -- i.e. a lock *only* locks its list
>>manipulation. So, you don't have to have a string of locks to change
>>a scsi_command, for example.
> 
> 
> If I want to loop over all outstanding commands on a device (say because
> the FC has just got a LIP removal), how do I do it?  Your design implies
> I have to loop over all portals, targets and luns.  To do this loop, I'd
> have to stabilise all the lists by acquiring the three locks that
> protect them, wouldn't I?

No, not at all.  If you know the struct scsi_lu, you can just lock
the pending_cmd_q and loop over the commands.

struct scsi_target is ``locked'' *implicitly* simply by having
atomic_read(&target->lu_q_count) != 0.

struct scsi_portal is ``locked'' *implicitly* simply by having
atomic_read(&portal->target_q_count) != 0.

struct scsi_core is ``locked'' *implicitly* simply by having
atomic_read(&core->portal_q_count) != 0.

You certainly do not need to lock the the whole hierarchy of locks
to loop over all pending commands.  Locks protect local data.
I.e. you just want to protect yourself from someone messing the
list up while you're traversing it.

>>When was the last time a SPI HBA set channel/bus to anything different
>>than 0?
> 
> 
> Channel is a special abstraction for the dual channel chips.  It's
> really an extension of host number for drivers that need a channel
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Thus it can be abstracted into a ``portal''.

>>>3. I don't see where the mid-layer has a use for the data.  By and
>>
>>Well, how can I contend *that* statement?...  This basically means
>>that the whole thing I proposed is cr*p.
> 
> 
> This is the key issue.  Complexity should only be introduced in a design

Well if it were the key issue, you should've just said *that*.
Nicely done.

> when it serves a justifiable purpose.  How do the 4 layers you propose
> simplify the design/improve the throughput or in any other way add
> benefit over the two layers (host and device) that we already have?

First of all it's 3 layers -- you're counting scsi_core but you don't
count it in the current structure. (scsi core pointers you can have as
ether-pointers, just as is now the practice)

So there's 3 layers: portal (aka host), target, lu. One more than
the current structure of scsi_core.

Look, you *NEED* the target layer, simply /because/ it exists in
nature. ;-)

I.e. a TARGET is the _addressable_ entity from a portal, i.e.
addressable on the fabric, but a LU is *NOT*.

The reason you get away with it now, is because linux scsi-core
gets help from the LLDDs.  But you have to understand that an LU
is a _function_ of the target.  So without this help of the LLDDs
the current scsi-core will *NOT* be able to address more than one
LU in a multi-LU target.

Yes, I know there's the old scan for LUs, but this is only
because linux scsi LLDD are SPI centric.

I.e. when you send a scsi command you're sending it to a (target,lu)
pair and this is what the LLDD does for you, i.e. it separates it
to a target, lu.

So, the question is: Is it worth it to abstract Target and LU into
OO design? Or is it better to leave it clunked up together as it is
now (device=(target,LU))?

I'm thinking sysfs here.

> Because the standards say so isn't enough.  The Mid-layer's job is to

And I'm not saying that it is enough. I'm just saying that:

> make efficient use of devices which follow the standards as simply and
> elegantly as possible, not mirror the SCSI architecture model.

Right, ``elegantly'' is the key word.

I don't think you can shrink any more from the 3 layer I proposed,
unless you go to the current 2 layer.

Judging from your words, the (host,device) pair is elegant enough?
If not, do you mind telling what is/would be?

-- 
Luben


