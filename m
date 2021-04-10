Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5C78C43462
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A0925611CA
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Apr 2021 17:30:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234903AbhDJRbC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Apr 2021 13:31:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234738AbhDJRbB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Apr 2021 13:31:01 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B561FC06138B
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id p12so6169520pgj.10
        for <linux-scsi@vger.kernel.org>; Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=k2/WQMErDOWTBOf8F7mdgEzBgEYn+fKIDvsxc5E+NPQ=;
        b=fPHE1guorbYwUsg9RfqwCZSSm9ZGhRi7ogJ5XGTJr+GX7zDKwa4JDz0rGH23+RBXq9
         Okazy+pe3LOHYF3ESRXrdx87AWrRFCdfLIuC1eYkPCUrWcVAFdeWOkTzpEZdJcEaN28F
         feGSC9P1uqLHN/VLfUln8+Z/8nFAY6zRgcn+F/OYaylDNjv02ODvyA9yRO2Izf1NUXyX
         Yfbt/aHpI1L+iH22OzrgJ26RC4M1NSapoeb+DvFRw+eBubq9Rke7IdR1NyTEyYVv4l4a
         4m7R7g3D5n5ps1IaZvoizCCvI8HRDLFXRAIxm+Qdt/0kmL8oYpbH659iMVvvnsUTr+IW
         8gBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=k2/WQMErDOWTBOf8F7mdgEzBgEYn+fKIDvsxc5E+NPQ=;
        b=XTZID7v9hQqDgYdFSaE4K4R7bf4i/aCYxAdNC0gHsJSxWKm5NwX7UvjrvITyMj0x95
         em3AOo2T5H21ayEgTGQUXsyBS4bA13yLHDXrrkXN+W4OtnMmgo62NUREwZLeAeJbPhJM
         EPVBlMexsekdxx87MRwjnYo8Dk8BI/TQJVoja+2yF0cV9tbNpv1pGnwiKRDEKYU+cm5W
         goybZ8oVcZoVhBrayAjOeLeEPoTL841VtIVsH6cllqh+UmeeD1iLhoWvHrbC/jE26DWn
         LBK1KluN+3Xy8vG1NLQmN4zabe3Xql4AzqnbeHxwbYwMUpkR3EmDVY9/Yp0i/ykntV2I
         TbfA==
X-Gm-Message-State: AOAM531cp7qlqDAyBKdQAxOdP63y17Zm4FVLRe74yKx1z/Sz81J17SR2
        y6lpDEk3x0yy727lxf1YC+DKijOVkrs=
X-Google-Smtp-Source: ABdhPJxtwc40GZJupik0dAqP+AJA3nxYEjo3kORn5A50CwNO3cVD0c7ynbf2EbEjBI7OPguOh58ezA==
X-Received: by 2002:aa7:962f:0:b029:247:b6c:52d5 with SMTP id r15-20020aa7962f0000b02902470b6c52d5mr7964308pfg.50.1618075846107;
        Sat, 10 Apr 2021 10:30:46 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x25sm5578861pfu.189.2021.04.10.10.30.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 10 Apr 2021 10:30:45 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/16] lpfc: Fix reference counting errors in lpfc_cmpl_els_rsp()
Date:   Sat, 10 Apr 2021 10:30:21 -0700
Message-Id: <20210410173034.67618-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210410173034.67618-1-jsmart2021@gmail.com>
References: <20210410173034.67618-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Call traces are being seen that result from a nodelist structure ref
counting error. They are typically seen after transmission of an LS_RJT
ELS response.

Aged code in lpfc_cmpl_els_rsp() calls lpfc_nlp_not_used() which, if the
ndlp reference count is exactly 1, will decrement the reference count.
Previously lpfc_nlp_put() was within lpfc_els_free_iocb, and the 'put'
within the free would only be invoked if cmdiocb->context1 was not NULL.
Since the nodelist structure reference count is decremented when exiting
lpfc_cmpl_els_rsp() the lpfc_nlp_not_used() calls are no longer required.
Calling them is causing the reference count issue.

Fix by removing the lpfc_nlp_not_used() calls

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 50 +-----------------------------------
 1 file changed, 1 insertion(+), 49 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index a04546eca18f..67159b957344 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -4444,10 +4444,7 @@ lpfc_mbx_cmpl_dflt_rpi(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
  * nlp_flag bitmap in the ndlp data structure, if the mbox command reference
  * field in the command IOCB is not NULL, the referred mailbox command will
  * be send out, and then invokes the lpfc_els_free_iocb() routine to release
- * the IOCB. Under error conditions, such as when a LS_RJT is returned or a
- * link down event occurred during the discovery, the lpfc_nlp_not_used()
- * routine shall be invoked trying to release the ndlp if no other threads
- * are currently referring it.
+ * the IOCB.
  **/
 static void
 lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
@@ -4494,15 +4491,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			}
 			mempool_free(mbox, phba->mbox_mem_pool);
 		}
-		if (ndlp && (ndlp->nlp_flag & NLP_RM_DFLT_RPI))
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate the node has already released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
 		goto out;
 	}
 
@@ -4580,29 +4568,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				"Data: x%x x%x x%x\n",
 				ndlp->nlp_DID, ndlp->nlp_flag, ndlp->nlp_state,
 				ndlp->nlp_rpi);
-
-			if (lpfc_nlp_not_used(ndlp)) {
-				ndlp = NULL;
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
-			}
-		} else {
-			/* Do not drop node for lpfc_els_abort'ed ELS cmds */
-			if (!lpfc_error_lost_link(irsp) &&
-			    ndlp->nlp_flag & NLP_ACC_REGLOGIN) {
-				if (lpfc_nlp_not_used(ndlp)) {
-					ndlp = NULL;
-					/* Indicate node has already been
-					 * released, should not reference
-					 * to it from within the routine
-					 * lpfc_els_free_iocb.
-					 */
-					cmdiocb->context1 = NULL;
-				}
-			}
 		}
 		mp = (struct lpfc_dmabuf *)mbox->ctx_buf;
 		if (mp) {
@@ -4618,19 +4583,6 @@ lpfc_cmpl_els_rsp(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			ndlp->nlp_flag &= ~NLP_ACC_REGLOGIN;
 		ndlp->nlp_flag &= ~NLP_RM_DFLT_RPI;
 		spin_unlock_irq(&ndlp->lock);
-
-		/* If the node is not being used by another discovery thread,
-		 * and we are sending a reject, we are done with it.
-		 * Release driver reference count here and free associated
-		 * resources.
-		 */
-		if (ls_rjt)
-			if (lpfc_nlp_not_used(ndlp))
-				/* Indicate node has already been released,
-				 * should not reference to it from within
-				 * the routine lpfc_els_free_iocb.
-				 */
-				cmdiocb->context1 = NULL;
 	}
 
 	/* Release the originating I/O reference. */
-- 
2.26.2

