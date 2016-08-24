From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: [PATCH 2/3] be2iscsi: Remove redundant iscsi_wrb desc memset
Date: Wed, 24 Aug 2016 15:03:14 +0530
Message-ID: <1472031195-14556-3-git-send-email-jitendra.bhivare@broadcom.com>
References: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f171.google.com ([209.85.192.171]:33161 "EHLO
        mail-pf0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754015AbcHXJgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Aug 2016 05:36:10 -0400
Received: by mail-pf0-f171.google.com with SMTP id y134so5224180pfg.0
        for <linux-scsi@vger.kernel.org>; Wed, 24 Aug 2016 02:36:09 -0700 (PDT)
In-Reply-To: <1472031195-14556-1-git-send-email-jitendra.bhivare@broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: christophe.jaillet@wanadoo.fr, julia.lawall@lip6.fr, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, Jitendra Bhivare <jitendra.bhivare@broadcom.com>

alloc_wrb_handle already does memset zero of iscsi_wrb descriptor so
remove redundant memset in WRB submission paths.

Signed-off-by: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
---
 drivers/scsi/be2iscsi/be_main.c | 1 -
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ---
 2 files changed, 4 deletions(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index b30db87..edea89f 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4718,7 +4718,6 @@ static int beiscsi_mtask(struct iscsi_task *task)
 
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
1.9.1

