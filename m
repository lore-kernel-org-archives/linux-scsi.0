From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v4 15/43] hpsa: Get queue depth from identify physical bmic
 for physical disks.
Date: Thu, 16 Apr 2015 08:48:03 -0500
Message-ID: <20150416134803.30238.27423.stgit@brunhilda>
References: <20150416134224.30238.66082.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g9t5008.houston.hp.com ([15.240.92.66]:49226 "EHLO
	g9t5008.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503AbbDPNtE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 09:49:04 -0400
In-Reply-To: <20150416134224.30238.66082.stgit@brunhilda>
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
index 9049133..ad2b44c 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3467,29 +3467,22 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
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

