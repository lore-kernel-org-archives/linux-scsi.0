From: James.Smart@Emulex.Com
Subject: RE: Mid-layer handling of NOT_READY conditions...
Date: Mon, 31 Jan 2005 11:56:02 -0500
Message-ID: <0B1E13B586976742A7599D71A6AC733C02F326@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:9903 "EHLO emulex.emulex.com")
	by vger.kernel.org with ESMTP id S261247AbVAaQ4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 31 Jan 2005 11:56:36 -0500
Content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, patmans@us.ibm.com
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org

> On Sat, 2005-01-29 at 11:34 -0800, Patrick Mansfield wrote:
> > On Sat, Jan 29, 2005 at 10:44:41AM -0600, James Bottomley wrote:
> > > On Fri, 2005-01-28 at 21:46 -0800, Andrew Vasquez wrote:
> > > > Returning back DID_IMM_RETRY for these 'transport' 
> related conditions
> > > > would of course help in this issue -- but at the same 
> time bring with it
> > > > several side-effects which may not be desirable.
> > > > 
> > > > So, beyond this particular circumstance, what would be 
> considered a
> > > > 'proper' return status for this type of event? 
> > > 
> > > Well, the correct return, since this is a condition from 
> the storage, is
> > > simply the check condition and the sense code (rather 
> than having the
> > > driver interpret it).
> > 
> > But the transport hit a failure, not the storage device.
> > 
> > I thought Andrew hit this sequence:
> > 
> > 	- pull / replace cable
> > 
> > 	- IO resumes but gets NOT_READY (the device could be 
> logging back
> > 	  into the fibre or such)
> > 
> > 	- a FC transport problem is hit, DID_BUSY_BUSY is returned, but
> > 	  scmd->retries has already been exhausted by the NOT_READY
> > 
> > Did I misread something?
> > 
> 
> No, that's correct -- sorry about the confusion my second 
> email caused.
> I had only inquired about the 'correct' return status in the 
> context of
> avoiding the (cmd-retries > cmd->allowed) failure.

So this maps into the fc_target_block/unblock functionality that was
added to the fc class...  Adapter notifies driver of cable loss and
starts the block, driver does not "resume" the traffic until the
firmware says the login, etc has the device ready to accept scsi
traffic (Note: it does not guarantee the device can't respond with
a NOT_READY sense code).  If the transport hits a problem, there's
no harm done as long as the problem is resolved within the block
timeout. If the timeout is hit - it's because the user dicated that
it wanted to know of errors within this time and if the device fails,
it fails...

In the multipath solution - the "block" time used by the transport gets
set to 0 (or 1 second), so the i/o fails quickly and the multipath
function can kick in.

I am not a fan of a driver manufacturing a NOT_READY condition...

> > 
> > Why not just set scmd->retries to zero in scsi_requeue_command()?
> > 
> 
> This is exactly what I was thinking would be a fairly straight-forward
> approach at solving the problem...

This is ultimately a hack, and raises the potential for the retries value
to perpetually be rezero'd.  The better solution is the use the block
primitives available to avoid the i/o being issued at all if the transport
can't handle it.

James S
 
