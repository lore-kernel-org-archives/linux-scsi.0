From: Doug Ledford <dledford@redhat.com>
Subject: Re: [PATCH]: Flexible timeout infrastructure
Date: Tue, 15 Jun 2004 18:13:59 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1087337639.3556.213.camel@compaq.xsintricity.com>
References: <40CF0F9F.4050902@adaptec.com>
	 <1087313492.1796.37.camel@mulgrave> <20040615181536.GA12611@us.ibm.com>
	 <40CF4207.9050108@adaptec.com> <20040615192045.GA13704@us.ibm.com>
	 <40CF5396.1030303@adaptec.com>  <20040615205715.GB13704@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:53411 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S265987AbUFOWQE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Jun 2004 18:16:04 -0400
In-Reply-To: <20040615205715.GB13704@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, James Bottomley <James.Bottomley@steeleye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-06-15 at 16:57, Mike Anderson wrote:
> Luben Tuikov [luben_tuikov@adaptec.com] wrote:
> > >In the patch as is you overload the eh_cmd_timed_out template function
> > 
> > But this method doesn't exist. How can I be overloading it?
> > 
> > >to mean the LLDD wants to try to handle timed out commands plus start /
> > >restart / stop the timers. This would appear to limit the interface to
> > >the LLDD doing both operations which should be separate decisions?
> > 
> > I don't understand what you mean here.
> 
> The patch is adding an interface that adds two capabilities. A LLDD
> callout to possibly handle timed out commands and another capability to
> control when command timers start / stop. 
> 
> If a LLDD wanted to just get called to possibly handle timed out
> commands it must also take care of starting and stopping command timers.
> This is all I was saying in the previous comment.

I agree with this.  I can certianly see why I would want to be able to
control timers from the low level driver though.  The most common
problem I've seen is actual bus lockups (due to either a hung device, a
hardware or driver error, or due to cabling issues).  When that happens,
the command that hangs usually is not the oldest command on the bus, so
all the commands that time out prior to the actual suspect command
should not be penalized on retries (or at least should be more
intelligently penalized, for example if the problem is a hung device and
not a cabling problem, then you can be using up a retry for disk 1 when
tape 2 is the one locking the bus up and there isn't a thing wrong with
disk 1).  One of the easiest ways to tell the difference between a hung
device/bus and a starved command is to get a timeout, pause the
controller, find out what command is active and what exact position in
the command process it's in, then wait a short period of time (HZ/100 is
sufficient to be sure that progress *should* have happened if the device
isn't hung), if progress has been made then you likely have a starved
command so send an ordered tag command (assuming it's a tagged device,
if it's not then go to a separate error handler path) and wait for the
ordered tag to complete, if the lost command is still lost, then you
have a problem, if not then it completed properly.  If progress has not
been made, then try a bus device reset and reset timeout on the active
command to something like (HZ/20).  If the timeout fires, then your bus
device reset has failed, throw a bus reset.  If the bus device reset
succeeds it will do so in much less time than HZ/20 and all commands for
that device will have already been returned as DID_RESET and will be
getting retried.  Easy, elegant, but hardware dependant.

> > 
> > >Also in the comments for the patch you mention that the LLDD may decide
> > >to resubmit the IO which I assume is why you would want to have control
> > >of the timers, but wouldn't the LLDD need to also consult if the IO
> > >should be resubmitted which propagates these tests and could result in
> > >inconsistent policy.
> > 
> > But the LLDD *does* know if the IO is to resubmitted, it doesn't have to
> > consult anyone.  Hint: targets are *passive*, and thus the stipuations in 
> > SAM.
> 
> Why does the LLDD not have to consult the same information that the SCSI
> mid layer does on retries (i.e., scmd->allowed, blk_noretry_request). Is
> there no idempotent issue to worry about?

Following the scenario I just wrote above, this all works out properly. 
For starved commands, there is no check of retries because you don't
retry, you just force it to complete.  For a hung device, all of it's
commands will go through the retry stuff as a result of being sent back
with DID_RESET (although if we have to throw a complete bus reset then
commands for other devices will also go through this, which is correct
if the problem is a general cabling problem making all devices flake
out, not so correct if you have a specific command causing a single
device to lock up repeatedly, but this is something that can actually be
handled at the mid layer by doing intelligent requeuing after a bus
reset, things like slow start on each device and doing a round robin
style 1 command at a time to 1 device, wait for completion, mark device
working, go to next device, when you complete one loop through all the
devices, then start sending commands to multiple devices at a time
again, that sort of thing).

>  While SPI topologies may lead
> to LLDD retries being successful in completing the command a major of
> the time, there are other transport topologies that lead to the success
> of the IO only through the re-driving of the IO through a disjoint path
> (i.e., different LLDD instance, port, etc.) which would be done outside
> the scope of the LLDD.

Typically, a LLDD is very much aware of these things.  When the
transport goes away, the LLDD knows it.  Think fiber channel for
example.  If a driver knows the transport is gone, then it returns the
command with an appropriate error and the upper layers do the rest.

> > 
> > That is, if IO is NOT to be continued, then SCSI Core should call
> > a TMF, ABORT TASK or ABORT TASK SET, via eh_abort_handler(<cmd>).
> > (Yes, the eh interface doesn't do 1:1 TMF mapping.)
> > 
> 
> The scsi mid layer would only call the eh_abort_handler post a timeout
> event (there are other rare case in scsi_decide_disposition that wake
> the error handler) which is being handled by the eh_cmd_timed_out
> function of the LLDD so there would be no way for the scsi mid layer to
> abort the IO.
> 
> > This is how SCSI Core communicates with LLDD, it's not the case that
> > LLDD asks SCSI Core each and every time for each and every decision.
> > First it's not by spec, and second it is unattainable both due to
> > the hardware reasons mentioned by Doug and I and due to the
> > recovery quirks.
> > 
> > I really don't see why this is such a big deal when SCSI Core
> > and LLDDs are unaffected.  It is just an _optional_ method
> > and will do good for SCSI Core. I promise. ;-)
> 
> I think the template callout in scsi_times_out is good. I believe there
> is still debate on controlling the timers that is why I suggested maybe
> the two capabilities could be separated.

I agree the two should be separated, but I certainly think the lldd
should have the ability to deal with their own timers.

> I believe the callout as per my previous query last week may help in
> some failover / failback case involing device mapper multipath. I
> think it would be good for SCSI core to have this callout interface or
> one like it.
> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc.
         1801 Varsity Dr.
         Raleigh, NC 27606


