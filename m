From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 10:24:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068744259.13580.41.camel@patrh9>
References: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:58589 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264398AbTKMRY6
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 12:24:58 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311131200420.949-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > > Bear in mind that Windows apparently does not use these commands.
> > 
> > Rather, Windows either does not use the variations in these commands
> > that we have tried or else uses a different variation of reset that
> > works.
> 
> I don't see what this has to do with variations of reset.  The examples of
> USB traces from a Windows host that people have posted recently show no
> use of MODE-SENSE.

I missed these, help?

In linux-scsi, I saw Andries B post an offer to collect these, I saw
myself loosely quote an op x46 Get Configuration
fetch-header-fetch-available sequence, but I never saw any traces
appear?

> > > Is there any strong reason not to do this?
> > 
> > Have we yet begun to experiment with disks that we can write protect?
> 
> Not as far as I know.

I have write-protectable disks that mount via sd e.g. WinHEC Lexar
flash, Iomega Zip.  Got any experiments you want me to try?

> But the current code does make a provision for 
> devices that don't respond to MODE-SENSE for page 0x3f correctly; it 
> assumes they are read/write.

I trust you actually know.  Me, I remember thinking that.

> Similarly, devices that don't respond to 
> page 0x08 correctly are assumed to have a write-through cache.

"I trust you actually know.  Me, I remember thinking that."

> > We could blacklist just USB MSC CBI/CB, for example, thus fixing the
> > Sony without making connections, especially SG_IO connections, to USB
> > MSC BBB more opaque.
> 
> Why bother to do either?  There's no need to single out CBI/CB and there's 
> no need to make SG_IO at all opaque.  Just have the sd driver avoid 
> issuing the MODE-SENSE commands.

Glad to hear no opaque SG_IO.

Deciding writable or not when disc arrives, rather than when device
arrives, sounds good.

Breaking write protect that works sounds bad.  Does write protect ever
work?

> > > (And the read-write status can be adjusted, if necessary, when a WRITE
> > > command fails with Medium Error: Write Protected sense.)
> > 
> > Aye.  But will the layers above cope well with such a late error?  I've
> > seen dmesg spew when playing with mounting udf.ko writable on top of a
> > read-only disc.
> 
> Probably they won't cope well.  But they don't cope well with the sudden 
> removal of a hot-unpluggable device either.  They will need to be updated 
> to handle such problems.

Yes please.

Me, I want to learn how write protect works in Linux cdrom/sr/ide-cd
because I want my USB & ATAPI write-protectable Iomega RRD to work.

Anybody know a better way for me to learn than to try write-protectable
sd discs?

So far I'm deeply confused by the concept of a device writable or not.

To ignorant newbie me, only partitions of discs are writable or not.

> > I was just going to suggest that myself -- or rather, blacklist all 
> > > MODE-SENSE(x) commands from all USB disk-type devices.
> > 
> > We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink at
> > the same time we fix SCSI over USB, yes?
> 
> Are they broken?

Aye, in much the same way: nothing but Talk Like Windows actually works
well across a wide variety of devices.

I hear commercially available DVD/CD burning software actually resorts
to guessing behaviour by op x12 Inquiry String.  Some apps doesn't even
try to talk to an unrecognised device.  Friendlier apps gives you the
option of running a diagnostic to try to discover behaviour - you crash
or you hang or you profile the new device.

Traces tell me binary-code-only Windows XP/2K produces the first few cdb
after plug in independently by bus, but pretty early in life the
different forms of SCSI over whatever then share a common cdb author.

I'm guessing from nearly zero evidence, but as yet by guess is that the
DVD/CD driver tries politically correct speech e.g.
fetch-header-fetch-available, but the HDD/Flash driver tries a less
obvious legacy speech whose sole virtue is that it works.

Pat LaVarre


