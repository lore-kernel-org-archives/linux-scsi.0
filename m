From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [linux-usb-devel] [2.6-test] Bug in usb-storage or scsi?
Date: 11 Sep 2003 14:42:33 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1063312953.3347.24.camel@patehci2>
References: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:54509 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S261528AbTIKUlc
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 16:41:32 -0400
In-Reply-To: <Pine.LNX.4.44L0.0309111551410.2667-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: patmans@us.ibm.com, mdharm-usb@one-eyed-alien.net, usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org

> From: Matthew Dharm <mdharm-scsi () one-eyed-alien ! net>
>
> I think allowing write to read-only media is
> the only way to go.  I don't see another way
> to get write-protect status.

Does write-protect work for dvd-ram?

How?

> From: 	Alan Stern <stern@rowland.harvard.edu>
> ...
> (Apparently the commands don't present a
> problem for sr.c.)

sr.c shows this problem by getting the wrong answer.

sr.c is getting cd->device->writeable wrong for all the seven-or-so mmc
writable profiles except dvd-ram.

Some background from me and patches from Andy Polyakov and Jens Axboe
appear in:
Subject: Re: [PATCH] mount -w of dvd+rw etc. in vanilla 2.6
http://marc.theaimsgroup.com/?t=106123318400007

> From: Matthew Dharm <mdharm-scsi () one-eyed-alien ! net>
> ... I'm going to have some code that will not
> apply the filters (any filters) if the request
> comes from sg,

More old good sense!

Following are relevant posts from me that some archives before now have
not included in this thread.

Pat LaVarre

---

Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts 
Date: 2003-04-23 14:45:31 PST 
From: Pat LaVarre (ppaatt@aol.com)

> http://groups.google.com/groups?group=mlist.linux.scsi
> Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts 
>
> > From: Patrick Mansfield (patmans@us.ibm.com)
> > Date: 2003-04-07 15:42:13 PST 
> >
> > Would a user ever want to send a MODE SENSE
> > to USB storage device?)
>
> From: Matthew Dharm (mdharm-scsi@one-eyed-alien.net)
> Date: 2003-04-21 17:04:05 PST  
>
> a very large number of USB devices of TYPE DISK do
> not  support MODE SENSE in any form.  Apparently,
> the 'popular' OSes don't use it.

I have some reason to believe Windows often passes thru something like:
-x "1A 00 08 00 18 00" -i x18
i.e. a ModeSense6 of Cacheing page x08 for the whole 4 byte header plus
one whole 8 byte block descriptor plus the whole xC byte standard page.

But I haven't studied this closely enough to know if that's precisely
correct, nor do I know when it gets translated to op x5A ModeSense10,
nor do I know when it is faked out in the host entirely, never reaching
the bus.

> From: Alan Stern (stern@rowland.harvard.edu)
> Date: 2003-04-22 11:21:36 PST ...
>
> a comment in drivers/storage/usb/protocol.c
> indicating that 8 is the minimum size for a
> MODE-SENSE (line 257).

Perhaps we mean:
http://lxr.linux.no/source/drivers/usb/storage/protocol.c?v=2.5.56#L274
/* again, for MODE_SENSE_10, we get the minimum (8) */

I don't know of any merely public standard that admits 8 (i.e. the whole
standard header) is a minimum.

I do know Win 2K kernel dies if a root-privileged app is so rude as to
express an x5A ModeSense10 ModeSense for less than 8 as op x1A
ModeSense6:
http://support.microsoft.com/?kbid=813908
SCSI Pass-Through Mode Sense Command May Crash the Computer

> > From: Matthew Dharm (mdharm-scsi@one-eyed-alien.net)
> > Date: 2003-04-05 11:40:24 PST 
> >
> > (1) can't filter TEST UNIT READY (opcode 0).
> > Not a big deal, but a theoretical problem.
> >
> From: James Bottomley (James.Bottomley@steeleye.com)
> Date: 2003-04-05 12:00:18 PST 
>
> TUR has been mandatory since SCSI-1, ...

A zeroed six byte CDB has been mandatory.  Other forms of TUR are less
widely supported.
...

-----Forwarded Message-----

From: p.lavarre@ieee.org
To: patmans@us.ibm.com
Cc: stern@rowland.harvard.edu, mdharm-usb@one-eyed-alien.net,
usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org
Subject: Re: [usb-storage] Re: [linux-usb-devel] [2.6-test] Bug in
usb-storage or scsi?
Date: 11 Sep 2003 14:04:54 -0600

> http://marc.theaimsgroup.com/?t=104839042700001&r=1&w=2

Thanks, there I find 44 posts dated since 2003-03 with Subject's like:
"PATCH: exclude certain commands from emulated SCSI hosts".

By the way, Google yields [an interestingly] different set of 44 posts:
http://groups.google.com/groups?threadm=linux.scsi.20030322193705.C17056%40one-eyed-alien.net

In both archives I think I see much sense:

> > From: Matthew Dharm <mdharm-usb () one-eyed-alien ! net> ...
> >
> > (a) don't ask for EVPD data, ...
> > (b) assume ... only 36-bytes of INQUIRY data, ...
> > (c) ... assume write-enabled for all disk-like media.
>
> From: Linus Torvalds <torvalds () transmeta ! com>
>
> suggest ... make the Linux SCSI layer
> ... use the sequences of commands that "that other OS" uses ...
> "don't use commands that haven't gotten much testing" ...
...



