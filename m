Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EF74C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 573936128B
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231352AbhJTVQw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhJTVQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:42 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17671C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id s1so15208511plg.12
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wbgHc5/zQAPVZfDjDzvVnkCM6EMKvzGucUYr+dZwcoc=;
        b=A8bhOxzhEHpbbUmrux470QkGlPjOb6Il8aJf9B5kYfYnQE2Pa7/6njd7335qQ/ZnCE
         vJ4jeRb8WXTbvF8DoLVbwUg9zWMD8GnBVDBAvg1ftWw7hKOhOsXmKFEIgbYFacfNJ+i2
         SDgnKI5kZQWnmzncWpvIHeViM9KGVmDM769OGwOSLoUKouDVg2bbYFiWImFdDex3wvaA
         2e1hCI4gWG/R9xeZ4bnK5zcFmFRI+6WKxVwIojXWhJENwkW8XmHtAYQkVNYIWw9O5Pws
         cNgOUowUG4Pd0aWDCHxUMObwe7t76oAjetTd6b+HFwNu6g19FpY762l2ILi6OEVwfE9O
         lW6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wbgHc5/zQAPVZfDjDzvVnkCM6EMKvzGucUYr+dZwcoc=;
        b=itArf9Q2vE6pmHqoNGHJG9Gok1ufOqPO4r6iiqjhXwQWfzGGFAJ0sXK66edauxvNOz
         EDiHpn22tWkFxbR72B/ivDkRPOhvXl25e812JsjXAnHIwG+iqkxGsOERwbhow50eKYs1
         j6H2KWb2GKhpe9d5bJgsve1oGhxtjZxWFBehx9aI5pDlvrD71r1Jr0jfp71RfNSdAZt8
         aiY83D3ghKaR6esPPLJesbxraIWK9k6/3mmCzND/b0IiOxx3XaDUTozGeyJQ3k4PN1iX
         dgIZ9Dm8nrNb4EPINnok+3Eipmhj/AlRgkqUNxMIenD7fSVbLdwyA1gjhrwLewR6qF7H
         xVhg==
X-Gm-Message-State: AOAM533aV/hs4hh+v6vpteuUKSybMChVhRSmUqSzAXyPWnVw65iB3Qnk
        +wH0+gXGmRA26tpQJogzAZvdUKWrPQc=
X-Google-Smtp-Source: ABdhPJzKwPwzWDMvHkxSSFwCsZxWh3hAKKWIIN0tpshXtelsVaQ8zxUDIEoRdb5HbCcCEiJ4x8RnGQ==
X-Received: by 2002:a17:90a:b105:: with SMTP id z5mr1607674pjq.64.1634764467446;
        Wed, 20 Oct 2021 14:14:27 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 5/8] lpfc: Allow PLOGI retry if previous PLOGI was aborted
Date:   Wed, 20 Oct 2021 14:14:14 -0700
Message-Id: <20211020211417.88754-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A remote nport can stop responding to PLOGI beyond the ELS IO timeout
under some fault conditions.  When this happens, the non-response
triggers a dev_loss_tmo event from the transport which causes the driver
to abort the PLOGI and stop any retries. This was due to a policy in the
ELS completion handler whenever an ELS was terminated due to driver
request.

Revise the ELS completion path to detect PLOGI's that were aborted
and allow retries.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index de38f4b886ca..746fe9772453 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4577,6 +4577,19 @@ lpfc_els_retry(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			retry = 1;
 			delay = 100;
 			break;
+		case IOERR_SLI_ABORTED:
+			/* Retry ELS PLOGI command?
+			 * Possibly the rport just wasn't ready.
+			 */
+			if (cmd == ELS_CMD_PLOGI) {
+				/* No retry if state change */
+				if (ndlp &&
+				    ndlp->nlp_state != NLP_STE_PLOGI_ISSUE)
+					goto out_retry;
+				retry = 1;
+				maxretry = 2;
+			}
+			break;
 		}
 		break;
 
-- 
2.26.2

