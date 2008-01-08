From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 18:56:11 +0100
Message-ID: <4783B93B.70307@s5r6.in-berlin.de>
References: <47837E06.5080406@novell.com> <20080108140151.GD16309@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:32793 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517AbYAHR5L (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 12:57:11 -0500
In-Reply-To: <20080108140151.GD16309@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Matthew Wilcox wrote:
> On Tue, Jan 08, 2008 at 02:43:34PM +0100, Hannes Reinecke wrote:
>> I have here a buggy firewire bridge (Prolific PL3507) which requires
>> that each 'INQUIRY' command is followed by a 'READ CAPACITY' command.
>> Otherwise any read will return invalid data (the payload is preceded
>> by 36 empty bytes).
>> 
>> How to fix this? Sure one could add a hack to sbp2.c to always issue
>> a READ CAPACITY after INQUIRY, but this somehow feels wrong ...
> 
> There's only one place in the scsi stack that issues INQUIRY --
> scsi_scan.c [1].  sd is going to issue READ CAPACITY before it issues
> any READ commands, so I don't see where you're having this problem.
> Is it with some program issuing INQUIRY through SG_IO or something?

It's hald or something like that.

> I have a hard time thinking this needs to be handled generically
> because READ CAPACITY isn't in the Primary Command Set, unlike INQUIRY.
> It's mandatory for SBC devices to implement it, but other devices
> shouldn't even implement it.

It is also mandatory in RBC, which most SBP-2 to IDE or SBP-2 to SATA
bridges implement (besides MMC, if a CD/DVD-ROM/R/W is attached).

> My opinion is that it needs to be handled either in the application
> issuing sg commands or in sbp2.
> 
> [1] yes, there are others, such as drivers and scsi_transport_spi, but
> none relevant to sbp2.
> 

Hannes, first check whether the PL3507 is of a variant which can be
fixed by firmware upload.  You need a Windows PC with USB to check
whether firmware can be uploaded, and if yes, to upload a firmware
image.  Have a look at http://wiki.linux1394.org/FirmwareDownload .

If this is not possible, ask the vendor of the device for replacement.
It is defective after all.

That said, maybe you can convince the maintainers of whatever userspace
program issues the second INQUIRY to be extra careful with buggy PL3507
firmwares.  Or deactivate that program.

I would not at all like to see a respective workaround added to the sbp2
driver.  Sbp2 is a transport layer which does not touch commands.  Maybe
an in-kernel workaround would be considered by whoever maintains the
point where that extra INQUIRY is injected (via sd or sg, I don't know
which).
-- 
Stefan Richter
-=====-==--- ---= -=---
http://arcgraph.de/sr/
