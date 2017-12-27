From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 04/30] scsi: aacraid: Do not remove offlined devices
Date: Tue, 26 Dec 2017 20:34:25 -0800
Message-ID: <20171227043451.27813-5-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0079.outbound.protection.outlook.com ([104.47.34.79]:10016
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751426AbdL0EfB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:01 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

As part of the recovery process, the drivers removes offline devices (
done by the kernel) and then tries to add them back in the rescan code.
Removing the device is like taking a sledgehammer to a nail.

Set the device as running if it is marked offline.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
None

 drivers/scsi/aacraid/commsup.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index ffbfd04..32b8bdb 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1658,14 +1658,12 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 		command->scsi_done(command);
 	}
 	/*
-	 * Any Device that was already marked offline needs to be cleaned up
+	 * Any Device that was already marked offline needs to be marked
+	 * running
 	 */
 	__shost_for_each_device(dev, host) {
-		if (!scsi_device_online(dev)) {
-			sdev_printk(KERN_INFO, dev, "Removing offline device\n");
-			scsi_remove_device(dev);
-			scsi_device_put(dev);
-		}
+		if (!scsi_device_online(dev))
+			scsi_device_set_state(dev, SDEV_RUNNING);
 	}
 	retval = 0;
 
-- 
2.9.4
