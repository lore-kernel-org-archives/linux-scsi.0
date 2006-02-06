From: brking@us.ibm.com
Subject: [patch 11/15] ipr: Disk remove path cleanup
Date: Mon, 06 Feb 2006 09:42:30 -0600
Message-ID: <200602061542.k16Fgaf6015347@d01av03.pok.ibm.com>
Return-path: <linux-ide-owner@vger.kernel.org>
Sender: linux-ide-owner@vger.kernel.org
To: jgarzik@pobox.com
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, brking@us.ibm.com
List-Id: linux-scsi@vger.kernel.org


Instead of NULLing the resource entry pointer when a disk
goes away to prevent any new commands being sent to it,
set the adapter resource handle to an invalid value so
new ops getting sent to it will fail with a selection timeout
response. This patch is needed for future SATA patches.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 linux-2.6-bjking1/drivers/scsi/ipr.c |    6 +++---
 linux-2.6-bjking1/drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_disk_remove_cleanup drivers/scsi/ipr.c
--- linux-2.6/drivers/scsi/ipr.c~ipr_disk_remove_cleanup	2006-01-23 15:11:19.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.c	2006-01-23 15:11:19.000000000 -0600
@@ -869,8 +869,8 @@ static void ipr_handle_config_change(str
 
 	if (hostrcb->hcam.notify_type == IPR_HOST_RCB_NOTIF_TYPE_REM_ENTRY) {
 		if (res->sdev) {
-			res->sdev->hostdata = NULL;
 			res->del_from_ml = 1;
+			res->cfgte.res_handle = IPR_INVALID_RES_HANDLE;
 			if (ioa_cfg->allow_ml_add_del)
 				schedule_work(&ioa_cfg->work_q);
 		} else
@@ -2107,7 +2107,6 @@ restart:
 				did_work = 1;
 				sdev = res->sdev;
 				if (!scsi_device_get(sdev)) {
-					res->sdev = NULL;
 					list_move_tail(&res->queue, &ioa_cfg->free_res_q);
 					spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 					scsi_remove_device(sdev);
@@ -2124,6 +2123,7 @@ restart:
 			bus = res->cfgte.res_addr.bus;
 			target = res->cfgte.res_addr.target;
 			lun = res->cfgte.res_addr.lun;
+			res->add_to_ml = 0;
 			spin_unlock_irqrestore(ioa_cfg->host->host_lock, lock_flags);
 			scsi_add_device(ioa_cfg->host, bus, target, lun);
 			spin_lock_irqsave(ioa_cfg->host->host_lock, lock_flags);
@@ -5018,7 +5018,7 @@ static int ipr_init_res_table(struct ipr
 	list_for_each_entry_safe(res, temp, &old_res, queue) {
 		if (res->sdev) {
 			res->del_from_ml = 1;
-			res->sdev->hostdata = NULL;
+			res->cfgte.res_handle = IPR_INVALID_RES_HANDLE;
 			list_move_tail(&res->queue, &ioa_cfg->used_res_q);
 		} else {
 			list_move_tail(&res->queue, &ioa_cfg->free_res_q);
diff -puN drivers/scsi/ipr.h~ipr_disk_remove_cleanup drivers/scsi/ipr.h
--- linux-2.6/drivers/scsi/ipr.h~ipr_disk_remove_cleanup	2006-01-23 15:11:19.000000000 -0600
+++ linux-2.6-bjking1/drivers/scsi/ipr.h	2006-01-23 15:11:19.000000000 -0600
@@ -133,6 +133,7 @@
 #define IPR_MAX_SCSI_RATE(width) ((320 * 10) / ((width) / 8))
 
 #define IPR_IOA_RES_HANDLE				0xffffffff
+#define IPR_INVALID_RES_HANDLE			0
 #define IPR_IOA_RES_ADDR				0x00ffffff
 
 /*
_
