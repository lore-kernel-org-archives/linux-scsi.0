From: Michael Reed <mdr@sgi.com>
Subject: Re: [PATCH] make fc transport removal of target configurable
Date: Tue, 13 Jun 2006 14:36:16 -0500
Message-ID: <448F13B0.20803@sgi.com>
References: <448DF5DA.3070800@sgi.com> <20060613070714.GA16358@infradead.org> <448E9C34.6070707@emulex.com> <448EDCEB.50702@sgi.com> <448EF4D4.4090402@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:5864 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1751192AbWFMTge (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 15:36:34 -0400
In-Reply-To: <448EF4D4.4090402@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: James.Smart@Emulex.Com, Christoph Hellwig <hch@infradead.org>, linux-scsi <linux-scsi@vger.kernel.org>, Jim Nead <jnead@sgi.com>, Jeremy Higdon <jeremy@sgi.com>, Gary Hagensen <gwh@sgi.com>



Stefan Richter wrote:
> Michael Reed wrote:
>> James Smart wrote:
>>> We are seriously in trouble if the subsystems above us don't know how
>>> to deal with dead targets. We are encountering scenarios in which the
>>> data structures are staying around due to references, but for all other
>>> intents they're gone.  I know that DM has yet to fully account for this.
>>> md - it's dead. Applications... they have no clue.
>> Mounted file systems have no clue either.  Even with no activity on the
>> fs, if the target stays missing beyond the device loss timeout and then
>> returns, the file system cannot be accessed without intervention.
>>
>> When the target does return, the file system has to be unmounted and
>> remounted on a new "sd" device.  This is even if there was no activity
>> on the file system while its target was absent, i.e., it wouldn't otherwise
>> require an unmount/remount.
> 
> Michael, I don't understand how your patch fits into this picture.

The patch allows the target to return to its existing infrastructure
following a prolonged absence due to, say, a kicked cable or raid controller
reboot.  Current file systems, volume managers, and multi-path drivers
do not seem to tolerate the return of a target to new infrastructure.

> 
> There is presently the FC transport parameter 'dev_loss_tmo', which is
>     "Maximum number of seconds that the FC transport should"
>     " insulate the loss of a remote port. Once this value is"
>     " exceeded, the scsi target {is|may be} removed. {%|Reference"
>     " the remove_on_dev_loss module parameter.} Value should be"
>     " between 1 and SCSI_DEVICE_BLOCK_MAX_TIMEOUT.");
> 
> Then you are adding the parameter 'remove_on_dev_loss', which is
>     "Boolean.  When the device loss timer fires, this variable"
>     " controls whether the scsi infrastructure for the target"
>     " device is removed.  Values: zero means do not remove,"
>     " non-zero means remove.  Default is zero.");
> 
> I think the 2nd parameter does not help anyone. What you rather seem to
> need is
>  a) the existing dev_loss_tmo parameter but without the kernel
>     enforcing an upper limit for it [the admin sets the policy, not
>     the kernel], and
>  b) the transport layer or the SCSI core taking care that no SCSI
>     command times out during the tolerated absence of a target.

Actually, I do not want this.  The limit on the dev_loss_tmo parameter
is there to allow error notification to eventually pass up the stack.
This is important in path failover situations.  An infinite value here
would imply that commands do not time out.

> 
> So, for every layer above the transport layer or of SCSI core (SCSI
> command set drivers and sg driver, block layer, filesystem...),
> everything becomes fully transparent. These layers do not notice absence
> of the target. If anything at all, they merely notice that commands take
> unusually long to complete.

The transport currently holds off commands with a combination of DID_IMM_RETRY,
blocking the target so that no new commands are issued, and holding off
error recovery until the dev loss timer expires.  This is the behavior that
is desired.

What I want is to have the device, when it returns, reconnect to it's
existing infrastructure.  This allows previously connected "users"
to reconnect.

Mike


> 
> Of course there are practical limits to this:
>  - We don't want to wait ages for commands to complete or to fail.
>  - The device's state may have changed arbitrarily during its absence
>    due to an external influence, leading to corruption when it comes
>    back.
> But again, the decision about the limit for such tolerated absence
> should be a decision by the admin, not one by the kernel. The driver
> software and the involved kernel infrastructure should merely provide
> mechanisms but not enforce a policy, at least not to unnecessary extent.
> 
> Anyhow. My point is: It seems what you want is 1. to let the admin set
> an arbitrary dev_loss_tmo and 2. the transport or the SCSI core taking
> care that no commands time out during that period.
> 
> Where to implement this? The transport layer has the benefit to have a
> better notion of target states because it is closer to the interconnect
> layer than the SCSI core. On the other hand, the SCSI core is rather the
> place where mechanisms to handle the lifecycle of targets and especially
> of commands exist.
> 
> The SCSI core seems appropriate for another reason: The issue at hand is
> not really specific to the FC transport. Maybe we want dev_loss_tmo to
> be independently configurable for different transports or on a
> per-host-adapter basis, or on a per target basis. But generally,
> temporary absence of a target is a *natural and common state* for some
> other transports besides FC. (Example: Bus reset phase and rescanning of
> FireWire interconnect == connection loss and subsequent reconnect or
> re-login of SBP-2 transport. This is a rather short period, but I
> already thought about implementing a prolongued state of absence in sbp2
> for two other specific purposes.)
> 
> If it was decided to implement this "tolerated temporary absence of a
> target" in SCSI core, then the SCSI core's state machine would "simply"
> have to handle another target state.
> 
> I put "simply" into quotes because the existing state model seems not to
> be exactly at a point where you could immediately proceed to add such
> additional state. In particular, the SCSI core does not yet support the
> state "device temporarily not accessible". The state "device blocked" is
> similar but ultimately not the same. Besides, the SCSI core does also
> not distinguish the state transitions "device operational -> device
> removal requested" versus "device operational -> device hot unplugged".
> (The latter transition does not exist for SCSI core; transport layers or
> low-level drivers have to initiate the transition to "device removal
> requested" and work around the subsequent problems when it was actually
> a hot unplug.)
> 
> Side note to everything above: Yes, I may have missed something, so
> correct me.
