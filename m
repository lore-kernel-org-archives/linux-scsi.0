From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: bCWBCBLength is cb length no when
Date: 05 Dec 2003 12:29:25 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1070652564.12411.436.camel@patibmrh9>
References: <Pine.LNX.4.44L0.0312051351420.645-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:64916 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264341AbTLET3g
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 5 Dec 2003 14:29:36 -0500
In-Reply-To: <Pine.LNX.4.44L0.0312051351420.645-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-scsi@vger.kernel.org, Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Alex Sanks <alex@netchip.com>, Julian Back <jback@mpc-data.co.uk>, David Brownell <david-b@pacbell.net>

> > > Incidentally, Pat, can you confirm whether bInterfaceSubClass x01 = RBC 
> > > (Reduced Block Commands, T10 project 1240-D) uses 0-padding of commands to 
> > > 12 bytes or not?  The Linux usb-storage driver seems to think that it 
> > > doesn't.
> > 
> > I can neither concisely confirm, nor concisely deny, sorry.
> ...
> Since usb-storage uses the a+b+d interpretation, that's what I'm inclined 
> to go with until more evidence arrives.  But to be safe, it might be best 
> to accept commands either with or without padding.

Oh, aye, sorry I answered with host context in mind, certainly I agree
"be liberal in what you accept" when speaking as the device receiving
the cdb.

Since as a device we know what the cdb[0] op means, we can develop an
independent idea of how long the cdb is.  With dreary conventionality,
let's call that length Do, and say Ho = bCBWCBLength.  Then concisely we
conclude:

1) Do = Ho everybody happy.

2) Ho < Do miscompare on purpose by quietly discarding cdb bytes out,
especially if Ho is 12 and/or pad is zero (rather than the other popular
choices of xFF and of copy of cb length)

3) Do < Ho miscompare on purpose by quietly fabricating zero pad.

That's the choice I shipped as usb/atapi bridge, mostly it works.

Something like (3) is explicitly required by 99 Sep bbb: text defining
CBW says something about device shall ignore cb bits past the cb length.

Sorry to say, yes actually I have seen (3) necessary to make sense of
the misspelled -i 8 -y "25 00 00:00:00:00" meaning -i 8 -y "25 00
00:00:00:00 00 00:00 00" i.e. Read Capacity.

> ...

However, since as a device we are aggressively choosing to recover from
the soft error of Do != Ho, ...

Please can we have a way of counting soft errors e.g. please can we have
at least one dmesg per boot to mention this msft/other host design
un/consciously disregarded "be conservative in what you send".

Pat LaVarre

P.S.

> message that came to me was not uuencoded at all.

Thanks for saying, I was curious.

Reverse chronological web trails celebrating "Linux live-CD" distros
defeating annoying Windows limitations include:

http://linux.oreillynet.com/pub/a/linux/2003/11/20/knoppix.html

http://lwn.net/Articles/59504/bigpage

draft not yet connected with ftp put privilege of
http://members.aol.com/plscsi/tools/knoppix/


