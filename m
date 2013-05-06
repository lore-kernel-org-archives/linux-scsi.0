From: Zhao Hongjiang <zhaohongjiang@huawei.com>
Subject: [PATCH] scsi: add put_device() after device_find_child()
Date: Mon, 6 May 2013 19:55:21 +0800
Message-ID: <51879A29.7070900@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([119.145.14.64]:6314 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676Ab3EFLzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 May 2013 07:55:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: ravi.anand@qlogic.com, vikas.chaudhary@qlogic.com, linux-scsi@vger.kernel.org

The qla4xxx_sysfs_ddb_add() function uses device_find_child() but it does not drop
the reference of the retrieved child.

Signed-off-by: Zhao Hongjiang <zhaohongjiang@huawei.com>
---
 drivers/scsi/qla4xxx/ql4_os.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/qla4xxx/ql4_os.c b/drivers/scsi/qla4xxx/ql4_os.c
index a47f999..b378d9e 100644
--- a/drivers/scsi/qla4xxx/ql4_os.c
+++ b/drivers/scsi/qla4xxx/ql4_os.c
@@ -5605,6 +5605,7 @@ static int qla4xxx_sysfs_ddb_add(struct Scsi_Host *shost, const char *buf,
 		ql4_printk(KERN_ERR, ha,
 			   "%s: A non-persistent entry %s found\n",
 			   __func__, dev->kobj.name);
+		put_device(dev);
 		goto exit_ddb_add;
 	}
 
-- 
1.7.1

