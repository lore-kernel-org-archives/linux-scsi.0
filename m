From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4] dm mpath: avoid call to blk_abort_queue by default
Date: Thu, 18 Nov 2010 14:19:19 -0500
Message-ID: <1290107959-17167-1-git-send-email-snitzer@redhat.com>
References: <1290095317-15684-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:10795 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751892Ab0KRTTj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:19:39 -0500
In-Reply-To: <1290095317-15684-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org, Mike Anderson <andmike@linux.vnet.ibm.com>, Mike Christie <michaelc@cs.wisc.edu>

Multipath was previously made to use blk_abort_queue() to allow for
lower latency path deactivation (commit 224cb3e9).  The call to
blk_abort_queue has proven to be unsafe, and is now disabled by default,
due to a race (between blk_abort_queue and scsi_request_fn) that can
lead to list corruption, from:
https://www.redhat.com/archives/dm-devel/2010-November/msg00085.html

"the cmd gets blk_abort_queued/timedout run on it and the scsi eh
somehow is able to complete and run scsi_queue_insert while
scsi_request_fn is still trying to process the request."

It is expected that this race will be fixed in the near-term so it makes
little since to remove all associated code.  Providing control over the
call to blk_abort_queue() facilitates continued testing and future
flexibility to opt-in to lower latency path deactivation.  Opting to
enable this feature will emit a warning for the time being.

Add 'features' member to 'struct multipath' and introduce
MPF_ABORT_QUEUE as the first feature flag.  If "abort_queue_on_fail"
is provided during mpath device configuration the MPF_ABORT_QUEUE
feature flag will be set and blk_abort_queue() will be called during
path deactivation.  The MPF_ABORT_QUEUE feature flag may be cleared
using the "skip_abort_queue_on_fail" message.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
---
 drivers/md/dm-mpath.c |   27 ++++++++++++++++++++++++---
 1 files changed, 24 insertions(+), 3 deletions(-)

v4: - revised the patch subject and header to emphaszie default to off
    - fixed missing m->lock locking when using test_bit() on m->features
      (MPF_ABORT_QUEUE is checked early in fail_path() to avoid queuing
      unnecessary work).
    - also added ability to clear MPF_ABORT_QUEUE feature flag via
      "skip_abort_queue_on_fail" message.

v3: bumped target version and switched feature name from
    "abort_queue_on_failure" to "abort_queue_on_fail".

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..ecec1af 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -56,8 +56,14 @@ struct priority_group {
 	struct list_head pgpaths;
 };
 
+/*
+ * Bits for the m->features
+ */
+#define MPF_ABORT_QUEUE 0
+
 /* Multipath context */
 struct multipath {
+	unsigned long features;
 	struct list_head list;
 	struct dm_target *ti;
 
@@ -813,6 +819,12 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("abort_queue_on_fail"))) {
+			set_bit(MPF_ABORT_QUEUE, &m->features);
+			DMWARN("Enabling use of blk_abort_queue is unsafe.");
+			continue;
+		}
+
 		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
 		    (argc >= 1)) {
 			r = read_param(_params + 1, shift(as),
@@ -995,7 +1007,9 @@ static int fail_path(struct pgpath *pgpath)
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
+
+	if (test_bit(MPF_ABORT_QUEUE, &pgpath->pg->m->features))
+		queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -1382,11 +1396,14 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
 		DMEMIT("2 %u %u ", m->queue_size, m->pg_init_count);
 	else {
 		DMEMIT("%u ", m->queue_if_no_path +
-			      (m->pg_init_retries > 0) * 2);
+			      (m->pg_init_retries > 0) * 2 +
+			      test_bit(MPF_ABORT_QUEUE, &m->features));
 		if (m->queue_if_no_path)
 			DMEMIT("queue_if_no_path ");
 		if (m->pg_init_retries)
 			DMEMIT("pg_init_retries %u ", m->pg_init_retries);
+		if (test_bit(MPF_ABORT_QUEUE, &m->features))
+			DMEMIT("abort_queue_on_fail ");
 	}
 
 	if (!m->hw_handler_name || type == STATUSTYPE_INFO)
@@ -1490,6 +1507,10 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 		} else if (!strnicmp(argv[0], MESG_STR("fail_if_no_path"))) {
 			r = queue_if_no_path(m, 0, 0);
 			goto out;
+		} else if (!strnicmp(argv[0], MESG_STR("skip_abort_queue_on_fail"))) {
+			clear_bit(MPF_ABORT_QUEUE, &m->features);
+			r = 0;
+			goto out;
 		}
 	}
 
@@ -1655,7 +1676,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
