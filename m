From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Re: USB storage problems on OHCI..
Date: 22 Sep 2003 12:55:09 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1064253312.15409.19.camel@mulgrave>
References: <Pine.LNX.4.44.0309221038440.2160-100000@home.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44.0309221038440.2160-100000@home.osdl.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Linus Torvalds <torvalds@osdl.org>
Cc: Patrick Mansfield <patmans@us.ibm.com>, Christoph Hellwig <hch@infradead.org>, Alan Stern <stern@rowland.harvard.edu>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, David Brownell <david-b@pacbell.net>, Greg KH <greg@kroah.com>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>, Andries.Brouwer@cwi.nl
List-Id: linux-scsi@vger.kernel.org

On Mon, 2003-09-22 at 12:41, Linus Torvalds wrote:
> Ok, thanks. In particular, it seems to be pointless to read anything past 
> byte 20 - nothing past there is even defined.
> 
> What's the general sense of things - for a random SCSI device with bugs 
> (and they all have _some_ sort of bugs, let's not just rain on USB here), 
> is it saner to try to read just the bytes we need (3 bytes: page code, 
> page size and the cache bits), or the full 20 bytes?

Generally, we used to do that...we did run across devices (I won't say
which) which tried to send more...i.e. there was a minimum size they
wouldn't transfer below.  By and large, I think it was the headers of
translated commands, though, so as long as we ask for the header +
minimum we need, we should be safe.

I think we could try 4 bytes for this (even to avoid wide residue
problems) and see how it goes.

James




-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
