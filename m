From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] mode sense blacklist how
Date: 14 Nov 2003 12:41:48 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068838908.2852.34.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
	 <1068777510.2851.359.camel@patrh9>
	 <1068779468.3fb447ccc6e60@webmail.netregistry.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out1.iomega.com ([147.178.1.82]:49902 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264369AbTKNTmZ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Nov 2003 14:42:25 -0500
In-Reply-To: <1068779468.3fb447ccc6e60@webmail.netregistry.net>
List-Id: linux-scsi@vger.kernel.org
To: dmitrik@users.sourceforge.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, mdharm-scsi@one-eyed-alien.net, stern@rowland.harvard.edu, patmans@us.ibm.co, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

// Everyone:

I think I'm seeing hints that possibly we've carried this reply-to-all
convention a little too far by now.  Not sure how to fix that.

// Dmitri K:

> > To accomodate this device are we asking Dmitri K to give one last shot
> > to telling us if kernel crash, boot fs crash, or other is the result of
> > each of the twelve ...
> > ?
> 
> I'll be away for the next 4 days. I'll try to test it now, 
> if not I'll report when I come back ...
> What exactly do you want me to do?

Step-by-step instructions follow, in case you choose to try them.

I see we have committed to teaching usb-storage to blacklist mode sense,
despite thereby breaking sd devices that write-protect disks by
implementing mode sense as described in the fiction authored by t10.

Therefore I cannot know who among "we" besides me still cares that the
sample Sony stick you're sharing with us chokes over how we used to try
mode sense.

As for me, yes I remain curious.  I'd like you (and all the world's
engineers) to learn to explore such matters.

> What exactly do you want me to do?

First step in learning to explore this way is to install some tool for
trying SG_IO from the command line, such as the download/ patch/ make
instructions of:

http://groups.google.com/groups?q=plscsi+sed+make

Newsgroups: mlist.linux.scsi
Subject: Re: [PATCH/RFT] mode sense madness always use page 8
Date: 2003-10-30 16:20:20 PST

You know you've finished decrypting that post when you get as far as:

sudo ./plscsi -w

Next you can proceed to try the twelve Sony stick experiments suggested
by that Win XP SP1 trace of an Iomega Zip with disk absent.  I think I
remember translating from those experiments as posted to bash and plscsi
syntax requires just substituting -x for -y, thus yielding:

export PLSCSI=/dev/sda

sudo plscsi -i xC0 -x "1A 00:1C:00 C0 00" // Mode Sense (6)
sudo plscsi -i xC0 -x "1A 00:3F:00 C0 00" // Mode Sense (6)
sudo plscsi -i x0C -x "1A 00:00:00 0C 00" // Mode Sense (6)
sudo plscsi -i x0C -x "1A 00:3F:00 0C 00" // Mode Sense (6)

sudo plscsi -p -i xC0 -x "5A 00 1C:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
sudo plscsi -p -i xC0 -x "5A 00 3F:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
sudo plscsi -p -i x0C -x "5A 00 00:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
sudo plscsi -p -i x0C -x "5A 00 3F:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)

sudo plscsi -p -i xC4 -x "5A 00 1C:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
sudo plscsi -p -i xC4 -x "5A 00 3F:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
sudo plscsi -p -i x10 -x "5A 00 00:00:00:00 00 00:10 00 00:00" // Mode Sense (10)
sudo plscsi -p -i x10 -x "5A 00 3F:00:00:00 00 00:10 00 00:00" // Mode Sense (10)

I trust already you understand, running plscsi with root or even just
device-write privilege by design can and does crash your kernel on
occasion, thus smashing automounted or manually mounted fs.

plscsi in effect gives you a way of typing out some of the code of a
module at the command line.  Entering a mistyped or misconceived line of
plscsi can hurt you as deeply as loading an untested .ko.

I wonder if already you understand, you might like the results better if
you only try talking while you device has no disk inserted, or at least
while disk not mounted, and preferably while you have no automounter
talking to your device.

> From: Dmitri Katchalov ...
> I'll be away for the next 4 days.

Soon I will discover if I replied quickly enough to catch you. :)

Pat LaVarre


