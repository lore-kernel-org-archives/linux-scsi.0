From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Asynchronous target discovery, version 10
Date: Mon, 24 Jul 2006 09:02:24 -0600
Message-ID: <20060724150223.GG29603@parisc-linux.org>
References: <20060721155710.GB9214@parisc-linux.org> <44C4CF1E.8090700@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:43749 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750842AbWGXPCZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Jul 2006 11:02:25 -0400
Content-Disposition: inline
In-Reply-To: <44C4CF1E.8090700@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org, Jack Steiner <steiner@sgi.com>, Lee Schermerhorn <Lee.Schermerhorn@hp.com>, Anton Blanchard <anton@samba.org>, Justin Chen <justin.chen@hp.com>

On Mon, Jul 24, 2006 at 09:46:06AM -0400, James Smart wrote:
> - I disagree with the handing off of a function pointer, with no real
>   bounds on it's "lifetime". There are windows with the current code
>   that if the driver were to then fail attachment and tear down
>   the shost, it would lead to bogus function calls, as well as
>   threads, etc that are essentially orphaned.

Can't happen; we take a reference on the shost and only release it once
it's done:

        data->shost = scsi_host_get(shost);

> - The jiffies thing for lpfc isn't needed, we'll deal with it in
>   the driver.

OK, I can take that out again.

> - I'm a little nervous with the scsi_scan_target() vectoring into
>   scsi_complete_async_scans(). The fc transport does this on a work
>   queue, which means you are stalling it, mixing the fchost work
>   queue with other driver code, etc (flushes always are a headache).
>   Today, it's ok, but...
>   >>Note: found another bug in the fc transport sysfs scan
>   >> function. We're supposed to be holding the shost_lock when
>   >> scan target is called - which would be bad news for your patch
>   >> as is. Good news is, we have a bug and aren't holding the lock.
>   >> I'll have to fix this bug.

We only wait for other scans to finish if this host isn't in the middle
of an async scan.  So this isn't a problem either.

> - I'd prefer the callback function to be part of the shost template,
>   and kicked in as of scsi_add_host(), and terminated as of
>   scsi_remove_host(). This would also make the thread integrated
>   with the host. Also, this "scan_ready" check feels like it should
>   be more of a generic thing that is always executed in the scan
>   code if the function is present.  I'll try to send out a counter
>   patch.

I'm open to this.  I think what I'd prefer to see is the FC drivers
setting a SHT->scan_finished() method, then calling scsi_scan_host()
which would then do something completely different for drivers which
have a scan_finished method than it would for SPI drivers.

> - For lpfc, I need to do a different patch. The delay, based on
>   where it was, occurred in other paths, such as when applications
>   took the card online/offline. So, I'll need to deal with them.
>   I don't know if the other vendors have the same issue.
>   Also, I'll have to test it before ACK'ing it.

Yes, I got a bug report by private mail saying that the QLogic driver
still waits for LIPs to complete for 20 seconds per card.  So more
iteration on this patch is certainly needed.

> - Lastly, be aware that this code only helps parallelize the discovery
>   delay loops in each host (the goal :). It does nothing to aid
>   consistent device naming. There are still no guarantees about which
>   rport gets which target id, which is scanned first/later, etc.
>   Udev is still a requirement.

Yes, indeed.  It occurs to me that the async scanning code does actually
give us a chance to sort devices before they get added to sysfs (and
named).  I don't understand the exact problem that FC has, but this
could give us back the sort order that you had when you were doing your
own discovery, right?


Clearly I haven't done a good enough job explaining how this patch
works.  I'm going to do a design document now ...
