From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 22 Mar 2003 23:39:05 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303222337260.5588-100000@home.transmeta.com>
References: <20030322233136.D17056@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030322233136.D17056@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


On Sat, 22 Mar 2003, Matthew Dharm wrote:
> 
> As I see it, SCSI commands break down into two basic categories:  common
> and uncommon.  Common things (basic read and write, 36-byte INQUIRY, eject,
> etc.) are all fine, but the 'uncommon' things (checking cache type,
> 255-byte INQUIRY, etc) cause problems.  I'm trying to find a way to choke
> off the problematic commands without having to write code to recognize what
> is being sent (and choke it off) based on what is in the command bytes.
> 
> I'm open to suggestions.

How about making the SCSI stuff pass a "common" flag (or "required") down
with the command? Then, a emulated thing could just decide to punt all 
commands with an immediate failure if they aren't marked "required".

That still _allows_ the driver to implement it if it wants to, unlike your 
previous approach.

		Linus

