From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Thu, 18 Jan 2018 22:19:32 +0800
Message-ID: <20180118141928.GA28320@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.didichuxing.com ([36.110.17.22]:20788 "EHLO
        BJEXCAS004.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756417AbeAROfA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 09:35:00 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

Add user friendly command strings sd_wce_rcd to enable/disable
write&read cache. User can enable both write and read cache by one of
the following commands:

echo 10 > cache_type
echo "write back" > cache_type

wce rcd write_cache read_cache
0   0   off         on
0   1   off         off
1   0   on          on
1   1   on          off

When execute "cat cache_type", it will show more detail info like following:
write back
10
write:on, read:on

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a028ab3..722e440 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -139,6 +139,15 @@ static const char *sd_cache_types[] = {
 	"write back, no read (daft)"
 };
 
+/*
+ * wce rcd write_cache read_cache
+ * 0   0   off         on
+ * 0   1   off         off
+ * 1   0   on          on
+ * 1   1   on          off
+ */
+static const char * const sd_wce_rcd[] = {"00", "01", "10", "11"};
+
 static void sd_set_flush_flag(struct scsi_disk *sdkp)
 {
 	bool wc = false, fua = false;
@@ -180,8 +189,11 @@ cache_type_store(struct device *dev, struct device_attribute *attr,
 	}
 
 	ct = sysfs_match_string(sd_cache_types, buf);
-	if (ct < 0)
-		return -EINVAL;
+	if (ct < 0) {
+		ct = sysfs_match_string(sd_wce_rcd, buf);
+		if (ct < 0)
+			return -EINVAL;
+	}
 
 	rcd = ct & 0x01 ? 1 : 0;
 	wce = (ct & 0x02) && !sdkp->write_prot ? 1 : 0;
@@ -282,7 +294,9 @@ cache_type_show(struct device *dev, struct device_attribute *attr, char *buf)
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	int ct = sdkp->RCD + 2*sdkp->WCE;
 
-	return sprintf(buf, "%s\n", sd_cache_types[ct]);
+	return sprintf(buf, "%s\n%s\nwrite:%s, read:%s\n", sd_cache_types[ct],
+			sd_wce_rcd[ct], sdkp->WCE ? "on" : "off",
+			sdkp->RCD ? "off" : "on");
 }
 static DEVICE_ATTR_RW(cache_type);
 
-- 
2.9.4
