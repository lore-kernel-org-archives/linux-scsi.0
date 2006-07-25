From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [RFC] fc transport: extensions for fast fail and dev loss
Date: Tue, 25 Jul 2006 14:49:17 -0400
Message-ID: <44C667AD.8090604@emulex.com>
References: <1150829123.16981.1.camel@localhost.localdomain> <44C65116.3030503@cs.wisc.edu>
Reply-To: James.Smart@Emulex.Com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:63462 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S1751491AbWGYS5O
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Jul 2006 14:57:14 -0400
In-Reply-To: <44C65116.3030503@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org



Mike Christie wrote:
> 
> So is the fast_io_fail_tmo callback the terminate_rport_io callback?

Yes.
When fast_io_fail_tmo expires, it calls the terminate_rport_io() callback.

 > If
> so, are we supposed to unblock the rport/session/target from
> fc_timeout_fail_rport_io

No... don't unblock.

 > and call into the LLD and the LLD will set some
> bit (or maybe check some rport/session/target/scsi_device bit) so that
> incoming IO and IO sitting in the driver will be failed with something
> like DID_BUS_BUSY so it goes to the upper layers?

The way this is managed in the fc transport is - the LLD calls the
transport when it establishes connectivity (an "add" call), and when it
loses connectivity (a "delete" call). When the transport receives the
delete call, it changs the rport state, blocks the rport, and starts the
dev_loss timeout (and potentially the fast_io_fail_tmo if < dev_loss).
If the LLD makes the add call prior to dev_loss expiring, then updates
the state, and unblocks the rport.  If dev_loss expires, it updates
state again (essentially the true deleted state) and tears down the
target tree.

To deal with requests being received while blocked, etc - the LLD's use
a helper routine (fc_remote_port_chkready()), which validates the rport
state, and if not valid (e.g. blocked or removed) returns the appropriate
status to return to the midlayer. If blocked, it returns DID_IMM_RETRY.
If deleted, it returns DID_NO_CONNECT.

What the above never dealt with was the i/o already in the driver. The
driver always had the option to terminate the active i/o when the loss
of connectivity occured, or it could just wait for it to timeout, etc
and be killed that way. This patch added the callback at dev_loss_tmo
to guarantee i/o is killed, and added the fast_io_fail_tmo if you
wanted a faster guarantee. If fast_io_fail_tmo expires and the callback
is called - it just kills the outstanding i/o and does nothing to the
rport's blocked state.

 > I think I only the
> unblock happen on success or fc_starget_delete, so IO in the driver
> looks like it can get failed upwards but IO sitting in the queue sits
> there until fc_rport_final_delete or success.

Yeah - essentially this is correct. I hope the above read that way.
I'm also hoping the iSER folks are reading this to get the general
feel of what's happening with block, dev_loss, etc.

> 
> If that is correct, what about a new device state? When the fail fast
> tmo expires we can set the device to the new state, run the queue and
> incoming IO or IO in the request_queue marked with FAILFAST can be
> failed upwards by scsi-ml.
> 
> I just woke up though :)

Sounds reasonable. It is adding a new semantic to what was meant by
fast_fail - but it's in line with our goal.  The goal was to terminate
i/o so that they could be quick rescheduled on a different path rather
than wait (what may be a long time) for the dev_loss connectivity
timer to fire.  Makes sense you would want to make new i/o requests
bound by that same window.

-- james s
