Return-Path: <SRS0=gVs6=XW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1D24C4360C
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 14:04:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CF3B721841
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Sep 2019 14:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727124AbfI0OEf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Sep 2019 10:04:35 -0400
Received: from smtp.infotech.no ([82.134.31.41]:55452 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbfI0OEf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 27 Sep 2019 10:04:35 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 5C8AA204164;
        Fri, 27 Sep 2019 16:04:32 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id ln+f-IVqyYhG; Fri, 27 Sep 2019 16:04:30 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id AA6EB204157;
        Fri, 27 Sep 2019 16:04:29 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, hare@suse.de, bvanassche@acm.org
Subject: [PATCH v2] scsi_debug: randomize command duration option + %p
Date:   Fri, 27 Sep 2019 10:04:25 -0400
Message-Id: <20190927140425.18958-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add an option to use the given command delay (in nanoseconds)
as the upper limit for command durations. A pseudo random
number generator chooses each duration from the range:
      [0..delay_in_ns)

Main benefit: allows testing with out-of-order responses.

Change the only %p (print a kernel pointer) in the driver
to %pK as the former seems to have no usefulness in recent
kernels.

---

The new %p would be more useful if it didn't randomize NULL
pointers and gave an indicative output for ERR_PTR(-ENOENT)
type pointers. Hard to imagine how that will help the black
hats. Probably all printk()s in the SCSI subsystem should be
changed to %pK or some variant of that.

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
---
 drivers/scsi/scsi_debug.c | 43 +++++++++++++++++++++++++++++++++++----
 1 file changed, 39 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d323523f5f9d..92b982158ec3 100644
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
+			u64 ns = (u64)delta_jiff * (NSEC_PER_SEC / HZ);
+
+			if (sdebug_random && ns < U32_MAX) {
+				ns = prandom_u32_max((u32)ns);
+			} else if (sdebug_random) {
+				ns >>= 10;	/* divide by 1024 */
+				if (ns < U32_MAX)  /* an hour and a bit */
+					ns = prandom_u32_max((u32)ns);
+				ns <<= 10;
+			}
+			kt = ns_to_ktime(ns);
+		} else {
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
+MODULE_PARM_DESC(random, "1-> command duration chosen from [0..delay_in_ns) (def=0)");
 MODULE_PARM_DESC(removable, "claim to have removable media (def=0)");
 MODULE_PARM_DESC(scsi_level, "SCSI level to simulate(def=7[SPC-5])");
 MODULE_PARM_DESC(sector_size, "logical block size in bytes (def=512)");
@@ -5101,6 +5118,23 @@ static ssize_t map_show(struct device_driver *ddp, char *buf)
 }
 static DRIVER_ATTR_RO(map);
 
+static ssize_t random_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_random ? 1 : 0);
+}
+static ssize_t random_store(struct device_driver *ddp, const char *buf,
+			    size_t count)
+{
+	int n;
+
+	if (count > 0 && 1 == sscanf(buf, "%d", &n) && n >= 0) {
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
@@ -5211,6 +5245,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_guard.attr,
 	&driver_attr_ato.attr,
 	&driver_attr_map.attr,
+	&driver_attr_random.attr,
 	&driver_attr_removable.attr,
 	&driver_attr_host_lock.attr,
 	&driver_attr_ndelay.attr,
@@ -5338,7 +5373,7 @@ static int __init scsi_debug_init(void)
 		dif_size = sdebug_store_sectors * sizeof(struct t10_pi_tuple);
 		dif_storep = vmalloc(dif_size);
 
-		pr_err("dif_storep %u bytes @ %p\n", dif_size, dif_storep);
+		pr_err("dif_storep %u bytes @ %pK\n", dif_size, dif_storep);
 
 		if (dif_storep == NULL) {
 			pr_err("out of mem. (DIX)\n");
-- 
2.23.0

