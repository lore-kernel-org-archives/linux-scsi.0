From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 1 of 8] block: Expose stacked device queues in sysfs
Date: Thu, 23 Apr 2009 01:29:28 -0400
Message-ID: <0e7ee30358755f9a5fda.1240464568__10141.9556457133$1240465865$gmane$org@sermon.lab.mkp.net>
References: <patchbomb.1240464567@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:54634 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751382AbZDWFtT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 23 Apr 2009 01:49:19 -0400
In-Reply-To: <patchbomb.1240464567@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, dgilbert@interlog.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org

Currently stacking devices do not have a queue directory in sysfs.
However, many of the I/O characteristics like sector size, maximum
request size, etc. are queue properties.

This patch enables the queue directory for MD/DM devices.  The elevator
code has been modified to deal with queues that do not have an I/O
scheduler.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

---
2 files changed, 15 insertions(+), 4 deletions(-)
block/blk-sysfs.c |    6 +++---
block/elevator.c  |   13 ++++++++++++-



diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -393,9 +393,6 @@ int blk_register_queue(struct gendisk *d
 	if (WARN_ON(!q))
 		return -ENXIO;
 
-	if (!q->request_fn)
-		return 0;
-
 	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
 			  "%s", "queue");
 	if (ret < 0)
@@ -403,6 +400,9 @@ int blk_register_queue(struct gendisk *d
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
+	if (!q->request_fn)
+		return 0;
+
 	ret = elv_register_queue(q);
 	if (ret) {
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
diff --git a/block/elevator.c b/block/elevator.c
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -592,6 +592,9 @@ void elv_drain_elevator(struct request_q
  */
 void elv_quiesce_start(struct request_queue *q)
 {
+	if (!q->elevator)
+		return;
+
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
 
 	/*
@@ -1179,6 +1182,9 @@ ssize_t elv_iosched_store(struct request
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
 
+	if (!q->elevator)
+		return count;
+
 	strlcpy(elevator_name, name, sizeof(elevator_name));
 	strstrip(elevator_name);
 
@@ -1202,10 +1208,15 @@ ssize_t elv_iosched_store(struct request
 ssize_t elv_iosched_show(struct request_queue *q, char *name)
 {
 	struct elevator_queue *e = q->elevator;
-	struct elevator_type *elv = e->elevator_type;
+	struct elevator_type *elv;
 	struct elevator_type *__e;
 	int len = 0;
 
+	if (!q->elevator)
+		return sprintf(name, "none\n");
+
+	elv = e->elevator_type;
+
 	spin_lock(&elv_list_lock);
 	list_for_each_entry(__e, &elv_list, list) {
 		if (!strcmp(elv->elevator_name, __e->elevator_name))


