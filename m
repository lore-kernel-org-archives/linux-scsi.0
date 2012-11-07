From: Nikolay Aleksandrov <nikolay@redhat.com>
Subject: [PATCH] [SCSI] scsi_sysfs: fix a buffer overflow in sysfs handling
Date: Wed,  7 Nov 2012 11:57:46 +0100
Message-ID: <1352285866-16593-1-git-send-email-nikolay@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, JBottomley@parallels.com, nikolay@redhat.com
List-Id: linux-scsi@vger.kernel.org

 Fix a stack buffer overflow in the SCSI layer sysfs handling code 
 (store_host_reset()). When a host reset type is read via sscanf in str
 there is no limit on the length and str is defined as char str[10].

How to reproduce:
 Given that the sysfs entry exists, execute
 echo "AAAAAAAAAAAAAAAA" > /sys/devices/pci0000:00/0000:00:1f.2/ata1/host0/scsi_host/host0/host_reset

Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
---
 drivers/scsi/scsi_sysfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index ce5224c..51826e2 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -267,7 +267,7 @@ store_host_reset(struct device *dev, struct device_attribute *attr,
 	char str[10];
 	int type;
 
-	sscanf(buf, "%s", str);
+	sscanf(buf, "%9s", str);
 	type = check_reset_type(str);
 
 	if (!type)
-- 
1.7.11.4
