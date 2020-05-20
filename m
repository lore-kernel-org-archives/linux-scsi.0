Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9AE40C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7BEA7207D3
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 18:59:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c2v677ZG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726846AbgETS7w (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 14:59:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726548AbgETS7v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 14:59:51 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FA3C061A0E;
        Wed, 20 May 2020 11:59:50 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id m185so4002498wme.3;
        Wed, 20 May 2020 11:59:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9XznIvAR7bDiKtKJMgdilzMAzpTq9fw9qWshfkg00WA=;
        b=c2v677ZGK91kZ/Rcz2CeDe5ceLjERgAeHQprZlhB0BGlLmR4PLd/n3GYuTqPhbMJPP
         Z0qsPv7x0IWzhf8ao1Qm8shIROhCgepiZddpNzgLS1L+UdyG/n2MzGP1QbzSo2/URPQJ
         ivR6LxZGihjHz+0KnW3JHHfsMJjkSCpdhIyabJ226RI44xgfLwFaf9IiAzTCxj1owS7e
         4d2pv5ISR+/LDGlm1JduhYzaQUFPmMe0OZ+NvuV3s+x3CgLqj4gYgchc2LZL19/WcxTa
         T/3xO8fUoemLciM+nBpeXJvvXZoGdaVVHhbj/WTPVXpvtmzG3cwEMlMfAXIR+p+vEMRo
         esnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9XznIvAR7bDiKtKJMgdilzMAzpTq9fw9qWshfkg00WA=;
        b=i0SP8IKXFXgO24NCx8yVOX1ggy3+dELfhm5eA3yj6GSnU2MjIfKoVxLQy81Qefik+o
         dwiUnANGbSCF1g06UsZUv7sbuIdaf+Y4VEHrastLqVf6Yr0s0Ru0FxmhcokX69c8/GE0
         A5hiOokMCHR0rRl/QwAEM5Gaizt1yniOl3sQZcYgfwom0yToQdYyKWOkVC5YKmK+/NIZ
         92quFiNVwCLjvNQqtH2ylsDNtCdOGrVLrYJ5FgnVxJvqL8rFxzudYg2FhcQql1saEU+e
         vt52GdlqRjmwMYnIcXwIgMv24hspYtKwcv7iXxNTq40mZIu2YhwB11ctIBqgR8DMMi2f
         MKiw==
X-Gm-Message-State: AOAM533OfIRO29J/ugIcseoiJG1Fk46VCrthxUXIKPGSmFm2oI9LgOtm
        sYnw3X0KZKhEeuIxp96kVYINnG4d
X-Google-Smtp-Source: ABdhPJwu8XZia8JwprTLIrZXGEdQqEAyuKu+UEXw1dUK/7VHyuWf7pfCFsuhPSqbONiSVioPIWDyDw==
X-Received: by 2002:a1c:307:: with SMTP id 7mr5798016wmd.104.1590001188791;
        Wed, 20 May 2020 11:59:48 -0700 (PDT)
Received: from localhost.localdomain.localdomain (ip68-5-85-189.oc.oc.cox.net. [68.5.85.189])
        by smtp.gmail.com with ESMTPSA id c19sm3896483wrb.89.2020.05.20.11.59.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 20 May 2020 11:59:48 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-nvme@lists.infradead.org
Cc:     linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        paul.ely@broadcom.com, hare@suse.de, jejb@linux.ibm.com,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@infradead.org,
        dan.carpenter@oracle.com, James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 2/3] lpfc: fix axchg pointer reference after free and double frees
Date:   Wed, 20 May 2020 11:59:28 -0700
Message-Id: <20200520185929.48779-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200520185929.48779-1-jsmart2021@gmail.com>
References: <20200520185929.48779-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The axchg structure is a structure allocated early in the
lpfc_nvme_unsol_ls_handler() to represent the newly received exchange.
Upon error, the out_fail path in the routine unconditionally frees the
pointer, yet subsequently passes the pointer to the abort routine.
Additionally, the abort routine, lpfc_nvme_unsol_ls_issue_abort(), also
has a failure path that will attempt to delete the pointer on error.

Fix these errors by:
- Removing the unconditional free so that it stays valid if passed
  to the abort routine.
- Revise the abort routine to not free the pointer. Instead, return
  a success/failure status. Note: if success, the later completion of
  the abort frees the structure.
- Back in the unsol_ls_handler() error path, if the abort routine was
  skipped (thus no possible reference) or the abort routine returned
  error, free the pointer.

Fixes: 3a8070c567aa ("lpfc: Refactor NVME LS receive handling")
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvmet.c |  3 +--
 drivers/scsi/lpfc/lpfc_sli.c   | 10 ++++++----
 2 files changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index bccf9da302ee..32eb5e873e9b 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -3598,10 +3598,9 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 	abts_wqeq->context2 = NULL;
 	abts_wqeq->context3 = NULL;
 	lpfc_sli_release_iocbq(phba, abts_wqeq);
-	kfree(ctxp);
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME_ABTS,
 			"6056 Failed to Issue ABTS. Status x%x\n", rc);
-	return 0;
+	return 1;
 }
 
 /**
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 1aaf40081e21..9e21c4f3b009 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2813,7 +2813,7 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 	struct lpfc_async_xchg_ctx *axchg = NULL;
 	char *failwhy = NULL;
 	uint32_t oxid, sid, did, fctl, size;
-	int ret;
+	int ret = 1;
 
 	d_buf = piocb->context2;
 
@@ -2897,14 +2897,16 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 			(phba->nvmet_support) ? "T" : "I", ret);
 
 out_fail:
-	kfree(axchg);
 
 	/* recycle receive buffer */
 	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 
 	/* If start of new exchange, abort it */
-	if (fctl & FC_FC_FIRST_SEQ && !(fctl & FC_FC_EX_CTX))
-		lpfc_nvme_unsol_ls_issue_abort(phba, axchg, sid, oxid);
+	if (axchg && (fctl & FC_FC_FIRST_SEQ && !(fctl & FC_FC_EX_CTX)))
+		ret = lpfc_nvme_unsol_ls_issue_abort(phba, axchg, sid, oxid);
+
+	if (ret)
+		kfree(axchg);
 }
 
 /**
-- 
2.26.1

