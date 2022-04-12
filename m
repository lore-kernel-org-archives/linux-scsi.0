Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C5BFC43217
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:34:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231210AbiDLXgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231348AbiDLXcw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:52 -0400
Received: from mail-pf1-x42c.google.com (mail-pf1-x42c.google.com [IPv6:2607:f8b0:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7D68C55AD
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
Received: by mail-pf1-x42c.google.com with SMTP id y8so329533pfw.0
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=TsLNMYJ4zkgM6Icr3cjbZk4Yw4BK1K+tR4IhGs9dJeI=;
        b=EkKTosh/Hp/W4mGJRlVTpQ/5JvUbNK+byc9EP7yffgXcRaG9IkM9wixnW1B5q2lsPJ
         vCGYnejlLFmeesh9pOiv86HezLaI/GjKWfb6cepTWbuBBQkz+b3rw3D40k8WJmZ9oHnj
         sTlYShUbauGrdiw4nxtrsrnkS4+xoiwkWg4Vpgoc2G/4fMiWDj/scvr0Ci5gKVtlqOwv
         hvvMcz4tzMV76omnf/jF8RsyWE6BKwegI8/aHCOGtqHz0XssVuL6inKrjykKgc5TI1mP
         7uzKW0mCqXrBnGvslSSKZAAne3Ux1dyzgG6BEV2luJPmBr/JMLD67/dfNF8a1gbwNA1J
         x+5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=TsLNMYJ4zkgM6Icr3cjbZk4Yw4BK1K+tR4IhGs9dJeI=;
        b=g+C1giazWLmLpNCIe+v/1lnawBvdcxkb1eAWyj3zRPUwMref+kPUHUR/D3V3C29lyS
         eRysOFjLFw4l1WDUE8dDUUpt/ScFAgK6AQLGR6ToXoXnpriJemu0svGvL5oT54WVldnY
         bdZiZf0wINMniAxAvLQTcn/uwPXL7Yhu/JYuX5jQFPyp0YkzfW9wPffikdJIN0/sfNfw
         NEGxs/tiHWiAixoSkewkfR17Is3dOAXRoN//6O1pQwJFHfNqk/9j+8PaVbvtENL4hM9G
         Us6FohGWBlCrNqDrKxvfFt+qkrtsEC3pqMIpe2vtyG9B2H/kaR79J9oIcwZlIdEKCx5R
         O7Yg==
X-Gm-Message-State: AOAM533E60sfGS3XkQtoPVsJMGI4bcpqFmtRJh1zBNrdXTrzbVmyZQQv
        2dmj1+TPxnemFHd4CLJcoyU4Zr1VEM8=
X-Google-Smtp-Source: ABdhPJxG/7qhr54IQRIqaqOD8vJgqq/Hkqo8gHMt8NVxbsPV7PYfcBT6Sg6SzA4qOge2U5z1O5gSpg==
X-Received: by 2002:a05:6a00:24cf:b0:505:d9fd:e415 with SMTP id d15-20020a056a0024cf00b00505d9fde415mr6726917pfv.78.1649802022779;
        Tue, 12 Apr 2022 15:20:22 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 10/26] lpfc: Update fc_prli_sent outstanding only after guaranteed IOCB submit
Date:   Tue, 12 Apr 2022 15:19:52 -0700
Message-Id: <20220412222008.126521-11-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If lpfc_sli_issue_iocb fails, then the fc_prli_sent is never decremented.

Move the fc_prli_sent++ to after a guaranteed IOCB submit.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 10e534d63508..be9d4618e52c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -2570,16 +2570,6 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 
 	phba->fc_stat.elsXmitPRLI++;
 	elsiocb->cmd_cmpl = lpfc_cmpl_els_prli;
-	spin_lock_irq(&ndlp->lock);
-	ndlp->nlp_flag |= NLP_PRLI_SND;
-
-	/* The vport counters are used for lpfc_scan_finished, but
-	 * the ndlp is used to track outstanding PRLIs for different
-	 * FC4 types.
-	 */
-	vport->fc_prli_sent++;
-	ndlp->fc4_prli_sent++;
-	spin_unlock_irq(&ndlp->lock);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue PRLI:  did:x%x refcnt %d",
@@ -2587,16 +2577,25 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 	elsiocb->context1 = lpfc_nlp_get(ndlp);
 	if (!elsiocb->context1) {
 		lpfc_els_free_iocb(phba, elsiocb);
-		goto err;
+		return 1;
 	}
 
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_els_free_iocb(phba, elsiocb);
 		lpfc_nlp_put(ndlp);
-		goto err;
+		return 1;
 	}
 
+	/* The vport counters are used for lpfc_scan_finished, but
+	 * the ndlp is used to track outstanding PRLIs for different
+	 * FC4 types.
+	 */
+	spin_lock_irq(&ndlp->lock);
+	ndlp->nlp_flag |= NLP_PRLI_SND;
+	vport->fc_prli_sent++;
+	ndlp->fc4_prli_sent++;
+	spin_unlock_irq(&ndlp->lock);
 
 	/* The driver supports 2 FC4 types.  Make sure
 	 * a PRLI is issued for all types before exiting.
@@ -2606,12 +2605,6 @@ lpfc_issue_els_prli(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		goto send_next_prli;
 	else
 		return 0;
-
-err:
-	spin_lock_irq(&ndlp->lock);
-	ndlp->nlp_flag &= ~NLP_PRLI_SND;
-	spin_unlock_irq(&ndlp->lock);
-	return 1;
 }
 
 /**
-- 
2.26.2

