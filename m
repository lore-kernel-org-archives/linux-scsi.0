From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Tue, 03 Sep 2002 17:02:48 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209032202.g83M2mC09323@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id PAA31958
	for <linux-scsi@vger.kernel.org>; Tue, 3 Sep 2002 15:02:56 -0700
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Tue, 03 Sep 2002 14:24:34 PDT." <20020903142434.A2538@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> If we only send an abort or reset after a quiesce I don't see why one
> is better than the other.

Quiesce means from the top (no more commands go from the block layer to the 
device) not from the bottom (commands can still be completed for the device).

> Not specific to reset or abort - if a single command gets an error, we
> wait for oustanding commands to complete before starting up the error
> handler thread. If all the commands (error one and outstanding) have
> barriers, those that do not error out will complete out of order from
> the errored command. 

We don't wait.  The commands may possibly be completing in parallel with 
recovery.  To address your point, though, that's why the device needs to be 
reset as fast as possible: to preserve what's left of the command order.  I 
accept that for a misbehaving device, this may be a race.

> And what happens if one command gets some sort of check condition
> (like medium error, or aborted command) that causes a retry? Will IO's
> still be correctly ordered? 

Retries get eliminated.  It should be up to the upper layers (sd or beyond) to 
say whether a retry is done.  Since, as you point out, retries automatically 
violate any barrier, it is probably up to the block layer to judge what should 
be done about the problem.

> I would like to see error handling occur without quiescing the entire
> adapter before taking any action. Stopping all adapter IO for a
> timeout can be a bit expensive - imagine a tape drive and multiple
> disks on an adapter, any IO disk timeout or failure will wait for the
> tape IO to complete before allowing any other IO, if the tape
> operation is long or is going to timeout this could be minutes or
> hours. 

Actually, I do think that quiescing has an important role to play.  A lot of 
drive errors can be self inflicted indigestion by accepting more tags into the 
queue than it can process.  Quiescing the queue lets us see if the drive can 
digest what it currently has or whether we need to apply a strong emetic.

I'd actually like to add tag starvation recovery to the error handler's list 
of things to do.  In that case, all you do on entry to the error handler is 
quiesce the upper queue and wait a while to see if the commands continue 
returning.  You only begin more drastic measures if nothing comes back in the 
designated time period.

James


