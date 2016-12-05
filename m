From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 04/12] be2iscsi: Set WRB invalid bit for SkyHawk
Date: Mon,  5 Dec 2016 13:36:43 +0530
Message-ID: <1480925211-13223-5-git-send-email-jitendra.bhivare@broadcom.com>
References: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:33175 "EHLO
        mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750849AbcLEIHO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2016 03:07:14 -0500
Received: by mail-qk0-f182.google.com with SMTP id x190so338335997qkb.0
        for <linux-scsi@vger.kernel.org>; Mon, 05 Dec 2016 00:07:14 -0800 (PST)
In-Reply-To: <1480925211-13223-1-git-send-email-jitendra.bhivare@broadcom.com>
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
index 6eaa78bd..948384c 100644
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
1.8.3.1

