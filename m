From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass larger
 receive buffer
Date: Thu, 13 Nov 2003 12:09:55 -0500 (EST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
References: <1068740496.13580.5.camel@patrh9>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:45828 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S264375AbTKMRJz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 12:09:55 -0500
In-Reply-To: <1068740496.13580.5.camel@patrh9>
List-Id: linux-scsi@vger.kernel.org
To: Pat LaVarre <p.lavarre@ieee.org>
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

On 13 Nov 2003, Pat LaVarre wrote:

> > I was just going to suggest that myself -- or rather, blacklist all 
> > MODE-SENSE(x) commands from all USB disk-type devices.
> 
> We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink at
> the same time we fix SCSI over USB, yes?

Are they broken?

> > Is there any strong reason not to do this?
> 
> Have we yet begun to experiment with disks that we can write protect?

Not as far as I know.  But the current code does make a provision for 
devices that don't respond to MODE-SENSE for page 0x3f correctly; it 
assumes they are read/write.  Similarly, devices that don't respond to 
page 0x08 correctly are assumed to have a write-through cache.

> > Bear in mind that Windows apparently does not use these commands.
> 
> Rather, Windows either does not use the variations in these commands
> that we have tried or else uses a different variation of reset that
> works.

I don't see what this has to do with variations of reset.  The examples of
USB traces from a Windows host that people have posted recently show no
use of MODE-SENSE.

> We could blacklist just USB MSC CBI/CB, for example, thus fixing the
> Sony without making connections, especially SG_IO connections, to USB
> MSC BBB more opaque.

Why bother to do either?  There's no need to single out CBI/CB and there's 
no need to make SG_IO at all opaque.  Just have the sd driver avoid 
issuing the MODE-SENSE commands.

> > (And the read-write status can be adjusted, if necessary, when a WRITE
> > command fails with Medium Error: Write Protected sense.)
> 
> Aye.  But will the layers above cope well with such a late error?  I've
> seen dmesg spew when playing with mounting udf.ko writable on top of a
> read-only disc.

Probably they won't cope well.  But they don't cope well with the sudden 
removal of a hot-unpluggable device either.  They will need to be updated 
to handle such problems.

Alan Stern

