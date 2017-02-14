From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 11/16] aacraid: Decrease adapter health check  interval
Date: Tue, 14 Feb 2017 12:44:41 -0800
Message-ID: <20170214204446.14808-12-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-co1nam03on0054.outbound.protection.outlook.com ([104.47.40.54]:48688
        "EHLO NAM03-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751617AbdBODWq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:46 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

Currently driver checks the health status of the adapter once every 24
hours. When that happens the driver becomes dependent on the kernel to
figure out if the  adapter is misbehaving. This might take some time
(when the adapter is idle). The driver currently has support to
restart/recover the controller when it fails, and decreasing the time
interval will help.

Fixed by decreasing check interval from 24 hours to 1 minute

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/aachba.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 98d4ffd..3ede50f 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -311,7 +311,7 @@ module_param(update_interval, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(update_interval, "Interval in seconds between time sync"
 	" updates issued to adapter.");
 
-int check_interval = 24 * 60 * 60;
+int check_interval = 60;
 module_param(check_interval, int, S_IRUGO|S_IWUSR);
 MODULE_PARM_DESC(check_interval, "Interval in seconds between adapter health"
 	" checks.");
-- 
2.7.4
