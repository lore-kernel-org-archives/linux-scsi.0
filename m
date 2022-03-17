Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56FA7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Mar 2022 03:28:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbiCQD3j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Mar 2022 23:29:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229818AbiCQD33 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Mar 2022 23:29:29 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52A1B22B18
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:07 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id e6so1668530pgn.2
        for <linux-scsi@vger.kernel.org>; Wed, 16 Mar 2022 20:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=khuzMAwy7oWcqRIw4zoNf8o7dmNh1+plsVLzDS9L6Qk=;
        b=qv/9/3onbgmJU5nr2j9K7dqbGlsWxSQP+VZHelWHpiLQC6FgmadNGFlnhmYRDHh6PY
         Jcuf04DAHCrgIl9trfrXmJaM16kx6QZbXMmtXvDKhZO0hwNAmpT5MN+i0JKosUUAN4di
         vSXOhZxQE5X5zOH2zXSG81rSf3bnJeoEFuUWmyvTVo9rc+hENmwBcmyvj3d8ElqKPW0R
         R9KPJn74rRWvBzKiuCbcegZPeYFau4/h4EPEucKOeqAN4rZmclYmChGKRCwcPZ3S+/2U
         5uUxKhqtb9C6uipoNIy9BIKp5dA8iwbdhSQcK0QJeWAYYR74zT+Kesm6MKZof0Yg8Sry
         uJ+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=khuzMAwy7oWcqRIw4zoNf8o7dmNh1+plsVLzDS9L6Qk=;
        b=olEDKGlrrVbdh/bjl1GyaRh0Ww89q3HV153yAaG3Bq3ibeSfBL5zJj9NRoyLh1enFM
         o/Lmn4aJw4ngbYTlsThn/4+r6+/HvNgMdwFilFIGG8hrDyLglObFKmR7o2FcsG9NSGoN
         iTQviJfx1BqgSSJTivuMc5PVFxMxaAcboaw+sOeZ5dir7JugG6Y5itf+j8jzgazOCYnY
         uuvTPJsBV2/Kl4VR9rAUqbORI2REsC68+OnLRazommiMyhAF1krY8u0e9R8S/Ssvqu8A
         vOvl2OUIXv3pqZDCwh8zFTpKFAwN5ShU0KO8K6MIwuss1ZuGqItu57f+GywO+T1qrDtI
         pw7A==
X-Gm-Message-State: AOAM530Hz1bAdGmmzrJexIdKohWL6hp0jF7eDl7foEtGOBP4ITUN2LVp
        XItvhbAqAIxc9itf04phxISJAT0DHd4=
X-Google-Smtp-Source: ABdhPJwP4hoabfLqb9tgDiFvEMrctH1GTXZvu3fb89y0VnHZf6Q4Eawy/3X4YlDS53ooRS43pupjrA==
X-Received: by 2002:a63:114:0:b0:380:29f7:a97a with SMTP id 20-20020a630114000000b0038029f7a97amr2048259pgb.361.1647487670567;
        Wed, 16 Mar 2022 20:27:50 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id k11-20020a056a00168b00b004f7e1555538sm5017511pfc.190.2022.03.16.20.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Mar 2022 20:27:50 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 3/4] lpfc: Fix queue failures when recovering from PCI parity error
Date:   Wed, 16 Mar 2022 20:27:36 -0700
Message-Id: <20220317032737.45308-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220317032737.45308-1-jsmart2021@gmail.com>
References: <20220317032737.45308-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When recovering from a pci-parity error the driver is failing to
re-create queues, causing recovery to fail. Looking deeper, it was
found tha the interrupt vector count allocated on the recovery is
fewer than the vectors originally allocated. This disparity resulted
in cpu map entries with stale information. When the driver tries to
re-create the queues, it attempts to use the stale information which
indicates an eq/interrupt vector that was no longer created.

Fix by clearng the cpup map array before enabling and requesting the
irqs in the lpfc_sli_reset_slot_s4 routine.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index cf83bc0e27c0..461d333b1b3a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -15236,6 +15236,8 @@ lpfc_io_slot_reset_s4(struct pci_dev *pdev)
 	psli->sli_flag &= ~LPFC_SLI_ACTIVE;
 	spin_unlock_irq(&phba->hbalock);
 
+	/* Init cpu_map array */
+	lpfc_cpu_map_array_init(phba);
 	/* Configure and enable interrupt */
 	intr_mode = lpfc_sli4_enable_intr(phba, phba->intr_mode);
 	if (intr_mode == LPFC_INTR_ERROR) {
-- 
2.26.2

