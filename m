From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Tue, 03 Sep 2002 16:48:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209032148.g83LmeP09177@localhost.localdomain>
References: <dledford@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id OAA29343
	for <linux-scsi@vger.kernel.org>; Tue, 3 Sep 2002 14:48:48 -0700
In-Reply-To: Message from Doug Ledford <dledford@redhat.com>
   of "Tue, 03 Sep 2002 17:13:21 EDT." <20020903171321.A12201@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

dledford@redhat.com said:
> But, regardless, the REQ_BARRIER ordering *can* be preserved  while
> using abort processing.  Since the command that needs aborting is,  as
> you are hypothesizing, before the REQ_BARRIER command, and since it
> hasn't completed, then the REQ_BARRIER command can not be complete and
>  neither can any of the commands behind the REQ_BARRIER.

You are correct.  However, as soon as you abort the problem command (assuming 
the device recovers from this), it will go on its merry way processing the 
remaining commands in the queue.  Assuming one of these is the barrier, you've 
no way now of re-queueing the aborted command so that it comes before the 
ordered tag barrier.  You can try using a head of queue tag, but it's still a 
nasty race.

> On direct access  devices you are only concerned about ordering around
> the barrier, not  ordering of the actual tagged commands, so for abort
> you can actually call  abort on all the commands past the REQ_BARRIER
> command first, then the  REQ_BARRIER command, then the hung command.
> That would do the job and  preserve REQ_BARRIER ordering while still
> using aborts.

I agree, but the most likely scenario is that now you're trying to abort 
almost every tag for that device in the system.  Isn't reset a simpler 
alternative to this?

> > At best, abort probably causes a command to overtake a barrier it shouldn't, 
> > at worst we abort the ordered tag that is the barrier and transactional 
> > integrity is lost.
> > 
> > When error correction is needed, we have to return all the commands for that 
> > device to the block layer so that ordering and barrier issues can be taken 
> > care of in the reissue.

> Not really, this would be easily enough done in the ML_QUEUE area of
> the  scsi layer, but it matters not to me.  However, if you throw a
> BDR, then  you have cancelled all outstanding commands and (typically)
> initiated a  hard reset of the device which then requires a device
> settle time.  All of  this is more drastic and typically takes longer
> than the individual aborts  which are completed in a single connect->
> disconnect cycle without ever  hitting a data phase and without
> triggering a full device reset and  requiring a settle time. 

I agree.  I certainly could do it.  I'm just a lazy so-and-so.  However, think 
what it does.  Apart from me having to do more work, the code becomes longer 
and the error recovery path more convoluted and difficult to follow.  The 
benefit?  well, error recovery might be faster in certain circumstances.  I 
just don't see that it's a cost effective change.  If you're hitting error 
recovery so often that whether it recovers in  half a second or several 
seconds makes a difference, I'd say there's something else wrong.

James


