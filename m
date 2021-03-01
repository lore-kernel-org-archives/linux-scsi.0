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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 132B5C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D990D64E45
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:25:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238354AbhCARYt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:24:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237886AbhCARUw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:20:52 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8221C0617AB
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:32 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id o6so12323076pjf.5
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f6wfmRMJ4UjLId4LJW+t5hfDYmlgPK2Cs4vIyLzlRXI=;
        b=ekapN+Dwh33IiX0A2OIfc/BTx2hrMszyJykId9P3jl5Ju/9axBb2pmzqcphq7AFzat
         MfoFu1ftcF6NVUklqApTN8Y32jxxP5dnHREl+8eTIDoUb3jkindfpq7BqQIqzF9hLkwP
         eXikxfjIniRsQHrsoVMGlghPUrevT1E9lD6ZxOV1BVoi5OKne6C3ttvFLmrO9yQ4Xil9
         UrvZQER0tQDSzJNWueoy5MsYW9d7dliABukA4c84wha1ijV7SoEjfqrscNdeNZHwRBcb
         gdXl82oU9kKwI9FkpL7pc8POw3miptkQtt0AUrLNxBxehWqgM5jklnlg6mnOSHX3SuXM
         Y8RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f6wfmRMJ4UjLId4LJW+t5hfDYmlgPK2Cs4vIyLzlRXI=;
        b=oPRzAICC2BQd+hN9cRQyGgqJ1t8xXNfZW4MA9V5uUQ47Tkso/7lh10z10WQViZEHp0
         kvDki8Up2vtvGYbznwAvn+edqQE9vjKacBPpKHH7EXfdhrNLnHG0Cmy8c+371OLWT1kJ
         DwvN7Kl0Fys7evkKlzYC7N1nhxAcA19Guq0xAqqRp6z03R+klvZHZW+7ANizcRYZc0FR
         nuT/QVI4xSUAYmpOVJC+dZVXGCZI1UTh7FyyRdqt+GuIXgp4xgNymymM59vl+3TsMM+l
         UOPdd9zkUkxH/c00U6HYiFjnyymtcBk2ZCbNrk8dfj0uHyFxOV+V3Ik3L/ELOUAjBAhz
         XkJw==
X-Gm-Message-State: AOAM531zzuzt3qwFMnudxl/IDy7kMiaWlKnCjto1QBykBER2RCGQotn8
        V+ggp6a8j4bOTXeYd9qWh094Gle5PHw=
X-Google-Smtp-Source: ABdhPJw1QjpVSEdqoV4CDWKqC18ISIbC9CnkR40+Dnbj/jutNplBYBOd+h1cAhHy4iWJ0cMo7exgMw==
X-Received: by 2002:a17:90b:110c:: with SMTP id gi12mr18588444pjb.48.1614619112119;
        Mon, 01 Mar 2021 09:18:32 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:31 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 08/22] lpfc: Fix unnecessary null check in lpfc_release_scsi_buf
Date:   Mon,  1 Mar 2021 09:18:07 -0800
Message-Id: <20210301171821.3427-9-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

lpfc_fcp_io_cmd_wqe_cmpl() is intended to mirror
lpfc_nvme_io_cmd_wqe_cmpl() for sli4 fcp completions. When the routine
was added, lpfc_fcp_io_cmd_wqe_cmpl() included a null pointer check for
phba. However, phba is definitely valid, being dereferenced by the calling
routine and used later in the routine itself.

Remove the unnecessary null check.

Fixes: 96e209be6ecb ("scsi: lpfc: Convert SCSI I/O completions to SLI-3 and SLI-4 handlers")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_scsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index 3e1bc55993fd..97178b30074b 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -4074,7 +4074,7 @@ lpfc_fcp_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 
 	/* Sanity check on return of outstanding command */
 	cmd = lpfc_cmd->pCmd;
-	if (!cmd || !phba) {
+	if (!cmd) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 				 "9042 I/O completion: Not an active IO\n");
 		spin_unlock(&lpfc_cmd->buf_lock);
-- 
2.26.2

