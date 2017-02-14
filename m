From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 08/16] aacraid: Skip wellness sync on controller failure
Date: Tue, 14 Feb 2017 12:44:38 -0800
Message-ID: <20170214204446.14808-9-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0065.outbound.protection.outlook.com ([104.47.33.65]:10688
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751664AbdBODWh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:37 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

aac_command_thread checks on the health of controller periodically,
using aac_check_health. If the status is an error state KERNEL_PANIC or
anything else. The driver will attempt to restart the adapter, but the
response is not checked in aac_command_thread. This allows the periodic
sync to go thru and lead the driver to a hung state.

Fixed by terminating the periodic loop(intended per original design),
if the controller is not restored to a healthy state.

Cc: stable@vger.kernel.org
Fixes: 3d77d8404478353358 (scsi: aacraid: Added support for periodic wellness sync)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 863c98d..de4285d 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2472,7 +2472,7 @@ int aac_command_thread(void *data)
 
 			/* Don't even try to talk to adapter if its sick */
 			ret = aac_check_health(dev);
-			if (!dev->queues)
+			if (ret || !dev->queues)
 				break;
 			next_check_jiffies = jiffies
 					   + ((long)(unsigned)check_interval)
-- 
2.7.4
