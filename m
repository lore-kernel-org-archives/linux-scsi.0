From: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Subject: Re: [PATCH 1/1] cciss: use timeout to ensure scan thread exits
Date: Tue, 16 Jun 2009 16:56:24 -0500
Message-ID: <20090616215624.GB29502@beardog.cca.cpqcorp.net>
References: <20090616204325.GA29502@beardog.cca.cpqcorp.net> <20090616141007.9b3852e7.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:14392 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895AbZFPV4A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Jun 2009 17:56:00 -0400
Content-Disposition: inline
In-Reply-To: <20090616141007.9b3852e7.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jens.axboe@oracle.com, james.bottomley@hansenpartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Tue, Jun 16, 2009 at 02:10:07PM -0700, Andrew Morton wrote:
> On Tue, 16 Jun 2009 15:43:25 -0500
> "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:
> 
> > Patch 1 of 1
> > 
> > This patch implements wait_for_completion_interruptible_timeout in the
> > scan_thread function to ensure it will exit cleanly during rmmod. Calling
> > complete in cciss_remove_one caused a race condition. Using the wait with a
> > timeout seems to work around that but it does fire the thread. The overhead
> > should be minimal.
> > 
> > Changelog:
> > Replace wait_for_completion_interruptible with
> > wait_for_completion_interruptible_timeout in scan_thread().
> > Use 5 second timeout value to avoid race.
> > 
> > Signed-off-by: Mike Miller
> > 
> > diff --git a/drivers/block/cciss.c b/drivers/block/cciss.c
> > index 4d4d5e0..76e7c10 100644
> > --- a/drivers/block/cciss.c
> > +++ b/drivers/block/cciss.c
> > @@ -3043,7 +3043,7 @@ static int scan_thread(void *data)
> >  	h->rescan_wait = &wait;
> >  
> >  	for (;;) {
> > -		rc = wait_for_completion_interruptible(&wait);
> > +		rc = wait_for_completion_interruptible_timeout(&wait, 5);
> >  		if (kthread_should_stop())
> >  			break;
> >  		if (!rc)
> 
> c'mon Mike, that's a hack.

I'm open to suggestions. Calling complete in cciss_remove_one does not
resolve the issue. Other things I've tried may work once or twice but always
results in the hang.
Something I noticed in the trace was 2 calls to rebuild_lun_table when
trying to rmmod. Then it would get into the scheduler and just hang. During
rmmod I don't want to call rebuild_lun_table, just kill the thread and exit.

Ideas, suggestions, flames? Anyone???? 

-- mikem
