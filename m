From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 9674] New: Oops during rmmod'ing modeuls
	sdhci, sr_mod, ricoh_mmc, mmc_core
Date: Tue, 01 Jan 2008 21:24:43 -0600
Message-ID: <1199244283.3252.13.camel@localhost.localdomain>
References: <bug-9674-10286@http.bugzilla.kernel.org/>
	 <20080101181026.38298e13.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:51394 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753648AbYABDYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jan 2008 22:24:50 -0500
In-Reply-To: <20080101181026.38298e13.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, bugme-daemon@bugzilla.kernel.org, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>


On Tue, 2008-01-01 at 18:10 -0800, Andrew Morton wrote:
> On Tue,  1 Jan 2008 14:55:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> 
> > http://bugzilla.kernel.org/show_bug.cgi?id=9674
> > 
> >            Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
> >                     mmc_core
> 
> Guys, this is a very recent regression.  Could you please take a look, see
> if it's due to mmc, block or scsi changes?

There's not a lot of information to go on.  The stack trace looks bogus,
so I guess the kernel is compiled without a frame pointer.  However, it
does look like the initial insertion of sr_mod is going through and it
generates a command which gets into scsi_request_fn and then indirects
through a bogus queueucommand pointer.

What's the actual underlying device the cdrom is attached to?

There's no real changes to SCSI in this area from 2.6.24-rc4 ...
however, the reinsertion is suggestive, it's like the removal is
retriggering a module request for some reason.

James


