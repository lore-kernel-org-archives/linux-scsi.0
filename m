From: bugme-daemon@bugzilla.kernel.org
Subject: [Bug 11898] mke2fs hang on AIC79 device.
Date: Wed,  5 Nov 2008 10:47:02 -0800 (PST)
Message-ID: <20081105184702.CB07711D10C@picon.linux-foundation.org>
References: <bug-11898-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50271 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752613AbYKESrb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 5 Nov 2008 13:47:31 -0500
Received: from picon.linux-foundation.org (picon.linux-foundation.org [140.211.169.79])
	by smtp1.linux-foundation.org (8.14.2/8.13.5/Debian-3ubuntu1.1) with ESMTP id mA5Il2Tp032221
	for <linux-scsi@vger.kernel.org>; Wed, 5 Nov 2008 10:47:03 -0800
In-Reply-To: <bug-11898-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=11898





------- Comment #21 from anonymous@kernel-bugs.osdl.org  2008-11-05 10:47 -------
Reply-To: James.Bottomley@HansenPartnership.com

On Wed, 2008-11-05 at 11:25 -0600, Mike Christie wrote:
> James Bottomley wrote:
> > The reason for doing it like this is so that if someone slices the loop
> > apart again (which is how this crept in) they won't get a continue or
> > something which allows this to happen.
> > 
> > It shouldn't be conditional on the starved list (or anything else)
> > because it's probably a register and should happen at the same point as
> > the list deletion but before we drop the problem lock (because once we
> > drop that lock we'll need to recompute starvation).
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index f5d3b96..f9a531f 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -606,6 +606,7 @@ static void scsi_run_queue(struct request_queue *q)
> >  		}
> >  
> >  		list_del_init(&sdev->starved_entry);
> > +		starved_entry = NULL;
> 
> Should this be starved_head?

Yes, sorry, constructed patch on 'plane and didn't compile it.

> >  		spin_unlock(shost->host_lock);
> >  
> >  		spin_lock(sdev->request_queue->queue_lock);
> > 
> 
> Do you think we can just splice the list like the attached patch (patch 
> is example only and is not tested)?

Afraid not ... you could still get a starved_head that's no longer
current (it gets tagged as starved_head then removed from the spliced
starved_list and then continued lower down) which would still cause the
endless loop.

> I thought the code is clearer, but I think it may be less efficient. If 
> scsi_run_queue is run on multiple processors then with the attached 
> patch one processor would splice the list and possibly have to execute 
> __blk_run_queue for all the devices on the list serially.
> 
> Currently we can at least prep the devices in parallel. One processor 
> would grab one entry on the list and drop the host lock, so then another 
> processor could grab another entry on the list and start the execution 
> process (I wrote start the process because it might turn out that this 
> second entry execution might have to wait on the first one when the scsi 
> layer has to grab the queue lock again).

James


-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are the assignee for the bug, or are watching the assignee.
