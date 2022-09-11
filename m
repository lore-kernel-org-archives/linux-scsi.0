Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15C4FC6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229748AbiIKWP3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbiIKWPP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:15 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C296213D6C
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:14 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id h28so4923331qka.0
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=cLqCu2GKULZveaY5e9WceBCgHVC/mxLRFCE94B80M/c=;
        b=V1jkuS7JRt16WCUMX7sFHO95wZfpFHVLTq7bbBlAu9OxdrHr3N/4PWfIMG2Ok0UCOk
         YF5EAFyixpj5sAkXUW0EQCimiUspD4iRaDPVEjxTdPBr+wBIT20kxGEE5Y9k3Hoh/Hhi
         y5JY2sm93Ycs3VW2cNri+xyo5DiPJ5Dk5ZQvPhGuwqVfp//uUW57QiAvEa7rRipsowfs
         5RE9hjemdetdOoIIBNOXclAEQvjBJ8HKJ4FkUDqAx9qhhtCO8oRvKZBc0AYFJwxanIq+
         ULMUD5yMYSpt0Wde9t67ZaLnhYqQFBmDD1y+dJ6qeYFksGj1H/kDjxuvJP5Ep8lcEfXb
         GrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=cLqCu2GKULZveaY5e9WceBCgHVC/mxLRFCE94B80M/c=;
        b=P0nJeGWYSGxWpCzI6tcVlgZUmcdRftwfyMpEsnl85y/a0RghseMXrX6IloEmCJhoFM
         RocNn4aluu8TfZOMwieSENcjD8JySPGHE/DM+EHhKgDp/i6HIHZCWr7SZitEtyn59ix0
         m2KKwyGShUDpUsLj6BRLR6p8aqJpCVpx4Wd3gmJvtlXyg/HsrfiTS8gRn7SxB7KKGf2w
         P8GfYjzy6NodV1Ctp3xwSs3suxZD5cqrQ8fsA8Ups2oX4UjURERgM7QEvKDOmzDolJVO
         proeHPzgORAnKWvYvJnPj7xc4U5huputk6Wliqr7BjDLJApDCb4PHRopc4/kuMK1+8Hs
         8hSg==
X-Gm-Message-State: ACgBeo1FIhfKARWOVnGE7queMLl9DplkaqypF5LkVmpB7vuDwkkOlMcv
        MVMFCNzB/yCBMEPP2ooT6HGk3na1Zdc=
X-Google-Smtp-Source: AA6agR5lPNsZipMnTWVDHas4GmhGyzgjJcwvb7dyEX8IyPUfJKFnLiDfRTH4WBA4IZqPAH1q6OL/Hg==
X-Received: by 2002:ae9:e217:0:b0:6ce:21bd:a03f with SMTP id c23-20020ae9e217000000b006ce21bda03fmr2202568qkc.765.1662934513775;
        Sun, 11 Sep 2022 15:15:13 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:13 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 04/13] lpfc: Add missing free iocb and nlp kref put for early return VMID cases
Date:   Sun, 11 Sep 2022 15:14:56 -0700
Message-Id: <20220911221505.117655-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Sometimes VMID targets are not getting rediscovered after a port
reset.

The iocb is not freed in lpfc_cmpl_ct_cmd_vmid(), which is the
completion function for the appid CT commands.  So after a port
reset, the count of sges is less than the expected count of 250.
This causes post reset operation logic to fail and keep the port
offline.

Fix by freeing the iocb and kref put for the lpfc_cmpl_ct_cmd_vmid()
early return cases.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index b555ccb5ae34..aad63adfc9ce 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -3909,6 +3909,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	struct lpfc_sli_ct_request *ctrsp = outp->virt;
 	u16 rsp = ctrsp->CommandResponse.bits.CmdRsp;
 	struct app_id_object *app;
+	struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
 	u32 cmd, hash, bucket;
 	struct lpfc_vmid *vmp, *cur;
 	u8 *data = outp->virt;
@@ -3920,7 +3921,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 
 	if (lpfc_els_chk_latt(vport) || get_job_ulpstatus(phba, rspiocb)) {
 		if (cmd != SLI_CTAS_DALLAPP_ID)
-			return;
+			goto free_res;
 	}
 	/* Check for a CT LS_RJT response */
 	if (rsp == be16_to_cpu(SLI_CT_RESPONSE_FS_RJT)) {
@@ -3935,7 +3936,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 			/* If DALLAPP_ID failed retry later */
 			if (cmd == SLI_CTAS_DALLAPP_ID)
 				vport->load_flag |= FC_DEREGISTER_ALL_APP_ID;
-			return;
+			goto free_res;
 		}
 	}
 
@@ -3949,7 +3950,7 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 				 app->obj.entity_id_len);
 
 		if (app->obj.entity_id_len == 0 || app->port_id == 0)
-			return;
+			goto free_res;
 
 		hash = lpfc_vmid_hash_fn(app->obj.entity_id,
 					 app->obj.entity_id_len);
@@ -3996,6 +3997,9 @@ lpfc_cmpl_ct_cmd_vmid(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		lpfc_printf_vlog(vport, KERN_DEBUG, LOG_DISCOVERY,
 				 "8857 Invalid command code\n");
 	}
+free_res:
+	lpfc_ct_free_iocb(phba, cmdiocb);
+	lpfc_nlp_put(ndlp);
 }
 
 /**
-- 
2.35.3

