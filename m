From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [SCSI] scst: Move tracing to debugfs
Date: Mon, 27 Dec 2010 13:46:14 +0100
Message-ID: <201012271346.15034.bvanassche@acm.org>
References: <201012231615.11691.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:45765 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753686Ab0L0Mqr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 07:46:47 -0500
In-Reply-To: <201012231615.11691.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

On Thursday 23 December 2010 16:15:11 Bart Van Assche wrote:
> The trace_level files created in sysfs by the SCST core are mostly
> used for debugging purposes, hence move these to debugfs.

[  ... ]

Note: this patch has been reworked such that not only the trace_level files
are moved from sysfs to debugfs but also the dump_pr file is moved (a
trigger to dump persistent reservation debug info) and such that there are no
more tests on the preprocessor symbols CONFIG_SCST_TRACING / CONFIG_SCST_DEBUG
in scst_sysfs.c:

[PATCH] [SCSI] scst: Move tracing to debugfs

The trace_level and dump_pr files created in sysfs by the SCST core are
mostly used for debugging purposes, hence move these to debugfs. Also
instead of using one file for all tracing flags of a driver use one file
per tracing flag. An example of the new hierarchy:

$ cd /sys/kernel/debug/scst && find -type f | cut -c3- | sort
device/disk01/dump_pr
device/disk02/dump_pr
device/disk03/dump_pr
device/disk04/dump_pr
device/disk05/dump_pr
device/disk06/dump_pr
device/disk07/dump_pr
device/disk08/dump_pr
device/disk09/dump_pr
device/disk10/dump_pr
device/disk11/dump_pr
device_type/dev_disk/tracing/buff
device_type/dev_disk/tracing/debug
device_type/dev_disk/tracing/flow_control
device_type/dev_disk/tracing/function
device_type/dev_disk/tracing/line
device_type/dev_disk/tracing/mem
device_type/dev_disk/tracing/mgmt
device_type/dev_disk/tracing/mgmt_dbg
device_type/dev_disk/tracing/minor
device_type/dev_disk/tracing/out_of_mem
device_type/dev_disk/tracing/pid
device_type/dev_disk/tracing/pr
device_type/dev_disk/tracing/scsi
device_type/dev_disk/tracing/sg
device_type/dev_disk/tracing/special
device_type/dev_disk_perf/tracing/buff
device_type/dev_disk_perf/tracing/debug
device_type/dev_disk_perf/tracing/flow_control
device_type/dev_disk_perf/tracing/function
device_type/dev_disk_perf/tracing/line
device_type/dev_disk_perf/tracing/mem
device_type/dev_disk_perf/tracing/mgmt
device_type/dev_disk_perf/tracing/mgmt_dbg
device_type/dev_disk_perf/tracing/minor
device_type/dev_disk_perf/tracing/out_of_mem
device_type/dev_disk_perf/tracing/pid
device_type/dev_disk_perf/tracing/pr
device_type/dev_disk_perf/tracing/scsi
device_type/dev_disk_perf/tracing/sg
device_type/dev_disk_perf/tracing/special
device_type/vcdrom/tracing/buff
device_type/vcdrom/tracing/debug
device_type/vcdrom/tracing/flow_control
device_type/vcdrom/tracing/function
device_type/vcdrom/tracing/line
device_type/vcdrom/tracing/mem
device_type/vcdrom/tracing/mgmt
device_type/vcdrom/tracing/mgmt_dbg
device_type/vcdrom/tracing/minor
device_type/vcdrom/tracing/order
device_type/vcdrom/tracing/out_of_mem
device_type/vcdrom/tracing/pid
device_type/vcdrom/tracing/pr
device_type/vcdrom/tracing/scsi
device_type/vcdrom/tracing/sg
device_type/vcdrom/tracing/special
device_type/vdisk_blockio/tracing/buff
device_type/vdisk_blockio/tracing/debug
device_type/vdisk_blockio/tracing/flow_control
device_type/vdisk_blockio/tracing/function
device_type/vdisk_blockio/tracing/line
device_type/vdisk_blockio/tracing/mem
device_type/vdisk_blockio/tracing/mgmt
device_type/vdisk_blockio/tracing/mgmt_dbg
device_type/vdisk_blockio/tracing/minor
device_type/vdisk_blockio/tracing/order
device_type/vdisk_blockio/tracing/out_of_mem
device_type/vdisk_blockio/tracing/pid
device_type/vdisk_blockio/tracing/pr
device_type/vdisk_blockio/tracing/scsi
device_type/vdisk_blockio/tracing/sg
device_type/vdisk_blockio/tracing/special
device_type/vdisk_fileio/tracing/buff
device_type/vdisk_fileio/tracing/debug
device_type/vdisk_fileio/tracing/flow_control
device_type/vdisk_fileio/tracing/function
device_type/vdisk_fileio/tracing/line
device_type/vdisk_fileio/tracing/mem
device_type/vdisk_fileio/tracing/mgmt
device_type/vdisk_fileio/tracing/mgmt_dbg
device_type/vdisk_fileio/tracing/minor
device_type/vdisk_fileio/tracing/order
device_type/vdisk_fileio/tracing/out_of_mem
device_type/vdisk_fileio/tracing/pid
device_type/vdisk_fileio/tracing/pr
device_type/vdisk_fileio/tracing/scsi
device_type/vdisk_fileio/tracing/sg
device_type/vdisk_fileio/tracing/special
device_type/vdisk_nullio/tracing/buff
device_type/vdisk_nullio/tracing/debug
device_type/vdisk_nullio/tracing/flow_control
device_type/vdisk_nullio/tracing/function
device_type/vdisk_nullio/tracing/line
device_type/vdisk_nullio/tracing/mem
device_type/vdisk_nullio/tracing/mgmt
device_type/vdisk_nullio/tracing/mgmt_dbg
device_type/vdisk_nullio/tracing/minor
device_type/vdisk_nullio/tracing/order
device_type/vdisk_nullio/tracing/out_of_mem
device_type/vdisk_nullio/tracing/pid
device_type/vdisk_nullio/tracing/pr
device_type/vdisk_nullio/tracing/scsi
device_type/vdisk_nullio/tracing/sg
device_type/vdisk_nullio/tracing/special
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

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scst/Kconfig                       |    4 +-
 drivers/scst/Makefile                      |    2 +
 drivers/scst/dev_handlers/scst_cdrom.c     |    6 +-
 drivers/scst/dev_handlers/scst_changer.c   |    6 +-
 drivers/scst/dev_handlers/scst_disk.c      |   12 +-
 drivers/scst/dev_handlers/scst_modisk.c    |   12 +-
 drivers/scst/dev_handlers/scst_processor.c |    6 +-
 drivers/scst/dev_handlers/scst_raid.c      |    6 +-
 drivers/scst/dev_handlers/scst_tape.c      |   12 +-
 drivers/scst/dev_handlers/scst_vdisk.c     |   38 ++--
 drivers/scst/scst_local/scst_local.c       |    6 +-
 drivers/scst/scst_sysfs.c                  |  443 +++-------------------------
 drivers/scst/scst_tracing.c                |  369 +++++++++++++++++++++++
 drivers/scst/scst_tracing.h                |   63 ++++
 drivers/scst/srpt/ib_srpt.c                |    6 +-
 include/scst/scst.h                        |   49 ++--
 16 files changed, 577 insertions(+), 463 deletions(-)
 create mode 100644 drivers/scst/scst_tracing.c
 create mode 100644 drivers/scst/scst_tracing.h

diff --git a/drivers/scst/Kconfig b/drivers/scst/Kconfig
index 2d0a595..2132b3f 100644
--- a/drivers/scst/Kconfig
+++ b/drivers/scst/Kconfig
@@ -151,7 +151,7 @@ config SCST_EXTRACHECKS
 
 config SCST_TRACING
 	bool "Tracing support"
-	depends on SCST
+	depends on SCST && DEBUG_FS
 	default y
 	help
 	  Enable SCSI middle level tracing support. Tracing can be controlled
@@ -163,7 +163,7 @@ config SCST_TRACING
 
 config SCST_DEBUG
 	bool "Debugging support"
-	depends on SCST
+	depends on SCST && DEBUG_FS
 	select DEBUG_BUGVERBOSE
 	help
 	  Enables support for debugging SCST. This may be helpful for SCST
diff --git a/drivers/scst/Makefile b/drivers/scst/Makefile
index 139df8b..38b3f4e 100644
--- a/drivers/scst/Makefile
+++ b/drivers/scst/Makefile
@@ -7,5 +7,7 @@ scst-y        += scst_lib.o
 scst-y        += scst_sysfs.o
 scst-y        += scst_mem.o
 scst-y        += scst_debug.o
+scst-$(CONFIG_SCST_DEBUG)	+= scst_tracing.o
+scst-$(CONFIG_SCST_TRACING)	+= scst_tracing.o
 
 obj-$(CONFIG_SCST)   += scst.o dev_handlers/ scst_local/ srpt/
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
index 36cb85d..932840a 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -44,7 +44,7 @@
 #include <scst/scst.h>
 #include "scst_priv.h"
 #include "scst_mem.h"
-#include "scst_pres.h"
+#include "scst_tracing.h"
 
 enum mgmt_path_type {
 	PATH_NOT_RECOGNIZED,
@@ -81,232 +81,6 @@ static const char *scst_dev_handler_types[] = {
 	"Optical card reader/writer device"
 };
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-
-static DEFINE_MUTEX(scst_log_mutex);
-
-static struct scst_trace_log scst_trace_tbl[] = {
-	{ TRACE_OUT_OF_MEM,	"out_of_mem"	},
-	{ TRACE_MINOR,		"minor"		},
-	{ TRACE_SG_OP,		"sg"		},
-	{ TRACE_MEMORY,		"mem"		},
-	{ TRACE_BUFF,		"buff"		},
-	{ TRACE_PID,		"pid"		},
-	{ TRACE_LINE,		"line"		},
-	{ TRACE_FUNCTION,	"function"	},
-	{ TRACE_DEBUG,		"debug"		},
-	{ TRACE_SPECIAL,	"special"	},
-	{ TRACE_SCSI,		"scsi"		},
-	{ TRACE_MGMT,		"mgmt"		},
-	{ TRACE_MGMT_DEBUG,	"mgmt_dbg"	},
-	{ TRACE_FLOW_CONTROL,	"flow_control"	},
-	{ TRACE_PRES,		"pr"		},
-	{ 0,			NULL		}
-};
-
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
-{
-	const struct scst_trace_log *t = tbl;
-
-	if (t == NULL)
-		goto out;
-
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
-}
-
-static ssize_t scst_trace_level_show(const struct scst_trace_log *local_tbl,
-	unsigned long log_level, char *buf, const char *help)
-{
-	int pos = 0;
-
-	scst_read_trace_tbl(scst_trace_tbl, buf, log_level, &pos);
-	scst_read_trace_tbl(local_tbl, buf, log_level, &pos);
-
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
-
-	return pos;
-}
-
-static int scst_write_trace(const char *buf, size_t length,
-	unsigned long *log_level, unsigned long default_level,
-	const char *name, const struct scst_trace_log *tbl)
-{
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
-
-	lockdep_assert_held(&scst_log_mutex);
-
-	if ((buf == NULL) || (length == 0)) {
-		res = -EINVAL;
-		goto out;
-	}
-
-	buffer = kasprintf(GFP_KERNEL, "%.*s", (int)length, buf);
-	if (buffer == NULL) {
-		PRINT_ERROR("Unable to alloc intermediate buffer (size %zd)",
-			length+1);
-		res = -ENOMEM;
-		goto out;
-	}
-
-	TRACE_DBG("buffer %s", buffer);
-
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
-	}
-
-	switch (action) {
-	case SCST_TRACE_ACTION_ADD:
-	case SCST_TRACE_ACTION_DEL:
-	case SCST_TRACE_ACTION_VALUE:
-		if (!isspace(*p)) {
-			PRINT_ERROR("%s", "Syntax error");
-			res = -EINVAL;
-			goto out_free;
-		}
-	}
-
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
-			}
-		}
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
-	}
-
-	PRINT_INFO("Changed trace level for \"%s\": old 0x%08lx, new 0x%08lx",
-		name, oldlevel, *log_level);
-
-out_free:
-	kfree(buffer);
-out:
-	return res;
-}
-
-#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
-
 static int device_create_files(struct device *dev,
 			       const struct device_attribute **ptr)
 {
@@ -472,46 +246,6 @@ static struct scst_acg *__scst_lookup_acg(const struct scst_tgt *tgt,
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
@@ -707,18 +441,12 @@ int scst_tgtt_sysfs_create(struct scst_tgt_template *tgtt)
 		}
 	}
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	if (tgtt->trace_flags != NULL) {
-		res = driver_create_file(scst_sysfs_get_tgtt_drv(tgtt),
-					 &tgtt_trace_attr);
-		if (res != 0) {
-			PRINT_ERROR("Can't add trace_flag for target "
-				"driver %s", tgtt->name);
-			goto out_del;
-		}
+	res = scst_tgtt_create_trace_files(tgtt);
+	if (res) {
+		PRINT_ERROR("Can't create tracing files for target driver %s",
+			    tgtt->name);
+		goto out_del;
 	}
-#endif
-	res = 0;
 
 out:
 	return res;
@@ -730,6 +458,7 @@ out_del:
 
 void scst_tgtt_sysfs_del(struct scst_tgt_template *tgtt)
 {
+	scst_tgtt_remove_trace_files(tgtt);
 	driver_unregister(&tgtt->tgtt_drv);
 }
 
@@ -1373,25 +1102,6 @@ static ssize_t scst_dev_sysfs_type_show(struct device *device,
 	return pos;
 }
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-
-static ssize_t scst_dev_sysfs_dump_prs(struct device *device,
-	struct device_attribute *attr, const char *buf, size_t count)
-{
-	ssize_t res;
-	struct scst_device *dev;
-
-	dev = scst_dev_to_dev(device);
-	scst_pr_dump_prs(dev, true);
-	res = count;
-	return res;
-}
-
-static struct device_attribute dev_dump_prs_attr =
-	__ATTR(dump_prs, S_IWUSR, NULL, scst_dev_sysfs_dump_prs);
-
-#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
-
 static int scst_process_dev_sysfs_threads_data_store(
 	struct scst_device *dev, int threads_num,
 	enum scst_dev_type_threads_pool_type threads_pool_type)
@@ -1679,6 +1389,15 @@ int scst_devt_dev_sysfs_create(struct scst_device *dev)
 		}
 	}
 
+	if (!dev->scsi_dev) {
+		res = scst_dev_create_debug_files(dev);
+		if (res) {
+			PRINT_ERROR("Can't create debug files for dev %s",
+				    dev->virt_name);
+			goto out_err;
+		}
+	}
+
 out:
 	return res;
 
@@ -1728,18 +1447,14 @@ int scst_dev_sysfs_create(struct scst_device *dev)
 		goto out_del;
 	}
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
 	if (!dev->scsi_dev) {
-		res = device_create_file(scst_sysfs_get_dev_dev(dev),
-					 &dev_dump_prs_attr);
-		if (res != 0) {
-			PRINT_ERROR("Can't create attr %s for dev %s",
-				    dev_dump_prs_attr.attr.name,
+		res = scst_dev_create_debug_files(dev);
+		if (res) {
+			PRINT_ERROR("Can't create debug files for dev %s",
 				    dev->virt_name);
 			goto out_del;
 		}
 	}
-#endif
 
 out:
 	return res;
@@ -1757,9 +1472,7 @@ void scst_dev_sysfs_del(struct scst_device *dev)
 	BUG_ON(!dev->handler);
 
 	/* Pass-through device attributes. */
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	device_remove_file(scst_sysfs_get_dev_dev(dev), &dev_dump_prs_attr);
-#endif
+	scst_dev_remove_debug_files(dev);
 	device_remove_files(scst_sysfs_get_dev_dev(dev), scst_dev_attrs);
 
 	/* Virtual device attributes. */
@@ -3136,46 +2849,6 @@ out:
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
@@ -3505,17 +3178,12 @@ int scst_devt_sysfs_create(struct scst_dev_type *devt)
 		}
 	}
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	if (devt->trace_flags) {
-		res = driver_create_file(scst_sysfs_get_devt_drv(devt),
-					 &devt_trace_attr);
-		if (res != 0) {
-			PRINT_ERROR("Can't add devt trace_flag for dev "
-				"handler %s", devt->name);
-			goto out_err;
-		}
+	res = scst_devt_create_trace_files(devt);
+	if (res) {
+		PRINT_ERROR("Can't create tracing files for device type %s",
+			    devt->name);
+		goto out_err;
 	}
-#endif
 
 out:
 	return res;
@@ -3527,6 +3195,7 @@ out_err:
 
 void scst_devt_sysfs_del(struct scst_dev_type *devt)
 {
+	scst_devt_remove_trace_files(devt);
 }
 
 void scst_devt_sysfs_put(struct scst_dev_type *devt)
@@ -3916,35 +3585,6 @@ out:
 	return res;
 }
 
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-
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
-
-	mutex_unlock(&scst_log_mutex);
-
-out:
-	return res;
-}
-
-#endif /* defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING) */
-
 static ssize_t scst_version_show(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
@@ -4007,12 +3647,6 @@ static struct device_attribute scst_setup_id_attr =
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
 
@@ -4020,9 +3654,6 @@ static const struct device_attribute *scst_root_default_attrs[] = {
 	&scst_mgmt_attr,
 	&scst_threads_attr,
 	&scst_setup_id_attr,
-#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
-	&scst_main_trace_level_attr,
-#endif
 	&scst_version_attr,
 	NULL
 };
@@ -4246,10 +3877,14 @@ int __init scst_sysfs_init(void)
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
@@ -4275,15 +3910,23 @@ int __init scst_sysfs_init(void)
 		goto out_unregister_device;
 	}
 
+	res = scst_main_create_trace_files();
+	if (res) {
+		PRINT_ERROR("%s", "Creating SCST trace files failed.");
+		goto out_remove_files;
+	}
+
 	res = scst_add_sgv_kobj(&scst_device->kobj, "sgv");
 	if (res) {
 		PRINT_ERROR("%s", "Creation of SCST sgv kernel object failed.");
-		goto out_remove_files;
+		goto out_remove_trace_files;
 	}
 
 out:
 	return res;
 
+out_remove_trace_files:
+	scst_main_remove_trace_files();
 out_remove_files:
 	device_remove_files(scst_device, scst_root_default_attrs);
 out_unregister_device:
@@ -4295,6 +3938,8 @@ out_unregister_device_bus:
 	bus_unregister(&scst_device_bus);
 out_unregister_target_bus:
 	bus_unregister(&scst_target_bus);
+out_cleanup_debugfs:
+	scst_debugfs_cleanup();
 	goto out;
 }
 
@@ -4304,6 +3949,8 @@ void scst_sysfs_cleanup(void)
 
 	scst_del_put_sgv_kobj();
 
+	scst_main_remove_trace_files();
+
 	device_remove_files(scst_device, scst_root_default_attrs);
 
 	device_unregister(scst_device);
@@ -4312,6 +3959,8 @@ void scst_sysfs_cleanup(void)
 
 	bus_unregister(&scst_target_bus);
 
+	scst_debugfs_cleanup();
+
 	/*
 	 * Wait until the release method of the sysfs root object has returned.
 	 */
diff --git a/drivers/scst/scst_tracing.c b/drivers/scst/scst_tracing.c
new file mode 100644
index 0000000..b34c9c6
--- /dev/null
+++ b/drivers/scst/scst_tracing.c
@@ -0,0 +1,369 @@
+/*
+ *  scst_tracing.c
+ *
+ *  Copyright (C) 2010 Bart Van Assche <bvanassche@acm.org>
+ *  Copyright (C) 2009 - 2010 Vladislav Bolkhovitin <vst@vlnb.net>
+ *
+ *  This program is free software; you can redistribute it and/or
+ *  modify it under the terms of the GNU General Public License
+ *  as published by the Free Software Foundation, version 2
+ *  of the License.
+ *
+ *  This program is distributed in the hope that it will be useful,
+ *  but WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
+ *  GNU General Public License for more details.
+ */
+
+#include <linux/debugfs.h>
+#include <scst/scst.h>
+#include <scst/scst_debug.h>
+#include "scst_priv.h"
+#include "scst_pres.h"
+#include "scst_tracing.h"
+
+static struct dentry *scst_debug_root;
+static struct dentry *scst_debug_target;
+static struct dentry *scst_debug_devt;
+static struct dentry *scst_debug_dev;
+static struct dentry *scst_main_tracing_dir;
+static DEFINE_MUTEX(scst_log_mutex);
+
+static struct scst_trace_log scst_trace_tbl[] = {
+	{ TRACE_OUT_OF_MEM,	"out_of_mem"	},
+	{ TRACE_MINOR,		"minor"		},
+	{ TRACE_SG_OP,		"sg"		},
+	{ TRACE_MEMORY,		"mem"		},
+	{ TRACE_BUFF,		"buff"		},
+	{ TRACE_PID,		"pid"		},
+	{ TRACE_LINE,		"line"		},
+	{ TRACE_FUNCTION,	"function"	},
+	{ TRACE_DEBUG,		"debug"		},
+	{ TRACE_SPECIAL,	"special"	},
+	{ TRACE_SCSI,		"scsi"		},
+	{ TRACE_MGMT,		"mgmt"		},
+	{ TRACE_MGMT_DEBUG,	"mgmt_dbg"	},
+	{ TRACE_FLOW_CONTROL,	"flow_control"	},
+	{ TRACE_PRES,		"pr"		},
+	{ 0,			NULL		}
+};
+
+static struct scst_trace_log scst_local_trace_tbl[] = {
+	{ TRACE_RTRY,			"retry"			},
+	{ TRACE_SCSI_SERIALIZING,	"scsi_serializing"	},
+	{ TRACE_RCV_BOT,		"recv_bot"		},
+	{ TRACE_SND_BOT,		"send_bot"		},
+	{ TRACE_RCV_TOP,		"recv_top"		},
+	{ TRACE_SND_TOP,		"send_top"		},
+	{ 0,				NULL			}
+};
+
+static struct scst_trace_data scst_main_trace_data = {
+	.default_trace_flags	= SCST_DEFAULT_LOG_FLAGS,
+	.trace_flags		= &trace_flag,
+	.trace_tbl		= scst_local_trace_tbl,
+};
+
+/**
+ * scst_lookup_token() - Look up the name of a tracing token.
+ *
+ * Always returns a non-NULL pointer. If the token has been found, upon return
+ * p->val != 0 and p->token != NULL. If the token has not been found, upon
+ * return p->val == 0 and p->token == NULL.
+ */
+static struct scst_trace_log *scst_lookup_token(struct scst_trace_data *td,
+						const char *name)
+{
+	struct scst_trace_log *p;
+
+	if (td->trace_tbl)
+		for (p = td->trace_tbl; p->token; ++p)
+			if (strcmp(p->token, name) == 0)
+				return p;
+
+	for (p = scst_trace_tbl; p->token; ++p)
+		if (strcmp(p->token, name) == 0)
+			break;
+
+	return p;
+}
+
+static ssize_t scst_tracing_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	struct scst_trace_data *td = file->private_data;
+	const char *name = file->f_dentry->d_name.name;
+	struct scst_trace_log *p;
+	unsigned long trace_flags;
+	char contents[3];
+	int len;
+	ssize_t res;
+
+	p = scst_lookup_token(td, name);
+	WARN_ON(!p->token || !p->val);
+	res = mutex_lock_interruptible(&scst_log_mutex);
+	if (res)
+		goto out;
+	trace_flags = *td->trace_flags;
+	mutex_unlock(&scst_log_mutex);
+	len = scnprintf(contents, sizeof(contents), "%d\n",
+			(trace_flags & p->val) != 0);
+	if (*ppos > len)
+		return -EINVAL;
+	res = min_t(ssize_t, count, len - *ppos);
+	copy_to_user(buf, contents + *ppos, res);
+	*ppos += res;
+out:
+	return res;
+}
+
+static ssize_t scst_tracing_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct scst_trace_data *td = file->private_data;
+	const char *name = file->f_dentry->d_name.name;
+	struct scst_trace_log *p;
+	unsigned long newval;
+	char input[8];
+	ssize_t res;
+
+	copy_from_user(input, buf, min(count, sizeof(input)));
+	res = strict_strtoul(input, 0, &newval);
+	if (res)
+		goto out;
+
+	p = scst_lookup_token(td, name);
+	WARN_ON(!p->token || !p->val);
+	res = mutex_lock_interruptible(&scst_log_mutex);
+	if (res)
+		goto out;
+	*td->trace_flags = (*td->trace_flags & ~p->val) | (newval ? p->val : 0);
+	mutex_unlock(&scst_log_mutex);
+	*ppos += count;
+	res = count;
+out:
+	return res;
+}
+
+static int scst_debugfs_open(struct inode *inode, struct file *file)
+{
+	if (inode->i_private)
+		file->private_data = inode->i_private;
+
+	return 0;
+}
+
+static const struct file_operations scst_tracing_fops = {
+	.read	=	scst_tracing_read_file,
+	.write	=	scst_tracing_write_file,
+	.open	=	scst_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
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
+
+	BUG_ON(!root);
+	BUG_ON(!dir_name);
+	BUG_ON(!td);
+
+	subdir = debugfs_create_dir(dir_name, root);
+	if (!subdir) {
+		PRINT_ERROR("Creation of directory %s failed", dir_name);
+		goto out;
+	}
+
+	tracing_dir = debugfs_create_dir("tracing", subdir);
+	if (!tracing_dir) {
+		PRINT_ERROR("%s", "Creation of tracing dir failed");
+		goto err;
+	}
+
+	for (i = 0; i < ARRAY_SIZE(tracing_table); ++i) {
+		for (p = tracing_table[i]; p && p->val; ++p) {
+			file = debugfs_create_file(p->token, S_IRUGO | S_IWUSR,
+						   tracing_dir, td,
+						   &scst_tracing_fops);
+			if (!file) {
+				PRINT_ERROR("Creation of tracing file %s"
+					    "failed", p->token);
+				goto err;
+			}
+		}
+	}
+out:
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
+}
+
+int scst_debugfs_init(void)
+{
+	int res;
+
+	res = -ENOMEM;
+	scst_debug_root = debugfs_create_dir("scst", NULL);
+	if (!scst_debug_root) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst failed");
+		goto out;
+	}
+
+	scst_debug_target = debugfs_create_dir("target", scst_debug_root);
+	if (!scst_debug_target) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/target"
+			    " failed");
+		goto out;
+	}
+
+	scst_debug_devt = debugfs_create_dir("device_type", scst_debug_root);
+	if (!scst_debug_devt) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/"
+			    "device_type failed");
+		goto out;
+	}
+
+	scst_debug_dev = debugfs_create_dir("device", scst_debug_root);
+	if (!scst_debug_dev) {
+		PRINT_ERROR("%s", "Creation of /sys/kernel/debug/scst/device"
+			    " failed");
+		goto out;
+	}
+
+	res = 0;
+
+out:
+	return res;
+}
+
+void scst_debugfs_cleanup(void)
+{
+	debugfs_remove_recursive(scst_debug_root);
+	scst_debug_dev = NULL;
+	scst_debug_devt = NULL;
+	scst_debug_target = NULL;
+	scst_debug_root = NULL;
+}
+
+int scst_main_create_trace_files(void)
+{
+	scst_main_tracing_dir = scst_create_trace_files(scst_debug_root,
+							"main",
+							&scst_main_trace_data);
+	return scst_main_tracing_dir ? 0 : -EINVAL;
+}
+
+void scst_main_remove_trace_files(void)
+{
+	scst_remove_trace_files(scst_main_tracing_dir);
+	scst_main_tracing_dir = NULL;
+}
+
+int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt)
+{
+	if (tgtt->trace_data.trace_flags) {
+		tgtt->tracing_dir = scst_create_trace_files(scst_debug_target,
+							    tgtt->name,
+							    &tgtt->trace_data);
+		if (!tgtt->tracing_dir)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt)
+{
+	scst_remove_trace_files(tgtt->tracing_dir);
+	tgtt->tracing_dir = NULL;
+}
+
+int scst_devt_create_trace_files(struct scst_dev_type *devt)
+{
+	if (devt->trace_data.trace_flags) {
+		devt->tracing_dir = scst_create_trace_files(scst_debug_devt,
+							    devt->name,
+							    &devt->trace_data);
+		if (!devt->tracing_dir)
+			return -EINVAL;
+	}
+	return 0;
+}
+
+void scst_devt_remove_trace_files(struct scst_dev_type *devt)
+{
+	scst_remove_trace_files(devt->tracing_dir);
+	devt->tracing_dir = NULL;
+}
+
+static ssize_t scst_dump_pr_read_file(struct file *file, char __user *buf,
+				      size_t count, loff_t *ppos)
+{
+	return 0;
+}
+
+static ssize_t scst_dump_pr_write_file(struct file *file,
+				       const char __user *buf,
+				       size_t count, loff_t *ppos)
+{
+	struct scst_device *dev = file->private_data;
+
+	scst_pr_dump_prs(dev, true);
+	return count;
+}
+
+static const struct file_operations scst_dump_pr_fops = {
+	.read	=	scst_dump_pr_read_file,
+	.write	=	scst_dump_pr_write_file,
+	.open	=	scst_debugfs_open,
+	.llseek	=	noop_llseek,
+};
+
+int scst_dev_create_debug_files(struct scst_device *dev)
+{
+	struct dentry *file;
+	int res;
+
+	res = -ENOMEM;
+	dev->debugfs_dir = debugfs_create_dir(dev->virt_name, scst_debug_dev);
+	if (!dev->debugfs_dir) {
+		PRINT_ERROR("Creating /sys/kernel/debug/device/%s failed",
+			    dev->virt_name);
+		goto out;
+	}
+	file = debugfs_create_file("dump_pr", S_IWUSR, dev->debugfs_dir, dev,
+				   &scst_dump_pr_fops);
+	if (!file) {
+		PRINT_ERROR("Creating /sys/kernel/debug/device/%s/dump_pr"
+			    " failed", dev->virt_name);
+		goto remove_dir;
+	}
+	res = 0;
+out:
+	return res;
+remove_dir:
+	debugfs_remove_recursive(dev->debugfs_dir);
+	dev->debugfs_dir = NULL;
+	goto out;
+}
+
+void scst_dev_remove_debug_files(struct scst_device *dev)
+{
+	debugfs_remove_recursive(dev->debugfs_dir);
+	dev->debugfs_dir = NULL;
+}
diff --git a/drivers/scst/scst_tracing.h b/drivers/scst/scst_tracing.h
new file mode 100644
index 0000000..8fd40bd
--- /dev/null
+++ b/drivers/scst/scst_tracing.h
@@ -0,0 +1,63 @@
+#include <scst/scst.h>
+
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+
+int scst_debugfs_init(void);
+void scst_debugfs_cleanup(void);
+int scst_main_create_trace_files(void);
+void scst_main_remove_trace_files(void);
+int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt);
+void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt);
+int scst_devt_create_trace_files(struct scst_dev_type *devt);
+void scst_devt_remove_trace_files(struct scst_dev_type *devt);
+int scst_dev_create_debug_files(struct scst_device *dev);
+void scst_dev_remove_debug_files(struct scst_device *dev);
+
+#else /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
+
+static inline int scst_debugfs_init(void)
+{
+	return 0;
+}
+
+static inline void scst_debugfs_cleanup(void)
+{
+}
+
+static inline int scst_main_create_trace_files(void)
+{
+	return 0;
+}
+
+static inline void scst_main_remove_trace_files(void)
+{
+}
+
+static inline int scst_tgtt_create_trace_files(struct scst_tgt_template *tgtt)
+{
+	return 0;
+}
+
+static inline void scst_tgtt_remove_trace_files(struct scst_tgt_template *tgtt)
+{
+}
+
+static inline int scst_devt_create_trace_files(struct scst_dev_type *devt)
+{
+	return 0;
+}
+
+static inline void scst_devt_remove_trace_files(struct scst_dev_type *devt)
+{
+}
+
+static inline int scst_dev_create_debug_files(struct scst_device *dev)
+{
+	return 0;
+}
+
+static inline void scst_dev_remove_debug_files(struct scst_device *dev)
+{
+}
+
+#endif /*defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)*/
diff --git a/drivers/scst/srpt/ib_srpt.c b/drivers/scst/srpt/ib_srpt.c
index 2c31edd..28f860f 100644
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
index 188832a..e44547a 100644
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
@@ -2094,6 +2095,10 @@ struct scst_device {
 
 	struct kobject *dev_exp_kobj; /* exported groups */
 
+#if defined(CONFIG_SCST_DEBUG) || defined(CONFIG_SCST_TRACING)
+	struct dentry *debugfs_dir;
+#endif
+
 	/* Export number in the dev's sysfs list. Protected by scst_mutex */
 	int dev_exported_lun_num;
 };
-- 
1.7.1
