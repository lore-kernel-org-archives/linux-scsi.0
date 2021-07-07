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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FD81C07E95
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5D62B61CC8
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jul 2021 18:44:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232684AbhGGSqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Jul 2021 14:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232606AbhGGSqo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jul 2021 14:46:44 -0400
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A512C06175F
        for <linux-scsi@vger.kernel.org>; Wed,  7 Jul 2021 11:44:03 -0700 (PDT)
Received: by mail-pg1-x52c.google.com with SMTP id a2so3226153pgi.6
        for <linux-scsi@vger.kernel.org>; Wed, 07 Jul 2021 11:44:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=l41WL1YRoN8UoHaOEQ52H1qf3qJEJ4Rqkq6dPkmzcag=;
        b=rW/xBG0jjFaCQSyY8r0WQA5fRTn7LAhORPYarkXG79GzOBuTGH5Abc5WTmwL/xShIz
         YSRBXe/TXL97pqs/RSaDpq50tZkZSStt4lxRA1xK3QIyZkk9QO6hPVJ8ytkI5UsFc/Ht
         PTvaKJRQuKQQnZ2tGPZW4CVO7QAptg8jFvFJrEFPa3hJemhIA88QcTF/3iXoE6Ajo/dT
         SKTIwMSnUXWd7Yo5WW59IYdwR3IeTnZ4zRMKdlga7UIm65QEPKze/wJuFfG226caAt2n
         v83D+J4kbUkXAjpXgnWJqjrMEq4sd5IchE93y/lcimFJLd1UGNrGRn+T5/HsJWFACmuF
         2Ffw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=l41WL1YRoN8UoHaOEQ52H1qf3qJEJ4Rqkq6dPkmzcag=;
        b=MERg5LeVMytKUiQ60aH8izgtbDU5o9AdB/0HHqeORdaPoZWlW2K2LiGjCJDOpN+zOx
         lPGldT46o+JiPmIcgHeNga0s6jlDWnKlu9yvOqAZCi2fjYg4e/fXpHWFPkTFG847CPvD
         d4CWsUKfmIfcZ+xCy+UASemvPGLkKJElFFkn8G2SReuzT/3dvnMY2XAfxM7PF/AMFU5k
         ZkOV3MwPXmNqPWtWRAK7TaMG6nttPNA+wTaR+adBAHDdPNOYs9mXO3pinhnnQSI+dWjl
         tC8IvtSttuRgWg9MQtbyNB+5LSUnz4bP3KDDozHAdgaAC/DoOZqdPqrOP0xUpLDz/R4w
         osyg==
X-Gm-Message-State: AOAM532+ihRZOJv2FOrQEp8h4+MDMks0o7Ux3X/LzmxrxniET8nn7m/i
        /plpXgTxN9RTCcdV4UXVemCwdZ0392c=
X-Google-Smtp-Source: ABdhPJy5sWP5fKHuJ+2plojnaMeGM7eha14HZGEYX9QxA1CYs/0sni3u3SKqkQQIy8Brmag8Igfnuw==
X-Received: by 2002:a65:6248:: with SMTP id q8mr28005665pgv.279.1625683442750;
        Wed, 07 Jul 2021 11:44:02 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z3sm23578631pgl.77.2021.07.07.11.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Jul 2021 11:44:02 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 11/20] lpfc: Fix KASAN slab-out-of-bounds in lpfc_unreg_rpi routine
Date:   Wed,  7 Jul 2021 11:43:42 -0700
Message-Id: <20210707184351.67872-12-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210707184351.67872-1-jsmart2021@gmail.com>
References: <20210707184351.67872-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In lpfc_offline_prep() an RPI is freed and nlp_rpi set to 0xFFFF
before calling lpfc_unreg_rpi().  Unfortunately, lpfc_unreg_rpi()
uses nlp_rpi to index the sli4_hba.rpi_ids[] array.

In lpfc_offline_prep, the unreg rpi before freeing the rpi.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 6867b02219b0..2d277979a56a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -3541,6 +3541,8 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 				spin_lock_irq(&ndlp->lock);
 				ndlp->nlp_flag &= ~NLP_NPR_ADISC;
 				spin_unlock_irq(&ndlp->lock);
+
+				lpfc_unreg_rpi(vports[i], ndlp);
 				/*
 				 * Whenever an SLI4 port goes offline, free the
 				 * RPI. Get a new RPI when the adapter port
@@ -3556,7 +3558,6 @@ lpfc_offline_prep(struct lpfc_hba *phba, int mbx_action)
 					lpfc_sli4_free_rpi(phba, ndlp->nlp_rpi);
 					ndlp->nlp_rpi = LPFC_RPI_ALLOC_ERROR;
 				}
-				lpfc_unreg_rpi(vports[i], ndlp);
 
 				if (ndlp->nlp_type & NLP_FABRIC) {
 					lpfc_disc_state_machine(vports[i], ndlp,
-- 
2.26.2

