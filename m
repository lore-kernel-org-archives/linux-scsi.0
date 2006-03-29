From: Brian King <brking@us.ibm.com>
Subject: [PATCH 1/6] ipr: Disk remove path cleanup
Date: Wed, 29 Mar 2006 09:37:16 -0600
Message-ID: <200603291537.k2TFbG7w007437@d01av02.pok.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48314 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751180AbWC2Phi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Mar 2006 10:37:38 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e2.ny.us.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k2TFbRm3029003
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:27 -0500
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2TFbH6F123470
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:17 -0500
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k2TFbGuq007471
	for <linux-scsi@vger.kernel.org>; Wed, 29 Mar 2006 10:37:17 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, brking@us.ibm.com


Instead of NULLing the resource entry pointer when a disk
goes away to prevent any new commands being sent to it,
set the adapter resource handle to an invalid value so
new ops getting sent to it will fail with a selection timeout
response. This patch is needed for future SATA patches.


Signed-off-by: Brian King <brking@us.ibm.com>
---

 libata-dev-bjking1/drivers/scsi/ipr.c |    6 +++---
 libata-dev-bjking1/drivers/scsi/ipr.h |    1 +
 2 files changed, 4 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/ipr.c~ipr_disk_remove_cleanup drivers/scsi/ipr.c
--- libata-dev/drivers/scsi/ipr.c~ipr_disk_remove_cleanup	2006-03-06 09:20:06.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.c	2006-03-06 09:20:06.000000000 -0600
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
@@ -4980,7 +4980,7 @@ static int ipr_init_res_table(struct ipr
 	list_for_each_entry_safe(res, temp, &old_res, queue) {
 		if (res->sdev) {
 			res->del_from_ml = 1;
-			res->sdev->hostdata = NULL;
+			res->cfgte.res_handle = IPR_INVALID_RES_HANDLE;
 			list_move_tail(&res->queue, &ioa_cfg->used_res_q);
 		} else {
 			list_move_tail(&res->queue, &ioa_cfg->free_res_q);
diff -puN drivers/scsi/ipr.h~ipr_disk_remove_cleanup drivers/scsi/ipr.h
--- libata-dev/drivers/scsi/ipr.h~ipr_disk_remove_cleanup	2006-03-06 09:20:06.000000000 -0600
+++ libata-dev-bjking1/drivers/scsi/ipr.h	2006-03-06 09:20:06.000000000 -0600
@@ -133,6 +133,7 @@
 #define IPR_MAX_SCSI_RATE(width) ((320 * 10) / ((width) / 8))
 
 #define IPR_IOA_RES_HANDLE				0xffffffff
+#define IPR_INVALID_RES_HANDLE			0
 #define IPR_IOA_RES_ADDR				0x00ffffff
 
 /*
_
