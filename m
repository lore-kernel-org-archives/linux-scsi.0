Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FBDBC433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  6 May 2022 03:55:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388858AbiEFD7Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 May 2022 23:59:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1388840AbiEFD7O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 May 2022 23:59:14 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 645DEDF08
        for <linux-scsi@vger.kernel.org>; Thu,  5 May 2022 20:55:32 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so9781872pjq.0
        for <linux-scsi@vger.kernel.org>; Thu, 05 May 2022 20:55:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=V+6uiLx/k4VFmYDVC5AjP1sVnBgsOR2Jqn5YaTRl/Cc=;
        b=AgdawogO6g6qGtes0ykwPvlP0ITJbFAvL240nacedj+PjHIPbj0lBDKBNgmjo+mn3e
         bmqwYkHFQUvRTxTQ3xiXOnhlYJNdHMV8TmcCKMvEjGVmKTPgMjH9vlo4GsXX9HNGuM7g
         6lyBhUmodCqmyjlia40COuLGihscWE/sdpD5pdZXTTjQeWnn1NZPUXwdkfBLeXvjqtN8
         oeFfbTRxAE5MwFSENFXYNyXzrfX7NceLh9Nc6DIo0itqE/1Gp0V+cZ/ahRhbqQyWr3UG
         ThT+sYPFx7OBGbo/qOcO8zkKaZHdPCnOKvWojJfZASTd1NOOfAXgCfk/mHYSMdA4DPGg
         llzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=V+6uiLx/k4VFmYDVC5AjP1sVnBgsOR2Jqn5YaTRl/Cc=;
        b=nHlznF9T8qK0GjZk6OZLqdhyyvFRdnuA5Y3F/9SBPktevRxfgjbqgtcFITVL+dg0Kb
         6a/vbKiGEHWyd21UmVmWxw02TABZH4lXu1vIRv1SFvQKnFfHl4g3koY2MSDfA7eGeF3G
         DPKqVLvZBlBf8cF8FEkSRSeVQICukbcjYWuBWHnG9ma5n7mHzWZqv3VMvuWyXZ2fJxLp
         iqa/vnqhmPd6Do6ePKEEMVgrStyJSgn82HMqxgVRA26gugx1WiHCgvzBqVyJTRh4jsGr
         AXI62/4rfIA3ANzhG7bTdx/C4IFRyrJe6maKyrZTWHDZMcE9UalZcsgIUWluH27/a09H
         el1g==
X-Gm-Message-State: AOAM532MTK2BDm9ml+szylva1+5SIAg2AF2wKK2kHS6bkMta4eqim+l0
        SasP71DBBN5DBJxaYpb9r6JL/vaHLIo=
X-Google-Smtp-Source: ABdhPJypgh1RMNhrSTFYMgRAVm02ldZAmcaSVkBagAohVDYmdIzaKiccgQcVHb1w2jCagWAH/D0gYg==
X-Received: by 2002:a17:902:7c8c:b0:156:5651:1d51 with SMTP id y12-20020a1709027c8c00b0015656511d51mr1567028pll.107.1651809331660;
        Thu, 05 May 2022 20:55:31 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id ck3-20020a17090afe0300b001cd4989feebsm6065187pjb.55.2022.05.05.20.55.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 May 2022 20:55:31 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 05/12] lpfc: Fix dmabuf ptr assignment in lpfc_ct_reject_event
Date:   Thu,  5 May 2022 20:55:12 -0700
Message-Id: <20220506035519.50908-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220506035519.50908-1-jsmart2021@gmail.com>
References: <20220506035519.50908-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Upon driver receipt of a CT cmd for type = 0xFA (Management Server) and
subtype = 0x11 (Fabric Device Management Interface), the driver is
responding with garbage CT cmd data when it should send a properly
formed RJT.

The __lpfc_prep_xmit_seq64_s4() routine was using the wrong buffer
for the reject.

Fix by converting the routine to use the buffer specified in the bde
within the wqe rather than the ill-set bmp element.

Fixes: 61910d6a5243 ("scsi: lpfc: SLI path split: Refactor CT paths")
Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 15 +++------------
 1 file changed, 3 insertions(+), 12 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index b509b3147759..573526f08baf 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -10808,24 +10808,15 @@ __lpfc_sli_prep_xmit_seq64_s4(struct lpfc_iocbq *cmdiocbq,
 {
 	union lpfc_wqe128 *wqe;
 	struct ulp_bde64 *bpl;
-	struct ulp_bde64_le *bde;
 
 	wqe = &cmdiocbq->wqe;
 	memset(wqe, 0, sizeof(*wqe));
 
 	/* Words 0 - 2 */
 	bpl = (struct ulp_bde64 *)bmp->virt;
-	if (cmdiocbq->cmd_flag & (LPFC_IO_LIBDFC | LPFC_IO_LOOPBACK)) {
-		wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
-		wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
-		wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
-	} else {
-		bde = (struct ulp_bde64_le *)&wqe->xmit_sequence.bde;
-		bde->addr_low = cpu_to_le32(putPaddrLow(bmp->phys));
-		bde->addr_high = cpu_to_le32(putPaddrHigh(bmp->phys));
-		bde->type_size = cpu_to_le32(bpl->tus.f.bdeSize);
-		bde->type_size |= cpu_to_le32(ULP_BDE64_TYPE_BDE_64);
-	}
+	wqe->xmit_sequence.bde.addrHigh = bpl->addrHigh;
+	wqe->xmit_sequence.bde.addrLow = bpl->addrLow;
+	wqe->xmit_sequence.bde.tus.w = bpl->tus.w;
 
 	/* Word 5 */
 	bf_set(wqe_ls, &wqe->xmit_sequence.wge_ctl, last_seq);
-- 
2.26.2

