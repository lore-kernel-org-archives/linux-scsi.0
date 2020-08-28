Return-Path: <SRS0=lsqi=CG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE56CC433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B15E920776
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Aug 2020 17:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="UHKNpX9D"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgH1Rxz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Aug 2020 13:53:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727895AbgH1Rxo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Aug 2020 13:53:44 -0400
Received: from mail-pl1-x642.google.com (mail-pl1-x642.google.com [IPv6:2607:f8b0:4864:20::642])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61C84C061264
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:43 -0700 (PDT)
Received: by mail-pl1-x642.google.com with SMTP id q3so2957pls.11
        for <linux-scsi@vger.kernel.org>; Fri, 28 Aug 2020 10:53:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L30PezUSTSdSjZeoYTtXAiWGD73goEIfHvr97NNFKBA=;
        b=UHKNpX9D7OpyzYqtBwyj24sYWvIZmTq31z7GWYtSqLLKEbEuoKegW+O39vD/5+mXMm
         XTiEHuQAAnUpgpwWHAxqzmWkP/2KezBJlOq5C9o4x9dPIiFZNCBVzmOrkLUTVfMa3SbB
         jAXNgs4q1ODTkazLQrsxrQeY9nAIXqzFq/CBI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L30PezUSTSdSjZeoYTtXAiWGD73goEIfHvr97NNFKBA=;
        b=AEarJt81zAxYPQfKofKZrqa/9xq1AAUZVoxPBPNGkM4I+Ah9pSXWN/wcB/xpZucmvE
         FK+n5CvLxdvXFvnzSc9aLDmTGZQcsY8RpD/H8fulVtNvndP/wz8Ec5ZDQ+TW7ciAiZbO
         c5wRfsOjvnisdRYryDV4TRfMf6SsYDNvOmcXHRhjNartC0/gX3HEkjTms8kbZhtLpigm
         xaWQV8skQdDctuqM8AuEAScbAdUdsxbuKn1frtL1/iN5U0fY+pTJQjQVhOgJ4tYmLDyp
         4otCSH2aU9tuDoQ3UMEW4K/+uRYxtSwIeCe38ULvPHVA4tROBakTGRf39RMcoi56y/4e
         zU0A==
X-Gm-Message-State: AOAM533eGzinmynuUNrwTU9J5RRUYBdMsslLu36DMZgYDAycWVnXmJ/d
        Bw4oIer/0YIwgW01r6PXVGQcVCt/szKAKErRKmiHdVfzLu8pQ6E7jnEkh3IOepduDuwHo/M7rxc
        VKHluOHjjqssxHI8CQDb+3Kt5eqv9tImfaa1rzoP0Q9pcWrH2fQcC5F5LF0gvRfswVo5UqoKI1G
        Gp0P8=
X-Google-Smtp-Source: ABdhPJwN7azBlziGWosfMgguZDF2xTy5jvVNNYmJUCO17rNSmTYBc3wpiJyftKTUmpp/YJPwZOwxAA==
X-Received: by 2002:a17:90a:f2c1:: with SMTP id gt1mr197076pjb.70.1598637222284;
        Fri, 28 Aug 2020 10:53:42 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id e65sm88734pjk.45.2020.08.28.10.53.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Aug 2020 10:53:41 -0700 (PDT)
From:   James Smart <james.smart@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 3/4] lpfc: Extend the RDF FPIN Registration descriptor for additional events
Date:   Fri, 28 Aug 2020 10:53:31 -0700
Message-Id: <20200828175332.130300-4-james.smart@broadcom.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200828175332.130300-1-james.smart@broadcom.com>
References: <20200828175332.130300-1-james.smart@broadcom.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Currently the driver registers for Link Integrity events only.

This patch adds registration for the following FPIN types:
Delivery Notifications
Congestion Notification
Peer Congestion Notification

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <james.smart@broadcom.com>

---
 drivers/scsi/lpfc/lpfc_els.c | 3 +++
 drivers/scsi/lpfc/lpfc_hw4.h | 2 +-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index abc6200d8881..f4e274eb6c9c 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -3517,6 +3517,9 @@ lpfc_issue_els_rdf(struct lpfc_vport *vport, uint8_t retry)
 				FC_TLV_DESC_LENGTH_FROM_SZ(prdf->reg_d1));
 	prdf->reg_d1.reg_desc.count = cpu_to_be32(ELS_RDF_REG_TAG_CNT);
 	prdf->reg_d1.desc_tags[0] = cpu_to_be32(ELS_DTAG_LNK_INTEGRITY);
+	prdf->reg_d1.desc_tags[1] = cpu_to_be32(ELS_DTAG_DELIVERY);
+	prdf->reg_d1.desc_tags[2] = cpu_to_be32(ELS_DTAG_PEER_CONGEST);
+	prdf->reg_d1.desc_tags[3] = cpu_to_be32(ELS_DTAG_CONGESTION);
 
 	lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
 			      "Issue RDF:       did:x%x",
diff --git a/drivers/scsi/lpfc/lpfc_hw4.h b/drivers/scsi/lpfc/lpfc_hw4.h
index c4ba8273a63f..12e4e76233e6 100644
--- a/drivers/scsi/lpfc/lpfc_hw4.h
+++ b/drivers/scsi/lpfc/lpfc_hw4.h
@@ -4800,7 +4800,7 @@ struct send_frame_wqe {
 	uint32_t fc_hdr_wd5;           /* word 15 */
 };
 
-#define ELS_RDF_REG_TAG_CNT		1
+#define ELS_RDF_REG_TAG_CNT		4
 struct lpfc_els_rdf_reg_desc {
 	struct fc_df_desc_fpin_reg	reg_desc;	/* descriptor header */
 	__be32				desc_tags[ELS_RDF_REG_TAG_CNT];
-- 
2.26.2

