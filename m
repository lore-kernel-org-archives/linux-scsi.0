From: Don Brace <don.brace@microsemi.com>
Subject: [PATCH 1/5] hpsa: determine device external status earlier
Date: Fri, 9 Sep 2016 16:30:17 -0500
Message-ID: <147345661717.19269.9073717000556201167.stgit@brunhilda>
References: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-sn1nam01on0088.outbound.protection.outlook.com ([104.47.32.88]:29424
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752040AbcIIVa3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Sep 2016 17:30:29 -0400
In-Reply-To: <147345640313.19269.15042173861496542431.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, john.hall@microsemi.com, Kevin.Barnett@microsemi.com, Mahesh.Rajashekhara@microsemi.com, hch@infradead.org, scott.teel@microsemi.com, Viswas.G@microsemi.com, Justin.Lindley@microsemi.com, scott.benesh@microsemi.com, elliott@hpe.com
Cc: linux-scsi@vger.kernel.org

currently we are checking for external status before
we are determining if a device is an external device.

Reviewed-by: Scott Benesh <scott.benest@microsemi.com>
Reviewed-by: Scott Teel <scott.teel@microsemi.com>
Reviewed-by: Kevin Barnett <kevin.barnett@microsemi.com>
Signed-off-by: Don Brace <don.brace@microsemi.com>
---
 drivers/scsi/hpsa.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 030d002..332ff1a 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4270,6 +4270,11 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 		lunaddrbytes = figure_lunaddrbytes(h, raid_ctlr_position,
 			i, nphysicals, nlogicals, physdev_list, logdev_list);
 
+		/* Determine if this is a lun from an external target array */
+		tmpdevice->external =
+			figure_external_status(h, raid_ctlr_position, i,
+						nphysicals, nlocal_logicals);
+
 		/*
 		 * Skip over some devices such as a spare.
 		 */
@@ -4295,11 +4300,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h)
 			continue;
 		}
 
-		/* Determine if this is a lun from an external target array */
-		tmpdevice->external =
-			figure_external_status(h, raid_ctlr_position, i,
-						nphysicals, nlocal_logicals);
-
 		figure_bus_target_lun(h, lunaddrbytes, tmpdevice);
 		hpsa_update_device_supports_aborts(h, tmpdevice, lunaddrbytes);
 		this_device = currentsd[ncurrent];

