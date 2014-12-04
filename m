From: "Ewan D. Milne" <emilne@redhat.com>
Subject: [PATCH 3/4] scsi_debug: Add REPORTED LUNS DATA HAS CHANGED Unit Attention
Date: Thu,  4 Dec 2014 11:49:27 -0500
Message-ID: <1417711768-24167-4-git-send-email-emilne@redhat.com>
References: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45164 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbaLDQtd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 11:49:33 -0500
Received: from int-mx14.intmail.prod.int.phx2.redhat.com (int-mx14.intmail.prod.int.phx2.redhat.com [10.5.11.27])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnW0i003358
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:33 -0500
Received: from emilne.csb ([10.18.25.104])
	by int-mx14.intmail.prod.int.phx2.redhat.com (8.14.4/8.14.4) with ESMTP id sB4GnUgF011313
	for <linux-scsi@vger.kernel.org>; Thu, 4 Dec 2014 11:49:31 -0500
In-Reply-To: <1417711768-24167-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

From: "Ewan D. Milne" <emilne@redhat.com>

Generate a REPORTED LUNS DATA HAS CHANGED Unit Attention if
sysfs "max_luns" is used to change the number of scsi_debug LUNs.
This is only done if scsi_debug_scsi_level is SPC-3 or above.
Additionally, implement SPC-4 behavior which only generates
this Unit Attention on the first LUN on the target to receive
a command after the change.  This condition is cleared when
a REPORT LUNS command is received.

Signed-off-by: Ewan D. Milne <emilne@redhat.com>
---
 drivers/scsi/scsi_debug.c | 56 ++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 55 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 1a11466..648abf2 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -80,6 +80,8 @@ static const char *scsi_debug_version_date = "20141022";
 #define INVALID_FIELD_IN_PARAM_LIST 0x26
 #define UA_RESET_ASC 0x29
 #define UA_CHANGED_ASC 0x2a
+#define TARGET_CHANGED_ASC 0x3f
+#define LUNS_CHANGED_ASCQ 0x0e
 #define INSUFF_RES_ASC 0x55
 #define INSUFF_RES_ASCQ 0x3
 #define POWER_ON_RESET_ASCQ 0x0
@@ -181,7 +183,8 @@ static const char *scsi_debug_version_date = "20141022";
 #define SDEBUG_UA_BUS_RESET 1
 #define SDEBUG_UA_MODE_CHANGED 2
 #define SDEBUG_UA_CAPACITY_CHANGED 3
-#define SDEBUG_NUM_UAS 4
+#define SDEBUG_UA_LUNS_CHANGED 4
+#define SDEBUG_NUM_UAS 5
 
 /* for check_readiness() */
 #define UAS_ONLY 1	/* check for UAs only */
@@ -783,6 +786,22 @@ static int scsi_debug_ioctl(struct scsi_device *dev, int cmd, void __user *arg)
 	/* return -ENOTTY; // correct return but upsets fdisk */
 }
 
+static int clear_luns_changed_on_target(struct sdebug_dev_info *devip)
+{
+	struct sdebug_host_info *sdhp;
+	struct sdebug_dev_info *dp;
+
+	spin_lock(&sdebug_host_list_lock);
+	list_for_each_entry(sdhp, &sdebug_host_list, host_list) {
+		list_for_each_entry(dp, &sdhp->dev_info_list, dev_list) {
+			if ((devip->sdbg_host == dp->sdbg_host) &&
+			    (devip->target == dp->target))
+				clear_bit(SDEBUG_UA_LUNS_CHANGED, dp->uas_bm);
+		}
+	}
+	spin_unlock(&sdebug_host_list_lock);
+}
+
 static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			   struct sdebug_dev_info * devip)
 {
@@ -818,6 +837,23 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			if (debug)
 				cp = "capacity data changed";
 			break;
+		case SDEBUG_UA_LUNS_CHANGED:
+			/*
+			 * SPC-3 behavior is to report a UNIT ATTENTION with
+			 * ASC/ASCQ REPORTED LUNS DATA HAS CHANGED on every LUN
+			 * on the target, until a REPORT LUNS command is
+			 * received.  SPC-4 behavior is to report it only once.
+			 * NOTE:  scsi_debug_scsi_level does not use the same
+			 * values as struct scsi_device->scsi_level.
+			 */
+			if (scsi_debug_scsi_level >= 6)	/* SPC-4 and above */
+				clear_luns_changed_on_target(devip);
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					TARGET_CHANGED_ASC,
+					LUNS_CHANGED_ASCQ);
+			if (debug)
+				cp = "reported luns data has changed";
+			break;
 		default:
 			pr_warn("%s: unexpected unit attention code=%d\n",
 				__func__, k);
@@ -3229,6 +3265,7 @@ static int resp_report_luns(struct scsi_cmnd * scp,
 	unsigned char arr[SDEBUG_RLUN_ARR_SZ];
 	unsigned char * max_addr;
 
+	clear_luns_changed_on_target(devip);
 	alloc_len = cmd[9] + (cmd[8] << 8) + (cmd[7] << 16) + (cmd[6] << 24);
 	shortish = (alloc_len < 4);
 	if (shortish || (select_report > 2)) {
@@ -4369,10 +4406,27 @@ static ssize_t max_luns_store(struct device_driver *ddp, const char *buf,
 			      size_t count)
 {
         int n;
+	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		changed = (scsi_debug_max_luns != n);
 		scsi_debug_max_luns = n;
 		sdebug_max_tgts_luns();
+		if (changed && (scsi_debug_scsi_level >= 5)) {	/* >= SPC-3 */
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
 		return count;
 	}
 	return -EINVAL;
-- 
1.7.11.7

