From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mptsas problem
Date: Sun, 13 Apr 2008 09:39:55 -0500
Message-ID: <1208097595.4707.24.camel@localhost.localdomain>
References: <47F95F5C.500@sauce.co.nz> <20080407010453.GA1952@animx.eu.org>
	 <480203FB.7070105@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40316 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752030AbYDMOj7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 13 Apr 2008 10:39:59 -0400
In-Reply-To: <480203FB.7070105@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Wakko Warner <wakko@animx.eu.org>, Richard Scobie <richard@sauce.co.nz>, linux-scsi@vger.kernel.org

On Sun, 2008-04-13 at 23:00 +1000, Douglas Gilbert wrote:
> Wakko Warner wrote:
> > Richard Scobie wrote:
> >>> I recall seeing some of this problem on the list a few days ago, but 
> >> I > can't remember what the subject was and was unable to find the thread.
> >>
> >> You are perhaps thinking of this:
> >>
> >> http://marc.info/?l=linux-scsi&m=120696978819085&w=2
> > 
> > Yes.
> > 
> >> but it seems to be a different issue.
> > 
> > Ok.
> > 
> >> From the message you posted, it looks as though there may be a problem 
> >> with sda.
> > 
> > It's working fine with /sys/block/sd[abc]/device/queue_depth = 1 (on boot up,
> > as stated before, it's 64)
> > 
> > I performed the same copy again with queue_depth=1 after the array rebuilt.
> > It worked fine then.  No errors.
> > 
> >> Does smartctl -a -d ata /dev/sda show any obvious problems?
> > 
> > smartctl doesn't work on sd[a-d] at all:
> > # smartctl -a -d ata /dev/sdd
> > smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> > Home page is http://smartmontools.sourceforge.net/
> > 
> > Smartctl: Device Read Identity Failed (not an ATA/ATAPI device)
> > 
> > A mandatory SMART command failed: exiting. To continue, add one or more '-T
> > permissive' options.
> > # smartctl -a -d ata -T permissive /dev/sdd
> 
> As a smartmontools developer I know that '-d ata' is
> incorrect in this context. The 'd <command_set> should
> either not be given or '-d sat' should be given.
> 
> This is difficult to explain and hence put in an easily
> understood option. As far as linux is concerned SCSI
> commands are being issued to a SCSI device (on a SCSI
> transport). But those SCSI commands are mostly instances
> of the SCSI ATA PASS-THROUGH command.

This is really what you need to use, although implementation of ATA_12
and ATA_16, which are the prescribed taskfile carriers is also done in
the SAT layer.

> It is further complicated by the fact that a properly
> implemented SAT layer (and I have never met one)
> implements the SCSI commands used for SMART support.
> If that was the case 'smartctl -a -d scsi /dev/sdd' would
> yield useful output which would be a subset of what 'd sat'
> would yield.

The problem with this, of course, is that the SCSI stats are less
comprehensive than the ATA SMART ones, so it's usually better to use the
pass through commands if you know you're dealling with an ATA device.

Actually, I'm afraid it's even more complex than this:  libata has a SAT
layer for all SATA devices it attaches to; libsas also uses this, so
you'd think that we only have one SAT layer in Linux.  Unfortunately,
mptsas and other "smart" SAS cards actually implement their own SAT
layer in the firmware which bypasses the linux one.  

The Linux one definitely doesn't implement the smart piece of the SAT
spec; I'm not at all sure about the various firmware ones.

> Clear as mud?

Not quite ... but hopefully I've stirred it enough ...

James


