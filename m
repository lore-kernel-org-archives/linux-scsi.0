From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] aacraid: prevent out-of-bounds access due to changing fip header sizes
Date: Thu,  4 Aug 2016 10:36:04 +0200
Message-ID: <1470299764-96617-1-git-send-email-jthumshirn@suse.de>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, Pengfei Wang <wpengfeinudt@gmail.com>, Johannes Thumshirn <jthumshirn@suse.de>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

In aacraid's ioctl_send_fib() we do two fetches from userspace, one the
get the fib header's size and one for the fib itself. Later we use the
size field from the second fetch to further process the fib. If for some
reason the size from the second fetch is different than from the first
fix, we may encounter an out-of-bounds access in aac_fib_send(). This was
reported in https://bugzilla.kernel.org/show_bug.cgi?id=116751 and was
assigned CVE-2016-6480.

Reported-by: Pengfei Wang <wpengfeinudt@gmail.com>
Fixes: 7c00ffa31 '[SCSI] 2.6 aacraid: Variable FIB size (updated patch)'
Cc: stable@vger.kernel.org
Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/aacraid/commctrl.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 4b3bb52..2d4acd1 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -118,6 +118,12 @@ static int ioctl_send_fib(struct aac_dev * dev, void __user *arg)
 		goto cleanup;
 	}
 
+	if (size != le16_to_cpu(kfib->header.Size)
+			+ sizeof(struct aac_fibhdr)) {
+		retval = -EINVAL;
+		goto cleanup;
+	}
+
 	if (kfib->header.Command == cpu_to_le16(TakeABreakPt)) {
 		aac_adapter_interrupt(dev);
 		/*
-- 
1.8.5.6
