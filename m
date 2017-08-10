From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 5/7] smartpqi: update kexec and power down support
Date: Thu, 10 Aug 2017 13:47:03 -0500
Message-ID: <150239082347.23771.3123846290283011411.stgit@brunhilda>
References: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0077.outbound.protection.outlook.com ([104.47.37.77]:28073
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1753093AbdHJSrY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 10 Aug 2017 14:47:24 -0400
In-Reply-To: <150239072706.23771.1380444570336852695.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joseph.szczypek@hpe.com, gerry.morong@microsemi.com, john.hall@microsemi.com, jejb@linux.vnet.ibm.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, bader.alisaleh@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, POSWALD@suse.com
Cc: linux-scsi@vger.kernel.org

From: Kevin Barnett <kevin.barnett@microsemi.com>

add PQI reset to driver shutdown callback to
work around controller bug.

During an 1.) OS shutdown or 2.) kexec outside of a kdump,
the Linux kernel will clear BME on our controller.

If BME is cleared during a controller/host PCIe transfer,
the controller will lock up.

So we perform a PQI reset in the driver's shutdown callback
function to eliminate the possibility of a controller/host
PCIe transfer being active when the kernel clears BME immediately
after calling the driver's shutdown callback.

Reviewed-by: Scott Benesh <scott.benesh@microsemi.com>
Signed-off-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/smartpqi/smartpqi_init.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/smartpqi/smartpqi_init.c b/drivers/scsi/smartpqi/smartpqi_init.c
index 70b1f97..afd3eed 100644
--- a/drivers/scsi/smartpqi/smartpqi_init.c
+++ b/drivers/scsi/smartpqi/smartpqi_init.c
@@ -6700,6 +6700,7 @@ static void pqi_shutdown(struct pci_dev *pci_dev)
 	 * storage.
 	 */
 	rc = pqi_flush_cache(ctrl_info, SHUTDOWN);
+	pqi_reset(ctrl_info);
 	if (rc == 0)
 		return;
 
