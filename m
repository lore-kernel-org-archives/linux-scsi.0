From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH 11/17] sym53c8xx: Remove tag_ctrl module parameter
Date: Fri,  5 Oct 2007 15:55:08 -0400
Message-ID: <11916141152123-git-send-email-matthew@wil.cx>
References: <11916141143747-git-send-email-matthew@wil.cx>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.tor.primus.ca ([216.254.136.21]:40312 "EHLO
	mail-02.primus.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760911AbXJETzV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Oct 2007 15:55:21 -0400
In-Reply-To: <11916141143747-git-send-email-matthew@wil.cx>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>

With sysfs making these options tunable at runtime, there's no
justification for keeping this horrendously complex specification
string around.

Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
---
 Documentation/scsi/sym53c8xx_2.txt   |   21 +++--------
 drivers/scsi/sym53c8xx_2/sym53c8xx.h |    1 -
 drivers/scsi/sym53c8xx_2/sym_glue.c  |   66 ++--------------------------------
 3 files changed, 8 insertions(+), 80 deletions(-)

diff --git a/Documentation/scsi/sym53c8xx_2.txt b/Documentation/scsi/sym53c8xx_2.txt
index 3d9f06b..49ea5c5 100644
--- a/Documentation/scsi/sym53c8xx_2.txt
+++ b/Documentation/scsi/sym53c8xx_2.txt
@@ -449,25 +449,14 @@ options as above.
         cmd_per_lun=#tags (#tags > 1) tagged command queuing enabled
   #tags will be truncated to the max queued commands configuration parameter.
 
-10.2.2  Detailed control of tagged commands
-  This option allows you to specify a command queue depth for each device 
-  that supports tagged command queueing.
-  Example:
-      tag_ctrl=10/t2t3q16-t5q24/t1u2q32
-  will set devices queue depth as follow:
-      - controller #0 target #2 and target #3                  -> 16 commands,
-      - controller #0 target #5                                -> 24 commands,
-      - controller #1 target #1 logical unit #2                -> 32 commands,
-      - all other logical units (all targets, all controllers) -> 10 commands.
-
-10.2.3 Burst max
+10.2.2 Burst max
         burst=0    burst disabled
         burst=255  get burst length from initial IO register settings.
         burst=#x   burst enabled (1<<#x burst transfers max)
   #x is an integer value which is log base 2 of the burst transfers max.
   By default the driver uses the maximum value supported by the chip.
 
-10.2.4 LED support
+10.2.3 LED support
         led=1      enable  LED support
         led=0      disable LED support
   Do not enable LED support if your scsi board does not use SDMS BIOS.
@@ -560,9 +549,9 @@ Previously, the sym2 driver accepted arguments of the form
 	sym53c8xx=tags:4,sync:10,debug:0x200
 
 As a result of the new module parameters, this is no longer available.
-Most of the options have remained the same, but tags has split into
-cmd_per_lun and tag_ctrl for its two different purposes.  The sample above
-would be specified as:
+Most of the options have remained the same, but tags has become
+cmd_per_lun to reflect its different purposes.  The sample above would
+be specified as:
 	modprobe sym53c8xx cmd_per_lun=4 sync=10 debug=0x200
 
 or on the kernel boot line as:
diff --git a/drivers/scsi/sym53c8xx_2/sym53c8xx.h b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
index 7519728..62d29cf 100644
--- a/drivers/scsi/sym53c8xx_2/sym53c8xx.h
+++ b/drivers/scsi/sym53c8xx_2/sym53c8xx.h
@@ -127,7 +127,6 @@ struct sym_driver_setup {
 	u_char	settle_delay;
 	u_char	use_nvram;
 	u_long	excludes[8];
-	char	tag_ctrl[100];
 };
 
 #define SYM_SETUP_MAX_TAG		sym_driver_setup.max_tag
diff --git a/drivers/scsi/sym53c8xx_2/sym_glue.c b/drivers/scsi/sym53c8xx_2/sym_glue.c
index 6865d30..7717ab8 100644
--- a/drivers/scsi/sym53c8xx_2/sym_glue.c
+++ b/drivers/scsi/sym53c8xx_2/sym_glue.c
@@ -63,7 +63,6 @@ unsigned int sym_debug_flags = 0;
 static char *excl_string;
 static char *safe_string;
 module_param_named(cmd_per_lun, sym_driver_setup.max_tag, ushort, 0);
-module_param_string(tag_ctrl, sym_driver_setup.tag_ctrl, 100, 0);
 module_param_named(burst, sym_driver_setup.burst_order, byte, 0);
 module_param_named(led, sym_driver_setup.scsi_led, byte, 0);
 module_param_named(diff, sym_driver_setup.scsi_diff, byte, 0);
@@ -78,7 +77,6 @@ module_param_named(excl, excl_string, charp, 0);
 module_param_named(safe, safe_string, charp, 0);
 
 MODULE_PARM_DESC(cmd_per_lun, "The maximum number of tags to use by default");
-MODULE_PARM_DESC(tag_ctrl, "More detailed control over tags per LUN");
 MODULE_PARM_DESC(burst, "Maximum burst.  0 to disable, 255 to read from registers");
 MODULE_PARM_DESC(led, "Set to 1 to enable LED support");
 MODULE_PARM_DESC(diff, "0 for no differential mode, 1 for BIOS, 2 for always, 3 for not GPIO3");
@@ -744,59 +742,6 @@ static void sym_tune_dev_queuing(struct sym_tcb *tp, int lun, u_short reqtags)
 	}
 }
 
-/*
- *  Linux select queue depths function
- */
-#define DEF_DEPTH	(sym_driver_setup.max_tag)
-#define ALL_TARGETS	-2
-#define NO_TARGET	-1
-#define ALL_LUNS	-2
-#define NO_LUN		-1
-
-static int device_queue_depth(struct sym_hcb *np, int target, int lun)
-{
-	int c, h, t, u, v;
-	char *p = sym_driver_setup.tag_ctrl;
-	char *ep;
-
-	h = -1;
-	t = NO_TARGET;
-	u = NO_LUN;
-	while ((c = *p++) != 0) {
-		v = simple_strtoul(p, &ep, 0);
-		switch(c) {
-		case '/':
-			++h;
-			t = ALL_TARGETS;
-			u = ALL_LUNS;
-			break;
-		case 't':
-			if (t != target)
-				t = (target == v) ? v : NO_TARGET;
-			u = ALL_LUNS;
-			break;
-		case 'u':
-			if (u != lun)
-				u = (lun == v) ? v : NO_LUN;
-			break;
-		case 'q':
-			if (h == np->s.unit &&
-				(t == ALL_TARGETS || t == target) &&
-				(u == ALL_LUNS    || u == lun))
-				return v;
-			break;
-		case '-':
-			t = ALL_TARGETS;
-			u = ALL_LUNS;
-			break;
-		default:
-			break;
-		}
-		p = ep;
-	}
-	return DEF_DEPTH;
-}
-
 static int sym53c8xx_slave_alloc(struct scsi_device *sdev)
 {
 	struct sym_hcb *np = sym_get_hcb(sdev->host);
@@ -861,21 +806,16 @@ static int sym53c8xx_slave_configure(struct scsi_device *sdev)
 	 *  Use at least 2.
 	 *  Donnot use more than our maximum.
 	 */
-	reqtags = device_queue_depth(np, sdev->id, sdev->lun);
+	reqtags = sym_driver_setup.max_tag;
 	if (reqtags > tp->usrtags)
 		reqtags = tp->usrtags;
 	if (!sdev->tagged_supported)
 		reqtags = 0;
-#if 1 /* Avoid to locally queue commands for no good reasons */
 	if (reqtags > SYM_CONF_MAX_TAG)
 		reqtags = SYM_CONF_MAX_TAG;
-	depth_to_use = (reqtags ? reqtags : 2);
-#else
-	depth_to_use = (reqtags ? SYM_CONF_MAX_TAG : 2);
-#endif
+	depth_to_use = reqtags ? reqtags : 2;
 	scsi_adjust_queue_depth(sdev,
-				(sdev->tagged_supported ?
-				 MSG_SIMPLE_TAG : 0),
+				sdev->tagged_supported ? MSG_SIMPLE_TAG : 0,
 				depth_to_use);
 	lp->s.scdev_depth = depth_to_use;
 	sym_tune_dev_queuing(tp, sdev->lun, reqtags);
-- 
1.4.4.2

