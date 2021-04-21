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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 214CFC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D929861428
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:44:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244122AbhDUXpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243880AbhDUXpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:45:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29603C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:44:38 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d124so30365854pfa.13
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUlw/N75jvzVQQMiQL4AYE31Tu6rQl68s8EJMHspAu0=;
        b=F6mdfOqE6hpJYPwlNomP9CnsXYRBsli07tB+TGHmvfsGS46AP7blWWub5lWnnU9eHY
         PbJ4lfBJeTdnkF6YU6GiJkOdRxHntkUv8jmjyHcqnZUXcPRUPPT2ceHpTFa71x3X1FOT
         NFIi73rum0ycZItom/QWZl/ia4YMXK8tENp6RhqSymhW8yTkggC2NOEDvuh05nTwOtAK
         KhbRclTRldAqm8wIcCKu5e2H4q6Ya7IHK3NvAkGS3Krad44ODE17Q9Uqe+zntX7x44ba
         qvt6NFseskvGKTYbZ5kD3GP3jtPC0R8Rcd9wCHvWj940pqL3rj976o4jioyLaut37+Yb
         5Igg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HUlw/N75jvzVQQMiQL4AYE31Tu6rQl68s8EJMHspAu0=;
        b=fl2pk3l/KSFhUzrLqcDNkuNVvQLCefFmY4DyijpAxI0TvJ51semjK2HxF8UMv4bbFC
         FpD09/Iy5Pkd+nV4fJMYkq9SC98oddz4n1sNJx62bTReDH2nW34e8uVVcc57XhwojHWD
         ANyhzTYDkq7cn+HfuxyJKWnviQW+ubNV7kjAXstLBb++FjSTquw90xuTgC3kaMu8nymW
         +Nhx2YHtor+Z+dgxVdfpF6PPNSnptGOk8ap7fege2Y1pri0/6KYM+z27ESctweQazdLY
         JW/+kyyGhuU+0wJFjkyoj4s3Nnd2f0zFPM+ar4zL7DrjP1/wfnJH+GLDKZSv0Jp4NIPj
         fN4w==
X-Gm-Message-State: AOAM530r1l//F24n21Bd+GadfnhZzlmXOXUjcXbX6jZwCkjLpseHpI7f
        Gocz9Py8sQ0hWYd4LJv7R84dK1ZTdCM=
X-Google-Smtp-Source: ABdhPJwDQ7Q9rVqM6Br6/FxATVenPB6otx8Hi8RVuQ7zq31VVMmGzKIIHoxIftwAGBQAo/V1srtFiA==
X-Received: by 2002:a17:90a:352:: with SMTP id 18mr646689pjf.223.1619048677691;
        Wed, 21 Apr 2021 16:44:37 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p18sm3137231pju.3.2021.04.21.16.44.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:44:37 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH][REPOST] lpfc: Fix illegal memory access on Abort IOCBs
Date:   Wed, 21 Apr 2021 16:44:33 -0700
Message-Id: <20210421234433.102079-1-jsmart2021@gmail.com>
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

