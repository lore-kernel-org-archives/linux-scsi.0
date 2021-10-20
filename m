Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE14BC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C8D2161284
	for <linux-scsi@archiver.kernel.org>; Wed, 20 Oct 2021 21:14:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231313AbhJTVQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 Oct 2021 17:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbhJTVQm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Oct 2021 17:16:42 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC18C06161C
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:27 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id gn3so3415371pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 20 Oct 2021 14:14:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hKF12mEwxEHSFypa09hDmUDzypGCfCd20ZJONrZg0CI=;
        b=htakT7nHklPdlf1GRzgKftRTbssTa/5b3OhnwQNotQbThi1z6TYC99SeB8rtWV1Iy9
         /rxT/5fd7gnlxwV7dM7Swa+97pvX4JF7qAbFoWQBU4aV+MFLjYk+TQW9fMk+jFq/ceDB
         YMxNsZoHLuSlqw62A/T3VPFuUDzljgvOM1wwNBOK8C708cKuVCIv7Y8DKp/2VSP8ri9N
         OqckF7ElZlATm0l3gsMrMOclZAOJkMCx6zQXnOTN/y2TdNxh9oAA8i/EtsepMhpZJ5rn
         XP9P0P1Vn3WZrUi3+EtiggrngYOJznA1uEs9TEK8JrYmVJf+i03taGZxI5uevoh+/I0t
         lydA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hKF12mEwxEHSFypa09hDmUDzypGCfCd20ZJONrZg0CI=;
        b=HFVa5SP/ooaubbIU9tpxT4opozJi3kJ5BwjdWFyOyCOowyBmfpVvUDi6fdpnfbU0kC
         DL2wMQUW2qZshmeWQS6CxR0TSwitiM/Yo4Afd9yArvK1JlsUmI53WPmX3bQmvknyoPRw
         28haFnqYrCbhR8V50sI9cYGjFVLKXZrex0pK6GpM3Rrs9wmwY2Cjadhmi3++ur2mRUcD
         G6DcwTYwTYtg3esWS7tOWR7o8A2Nw3gUP8UxOS/p8NjxmmcakN73OMlr+eanPEFOGsbA
         PR7lIlbLgAJf6eTtbexqpBZPoLy/Qji0I+lTvaDUtUrtJEwyqrreDt60sN8URAg1ym7b
         lxeg==
X-Gm-Message-State: AOAM5306z/3vtNdxrJmDPauKxeMD2OAsvhNLHkV18hTlk4F1gzMieI+Q
        zWCfecPDMyYTir4nxI1bAdfxPEmQpnc=
X-Google-Smtp-Source: ABdhPJzUFls2ZOOcLWMvGmhczB4CX4L1IoWr4fSTO7D1cH27PVr4Dvuiac+3JW0cpq1fX41zVeHjnA==
X-Received: by 2002:a17:90a:6782:: with SMTP id o2mr1588247pjj.165.1634764466830;
        Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id pi9sm3700689pjb.31.2021.10.20.14.14.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Oct 2021 14:14:26 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 4/8] lpfc: Fix use-after-free in lpfc_unreg_rpi() routine
Date:   Wed, 20 Oct 2021 14:14:13 -0700
Message-Id: <20211020211417.88754-5-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20211020211417.88754-1-jsmart2021@gmail.com>
References: <20211020211417.88754-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

An error is detected with the following report when unloading the driver:
  "KASAN: use-after-free in lpfc_unreg_rpi+0x1b1b"

The NLP_REG_LOGIN_SEND nlp_flag is set in lpfc_reg_fab_ctrl_node(), but
the flag is not cleared upon completion of the login.

This allows a second call to lpfc_unreg_rpi() to proceed with nlp_rpi
set to LPFC_RPI_ALLOW_ERROR.  This results in a use after free access
when used as an rpi_ids array index.

Fix by clearing the NLP_REG_LOGIN_SEND nlp_flag in
lpfc_mbx_cmpl_fc_reg_login().

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_hbadisc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_hbadisc.c b/drivers/scsi/lpfc/lpfc_hbadisc.c
index 0b1e1cc00e01..4c068fbb550a 100644
--- a/drivers/scsi/lpfc/lpfc_hbadisc.c
+++ b/drivers/scsi/lpfc/lpfc_hbadisc.c
@@ -4372,6 +4372,7 @@ lpfc_mbx_cmpl_fc_reg_login(struct lpfc_hba *phba, LPFC_MBOXQ_t *pmb)
 			 ndlp->nlp_state);
 
 	ndlp->nlp_flag |= NLP_RPI_REGISTERED;
+	ndlp->nlp_flag &= ~NLP_REG_LOGIN_SEND;
 	ndlp->nlp_type |= NLP_FABRIC;
 	lpfc_nlp_set_state(vport, ndlp, NLP_STE_UNMAPPED_NODE);
 
-- 
2.26.2

