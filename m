From: Tomas Winkler <tomas.winkler@intel.com>
Subject: [scsi 2/2] scsi_debug: add UFS WLUNs
Date: Sun,  1 Mar 2015 23:25:39 +0200
Message-ID: <1425245139-16555-2-git-send-email-tomas.winkler@intel.com>
References: <1425245139-16555-1-git-send-email-tomas.winkler@intel.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53043 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751182AbbCAV0f (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Mar 2015 16:26:35 -0500
In-Reply-To: <1425245139-16555-1-git-send-email-tomas.winkler@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley\"" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Tomas Winkler <tomas.winkler@intel.com>, Douglas Gilbert <dgilbert@interlog.com>

Add ufs wluns: ufs, boot, and rpmb
enabled by boolean ufs module parameter.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
---
 drivers/scsi/scsi_debug.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5d1bb12adc43..73557df003c2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -144,6 +144,7 @@ static const char *scsi_debug_version_date = "20141022";
 #define DEF_WRITESAME_LENGTH 0xFFFF
 #define DEF_STRICT 0
 #define DELAY_OVERRIDDEN -9999
+#define DEF_UFS 0
 
 /* bit mask values for scsi_debug_opts */
 #define SCSI_DEBUG_OPT_NOISE   1
@@ -556,6 +557,7 @@ static bool scsi_debug_removable = DEF_REMOVABLE;
 static bool scsi_debug_clustering;
 static bool scsi_debug_host_lock = DEF_HOST_LOCK;
 static bool scsi_debug_strict = DEF_STRICT;
+static bool scsi_debug_ufs = DEF_UFS;
 static bool sdebug_any_injecting_opt;
 
 static atomic_t sdebug_cmnd_count;
@@ -4192,6 +4194,7 @@ module_param_named(vpd_use_hostno, scsi_debug_vpd_use_hostno, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(write_same_length, scsi_debug_write_same_length, int,
 		   S_IRUGO | S_IWUSR);
+module_param_named(ufs, scsi_debug_ufs, bool, S_IRUGO | S_IWUSR);
 
 MODULE_AUTHOR("Eric Youngdale + Douglas Gilbert");
 MODULE_DESCRIPTION("SCSI debug adapter driver");
@@ -5426,6 +5429,15 @@ static int sdebug_driver_probe(struct device * dev)
 	/* REPORT LUNS */
 	sdebug_register_w_lun(0x01);
 
+	if (scsi_debug_ufs) {
+		/* boot */
+		sdebug_register_w_lun(0x30);
+		/* rpmb */
+		sdebug_register_w_lun(0x44);
+		/* UFS */
+		sdebug_register_w_lun(0x50);
+	}
+
 	hpnt->max_lun = sdebug_max_luns();
 
 	host_prot = 0;
-- 
1.9.3

