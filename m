From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 27/29] scsi: aacraid: Skip schedule rescan in case of kdump
Date: Thu, 21 Dec 2017 09:34:18 -0800
Message-ID: <20171221173420.8213-28-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam02on0070.outbound.protection.outlook.com ([104.47.36.70]:57584
        "EHLO NAM02-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754670AbdLURfB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:35:01 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

There is a chance of the driver being stuck in kdump if drives start acting
up in kdump discovery process and the kernel decides to send eh resets,
which would prompt rescan to be scheduled.

Do not perform a rescan in kdump context, since we do not expect a hotplug
event during kdump and all the devices are going to go away anyway.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index adebf2e..6f5dfc9 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -33,6 +33,7 @@
 
 #include <linux/kernel.h>
 #include <linux/init.h>
+#include <linux/crash_dump.h>
 #include <linux/types.h>
 #include <linux/sched.h>
 #include <linux/pci.h>
@@ -1675,7 +1676,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 	 * Issue bus rescan to catch any configuration that might have
 	 * occurred
 	 */
-	if (!retval) {
+	if (!retval && !is_kdump_kernel()) {
 		dev_info(&aac->pdev->dev, "Scheduling bus rescan\n");
 		aac_schedule_safw_scan_worker(aac);
 	}
-- 
2.9.4
