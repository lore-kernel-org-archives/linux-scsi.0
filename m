From: Don Brace <don.brace@pmcs.com>
Subject: [PATCH 06/11] hpsa: cleanup update scsi devices
Date: Sat, 18 Jul 2015 11:12:49 -0500
Message-ID: <20150718161249.31955.25688.stgit@brunhilda>
References: <20150718160245.31955.16794.stgit@brunhilda>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t3426.houston.hp.com ([15.201.208.54]:40771 "EHLO
	g4t3426.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbbGRQPF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jul 2015 12:15:05 -0400
In-Reply-To: <20150718160245.31955.16794.stgit@brunhilda>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scott.teel@pmcs.com, Kevin.Barnett@pmcs.com, james.bottomley@parallels.com, hch@infradead.org, Justin.Lindley@pmcs.com, elliott@hp.com
Cc: linux-scsi@vger.kernel.org

showing that tables have been updated unnecessarily.

Reviewed-by: Kevin Barnett <kevin.barnett@pmcs.com>
Reviewed-by: Scott Teel <scott.teel@pmcs.com>
Signed-off-by: Don Brace <don.brace@pmcs.com>
---
 drivers/scsi/hpsa.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
index f64a2c7..f34978d 100644
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -1379,8 +1379,9 @@ static inline int device_updated(struct hpsa_scsi_dev_t *dev1,
 		return 1;
 	if (dev1->offload_enabled != dev2->offload_enabled)
 		return 1;
-	if (dev1->queue_depth != dev2->queue_depth)
-		return 1;
+	if (!is_logical_dev_addr_mode(dev1->scsi3addr))
+		if (dev1->queue_depth != dev2->queue_depth)
+			return 1;
 	return 0;
 }
 
@@ -3889,7 +3890,6 @@ static void hpsa_update_scsi_devices(struct ctlr_info *h, int hostno)
 			else if (!(h->transMethod & CFGTBL_Trans_io_accel1 ||
 				h->transMethod & CFGTBL_Trans_io_accel2))
 				break;
-
 			hpsa_get_ioaccel_drive_info(h, this_device,
 						lunaddrbytes, id_phys);
 			hpsa_get_path_info(this_device, lunaddrbytes, id_phys);

