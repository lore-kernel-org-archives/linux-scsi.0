From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: 24 Mar 2003 09:15:57 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1048519237.1982.16.camel@mulgrave>
References: <20030322193705.C17056@one-eyed-alien.net>
	<Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
	<20030322233136.D17056@one-eyed-alien.net>
	<1048467235.1634.22.camel@mulgrave>
	<20030323173733.B24668@one-eyed-alien.net>
	<1048469946.1643.2.camel@mulgrave>
	<20030323230438.E24668@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030323230438.E24668@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>
Cc: Linus Torvalds <torvalds@transmeta.com>, USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>

On Mon, 2003-03-24 at 01:04, Matthew Dharm wrote:
> Well, here's my list of what the 'popular OS' uses for all devices:
> 
> INQUIRY (for only 36 bytes -- nothing else!)
> TEST_UNIT_READY
> REQUEST_SENSE
> ALLOW_MEDIUM_REMOVAL (mostly for eject purposes)
> 
> For disk-like media:
> 
> READ_10
> WRITE_10

We do about the best we can for read and write.  For sd, we gauge the
size of the command from the size of the medium:  <1Gb=> six byte, from
1Gb to 2Tb 10 byte, over 2Tb 16 byte, so I think this should all be
fine.

> I'd have to go back to my notes for tape and CD media.  But those aren't my
> biggest problem areas -- the common probe and the disk driver are my
> biggest headaches.
> 
> Note that MODE_SENSE isn't on this list.  How does the 'popular OS' test
> for write-protect, you ask?  It tries to write and then looks for a
> failure, AFAICT.

We use MODE_SENSE on CDs to probe for capabilities: this is required
behaviour and we've been doing for a long time.

sd also uses MODE_SENSE to probe the cache type as well as the write
protect state.  Cache type certainly can't be obtained any other way,
and I'm not sure allowing writes to read only media wouldn't cause us
more problems in the long run.

> I'd be willing to write a helper, but I'm a bit out of my element here...
> can someone at least suggest a good place to put such a helper (or
> volunteer to mock one up for me)?

OK, I can do this: A simple one with either a blacklist (reject these
commands) or whitelist (only accept these commands) going by the first
command byte OK?

James


