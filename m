From: Linus Torvalds <torvalds@transmeta.com>
Subject: Re: PATCH: exclude certain commands from emulated SCSI hosts
Date: Sat, 22 Mar 2003 20:09:57 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0303222005520.29393-100000@home.transmeta.com>
References: <20030322193705.C17056@one-eyed-alien.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <20030322193705.C17056@one-eyed-alien.net>
List-Id: linux-scsi@vger.kernel.org
To: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Cc: USB Developers <linux-usb-devel@lists.sourceforge.net>, USB Storage List <usb-storage@one-eyed-alien.net>, Linux SCSI list <linux-scsi@vger.kernel.org>


On Sat, 22 Mar 2003, Matthew Dharm wrote:
>
> This patch changes how devices a probed on a SCSI bus if they are on an
> emulated host.

I really think this is wrong. I'd much much rather get _rid_ of that 
stupid "emulated" flag, instead of adding meaning to it.

> If a host is emulated, we (a) don't ask for EVPD data, as it's likely not
> there, (b) assume that we have only 36-bytes of INQUIRY data, and (c) don't
> ask disks for their cache-type (assume write-through).

..and thus anything that wants to emulate SCSI has to never be able to be
write-back again.

Now, I'd say that it is stupid to call yourself a SCSI disk if you aren't 
one _anyway_ (the raw block device interfaces are simpler and faster), but 
if you do, then I think it's doubly stupid to put in arbitrary 
restrictions like this.

If there are known commands that devices have trouble with (whether 
emulated or not), maybe we could have helper routines to do some default 
filtering, and have the queuecommand function check those. But this just 
looks ugly and hacky to me.

		Linus

