From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH v2 15/41] hpsa: Get queue depth from identify physical bmic
 for physical disks.
Date: Fri, 06 Mar 2015 17:47:07 -0600
Message-ID: <20150306234707.29973.46976.stgit@brunhilda>
References: <20150306233504.29973.41322.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:50779 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754923AbbCFXsh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2015 18:48:37 -0500
Received: from g9t5009.houston.hp.com (g9t5009.houston.hp.com [15.240.92.67])
	(using TLSv1.2 with cipher DHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by g2t1383g.austin.hp.com (Postfix) with ESMTPS id 00DC644D0
	for <linux-scsi@vger.kernel.org>; Fri,  6 Mar 2015 23:48:36 +0000 (UTC)
In-Reply-To: <20150306233504.29973.41322.stgit@brunhilda>
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
index 85c4c8a..229366b 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -3500,29 +3500,22 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
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

