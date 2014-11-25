From: Douglas Gilbert <dgilbert@interlog.com>
Subject: [PATCH v2 3/5] scsi_debug: add Capacity Changed Unit Attention
Date: Mon, 24 Nov 2014 23:05:20 -0500
Message-ID: <54740000.3010104@interlog.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------030007080508050403020402"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:54385 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260AbaKYEFf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Nov 2014 23:05:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>
Cc: "Martin K. Petersen" <martin.petersen@ORACLE.COM>

This is a multi-part message in MIME format.
--------------030007080508050403020402
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:27:51 -0500
Subject: [PATCH 3/5] add Capacity Changed Unit Attention

Via sysfs the virtual_gb scsi_debug parameter can be changed while
LUs are in use. If that changes, the 'Capacity data has changed'
Unit Attention is queued on all LUs.
---
  drivers/scsi/scsi_debug.c | 28 ++++++++++++++++++++++++----
  1 file changed, 24 insertions(+), 4 deletions(-)

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>

--------------030007080508050403020402
Content-Type: text/x-patch;
 name="0003-add-Capacity-Changed-Unit-Attention.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="0003-add-Capacity-Changed-Unit-Attention.patch"

>From 54eeff05237c4872fb1f5dcf1edddaace467d5b0 Mon Sep 17 00:00:00 2001
From: Douglas Gilbert <dgilbert@interlog.com>
Date: Mon, 24 Nov 2014 20:27:51 -0500
Subject: [PATCH 3/5] add Capacity Changed Unit Attention

Via sysfs the virtual_gb scsi_debug parameter can be changed while
LUs are in use. If that changes, the 'Capacity data has changed'
Unit Attention is queued on all LUs.
---
 drivers/scsi/scsi_debug.c | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index d337eaa..ee99aca 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -179,7 +179,8 @@ static const char *scsi_debug_version_date = "20141022";
 #define SDEBUG_UA_POR 0		/* Power on, reset, or bus device reset */
 #define SDEBUG_UA_BUS_RESET 1
 #define SDEBUG_UA_MODE_CHANGED 2
-#define SDEBUG_NUM_UAS 3
+#define SDEBUG_UA_CAPACITY_CHANGED 3
+#define SDEBUG_NUM_UAS 4
 
 /* for check_readiness() */
 #define UAS_ONLY 1
@@ -582,6 +583,11 @@ static int check_readiness(struct scsi_cmnd *SCpnt, int uas_only,
 			if (debug)
 				cp = "mode parameters changed";
 			break;
+		case SDEBUG_UA_CAPACITY_CHANGED:
+			mk_sense_buffer(SCpnt, UNIT_ATTENTION,
+					UA_CHANGED_ASC, CAPACITY_CHANGED_ASCQ);
+			if (debug)
+				cp = "capacity data changed";
 		default:
 			pr_warn("%s: unexpected unit attention code=%d\n",
 				__func__, k);
@@ -3638,16 +3644,30 @@ static ssize_t virtual_gb_show(struct device_driver *ddp, char *buf)
 {
         return scnprintf(buf, PAGE_SIZE, "%d\n", scsi_debug_virtual_gb);
 }
+
 static ssize_t virtual_gb_store(struct device_driver *ddp, const char *buf,
 				size_t count)
 {
-        int n;
+	int n;
+	bool changed;
 
 	if ((count > 0) && (1 == sscanf(buf, "%d", &n)) && (n >= 0)) {
+		changed = (scsi_debug_virtual_gb != n);
 		scsi_debug_virtual_gb = n;
-
 		sdebug_capacity = get_sdebug_capacity();
-
+		if (changed) {
+			struct sdebug_host_info *sdhp;
+			struct sdebug_dev_info *dp;
+
+			list_for_each_entry(sdhp, &sdebug_host_list,
+					    host_list) {
+				list_for_each_entry(dp, &sdhp->dev_info_list,
+						    dev_list) {
+					set_bit(SDEBUG_UA_CAPACITY_CHANGED,
+						dp->uas_bm);
+				}
+			}
+		}
 		return count;
 	}
 	return -EINVAL;
-- 
1.9.1


--------------030007080508050403020402--
