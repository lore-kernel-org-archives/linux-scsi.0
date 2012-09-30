From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 1/6] target/file: Re-enable optional fd_buffered_io=1 operation
Date: Sun, 30 Sep 2012 05:58:11 +0000
Message-ID: <1348984696-30992-2-git-send-email-nab@linux-iscsi.org>
References: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348984696-30992-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andy Grover <agrover@redhat.com>, Nicholas Bellinger <nab@linux-iscsi.org>, Christoph Hellwig <hch@lst.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

This patch re-adds the ability to optionally run in buffered FILEIO mode
(eg: w/o O_DSYNC) for device backends in order to once again use the
Linux buffered cache as a write-back storage mechanism.

This logic was originally dropped with mainline v3.5-rc commit:

commit a4dff3043c231d57f982af635c9d2192ee40e5ae
Author: Nicholas Bellinger <nab@linux-iscsi.org>
Date:   Wed May 30 16:25:41 2012 -0700

    target/file: Use O_DSYNC by default for FILEIO backends

This difference with this patch is that fd_create_virtdevice() now
forces the explicit setting of emulate_write_cache=1 when buffered FILEIO
operation has been enabled.

Reported-by: Ferry <iscsitmp@bananateam.nl>
Cc: Christoph Hellwig <hch@lst.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
---
 drivers/target/target_core_file.c |   36 +++++++++++++++++++++++++++++++++---
 drivers/target/target_core_file.h |    1 +
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
index 1111925..e79b7b9 100644
--- a/drivers/target/target_core_file.c
+++ b/drivers/target/target_core_file.c
@@ -125,6 +125,14 @@ static struct se_device *fd_create_virtdevice(
 	 * of pure timestamp updates.
 	 */
 	flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
+	 /*
+	 * Optionally allow fd_buffered_io=1 to be enabled for people
+	 * who know what they are doing w/o O_DSYNC.
+	 */
+	if (fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) {
+		pr_debug("FILEIO: Disabling O_DSYNC, using buffered FILEIO\n");
+		flags &= ~O_DSYNC;
+	}
 
 	file = filp_open(fd_dev->fd_dev_name, flags, 0600);
 	if (IS_ERR(file)) {
@@ -188,6 +196,12 @@ static struct se_device *fd_create_virtdevice(
 	if (!dev)
 		goto fail;
 
+	if (fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) {
+		pr_debug("FILEIO: Forcing setting of emulate_write_cache=1"
+			" with FDBD_USE_BUFFERED_IO\n");
+		dev->se_sub_dev->se_dev_attrib.emulate_write_cache = 1;
+	}
+
 	fd_dev->fd_dev_id = fd_host->fd_host_dev_id_count++;
 	fd_dev->fd_queue_depth = dev->queue_depth;
 
@@ -407,6 +421,7 @@ enum {
 static match_table_t tokens = {
 	{Opt_fd_dev_name, "fd_dev_name=%s"},
 	{Opt_fd_dev_size, "fd_dev_size=%s"},
+	{Opt_fd_buffered_io, "fd_buffered_io=%d"},
 	{Opt_err, NULL}
 };
 
@@ -418,7 +433,7 @@ static ssize_t fd_set_configfs_dev_params(
 	struct fd_dev *fd_dev = se_dev->se_dev_su_ptr;
 	char *orig, *ptr, *arg_p, *opts;
 	substring_t args[MAX_OPT_ARGS];
-	int ret = 0, token;
+	int ret = 0, arg, token;
 
 	opts = kstrdup(page, GFP_KERNEL);
 	if (!opts)
@@ -459,6 +474,19 @@ static ssize_t fd_set_configfs_dev_params(
 					" bytes\n", fd_dev->fd_dev_size);
 			fd_dev->fbd_flags |= FBDF_HAS_SIZE;
 			break;
+		case Opt_fd_buffered_io:
+			match_int(args, &arg);
+			if (arg != 1) {
+				pr_err("bogus fd_buffered_io=%d value\n", arg);
+				ret = -EINVAL;
+				goto out;
+			}
+
+			pr_debug("FILEIO: Using buffered I/O"
+				" operations for struct fd_dev\n");
+
+			fd_dev->fbd_flags |= FDBD_USE_BUFFERED_IO;
+			break;
 		default:
 			break;
 		}
@@ -490,8 +518,10 @@ static ssize_t fd_show_configfs_dev_params(
 	ssize_t bl = 0;
 
 	bl = sprintf(b + bl, "TCM FILEIO ID: %u", fd_dev->fd_dev_id);
-	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: O_DSYNC\n",
-		fd_dev->fd_dev_name, fd_dev->fd_dev_size);
+	bl += sprintf(b + bl, "        File: %s  Size: %llu  Mode: %s\n",
+		fd_dev->fd_dev_name, fd_dev->fd_dev_size,
+		(fd_dev->fbd_flags & FDBD_USE_BUFFERED_IO) ?
+		"Buffered" : "O_DSYNC");
 	return bl;
 }
 
diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
index 70ce7fd..fbd59ef 100644
--- a/drivers/target/target_core_file.h
+++ b/drivers/target/target_core_file.h
@@ -14,6 +14,7 @@
 
 #define FBDF_HAS_PATH		0x01
 #define FBDF_HAS_SIZE		0x02
+#define FDBD_USE_BUFFERED_IO	0x04
 
 struct fd_dev {
 	u32		fbd_flags;
-- 
1.7.2.5
