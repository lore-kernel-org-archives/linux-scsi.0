Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DC63C433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 20:55:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444045AbiEFU70 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 May 2022 16:59:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346231AbiEFU7W (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 May 2022 16:59:22 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9854B65A4
        for <linux-scsi@vger.kernel.org>; Fri,  6 May 2022 13:55:37 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id t11-20020a17090ad50b00b001d95bf21996so11839798pju.2
        for <linux-scsi@vger.kernel.org>; Fri, 06 May 2022 13:55:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NFXQyyXiGUNufyA1e+SQwcuX7Pbo4KmUoL1yUvsJ4s=;
        b=dLGzaS3FaHQG7EZ/WzLmDcFzXUtEVIVxodlswB4/GReyOY00Wep5IV/IfvhJZC5BAf
         HPfj9stGBo5SIBqwcSzgyxXT3heSUSKh5zYi8oH/fNF73N5qobhNEBYdeOgWGToSd9LD
         MwFQbQg7rqYeTvAhzauvJyzfTtXk13tdpQmOTC+fF9mIsqUmpwdUwNwZJPald553Oyug
         cfVtk8G9taVHcQo9P7zkQCkm0NSKT+rWr+RHBPUIqX7OaCaqeOSSaNu04leSct9m8TD0
         Vm5E5yMQwXmclV7ccSALNa/lYEtqt8KsboHpDuZg1ylIZz0fwccRM/7xsjoWg5si4Fm8
         CODQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=2NFXQyyXiGUNufyA1e+SQwcuX7Pbo4KmUoL1yUvsJ4s=;
        b=0sBv+sCv/L7QPZD6tAA+wif4Tdf8fpN0SYp18NZ1/83+AxTJyh4QCZJ+SwkzAIkToB
         VgTn68/uOhfMQWNELePOletrMaTlmQxseaVUMGKQAQL/OaWgfANKhKu0Cwue0Vk/Zr1M
         CIz2cXSdpsAvgI/IBO4yt0EiFc2cpb3AQd0NtrWPVUrtgOrI4nO6ZVACrYuY1eNo7LhX
         g3roj+0tKeqLDJj1D2cM/OeGmgSNdwdkfxKDBpuNmOMk67Jfme6xXKmOeZBGVvPedrTJ
         gk2y7+DpUCaRoB59oBJNZb7VhzF/8cfCUzuF/V3kuK2zVpdAMLtrgHuaGhhLOAwSsI2D
         sU5g==
X-Gm-Message-State: AOAM533/k2Xwgn4JsjL2Ruse2JrBBdDRBdRSuiSjZGMT3t2gbUIJf2RA
        Qnxzh1dJpPAbNSKDlO1dN0QXMckuAwI=
X-Google-Smtp-Source: ABdhPJyZbUjKHmJpbIysBSAL34aPLgKKg085S1KxlMCQEB6GPPkz7Owq5B7XMZ0bnmTsPeZz2GgjGA==
X-Received: by 2002:a17:902:a417:b0:158:ed2c:3740 with SMTP id p23-20020a170902a41700b00158ed2c3740mr5466172plq.121.1651870536859;
        Fri, 06 May 2022 13:55:36 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id x15-20020a170902ec8f00b0015e8d4eb261sm2283719plg.171.2022.05.06.13.55.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 13:55:36 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH] lpfc: Fix split code for FLOGI on FCoE
Date:   Fri,  6 May 2022 13:55:28 -0700
Message-Id: <20220506205528.61590-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The refactoring code converted context information from SLI-3 to SLI-4.
The conversion for the SLI-4 bit field tried to use the old (hacky)
sli3 high/low bit settings.  Needless to say, it was incorrect.

Explicitly set the context field to type FCFI and set it in the wqe.
SLI-4 is now a proper bit field so no need for the shifting/anding.

Fixes: 6831ce129f19 ("scsi: lpfc: SLI path split: Refactor base ELS paths and the FLOGI path")
Co-developed-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_els.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/lpfc/lpfc_els.c b/drivers/scsi/lpfc/lpfc_els.c
index 51c505d15410..07f9a6e61e10 100644
--- a/drivers/scsi/lpfc/lpfc_els.c
+++ b/drivers/scsi/lpfc/lpfc_els.c
@@ -1317,7 +1317,7 @@ lpfc_issue_els_flogi(struct lpfc_vport *vport, struct lpfc_nodelist *ndlp,
 		if (bf_get(lpfc_sli_intf_if_type, &phba->sli4_hba.sli_intf) ==
 		    LPFC_SLI_INTF_IF_TYPE_0) {
 			/* FLOGI needs to be 3 for WQE FCFI */
-			ct = ((SLI4_CT_FCFI >> 1) & 1) | (SLI4_CT_FCFI & 1);
+			ct = SLI4_CT_FCFI;
 			bf_set(wqe_ct, &wqe->els_req.wqe_com, ct);
 
 			/* Set the fcfi to the fcfi we registered with */
-- 
2.26.2

