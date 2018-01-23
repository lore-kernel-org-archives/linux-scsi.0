From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v3] scsi: sd: add new match array for cache_type
Date: Tue, 23 Jan 2018 22:44:44 +0800
Message-ID: <20180123144439.GA15247@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.didichuxing.com ([36.110.17.22]:13294 "EHLO
        BJEXCAS002.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751565AbeAWOo7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 23 Jan 2018 09:44:59 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

add user friendly command strings sd_wr_cache to enable/disable
write&read cache. user can enable both write and read cache by one of
the following commands:

echo w1r1 > cache_type
echo "write back" > cache_type

sd_wr_cache[] = {"w0r1", "w0r0", "w1r1", "w1r0"};
for sd_wr_cache 0 means disable, 1 means enable.

Encoding                          | WCE RCD | Write_cache Read_cache
--------------------------------------------------------------------
write through              / w0r1 | 0   0   | off         on
none                       / w0r0 | 0   1   | off         off
write back                 / w1r1 | 1   0   | on          on
write back, no read (daft) / w1r0 | 1   1   | on          off

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a028ab3..ce2fda5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -134,10 +134,20 @@ static DEFINE_MUTEX(sd_ref_mutex);
 static struct kmem_cache *sd_cdb_cache;
 static mempool_t *sd_cdb_pool;
 
+/*
+ * Encoding                          | WCE RCD | Write_cache Read_cache
+ * --------------------------------------------------------------------
+ * write through              / w0r1 | 0   0   | off         on
+ * none                       / w0r0 | 0   1   | off         off
+ * write back                 / w1r1 | 1   0   | on          on
+ * write back, no read (daft) / w1r0 | 1   1   | on          off
+ */
 static const char *sd_cache_types[] = {
 	"write through", "none", "write back",
 	"write back, no read (daft)"
 };
+/* 0:disable, 1:enable */
+static const char * const sd_wr_cache[] = {"w0r1", "w0r0", "w1r1", "w1r0"};
 
 static void sd_set_flush_flag(struct scsi_disk *sdkp)
 {
@@ -172,6 +182,10 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 		 * it's not worth the risk */
 		return -EINVAL;
 
+	/*
+	 * for "temporary", we only change request_queue's flag, not send
+	 * any command to disk, so actually disk'cache dosen't changed yet.
+	 */
 	if (strncmp(buf, temp, sizeof(temp) - 1) == 0) {
 		buf += sizeof(temp) - 1;
 		sdkp->cache_override = 1;
@@ -180,8 +194,11 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	ct = sysfs_match_string(sd_cache_types, buf);
-	if (ct < 0)
-		return -EINVAL;
+	if (ct < 0) {
+		ct = sysfs_match_string(sd_wr_cache, buf);
+		if (ct < 0)
+			return -EINVAL;
+	}
 
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
-- 
2.9.4
