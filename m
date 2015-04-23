From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v5 15/42] hpsa: Get queue depth from identify physical bmic
 for physical disks.
Date: Thu, 23 Apr 2015 09:33:04 -0500
Message-ID: <20150423143304.18832.33610.stgit@brunhilda>
References: <20150423141637.18832.35621.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3427.houston.hp.com ([15.201.208.55]:37892 "EHLO
	g4t3427.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965008AbbDWOeN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2015 10:34:13 -0400
In-Reply-To: <20150423141637.18832.35621.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, brace@pmcs.com
Cc: linux-scsi@vger.kernel.org

From: Joe Handzik <joseph.t.handzik@hp.com>

get drive queue depth to help avoid task set full conditions.

Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Tomas Henzl <thenzl@redhat.com>
Reviewed-by: Hannes Reinecke <hare@Suse.de>
Signed-off-by: Joe Handzik <joseph.t.handzik@hp.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |   33 +++++++++++++--------------------
 1 file changed, 13 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index 15f8bb6..236dfc9 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3464,29 +3464,22 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
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

