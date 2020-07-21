Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D6B5C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3806620792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="pyZFNzQ/"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730868AbgGUQnh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730735AbgGUQml (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:41 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF07C0619DA
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:41 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id 88so11573034wrh.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vXJJF1W9k1z7Na3pvzHdBZG9DscScXGROr0HjsmWObQ=;
        b=pyZFNzQ/Dc37saZNTqKBcYtVTa5rv+/RJruM7hWu+W2SyhAPzEswAFuxeBTIEnJ2Un
         QZeKxXn43difmwUNS7tGyNRyg96K37+sAIugIRGi04o0g2F5UpugvSvGKFZgTcC6BmPo
         symCKm9w5GtHl8WmFboCRwXyLznDVgh5M7DAnt1jUZSQIjq6mZF5CF3+PtTyDtsxBnaC
         n2PybB1JUxe807lhhh4R9uGuLggdrSzx/TtOGlpC4DOrju9L6UgOsCnBoN0OycRwwX5e
         RLkYJ6KLz3pBkoYDZHbHrb8m00dfl/2VWIf1xnIBxcWEjDLkb2W8ppoMSt2Qxs22X2XG
         LGdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vXJJF1W9k1z7Na3pvzHdBZG9DscScXGROr0HjsmWObQ=;
        b=mHOh93T2tz6loE0HJqlUmneRTCMPyn3PYqlvMmkqJh/ctRKRD7xGziXH9KQNEPHqah
         45r0cJbRWY0i5nc+4o5uT3pPjoeIKv0t6kmo3vbnq9+m+lb7Z5GVwv9tN96Q4t+1VELR
         JKOBGv/fE/qQln2vdbChQuTcMPcGNrIa8Njk+BPfhts1a4sicTwCpuCxoMh1ewrQDg/z
         +Z7vl9gJJ3fVHCf0fP8I9P0Jj0hK1LDMAnLOMB/tEGYJ0TgkMyX3WBT7MztbxxL/x+Cp
         OborNtQ5qR9yuHl+yFjnrzOWz+RM9Zzb6nsbTI9wlKk7m+wDSVJNNlSfwb7N8rr7Uv6c
         KV1Q==
X-Gm-Message-State: AOAM533aUWjKuBrsKFqFZvrCCAgcbC37Zmw6/iff2/6OP+EYY3J4st2P
        5pNTfQe2qZFPktptkPnDI2wCag==
X-Google-Smtp-Source: ABdhPJwIGFbiXIil3Vep+qPfyS242Z5ektcm5mpCelA5ULa/8ioavvgYS9xcq5sq4eD5XrvXvCqH1A==
X-Received: by 2002:adf:e38b:: with SMTP id e11mr27053586wrm.65.1595349759735;
        Tue, 21 Jul 2020 09:42:39 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:39 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 30/40] scsi: lpfc: lpfc_ct: Fix-up formatting/docrot where appropriate
Date:   Tue, 21 Jul 2020 17:41:38 +0100
Message-Id: <20200721164148.2617584-31-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Other headers have been demoted as they are too far out of sync and
ideally require effort from the authors.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_ct.c:321: warning: Function parameter or member 'usr_flg' not described in 'lpfc_gen_req'
 drivers/scsi/lpfc/lpfc_ct.c:321: warning: Function parameter or member 'num_entry' not described in 'lpfc_gen_req'
 drivers/scsi/lpfc/lpfc_ct.c:321: warning: Function parameter or member 'tmo' not described in 'lpfc_gen_req'
 drivers/scsi/lpfc/lpfc_ct.c:321: warning: Function parameter or member 'retry' not described in 'lpfc_gen_req'
 drivers/scsi/lpfc/lpfc_ct.c:413: warning: Function parameter or member 'rsp_size' not described in 'lpfc_ct_cmd'
 drivers/scsi/lpfc/lpfc_ct.c:413: warning: Function parameter or member 'retry' not described in 'lpfc_ct_cmd'
 drivers/scsi/lpfc/lpfc_ct.c:3030: warning: Function parameter or member 'cmdcode' not described in 'lpfc_fdmi_cmd'
 drivers/scsi/lpfc/lpfc_ct.c:3030: warning: Function parameter or member 'new_mask' not described in 'lpfc_fdmi_cmd'
 drivers/scsi/lpfc/lpfc_ct.c:3272: warning: Function parameter or member 't' not described in 'lpfc_delayed_disc_tmo'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_ct.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 701f2405cf022..dd9f2bf54edd4 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -300,7 +300,7 @@ lpfc_ct_free_iocb(struct lpfc_hba *phba, struct lpfc_iocbq *ctiocb)
 	return 0;
 }
 
-/**
+/*
  * lpfc_gen_req - Build and issue a GEN_REQUEST command  to the SLI Layer
  * @vport: pointer to a host virtual N_Port data structure.
  * @bmp: Pointer to BPL for SLI command
@@ -394,7 +394,7 @@ lpfc_gen_req(struct lpfc_vport *vport, struct lpfc_dmabuf *bmp,
 	return 0;
 }
 
-/**
+/*
  * lpfc_ct_cmd - Build and issue a CT command
  * @vport: pointer to a host virtual N_Port data structure.
  * @inmp: Pointer to data buffer for response data.
@@ -3019,8 +3019,8 @@ int (*lpfc_fdmi_port_action[])
  * lpfc_fdmi_cmd - Build and send a FDMI cmd to the specified NPort
  * @vport: pointer to a host virtual N_Port data structure.
  * @ndlp: ndlp to send FDMI cmd to (if NULL use FDMI_DID)
- * cmdcode: FDMI command to send
- * mask: Mask of HBA or PORT Attributes to send
+ * @cmdcode: FDMI command to send
+ * @new_mask: Mask of HBA or PORT Attributes to send
  *
  * Builds and sends a FDMI command using the CT subsystem.
  */
@@ -3262,7 +3262,7 @@ lpfc_fdmi_cmd(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 /**
  * lpfc_delayed_disc_tmo - Timeout handler for delayed discovery timer.
- * @ptr - Context object of the timer.
+ * @t: Context object of the timer.
  *
  * This function set the WORKER_DELAYED_DISC_TMO flag and wake up
  * the worker thread.
-- 
2.25.1

