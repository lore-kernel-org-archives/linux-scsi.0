From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 07 Apr 2010 13:29:02 -0500
Message-ID: <1270664942.8916.126.camel@mulgrave.site>
References: <Pine.LNX.4.44L0.1004021114160.1615-100000@iolanthe.rowland.org>
	 <4BB61237.5030000@ru.mvista.com> <1270223970.2899.80.camel@mulgrave.site>
	 <4BBCCA0D.3000708@teksavvy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:51652 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab0DGS3f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Apr 2010 14:29:35 -0400
In-Reply-To: <4BBCCA0D.3000708@teksavvy.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <kernel@teksavvy.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Alan Stern <stern@rowland.harvard.edu>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Kay Sievers <kay.sievers@vrfy.org>, Douglas Gilbert <dgilbert@interlog.com>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Mark Lord <liml@rtr.ca>

On Wed, 2010-04-07 at 14:08 -0400, Mark Lord wrote:
> On 02/04/10 11:59 AM, James Bottomley wrote:
> > On Fri, 2010-04-02 at 19:50 +0400, Sergei Shtylyov wrote:
> ..
> >>     IDENTIFY DEVICE command has *no* parameters.
> >
> > Alan was talking about ATA_16, which has to contain payload data in SCSI
> > format for the encapsulation to work, so for a command that returns 512b
> > the ATA_16 has to contain this as the data length.
> >
> > Sounds like a Mark Lord problem to me ... cc added.
> ..
> 
> Errr.. yes and no.
> 
> Yes, because nobody else is likely to do anything about it,
> so I will work around the hardware bug by updating hdparm.
> 
> But no, there's no funky missing data length issue there.
> Just a bridge chip that doesn't understand ATA_16 commands.
> 
> Apparently it *does* understand ATA_12 commands, though,
> so perhaps hdparm will simply use ATA_12 for IDENTIFY from now on.

Thanks, and welcome to my world ... the wierd antics of USB devices,
plus the way they throw their toys out of the pram the moment you don't
address them correctly is one of the banes of the SCSI subsystem.  In
general, the advice is to use the simplest possible command to achieve
what you want so ATA_12 rather than ATA_16 is one of those (because most
USB devices being below 2TB don't need to support 16 byte CDBs for
anything else, so it's obviously something they'd forget to implement or
test in their bridge chips ...).  One of the consolations is that we're
only on the edge ... people in the USB subsystem seem to have a much
worse time of it.

You can extrapolate from this that I'm so looking forward to UAS ...

James


