From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 15/16] aacraid: Fix a potential spinlock double unlock bug
Date: Tue, 14 Feb 2017 12:44:45 -0800
Message-ID: <20170214204446.14808-16-RaghavaAditya.Renukunta@microsemi.com>
References: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0053.outbound.protection.outlook.com ([104.47.38.53]:48446
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751694AbdBODWo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Feb 2017 22:22:44 -0500
In-Reply-To: <20170214204446.14808-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

The driver does not unlock the reply  queue spin lock after handling SMART
adapter events. Instead it might attempt to unlock an already unlocked
spin lock.

Fixed by making sure the driver locks the spin lock before freeing it.

Thank you dan for finding this issue out.

Fixes: 6223a39fe6fbbeef (scsi: aacraid: Added support for hotplug)
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 0ee91d0..4141de0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -2213,7 +2213,7 @@ static void aac_process_events(struct aac_dev *dev)
 			/* Thor AIF */
 			aac_handle_sa_aif(dev, fib);
 			aac_fib_adapter_complete(fib, (u16)sizeof(u32));
-			continue;
+			goto free_fib;
 		}
 		/*
 		 *	We will process the FIB here or pass it to a
-- 
2.7.4
