From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH v2 2/3] be2iscsi: Remove redundant iscsi_wrb desc memset
Date: Fri, 26 Aug 2016 15:09:07 +0530
Message-ID: <1472204348-5960-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1472204348-5960-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:34347 "EHLO
        mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752596AbcHZJjc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Aug 2016 05:39:32 -0400
Received: by mail-pa0-f47.google.com with SMTP id fi15so25839365pac.1
        for <linux-scsi@vger.kernel.org>; Fri, 26 Aug 2016 02:39:25 -0700 (PDT)
In-Reply-To: <1472204348-5960-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

alloc_wrb_handle already does memset zero of iscsi_wrb descriptor so
remove redundant memset in WRB submission paths.

Add pwrb_handle NULL check before memsett'ing pwrb.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 5 +++--
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ---
 2 files changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b30db87..6a6906f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -967,7 +967,9 @@ beiscsi_get_wrb_handle(struct hwi_wrb_context *pwrb_context,
 	else
 		pwrb_context->alloc_index++;
 	spin_unlock_bh(&pwrb_context->wrb_lock);
-	memset(pwrb_handle->pwrb, 0, sizeof(*pwrb_handle->pwrb));
+
+	if (pwrb_handle)
+		memset(pwrb_handle->pwrb, 0, sizeof(*pwrb_handle->pwrb));
 
 	return pwrb_handle;
 }
@@ -4718,7 +4720,6 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
 	cid = beiscsi_conn->beiscsi_conn_cid;
 	pwrb = io_task->pwrb_handle->pwrb;
-	memset(pwrb, 0, sizeof(*pwrb));
 
 	if (is_chip_be2_be3r(phba)) {
 		AMAP_SET_BITS(struct amap_iscsi_wrb, cmdsn_itt, pwrb,
diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index 3ac7b88..b9ff939 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -1350,7 +1350,6 @@ void beiscsi_offload_cxn_v0(struct beiscsi_offload_params *params,
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
 
-	memset(pwrb, 0, sizeof(*pwrb));
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb,
 		      max_send_data_segment_length, pwrb,
 		      params->dw[offsetof(struct amap_beiscsi_offload_params,
@@ -1422,8 +1421,6 @@ void beiscsi_offload_cxn_v2(struct beiscsi_offload_params *params,
 {
 	struct iscsi_wrb *pwrb = pwrb_handle->pwrb;
 
-	memset(pwrb, 0, sizeof(*pwrb));
-
 	AMAP_SET_BITS(struct amap_iscsi_target_context_update_wrb_v2,
 		      max_burst_length, pwrb, params->dw[offsetof
 		      (struct amap_beiscsi_offload_params,
-- 
2.7.4

