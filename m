From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [usb-storage] Re: [PATCH] fix Sony USB mass storage - pass
	larger receive buffer
Date: 13 Nov 2003 09:21:36 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1068740496.13580.5.camel@patrh9>
References: <Pine.LNX.4.44L0.0311130950090.843-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:34517 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S264331AbTKMQWQ
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 13 Nov 2003 11:22:16 -0500
In-Reply-To: <Pine.LNX.4.44L0.0311130950090.843-100000@ida.rowland.org>
List-Id: linux-scsi@vger.kernel.org
To: stern@rowland.harvard.edu
Cc: mdharm-scsi@one-eyed-alien.net, patmans@us.ibm.com, james.bottomley@steeleye.com, linux-scsi@vger.kernel.org, usb-storage@one-eyed-alien.net, ronald@kuetemeier.com, dmitrik@users.sourceforge.net, idan@idanso.dyndns.org

> > I'm starting to think that this may be the best solution --
> > blacklist all MODE_SENSE[_10] commands from all Direct-Access
> > devices.
> 
> I was just going to suggest that myself -- or rather, blacklist all 
> MODE-SENSE(x) commands from all USB disk-type devices.

We may as well fix SCSI over IDE and SCSI over 1394/FireWire/iLink at
the same time we fix SCSI over USB, yes?

> Is there any strong reason not to do this?

Have we yet begun to experiment with disks that we can write protect?

> Bear in mind that Windows apparently does not use these commands.

Rather, Windows either does not use the variations in these commands
that we have tried or else uses a different variation of reset that
works.

We could blacklist just USB MSC CBI/CB, for example, thus fixing the
Sony without making connections, especially SG_IO connections, to USB
MSC BBB more opaque.

> I don't see how not knowing the true read-write status or caching type
> will hurt anything.

Anybody know why Jens Axboe so vehemently rejected my suggestion that
that we teach cdrom.ko and sr_mod.ko to pass writes thru to all PDT x05
DVD/CD?

> (And the read-write status can be adjusted, if necessary, when a WRITE
> command fails with Medium Error: Write Protected sense.)

Aye.  But will the layers above cope well with such a late error?  I've
seen dmesg spew when playing with mounting udf.ko writable on top of a
read-only disc.

Pat LaVarre


