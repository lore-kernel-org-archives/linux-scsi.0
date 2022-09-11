Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F342C6FA83
	for <linux-scsi@archiver.kernel.org>; Sun, 11 Sep 2022 22:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229679AbiIKWPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Sep 2022 18:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiIKWPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Sep 2022 18:15:14 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D0E13CFD
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:13 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id d17so4120872qko.13
        for <linux-scsi@vger.kernel.org>; Sun, 11 Sep 2022 15:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jeU8J26ZtHkyQ1+qUzX2knPdsPuHCWz9iKHBwaTASFY=;
        b=f+hZRSEQepSL+1kSAhRbm3YiBydsJ9et5MDkfAlEVzQCTEroDGFAh7B3iDrCj/Uqks
         i1MC3lpLnRRQPQf0JGfEXFafo6PV30KGc2fKVKpqACTEEd2/RjsrU8h7dszIpCdUEOjn
         KKkvhusKwrFVaRWzfufLnjtzRLLUnMLIemrNH1husCCbnhNhhM1gt0WjjqrBOpyBU78L
         4rcfD63QcXYyIE77BGZv5fFiWdhqQa/iqFOxWUVVmL75gK7Wdulc2c3TCF/Om4ifwe5u
         llOT5oMT9loAZPXMEiYY/7a97jbYA47qQwKVupaO+8NFIBFr04GhedadfxMZ3OJakCfO
         fXAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jeU8J26ZtHkyQ1+qUzX2knPdsPuHCWz9iKHBwaTASFY=;
        b=ASSQjt76uIWc1v1lbwaEpiKoX3KGUPO1IDoCma/mCSIWZvDmWRz/b7HaC4HzT4++Fs
         WQ85kuYR/9tyxydpyGRJiz5CcWIwVqELb/o66KIrOw3pnXvePEA+C2zpXRZiTcJpuqRz
         w2KNtmmgkQozyDp2cOeQ1/lG0IYGBKBaoUkQjIOZ/LTB6X1wBIHO5JTpEuTHHCR8rf37
         Nd4eh2FEJZEPqQFvRgmZN8aPoxXB/fcLgvusq/kLmX4o+oddbNL+zMUm1XaLGcNx+SGM
         /hMVyHXPnaVLJOoId9Lp3+mYgkkc1z6mSkeMDyJbkMeWrEU4/18nlo4yQEeNDA9/DeGI
         Pkvg==
X-Gm-Message-State: ACgBeo2w+8aXpK6bCWbKR6bq4HaYxxVLiSnFRsvO+G8wm7SdHzPQBgeo
        H1IkFnlRBiTzG5rSUBnGHCPQ+HN0vsM=
X-Google-Smtp-Source: AA6agR7FLhG6GEUGETlsT3LXUDfl046cIbK9X1RUeTjfZZ6OedYln3BpvfD3jcHJ1EngqTbuT9P4Uw==
X-Received: by 2002:a05:620a:280e:b0:6a6:ee16:8c78 with SMTP id f14-20020a05620a280e00b006a6ee168c78mr16785357qkp.122.1662934512753;
        Sun, 11 Sep 2022 15:15:12 -0700 (PDT)
Received: from localhost.localdomain (ip98-164-255-77.oc.oc.cox.net. [98.164.255.77])
        by smtp.gmail.com with ESMTPSA id x8-20020a05622a000800b0035a70d82d7bsm5324305qtw.47.2022.09.11.15.15.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 11 Sep 2022 15:15:12 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 03/13] lpfc: Fix mbuf pool resource detected as busy at driver unload
Date:   Sun, 11 Sep 2022 15:14:55 -0700
Message-Id: <20220911221505.117655-4-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.35.3
In-Reply-To: <20220911221505.117655-1-jsmart2021@gmail.com>
References: <20220911221505.117655-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In a situation where the node state changes while a REG_LOGIN is in
progress, the LPFC_MBOXQ_t structure is cleared and reused for an
UNREG_LOGIN command to release RPI resources without first freeing
the mbuf pool resource allocated for REG_LOGIN.

Release mbuf pool resource prior to repurposing of the mailbox
command structure from REG_LOGIN to UNREG_LOGIN.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 33373b20f819..002794975cd9 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -2856,6 +2856,7 @@ void
 lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 {
 	struct lpfc_vport  *vport = pmb->vport;
+	struct lpfc_dmabuf *mp;
 	struct lpfc_nodelist *ndlp;
 	struct Scsi_Host *shost;
 	uint16_t rpi, vpi;
@@ -2868,6 +2869,12 @@ lpfc_sli_def_mbox_cmpl(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 	if (!(phba->pport->load_flag & FC_UNLOADING) &&
 	    pmb->u.mb.mbxCommand == MBX_REG_LOGIN64 &&
 	    !pmb->u.mb.mbxStatus) {
+		mp = (struct lpfc_dmabuf *)pmb->ctx_buf;
+		if (mp) {
+			pmb->ctx_buf = NULL;
+			lpfc_mbuf_free(phba, mp->virt, mp->phys);
+			kfree(mp);
+		}
 		rpi = pmb->u.mb.un.varWords[0];
 		vpi = pmb->u.mb.un.varRegLogin.vpi;
 		if (phba->sli_rev == LPFC_SLI_REV4)
-- 
2.35.3

