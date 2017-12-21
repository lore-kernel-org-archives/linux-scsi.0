From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 04/29] scsi: aacraid: Do not remove offlined devices
Date: Thu, 21 Dec 2017 09:33:55 -0800
Message-ID: <20171221173420.8213-5-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0048.outbound.protection.outlook.com ([104.47.38.48]:18521
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753761AbdLURee (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:34 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

As part of the recovery process, the drivers removes offline devices (
done by the kernel) and then tries to add them back in the rescan code.
Removing the device is like taking a sledgehammer to a nail.

Set the device as running if it is marked offline.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
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
