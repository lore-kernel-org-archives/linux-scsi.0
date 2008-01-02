From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [Bugme-new] [Bug 9674] New: Oops during rmmod'ing modeuls
	sdhci, sr_mod, ricoh_mmc, mmc_core
Date: Wed, 02 Jan 2008 10:33:45 -0600
Message-ID: <1199291625.3258.21.camel@localhost.localdomain>
References: <bug-9674-10286@http.bugzilla.kernel.org/>
	 <20080101181026.38298e13.akpm@linux-foundation.org>
	 <1199244283.3252.13.camel@localhost.localdomain>
	 <20080102154951.GA8976@osc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:35575 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753493AbYABQdz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jan 2008 11:33:55 -0500
In-Reply-To: <20080102154951.GA8976@osc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Pete Wyckoff <pw@osc.edu>
Cc: Andrew Morton <akpm@linux-foundation.org>, "Rafael J. Wysocki" <rjw@sisk.pl>, Pierre Ossman <drzeus@drzeus.cx>, Jens Axboe <jens.axboe@oracle.com>, bugme-daemon@bugzilla.kernel.org, gentuu@gmail.com, linux-scsi <linux-scsi@vger.kernel.org>


On Wed, 2008-01-02 at 10:49 -0500, Pete Wyckoff wrote:
> James.Bottomley@HansenPartnership.com wrote on Tue, 01 Jan 2008 21:24 -0600:
> > 
> > On Tue, 2008-01-01 at 18:10 -0800, Andrew Morton wrote:
> > > On Tue,  1 Jan 2008 14:55:45 -0800 (PST) bugme-daemon@bugzilla.kernel.org wrote:
> > > 
> > > > http://bugzilla.kernel.org/show_bug.cgi?id=9674
> > > > 
> > > >            Summary: Oops during rmmod'ing modeuls sdhci, sr_mod, ricoh_mmc,
> > > >                     mmc_core
> > > 
> > > Guys, this is a very recent regression.  Could you please take a look, see
> > > if it's due to mmc, block or scsi changes?
> > 
> > There's not a lot of information to go on.  The stack trace looks bogus,
> > so I guess the kernel is compiled without a frame pointer.  However, it
> > does look like the initial insertion of sr_mod is going through and it
> > generates a command which gets into scsi_request_fn and then indirects
> > through a bogus queueucommand pointer.
> 
> Bogus prep_rq_fn actually.
> 
> > What's the actual underlying device the cdrom is attached to?
> > 
> > There's no real changes to SCSI in this area from 2.6.24-rc4 ...
> > however, the reinsertion is suggestive, it's like the removal is
> > retriggering a module request for some reason.
> 
> Here's a guess.  When sr_mod is removed, it looks like the request
> queue prep_rq_fn is still pointing to the now nonexistent
> sr_prep_fn.  This may have been due to a commit that went in early
> 2.6.24:
> 
>     commit 7f9a6bc4e9d59e7fcf03ed23f60cd81ca5d80b65
>     Author: James Bottomley <James.Bottomley@steeleye.com>
>     Date:   Sat Aug 4 10:06:25 2007 -0500
> 
>     [SCSI] move ULD attachment into the prep function
>     
>     One of the intents of the block prep function was to allow ULDs to use
>     it for preprocessing.  The original SCSI model was to have a single prep
>     function and add a pointer indirect filter to build the necessary
>     commands.  This patch reverses that, does away with the init_command
>     field of the scsi_driver structure and makes ULDs attach directly to the
>     prep function instead.  The value is really that it allows us to begin
>     to separate the ULDs from the SCSI mid layer (as long as they don't use
>     any core functions---which is hard at the moment---a ULD doesn't even
>     need SCSI to bind).
>     
>     Acked-by: Jens Axboe <jens.axboe@oracle.com>
>     Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>
> 
> When the module is re-inserted, it does a few SCSI commands before
> setting up the new prep_rq_fn, presumably hitting this bogus
> pointer.
> 
> One fix would be to have sr remember the original prep function and
> restore it in sr_kref_release.  Sd and a few other drivers have this
> issue.  Ide-cd bothers to set prep_rq_fn to NULL as it releases
> the device.

Bingo .. that's why we ask the list, thanks Pete!

I don't think the fix is the correct one, but I've attached what I think
is the correct fix (basically, there's a bus callback we can use to
ensure the right thing always gets done rather than relying on drivers
doing it in their own release methods, that way they can't forget).

The reason it was showing up in -rc4 I suspect is because something was
structurally altering the module stack, and the address that sr_mod was
loaded was changed, so the prep_fn as Pete said was pointing into bogus
address space.

The way to trigger this bug 100% of the time is to rmmod sr_mod and then
send an inquiry (or another command) to the device using the sg node.

James

---

Index: BUILD-2.6/drivers/scsi/scsi_lib.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_lib.c	2008-01-01 10:13:33.000000000 -0600
+++ BUILD-2.6/drivers/scsi/scsi_lib.c	2008-01-02 10:17:51.000000000 -0600
@@ -1324,7 +1324,7 @@ int scsi_prep_return(struct request_queu
 }
 EXPORT_SYMBOL(scsi_prep_return);
 
-static int scsi_prep_fn(struct request_queue *q, struct request *req)
+int scsi_prep_fn(struct request_queue *q, struct request *req)
 {
 	struct scsi_device *sdev = q->queuedata;
 	int ret = BLKPREP_KILL;
Index: BUILD-2.6/drivers/scsi/scsi_priv.h
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_priv.h	2007-11-03 09:08:46.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_priv.h	2008-01-02 10:20:09.000000000 -0600
@@ -74,6 +74,9 @@ extern struct request_queue *scsi_alloc_
 extern void scsi_free_queue(struct request_queue *q);
 extern int scsi_init_queue(void);
 extern void scsi_exit_queue(void);
+struct request_queue;
+struct request;
+extern int scsi_prep_fn(struct request_queue *, struct request *);
 
 /* scsi_proc.c */
 #ifdef CONFIG_SCSI_PROC_FS
Index: BUILD-2.6/drivers/scsi/scsi_sysfs.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/scsi_sysfs.c	2007-11-03 10:08:02.000000000 -0500
+++ BUILD-2.6/drivers/scsi/scsi_sysfs.c	2008-01-02 10:31:33.000000000 -0600
@@ -373,12 +373,24 @@ static int scsi_bus_resume(struct device
 	return err;
 }
 
+static int scsi_bus_remove(struct device *dev)
+{
+	struct scsi_device *sdev = to_scsi_device(dev);
+
+	/* reset the prep_fn back to the default since the
+	 * driver may have altered it and it's being removed */
+	blk_queue_prep_rq(sdev->request_queue, scsi_prep_fn);
+
+	return 0;
+}
+
 struct bus_type scsi_bus_type = {
         .name		= "scsi",
         .match		= scsi_bus_match,
 	.uevent		= scsi_bus_uevent,
 	.suspend	= scsi_bus_suspend,
 	.resume		= scsi_bus_resume,
+	.remove		= scsi_bus_remove,
 };
 
 int scsi_sysfs_register(void)


