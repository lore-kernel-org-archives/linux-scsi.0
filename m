From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 17:44:08 -0800 (PST)
Message-ID: <20081106014408.2FE9211D10A@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43288 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752334AbYKFBol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Nov 2008 20:44:41 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA61i8Fa027678
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 17:44:09 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #22 from yanmin_zhang@linux.intel.com  2008-11-05 17:44 -------
(In reply to comment #19)
> Reply-To: James.Bottomley@HansenPartnership.com
> 
> On Tue, 2008-11-04 at 20:01 -0800, bugme-daemon@bugzilla.kernel.org
> wrote:
> > http://bugzilla.kernel.org/show_bug.cgi?id=11898
> > 
> > 
> > 
> > 
> > 
> > ------- Comment #15 from alex.shi@intel.com  2008-11-04 20:01 -------
> > the fix is right. and "sdev == starved_head" does not need according code
> > context. so the following patch works too.
> > 
> > --- scsi_lib.c.orig     2008-11-04 13:07:16.000000000 -0800
> > +++ scsi_lib.c  2008-11-04 13:07:38.000000000 -0800
> > @@ -607,6 +607,8 @@
> >                 spin_unlock(sdev->request_queue->queue_lock);
> > 
> >                 spin_lock(shost->host_lock);
> > +               if (list_empty(&sdev->starved_entry) ) 
> > +                       starved_head = NULL; 
> >         }
> >         spin_unlock_irqrestore(shost->host_lock, flags);
> 
> Actually, no.  The correct patch is below.
> 
> The reason for doing it like this is so that if someone slices the loop
> apart again (which is how this crept in) they won't get a continue or
> something which allows this to happen.
> 
> It shouldn't be conditional on the starved list (or anything else)
> because it's probably a register and should happen at the same point as
> the list deletion but before we drop the problem lock (because once we
> drop that lock we'll need to recompute starvation).
> 
> James
> 
> ---
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f5d3b96..f9a531f 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
>                 }
> 
>                 list_del_init(&sdev->starved_entry);
> +               starved_entry = NULL;
>                 spin_unlock(shost->host_lock);
> 
>                 spin_lock(sdev->request_queue->queue_lock);
> 

It looks like you still don't understand the scenario.

I did a quick testing with your patch. kernel just hangs after booting, before
I start mkfs.ext2.

Consider below scenario: the scsi target isn't busy, but
"if (blk_queue_tagged(q) && !blk_rq_tagged(req))" is true in function
scsi_request_fn, the sdev will be added back to starved_list. But with your
patch, starved_head is reset to NULL to lose his purpose. So although there is
only one sdev in starved_list, function scsi_run_queue enters a dead loop.


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
