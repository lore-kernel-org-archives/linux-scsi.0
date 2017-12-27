From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 03/30] scsi: aacraid: Fix hang in kdump
Date: Tue, 26 Dec 2017 20:34:24 -0800
Message-ID: <20171227043451.27813-4-RaghavaAditya.Renukunta@microsemi.com>
References: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0045.outbound.protection.outlook.com ([104.47.33.45]:39616
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751591AbdL0EfB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Dec 2017 23:35:01 -0500
In-Reply-To: <20171227043451.27813-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

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
Reported-by: Douglas Miller <dougmill@linux.vnet.ibm.com>
Tested-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
Fixes: a2d0321dd532901e (scsi: aacraid: Reload offlined drives after controller reset)
Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>

---
Changes in V2:
Changed reported by from Guilherme G. Piccoli to Douglas Miller

 drivers/scsi/aacraid/aachba.c  | 1 -
 drivers/scsi/aacraid/commsup.c | 9 +--------
 2 files changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
index 548a3e7..7173ae5 100644
--- a/drivers/scsi/aacraid/aachba.c
+++ b/drivers/scsi/aacraid/aachba.c
@@ -918,7 +918,6 @@ static void setinqstr(struct aac_dev *dev, void *data, int tindex)
 		char *cname = kmemdup(sup_adap_info->adapter_type_text,
 				sizeof(sup_adap_info->adapter_type_text),
 								GFP_ATOMIC);
-
 		if (!cname)
 			return;
 
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
