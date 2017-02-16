From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH V2 09/15] aacraid: Reload offlined drives after controller reset
Date: Thu, 16 Feb 2017 12:51:18 -0800
Message-ID: <20170216205124.20271-10-RaghavaAditya.Renukunta@microsemi.com>
References: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam01on0045.outbound.protection.outlook.com ([104.47.34.45]:30432
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755018AbdBQD2U (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Feb 2017 22:28:20 -0500
In-Reply-To: <20170216205124.20271-1-RaghavaAditya.Renukunta@microsemi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: David.Carroll@microsemi.com, Gana.Sridaran@microsemi.com, Scott.Benesh@microsemi.com, jthumshirn@suse.de, dan.carpenter@oracle.com

During the IOP reset stress testing, it was found that the drives can be
marked offline when the adapter controller crashes and IO's are running
in parallel. When the controller  does come back from the reset, the drive
that is marked offline is not exposed.

Fixed by removing and adding drives that are marked offline. In addition
invoke a scsi host bus rescan to capture any additional configuration
changes.

Signed-off-by: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Reviewed-by: David Carroll <David.Carroll@microsemi.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

---
Changes in V2:
None

 drivers/scsi/aacraid/commsup.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/commsup.c
index eb4d8cf..1f716c0 100644
--- a/drivers/scsi/aacraid/commsup.c
+++ b/drivers/scsi/aacraid/commsup.c
@@ -1637,11 +1637,29 @@ static int _aac_reset_adapter(struct aac_dev *aac, int forced, u8 reset_type)
 		command->SCp.phase = AAC_OWNER_ERROR_HANDLER;
 		command->scsi_done(command);
 	}
+	/*
+	 * Any Device that was already marked offline needs to be cleaned up
+	 */
+	__shost_for_each_device(dev, host) {
+		if (!scsi_device_online(dev)) {
+			sdev_printk(KERN_INFO, dev, "Removing offline device\n");
+			scsi_remove_device(dev);
+			scsi_device_put(dev);
+		}
+	}
 	retval = 0;
 
 out:
 	aac->in_reset = 0;
 	scsi_unblock_requests(host);
+	/*
+	 * Issue bus rescan to catch any configuration that might have
+	 * occurred
+	 */
+	if (!retval) {
+		dev_info(&aac->pdev->dev, "Issuing bus rescan\n");
+		scsi_scan_host(host);
+	}
 	if (jafo) {
 		spin_lock_irq(host->host_lock);
 	}
-- 
2.7.4
