From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 05/30] scsi: aacraid: Fix ioctl reset hang
Date: Tue, 26 Dec 2017 20:34:26 -0800
Message-ID: <20171227043451.27813-6-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0087.outbound.protection.outlook.com ([104.47.34.87]:27920
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751694AbdL0EfD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:03 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

Driver would hang when attempting to send reset from the ioctl interface,
since it would wait to retrieve the ioctl mutex at send shutdown.

Set adapter shutdown and unlock mutex before sending down reset request.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/commctrl.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commctrl.c b/drivers/scsi/aacraid/commctrl.c
index 9ab0fa9..a2b3430 100644
--- a/drivers/scsi/aacraid/commctrl.c
+++ b/drivers/scsi/aacraid/commctrl.c
@@ -1052,9 +1052,13 @@ static int aac_send_reset_adapter(struct aac_dev *dev, void __user *arg)
 	if (copy_from_user((void *)&reset, arg, sizeof(struct aac_reset_iop)))
 		return -EFAULT;
 
+	dev->adapter_shutdown = 1;
+
+	mutex_unlock(&dev->ioctl_mutex);
 	retval = aac_reset_adapter(dev, 0, reset.reset_type);
-	return retval;
+	mutex_lock(&dev->ioctl_mutex);
 
+	return retval;
 }
 
 int aac_do_ioctl(struct aac_dev * dev, int cmd, void __user *arg)
-- 
2.9.4
