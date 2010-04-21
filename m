From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: System hangs when using USB 3.0 HD with on Ubuntu
Date: Wed, 21 Apr 2010 10:22:08 -0400
Message-ID: <1271859728.2893.72.camel@mulgrave.site>
References: <593030.61801.qm@web31804.mail.mud.yahoo.com>
	 <4BCF0310.4000906@pobox.com> <1271858694.2893.47.camel@mulgrave.site>
	 <4BCF0819.7090405@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:34555 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440Ab0DUOWO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Apr 2010 10:22:14 -0400
In-Reply-To: <4BCF0819.7090405@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <mlord@pobox.com>
Cc: ltuikov@yahoo.com, Alan Stern <stern@rowland.harvard.edu>, Sarah Sharp <sarah.a.sharp@linux.intel.com>, Jonas Schwertfeger <jschwertfeger@gmail.com>, Dinh.Nguyen@freescale.com, Sergei Shtylyov <sshtylyov@mvista.com>, Kay Sievers <kay.sievers@vrfy.org>, David Zeuthen <david@fubar.dk>, linux-hotplug@vger.kernel.org, linux-usb@vger.kernel.org, USB Storage List <usb-storage@lists.one-eyed-alien.net>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, linux-scsi@vger.kernel.org, Lennart Poettering <lennart@poettering.net>, Douglas Gilbert <dgilbert@interlog.com>

On Wed, 2010-04-21 at 10:13 -0400, Mark Lord wrote:
> On 21/04/10 10:04 AM, James Bottomley wrote:
> ..
> > But this isn't a userspace problem.  By the time we present the device
> > to userspace, we already know what it is ... so you can go by device
> > type and only use ATA_12 for disk devices.
> ..
> 
> And most tools / programs can indeed do that.
> 
> But hdparm's mission is to ignore what the kernel thinks,
> and speak directly to the drive whenever possible.

This is a bit dangerous where USB is concerned.  We certainly don't have
all the heuristics necessary in the kernel, but whenever anything goes
wrong, we do tend to hear about it pretty quickly.

> Because hdparm is an important part of how we verify
> that the kernel is correct (or not).  So I very much
> prefer that it continue to work out the details as much
> as it can without asking a possibly buggy kernel for help.
> 
> :)
> 
> That said.. what would you recommend as a way for a userspace
> program to figure out whether to use ATA_12 or ATA_16 to talk
> to a given arbitrary device name ?

To be honest, no.  For USB, All USB is SCSI or RBC command based. You
don't have any idea whether it's a real SCSI device or an ATA device
behind a SAT  ... the only reason you assume it's ATA is because USB
gadget builders tend to be cheapskates.

> I guess the info is in sysfs somewhere.

Only for direct interconnects.  For USB most bets are off.

James


