From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH v2 1/2] scsi: sd: change allow_restart to bool in sysfs
 interface
Date: Thu, 12 Oct 2017 14:56:44 +0800
Message-ID: <849d18ab943e583b1d077e091b00caa8d63da74b.1507791207.git.zhangweiping@didichuxing.com>
References: <cover.1507791207.git.zhangweiping@didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 22.17.110.36.static.bjtelecom.net ([36.110.17.22]:9233 "EHLO
        BJEXCAS006.didichuxing.com" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751237AbdJLG4v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 12 Oct 2017 02:56:51 -0400
Content-Disposition: inline
In-Reply-To: <cover.1507791207.git.zhangweiping@didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
Cc: linux-scsi@vger.kernel.org

/sys/class/scsi_disk/0:2:0:0/allow_restart can be changed to 0 unexpectly
by writing invalid string, like following:

echo asdf > /sys/class/scsi_disk/0:2:0:0/allow_restart

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/sd.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3ef2214..e653dc5 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -253,6 +253,7 @@ static ssize_t
 allow_restart_store(struct device *dev, struct device_attribute *attr,
 		    const char *buf, size_t count)
 {
+	bool v;
 	struct scsi_disk *sdkp = to_scsi_disk(dev);
 	struct scsi_device *sdp = sdkp->device;
 
@@ -262,7 +263,10 @@ allow_restart_store(struct device *dev, struct device_attribute *attr,
 	if (sdp->type != TYPE_DISK && sdp->type != TYPE_ZBC)
 		return -EINVAL;
 
-	sdp->allow_restart = simple_strtoul(buf, NULL, 10);
+	if (kstrtobool(buf, &v))
+		return -EINVAL;
+
+	sdp->allow_restart = v ? 1 : 0;
 
 	return count;
 }
-- 
2.9.4
