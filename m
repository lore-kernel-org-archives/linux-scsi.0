Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BE56C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78BE764EE3
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355693AbhCDAcw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238097AbhCCOxX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:53:23 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AB2FC0604DD
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:47:51 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id k66so6597708wmf.1
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:47:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dVGY+2eVCzb/plLTl5wPYqGdorDqWqmvQcwoi8RclRE=;
        b=LU402gc4bmHicdpFm3WTCCDyVaNj3gfK0eQ//P/3UXc0RO37znWGJtNg9MHCyf7uJH
         WgXVe1rH2uCSKfu8f95QI1C32rE6gGg/NHcHQAhkNLAnICzS/SGjdgfoWW9VX9hpqP1A
         Adf3dXrYLsIusqq0czBOqaw/2ZsHx3aVmfG9V6QfgmHpAFsjZR/ZKKsyJNAst3ZwIJDI
         5hqRtUnX1KOZR2Ci/ZCMafK472Enx+NgS8k0j01WsZvZRaOt0NKwQYLRDswC6AahQdlk
         ufusJWii89hzbTXZluOqEiZynfI9/y5VZeYtOV59PtPqykJHtbuJQbd7U6tEmFGFrl4O
         tplw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dVGY+2eVCzb/plLTl5wPYqGdorDqWqmvQcwoi8RclRE=;
        b=Qo4bJksETEvwnHedy1ytl2DTJOkKzPUnbDgYJk73VP5RT/ipnAZn+0LjxB1EKvnIo5
         ZAup3otZQNVS77KSOHs66rtPKORUjw5XUbj7tPUvmuvXY9MZNA6rUoxwvlyO4zApYwGs
         8QDX/AwsoohDxHwy5I7KKO6z7Psyy+PhcW9SKhZTxGhjZ6F6zvSq98rh9Rny5u1CN7Mx
         q1xCUB89erJwxI9lpPrdjiN5vFEFGTMosXDMk4N4lbB4eb34r6RQ4ulDFVdqLS8BRY/z
         9JkvmnJpJPSF1JCEzjzjGic0XCslisMozFE7zdi6SjRLtFFkiRJT9qICXiyG1LmRJQbC
         C4fg==
X-Gm-Message-State: AOAM532wvy4nrAlwewJi8JNDlwlPONW71kj693xryZKywiIlDI86ovVM
        2oKEtKY1X2GbOa3wnpBSrpVFWQ==
X-Google-Smtp-Source: ABdhPJy+7UfIOPpgeTPojOLx8GUyLfk9FGzs0T3v9/Bdp6I9M66m5yG0d1EAmp8cuc7Aci1NZr8jOA==
X-Received: by 2002:a7b:c10c:: with SMTP id w12mr9672843wmi.112.1614782868292;
        Wed, 03 Mar 2021 06:47:48 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:47:46 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 29/30] scsi: lpfc: lpfc_nportdisc: Fix misspelling of lpfc_defer_acc_rsp()
Date:   Wed,  3 Mar 2021 14:46:30 +0000
Message-Id: <20210303144631.3175331-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_nportdisc.c:345: warning: expecting prototype for lpfc_defer_tgt_acc(). Prototype was for lpfc_defer_acc_rsp() instead

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_nportdisc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_nportdisc.c b/drivers/scsi/lpfc/lpfc_nportdisc.c
index 135d8e8a42ba2..ffd41cc7c96c6 100644
--- a/drivers/scsi/lpfc/lpfc_nportdisc.c
+++ b/drivers/scsi/lpfc/lpfc_nportdisc.c
@@ -329,7 +329,7 @@ lpfc_defer_pt2pt_acc(struct lpfc_hba *phba, LPFC_MBOXQ_t *link_mbox)
 }
 
 /**
- * lpfc_defer_tgt_acc - Progress SLI4 target rcv PLOGI handler
+ * lpfc_defer_acc_rsp - Progress SLI4 target rcv PLOGI handler
  * @phba: Pointer to HBA context object.
  * @pmb: Pointer to mailbox object.
  *
-- 
2.27.0

