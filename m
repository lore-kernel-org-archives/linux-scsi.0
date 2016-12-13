From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 04/13] be2iscsi: Set WRB invalid bit for SkyHawk
Date: Tue, 13 Dec 2016 15:55:57 +0530
Message-ID: <1481624766-13846-5-git-send-email-jitendra.bhivare@broadcom.com>
References: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f181.google.com ([209.85.216.181]:32833 "EHLO
        mail-qt0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932220AbcLMK0t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Dec 2016 05:26:49 -0500
Received: by mail-qt0-f181.google.com with SMTP id p16so102138242qta.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Dec 2016 02:26:49 -0800 (PST)
In-Reply-To: <1481624766-13846-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

invalid bit in WRB indicates to FW that IO was invalidated before WRB
was fetched from host memory.

For SkyHawk, this invalid bit in WRB is at a different offset.
Use amap_iscsi_wrb_v2 to mark invalid bit for SkyHawk.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 19 ++++++++++++++-----
 drivers/scsi/be2iscsi/be_main.h |  2 +-
 2 files changed, 15 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 260842a..b509acd 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -244,8 +244,13 @@ static int beiscsi_eh_abort(struct scsi_cmnd *sc)
 	beiscsi_conn = conn->dd_data;
 	phba = beiscsi_conn->phba;
 	/* mark WRB invalid which have been not processed by FW yet */
-	AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-		      abrt_io_task->pwrb_handle->pwrb, 1);
+	if (is_chip_be2_be3r(phba)) {
+		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+			      abrt_io_task->pwrb_handle->pwrb, 1);
+	} else {
+		AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
+			      abrt_io_task->pwrb_handle->pwrb, 1);
+	}
 	inv_tbl.cid = beiscsi_conn->beiscsi_conn_cid;
 	inv_tbl.icd = abrt_io_task->psgl_handle->sgl_index;
 	spin_unlock_bh(&session->back_lock);
@@ -321,9 +326,13 @@ static int beiscsi_eh_device_reset(struct scsi_cmnd *sc)
 		__iscsi_get_task(task);
 		io_task = task->dd_data;
 		/* mark WRB invalid which have been not processed by FW yet */
-		AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
-			      io_task->pwrb_handle->pwrb,
-			      1);
+		if (is_chip_be2_be3r(phba)) {
+			AMAP_SET_BITS(struct amap_iscsi_wrb, invld,
+				      io_task->pwrb_handle->pwrb, 1);
+		} else {
+			AMAP_SET_BITS(struct amap_iscsi_wrb_v2, invld,
+				      io_task->pwrb_handle->pwrb, 1);
+		}
 
 		inv_tbl->tbl[nents].cid = beiscsi_conn->beiscsi_conn_cid;
 		inv_tbl->tbl[nents].icd = io_task->psgl_handle->sgl_index;
diff --git a/drivers/scsi/be2iscsi/be_main.h b/drivers/scsi/be2iscsi/be_main.h
index f869e37..8ba8c12 100644
--- a/drivers/scsi/be2iscsi/be_main.h
+++ b/drivers/scsi/be2iscsi/be_main.h
@@ -840,7 +840,7 @@ struct amap_iscsi_wrb_v2 {
 	u8 diff_enbl;   /* DWORD 11 */
 	u8 u_run;       /* DWORD 11 */
 	u8 o_run;       /* DWORD 11 */
-	u8 invalid;     /* DWORD 11 */
+	u8 invld;     /* DWORD 11 */
 	u8 dsp;         /* DWORD 11 */
 	u8 dmsg;        /* DWORD 11 */
 	u8 rsvd4;       /* DWORD 11 */
-- 
2.7.4

