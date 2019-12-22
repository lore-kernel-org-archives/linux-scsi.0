Return-Path: <SRS0=BSUp=2M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BDA6C3F68F
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 38EB420CC7
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Dec 2019 04:00:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726670AbfLVD76 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 21 Dec 2019 22:59:58 -0500
Received: from smtp.infotech.no ([82.134.31.41]:39878 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726339AbfLVD76 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 21 Dec 2019 22:59:58 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 0ACD1204194;
        Sun, 22 Dec 2019 04:59:55 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id i5ezzo61v+5N; Sun, 22 Dec 2019 04:59:53 +0100 (CET)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 6BB15204191;
        Sun, 22 Dec 2019 04:59:52 +0100 (CET)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: [RFC 1/6] scsi_debug: randomize command completion time
Date:   Sat, 21 Dec 2019 22:59:43 -0500
Message-Id: <20191222035948.30447-2-dgilbert@interlog.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191222035948.30447-1-dgilbert@interlog.com>
References: <20191222035948.30447-1-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a new command line option (e.g. random=1) and sysfs attribute
that causes subsequent command completion times to be between the
current command delay setting and 0. A unformily distributed 32
bit, kernel provided integer is used for this purpose.

Since the existing 'delay' whose units are jiffies (typically
milliseconds) and 'ndelay' (units: nanoseconds) options (and sysfs
attributes) span a range greater than 32 bits, some scaling is
required.

The purpose of this patch is to widen the range of testing cases
that are visited in long running tests. Put simply: rarely struct
race conditions are more likely to be found when this facility is
used.

The default is the previous case in which all command completions
were roughly equal to (if not, slightly longer) than the value
given by the 'delay' or 'ndelay' settings (or their defaults).
This option's default is equivalent to setting 'random=0' .

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 42 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 39 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 44cb054d5e66..18c07e9ace15 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -38,6 +38,7 @@
 #include <linux/hrtimer.h>
 #include <linux/uuid.h>
 #include <linux/t10-pi.h>
+#include <linux/random.h>
 
 #include <net/checksum.h>
 
@@ -125,6 +126,7 @@ static const char *sdebug_version_date = "20190125";
 #define DEF_PHYSBLK_EXP 0
 #define DEF_OPT_XFERLEN_EXP 0
 #define DEF_PTYPE   TYPE_DISK
+#define DEF_RANDOM false
 #define DEF_REMOVABLE false
 #define DEF_SCSI_LEVEL   7    /* INQUIRY, byte2 [6->SPC-4; 7->SPC-5] */
 #define DEF_SECTOR_SIZE 512
@@ -655,6 +657,7 @@ static unsigned int sdebug_unmap_max_blocks = DEF_UNMAP_MAX_BLOCKS;
 static unsigned int sdebug_unmap_max_desc = DEF_UNMAP_MAX_DESC;
 static unsigned int sdebug_write_same_length = DEF_WRITESAME_LENGTH;
 static int sdebug_uuid_ctl = DEF_UUID_CTL;
+static bool sdebug_random = DEF_RANDOM;
 static bool sdebug_removable = DEF_REMOVABLE;
 static bool sdebug_clustering;
 static bool sdebug_host_lock = DEF_HOST_LOCK;
@@ -4354,9 +4357,21 @@ static int schedule_resp(struct scsi_cmnd *cmnd, struct sdebug_dev_info *devip,
 		ktime_t kt;
 
 		if (delta_jiff > 0) {
-			kt = ns_to_ktime((u64)delta_jiff * (NSEC_PER_SEC / HZ));
-		} else
-			kt = ndelay;
+			u64 ns = jiffies_to_nsecs(delta_jiff);
+
+			if (sdebug_random && ns < U32_MAX) {
+				ns = prandom_u32_max((u32)ns);
+			} else if (sdebug_random) {
+				ns >>= 12;	/* scale to 4 usec precision */
+				if (ns < U32_MAX)	/* over 4 hours max */
+					ns = prandom_u32_max((u32)ns);
+				ns <<= 12;
+			}
+			kt = ns_to_ktime(ns);
+		} else {	/* ndelay has a 4.2 second max */
+			kt = sdebug_random ? prandom_u32_max((u32)ndelay) :
+					     (u32)ndelay;
+		}
 		if (!sd_dp->init_hrt) {
 			sd_dp->init_hrt = true;
 			sqcp->sd_dp = sd_dp;
@@ -4451,6 +4466,7 @@ module_param_named(opts, sdebug_opts, int, S_IRUGO | S_IWUSR);
 module_param_named(physblk_exp, sdebug_physblk_exp, int, S_IRUGO);
 module_param_named(opt_xferlen_exp, sdebug_opt_xferlen_exp, int, S_IRUGO);
 module_param_named(ptype, sdebug_ptype, int, S_IRUGO | S_IWUSR);
+module_param_named(random, sdebug_random, bool, S_IRUGO | S_IWUSR);
 module_param_named(removable, sdebug_removable, bool, S_IRUGO | S_IWUSR);
 module_param_named(scsi_level, sdebug_scsi_level, int, S_IRUGO);
 module_param_named(sector_size, sdebug_sector_size, int, S_IRUGO);
@@ -4511,6 +4527,7 @@ MODULE_PARM_DESC(opts, "1->noise, 2->medium_err, 4->timeout, 8->recovered_err...
 MODULE_PARM_DESC(physblk_exp, "physical block exponent (def=0)");
 MODULE_PARM_DESC(opt_xferlen_exp, "optimal transfer length granularity exponent (def=physblk_exp)");
 MODULE_PARM_DESC(ptype, "SCSI peripheral type(def=0[disk])");
+MODULE_PARM_DESC(random, "If set, uniformly randomize command duration between 0 and delay_in_ns");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=7[SPC-5])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
@@ -5101,6 +5118,24 @@ static ssize_t map_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(map);
 
+static ssize_t random_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_random);
+}
+
+static ssize_t random_store(struct device_driver *ddp, const char *buf,
+			    size_t count)
+{
+	int n;
+
+	if (count > 0 && kstrtoint(buf, 10, &n) == 0 && n >= 0) {
+		sdebug_random = (n > 0);
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(random);
+
 static ssize_t removable_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_removable ? 1 : 0);
@@ -5211,6 +5246,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_guard.attr,
 	&driver_attr_ato.attr,
 	&driver_attr_map.attr,
+	&driver_attr_random.attr,
 	&driver_attr_removable.attr,
 	&driver_attr_host_lock.attr,
 	&driver_attr_ndelay.attr,
-- 
2.24.1

