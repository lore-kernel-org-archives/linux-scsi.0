From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Buggy Firewire bridge 'Prolific PL3507'
Date: Tue, 08 Jan 2008 12:10:47 -0600
Message-ID: <1199815847.3534.49.camel@localhost.localdomain>
References: <47837E06.5080406@novell.com>
	 <20080108140151.GD16309@parisc-linux.org>
	 <4783B93B.70307@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:60703 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752268AbYAHSKz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jan 2008 13:10:55 -0500
In-Reply-To: <4783B93B.70307@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Matthew Wilcox <matthew@wil.cx>, Hannes Reinecke <hare@novell.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, David Zeuthen <david@fubar.dk>

On Tue, 2008-01-08 at 18:56 +0100, Stefan Richter wrote:
> Matthew Wilcox wrote:
> > On Tue, Jan 08, 2008 at 02:43:34PM +0100, Hannes Reinecke wrote:
> >> I have here a buggy firewire bridge (Prolific PL3507) which requires
> >> that each 'INQUIRY' command is followed by a 'READ CAPACITY' command.
> >> Otherwise any read will return invalid data (the payload is preceded
> >> by 36 empty bytes).
> >> 
> >> How to fix this? Sure one could add a hack to sbp2.c to always issue
> >> a READ CAPACITY after INQUIRY, but this somehow feels wrong ...
> > 
> > There's only one place in the scsi stack that issues INQUIRY --
> > scsi_scan.c [1].  sd is going to issue READ CAPACITY before it issues
> > any READ commands, so I don't see where you're having this problem.
> > Is it with some program issuing INQUIRY through SG_IO or something?
> 
> It's hald or something like that.

Not to hijack the thread, but this is getting to be a broken record.  I
was dealing only a few days ago with a camera presenting as a mass
storage device that was then crashing and going offline.  I looked at
the dmesg trace which showed that the SCSI layer completes its probing
successfully, and said it was some other extraneous command issued from
user level causing the crash.  Sure enough, stopping hald fixed the
camera so it functioned as a mass storage device properly.  The bug
report is here:

https://bugs.launchpad.net/ubuntu/+source/hal/+bug/180472

What is the point of having SCSI be so careful in its probing and setup
so as not to annoy these devices, and then have hald or another standard
component blithely go and wreck the device by issuing unwarranted SCSI
commands?

Can we please stop hald from issuing SCSI commands ... we should have
the infrastructure in place now that renders this unnecessary ... unless
there's still some information it needs that we're not providing?

James


