From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH; make sr.c respect use_10_for_ms
Date: Sat, 21 Jun 2003 17:21:53 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0306211716110.1980-100000@home.transmeta.com>
References: <20030621171253.H2811@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from neon-gw-l3.transmeta.com ([63.209.4.196]:46865 "EHLO
	neon-gw.transmeta.com") by vger.kernel.org with ESMTP
	id S264292AbTFVAIQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 21 Jun 2003 20:08:16 -0400
In-Reply-To: <20030621171253.H2811@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linux SCSI list <linux-scsi@vger.kernel.org>, Greg KH <greg@kroah.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>


On Sat, 21 Jun 2003, Matthew Dharm wrote:
> 
> I mean, this works, it's not difficult to follow, and meets all the
> operational goals.

As far as I can tell, your patch is not actually all that stable.

Imagine a flaky SCSI connection (think iscsi or whatever), where your
commands are getting lost or corrupted. The first mode-sense command goes 
out, it takes a while to come back, another one goes out for some other 
reason (like scsi-generic), that other one failes due to something else, 
and look what happens: two bugs in one schenario:

 - your code will clear "use_10_for_ms" even though the failure code 
   wasn't due to an unrecognized command, but due to something else 
   (timeout, out-of-memory, whatever)

 - when the other sense command comes back, it was sent with 
   "use_10_for_ms" active, but by the time the result comes back it has
   been cleared, and now we'll use that flag to test what the sense data 
   means. So now we'll get the size wrong.

That sounds flaky to me.

			Linus


