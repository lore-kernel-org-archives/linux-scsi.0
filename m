Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A475C433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68E70207BC
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 18:04:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhADSET (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 13:04:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727749AbhADSET (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 13:04:19 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86495C0617A4
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 10:03:22 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id p18so19522469pgm.11
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 10:03:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mQxjJrkT7pqr41naEEEomdkw940egPTaC50Th7l7eqY=;
        b=Ay2XcPudQEZH7ePMIsd4bSw6dycdgYzW9DLPK5ywvCV/0iORtEXu7RBJJmh1wo7YKl
         yKJSazZvb8VhgSGhR4yRajfM0jKeD2VnNL2nSshKlj0sXQZBySG55ug5lTzlQ1ZI00cu
         HSogeRUpCmNzjwX6UhjpWn1jqhxmo/qYaKHsJFHdIHAxibVOD8zzeUq5wy41GITmcWe2
         zhiQGv00zQ3SQKJvGgpA9RpJWjFDBJ8pDzh+JW3Tb2gQWG/u5gR6b1g8yjvULbHXVx6O
         h9IKJDEmLywFEklGxcsxP8b1Av4OqV8BSmZj4gFwTj4azxfqos6UcP61idHNhwWJ9DFn
         o7kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mQxjJrkT7pqr41naEEEomdkw940egPTaC50Th7l7eqY=;
        b=jBKm0dD9SYgSwj7L8soUYD8fPKdPpHQXspWga3mBP0RmOjuc5+ZYL8IZ5IYzUgYWhK
         btNsHpzZbWJedQqaL38NAzxa99Dvcce+u9gM9GGEsY7MduTu0sC4lbWwMLE80dRUeEvx
         CnVvby7DPygf4QJ5eLj/3+kV1Tq3g+PP/51ret0KgHZ4PHSJJp/v/eubYJYxEyyslJaf
         lq9qnrlcGCqYbiOKbdxtFgEaRnouK80GeK9EESHgt7wzcfsFhKMw24vowcqev8KAKMPf
         Q/3kYFT5zEG5wANO5cllGLpVatrSc7bTtBCE1xqq9afAmg9xbAf5bAledLWl0kfc8OMd
         UDzA==
X-Gm-Message-State: AOAM530xSJyo2ZkwULmZA+qcHr8b/noXjvO62SLfTIMHImhrFLwBj/bd
        k6dW/KxSgZ7SqQ0P9z873+HEM/8i0WQ=
X-Google-Smtp-Source: ABdhPJxpzb1bkhrm1YCWjVyieiJrfeJNRpXsRDEUcch7UxA2xjuk2zxhuPjzc/fRPt6n7yA4Qv0v7g==
X-Received: by 2002:a63:4851:: with SMTP id x17mr53885814pgk.451.1609783401882;
        Mon, 04 Jan 2021 10:03:21 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id q23sm57570885pfg.18.2021.01.04.10.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 10:03:21 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 12/15] lpfc: Fix crash when nvmet transport calls host_release
Date:   Mon,  4 Jan 2021 10:02:37 -0800
Message-Id: <20210104180240.46824-13-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210104180240.46824-1-jsmart2021@gmail.com>
References: <20210104180240.46824-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When lpfc is running in NVMET mode and supports the NVME-1 addendum
changes, a LIP on a bound NVME Initiator or lipping the lpfc NVMET's
link resulted in an Oops in lpfc_nvmet_host_release.

The fix requires lpfc NVMET to maintain an additional reference on any
node structure that acts as the hosthandle for the NVMET transport.
This reference get is a one-time addition, is taken prior to the upcall
of an unsolicited LS_REQ, and is released when the NVMET transport releases
the hosthandle during the host_release downcall.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_disc.h  | 16 ++++++++++------
 drivers/scsi/lpfc/lpfc_nvmet.c | 33 ++++++++++++++++++++++++++++-----
 drivers/scsi/lpfc/lpfc_sli.c   | 29 +++++++++++++++++++++++++----
 3 files changed, 63 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_disc.h b/drivers/scsi/lpfc/lpfc_disc.h
index 4cea61b63fdf..8ce13ef3cac3 100644
--- a/drivers/scsi/lpfc/lpfc_disc.h
+++ b/drivers/scsi/lpfc/lpfc_disc.h
@@ -77,6 +77,13 @@ struct lpfc_node_rrqs {
 	unsigned long xri_bitmap[XRI_BITMAP_ULONGS];
 };
 
+enum lpfc_fc4_xpt_flags {
+	NLP_WAIT_FOR_UNREG = 0x1,
+	SCSI_XPT_REGD      = 0x2,
+	NVME_XPT_REGD      = 0x4,
+	NLP_XPT_HAS_HH     = 0x8,
+};
+
 struct lpfc_nodelist {
 	struct list_head nlp_listp;
 	struct lpfc_name nlp_portname;
@@ -134,13 +141,10 @@ struct lpfc_nodelist {
 	unsigned long *active_rrqs_xri_bitmap;
 	struct lpfc_scsicmd_bkt *lat_data;	/* Latency data */
 	uint32_t fc4_prli_sent;
-	uint32_t fc4_xpt_flags;
-	uint32_t upcall_flags;
-#define NLP_WAIT_FOR_UNREG    0x1
-#define SCSI_XPT_REGD         0x2
-#define NVME_XPT_REGD         0x4
-#define NLP_WAIT_FOR_LOGO     0x2
+	u32 upcall_flags;
+#define	NLP_WAIT_FOR_LOGO 0x2
 
+	enum lpfc_fc4_xpt_flags fc4_xpt_flags;
 
 	uint32_t nvme_fb_size; /* NVME target's supported byte cnt */
 #define NVME_FB_BIT_SHIFT 9    /* PRLI Rsp first burst in 512B units. */
diff --git a/drivers/scsi/lpfc/lpfc_nvmet.c b/drivers/scsi/lpfc/lpfc_nvmet.c
index a71df8788fff..bb2a4a0d1295 100644
--- a/drivers/scsi/lpfc/lpfc_nvmet.c
+++ b/drivers/scsi/lpfc/lpfc_nvmet.c
@@ -1367,17 +1367,22 @@ static void
 lpfc_nvmet_host_release(void *hosthandle)
 {
 	struct lpfc_nodelist *ndlp = hosthandle;
-	struct lpfc_hba *phba = NULL;
+	struct lpfc_hba *phba = ndlp->phba;
 	struct lpfc_nvmet_tgtport *tgtp;
 
-	phba = ndlp->phba;
 	if (!phba->targetport || !phba->targetport->private)
 		return;
 
 	lpfc_printf_log(phba, KERN_ERR, LOG_NVME,
-			"6202 NVMET XPT releasing hosthandle x%px\n",
-			hosthandle);
+			"6202 NVMET XPT releasing hosthandle x%px "
+			"DID x%x xflags x%x refcnt %d\n",
+			hosthandle, ndlp->nlp_DID, ndlp->fc4_xpt_flags,
+			kref_read(&ndlp->kref));
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
+	spin_lock_irq(&ndlp->lock);
+	ndlp->fc4_xpt_flags &= ~NLP_XPT_HAS_HH;
+	spin_unlock_irq(&ndlp->lock);
+	lpfc_nlp_put(ndlp);
 	atomic_set(&tgtp->state, 0);
 }
 
@@ -3644,15 +3649,33 @@ lpfc_nvme_unsol_ls_issue_abort(struct lpfc_hba *phba,
 void
 lpfc_nvmet_invalidate_host(struct lpfc_hba *phba, struct lpfc_nodelist *ndlp)
 {
+	u32 ndlp_has_hh;
 	struct lpfc_nvmet_tgtport *tgtp;
 
-	lpfc_printf_log(phba, KERN_INFO, LOG_NVME | LOG_NVME_ABTS,
+	lpfc_printf_log(phba, KERN_INFO,
+			LOG_NVME | LOG_NVME_ABTS | LOG_NVME_DISC,
 			"6203 Invalidating hosthandle x%px\n",
 			ndlp);
 
 	tgtp = (struct lpfc_nvmet_tgtport *)phba->targetport->private;
 	atomic_set(&tgtp->state, LPFC_NVMET_INV_HOST_ACTIVE);
 
+	spin_lock_irq(&ndlp->lock);
+	ndlp_has_hh = ndlp->fc4_xpt_flags & NLP_XPT_HAS_HH;
+	spin_unlock_irq(&ndlp->lock);
+
+	/* Do not invalidate any nodes that do not have a hosthandle.
+	 * The host_release callbk will cause a node reference
+	 * count imbalance and a crash.
+	 */
+	if (!ndlp_has_hh) {
+		lpfc_printf_log(phba, KERN_INFO,
+				LOG_NVME | LOG_NVME_ABTS | LOG_NVME_DISC,
+				"6204 Skip invalidate on node x%px DID x%x\n",
+				ndlp, ndlp->nlp_DID);
+		return;
+	}
+
 #if (IS_ENABLED(CONFIG_NVME_TARGET_FC))
 	/* Need to get the nvmet_fc_target_port pointer here.*/
 	nvmet_fc_invalidate_host(phba->targetport, ndlp);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index dedea5de7d78..176706aaebf5 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -3011,23 +3011,44 @@ lpfc_nvme_unsol_ls_handler(struct lpfc_hba *phba, struct lpfc_iocbq *piocb)
 	axchg->payload = nvmebuf->dbuf.virt;
 	INIT_LIST_HEAD(&axchg->list);
 
-	if (phba->nvmet_support)
+	if (phba->nvmet_support) {
 		ret = lpfc_nvmet_handle_lsreq(phba, axchg);
-	else
+		spin_lock_irq(&ndlp->lock);
+		if (!ret && !(ndlp->fc4_xpt_flags & NLP_XPT_HAS_HH)) {
+			ndlp->fc4_xpt_flags |= NLP_XPT_HAS_HH;
+			spin_unlock_irq(&ndlp->lock);
+
+			/* This reference is a single occurrence to hold the
+			 * node valid until the nvmet transport calls
+			 * host_release.
+			 */
+			if (!lpfc_nlp_get(ndlp))
+				goto out_fail;
+
+			lpfc_printf_log(phba, KERN_ERR, LOG_NODE,
+					"6206 NVMET unsol ls_req ndlp %p "
+					"DID x%x xflags x%x refcnt %d\n",
+					ndlp, ndlp->nlp_DID,
+					ndlp->fc4_xpt_flags,
+					kref_read(&ndlp->kref));
+		} else {
+			spin_unlock_irq(&ndlp->lock);
+		}
+	} else {
 		ret = lpfc_nvme_handle_lsreq(phba, axchg);
+	}
 
 	/* if zero, LS was successfully handled. If non-zero, LS not handled */
 	if (!ret)
 		return;
 
+out_fail:
 	lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 			"6155 Drop NVME LS from DID %06X: SID %06X OXID x%X "
 			"NVMe%s handler failed %d\n",
 			did, sid, oxid,
 			(phba->nvmet_support) ? "T" : "I", ret);
 
-out_fail:
-
 	/* recycle receive buffer */
 	lpfc_in_buf_free(phba, &nvmebuf->dbuf);
 
-- 
2.26.2

