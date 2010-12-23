From: Bart Van Assche <bvanassche@acm.org>
Subject: [SCSI] scst: Move tracing to debugfs
Date: Thu, 23 Dec 2010 16:15:11 +0100
Message-ID: <201012231615.11691.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:42283 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab0LWPPV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Dec 2010 10:15:21 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

The trace_level files created in sysfs by the SCST core are mostly
used for debugging purposes, hence move these to debugfs. Also
instead of using one file for all tracing flags of a driver use
one file per tracing flag. An example of the new hierarchy:

main/tracing/buff
main/tracing/debug
main/tracing/flow_control
main/tracing/function
main/tracing/line
main/tracing/mem
main/tracing/mgmt
main/tracing/mgmt_dbg
main/tracing/minor
main/tracing/out_of_mem
main/tracing/pid
main/tracing/pr
main/tracing/recv_bot
main/tracing/recv_top
main/tracing/retry
main/tracing/scsi
main/tracing/scsi_serializing
main/tracing/send_bot
main/tracing/send_top
main/tracing/sg
main/tracing/special
target/scst_local/tracing/buff
target/scst_local/tracing/debug
target/scst_local/tracing/flow_control
target/scst_local/tracing/function
target/scst_local/tracing/line
target/scst_local/tracing/mem
target/scst_local/tracing/mgmt
target/scst_local/tracing/mgmt_dbg
target/scst_local/tracing/minor
target/scst_local/tracing/out_of_mem
target/scst_local/tracing/pid
target/scst_local/tracing/pr
target/scst_local/tracing/scsi
target/scst_local/tracing/sg
target/scst_local/tracing/special
tgt_dev/vdisk_fileio/tracing/buff
tgt_dev/vdisk_fileio/tracing/debug
tgt_dev/vdisk_fileio/tracing/flow_control
tgt_dev/vdisk_fileio/tracing/function
tgt_dev/vdisk_fileio/tracing/line
tgt_dev/vdisk_fileio/tracing/mem
tgt_dev/vdisk_fileio/tracing/mgmt
tgt_dev/vdisk_fileio/tracing/mgmt_dbg
tgt_dev/vdisk_fileio/tracing/minor
tgt_dev/vdisk_fileio/tracing/order
tgt_dev/vdisk_fileio/tracing/out_of_mem
tgt_dev/vdisk_fileio/tracing/pid
tgt_dev/vdisk_fileio/tracing/pr
tgt_dev/vdisk_fileio/tracing/scsi
tgt_dev/vdisk_fileio/tracing/sg
tgt_dev/vdisk_fileio/tracing/special

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Richard Sharpe <realrichardsharpe@gmail.com>
---
 drivers/scst/dev_handlers/scst_cdrom.c     |    6 +-
 drivers/scst/dev_handlers/scst_changer.c   |    6 +-
 drivers/scst/dev_handlers/scst_disk.c      |   12 +-
 drivers/scst/dev_handlers/scst_modisk.c    |   12 +-
 drivers/scst/dev_handlers/scst_processor.c |    6 +-
 drivers/scst/dev_handlers/scst_raid.c      |    6 +-
 drivers/scst/dev_handlers/scst_tape.c      |   12 +-
 drivers/scst/dev_handlers/scst_vdisk.c     |   38 +-
 drivers/scst/scst_local/scst_local.c       |    6 +-
 drivers/scst/scst_sysfs.c                  |  536 ++++++++++++----------------
 drivers/scst/srpt/ib_srpt.c                |    6 +-
 include/scst/scst.h                        |   45 ++--
 12 files changed, 328 insertions(+), 363 deletions(-)

diff --git a/drivers/scst/dev_handlers/scst_cdrom.c b/drivers/scst/dev_handlers/scst_cdrom.c
index 97f428f..72c606e 100644
--- a/drivers/scst/dev_handlers/scst_cdrom.c
+++ b/drivers/scst/dev_handlers/scst_cdrom.c
@@ -51,8 +51,10 @@ static struct scst_dev_type cdrom_devtype = {
 	.parse =		cdrom_parse,
 	.dev_done =		cdrom_done,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_changer.c b/drivers/scst/dev_handlers/scst_changer.c
index 74d9c8e..645cfb4 100644
--- a/drivers/scst/dev_handlers/scst_changer.c
+++ b/drivers/scst/dev_handlers/scst_changer.c
@@ -46,8 +46,10 @@ static struct scst_dev_type changer_devtype = {
 	.parse =	changer_parse,
 /*	.dev_done =	changer_done */
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_disk.c b/drivers/scst/dev_handlers/scst_disk.c
index b8d1190..39f221b 100644
--- a/drivers/scst/dev_handlers/scst_disk.c
+++ b/drivers/scst/dev_handlers/scst_disk.c
@@ -63,8 +63,10 @@ static struct scst_dev_type disk_devtype = {
 	.on_sg_tablesize_low = disk_on_sg_tablesize_low,
 	.dev_done =		disk_done,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags = SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags = &trace_flag,
+	.trace_data = {
+		.default_trace_flags = SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags = &trace_flag,
+	},
 #endif
 };
 
@@ -80,8 +82,10 @@ static struct scst_dev_type disk_devtype_perf = {
 	.dev_done =		disk_done,
 	.on_sg_tablesize_low = disk_on_sg_tablesize_low,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_modisk.c b/drivers/scst/dev_handlers/scst_modisk.c
index 90e6609..50ecfa4 100644
--- a/drivers/scst/dev_handlers/scst_modisk.c
+++ b/drivers/scst/dev_handlers/scst_modisk.c
@@ -57,8 +57,10 @@ static struct scst_dev_type modisk_devtype = {
 	.parse =		modisk_parse,
 	.dev_done =		modisk_done,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
@@ -73,8 +75,10 @@ static struct scst_dev_type modisk_devtype_perf = {
 	.dev_done =		modisk_done,
 	.exec =			modisk_perf_exec,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_processor.c b/drivers/scst/dev_handlers/scst_processor.c
index 91158d1..f6872cf 100644
--- a/drivers/scst/dev_handlers/scst_processor.c
+++ b/drivers/scst/dev_handlers/scst_processor.c
@@ -46,8 +46,10 @@ static struct scst_dev_type processor_devtype = {
 	.parse =		processor_parse,
 /*	.dev_done =		processor_done*/
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_raid.c b/drivers/scst/dev_handlers/scst_raid.c
index 241eb8d..6bc4e5d 100644
--- a/drivers/scst/dev_handlers/scst_raid.c
+++ b/drivers/scst/dev_handlers/scst_raid.c
@@ -46,8 +46,10 @@ static struct scst_dev_type raid_devtype = {
 	.parse =		raid_parse,
 /*	.dev_done =		raid_done,*/
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_tape.c b/drivers/scst/dev_handlers/scst_tape.c
index 1109b02..172847e 100644
--- a/drivers/scst/dev_handlers/scst_tape.c
+++ b/drivers/scst/dev_handlers/scst_tape.c
@@ -62,8 +62,10 @@ static struct scst_dev_type tape_devtype = {
 	.parse =		tape_parse,
 	.dev_done =		tape_done,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
@@ -78,8 +80,10 @@ static struct scst_dev_type tape_devtype_perf = {
 	.dev_done =		tape_done,
 	.exec =			tape_perf_exec,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/dev_handlers/scst_vdisk.c b/drivers/scst/dev_handlers/scst_vdisk.c
index b951057..0700c60 100644
--- a/drivers/scst/dev_handlers/scst_vdisk.c
+++ b/drivers/scst/dev_handlers/scst_vdisk.c
@@ -57,8 +57,6 @@ static struct scst_trace_log vdisk_local_trace_tbl[] = {
 };
 #define trace_log_tbl			vdisk_local_trace_tbl
 
-#define VDISK_TRACE_TLB_HELP	", order"
-
 #endif
 
 #include "scst_dev_handler.h"
@@ -426,10 +424,11 @@ static struct scst_dev_type vdisk_file_devtype = {
 	.dev_attrs =		vdisk_fileio_attrs,
 	.add_device_parameters = vdisk_fileio_add_device_parameters,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
-	.trace_tbl =		vdisk_local_trace_tbl,
-	.trace_tbl_help =	VDISK_TRACE_TLB_HELP,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+		.trace_tbl =		vdisk_local_trace_tbl,
+	},
 #endif
 };
 
@@ -458,10 +457,11 @@ static struct scst_dev_type vdisk_blk_devtype = {
 	.dev_attrs =		vdisk_blockio_attrs,
 	.add_device_parameters = vdisk_blockio_add_device_parameters,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
-	.trace_tbl =		vdisk_local_trace_tbl,
-	.trace_tbl_help =	VDISK_TRACE_TLB_HELP,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+		.trace_tbl =		vdisk_local_trace_tbl,
+	},
 #endif
 };
 
@@ -487,10 +487,11 @@ static struct scst_dev_type vdisk_null_devtype = {
 	.dev_attrs =		vdisk_nullio_attrs,
 	.add_device_parameters = vdisk_nullio_add_device_parameters,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
-	.trace_tbl =		vdisk_local_trace_tbl,
-	.trace_tbl_help =	VDISK_TRACE_TLB_HELP,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+		.trace_tbl =		vdisk_local_trace_tbl,
+	},
 #endif
 };
 
@@ -514,10 +515,11 @@ static struct scst_dev_type vcdrom_devtype = {
 	.dev_attrs =		vcdrom_attrs,
 	.add_device_parameters = NULL,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
-	.trace_flags =		&trace_flag,
-	.trace_tbl =		vdisk_local_trace_tbl,
-	.trace_tbl_help =	VDISK_TRACE_TLB_HELP,
+	.trace_data = {
+		.default_trace_flags =	SCST_DEFAULT_DEV_LOG_FLAGS,
+		.trace_flags =		&trace_flag,
+		.trace_tbl =		vdisk_local_trace_tbl,
+	},
 #endif
 };
 
diff --git a/drivers/scst/scst_local/scst_local.c b/drivers/scst/scst_local/scst_local.c
index c84c08e..14c8fd9 100644
--- a/drivers/scst/scst_local/scst_local.c
+++ b/drivers/scst/scst_local/scst_local.c
@@ -1089,8 +1089,10 @@ static struct scst_tgt_template scst_local_targ_tmpl = {
 	.get_scsi_transport_version = scst_local_get_scsi_transport_version,
 	.get_phys_transport_version = scst_local_get_phys_transport_version,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags = SCST_LOCAL_DEFAULT_LOG_FLAGS,
-	.trace_flags = &trace_flag,
+	.trace_data = {
+		.default_trace_flags = SCST_LOCAL_DEFAULT_LOG_FLAGS,
+		.trace_flags = &trace_flag,
+	},
 #endif
 };
 
diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index 36cb85d..1261704 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -40,6 +40,8 @@
 #include <linux/ctype.h>
 #include <linux/slab.h>
 #include <linux/kthread.h>
+#include <linux/file.h>
+#include <linux/debugfs.h>
 
 #include <scst/scst.h>
 #include "scst_priv.h"
@@ -61,6 +63,9 @@ enum mgmt_path_type {
 
 static struct bus_type scst_target_bus;
 static struct bus_type scst_device_bus;
+static struct dentry *scst_debug_root;
+static struct dentry *scst_debug_target;
+static struct dentry *scst_debug_tgt_dev;
 
 static const char *scst_dev_handler_types[] = {
 	"Direct-access device (e.g., magnetic disk)",
@@ -104,205 +109,139 @@ static struct scst_trace_log scst_trace_tbl[] = {
 	{ 0,			NULL		}
 };
 
-static struct scst_trace_log scst_local_trace_tbl[] = {
-	{ TRACE_RTRY,			"retry"			},
-	{ TRACE_SCSI_SERIALIZING,	"scsi_serializing"	},
-	{ TRACE_RCV_BOT,		"recv_bot"		},
-	{ TRACE_SND_BOT,		"send_bot"		},
-	{ TRACE_RCV_TOP,		"recv_top"		},
-	{ TRACE_SND_TOP,		"send_top"		},
-	{ 0,				NULL			}
-};
-
-static void scst_read_trace_tbl(const struct scst_trace_log *tbl, char *buf,
-	unsigned long log_level, int *pos)
+/**
+ * scst_lookup_token() - Look up the name of a tracing token.
+ *
+ * Always returns a non-NULL pointer. If the token has been found, upon return
+ * p->val != 0 and p->token != NULL. If the token has not been found, upon
+ * return p->val == 0 and p->token == NULL.
+ */
+static struct scst_trace_log *scst_lookup_token(struct scst_trace_data *td,
+						const char *name)
 {
-	const struct scst_trace_log *t = tbl;
+	struct scst_trace_log *p;
 
-	if (t == NULL)
-		goto out;
+	if (td->trace_tbl)
+		for (p = td->trace_tbl; p->token; ++p)
+			if (strcmp(p->token, name) == 0)
+				return p;
 
-	while (t->token) {
-		if (log_level & t->val) {
-			*pos += sprintf(&buf[*pos], "%s%s",
-					(*pos == 0) ? "" : " | ",
-					t->token);
-		}
-		t++;
-	}
-out:
-	return;
+	for (p = scst_trace_tbl; p->token; ++p)
+		if (strcmp(p->token, name) == 0)
+			break;
+
+	return p;
 }
 
-static ssize_t scst_trace_level_show(const struct scst_trace_log *local_tbl,
-	unsigned long log_level, char *buf, const char *help)
+static ssize_t scst_debugfs_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
 {
-	int pos = 0;
+	struct scst_trace_data *td = file->private_data;
+	const char *name = file->f_dentry->d_name.name;
+	struct scst_trace_log *p;
+	char contents[3];
+	int len;
+	ssize_t result;
 
-	scst_read_trace_tbl(scst_trace_tbl, buf, log_level, &pos);
-	scst_read_trace_tbl(local_tbl, buf, log_level, &pos);
+	p = scst_lookup_token(td, name);
+	len = scnprintf(contents, sizeof(contents), "%d\n",
+			(*td->trace_flags & p->val) != 0);
+	if (*ppos > len)
+		return -EINVAL;
+	result = min_t(ssize_t, count, len - *ppos);
+	copy_to_user(buf, contents + *ppos, result);
+	*ppos += result;
+	return result;
+}
 
-	pos += sprintf(&buf[pos], "\n\n\nUsage:\n"
-		"	echo \"all|none|default\" >trace_level\n"
-		"	echo \"value DEC|0xHEX|0OCT\" >trace_level\n"
-		"	echo \"add|del TOKEN\" >trace_level\n"
-		"\nwhere TOKEN is one of [debug, function, line, pid,\n"
-		"		       buff, mem, sg, out_of_mem,\n"
-		"		       special, scsi, mgmt, minor,\n"
-		"		       mgmt_dbg, scsi_serializing,\n"
-		"		       retry, recv_bot, send_bot, recv_top, pr,\n"
-		"		       send_top%s]\n", help != NULL ? help : "");
+static ssize_t scst_debugfs_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct scst_trace_data *td = file->private_data;
+	const char *name = file->f_dentry->d_name.name;
+	struct scst_trace_log *p;
+	unsigned long newval;
+	char input[8];
+	int res;
 
-	return pos;
+	copy_from_user(input, buf, min(count, sizeof(input)));
+	res = strict_strtoul(input, 0, &newval);
+	if (res)
+		return res;
+
+	p = scst_lookup_token(td, name);
+	*td->trace_flags = (*td->trace_flags & ~p->val) | (newval ? p->val : 0);
+	*ppos += count;
+	return count;
 }
 
-static int scst_write_trace(const char *buf, size_t length,
-	unsigned long *log_level, unsigned long default_level,
-	const char *name, const struct scst_trace_log *tbl)
+static int scst_debugfs_open(struct inode *inode, struct file *file)
 {
-	int res = length;
-	int action;
-	unsigned long level = 0, oldlevel;
-	char *buffer, *p, *e;
-	const struct scst_trace_log *t;
-	enum {
-		SCST_TRACE_ACTION_ALL	  = 1,
-		SCST_TRACE_ACTION_NONE	  = 2,
-		SCST_TRACE_ACTION_DEFAULT = 3,
-		SCST_TRACE_ACTION_ADD	  = 4,
-		SCST_TRACE_ACTION_DEL	  = 5,
-		SCST_TRACE_ACTION_VALUE	  = 6,
-	};
+	if (inode->i_private)
+		file->private_data = inode->i_private;
 
-	lockdep_assert_held(&scst_log_mutex);
+	return 0;
+}
 
-	if ((buf == NULL) || (length == 0)) {
-		res = -EINVAL;
-		goto out;
-	}
+static struct file_operations scst_debugfs_fops = {
+	.read	=	scst_debugfs_read_file,
+	.write	=	scst_debugfs_write_file,
+	.open	=	scst_debugfs_open,
+	.llseek	=	noop_llseek,
+};
 
-	buffer = kasprintf(GFP_KERNEL, "%.*s", (int)length, buf);
-	if (buffer == NULL) {
-		PRINT_ERROR("Unable to alloc intermediate buffer (size %zd)",
-			length+1);
-		res = -ENOMEM;
-		goto out;
-	}
+static struct dentry *scst_create_trace_files(struct dentry *root,
+					      const char *dir_name,
+					      struct scst_trace_data *td)
+{
+	int i;
+	struct dentry *subdir, *tracing_dir, *file;
+	const struct scst_trace_log *p;
+	const struct scst_trace_log *tracing_table[] = {
+		scst_trace_tbl,
+		td->trace_tbl,
+	};
 
-	TRACE_DBG("buffer %s", buffer);
+	BUG_ON(!root);
+	BUG_ON(!dir_name);
+	BUG_ON(!td);
 
-	p = buffer;
-	if (!strncasecmp("all", p, 3)) {
-		action = SCST_TRACE_ACTION_ALL;
-	} else if (!strncasecmp("none", p, 4) || !strncasecmp("null", p, 4)) {
-		action = SCST_TRACE_ACTION_NONE;
-	} else if (!strncasecmp("default", p, 7)) {
-		action = SCST_TRACE_ACTION_DEFAULT;
-	} else if (!strncasecmp("add", p, 3)) {
-		p += 3;
-		action = SCST_TRACE_ACTION_ADD;
-	} else if (!strncasecmp("del", p, 3)) {
-		p += 3;
-		action = SCST_TRACE_ACTION_DEL;
-	} else if (!strncasecmp("value", p, 5)) {
-		p += 5;
-		action = SCST_TRACE_ACTION_VALUE;
-	} else {
-		if (p[strlen(p) - 1] == '\n')
-			p[strlen(p) - 1] = '\0';
-		PRINT_ERROR("Unknown action \"%s\"", p);
-		res = -EINVAL;
-		goto out_free;
+	subdir = debugfs_create_dir(dir_name, root);
+	if (!subdir) {
+		PRINT_ERROR("Creation of directory %s failed", dir_name);
+		goto out;
 	}
 
-	switch (action) {
-	case SCST_TRACE_ACTION_ADD:
-	case SCST_TRACE_ACTION_DEL:
-	case SCST_TRACE_ACTION_VALUE:
-		if (!isspace(*p)) {
-			PRINT_ERROR("%s", "Syntax error");
-			res = -EINVAL;
-			goto out_free;
-		}
+	tracing_dir = debugfs_create_dir("tracing", subdir);
+	if (!tracing_dir) {
+		PRINT_ERROR("%s", "Creation of tracing dir failed");
+		goto err;
 	}
 
-	switch (action) {
-	case SCST_TRACE_ACTION_ALL:
-		level = TRACE_ALL;
-		break;
-	case SCST_TRACE_ACTION_DEFAULT:
-		level = default_level;
-		break;
-	case SCST_TRACE_ACTION_NONE:
-		level = TRACE_NULL;
-		break;
-	case SCST_TRACE_ACTION_ADD:
-	case SCST_TRACE_ACTION_DEL:
-		while (isspace(*p) && *p != '\0')
-			p++;
-		e = p;
-		while (!isspace(*e) && *e != '\0')
-			e++;
-		*e = 0;
-		if (tbl) {
-			t = tbl;
-			while (t->token) {
-				if (!strcasecmp(p, t->token)) {
-					level = t->val;
-					break;
-				}
-				t++;
+	for (i = 0; i < ARRAY_SIZE(tracing_table); ++i) {
+		for (p = tracing_table[i]; p && p->val; ++p) {
+			file = debugfs_create_file(p->token, S_IRUGO | S_IWUSR,
+						   tracing_dir, td,
+						   &scst_debugfs_fops);
+			if (!file) {
+				PRINT_ERROR("Creation of tracing file %s"
+					    "failed", p->token);
+				goto err;
 			}
 		}
-		if (level == 0) {
-			t = scst_trace_tbl;
-			while (t->token) {
-				if (!strcasecmp(p, t->token)) {
-					level = t->val;
-					break;
-				}
-				t++;
-			}
-		}
-		if (level == 0) {
-			PRINT_ERROR("Unknown token \"%s\"", p);
-			res = -EINVAL;
-			goto out_free;
-		}
-		break;
-	case SCST_TRACE_ACTION_VALUE:
-		while (isspace(*p) && *p != '\0')
-			p++;
-		res = strict_strtoul(p, 0, &level);
-		if (res != 0) {
-			PRINT_ERROR("Invalid trace value \"%s\"", p);
-			res = -EINVAL;
-			goto out_free;
-		}
-		break;
-	}
-
-	oldlevel = *log_level;
-
-	switch (action) {
-	case SCST_TRACE_ACTION_ADD:
-		*log_level |= level;
-		break;
-	case SCST_TRACE_ACTION_DEL:
-		*log_level &= ~level;
-		break;
-	default:
-		*log_level = level;
-		break;
 	}
-
-	PRINT_INFO("Changed trace level for \"%s\": old 0x%08lx, new 0x%08lx",
-		name, oldlevel, *log_level);
-
-out_free:
-	kfree(buffer);
 out:
-	return res;
+	return subdir;
+err:
+	debugfs_remove_recursive(subdir);
+	subdir = NULL;
+	goto out;
+}
+
+static void scst_remove_trace_files(struct dentry *dir)
+{
+	debugfs_remove_recursive(dir);
 }
 
 #endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
@@ -472,46 +411,6 @@ static struct scst_acg *__scst_lookup_acg(const struct scst_tgt *tgt,
  ** Target Template
  **/
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-
-static ssize_t scst_tgtt_trace_level_show(struct device_driver *drv, char *buf)
-{
-	struct scst_tgt_template *tgtt;
-
-	tgtt = scst_drv_to_tgtt(drv);
-
-	return scst_trace_level_show(tgtt->trace_tbl,
-		tgtt->trace_flags ? *tgtt->trace_flags : 0, buf,
-		tgtt->trace_tbl_help);
-}
-
-static ssize_t scst_tgtt_trace_level_store(struct device_driver *drv,
-					   const char *buf, size_t count)
-{
-	int res;
-	struct scst_tgt_template *tgtt;
-
-	tgtt = scst_drv_to_tgtt(drv);
-
-	res = mutex_lock_interruptible(&scst_log_mutex);
-	if (res != 0)
-		goto out;
-
-	res = scst_write_trace(buf, count, tgtt->trace_flags,
-		tgtt->default_trace_flags, tgtt->name, tgtt->trace_tbl);
-
-	mutex_unlock(&scst_log_mutex);
-
-out:
-	return res;
-}
-
-static struct driver_attribute tgtt_trace_attr =
-	__ATTR(trace_level, S_IRUGO | S_IWUSR,
-	       scst_tgtt_trace_level_show, scst_tgtt_trace_level_store);
-
-#endif /* #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
-
 /**
  * scst_tgtt_add_target_show() - Whether the add_target method is supported.
  */
@@ -708,12 +607,14 @@ int scst_tgtt_sysfs_create(struct scst_tgt_template *tgtt)
 	}
 
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	if (tgtt->trace_flags != NULL) {
-		res = driver_create_file(scst_sysfs_get_tgtt_drv(tgtt),
-					 &tgtt_trace_attr);
-		if (res != 0) {
-			PRINT_ERROR("Can't add trace_flag for target "
-				"driver %s", tgtt->name);
+	if (tgtt->trace_data.trace_flags) {
+		res = -EINVAL;
+		tgtt->tracing_dir = scst_create_trace_files(scst_debug_target,
+							    tgtt->name,
+							    &tgtt->trace_data);
+		if (!tgtt->tracing_dir) {
+			PRINT_ERROR("Can't create tracing files for target "
+				    "driver %s", tgtt->name);
 			goto out_del;
 		}
 	}
@@ -730,6 +631,8 @@ out_del:
 
 void scst_tgtt_sysfs_del(struct scst_tgt_template *tgtt)
 {
+	scst_remove_trace_files(tgtt->tracing_dir);
+	tgtt->tracing_dir = NULL;
 	driver_unregister(&tgtt->tgtt_drv);
 }
 
@@ -3136,46 +3039,6 @@ out:
  ** Dev handlers
  **/
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-
-static ssize_t scst_devt_trace_level_show(struct device_driver *drv, char *buf)
-{
-	struct scst_dev_type *devt;
-
-	devt = scst_drv_to_devt(drv);
-
-	return scst_trace_level_show(devt->trace_tbl,
-		devt->trace_flags ? *devt->trace_flags : 0, buf,
-		devt->trace_tbl_help);
-}
-
-static ssize_t scst_devt_trace_level_store(struct device_driver *drv,
-					   const char *buf, size_t count)
-{
-	int res;
-	struct scst_dev_type *devt;
-
-	devt = scst_drv_to_devt(drv);
-
-	res = mutex_lock_interruptible(&scst_log_mutex);
-	if (res != 0)
-		goto out;
-
-	res = scst_write_trace(buf, count, devt->trace_flags,
-		devt->default_trace_flags, devt->name, devt->trace_tbl);
-
-	mutex_unlock(&scst_log_mutex);
-
-out:
-	return res;
-}
-
-static struct driver_attribute devt_trace_attr =
-	__ATTR(trace_level, S_IRUGO | S_IWUSR,
-	       scst_devt_trace_level_show, scst_devt_trace_level_store);
-
-#endif /* #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
-
 static ssize_t scst_devt_type_show(struct device_driver *drv, char *buf)
 {
 	int pos;
@@ -3506,12 +3369,14 @@ int scst_devt_sysfs_create(struct scst_dev_type *devt)
 	}
 
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	if (devt->trace_flags) {
-		res = driver_create_file(scst_sysfs_get_devt_drv(devt),
-					 &devt_trace_attr);
-		if (res != 0) {
-			PRINT_ERROR("Can't add devt trace_flag for dev "
-				"handler %s", devt->name);
+	if (devt->trace_data.trace_flags) {
+		res = -EINVAL;
+		devt->tracing_dir = scst_create_trace_files(scst_debug_tgt_dev,
+							    devt->name,
+							    &devt->trace_data);
+		if (!devt->tracing_dir) {
+			PRINT_ERROR("Can't create tracing files for device "
+				    "type %s", devt->name);
 			goto out_err;
 		}
 	}
@@ -3527,6 +3392,8 @@ out_err:
 
 void scst_devt_sysfs_del(struct scst_dev_type *devt)
 {
+	scst_remove_trace_files(devt->tracing_dir);
+	devt->tracing_dir = NULL;
 }
 
 void scst_devt_sysfs_put(struct scst_dev_type *devt)
@@ -3918,30 +3785,23 @@ out:
 
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
 
-static ssize_t scst_main_trace_level_show(struct device *device,
-				struct device_attribute *attr, char *buf)
-{
-	return scst_trace_level_show(scst_local_trace_tbl, trace_flag,
-			buf, NULL);
-}
-
-static ssize_t scst_main_trace_level_store(struct device *device,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	int res;
-
-	res = mutex_lock_interruptible(&scst_log_mutex);
-	if (res != 0)
-		goto out;
-
-	res = scst_write_trace(buf, count, &trace_flag,
-		SCST_DEFAULT_LOG_FLAGS, "scst", scst_local_trace_tbl);
+static struct scst_trace_log scst_local_trace_tbl[] = {
+	{ TRACE_RTRY,			"retry"			},
+	{ TRACE_SCSI_SERIALIZING,	"scsi_serializing"	},
+	{ TRACE_RCV_BOT,		"recv_bot"		},
+	{ TRACE_SND_BOT,		"send_bot"		},
+	{ TRACE_RCV_TOP,		"recv_top"		},
+	{ TRACE_SND_TOP,		"send_top"		},
+	{ 0,				NULL			}
+};
 
-	mutex_unlock(&scst_log_mutex);
+static struct scst_trace_data scst_main_trace_data = {
+	.default_trace_flags	= SCST_DEFAULT_LOG_FLAGS,
+	.trace_flags		= &trace_flag,
+	.trace_tbl		= scst_local_trace_tbl,
+};
 
-out:
-	return res;
-}
+static struct dentry *scst_main_tracing_dir;
 
 #endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
 
@@ -4007,12 +3867,6 @@ static struct device_attribute scst_setup_id_attr =
 	__ATTR(setup_id, S_IRUGO | S_IWUSR, scst_setup_id_show,
 	       scst_setup_id_store);
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-static struct device_attribute scst_main_trace_level_attr =
-	__ATTR(trace_level, S_IRUGO | S_IWUSR, scst_main_trace_level_show,
-	       scst_main_trace_level_store);
-#endif
-
 static struct device_attribute scst_version_attr =
 	__ATTR(version, S_IRUGO, scst_version_show, NULL);
 
@@ -4020,9 +3874,6 @@ static const struct device_attribute *scst_root_default_attrs[] = {
 	&scst_mgmt_attr,
 	&scst_threads_attr,
 	&scst_setup_id_attr,
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	&scst_main_trace_level_attr,
-#endif
 	&scst_version_attr,
 	NULL
 };
@@ -4222,6 +4073,64 @@ out:
 }
 EXPORT_SYMBOL_GPL(scst_wait_info_completion);
 
+#if (defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)) \
+	&& defined(CONFIG_DEBUG_FS)
+
+static int scst_debugfs_init(void)
+{
+	int res;
+
+	res = -ENOMEM;
+	scst_debug_root = debugfs_create_dir("scst", NULL);
+	if (!scst_debug_root) {
+		PRINT_ERROR("Creation of /sys/kernel/debug/scst failed (%d)",
+			    res);
+		goto out;
+	}
+
+	scst_debug_target = debugfs_create_dir("target", scst_debug_root);
+	if (!scst_debug_target) {
+		PRINT_ERROR("Creation of /sys/kernel/debug/scst/target failed"
+			    " (%d)", res);
+		goto out;
+	}
+
+	scst_debug_tgt_dev = debugfs_create_dir("tgt_dev", scst_debug_root);
+	if (!scst_debug_tgt_dev) {
+		PRINT_ERROR("Creation of /sys/kernel/debug/scst/tgt_dev failed"
+			    " (%d)", res);
+		goto out;
+	}
+
+	res = 0;
+
+out:
+	return res;
+}
+
+static void scst_debugfs_cleanup(void)
+{
+	debugfs_remove_recursive(scst_debug_root);
+	scst_debug_tgt_dev = NULL;
+	scst_debug_target = NULL;
+	scst_debug_root = NULL;
+}
+
+#else /*(defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING))
+	&& defined(CONFIG_DEBUG_FS)*/
+
+static int scst_debugfs_init(void)
+{
+	return 0;
+}
+
+static void scst_debugfs_cleanup(void)
+{
+}
+
+#endif /*(defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING))
+	 && defined(CONFIG_DEBUG_FS)*/
+
 static int scst_target_bus_match(struct device *dev, struct device_driver *drv)
 {
 	struct scst_tgt *tgt = scst_dev_to_tgt(dev);
@@ -4246,10 +4155,14 @@ int __init scst_sysfs_init(void)
 {
 	int res;
 
-	res = bus_register(&scst_target_bus);
+	res = scst_debugfs_init();
 	if (res)
 		goto out;
 
+	res = bus_register(&scst_target_bus);
+	if (res)
+		goto out_cleanup_debugfs;
+
 	res = bus_register(&scst_device_bus);
 	if (res != 0)
 		goto out_unregister_target_bus;
@@ -4275,15 +4188,31 @@ int __init scst_sysfs_init(void)
 		goto out_unregister_device;
 	}
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	res = -EINVAL;
+	scst_main_tracing_dir = scst_create_trace_files(scst_debug_root,
+							"main",
+							&scst_main_trace_data);
+	if (!scst_main_tracing_dir) {
+		PRINT_ERROR("%s", "Creating SCST trace files failed.");
+		goto out_remove_files;
+	}
+#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
+
 	res = scst_add_sgv_kobj(&scst_device->kobj, "sgv");
 	if (res) {
 		PRINT_ERROR("%s", "Creation of SCST sgv kernel object failed.");
-		goto out_remove_files;
+		goto out_remove_trace_files;
 	}
 
 out:
 	return res;
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+out_remove_trace_files:
+	scst_remove_trace_files(scst_main_tracing_dir);
+	scst_main_tracing_dir = NULL;
+#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
 out_remove_files:
 	device_remove_files(scst_device, scst_root_default_attrs);
 out_unregister_device:
@@ -4295,6 +4224,8 @@ out_unregister_device_bus:
 	bus_unregister(&scst_device_bus);
 out_unregister_target_bus:
 	bus_unregister(&scst_target_bus);
+out_cleanup_debugfs:
+	scst_debugfs_cleanup();
 	goto out;
 }
 
@@ -4304,6 +4235,11 @@ void scst_sysfs_cleanup(void)
 
 	scst_del_put_sgv_kobj();
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	scst_remove_trace_files(scst_main_tracing_dir);
+	scst_main_tracing_dir = NULL;
+#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
+
 	device_remove_files(scst_device, scst_root_default_attrs);
 
 	device_unregister(scst_device);
@@ -4312,6 +4248,8 @@ void scst_sysfs_cleanup(void)
 
 	bus_unregister(&scst_target_bus);
 
+	scst_debugfs_cleanup();
+
 	/*
 	 * Wait until the release method of the sysfs root object has returned.
 	 */
diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 6d45cf4..be3ed5d 100644
--- a/drivers/scst/srpt/ib_srpt.c
+++ b/drivers/scst/srpt/ib_srpt.c
@@ -3313,8 +3313,10 @@ static struct scst_tgt_template srpt_template = {
 	.tgt_attrs			 = srpt_tgt_attrs,
 	.sess_attrs			 = srpt_sess_attrs,
 #if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	.default_trace_flags		 = DEFAULT_SRPT_TRACE_FLAGS,
-	.trace_flags			 = &trace_flag,
+	.trace_data = {
+		.default_trace_flags		 = DEFAULT_SRPT_TRACE_FLAGS,
+		.trace_flags			 = &trace_flag,
+	},
 #endif
 	.detect				 = srpt_detect,
 	.release			 = srpt_release,
diff --git a/include/scst/scst.h b/include/scst/scst.h
index 188832a..d2e9f12 100644
--- a/include/scst/scst.h
+++ b/include/scst/scst.h
@@ -478,6 +478,7 @@ struct scst_acg;
 struct scst_acg_dev;
 struct scst_acn;
 struct scst_aen;
+struct scst_trace_log;
 
 /*
  * SCST uses 64-bit numbers to represent LUN's internally. The value
@@ -487,6 +488,20 @@ struct scst_aen;
 
 typedef enum dma_data_direction scst_data_direction;
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+/**
+ * struct scst_trace_data - Tracing-related data.
+ * @default_trace_flags: Default trace flags.
+ * @trace_flags: Actual trace flags.
+ * @trace_tbl: Table with values and names of additional tracing flags.
+ */
+struct scst_trace_data {
+	const unsigned long	 default_trace_flags;
+	unsigned long		*trace_flags;
+	struct scst_trace_log	*trace_tbl;
+};
+#endif
+
 /*
  * SCST target template: defines target driver's parameters and callback
  * functions.
@@ -859,17 +874,10 @@ struct scst_tgt_template {
 	 */
 	int threads_num;
 
-	/* Optional default log flags */
-	const unsigned long default_trace_flags;
-
-	/* Optional pointer to trace flags */
-	unsigned long *trace_flags;
-
-	/* Optional local trace table */
-	struct scst_trace_log *trace_tbl;
-
-	/* Optional local trace table help string */
-	const char *trace_tbl_help;
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct scst_trace_data trace_data;
+	struct dentry *tracing_dir;
+#endif
 
 	/* sysfs attributes, if any */
 	const struct driver_attribute **tgtt_attrs;
@@ -1210,17 +1218,10 @@ struct scst_dev_type {
 	/* Threads pool type. Valid only if threads_num > 0. */
 	enum scst_dev_type_threads_pool_type threads_pool_type;
 
-	/* Optional default log flags */
-	const unsigned long default_trace_flags;
-
-	/* Optional pointer to trace flags */
-	unsigned long *trace_flags;
-
-	/* Optional local trace table */
-	struct scst_trace_log *trace_tbl;
-
-	/* Optional local trace table help string */
-	const char *trace_tbl_help;
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct scst_trace_data trace_data;
+	struct dentry *tracing_dir;
+#endif
 
 	/* Optional help string for mgmt_cmd commands */
 	const char *mgmt_cmd_help;
-- 
1.7.1

