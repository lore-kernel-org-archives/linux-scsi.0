From: weiping zhang <zhangweiping@didichuxing.com>
Subject: [PATCH] scsi-sysfs: correct errno for host_reset
Date: Fri, 11 Aug 2017 01:52:17 +0800
Message-ID: <20170810175212.GA19528@localhost.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.didichuxing.com ([111.202.154.82]:13622 "EHLO
        BJEXMBX012.didichuxing.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752437AbdHJRw1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 13:52:27 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

if scsi_host_template->host_reset is NULL, when user
"echo adapter > /sys/class/scsi_host/hostx/host_reset",
-EINVAL will return even string compare successfully. It make user confuse.

change to:
-EINVAL		if string not match "adapter" / "firmware";
-EOPNOTSUPP	if string match but not implement ->host_reset.

Signed-off-by: weiping zhang <zhangweiping@didichuxing.com>
---
 drivers/scsi/scsi_sysfs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index dff8faf..3e664f4 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -272,6 +272,8 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 
 	if (sht->host_reset)
 		ret = sht->host_reset(shost, type);
+	else
+		ret = -EOPNOTSUPP;
 
 exit_store_host_reset:
 	if (ret == 0)
-- 
2.9.4
