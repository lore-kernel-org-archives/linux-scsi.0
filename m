Return-Path: <SRS0=G6Im=7L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D7FDC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 50EC6206F1
	for <linux-scsi@archiver.kernel.org>; Fri, 29 May 2020 13:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726838AbgE2Njs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 May 2020 09:39:48 -0400
Received: from mx2.suse.de ([195.135.220.15]:59378 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgE2Njr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 29 May 2020 09:39:47 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 9F281AF16;
        Fri, 29 May 2020 13:39:45 +0000 (UTC)
From:   Hannes Reinecke <hare@suse.de>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: [PATCH] scsi_debug: implement 'sdebug_lun_format' and update max_lun
Date:   Fri, 29 May 2020 15:39:42 +0200
Message-Id: <20200529133942.146413-1-hare@suse.de>
X-Mailer: git-send-email 2.16.4
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Implement 'flat space LUN addressing', which allows us to raise
the max_lun limitation to 16384.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/scsi_debug.c | 66 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 4c6c448dc2df..b486d6a34d22 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -204,8 +204,8 @@ static const char *sdebug_version_date = "20190125";
 #define OPT_MEDIUM_ERR_ADDR   0x1234 /* that's sector 4660 in decimal */
 #define OPT_MEDIUM_ERR_NUM    10     /* number of consecutive medium errs */
 
-/* If REPORT LUNS has luns >= 256 it can choose "flat space" (value 1)
- * or "peripheral device" addressing (value 0) */
+/* If REPORT LUNS has luns >= 256 it should choose "flat space" (value 1)
+ * instead of "peripheral device" addressing (value 0) */
 #define SAM2_LUN_ADDRESS_METHOD 0
 
 /* SDEBUG_CANQUEUE is the maximum number of commands that can be queued
@@ -666,6 +666,7 @@ static bool have_dif_prot;
 static bool write_since_sync;
 static bool sdebug_statistics = DEF_STATISTICS;
 static bool sdebug_wp;
+static int sdebug_lun_format = SAM2_LUN_ADDRESS_METHOD;
 
 static unsigned int sdebug_store_sectors;
 static sector_t sdebug_capacity;	/* in sectors */
@@ -3676,6 +3677,8 @@ static int resp_report_luns(struct scsi_cmnd *scp,
 			if ((k * RL_BUCKET_ELEMS) + j > lun_cnt)
 				break;
 			int_to_scsilun(lun++, lun_p);
+			if (lun > 1 && sdebug_lun_format == 1)
+				lun_p->scsi_lun[0] |= 0x40;
 		}
 		if (j < RL_BUCKET_ELEMS)
 			break;
@@ -3834,6 +3837,7 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 		pr_err("Host info NULL\n");
 		return NULL;
 	}
+
 	list_for_each_entry(devip, &sdbg_host->dev_info_list, dev_list) {
 		if ((devip->used) && (devip->channel == sdev->channel) &&
 		    (devip->target == sdev->id) &&
@@ -4438,6 +4442,7 @@ module_param_named(lbpws, sdebug_lbpws, int, S_IRUGO);
 module_param_named(lbpws10, sdebug_lbpws10, int, S_IRUGO);
 module_param_named(lbprz, sdebug_lbprz, int, S_IRUGO);
 module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
+module_param_named(lun_format, sdebug_lun_format, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int, S_IRUGO | S_IWUSR);
@@ -4499,6 +4504,7 @@ MODULE_PARM_DESC(lbprz,
 	"on read unmapped LBs return 0 when 1 (def), return 0xff when 2");
 MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
+MODULE_PARM_DESC(lun_format, "LUN format to use(def=0)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
@@ -4860,6 +4866,44 @@ static ssize_t every_nth_store(struct device_driver *ddp, const char *buf,
 }
 static DRIVER_ATTR_RW(every_nth);
 
+static ssize_t lun_format_show(struct device_driver *ddp, char *buf)
+{
+	return scnprintf(buf, PAGE_SIZE, "%d\n", sdebug_lun_format);
+}
+static ssize_t lun_format_store(struct device_driver *ddp, const char *buf,
+				size_t count)
+{
+	int n;
+	bool changed;
+
+	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		if (n > 2) {
+			pr_warn("only formats 0 and 1 are supported\n");
+			return -EINVAL;
+		}
+		changed = (sdebug_lun_format != n);
+		sdebug_lun_format = n;
+		if (changed && (sdebug_scsi_level >= 5)) {	/* >= SPC-3 */
+			struct sdebug_host_info *sdhp;
+			struct sdebug_dev_info *dp;
+
+			spin_lock(&sdebug_host_list_lock);
+			list_for_each_entry(sdhp, &sdebug_host_list,
+					    host_list) {
+				list_for_each_entry(dp, &sdhp->dev_info_list,
+						    dev_list) {
+					set_bit(SDEBUG_UA_LUNS_CHANGED,
+						dp->uas_bm);
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
@@ -5197,6 +5241,7 @@ static struct attribute *sdebug_drv_attrs[] = {
 	&driver_attr_dev_size_mb.attr,
 	&driver_attr_num_parts.attr,
 	&driver_attr_every_nth.attr,
+	&driver_attr_lun_format.attr,
 	&driver_attr_max_luns.attr,
 	&driver_attr_max_queue.attr,
 	&driver_attr_no_uld.attr,
@@ -5283,9 +5328,19 @@ static int __init scsi_debug_init(void)
 		pr_err("invalid physblk_exp %u\n", sdebug_physblk_exp);
 		return -EINVAL;
 	}
+
+	if (sdebug_lun_format > 2) {
+		pr_warn("Invalid LUN format %u, using default\n",
+			sdebug_lun_format);
+		sdebug_lun_format = SAM2_LUN_ADDRESS_METHOD;
+	}
+
 	if (sdebug_max_luns > 256) {
-		pr_warn("max_luns can be no more than 256, use default\n");
-		sdebug_max_luns = DEF_MAX_LUNS;
+		if (sdebug_max_luns > 16384) {
+			pr_warn("max_luns can be no more than 16384, use default\n");
+			sdebug_max_luns = DEF_MAX_LUNS;
+		}
+		sdebug_lun_format = 1;
 	}
 
 	if (sdebug_lowest_aligned > 0x3fff) {
@@ -5600,6 +5655,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	int (*pfp)(struct scsi_cmnd *, struct sdebug_dev_info *) = NULL;
 	int k, na;
 	int errsts = 0;
+	u64 lun_index = sdp->lun & 0x3FFF;
 	u32 flags;
 	u16 sa;
 	u8 opcode = cmd[0];
@@ -5628,7 +5684,7 @@ static int scsi_debug_queuecommand(struct Scsi_Host *shost,
 	if (fake_host_busy(scp))
 		return SCSI_MLQUEUE_HOST_BUSY;
 	has_wlun_rl = (sdp->lun == SCSI_W_LUN_REPORT_LUNS);
-	if (unlikely((sdp->lun >= sdebug_max_luns) && !has_wlun_rl))
+	if (unlikely((lun_index >= sdebug_max_luns) && !has_wlun_rl))
 		goto err_out;
 
 	sdeb_i = opcode_ind_arr[opcode];	/* fully mapped */
-- 
2.16.4

