Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C2A8C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF8E207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbhADSEO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726098AbhADSEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:13 -0500
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D09E6C06179F
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:11 -0800 (PST)
Received: by mail-pg1-x534.google.com with SMTP id n7so19556776pgg.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=0D1Gwjz41+JH9PKar85Amcm233dowW4fJ/NDvSbiA0w=;
        b=LiLGz1RhkBmi2ClXirBHHCZ1jKF/3DmuYNc5Vqnp9GsD5vrjgXue81H/ke+EwAEtqo
         6JVBx0669Ztr/4hjkHZ2/wjfkIcqZ0GxQjrq/9A0PBbJROQmYJBRlZHv7cQI4FeS0hTG
         icWXel8dJK0ACxsZVg5QiWksge/gI01sbc2vS+31O/xX3SPxFrziUuH0psSlr3kKAh3+
         oQP5QVlCpzjsD+EeOS03OJTpGS0NxgHWLeQalk1EbPttYkSdflGop5+2fD9ZkrGrSOkz
         huF+xJT+wXFSpZKOp5iVDLURJDX4BPHEmgqa13NhtZuvdTDiaBKziP/9m9BEsn7Hzwro
         wBrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0D1Gwjz41+JH9PKar85Amcm233dowW4fJ/NDvSbiA0w=;
        b=I2xkNS3eepUBlnR73zmXni02klQVw0kN9hx4PIpuNtbukiVELimwJq1JVvBhmivhDG
         +aWfk61HLfWS2Jf+ObCnnF1edFidEtAYnxYubWXmz4H3c3FIuyslSEGlyXag2KflOLwm
         CxGax5vSi75+jUPl37aAb80tIiRH73XDBmgM44bjs8EUV3wZSl3cxu8YmmEVCYY0VtXS
         i968A7bc0YoTEwo2uQsxdSINhaeRtEiU3uJQhG16QYmaK7vCXc2VlYSbMVsdk7RvEBqa
         RZmjEeuTihf7q5JXW1t5UlZgdg0mT+GEWLsqBul14+/p8uz4Kx/C0aAATF8To7NI6Ffp
         zCDg==
X-Gm-Message-State: AOAM530BQkAk3+KRw6F9/mKAXMY+nIKHyjzQey7AkcnvJ86b/C6LoTN4
        xD+MJokU02Hh+ksOD9qmrRYf8Ukhx08=
X-Google-Smtp-Source: ABdhPJxp/FWEl4YQ/PWaHhraC6HiTLGw9RnofFuNktIOEfYKCdHVMfccCxvQxhccQZ4TsqNakUGMXw==
X-Received: by 2002:a05:6a00:88b:b029:19c:780e:1cd with SMTP id q11-20020a056a00088bb029019c780e01cdmr66482249pfj.64.1609783391296;
        Mon, 04 Jan 2021 10:03:11 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:10 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 08/15] lpfc: Fix error log messages being logged following scsi task mgnt
Date:   Mon,  4 Jan 2021 10:02:33 -0800
Message-Id: <20210104180240.46824-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
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

