From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:38:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306211735500.1980-100000@home.transmeta.com>
References: <20030621173033.J2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neon-gw-l3.transmeta.com ([63.209.4.196]:23827 "EHLO
	neon-gw.transmeta.com") by vger.kernel.org with ESMTP
	id S264923AbTFVAZL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:25:11 -0400
In-Reply-To: <20030621173033.J2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


On Sat, 21 Jun 2003, Matthew Dharm wrote:
> 
> I don't see how a sense command sent from the scsi-generic interface will
> affect (or be affected by) use_10_for_ms -- if scsi-generic issues the
> command, this code path won't try to interpret the data at all.  Perhaps
> I'm confused?

Yeah, it only works if the first command was sent through sr.c, and the 
second command also clears the use_10_for_ms bit (ie it has to be sent 
through the sr.c or sd.c codepaths). 

The basic idea stands, though: your code depends on global device state 
not to change between the creation of the command and the parsing of it. 
Which just isn't a good thing to do.

sd.c gets all of these things right (including re-transmission etc), 
simply because of how it does things. Which is why I prefer the sd.c 
approach over the simplistic patch. sd.c just looks a lot more robust.

(Maybe that one has bugs too, but they aren't immediately obvious).

		Linus

