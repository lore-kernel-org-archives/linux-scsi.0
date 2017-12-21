From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 03/29] scsi: aacraid: Fix hang in kdump
Date: Thu, 21 Dec 2017 09:33:54 -0800
Message-ID: <20171221173420.8213-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0042.outbound.protection.outlook.com ([104.47.42.42]:27728
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753819AbdLURef (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 12:34:35 -0500
In-Reply-To: <20171221173420.8213-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, aacraid@microsemi.com, tom.white@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>

Driver attempts to perform a device scan and device add after coming out
of reset. At times when the kdump kernel loads and it tries to perform
eh recovery, the device scan hangs since its commands are blocked because
of the eh recovery. This should have shown up in normal eh recovery path
(Should have been obvious)

Remove the code that performs scanning.I can live without the rescanning
support in the stable kernels but a hanging kdump/eh recovery needs to be
fixed.

Fixes: a2d0321dd532901e (scsi: aacraid: Reload offlined drives after controller reset)
Cc: <stable@vger.kernel.org>
Reported-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Fixes: a2d0321dd532901e (scsi: aacraid: Reload offlined drives after controller reset)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
---
 drivers/scsi/aacraid/commsup.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index 525a652..ffbfd04 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1672,14 +1672,7 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 out:
 	aac->in_reset = 0;
 	scsi_unblock_requests(host);
-	/*
-	 * Issue bus rescan to catch any configuration that might have
-	 * occurred
-	 */
-	if (!retval) {
-		dev_info(&aac->pdev->dev, "Issuing bus rescan\n");
-		scsi_scan_host(host);
-	}
+
 	if (jafo) {
 		spin_lock_irq(host->host_lock);
 	}
-- 
2.9.4
