From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: RE: Mid-layer handling of NOT_READY conditions...
Date: Mon, 31 Jan 2005 10:22:57 -0800
Message-ID: <1107195778.6126.32.camel@plap>
References: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch01.qlogic.com ([198.70.193.200]:52153 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261297AbVAaSWl
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 13:22:41 -0500
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: patmans@us.ibm.com, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

On Mon, 2005-01-31 at 11:56 -0500, James.Smart@Emulex.Com wrote:
> > On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:
> > > On Sat, Jan 29, 2005 at 10:44:41AM -0600, James Bottomley wrote:
> > > > On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
> > > > > Returning back DID_IMM_RETRY for these 'transport' 
> > related conditions
> > > > > would of course help in this issue -- but at the same 
> > time bring with it
> > > > > several side-effects which may not be desirable.
> > > > > 
> > > > > So, beyond this particular circumstance, what would be 
> > considered a
> > > > > 'proper' return status for this type of event? 
> > > > 
> > > > Well, the correct return, since this is a condition from 
> > the storage, is
> > > > simply the check condition and the sense code (rather 
> > than having the
> > > > driver interpret it).
> > > 
> > > But the transport hit a failure, not the storage device.
> > > 
> > > I thought Andrew hit this sequence:
> > > 
> > > 	- pull / replace cable
> > > 
> > > 	- IO resumes but gets NOT_READY (the device could be 
> > logging back
> > > 	  into the fibre or such)
> > > 
> > > 	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
> > > 	  scmd->retries has already been exhausted by the NOT_READY
> > > 
> > > Did I misread something?
> > > 
> > 
> > No, that's correct -- sorry about the confusion my second 
> > email caused.
> > I had only inquired about the 'correct' return status in the 
> > context of
> > avoiding the (cmd-retries > cmd->allowed) failure.
> 
> So this maps into the fc_target_block/unblock functionality that was
> added to the fc class...  Adapter notifies driver of cable loss and
> starts the block, driver does not "resume" the traffic until the
> firmware says the login, etc

Yes.

>  has the device ready to accept scsi
> traffic (Note: it does not guarantee the device can't respond with
> a NOT_READY sense code).

Exactly.

>   If the transport hits a problem, there's
> no harm done as long as the problem is resolved within the block
> timeout. If the timeout is hit - it's because the user dicated that
> it wanted to know of errors within this time and if the device fails,
> it fails...
> 
> In the multipath solution - the "block" time used by the transport gets
> set to 0 (or 1 second), so the i/o fails quickly and the multipath
> function can kick in.
> 

A bit confused now, are you proposing that cmd->timeout_per_command time
be inclusive of potential transport failures resulting in a requested
retry?  And thus not be refreshed (as it currently is) upon retry
request.

> I am not a fan of a driver manufacturing a NOT_READY condition...
> 

Again -- there is no manufacturing of check-conditions. Their existence
only highlighted the point that the retries value was being exhausted
(quickly) during the state and thus restricts a LLDD's ability to return
any status which would initiate a normal retry (i.e. DID_BUS_BUSY).

> > > 
> > > Why not just set scmd->retries to zero in scsi_requeue_command()?
> > > 
> > 
> > This is exactly what I was thinking would be a fairly straight-forward
> > approach at solving the problem...
> 
> This is ultimately a hack, and raises the potential for the retries value
> to perpetually be rezero'd.  The better solution is the use the block
> primitives available to avoid the i/o being issued at all if the transport
> can't handle it.
> 

Agree -- the midlayer internally plugging a device for a small period of
time while some NOT_READY (and any other similar) state is received from
the storage is the more appropriate direction.   Perhaps there could be
a combination of timing conditionals -- the fc_starget_dev_loss_tmo() to
time the overall pause in 'not-ready' plugging and a
period-to-wakeup-and-ping-the-storage time within the window?

--
av
