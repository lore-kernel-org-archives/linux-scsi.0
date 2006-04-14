From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH 1/2] SCSI: implement scsi_eh_schedule_cmd()
Date: Fri, 14 Apr 2006 01:49:14 -0700 (PDT)
Message-ID: <20060414084914.63147.qmail@web31812.mail.mud.yahoo.com>
References: <443DE25E.90905@gmail.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <443DE25E.90905@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Patrick Mansfield <patmans@us.ibm.com>
Cc: Luben Tuikov <ltuikov@yahoo.com>, Jeff Garzik <jgarzik@pobox.com>, hch@lst.de, James.Bottomley@SteelEye.com, alan@lxorguk.ukuu.org.uk, albertcc@tw.ibm.com, arjan@infradead.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Tejun,

--- Tejun Heo <htejun@gmail.com> wrote:
> Yeap, I kind of misunderstood Patrick's mail.  scsi_req_abort_cmd() is 
> good but...
> 
> * The event is not really a timeout.

You are absolutely correct.

> It shouldn't be logged as 
> TIMEOUT_ERROR or completed with DID_TIME_OUT when add_scmd fails.
> 
> * Similarly, I don't think it's a good idea to call ->eh_timed_out() on 
> explicit command abort.  If something common has to be done, it's better 
> to make a function for that can calling the function from both 
> ->eh_timed_out() and after scsi_req_abort_cmd() succeeds.  Otherwise, 
> libata has to decide whether ->eh_timed_out() is called from real 
> timeout or explicit abortion and skip timeout processing for explicit 
> abortions.

You've been looking too much into libata code.
You are absolutely correct here as well.
"Special case begat special case."

Now, if you are absolutely correct, and we (I at least) recognize that,
then why are we (I at least) contending that you should use scsi_req_abort_cmd()?

> * I don't really understand what you mean by saying scsi_req_abort_cmd() 
> is more generic.  If it means the WARN_ON(!->eh_strategy_handler) part. 

No, not that part.

>   That's just a safety net as standard SCSI doesn't know what to do with 
> commands directly aborted by LLDD.

It does know.  Look at the 3 line implementation of scsi_req_abort_cmd().
Notice that "scsi_times_out()" is the beauty of generality: follow the same path.
That is, the call to the general "scsi_times_out()" gives the driver/layer another chance,
or notification thereof, that this command is going to go to the eh queue.

Now thereon, the eh_strategy is called with the list of commands to be recovered.
Where the eh_strategy points to if anywhere is another completely different story.

> __scsi_abort_cmd() would just contain scmd_add, I think.

Yeah, you see, try to stay away of those special cases with abcd_fn() and
__abcd_fn().  (Too much libata code?)

> Can you please post the patch for scsi_req_dev_reset()?  One thing to

First, that patch isn't ready for lsml posting.  Also, take a look at the
elaborate threads about literally a three (3) line function "scsi_req_abort_cmd()".
Imagine the book that would result from posting "scsi_req_dev_reset()".
 
> note is that libata might not have sdev to call that function with when 
> it wants to invoke EH for hotplug.

Let's separate the domains.  You are doing a good thing in separating
your SATA code into a "layer", and then you have LLDD which actually drive
the HW by which you access the interconnect.  (Sounds familiar? ;-) )

Now enter SCSI (as in SAM).  How can you tell SCSI "do eh for me, but
neither a device nor command has failed and I cannot give you either one of them"
as you're saying you'd like to do above?  See?  It is a protocol thing!  That is,
you want to handle such things in your layer.

But since the device abstraction and the command abstraction is _shared_ with
SCSI Core, you have to call "scsi_req_abort_cmd()" and "scsi_req_dev_reset()"
in order to request SCSI Core to call you back with that type of request when
it feels that is is comfortable in calling you to abort the task or
reset the device.

> >> Also, your routine calls more specific eh routines and you should try
> >> to be more general.
> 
> Please, elaborate.

"scsi_times_out()"

> I think it's good have some infrastructure in SCSI.  e.g. libata can do 
> everything itself but it's just nice to have SCSI EH infrastructure to 
> build upon (EH thread, scmd draining & plugging...).

You have to admit, SCSI is a lot more than SATA.  For this reason,
deriving an abstraction from your SATA code that would work for SCSI
isn't an easy feat.

For example, why do you absolutely have to do anything in your eh_timed_out()
callback?  Just atomicly mark your task abstraction as "aborting/aborted" and
return EH_NOT_HANDLED so that you can get called back in your eh_strategy with
a list of commands that need error recovery (ER, from now on).  This is _all_ that
you're going to do in your eh_timed_out() callback.

By also having everything go through eh_timed_out() you can inspect at that instant
if the command has completed and if not, mark it as aborted/aborting, else it has
completed, give it to SCSI Core to complete it for you.

When your ER strategy gets called with a list of commands to be recovered,
it is not necessarily the case that they ended up there because all of them timed
out.  But one thing is for sure, they are all marked aborted/aborting and they
all went through eh_timed_out() and were not done at that time.

Maybe some of them completed ok, and you'd want to "return" them, but cannot since
they were marked "aborted/aborting"... it is this dis-syncrhonization or late-completion,
which you can achieve.

Also consider that the "device failed" you can get from any of the commands on the
er list when your er strategy gets called.  Pick the first command, take a look at the
device, device dead, search the rest of the list for any commands also going to that
device and "recover" them and the device, then go to the next command.

Consider, the SATA layer's task/device abstraction is shared with the LLDD and this
is why you want to use things like eh_timed_out().  For commands and devices it is
most likely the LLDD which will call them and you would want to get notified
somehow of this (via the eh_timed_out()).

Also you want ER to always flow in the same direction from the same starting point
going to the same ending point.

This is the reason to have scsi_req_abort_cmd() and scsi_req_device_reset(), callable
from anywhere by anyone.

Good luck!
    Luben

