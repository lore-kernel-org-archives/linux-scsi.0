Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAF70C4332D
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9CD156506F
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 17:24:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238069AbhCARWi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 12:22:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237838AbhCARTM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Mar 2021 12:19:12 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A37C0617A7
        for <linux-scsi@vger.kernel.org>; Mon,  1 Mar 2021 09:18:27 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p5so10329328plo.4
        for <linux-scsi@vger.kernel.org>; Mon, 01 Mar 2021 09:18:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4p43K1HN6fO81bEyQcwOb3iUbzlwS3ZUXijLBb/8iZ4=;
        b=AIYyw98C3a7zV8mf1A68MPf6N28agJLXk+XunjDOYTovmuagy/oYqvwUtam+jn6ztd
         WI6F+KGUhAsakq2KLueULhVC7LjGxNEUb8rscPvQMIL08Xij9S995Bp/ktFKfdEy5l8n
         3utpfLqXD2LOzR9n93tQXAEMri+wM/xfr9pUh2ExzwlntuNpqVOaSueizLcCcFEBSLG0
         XBx7F1vaSlUQA+xvbPwjXwfujaPfm1WQZ2qnEdhxvaet//m1E/JGi1s6Y44uNcnV36Aq
         QkOSG8lbekBdrPzhjRoJXownS4lt9D8lbwyFrnbr53/t3Hfc9ZFSjDkSA7pZnunRMgjt
         puvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4p43K1HN6fO81bEyQcwOb3iUbzlwS3ZUXijLBb/8iZ4=;
        b=K1ZSOrvQVrB9aRQxOPRlbsMH7Fw9klUe+gZqQYOmkJ3KNGSxTcmA9JAm6sQ/rqx6di
         7ndzc3/jBPKS7rp3WDFqpveSJoULg1NoiuPCS9wYufZqQTLl/aPrqnfeR1BpICjmihfx
         JBOr0lspoePJi+/k3Z6Q36+6HekrSL7tOP7kwmLDbaem4mK7I6CWHmgXxqsXyErcwFqA
         +UOkGqXzLYAw94L2nXXMOnd8imdkC8X0xBofpitBLkg29v6helCV9aL+SZDCFwmKceZB
         /nWklzmWwzBE38QkofxtxkJcTKWjuBNcEG+FfItmzCkx8HOb10/3jknJQTt/NvdQsern
         gHqQ==
X-Gm-Message-State: AOAM532O3+DZhqhmQTV4e8MLj8GD97NFx17pqn9/HbRHj/CX0KKdhk/s
        FvaeYsExzyA4R3RUKGLvhSPBTKgVRxs=
X-Google-Smtp-Source: ABdhPJwldLl8alZTMovkmSnxl+SGO0QmnzznQAX9LrMK8XbryIdn7HY/YeWRatYesEXlZsWhpklUSg==
X-Received: by 2002:a17:90b:1649:: with SMTP id il9mr18022705pjb.62.1614619107159;
        Mon, 01 Mar 2021 09:18:27 -0800 (PST)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id t19sm10133602pgj.8.2021.03.01.09.18.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Mar 2021 09:18:26 -0800 (PST)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH v2 02/22] lpfc: Fix vport indices in lpfc_find_vport_by_vpid()
Date:   Mon,  1 Mar 2021 09:18:01 -0800
Message-Id: <20210301171821.3427-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210301171821.3427-1-jsmart2021@gmail.com>
References: <20210301171821.3427-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Calls to lpfc_find_vport_by_vpid() for the highest indexed vport fails
with error, "2936 Could not find Vport mapped to vpi XXX".  Our vport
indices in the loop and if-clauses were off by one.

Correct the vpid range used for vpi lookup to include the
highest possible vpid.

Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 48ca4a612f80..a60fa3f67076 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -6081,12 +6081,12 @@ lpfc_find_vport_by_vpid(struct lpfc_hba *phba, uint16_t vpi)
 		 * Translate the physical vpi to the logical vpi.  The
 		 * vport stores the logical vpi.
 		 */
-		for (i = 0; i < phba->max_vpi; i++) {
+		for (i = 0; i <= phba->max_vpi; i++) {
 			if (vpi == phba->vpi_ids[i])
 				break;
 		}
 
-		if (i >= phba->max_vpi) {
+		if (i > phba->max_vpi) {
 			lpfc_printf_log(phba, KERN_ERR, LOG_TRACE_EVENT,
 					"2936 Could not find Vport mapped "
 					"to vpi %d\n", vpi);
-- 
2.26.2

