From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Summary of the Multi-Path BOF at OLS and future directions
Date: Tue, 5 Aug 2003 17:14:16 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030805171416.A7963@beaverton.ibm.com>
References: <1060042082.1985.53.camel@fuzzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:45499 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S272991AbTHFAO3 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Aug 2003 20:14:29 -0400
Content-Disposition: inline
In-Reply-To: <1060042082.1985.53.camel@fuzzy>; from James.Bottomley@steeleye.com on Mon, Aug 04, 2003 at 08:54:55PM -0700
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James -

Thanks for the summary.

On Mon, Aug 04, 2003 at 08:54:55PM -0700, James Bottomley wrote:

> 1. Multi-path is relevant to more layers of the I/O stack than just
> SCSI. Thus, it makes sense to do it at the layer just above bio.  This
> would either be md/multipath or the Device Mapper multi-path module.

I was hoping for linux scsi to evolve into a "native queueing driver" [1],
adding multi-path to such a driver would be appropriate (of course IMO),
users of the native queueing driver would then get multi-path support.
(This is what I meant when referencing the "packet command interface" at
the SCSI BOF, sorry if the name made no sense, I thought there had been
earlier references to a common "packet interface" driver or such.)

Given the consensus for md/dm, I'm not planning any further work on a scsi
mid-level solution, though technically I prefer the mid-level approach.

One other issue discussed at the multi-path BOF is the lack of character
device (tape) support - dm does not work for such devices. (We do not need
a multi-ported tape device to see multi-path in linux, multiple
initiators on the same transport/bus/etc. also show up as multi-path).

Some other points following.

> 3.  It was noted that symmetric active multi-path in this scheme is not
> possible without the ability to place a proper elevator above the
> multi-pathing driver (and have a simple queue only noop elevator
> below).  This should help alleviate the current fragmentation issues
> where symmetric active multi-path produces I/O in decidedly non-optimal
> page sized chunks.

Related to queueing - we also need to queue commands (in dm) to avoid
sending too many commands to the actual device: dm should not send more
than scsi_device->queue_depth commands.

queue_depth changes via user (sysfs) or kernel space should eventually be
addressed (right now only one LLDD is using the scsi_track_queue_full).

We should eventually export scsi_host attributes (i.e. host_busy reached
can_queue limit, and host_blocked) such that dm can avoid congested or
blocked hosts.

We need to ensure that scsi_device fields (generally the per device state-like)
function properly when used with multi-path dm, including:

	access_count - probably OK with latest ref count changes, so a
	call to the release function by dm should remove a scsi_device (if
	scsi_remove_device was called on an active scsi_device), I don't
	know dm/md enough as to when/how it might release a path/device

	online - more below

	was_reset - probably OK, since it is somewhat path specific

	expecting_cc_ua - probably OK, same as was_reset

	device_blocked - QUEUE FULL was seen, we don't want commands
	on a given path to be starved out

	sdev_state - Mike's changes, I haven't looked at if/how it's
	affected relative to dm multi-path

For the online flag: on timeout, if we fast fail and do not try to recover
the device or transport, the device could be left online, and leave it to
dm to not send any further IO requests. This also might protect us from device
resets (other paths might have active IO). But this means a timeout might
take a dm path offline, and retrying on a separate path could offline all
paths to the device.

> infrastructure for us (in 2.6.0-test2).  The attached patch should add
> the fast fail capability to SCSI (although without the upwards/downwards
> failure indications) and we should be able to build the rest of the
> infrastructure on this framework.

What about a MEDIUM_ERROR - will all sectors be seen as completed with no
error for partial completion of IO (uptodate is 1 in scsi_end_request,
but your patch sets sectors = req->hard_nr_sectors)?

Per above the error handler (cmd timeout) should not requeue/retry if fast
fail is set (in scsi_eh_flush_done_q). And, should the error handler
recovery/resetting run for fast fail?

[1] http://marc.theaimsgroup.com/?l=linux-kernel&m=105400909207359&w=2

-- Patrick Mansfield
