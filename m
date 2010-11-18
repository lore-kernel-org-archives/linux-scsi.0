From: Mike Snitzer <snitzer@redhat.com>
Subject: (unknown)
Date: Thu, 18 Nov 2010 14:16:11 -0500
Message-ID: <1290107771-17070-1-git-send-email-snitzer@redhat.com>
References: <1290095317-15684-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:18509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752023Ab0KRTQR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Nov 2010 14:16:17 -0500
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.13.8/8.13.8) with ESMTP id oAIJGHqf001877
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <linux-scsi@vger.kernel.org>; Thu, 18 Nov 2010 14:16:17 -0500
Subject: 
In-Reply-To: <1290095317-15684-1-git-send-email-snitzer@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: linux-scsi@vger.kernel.org

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 487ecda..723dc19 100644
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
 
@@ -813,6 +819,11 @@ static int parse_features(struct arg_set *as, struct multipath *m)
 			continue;
 		}
 
+		if (!strnicmp(param_name, MESG_STR("abort_queue_on_fail"))) {
+			set_bit(MPF_ABORT_QUEUE, &m->features);
+			continue;
+		}
+
 		if (!strnicmp(param_name, MESG_STR("pg_init_retries")) &&
 		    (argc >= 1)) {
 			r = read_param(_params + 1, shift(as),
@@ -995,7 +1006,9 @@ static int fail_path(struct pgpath *pgpath)
 		      pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
-	queue_work(kmultipathd, &pgpath->deactivate_path);
+
+	if (test_bit(MPF_ABORT_QUEUE, &pgpath->pg->m->features))
+		queue_work(kmultipathd, &pgpath->deactivate_path);
 
 out:
 	spin_unlock_irqrestore(&m->lock, flags);
@@ -1382,11 +1395,14 @@ static int multipath_status(struct dm_target *ti, status_type_t type,
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
@@ -1490,6 +1506,10 @@ static int multipath_message(struct dm_target *ti, unsigned argc, char **argv)
 		} else if (!strnicmp(argv[0], MESG_STR("fail_if_no_path"))) {
 			r = queue_if_no_path(m, 0, 0);
 			goto out;
+		} else if (!strnicmp(argv[0], MESG_STR("skip_abort_queue_on_fail"))) {
+			clear_bit(MPF_ABORT_QUEUE, &m->features);
+			r = 0;
+			goto out;
 		}
 	}
 
@@ -1655,7 +1675,7 @@ out:
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
 	.dtr = multipath_dtr,
