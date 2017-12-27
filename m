From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 06/30] scsi: aacraid: Allow reset_host sysfs var to recover Panicked Fw
Date: Tue, 26 Dec 2017 20:34:27 -0800
Message-ID: <20171227043451.27813-7-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0079.outbound.protection.outlook.com ([104.47.34.79]:10016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751715AbdL0EfF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:05 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

It is possible to restart the controller via the use of the reset_host
sysfs variable. This does work for controllers that can no longer respond,
since driver will attempt to send down a shutdown in this path.

Check if the controller is able to receive commands before sending down
a shutdown

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/comminit.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/aacraid/comminit.c b/drivers/scsi/aacraid/comminit.c
index 1bc623a..9eff246 100644
--- a/drivers/scsi/aacraid/comminit.c
+++ b/drivers/scsi/aacraid/comminit.c
@@ -295,12 +295,10 @@ int aac_send_shutdown(struct aac_dev * dev)
 {
 	struct fib * fibctx;
 	struct aac_close *cmd;
-	int status;
+	int status = 0;
 
-	fibctx = aac_fib_alloc(dev);
-	if (!fibctx)
-		return -ENOMEM;
-	aac_fib_init(fibctx);
+	if (aac_adapter_check_health(dev))
+		return status;
 
 	if (!dev->adapter_shutdown) {
 		mutex_lock(&dev->ioctl_mutex);
@@ -308,6 +306,11 @@ int aac_send_shutdown(struct aac_dev * dev)
 		mutex_unlock(&dev->ioctl_mutex);
 	}
 
+	fibctx = aac_fib_alloc(dev);
+	if (!fibctx)
+		return -ENOMEM;
+	aac_fib_init(fibctx);
+
 	cmd = (struct aac_close *) fib_data(fibctx);
 	cmd->command = cpu_to_le32(VM_CloseAll);
 	cmd->cid = cpu_to_le32(0xfffffffe);
-- 
2.9.4
