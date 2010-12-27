From: Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 4/8] [SCSI] scst: Substitute SCST_SYSFS_BLOCK_SIZE
Date: Mon, 27 Dec 2010 14:39:06 +0100
Message-ID: <201012271439.06828.bvanassche@acm.org>
References: <201012271435.33778.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jester.euphonynet.be ([212.87.96.13]:52070 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753777Ab0L0NjO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Dec 2010 08:39:14 -0500
In-Reply-To: <201012271435.33778.bvanassche@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scst-devel@lists.sourceforge.net, Greg Kroah-Hartman <gregkh@suse.de>, Konrad Rzeszutek Wilk <konrad@darnok.org>, Vladislav Bolkhovitin <vst@vlnb.net>, Richard Sharpe <realrichardsharpe@gmail.com>

Replace all instances of SCST_SYSFS_BLOCK_SIZE by PAGE_SIZE and remove the
symbolic constant SCST_SYSFS_BLOCK_SIZE.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
---
 drivers/scst/scst_sysfs.c |   54 +++++++++++++++++++-------------------------
 include/scst/scst_const.h |    2 -
 2 files changed, 23 insertions(+), 33 deletions(-)

diff --git a/drivers/scst/scst_sysfs.c b/drivers/scst/scst_sysfs.c
index da325f5..ed10475 100644
--- a/drivers/scst/scst_sysfs.c
+++ b/drivers/scst/scst_sysfs.c
@@ -1531,7 +1531,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 		processed_cmds_wr = latency_stat->processed_cmds_wr;
 		processed_cmds_rd = latency_stat->processed_cmds_rd;
 
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			 "%-5s %-9s %-15lu ", "Write", scst_io_size_names[i],
 			(unsigned long)processed_cmds_wr);
 		if (processed_cmds_wr == 0)
@@ -1543,8 +1543,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)scst_time_wr,
 			(unsigned long)latency_stat->max_scst_time_wr,
 			(unsigned long)latency_stat->scst_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
 
 		do_div(tgt_time_wr, processed_cmds_wr);
 		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
@@ -1552,8 +1551,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)tgt_time_wr,
 			(unsigned long)latency_stat->max_tgt_time_wr,
 			(unsigned long)latency_stat->tgt_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
 
 		do_div(dev_time_wr, processed_cmds_wr);
 		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
@@ -1561,10 +1559,9 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)dev_time_wr,
 			(unsigned long)latency_stat->max_dev_time_wr,
 			(unsigned long)latency_stat->dev_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s\n", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
 
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-5s %-9s %-15lu ", "Read", scst_io_size_names[i],
 			(unsigned long)processed_cmds_rd);
 		if (processed_cmds_rd == 0)
@@ -1576,8 +1573,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)scst_time_rd,
 			(unsigned long)latency_stat->max_scst_time_rd,
 			(unsigned long)latency_stat->scst_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
 
 		do_div(tgt_time_rd, processed_cmds_rd);
 		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
@@ -1585,8 +1581,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)tgt_time_rd,
 			(unsigned long)latency_stat->max_tgt_time_rd,
 			(unsigned long)latency_stat->tgt_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s", buf);
 
 		do_div(dev_time_rd, processed_cmds_rd);
 		snprintf(buf, sizeof(buf), "%lu/%lu/%lu/%lu",
@@ -1594,8 +1589,7 @@ static ssize_t scst_tgt_dev_latency_show(struct kobject *kobj,
 			(unsigned long)dev_time_rd,
 			(unsigned long)latency_stat->max_dev_time_rd,
 			(unsigned long)latency_stat->dev_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
-			"%-47s\n", buf);
+		res += scnprintf(&buffer[res], PAGE_SIZE - res, "%-47s\n", buf);
 	}
 	return res;
 }
@@ -1671,7 +1665,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 	sess = scst_kobj_to_sess(kobj);
 
 	res = 0;
-	res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
 		"%-15s %-15s %-46s %-46s %-46s\n",
 		"T-L names", "Total commands", "SCST latency",
 		"Target latency", "Dev latency (min/avg/max/all ns)");
@@ -1695,7 +1689,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 		processed_cmds_wr = latency_stat->processed_cmds_wr;
 		processed_cmds_rd = latency_stat->processed_cmds_rd;
 
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-5s %-9s %-15lu ",
 			"Write", scst_io_size_names[i],
 			(unsigned long)processed_cmds_wr);
@@ -1708,7 +1702,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)scst_time_wr,
 			(unsigned long)latency_stat->max_scst_time_wr,
 			(unsigned long)latency_stat->scst_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s", buf);
 
 		do_div(tgt_time_wr, processed_cmds_wr);
@@ -1717,7 +1711,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)tgt_time_wr,
 			(unsigned long)latency_stat->max_tgt_time_wr,
 			(unsigned long)latency_stat->tgt_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s", buf);
 
 		do_div(dev_time_wr, processed_cmds_wr);
@@ -1726,10 +1720,10 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)dev_time_wr,
 			(unsigned long)latency_stat->max_dev_time_wr,
 			(unsigned long)latency_stat->dev_time_wr);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s\n", buf);
 
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-5s %-9s %-15lu ",
 			"Read", scst_io_size_names[i],
 			(unsigned long)processed_cmds_rd);
@@ -1742,7 +1736,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)scst_time_rd,
 			(unsigned long)latency_stat->max_scst_time_rd,
 			(unsigned long)latency_stat->scst_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s", buf);
 
 		do_div(tgt_time_rd, processed_cmds_rd);
@@ -1751,7 +1745,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)tgt_time_rd,
 			(unsigned long)latency_stat->max_tgt_time_rd,
 			(unsigned long)latency_stat->tgt_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s", buf);
 
 		do_div(dev_time_rd, processed_cmds_rd);
@@ -1760,7 +1754,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 			(unsigned long)dev_time_rd,
 			(unsigned long)latency_stat->max_dev_time_rd,
 			(unsigned long)latency_stat->dev_time_rd);
-		res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+		res += scnprintf(&buffer[res], PAGE_SIZE - res,
 			"%-47s\n", buf);
 	}
 
@@ -1769,7 +1763,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 	dev_time = sess->dev_time;
 	processed_cmds = sess->processed_cmds;
 
-	res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
 		"\n%-15s %-16d", "Overall ", processed_cmds);
 
 	if (processed_cmds == 0)
@@ -1781,7 +1775,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 		(unsigned long)scst_time,
 		(unsigned long)sess->max_scst_time,
 		(unsigned long)sess->scst_time);
-	res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
 		"%-47s", buf);
 
 	do_div(tgt_time, processed_cmds);
@@ -1790,7 +1784,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 		(unsigned long)tgt_time,
 		(unsigned long)sess->max_tgt_time,
 		(unsigned long)sess->tgt_time);
-	res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
 		"%-47s", buf);
 
 	do_div(dev_time, processed_cmds);
@@ -1799,7 +1793,7 @@ static ssize_t scst_sess_latency_show(struct kobject *kobj,
 		(unsigned long)dev_time,
 		(unsigned long)sess->max_dev_time,
 		(unsigned long)sess->dev_time);
-	res += scnprintf(&buffer[res], SCST_SYSFS_BLOCK_SIZE - res,
+	res += scnprintf(&buffer[res], PAGE_SIZE - res,
 		"%-47s\n\n", buf);
 
 	spin_unlock_bh(&sess->lat_lock);
@@ -1937,8 +1931,7 @@ static ssize_t scst_sess_sysfs_initiator_name_show(struct kobject *kobj,
 
 	sess = scst_kobj_to_sess(kobj);
 
-	return scnprintf(buf, SCST_SYSFS_BLOCK_SIZE, "%s\n",
-		sess->initiator_name);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", sess->initiator_name);
 }
 
 static struct kobj_attribute session_initiator_name_attr =
@@ -2588,8 +2581,7 @@ out:
 static ssize_t scst_acn_file_show(struct kobject *kobj,
 	struct kobj_attribute *attr, char *buf)
 {
-	return scnprintf(buf, SCST_SYSFS_BLOCK_SIZE, "%s\n",
-		attr->attr.name);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", attr->attr.name);
 }
 
 int scst_acn_sysfs_create(struct scst_acn *acn)
diff --git a/include/scst/scst_const.h b/include/scst/scst_const.h
index d1dadfa..ac446fa 100644
--- a/include/scst/scst_const.h
+++ b/include/scst/scst_const.h
@@ -379,8 +379,6 @@ enum scst_cdb_flags {
 /*************************************************************
  ** Misc constants
  *************************************************************/
-#define SCST_SYSFS_BLOCK_SIZE			PAGE_SIZE
-
 #define SCST_PR_DIR				"/var/lib/scst/pr"
 
 #define TID_COMMON_SIZE				24
-- 
1.7.1

