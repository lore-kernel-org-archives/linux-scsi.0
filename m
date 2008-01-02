From: Pete Wyckoff <pw@osc.edu>
Subject: Re: [Bugme-new] [Bug 9674] New: Oops during rmmod'ing modeuls
	sdhci, sr_mod, ricoh_mmc, mmc_core
Date: Wed, 2 Jan 2008 10:49:51 -0500
Message-ID: <20080102154951.GA8976@osc.edu>
References: <bug-9674-10286@http.bugzilla.kernel.org/> <20080101181026.38298e13.akpm@linux-foundation.org> <1199244283.3252.13.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from quasar.osc.edu ([192.148.249.15]:47941 "EHLO quasar.osc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753537AbYABPtx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Jan 2008 10:49:53 -0500
Content-Disposition: inline
In-Reply-To: <1199244283.3252.13.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, bugme-daemon@bugzilla.kernel.org, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>

James.Bottomley@HansenPartnership.com wrote on Tue, 01 Jan 2008 21:24 -0600:
> 
> On Tue, 2008-01-01 at 18:10 -0800, Andrew Morton wrote:
> > On Tue,  1 Jan 2008 14:55:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > 
> > > http://bugzilla.kernel.org/show_bug.cgi?id=9674
> > > 
> > >            Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
> > >                     mmc_core
> > 
> > Guys, this is a very recent regression.  Could you please take a look, see
> > if it's due to mmc, block or scsi changes?
> 
> There's not a lot of information to go on.  The stack trace looks bogus,
> so I guess the kernel is compiled without a frame pointer.  However, it
> does look like the initial insertion of sr_mod is going through and it
> generates a command which gets into scsi_request_fn and then indirects
> through a bogus queueucommand pointer.

Bogus prep_rq_fn actually.

> What's the actual underlying device the cdrom is attached to?
> 
> There's no real changes to SCSI in this area from 2.6.24-rc4 ...
> however, the reinsertion is suggestive, it's like the removal is
> retriggering a module request for some reason.

Here's a guess.  When sr_mod is removed, it looks like the request
queue prep_rq_fn is still pointing to the now nonexistent
sr_prep_fn.  This may have been due to a commit that went in early
2.6.24:

    commit 7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65
    Author: James Bottomley <James.Bottomley@steeleye.com>
    Date:   Sat Aug 4 10:06:25 2007 -0500

    [SCSI] move ULD attachment into the prep function
    
    One of the intents of the block prep function was to allow ULDs to use
    it for preprocessing.  The original SCSI model was to have a single prep
    function and add a pointer indirect filter to build the necessary
    commands.  This patch reverses that, does away with the init_command
    field of the scsi_driver structure and makes ULDs attach directly to the
    prep function instead.  The value is really that it allows us to begin
    to separate the ULDs from the SCSI mid layer (as long as they don't use
    any core functions---which is hard at the moment---a ULD doesn't even
    need SCSI to bind).
    
    Acked-by: Jens Axboe <jens.axboe@oracle.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

When the module is re-inserted, it does a few SCSI commands before
setting up the new prep_rq_fn, presumably hitting this bogus
pointer.

One fix would be to have sr remember the original prep function and
restore it in sr_kref_release.  Sd and a few other drivers have this
issue.  Ide-cd bothers to set prep_rq_fn to NULL as it releases
the device.

		-- Pete
