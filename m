From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 17 Nov 2003 13:14:13 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069100053.2324.118.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
	 <1068838908.2852.34.camel@patrh9> <20031114153607.A7207@beaverton.ibm.com>
	 <20031116121039.A13224@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:14759 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S263675AbTKQUOp
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Nov 2003 15:14:45 -0500
In-Reply-To: <20031116121039.A13224@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: patmans@us.ibm.com
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, dmitrik@users.sourceforge.net, mdharm-scsi@one-eyed-alien.net, stern@rowland.harvard.edu, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> [Resending, this never showed up on linux-scsi.]

us.ibm.co vs.us.ibm.com ambiguities may have entered this thread from
here, sorry ouch ouch ouch, these new-fangled protocols for mixing human
names into mailto addresses don't quite reach me everywhere I connect.

> I am not really sure what happened, I think it is waiting for a 30 hr
> timeout to complete, you ought to lower the timeout a bit ;-)

Just before we redesign this plscsi default for a different audience ...

Please tell me why Ctrl+C aka SIGINT doesn't work?

As a client of SG_IO, am I supposed to work to catch SIGINT explicitly
so I can pass that SIGINT thru sg somehow?  (And is that answer
documented anywhere?)

> I am not really sure what happened, I think it is waiting for a 30 hr
> timeout to complete, you ought to lower the timeout a bit ;-)

Thank you for saying.  You are the second host developer who has somehow
found the time to tell me this.  An override syntax that might work is:

export PLSCSI=/dev/sda -X time 5 0

I'll race you all to try and report back how accurately I'm remembering
that plscsi syntax.

The issue of a long timeout arises because personally I've lived mostly
as a developer of device firmware, rather than host software.

A long timeout was the only effective way I found to persuade the host
to let me stop a test at first weirdness.  With short timeouts, the host
would automagically attack the device with resets, destroying all
evidence of what went wrong to begin with.

To my eye, polite hosts delay the automagic attack until the next
command.  That way, I can sit at the top of the stack and ask to halt at
first weirdness.  So long as I prevent any other commands from going
down thru the stack, then so likewise do I prevent the automagic
attack.  But only if I have a host designed to be polite by default.

> The following did nothing, I am running on 2.6 current bk + only my earlier
> send oversize MODE SENSE buffer patch.
> 
> Is that expected without -v?
> 
> > sudo plscsi -p -i xC0 -x "5A 00 1C:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)

Yes I now agree I should have mentioned we add -v to see a trace of what
was tried when, sorry I did not.

> Full results:

Great fun, thank you.

> + PLPROG=/home/patman/src/plscsi/plscsi
> + DEV=/dev/sda
> + /home/patman/src/plscsi/plscsi -i xC0 -x '1A 00:1C:00 C0 00' /dev/sda
> // x 5 20 sense // xC0 (192) residue
> // -x0102 = -258 = plscsi.main exit int
> + /home/patman/src/plscsi/plscsi -i xC0 -x '1A 00:3F:00 C0 00' /dev/sda
> // x 5 20 sense // xC0 (192) residue
> // -x0102 = -258 = plscsi.main exit int
> + /home/patman/src/plscsi/plscsi -i x0C -x '1A 00:00:00 0C 00' /dev/sda
> // x 5 20 sense // xC (12) residue
> // -x0102 = -258 = plscsi.main exit int
> + /home/patman/src/plscsi/plscsi -i x0C -x '1A 00:3F:00 0C 00' /dev/sda
> // x 5 20 sense // xC (12) residue
> // -x0102 = -258 = plscsi.main exit int

Cool.

Here we repeatedly see nonzero residue equal to the data byte count
asked to copy in.  That suggests we may be getting accurate reporting of
residue from the connection between you and the drive.

SK ASC = x 5 20 correlates with versions of t10.org English over time,
all of which I think I remember say op not known i.e. cdb[0] not known
i.e. apparently this device correctly reports it does not support op x1A
Mode Sense (6).

> + /home/patman/src/plscsi/plscsi -p -i xC0 -x '5A 00 1C:00:00:00 00 00:C0 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i xC0 -x '5A 00 3F:00:00:00 00 00:C0 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i x0C -x '5A 00 00:00:00:00 00 00:0C 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i x0C -x '5A 00 3F:00:00:00 00 00:0C 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i xC4 -x '5A 00 1C:00:00:00 00 00:C4 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i xC4 -x '5A 00 3F:00:00:00 00 00:C4 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i x10 -x '5A 00 00:00:00:00 00 00:10 00 00:00' /dev/sda
> + /home/patman/src/plscsi/plscsi -p -i x10 -x '5A 00 3F:00:00:00 00 00:10 00 00:00' /dev/sda

I guess here we have been reading something much like a tty log of:

#!/bin/bash -x

By that guess, this quote says all those commands completed without
error.

>From that guess we conclude, if we try talking mode sense like Windows
does, we here have found one more device supporting us.

> Following is the "breaking" command that caused the original "--babble"
> and problem.
> 
> ./plscsi /dev/sda -v -i x4 -x "5A 00 3F:00:00:00 00 00:08 00"

Ouch that's gross.

That 00:08 in the bytes[7:8] of the -x "$cdb" tells the device to copy
up to 8 bytes in, but the -i x4 tells the device to never copy more than
4 bytes in.  We throw paradox at the device, and we get back "babble". 
Shame on the device, but shame on us too.

Mind you, since here we have CBI/CB protocol rather than BBB protocol,
the device never sees the -i x4, the device sees only the 00:08.  So in
a bus trace we see no babble: only the host that tries to reconcile -i
x4 with 8 bytes in from the device sees babble.

Since the device can't see CBI/CB break this way, the device can't
help.  With CBI/CB, by design, only the host can avoid this kind of
trouble, only by more accurately guessing in advance out-of-band how the
device will actually interpret a particular cdb.

> Luckily unplugging the device completes, and I can plug it back in and
> everything is ok! That is quite nice! Thanks for all the nice hotplug and
> ref-counting code everybody.

Brilliant, aye, kudos everyone.

> Following is the usb storage debug logs for the above command, including
> "--babble" output. 
> 
> I added some messages via "logger -p kern.debug" to separate things.

Ooooh.  I've been looking to discover that `logger` command since the
day I discovered `dmesg`.  Thank you for naming it explicitly.

> Weird that we tried to send another MODE SENSE *after* I unplugged the
> device, maybe an abort or cancel of the commands caused it to retry before
> the device was actually removed, more likely usb aborted outstanding
> commands prior to a call to scsi_remove_host (that is OK).
> 
> -----------------------------------------------------------------------------
> 
> Nov 14 14:51:34 laptop patman:  NOTE pre post too short command sent
> ...
> Nov 14 14:52:39 laptop patman: NOTE unplugging device NOTE
> ...
> Nov 14 14:52:44 laptop kernel: usb-storage: -- usb_stor_release_resources finished
> ...
> Nov 14 14:52:52 laptop patman: NOTE device unplugged NOTE

I read that trace with interest, thank you.

Pat LaVarre


