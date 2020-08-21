Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6BDC433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 04:23:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3EE3820855
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 04:23:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725908AbgHUEXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 00:23:02 -0400
Received: from smtp.infotech.no ([82.134.31.41]:46676 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725884AbgHUEXA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 21 Aug 2020 00:23:00 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id CFAD720424C;
        Fri, 21 Aug 2020 06:22:57 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PbS9ta1g4V+a; Fri, 21 Aug 2020 06:22:54 +0200 (CEST)
Received: from xtwo70.bingwo.ca (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 6A40A204188;
        Fri, 21 Aug 2020 06:22:53 +0200 (CEST)
From:   Douglas Gilbert <dgilbert@interlog.com>
To:     linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de,
        bvanassche@acm.org
Subject: [PATCH v2] scsi_debug: implement lun_format
Date:   Fri, 21 Aug 2020 00:22:49 -0400
Message-Id: <20200821042249.5097-1-dgilbert@interlog.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement 'flat space LUN addressing', which allows us to raise
the max_lun limitation to 16384. The maximum number of LUNs
prior to this patch was 256.

Changes since version 1 [20200529}
  - rebase to Martin Petersen's 5.10/scsi-queue branch
  - implement review comments from Bart Van Assche

Suggested-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

---

This patch was presented by Hannes on 20200529 to the linux-scsi
list titled: "[PATCH] scsi_debug: implement 'sdebug_lun_format'
and update max_lun". That title is shortened at the suggestion
of git tools.

 drivers/scsi/scsi_debug.c | 71 +++++++++++++++++++++++++++++++++++----
 1 file changed, 64 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 139f0073da37..35fe8080e957 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -209,10 +209,6 @@ static const char *sdebug_version_date = "20200710";
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
 #define OPT_MEDIUM_ERR_NUM    10     /* number of consecutive medium errs */
 
-/* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
- * or "peripheral device" addressing (value 0) */
-#define SAM2_LUN_ADDRESS_METHOD 0
-
 /* SDEBUG_CANQUEUE is the maximum number of commands that can be queued
  * (for response) per submit queue at one time. Can be reduced by max_queue
  * option. Command responses are not queued when jdelay=0 and ndelay=0. The
@@ -791,6 +787,13 @@ static bool sdebug_wp;
 static enum blk_zoned_model sdeb_zbc_model = BLK_ZONED_NONE;
 static char *sdeb_zbc_model_s;
 
+enum sam_lun_addr_method {SAM_LUN_AM_PERIPHERAL = 0x0,
+			  SAM_LUN_AM_FLAT = 0x1,
+			  SAM_LUN_AM_LOGICAL_UNIT = 0x2,
+			  SAM_LUN_AM_EXTENDED = 0x3};
+static enum sam_lun_addr_method sdebug_lun_am = SAM_LUN_AM_PERIPHERAL;
+static int sdebug_lun_am_i = (int)SAM_LUN_AM_PERIPHERAL;
+
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
 
@@ -4179,6 +4182,8 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 			if ((k * RL_BUCKET_ELEMS) + j > lun_cnt)
 				break;
 			int_to_scsilun(lun++, lun_p);
+			if (lun > 1 && sdebug_lun_am == SAM_LUN_AM_FLAT)
+				lun_p->scsi_lun[0] |= 0x40;
 		}
 		if (j < RL_BUCKET_ELEMS)
 			break;
@@ -4946,6 +4951,7 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 		pr_err("Host info NULL\n");
 		return NULL;
 	}
+
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if ((devip->used) && (devip->channel == sdev->channel) &&
 		    (devip->target == sdev->id) &&
@@ -5586,6 +5592,7 @@ module_param_named(lbpu, sdebug_lbpu, int, S_IRUGO);
 module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
+module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
@@ -5659,6 +5666,7 @@ MODULE_PARM_DESC(lbpws, "enable LBP, support WRITE SAME(16) with UNMAP bit (def=
 MODULE_PARM_DESC(lbpws10, "enable LBP, support WRITE SAME(10) with UNMAP bit (def=0)");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
+MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
@@ -6106,6 +6114,43 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(every_nth);
 
+static ssize_t lun_format_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", (int)sdebug_lun_am);
+}
+static ssize_t lun_format_store(struct device_driver *ddp, const char *buf,
+				size_t count)
+{
+	int n;
+	bool changed;
+
+	if (kstrtoint(buf, 0, &n))
+		return -EINVAL;
+	if (n >= 0) {
+		if (n > (int)SAM_LUN_AM_FLAT) {
+			pr_warn("only LUN address methods 0 and 1 are supported\n");
+			return -EINVAL;
+		}
+		changed = ((int)sdebug_lun_am != n);
+		sdebug_lun_am = n;
+		if (changed && sdebug_scsi_level >= 5) {	/* >= SPC-3 */
+			struct sdebug_host_info *sdhp;
+			struct sdebug_dev_info *dp;
+
+			spin_lock(&sdebug_host_list_lock);
+			list_for_each_entry(sdhp, &sdebug_host_list, host_list) {
+				list_for_each_entry(dp, &sdhp->dev_info_list, dev_list) {
+					set_bit(SDEBUG_UA_LUNS_CHANGED, dp->uas_bm);
+				}
+			}
+			spin_unlock(&sdebug_host_list_lock);
+		}
+		return count;
+	}
+	return -EINVAL;
+}
+static DRIVER_ATTR_RW(lun_format);
+
 static ssize_t max_luns_show(struct device_driver *ddp, char *buf)
 {
 	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_max_luns);
@@ -6544,6 +6589,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_dev_size_mb.attr,
 	&driver_attr_num_parts.attr,
 	&driver_attr_every_nth.attr,
+	&driver_attr_lun_format.attr,
 	&driver_attr_max_luns.attr,
 	&driver_attr_max_queue.attr,
 	&driver_attr_no_uld.attr,
@@ -6636,9 +6682,19 @@ static int __init scsi_debug_init(void)
 		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
+
+	sdebug_lun_am = sdebug_lun_am_i;
+	if (sdebug_lun_am > SAM_LUN_AM_FLAT) {
+		pr_warn("Invalid LUN format %u, using default\n", (int)sdebug_lun_am);
+		sdebug_lun_am = SAM_LUN_AM_PERIPHERAL;
+	}
+
 	if (sdebug_max_luns > 256) {
-		pr_warn("max_luns can be no more than 256, use default\n");
-		sdebug_max_luns = DEF_MAX_LUNS;
+		if (sdebug_max_luns > 16384) {
+			pr_warn("max_luns can be no more than 16384, use default\n");
+			sdebug_max_luns = DEF_MAX_LUNS;
+		}
+		sdebug_lun_am = SAM_LUN_AM_FLAT;
 	}
 
 	if (sdebug_lowest_aligned > 0x3fff) {
@@ -7160,6 +7216,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
 	int k, na;
 	int errsts = 0;
+	u64 lun_index = sdp->lun & 0x3FFF;
 	u32 flags;
 	u16 sa;
 	u8 opcode = cmd[0];
@@ -7193,7 +7250,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (unlikely(inject_now && (sdebug_opts & SDEBUG_OPT_HOST_BUSY)))
 		return SCSI_MLQUEUE_HOST_BUSY;
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
-	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
+	if (unlikely(lun_index >= sdebug_max_luns && !has_wlun_rl))
 		goto err_out;
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
-- 
2.25.1

