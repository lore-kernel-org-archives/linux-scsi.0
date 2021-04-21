Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CB79C433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B270613D7
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234969AbhDUXlu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:41:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbhDUXlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:41:49 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95576C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:14 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id g16so17101332pfq.5
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3GynYUGOPH7yEsKkmT9qqCE9XnTGtLbKwrWx0LOY7M=;
        b=d0PJrbkUW5bm7btWatm3h2Jx9D95n+5NgS71D1sjOSfzf2PhuJgnCWGFCJL58qa8Qr
         YfTp3HQCcj4ZEt7RQlbWkL+bQRCgx5kktmOJu8hSqhXxObxoiGEVJqddj2ySk/W932C7
         ChtpekfvcAN3G47SPJbzKU+pU0OoKznmdSSDkM5kubU4cwWndzFBX0k0vRrbw9ZxVEyl
         N5UH2nNtCM6SCKG6Ao7B28Nhfa4eZ7rRfkDm0dJBSUryllN3n5h/TCmlBoqFlLAqaEG+
         QgQHUPfsqV0VzQwL8/Zy1fqaib5jGQ7Xc6PLGNMWLITLksLIx6sfnBdwmXjusHSThln6
         jeuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s3GynYUGOPH7yEsKkmT9qqCE9XnTGtLbKwrWx0LOY7M=;
        b=lTnErSkjq2YK8ovxXSZ20ko1fZHsCjD1HQ4lLp9QQMfhFB+YTNpylpnALN02SONwiG
         q376k446CtGyF+gC4SHSDWwwQX8UD3EPlVgxttXj8gLK9cizzdZTrOtPZei9ZUVLIkWN
         IHPlc3O5iSIKyySN5nOPizGjms26UPEQJckdYxTiWGBTpMRRjvjt3rrx372Z5IuImP/9
         ynJavyf9N6FRBZkstRKKK5xjbWEHxpIXQBiDaBlqtXdiudv/wM7ed/KVg/Ba3BBok9V4
         p48LG3iDqFC4L2tQRZmoeiq6SU5oij5sGo2hsCrTQvBHKWAGbYJcb1hSqDxmKaCCm2lH
         di7A==
X-Gm-Message-State: AOAM5322fNdZGn8bueuGgItS/p5/8tnPZnk7UofNKHxyr0TqjvWZsJu1
        GEE7depcta8eGsvwdY1zsiRJ0DiIcp8=
X-Google-Smtp-Source: ABdhPJxGzoeuuwHrJ8KsL0OKP3jRQovOaK8CKKyr5I/1EecoI0QV7wQcFTnb4wylOFXYoFLOK7vPWQ==
X-Received: by 2002:a63:aa06:: with SMTP id e6mr601075pgf.178.1619048473903;
        Wed, 21 Apr 2021 16:41:13 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g16sm330606pfu.45.2021.04.21.16.41.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:41:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix illegal memory access on Abort IOCBs
Date:   Wed, 21 Apr 2021 16:41:09 -0700
Message-Id: <20210421234109.101764-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In devloss timer handler and in backend calls to terminate remote port
io, there is logic to walk through all active IOCBs and validate them
to potentially trigger an abort request. This logic is causing illegal
memory accesses which leads to a crash. Abort IOCBs, which may be on
the list, do not have an associated lpfc_io_buf struct. The driver is
trying to map an lpfc_io_buf struct on the iocb and which results in a
bogus address thus the issue.

Fix by skipping over ABORT IOCBs (CLOSE IOCBs are ABORTS that don't send
ABTS) in the IOCB scan logic.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

ECD submit header:

        ****************************************

        COMMIT-TITLE: Logic to validate IOCB for aborts causes illegal memory access
        COMMIT: 78307
        COMMIT-BZ: 244869
        COMMIT-QC:

r78307 | sb889165 | 2021-03-12 09:00:53 +0530 (Fri, 12 Mar 2021) | 32 lines

Logic to validate IOCB for aborts causes illegal memory access

Bugs: 244869

Reviewers: jsmart pely jinfante

Symptoms:
In devloss timer handler and in backend calls to terminate remote port io,
there is logic to walk through all active IOCBs and validate them to
potentially trigger abort request. This logic causes illegal memory access
which leads to a crash.

Cause:
Abort IOCBs are not associated with lpfc_io_buf structure. While validating
FCP IOCBs, the function tries to map abort IOCB request to lpfc_io_buf struct
using container_of macros. This causes illegal memory access and thus leads
to interpreting junk values eventually leading to crash.

Fix:
Skip over abort IOCBs and IOCBs that have already been aborted.

Notes:

Unit Testing:

System Testing:
- Tested with ocs_fc_ramd SCSI target driver
- Trigger lips on initiator node
- Trigger port swaps and run io in background

Review_ID: https://cmengapps1.lvn.broadcom.net/r/34278/
---
 drivers/scsi/lpfc/lpfc_sli.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 06ccc0157bd8..579ac75dfe79 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -11804,13 +11804,20 @@ lpfc_sli_validate_fcp_iocb(struct lpfc_iocbq *iocbq, struct lpfc_vport *vport,
 			   lpfc_ctx_cmd ctx_cmd)
 {
 	struct lpfc_io_buf *lpfc_cmd;
+	IOCB_t *icmd = NULL;
 	int rc = 1;
 
 	if (!iocbq || iocbq->vport != vport)
 		return rc;
 
-	if (!(iocbq->iocb_flag &  LPFC_IO_FCP) ||
-	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ))
+	if (!(iocbq->iocb_flag & LPFC_IO_FCP) ||
+	    !(iocbq->iocb_flag & LPFC_IO_ON_TXCMPLQ) ||
+	      iocbq->iocb_flag & LPFC_DRIVER_ABORTED)
+		return rc;
+
+	icmd = &iocbq->iocb;
+	if (icmd->ulpCommand == CMD_ABORT_XRI_CN ||
+	    icmd->ulpCommand == CMD_CLOSE_XRI_CN)
 		return rc;
 
 	lpfc_cmd = container_of(iocbq, struct lpfc_io_buf, cur_iocbq);
-- 
2.26.2

