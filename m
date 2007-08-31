From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [APPENDIX PATCH 4/5] blk_end_request: userspace
 device-mapper for request-based dm
Date: Fri, 31 Aug 2007 18:45:56 -0400 (EDT)
Message-ID: <20070831.184556.45747637.k-ueda@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com
Cc: dm-devel@redhat.com
List-Id: linux-scsi@vger.kernel.org

This patch adds a feature of turning request-based dm on
to device-mapper userspace tool.

To turn on request-based dm, following steps should work:
    1. # dmsetup create --rqbase mpath0
    2. # echo <multipath table> | dmsetup load mpath0
    3. # dmsetup resume mpath0
    Note: If you used bio-based targets for request-based dm device,
          you would hit kernel panic.  And vice versa.  (This is TODO.)
          The patch-set converts only multipath target to request-based.
          So please don't use other targets for request-based dm device
          and patched multipath target for bio-based dm device.
If you use multipath-tools (another patch), multipath-tools should
take care of all.

This patch should be applied on top of CVS device-mapper-1.02.23
of 8/28/2007.

Request-based dm itself is still under development and not ready
for inclusion.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
---
 dmsetup/dmsetup.c         |    9 ++++++++-
 kernel/ioctl/dm-ioctl.h   |    5 +++++
 lib/.exported_symbols     |    1 +
 lib/ioctl/libdm-iface.c   |   13 ++++++++++++-
 lib/ioctl/libdm-targets.h |    1 +
 lib/libdevmapper.h        |    1 +
 6 files changed, 28 insertions(+), 2 deletions(-)

diff -rupN cvs-device-mapper-20070828/dmsetup/dmsetup.c rqdm-device-mapper/dmsetup/dmsetup.c
--- cvs-device-mapper-20070828/dmsetup/dmsetup.c	2007-08-21 12:26:06.000000000 -0400
+++ rqdm-device-mapper/dmsetup/dmsetup.c	2007-08-28 17:47:04.000000000 -0400
@@ -119,6 +119,7 @@ enum {
 	NOOPENCOUNT_ARG,
 	NOTABLE_ARG,
 	OPTIONS_ARG,
+	RQBASE_ARG,
 	SEPARATOR_ARG,
 	SHOWKEYS_ARG,
 	SORT_ARG,
@@ -493,6 +493,9 @@ static int _create(int argc, char **argv, 
 	if (_switches[NOOPENCOUNT_ARG] && !dm_task_no_open_count(dmt))
 		goto out;
 
+	if (_switches[RQBASE_ARG] && !dm_task_request_base(dmt))
+		goto out;
+
 	if (!dm_task_run(dmt))
 		goto out;
 
@@ -1978,7 +1982,7 @@ static struct command _commands[] = {
 	{"help", "[-c|-C|--columns]", 0, 0, _help},
 	{"create", "<dev_name> [-j|--major <major> -m|--minor <minor>]\n"
 	  "\t                  [-U|--uid <uid>] [-G|--gid <gid>] [-M|--mode <octal_mode>]\n"
-	  "\t                  [-u|uuid <uuid>]\n"
+	  "\t                  [-u|uuid <uuid>] [--rqbase]\n"
 	  "\t                  [--notable | --table <table> | <table_file>]",
 	 1, 2, _create},
 	{"remove", "[-f|--force] <device>", 0, 1, _remove},
@@ -2366,6 +2370,7 @@ static int _process_switches(int *argc, 
 		{"noopencount", 0, &ind, NOOPENCOUNT_ARG},
 		{"notable", 0, &ind, NOTABLE_ARG},
 		{"options", 1, &ind, OPTIONS_ARG},
+		{"rqbase", 0, &ind, RQBASE_ARG},
 		{"separator", 1, &ind, SEPARATOR_ARG},
 		{"showkeys", 0, &ind, SHOWKEYS_ARG},
 		{"sort", 1, &ind, SORT_ARG},
@@ -2498,6 +2503,8 @@ static int _process_switches(int *argc, 
 			_switches[NOLOCKFS_ARG]++;
 		if ((ind == NOOPENCOUNT_ARG))
 			_switches[NOOPENCOUNT_ARG]++;
+		if ((ind == RQBASE_ARG))
+			_switches[RQBASE_ARG]++;
 		if ((ind == SHOWKEYS_ARG))
 			_switches[SHOWKEYS_ARG]++;
 		if ((ind == TABLE_ARG)) {
diff -rupN cvs-device-mapper-20070828/kernel/ioctl/dm-ioctl.h rqdm-device-mapper/kernel/ioctl/dm-ioctl.h
--- cvs-device-mapper-20070828/kernel/ioctl/dm-ioctl.h	2006-10-12 11:42:24.000000000 -0400
+++ rqdm-device-mapper/kernel/ioctl/dm-ioctl.h	2007-08-28 17:47:04.000000000 -0400
@@ -330,4 +330,9 @@ typedef char ioctl_struct[308];
  */
 #define DM_NOFLUSH_FLAG		(1 << 11) /* In */
 
+/*
+ * Set this to create request based device-mapper device.
+ */
+#define DM_REQUEST_BASE_FLAG	(1 << 12) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
diff -rupN cvs-device-mapper-20070828/lib/.exported_symbols rqdm-device-mapper/lib/.exported_symbols
--- cvs-device-mapper-20070828/lib/.exported_symbols	2007-07-28 06:48:36.000000000 -0400
+++ rqdm-device-mapper/lib/.exported_symbols	2007-08-28 17:47:04.000000000 -0400
@@ -32,6 +32,7 @@ dm_task_suppress_identical_reload
 dm_task_add_target
 dm_task_no_flush
 dm_task_no_open_count
+dm_task_request_base
 dm_task_skip_lockfs
 dm_task_update_nodes
 dm_task_run
diff -rupN cvs-device-mapper-20070828/lib/ioctl/libdm-iface.c rqdm-device-mapper/lib/ioctl/libdm-iface.c
--- cvs-device-mapper-20070828/lib/ioctl/libdm-iface.c	2007-08-21 12:26:07.000000000 -0400
+++ rqdm-device-mapper/lib/ioctl/libdm-iface.c	2007-08-28 17:47:04.000000000 -0400
@@ -1038,6 +1038,13 @@ int dm_task_no_open_count(struct dm_task
 	return 1;
 }
 
+int dm_task_request_base(struct dm_task *dmt)
+{
+	dmt->request_base = 1;
+
+	return 1;
+}
+
 int dm_task_skip_lockfs(struct dm_task *dmt)
 {
 	dmt->skip_lockfs = 1;
@@ -1281,6 +1288,8 @@ static struct dm_ioctl *_flatten(struct 
 		dmi->flags |= DM_READONLY_FLAG;
 	if (dmt->skip_lockfs)
 		dmi->flags |= DM_SKIP_LOCKFS_FLAG;
+	if (dmt->request_base)
+		dmi->flags |= DM_REQUEST_BASE_FLAG;
 
 	dmi->target_count = count;
 	dmi->event_nr = dmt->event_nr;
@@ -1412,6 +1421,7 @@ static int _create_and_load_v4(struct dm
 	task->uid = dmt->uid;
 	task->gid = dmt->gid;
 	task->mode = dmt->mode;
+	task->request_base = dmt->request_base;
 
 	r = dm_task_run(task);
 	dm_task_destroy(task);
@@ -1551,7 +1561,7 @@ static struct dm_ioctl *_do_dm_ioctl(str
 		dmi->flags |= DM_SKIP_BDGET_FLAG;
 
 	log_debug("dm %s %s %s%s%s %s%.0d%s%.0d%s"
-		  "%s%c%c%s %.0" PRIu64 " %s [%u]",
+		  "%s%c%c%c%s %.0" PRIu64 " %s [%u]",
 		  _cmd_data_v4[dmt->type].name,
 		  dmi->name, dmi->uuid, dmt->newname ? " " : "",
 		  dmt->newname ? dmt->newname : "",
@@ -1563,6 +1573,7 @@ static struct dm_ioctl *_do_dm_ioctl(str
 		  dmt->major > 0 ? ") " : "",
 		  dmt->no_open_count ? 'N' : 'O',
 		  dmt->no_flush ? 'N' : 'F',
+		  dmt->request_base ? 'R' : 'B',
 		  dmt->skip_lockfs ? "S " : "",
 		  dmt->sector, dmt->message ? dmt->message : "",
 		  dmi->data_size);
diff -rupN cvs-device-mapper-20070828/lib/ioctl/libdm-targets.h rqdm-device-mapper/lib/ioctl/libdm-targets.h
--- cvs-device-mapper-20070828/lib/ioctl/libdm-targets.h	2007-08-21 12:26:07.000000000 -0400
+++ rqdm-device-mapper/lib/ioctl/libdm-targets.h	2007-08-28 17:47:04.000000000 -0400
@@ -54,6 +54,7 @@ struct dm_task {
 	uint64_t sector;
 	int no_flush;
 	int no_open_count;
+	int request_base;
 	int skip_lockfs;
 	int suppress_identical_reload;
 
diff -rupN cvs-device-mapper-20070828/lib/libdevmapper.h rqdm-device-mapper/lib/libdevmapper.h
--- cvs-device-mapper-20070828/lib/libdevmapper.h	2007-08-21 12:26:06.000000000 -0400
+++ rqdm-device-mapper/lib/libdevmapper.h	2007-08-28 17:47:04.000000000 -0400
@@ -154,6 +154,7 @@ int dm_task_set_message(struct dm_task *
 int dm_task_set_sector(struct dm_task *dmt, uint64_t sector);
 int dm_task_no_flush(struct dm_task *dmt);
 int dm_task_no_open_count(struct dm_task *dmt);
+int dm_task_request_base(struct dm_task *dmt);
 int dm_task_skip_lockfs(struct dm_task *dmt);
 int dm_task_suppress_identical_reload(struct dm_task *dmt);
 
