From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v3 15/42] hpsa: Get queue depth from identify physical bmic
 for physical disks.
Date: Tue, 17 Mar 2015 15:03:46 -0500
Message-ID: <20150317200346.19856.43617.stgit@brunhilda>
References: <20150317200139.19856.87982.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t1613g.houston.hp.com ([15.240.0.71]:42503 "EHLO
	g9t1613g.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932268AbbCQUGC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Mar 2015 16:06:02 -0400
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g9t1613g.houston.hp.com (Postfix) with ESMTPS id 19AE361EE8
	for <linux-scsi@vger.kernel.org>; Tue, 17 Mar 2015 20:05:26 +0000 (UTC)
In-Reply-To: <20150317200139.19856.87982.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Joe Handzik <joseph.t.handzik@hp.com>

get drive queue depth to help avoid task set full conditions.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 76f9042..3fa72a1 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3497,29 +3497,22 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 				ncurrent++;
 			break;
 		case TYPE_DISK:
-			if (h->hba_mode_enabled) {
-				/* never use raid mapper in HBA mode */
-				this_device->offload_enabled = 0;
-				ncurrent++;
-				break;
-			} else if (h->acciopath_status) {
-				if (i >= nphysicals) {
-					ncurrent++;
-					break;
-				}
-			} else {
-				if (i < nphysicals)
-					break;
+			if (i >= nphysicals) {
 				ncurrent++;
 				break;
 			}
-			if (h->transMethod & CFGTBL_Trans_io_accel1 ||
-				h->transMethod & CFGTBL_Trans_io_accel2) {
-				hpsa_get_ioaccel_drive_info(h, this_device,
-							lunaddrbytes, id_phys);
-				atomic_set(&this_device->ioaccel_cmds_out, 0);
-				ncurrent++;
-			}
+
+			if (h->hba_mode_enabled)
+				/* never use raid mapper in HBA mode */
+				this_device->offload_enabled = 0;
+			else if (!(h->transMethod & CFGTBL_Trans_io_accel1 ||
+				h->transMethod & CFGTBL_Trans_io_accel2))
+				break;
+
+			hpsa_get_ioaccel_drive_info(h, this_device,
+						lunaddrbytes, id_phys);
+			atomic_set(&this_device->ioaccel_cmds_out, 0);
+			ncurrent++;
 			break;
 		case TYPE_TAPE:
 		case TYPE_MEDIUM_CHANGER:

