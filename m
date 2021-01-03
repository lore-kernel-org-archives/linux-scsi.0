Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00231C433E9
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF0A6207AC
	for <linux-scsi@archiver.kernel.org>; Sun,  3 Jan 2021 00:18:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726904AbhACASN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Jan 2021 19:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726885AbhACASM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Jan 2021 19:18:12 -0500
Received: from mail-pg1-x529.google.com (mail-pg1-x529.google.com [IPv6:2607:f8b0:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DCC6C06179F
        for <linux-scsi@vger.kernel.org>; Sat,  2 Jan 2021 16:17:10 -0800 (PST)
Received: by mail-pg1-x529.google.com with SMTP id n7so16438172pgg.2
        for <linux-scsi@vger.kernel.org>; Sat, 02 Jan 2021 16:17:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0D1Gwjz41+JH9PKar85Amcm233dowW4fJ/NDvSbiA0w=;
        b=HPHBPtqOyYGNx5oIcyhbyqbs2Xj3PFeLMDfKPqgSRxjmHl0oRI0y0R8d/hsP1AWRvS
         EqPsuZ9pHAYqhQglXgjDx9gzWOUPw+1THh4U2IBhgRhM5yuv7u2Mquq09LtIhTiNRDP0
         pHE99wvbKUhciMF03kgERmJckgLmHrycZow15AZxSGRXheATXZ5Ctc92U1YaHAF1xfd5
         LMfIvrAUP1+9/UJydBU4nmJyT6/HIcPY9NkHuy7aG2ym6KjBImVB9rLOfG8vD4ZZuUpY
         Osw2/0r8nJHjhAmGStPmIY3qVezK1oCYI2QT4zavGvVFBcJQYbHAJ7zZExf4cieqGng4
         gSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0D1Gwjz41+JH9PKar85Amcm233dowW4fJ/NDvSbiA0w=;
        b=Z4ala7+a0SNB2UM19OXuU0mn1Mqid3sV6Oohe2sHtXQgw69qXhauBa4VspxZ6G5Qo0
         xY12u+7bvXa9NAYha1nVH+sv/gSizf2SmHUs7sxv9pQ9lsWLYucxEO7CbzFdM2wdHNlz
         gb/Gcrjh3qoEKOJ41uIONj8c81Ga+8jVpFpQG9fSxYBDoKri2dafuqACD5zGCRYkeyPn
         neMGQhoQi4iddHoHDiEALag1H2pYcbVWBJCDF8Vp8b35llvlnsvVfXI9KjZYXzPElnsi
         on+udO1UsvB1OiLc08uvay6mOhwkqQrCA2le4D0h7UH1hZaZsxsq746gsKXhRSMCnT6E
         GOYQ==
X-Gm-Message-State: AOAM531RMYk9LAKoTOIH1I5myEoPge7+uwSNXcvry55nw1UYc+MK9zqw
        Zxt0wjePmp0KIJPe5nXg4VNSFRYP4WQ=
X-Google-Smtp-Source: ABdhPJx8Jd3+uHDuDr2HPX1UfZ4f4ljmgebo0uRIVxtXSPRjKb/atA5K3uRI4jtgEdU66NxxJ6WmDA==
X-Received: by 2002:a63:c444:: with SMTP id m4mr64936345pgg.420.1609633029564;
        Sat, 02 Jan 2021 16:17:09 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q12sm55671867pgj.24.2021.01.02.16.17.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 16:17:09 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 08/15] lpfc: Fix error log messages being logged following scsi task mgnt
Date:   Sat,  2 Jan 2021 16:16:32 -0800
Message-Id: <20210103001639.1995-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210103001639.1995-1-jsmart2021@gmail.com>
References: <20210103001639.1995-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A successful task mgmt command is logging errors, making it look like
problems were encountered.  This is due to log messages for the
device/target and bus reset handlers having the LOG_TRACE_EVENT flag set.

Fix by adjusting the event flag such that the call to the logging routine
only receives a LOG_TRACE_EVENT if a prior call actually failed.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3b989f720937..78f34b1af980 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -5849,6 +5849,7 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
+	u32 logit = LOG_FCP;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 	if (!rdata || !rdata->pnode) {
@@ -5880,8 +5881,10 @@ lpfc_device_reset_handler(struct scsi_cmnd *cmnd)
 
 	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 						FCP_LUN_RESET);
+	if (status != SUCCESS)
+		logit =  LOG_TRACE_EVENT;
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, logit,
 			 "0713 SCSI layer issued Device Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
@@ -5920,6 +5923,7 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 	uint64_t lun_id = cmnd->device->lun;
 	struct lpfc_scsi_event_header scsi_event;
 	int status;
+	u32 logit = LOG_FCP;
 
 	rdata = lpfc_rport_data_from_scsi_device(cmnd->device);
 	if (!rdata || !rdata->pnode) {
@@ -5959,8 +5963,10 @@ lpfc_target_reset_handler(struct scsi_cmnd *cmnd)
 
 	status = lpfc_send_taskmgmt(vport, cmnd, tgt_id, lun_id,
 					FCP_TARGET_RESET);
+	if (status != SUCCESS)
+		logit =  LOG_TRACE_EVENT;
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, logit,
 			 "0723 SCSI layer issued Target Reset (%d, %llu) "
 			 "return x%x\n", tgt_id, lun_id, status);
 
@@ -5996,6 +6002,7 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_scsi_event_header scsi_event;
 	int match;
 	int ret = SUCCESS, status, i;
+	u32 logit = LOG_FCP;
 
 	scsi_event.event_type = FC_REG_SCSI_EVENT;
 	scsi_event.subcategory = LPFC_EVENT_BUSRESET;
@@ -6056,8 +6063,10 @@ lpfc_bus_reset_handler(struct scsi_cmnd *cmnd)
 	status = lpfc_reset_flush_io_context(vport, 0, 0, LPFC_CTX_HOST);
 	if (status != SUCCESS)
 		ret = FAILED;
+	if (ret == FAILED)
+		logit =  LOG_TRACE_EVENT;
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, logit,
 			 "0714 SCSI layer issued Bus Reset Data: x%x\n", ret);
 	return ret;
 }
@@ -6086,7 +6095,7 @@ lpfc_host_reset_handler(struct scsi_cmnd *cmnd)
 	struct lpfc_hba *phba = vport->phba;
 	int rc, ret = SUCCESS;
 
-	lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
+	lpfc_printf_vlog(vport, KERN_ERR, LOG_FCP,
 			 "3172 SCSI layer issued Host Reset Data:\n");
 
 	lpfc_offline_prep(phba, LPFC_MBX_WAIT);
-- 
2.26.2

