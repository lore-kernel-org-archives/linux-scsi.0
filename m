From: Pat LaVarre <p.lavarre@ieee.org>
Subject: [usb-storage] mode sense blacklist how
Date: 13 Nov 2003 19:38:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068777510.2851.359.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131638320.949-100000@ida.rowland.org>
	 <1068767049.2851.166.camel@patrh9>
	 <1068768796.3fb41e1c8d075@webmail.netregistry.net>
	 <1068775834.2851.321.camel@patrh9>
	 <20031113181945.I30194@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:46245 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264498AbTKNCjD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 21:39:03 -0500
In-Reply-To: <20031113181945.I30194@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: mdharm-scsi@one-eyed-alien.net
Cc: usb-storage@one-eyed-alien.net, linux-scsi@vger.kernel.org, dmitrik@users.sourceforge.net, stern@rowland.harvard.edu, patmans@us.ibm.com, james.bottomley@steeleye.com, ronald@kuetemeier.com, idan@idanso.dyndns.org

> The point is to create as narrow an exception as possible.

Yes please.

> ...

To accomodate this device are we asking Dmitri K to give one last shot
to telling us if kernel crash, boot fs crash, or other is the result of
each of the twelve:

> > -i xC0 -y "1A 00:1C:00 C0 00" // Mode Sense (6)
> > -i xC0 -y "1A 00:3F:00 C0 00" // Mode Sense (6)
> > -i x0C -y "1A 00:00:00 0C 00" // Mode Sense (6)
> > -i x0C -y "1A 00:3F:00 0C 00" // Mode Sense (6)
> ...
> -p -i xC0 -y "5A 00 1C:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
> -p -i xC0 -y "5A 00 3F:00:00:00 00 00:C0 00 00:00" // Mode Sense (10)
> -p -i x0C -y "5A 00 00:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
> -p -i x0C -y "5A 00 3F:00:00:00 00 00:0C 00 00:00" // Mode Sense (10)
> ...
> -p -i xC4 -y "5A 00 1C:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
> -p -i xC4 -y "5A 00 3F:00:00:00 00 00:C4 00 00:00" // Mode Sense (10)
> -p -i x10 -y "5A 00 00:00:00:00 00 00:10 00 00:00" // Mode Sense (10)
> -p -i x10 -y "5A 00 3F:00:00:00 00 00:10 00 00:00" // Mode Sense (10)

?

> To blacklist bInterfaceSubClass = 0xFF, you'll have to do that at the
> usb-storage layer (not the SCSI layer).  I generally object to that, but
> not very strongly -- I want usb-storage to be as simple/dumb as possible,
> to reduce to number of places where it doesn't do what the end-user
> expects.  (The principle of least suprise)
> 
> If the blacklist was implemented such that it only blacklisted
> direct-access devices, and only MODE_SENSE and MODE_SENSE_10, and provided
> fake sense data, then it would probably work.  Messy, but it would work.

I remember already in usb-storage we intercept op x12 Inquiry (to munge
bytes[2] compliance to x02 from x00).

I figure there we can flip a bit to say we saw (byte[0] & x1F) PDT = x00
HDD/Flash.  To name & allot the bit, I can follow our earlier incomplete
usb-trace efforts ... urgh, we have no googlable usb-storage archive, I
will review source and see if I remember.

Nearby I suppose we can find bInterfaceSubClass and compare to xFF.

Then if bit set and SubClass xFF and op is x1A/5A we can simulate
failure by auto sense of x12 available bytes with residue = all data and
sk asc = x 5 20 Unsupported Op.

Shall we try that next?

> ...

Ouch, one last thing: tell me again what device/interface descriptors
our usb-storage by default tries to support?

Is that bInterfaceClass ...SubClass ...Protocol = x 08 XX (00|01|50)? 
Or just x 08 (00..06|FF) (00|01|50)?  (Clearly it's not just the
formally defined x 08 (00..06) (00|01|50).)

I ask because if we're supporting bInterfaceSubClass via
drivers/usb/storage/unusual_devs.h then we might rather put the
blacklist there.  But I'm guessing this answer is: x 08 XX (00|01|50),
so we'd rather blacklist all of x 08 FF (00|01|50), rather than growing
unusual_devs.h.

Pat LaVarre


