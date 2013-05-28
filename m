From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: SCSI error handling -- one error blocks the whole SCSI host
Date: Tue, 28 May 2013 09:38:49 -0500
Message-ID: <51A4C179.5000205@tributary.com>
References: <CAL1RGDWuriBQQcTngjn5M3fUg0VC9XUKC_0iMQbf2p2DKfxJsQ@mail.gmail.com> <1369608242.1904.7.camel@dabdike> <51A37019.3050604@suse.de> <1369687319.1950.11.camel@dabdike.int.hansenpartnership.com> <CAC9+an+6iLGfJ9htCnW0xoD=0M1JCObwwMPgYGtTZELEwkYC2w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.56]:35610 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934325Ab3E1OjQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 28 May 2013 10:39:16 -0400
In-Reply-To: <CAC9+an+6iLGfJ9htCnW0xoD=0M1JCObwwMPgYGtTZELEwkYC2w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 5/27/2013 8:32 PM, Baruch Even wrote:

> necessary but the command itself if it is already actively handled
> continues in its path. The abort only cancels those commands that are in
> the queue and if there really was a problem and the disk is engaging in
> error recovery of its own you'll just have no response from it and it will
> seem dead (abort may timeout).

	Yes, the abort seems to be handled more like a "hint" in many cases. Having
coded a couple targets, abort handling is often _REALLY_ hard to get 100%
right. Especially, when its an actual error that is causing the delay, rather
than a correctly functional long running command. That said, I've seen devices
actually respond to aborts on tape ERASE and similar commands by actually
aborting the command as one would expect. So it does sometimes work..

	Besides abort timeouts (which is major bad karma) the abort may be accepted,
and the next non inquiry/tur type command that gets queued simply blocks
waiting for the abort to internally complete. From the target device
perspective, if you don't send a response for ABTS out in 2*RA_TOV then your
problems start to multiply. So it encourages the target devices to treat
aborts in an async manner. As you said, the device simply finds the indicated
command on a queue, marks it as being aborted and hopes whatever is processing
the command notices and terminates its operation. On subsequent commands the
nicer devices will notice the abort hasn't completed and return becoming ready
or similar in response to TUR/etc for some number of minutes.


	

> 
> This view of aborts also means that reducing timeouts for commands and TMFs
> is mostly useless and sometimes even a really bad idea. I prefer to just
> let the device go on with its error recovery and just forget about the 
> command. I want to forget about the DMA so I issue an abort but anything 
> higher than that means a link is dead to me.

	Well, invariably the manufactures have timeouts that are really long and
based on internal error recovery logic. See
http://www-01.ibm.com/support/docview.wss?uid=ssg1S7003556&aid=1 page 468.
Notice the timeouts are specified in minutes, not seconds. Furthermore, the
commands that normally complete in fractions of a second have actual timeouts
that can be tens of minutes (READ/WRITE for example). So, doing anything
before that timeout has expired is a good way to knock the device offline.
Some of the newer disks have mode page options to shorten their read/write
error recovery, but "short" error recovery can still be many tens of seconds
rather than a couple minutes. Plus, it doesn't help compound commands like
"SYNCHRONIZE CACHE" which may take multiple errors during operation.

	This is another part of what formed my opinions about error isolation. If one
of your devices goes out to lunch and isn't recovering via abort/lun reset.
Its done! Wrecking the rest of the SAN doing "bus resets" and HBA resets is a
good way to take a serious problem and turn it into a full blown catastrophe.




