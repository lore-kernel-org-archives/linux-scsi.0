Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CBBDC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Apr 2022 22:22:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232128AbiD0WZp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Apr 2022 18:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232108AbiD0WZn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Apr 2022 18:25:43 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA092B189
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:22:30 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so6080455pju.2
        for <linux-scsi@vger.kernel.org>; Wed, 27 Apr 2022 15:22:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dg24V0JWn98Eul6Z9xRFpXyrDXxxpOcGv/c3Kp+IvDs=;
        b=B8cbrcqojthGkxfv6x5dj6x44Y+eDH9yIeiwj2WyneaOgchTvNBqjOo5Pc+KDA+ffj
         mEne6BsI30HRn6YChiLx05fHfgXxPKq19OqEjZR2dDYwJJlnS2IKezPC4tdK20F9nLId
         AEowgqPflbdaQIHlg9e/bK9L/yHetH+B65G2tp97xp0QUUAiRfS/ZlMnxyhOifPMPsat
         3Bes3GaMAcEa/DuiCCipjDYwWujmXPIlJ5gcIbjWoLOohDlx7Ui+Tw24ozcg/etj3Mjh
         ccOBSMzKeg/ZNwl7rbmDWcg3zFXZ9vg+yon6Q4CK6Fb6tRIdJjCrKVSk8hzK+jNvM5Bd
         m/cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dg24V0JWn98Eul6Z9xRFpXyrDXxxpOcGv/c3Kp+IvDs=;
        b=PNuPAv1pgwEvV7fRJVCqUlFENm3RYNKMzmwoZcj9sWIDC6E5kBNJOLReam3Pw2XbKI
         jf4QEo/7K1DJNHKO4TStlILG2jJbxiC+8hxDR9kOp4oqBSTWwEedJ7jqWfgaBPyD3E73
         EmQtxvXiy36VIosfyOmsbMmMv0iWJCuGNjT4eKVeGMK94B1L3Xz+QzcQvT0HshCsTyr5
         aoidnHP052aZUazJ72ksa7mKW2JyDaUYxmrGOXxLig0TUOGF54B9D8BYSnJXKVZty0Q1
         BIfH06zvhCr9Rw+XptuynqCoon+2pEAFVMRIa+rUoX8/BPruxmAB+4HaEz6HzjZ8s5bU
         Qhxg==
X-Gm-Message-State: AOAM530lYbOLPJnHjp4yZMdVQRyZT8Zp3HSfqcZcpAW2wOJM3nPECI+2
        AjTtalmipi9ENL8A7EVbURd0l52lQd8=
X-Google-Smtp-Source: ABdhPJwzLTeEujDdI2ipGBBCcTscwRvecvTk5wHWIKgt065TaX8k0QAtBaqcLjdTUZfKpGWsaH7HiA==
X-Received: by 2002:a17:90b:314a:b0:1d9:5ccf:baab with SMTP id ip10-20020a17090b314a00b001d95ccfbaabmr22900550pjb.110.1651098149478;
        Wed, 27 Apr 2022 15:22:29 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090a154800b001daac75511esm1687536pja.51.2022.04.27.15.22.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Apr 2022 15:22:29 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH] lpfc: Remove redundant lpfc_sli_prep_wqe() call
Date:   Wed, 27 Apr 2022 15:22:23 -0700
Message-Id: <20220427222223.57920-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prior patch added a call to lpfc_sli_prep_wqe prior to lpfc_sli_issue_iocb.
This call should not have been added as prep_wqe is called within
the issue_iocb routine. So it's called twice now.

Remove the redundant prep call.

Fixes: 31a59f75702f ("scsi: lpfc: SLI path split: Refactor Abort paths")
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 71e7d209bd0b..a0ef1fede3cc 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -18690,13 +18690,11 @@ lpfc_sli4_seq_abort_rsp(struct lpfc_vport *vport,
 	       phba->sli4_hba.rpi_ids[ndlp->nlp_rpi]);
 	bf_set(wqe_cmnd, &icmd->generic.wqe_com, CMD_XMIT_BLS_RSP64_CX);
 
-
 	/* Xmit CT abts response on exchange <xid> */
 	lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
 			 "1200 Send BLS cmd x%x on oxid x%x Data: x%x\n",
 			 ctiocb->abort_rctl, oxid, phba->link_state);
 
-	lpfc_sli_prep_wqe(phba, ctiocb);
 	rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, ctiocb, 0);
 	if (rc == IOCB_ERROR) {
 		lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
-- 
2.26.2

