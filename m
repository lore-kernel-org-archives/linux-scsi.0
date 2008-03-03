From: Neil Brown <neilb@suse.de>
Subject: Re: [BUGREPORT] The kernel thread for md RAID10 could cause a md RAID10
 array deadlock
Date: Mon, 3 Mar 2008 11:11:23 +1100
Message-ID: <18379.16939.951960.592459@notabene.brown>
References: <47B2AB68.1040604@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.suse.de ([195.135.220.2]:44324 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751847AbYCCALO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 19:11:14 -0500
In-Reply-To: message from K.Tanaka on Wednesday February 13
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Cc: linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org

On Wednesday February 13, k-tanaka@ce.jp.nec.com wrote:
> This message describes another issue about md-RAID10 found by
> testing the 2.6.24 md RAID10 using new scsi fault injection framework.

Thanks for finding and reporting this!!!

The following patch should fix the bug, both in raid1 and raid10.

NeilBrown



Fix possible raid1/raid10 deadlock on read error during resync.

Thanks to K.Tanaka and the scsi fault injection framework, here is
a fix for another possible deadlock in raid1/raid10 error handing.

If a read request returns an error while a resync is happening and
a resync request is pending, the attempt to fix the error will block
until the resync progresses, and the resync will block until the
read request completes.  Thus a deadlock.

This patch fixes the problem.

Cc: "K.Tanaka" <k-tanaka@ce.jp.nec.com>
Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/raid1.c  |   11 +++++++++--
 ./drivers/md/raid10.c |   11 +++++++++--
 2 files changed, 18 insertions(+), 4 deletions(-)

diff .prev/drivers/md/raid10.c ./drivers/md/raid10.c
--- .prev/drivers/md/raid10.c	2008-03-03 11:03:39.000000000 +1100
+++ ./drivers/md/raid10.c	2008-03-03 09:56:53.000000000 +1100
@@ -747,13 +747,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quiet.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid10_unplug(conf->mddev->queue); }));

diff .prev/drivers/md/raid1.c ./drivers/md/raid1.c
--- .prev/drivers/md/raid1.c	2008-03-03 11:03:39.000000000 +1100
+++ ./drivers/md/raid1.c	2008-03-03 09:56:52.000000000 +1100
@@ -704,13 +704,20 @@ static void freeze_array(conf_t *conf)
 	/* stop syncio and normal IO and wait for everything to
 	 * go quite.
 	 * We increment barrier and nr_waiting, and then
-	 * wait until barrier+nr_pending match nr_queued+2
+	 * wait until nr_pending match nr_queued+1
+	 * This is called in the context of one normal IO request
+	 * that has failed. Thus any sync request that might be pending
+	 * will be blocked by nr_pending, and we need to wait for
+	 * pending IO requests to complete or be queued for re-try.
+	 * Thus the number queued (nr_queued) plus this request (1)
+	 * must match the number of pending IOs (nr_pending) before
+	 * we continue.
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->barrier++;
 	conf->nr_waiting++;
 	wait_event_lock_irq(conf->wait_barrier,
-			    conf->barrier+conf->nr_pending == conf->nr_queued+2,
+			    conf->nr_pending == conf->nr_queued+1,
 			    conf->resync_lock,
 			    ({ flush_pending_writes(conf);
 			       raid1_unplug(conf->mddev->queue); }));
