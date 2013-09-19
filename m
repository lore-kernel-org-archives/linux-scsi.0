From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm mpath: disable WRITE SAME if it fails
Date: Thu, 19 Sep 2013 12:13:58 -0400
Message-ID: <20130919161043.GA27081@redhat.com>
Reply-To: yq1fvwuoeck.fsf@sermon.lab.mkp.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:19054 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752072Ab3ISQOG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 Sep 2013 12:14:06 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: martin.petersen@oracle.com, hare@suse.de, linux-scsi@vger.kernel.org

Workaround the SCSI layer's problematic WRITE SAME heuristics by
disabling WRITE SAME in the DM multipath device's queue_limits if an
underlying device disabled it.

The WRITE SAME heuristics, with both the original commit 5db44863b6eb
("[SCSI] sd: Implement support for WRITE SAME") and the updated commit
66c28f971 ("[SCSI] sd: Update WRITE SAME heuristics"), default to enabling
WRITE SAME(10) even without successfully determining it is supported.
After the first failed WRITE SAME the SCSI layer will disable WRITE SAME
for the device (by setting sdkp->device->no_write_same which results in
'max_write_same_sectors' in device's queue_limits to be set to 0).

When a device is stacked ontop of such a SCSI device any changes to that
SCSI device's queue_limits do not automatically propagate up the stack.
As such, a DM multipath device will not have its WRITE SAME support
disabled.  This causes the block layer to continue to issue WRITE SAME
requests to the mpath device which causes paths to fail and (if mpath IO
isn't configured to queue when no paths are available) it will result in
actual IO errors to the upper layers.

This fix doesn't help configurations that have additional devices
stacked ontop of the mpath device (e.g. LVM created linear DM devices
ontop).  A proper fix that restacks all the queue_limits from the bottom
of the device stack up will need to be explored if SCSI will continue to
use this model of optimistically allowing op codes and then disabling
them after they fail for the first time.

Before this patch:

EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
device-mapper: multipath: XXX snitm debugging: got -EREMOTEIO (-121)
device-mapper: multipath: XXX snitm debugging: failing WRITE SAME IO with error=-121
end_request: critical target error, dev dm-6, sector 528
dm-6: WRITE SAME failed. Manually zeroing.
device-mapper: multipath: Failing path 8:112.
end_request: I/O error, dev dm-6, sector 4616
dm-6: WRITE SAME failed. Manually zeroing.
end_request: I/O error, dev dm-6, sector 4616
end_request: I/O error, dev dm-6, sector 5640
end_request: I/O error, dev dm-6, sector 6664
end_request: I/O error, dev dm-6, sector 7688
end_request: I/O error, dev dm-6, sector 524288
Buffer I/O error on device dm-6, logical block 65536
lost page write due to I/O error on dm-6
JBD2: Error -5 detected when updating journal superblock for dm-6-8.
end_request: I/O error, dev dm-6, sector 524296
Aborting journal on device dm-6-8.
end_request: I/O error, dev dm-6, sector 524288
Buffer I/O error on device dm-6, logical block 65536
lost page write due to I/O error on dm-6
JBD2: Error -5 detected when updating journal superblock for dm-6-8.

# cat /sys/block/sdh/queue/write_same_max_bytes
0
# cat /sys/block/dm-6/queue/write_same_max_bytes
33553920

After this patch:

EXT4-fs (dm-6): mounted filesystem with ordered data mode. Opts: (null)
device-mapper: multipath: XXX snitm debugging: got -EREMOTEIO (-121)
device-mapper: multipath: XXX snitm debugging: WRITE SAME I/O failed with error=-121
end_request: critical target error, dev dm-6, sector 528
dm-6: WRITE SAME failed. Manually zeroing.

# cat /sys/block/sdh/queue/write_same_max_bytes
0
# cat /sys/block/dm-6/queue/write_same_max_bytes
0

It should be noted that WRITE SAME support wasn't enabled in DM
multipath until v3.10.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: stable@vger.kernel.org # 3.10+
---
 drivers/md/dm-mpath.c         |   11 ++++++++++-
 drivers/md/dm.c               |   11 +++++++++++
 include/linux/device-mapper.h |    3 ++-
 3 files changed, 23 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 0b3955f..de570a5 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -1299,8 +1299,17 @@ static int do_end_io(struct multipath *m, struct request *clone,
 	if (!error && !clone->errors)
 		return 0;	/* I/O complete */
 
-	if (noretry_error(error))
+	if (noretry_error(error)) {
+		if ((clone->cmd_flags & REQ_WRITE_SAME) &&
+		    !clone->q->limits.max_write_same_sectors) {
+			struct queue_limits *limits;
+
+			/* device doesn't really support WRITE SAME, disable it */
+			limits = dm_get_queue_limits(dm_table_get_md(m->ti->table));
+			limits->max_write_same_sectors = 0;
+		}
 		return error;
+	}
 
 	if (mpio->pgpath)
 		fail_path(mpio->pgpath);
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 033dc26..b3e26c7 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2323,6 +2323,17 @@ struct target_type *dm_get_immutable_target_type(struct mapped_device *md)
 }
 
 /*
+ * The queue_limits are only valid as long as you have a reference
+ * count on 'md'.
+ */
+struct queue_limits *dm_get_queue_limits(struct mapped_device *md)
+{
+	BUG_ON(!atomic_read(&md->holders));
+	return &md->queue->limits;
+}
+EXPORT_SYMBOL_GPL(dm_get_queue_limits);
+
+/*
  * Fully initialize a request-based queue (->elevator, ->request_fn, etc).
  */
 static int dm_init_request_based_queue(struct mapped_device *md)
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 653073d..ed419c6 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -406,13 +406,14 @@ int dm_noflush_suspending(struct dm_target *ti);
 union map_info *dm_get_mapinfo(struct bio *bio);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
+struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
+
 /*
  * Geometry functions.
  */
 int dm_get_geometry(struct mapped_device *md, struct hd_geometry *geo);
 int dm_set_geometry(struct mapped_device *md, struct hd_geometry *geo);
 
-
 /*-----------------------------------------------------------------
  * Functions for manipulating device-mapper tables.
  *---------------------------------------------------------------*/
