From: Neil Brown <neilb@suse.de>
Subject: Re: [BUG] The kernel thread for md RAID1 could cause a md RAID1 array deadlock
Date: Thu, 24 Jan 2008 14:28:01 +1100
Message-ID: <18328.1473.26122.647283@notabene.brown>
References: <478C240F.8070004@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:48438 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752588AbYAXD2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Jan 2008 22:28:10 -0500
In-Reply-To: message from K.Tanaka on Tuesday January 15
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, dm-devel@redhat.com

On Tuesday January 15, k-tanaka@ce.jp.nec.com wrote:
> 
> This message describes the details about md-RAID1 issue found by
> testing the md RAID1 using the SCSI fault injection framework.
> 
> Abstract:
> Both the error handler for md RAID1 and write access request to the md RAID1
> use raid1d kernel thread. The nr_pending flag could cause a race condition
> in raid1d, results in a raid1d deadlock.

Thanks for finding and reporting this.

I believe the following patch should fix the deadlock.

If you are able to repeat your test and confirm this I would
appreciate it.

Thanks,
NeilBrown



Fix deadlock in md/raid1 when handling a read error.

When handling a read error, we freeze the array to stop any other
IO while attempting to over-write with correct data.

This is done in the raid1d thread and must wait for all submitted IO
to complete (except for requests that failed and are sitting in the
retry queue - these are counted in ->nr_queue and will stay there during
a freeze).

However write requests need attention from raid1d as bitmap updates
might be required.  This can cause a deadlock as raid1 is waiting for
requests to finish that themselves need attention from raid1d.

So we create a new function 'flush_pending_writes' to give that attention,
and call it in freeze_array to be sure that we aren't waiting on raid1d.

Thanks to "K.Tanaka" <k-tanaka@ce.jp.nec.com> for finding and reporting
this problem.

Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c |   66 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 45 insertions(+), 21 deletions(-)

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-01-18 11:19:09.000000000 +1100
+++ ./drivers/md/raid1.c	2008-01-24 14:21:55.000000000 +1100
@@ -592,6 +592,37 @@ static int raid1_congested(void *data, i
 }
 
 
+static int flush_pending_writes(conf_t *conf)
+{
+	/* Any writes that have been queue but are awaiting
+	 * bitmap updates get flushed here.
+	 * We return 1 if any requests were actually submitted.
+	 */
+	int rv = 0;
+
+	spin_lock_irq(&conf->device_lock);
+
+	if (conf->pending_bio_list.head) {
+		struct bio *bio;
+		bio = bio_list_get(&conf->pending_bio_list);
+		blk_remove_plug(conf->mddev->queue);
+		spin_unlock_irq(&conf->device_lock);
+		/* flush any pending bitmap writes to
+		 * disk before proceeding w/ I/O */
+		bitmap_unplug(conf->mddev->bitmap);
+
+		while (bio) { /* submit pending writes */
+			struct bio *next = bio->bi_next;
+			bio->bi_next = NULL;
+			generic_make_request(bio);
+			bio = next;
+		}
+		rv = 1;
+	} else
+		spin_unlock_irq(&conf->device_lock);
+	return rv;
+}
+
 /* Barriers....
  * Sometimes we need to suspend IO while we do something else,
  * either some resync/recovery, or reconfigure the array.
@@ -678,10 +709,14 @@ static void freeze_array(conf_t *conf)
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
+	spin_unlock_irq(&conf->resync_lock);
+
+	spin_lock_irq(&conf->resync_lock);
 	wait_event_lock_irq(conf->wait_barrier,
 			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
 			    conf->resync_lock,
-			    raid1_unplug(conf->mddev->queue));
+			    ({ flush_pending_writes(conf);
+			       raid1_unplug(conf->mddev->queue); }));
 	spin_unlock_irq(&conf->resync_lock);
 }
 static void unfreeze_array(conf_t *conf)
@@ -907,6 +942,9 @@ static int make_request(struct request_q
 	blk_plug_device(mddev->queue);
 	spin_unlock_irqrestore(&conf->device_lock, flags);
 
+	/* In case raid1d snuck into freeze_array */
+	wake_up(&conf->wait_barrier);
+
 	if (do_sync)
 		md_wakeup_thread(mddev->thread);
 #if 0
@@ -1473,28 +1511,14 @@ static void raid1d(mddev_t *mddev)
 	
 	for (;;) {
 		char b[BDEVNAME_SIZE];
-		spin_lock_irqsave(&conf->device_lock, flags);
-
-		if (conf->pending_bio_list.head) {
-			bio = bio_list_get(&conf->pending_bio_list);
-			blk_remove_plug(mddev->queue);
-			spin_unlock_irqrestore(&conf->device_lock, flags);
-			/* flush any pending bitmap writes to disk before proceeding w/ I/O */
-			bitmap_unplug(mddev->bitmap);
-
-			while (bio) { /* submit pending writes */
-				struct bio *next = bio->bi_next;
-				bio->bi_next = NULL;
-				generic_make_request(bio);
-				bio = next;
-			}
-			unplug = 1;
 
-			continue;
-		}
+		unplug += flush_pending_writes(conf);
 
-		if (list_empty(head))
+		spin_lock_irqsave(&conf->device_lock, flags);
+		if (list_empty(head)) {
+			spin_unlock_irqrestore(&conf->device_lock, flags);
 			break;
+		}
 		r1_bio = list_entry(head->prev, r1bio_t, retry_list);
 		list_del(head->prev);
 		conf->nr_queued--;
@@ -1590,7 +1614,7 @@ static void raid1d(mddev_t *mddev)
 			}
 		}
 	}
-	spin_unlock_irqrestore(&conf->device_lock, flags);
+
 	if (unplug)
 		unplug_slaves(mddev);
 }
