From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 04/13] block: Expose stacked device queues in sysfs
Date: Fri, 15 May 2009 00:40:26 -0400
Message-ID: <1242362435-11953-5-git-send-email-martin.petersen@oracle.com>
References: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1242362435-11953-1-git-send-email-martin.petersen@oracle.com>
Sender: linux-ide-owner@vger.kernel.org
To: rwheeler@redhat.com, snitzer@redhat.com, jeff@garzik.org, neilb@suse.de, James.Bottomley@hansenpartnership.com, jens.axboe@oracle.com, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

From: Martin K. Petersen <martin.petersen@oracle.com>

Currently stacking devices do not have a queue directory in sysfs.
However, many of the I/O characteristics like sector size, maximum
request size, etc. are queue properties.

This patch enables the queue directory for MD/DM devices.  The elevator
code has been modified to deal with queues that do not have an I/O
scheduler.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-sysfs.c |    6 +++---
 block/elevator.c  |   13 ++++++++++++-
 2 files changed, 15 insertions(+), 4 deletions(-)

diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index 142a4ac..3ccdadb 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -395,9 +395,6 @@ int blk_register_queue(struct gendisk *disk)
 	if (WARN_ON(!q))
 		return -ENXIO;
 
-	if (!q->request_fn)
-		return 0;
-
 	ret = kobject_add(&q->kobj, kobject_get(&disk_to_dev(disk)->kobj),
 			  "%s", "queue");
 	if (ret < 0)
@@ -405,6 +402,9 @@ int blk_register_queue(struct gendisk *disk)
 
 	kobject_uevent(&q->kobj, KOBJ_ADD);
 
+	if (!q->request_fn)
+		return 0;
+
 	ret = elv_register_queue(q);
 	if (ret) {
 		kobject_uevent(&q->kobj, KOBJ_REMOVE);
diff --git a/block/elevator.c b/block/elevator.c
index 9189200..143fb6a 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -575,6 +575,9 @@ void elv_drain_elevator(struct request_queue *q)
  */
 void elv_quiesce_start(struct request_queue *q)
 {
+	if (!q->elevator)
+		return;
+
 	queue_flag_set(QUEUE_FLAG_ELVSWITCH, q);
 
 	/*
@@ -1050,6 +1053,9 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
 	char elevator_name[ELV_NAME_MAX];
 	struct elevator_type *e;
 
+	if (!q->elevator)
+		return count;
+
 	strlcpy(elevator_name, name, sizeof(elevator_name));
 	strstrip(elevator_name);
 
@@ -1073,10 +1079,15 @@ ssize_t elv_iosched_store(struct request_queue *q, const char *name,
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
-- 
1.6.0.6

