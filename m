From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v2 2/2] scsi: sd: change manage_start_stop to bool in sysfs
 interface
Date: Thu, 12 Oct 2017 14:57:06 +0800
Message-ID: <316f6176f9269aa0782fd64e7d0e69f52985692c.1507791207.git.zhangweiping@didichuxing.com>
References: <cover.1507791207.git.zhangweiping@didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:18580 "EHLO
        BJEXCAS002.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752416AbdJLG5Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 02:57:16 -0400
Content-Disposition: inline
In-Reply-To: <cover.1507791207.git.zhangweiping@didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

/sys/class/scsi_disk/0:2:0:0/manage_start_stop can be changed to 0
unexpectly by writing invalid string.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index e653dc5..00c9837 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -231,11 +231,15 @@ manage_start_stop_store(struct device *dev, struct device_attribute *attr,
 {
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
+	bool v;
 
 	if (!capable(CAP_SYS_ADMIN))
 		return -EACCES;
 
-	sdp->manage_start_stop = simple_strtoul(buf, NULL, 10);
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdp->manage_start_stop = v ? 1 : 0;
 
 	return count;
 }
-- 
2.9.4
