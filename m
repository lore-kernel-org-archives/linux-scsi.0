Return-Path: <SRS0=JunS=BC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C534C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 037B922D01
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jul 2020 12:25:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y9/5H92V"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728981AbgGWMZQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jul 2020 08:25:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728961AbgGWMZO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jul 2020 08:25:14 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81B0DC0698C4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:12 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id y3so4977615wrl.4
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2020 05:25:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=fFCkXG9YSXNm34wg4F+wGX5K4ez31ESofd03IW98OEg=;
        b=y9/5H92VbCA1egotNV9BA58XpjXdzU33aT3oGUcjZfBmDlpDVbbF3L5oth+TM4+oft
         LLsJa3FnzFeoDFjArzUyZhkCXcXOnwOlBsZ8xmvZquib1xqFDlxOQJzgvozOJ9BNkbh9
         ds+ISMCJ45QDwEpbN/XFb5aZbnS2h8KzzD5QjQEMZSlXjDlebRw2UT1S63Udzvc7T6DP
         VKDlSzmGcVs7kG7++z+U/Xwi///G+AHZSBAZYL1B2SYOTk9Im/ecX+wcKU44M9Cqj3o+
         HEJbpO+/Ro1oyUPOsr8IEbGlAcV5F2P2to7VA1MIpG2Qs2lEbPCvHX/TRY/TqKsbZ0Re
         tObA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fFCkXG9YSXNm34wg4F+wGX5K4ez31ESofd03IW98OEg=;
        b=Op5/TCH3LJPRacqCCq07iQGZhe22D/yiQvvQ4vwbai4eI1s4D6zatgFVN4ruvCECOU
         n2/LdVYa1wbpmRRN/PgEID4PxGfs7lGXK8ayswp2Z74glwJXsQXj/T/0MMXQQZwbl0nM
         9/83FKympG6eu6LQOvWQkA6byjYqSPCF0GGIgpRMlQVaCvXNZtKECoCymp6ZNbMq+3Sz
         8gpVtP5KA/NIif4SLBd55HwEGWs4QuVg3uIhqBPrTaSeIJCs6jxbnxVXEiY5+iMuuhgA
         jpuWus/EmCruGTUD97bRBmUUDkrbJPUaUNWWq1qMWOuh9fV1g6otgQwWcDizPgpGAVgg
         hnjg==
X-Gm-Message-State: AOAM5304xApuujBDu0Ors3GI+K1Fd31QzIX20dfKd2SyXBl6KmHF09sK
        jJ/WR6BUjp/Vyr48UhIPOkw7pQ==
X-Google-Smtp-Source: ABdhPJx3323BO+jDBKt8oJ/qAiv4vjAs5/wa0v5rDlaloTpI5IVv4LvTUQNYjvIiQGqEXA/vu8j6Bw==
X-Received: by 2002:adf:92a1:: with SMTP id 30mr4196849wrn.56.1595507111228;
        Thu, 23 Jul 2020 05:25:11 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.73])
        by smtp.gmail.com with ESMTPSA id j5sm3510651wma.45.2020.07.23.05.25.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2020 05:25:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 18/40] scsi: lpfc: lpfc_mbox: Fix a bunch of kerneldoc misdemeanours
Date:   Thu, 23 Jul 2020 13:24:24 +0100
Message-Id: <20200723122446.1329773-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200723122446.1329773-1-lee.jones@linaro.org>
References: <20200723122446.1329773-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Adding, removing and correcting function parameter descriptions.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_mbox.c:886: warning: Function parameter or member 'vport' not described in 'lpfc_reg_vpi'
 drivers/scsi/lpfc/lpfc_mbox.c:886: warning: Excess function parameter 'phba' description in 'lpfc_reg_vpi'
 drivers/scsi/lpfc/lpfc_mbox.c:886: warning: Excess function parameter 'vpi' description in 'lpfc_reg_vpi'
 drivers/scsi/lpfc/lpfc_mbox.c:886: warning: Excess function parameter 'sid' description in 'lpfc_reg_vpi'
 drivers/scsi/lpfc/lpfc_mbox.c:1218: warning: Function parameter or member 'ring' not described in 'lpfc_config_ring'
 drivers/scsi/lpfc/lpfc_mbox.c:1626: warning: Function parameter or member 'mboxq' not described in 'lpfc_mbox_tmo_val'
 drivers/scsi/lpfc/lpfc_mbox.c:1626: warning: Excess function parameter 'cmd' description in 'lpfc_mbox_tmo_val'
 drivers/scsi/lpfc/lpfc_mbox.c:1710: warning: Function parameter or member 'sge' not described in 'lpfc_sli4_mbx_sge_get'
 drivers/scsi/lpfc/lpfc_mbox.c:1780: warning: Function parameter or member 'emb' not described in 'lpfc_sli4_config'
 drivers/scsi/lpfc/lpfc_mbox.c:2027: warning: Function parameter or member 'mboxq' not described in 'lpfc_sli4_mbx_read_fcf_rec'
 drivers/scsi/lpfc/lpfc_mbox.c:2078: warning: Function parameter or member 'phba' not described in 'lpfc_request_features'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_mbox.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_mbox.c b/drivers/scsi/lpfc/lpfc_mbox.c
index e34e0f11bfdd5..3414ffcb26fed 100644
--- a/drivers/scsi/lpfc/lpfc_mbox.c
+++ b/drivers/scsi/lpfc/lpfc_mbox.c
@@ -868,9 +868,7 @@ lpfc_sli4_unreg_all_rpis(struct lpfc_vport *vport)
 
 /**
  * lpfc_reg_vpi - Prepare a mailbox command for registering vport identifier
- * @phba: pointer to lpfc hba data structure.
- * @vpi: virtual N_Port identifier.
- * @sid: Fibre Channel S_ID (N_Port_ID assigned to a virtual N_Port).
+ * @vport: pointer to a vport object.
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
  * The registration vport identifier mailbox command is used to activate a
@@ -1199,7 +1197,7 @@ lpfc_config_hbq(struct lpfc_hba *phba, uint32_t id,
 /**
  * lpfc_config_ring - Prepare a mailbox command for configuring an IOCB ring
  * @phba: pointer to lpfc hba data structure.
- * @ring:
+ * @ring: ring number/index
  * @pmb: pointer to the driver internal queue element for mailbox command.
  *
  * The configure ring mailbox command is used to configure an IOCB ring. This
@@ -1613,7 +1611,7 @@ lpfc_mbox_dev_check(struct lpfc_hba *phba)
 /**
  * lpfc_mbox_tmo_val - Retrieve mailbox command timeout value
  * @phba: pointer to lpfc hba data structure.
- * @cmd: mailbox command code.
+ * @mboxq: pointer to the driver internal queue element for mailbox command.
  *
  * This routine retrieves the proper timeout value according to the mailbox
  * command code.
@@ -1700,6 +1698,7 @@ lpfc_sli4_mbx_sge_set(struct lpfcMboxq *mbox, uint32_t sgentry,
  * lpfc_sli4_mbx_sge_get - Get a sge entry from non-embedded mailbox command
  * @mbox: pointer to lpfc mbox command.
  * @sgentry: sge entry index.
+ * @sge: pointer to lpfc mailbox sge to load into.
  *
  * This routine gets an entry from the non-embedded mailbox command at the sge
  * index location.
@@ -1767,6 +1766,7 @@ lpfc_sli4_mbox_cmd_free(struct lpfc_hba *phba, struct lpfcMboxq *mbox)
  * @subsystem: The sli4 config sub mailbox subsystem.
  * @opcode: The sli4 config sub mailbox command opcode.
  * @length: Length of the sli4 config mailbox command (including sub-header).
+ * @emb: True if embedded mbox command should be setup.
  *
  * This routine sets up the header fields of SLI4 specific mailbox command
  * for sending IOCTL command.
@@ -2012,6 +2012,7 @@ lpfc_sli_config_mbox_opcode_get(struct lpfc_hba *phba, LPFC_MBOXQ_t *mbox)
 /**
  * lpfc_sli4_mbx_read_fcf_rec - Allocate and construct read fcf mbox cmd
  * @phba: pointer to lpfc hba data structure.
+ * @mboxq: pointer to lpfc mbox command.
  * @fcf_index: index to fcf table.
  *
  * This routine routine allocates and constructs non-embedded mailbox command
@@ -2068,6 +2069,7 @@ lpfc_sli4_mbx_read_fcf_rec(struct lpfc_hba *phba,
 
 /**
  * lpfc_request_features: Configure SLI4 REQUEST_FEATURES mailbox
+ * @phba: pointer to lpfc hba data structure.
  * @mboxq: pointer to lpfc mbox command.
  *
  * This routine sets up the mailbox for an SLI4 REQUEST_FEATURES
-- 
2.25.1

