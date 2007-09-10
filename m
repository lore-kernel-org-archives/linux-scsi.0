From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: 2.6.22 oops kernel BUG at block/elevator.c:366!
Date: Mon, 10 Sep 2007 02:17:48 -0700
Message-ID: <20070910021748.f728c242.akpm@linux-foundation.org>
References: <200708291950.14513.arekm@maven.pl>
	<200708292011.47134.arekm@maven.pl>
	<20070829181648.GD7932@kernel.dk>
	<200708301329.37396.arekm@maven.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:60457 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750849AbXIJJSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 10 Sep 2007 05:18:25 -0400
In-Reply-To: <200708301329.37396.arekm@maven.pl>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arkadiusz Miskiewicz <arekm@maven.pl>
Cc: Jens Axboe <jens.axboe@oracle.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Ed Lin <ed.lin@promise.com>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>

On Thu, 30 Aug 2007 13:29:37 +0200 Arkadiusz Miskiewicz <arekm@maven.pl> wrote:

> On Wednesday 29 of August 2007, Jens Axboe wrote:
> > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > > On Wednesday 29 of August 2007, Jens Axboe wrote:
> > > > > > On Wed, Aug 29 2007, Arkadiusz Miskiewicz wrote:
> > > > > > > I guess I should sent these here since it looks like not scsi bug
> > > > > > > anyway.
> > > > > >
> > > > > > It's stex, right? It seems to have some issues with multiple
> > > > > > completions of commands, which craps out the block layer of course.
> > > > >
> > > > > Yes, stex. I'm staying with 2.6.19 in that case since it works fine
> > > > > in that version.
> > > > >
> > > > > So scsi bug ... 8-)
> > > >
> > > > And you based that conclusion on what exactly?

Could be viewed as a scsi deficiency at least.  Is it unheard of for
"independent" queues to have shared resources?  If so, then yeah, perhaps
some driver-private locking as James suggested is appropriate.  But if
other drivers face similar problems then perhaps it is something which scsi
core should offer support for.

But whatever.  The situation is that Ed suggested a fix eight months ago,
James suggested enhancements and afaict nobody did anything more, and
machines which use this driver are still crashing.

<checks>

OK, Ed's email client breaks message threading, so you need to hyperjump to
a "different" thread a few days later, in which Ed points out that qla4xxx
also has a shared tag queue.

Ed's email client proceeds to splatter the discussion all over the Jan 2007
archive.  Ed finds a possible bug in qla4xxx.  Jens proposes a block patch.
Ed disagrees, Jeff agrees with Ed, discussion dies, driver still
crashing..


> > > Isn't drivers/scsi/* handled by linux-scsi@? (that's what I mean)
> >
> > Yep indeed, I thought you meant that it was a scsi bug (and not an stex
> > one). You could try and copy the 2.6.19 stex driver into 2.6.20 and see
> > if that works, though.
> 
> Looks like this bug is known for months :-(
> 
> Ed Lin pointed to http://lkml.org/lkml/2007/1/23/268 with possible patch (that 
> unfortunately serialises access to storage devices, well...)
> 
> There is also: http://bugzilla.kernel.org/show_bug.cgi?id=7842
> 
> I'm running 2.6.22 with that patch now, did huge (few hours) rsync that 
> previously caused oopses and now everything works properly.
> 
> Can we get some form of this patch into Linus tree?

Here's Ed's patch again.  As a suboptimal driver is better than a crashing
one, perhaps we should merge it until we can sort out something better?



From: "Ed Lin" <ed.lin@promise.com>

The block layer uses lock to protect request queue.  Every scsi device has
a unique request queue, and queue lock is the default lock in struct
request_queue.  This is good for normal cases.  But for a host with shared
queue tag (e.g.  stex controllers), a queue lock per device means the
shared queue tag is not protected when multiple devices are accessed at a
same time.  This patch is a simple fix for this situation by introducing a
host queue lock to protect shared queue tag.  Without this patch we will
see various kernel panics (including the BUG() and kernel errors in
blk_queue_start_tag and blk_queue_end_tag of ll_rw_blk.c) when accessing
another in smp kernels).

Signed-off-by: Ed Lin <ed.lin@promise.com>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Cc: Jeff Garzik <jeff@garzik.org>
Cc: Jens Axboe <jens.axboe@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c  |    2 +-
 drivers/scsi/stex.c      |    2 ++
 include/scsi/scsi_host.h |    3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/scsi_lib.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/drivers/scsi/scsi_lib.c
@@ -1670,7 +1670,7 @@ struct request_queue *__scsi_alloc_queue
 {
 	struct request_queue *q;
 
-	q = blk_init_queue(request_fn, NULL);
+	q = blk_init_queue(request_fn, shost->req_q_lock);
 	if (!q)
 		return NULL;
 
diff -puN drivers/scsi/stex.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host drivers/scsi/stex.c
--- a/drivers/scsi/stex.c~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/drivers/scsi/stex.c
@@ -1234,6 +1234,8 @@ stex_probe(struct pci_dev *pdev, const s
 	if (err)
 		goto out_free_irq;
 
+	spin_lock_init(&host->__req_q_lock);
+	host->req_q_lock = &host->__req_q_lock;
 	err = scsi_init_shared_tag_map(host, host->can_queue);
 	if (err) {
 		printk(KERN_ERR DRV_NAME "(%s): init shared queue failed\n",
diff -puN include/scsi/scsi_host.h~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host include/scsi/scsi_host.h
--- a/include/scsi/scsi_host.h~scsi-use-lock-per-host-instead-of-per-device-for-shared-queue-tag-host
+++ a/include/scsi/scsi_host.h
@@ -503,6 +503,9 @@ struct Scsi_Host {
 	spinlock_t		default_lock;
 	spinlock_t		*host_lock;
 
+	spinlock_t		__req_q_lock;
+	spinlock_t		*req_q_lock;/* protect shared block queue tag */
+
 	struct mutex		scan_mutex;/* serialize scanning activity */
 
 	struct list_head	eh_cmd_q;
_

