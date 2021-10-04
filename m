Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48872C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 23:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C0986120F
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Oct 2021 23:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234987AbhJDXON (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Oct 2021 19:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233517AbhJDXON (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Oct 2021 19:14:13 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0F89C061745
        for <linux-scsi@vger.kernel.org>; Mon,  4 Oct 2021 16:12:23 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id oa6-20020a17090b1bc600b0019ffc4b9c51so510921pjb.2
        for <linux-scsi@vger.kernel.org>; Mon, 04 Oct 2021 16:12:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33pRDyFymmGt/fkS1UDjenP4e2Tk0azAaW8pWz3y/i8=;
        b=cOHyEsxhGuLMOZy38MqdMBFV2fSky0I38+96SsOIC3cZuKP1RjZrdqUxV/bScAHLbV
         Oe/7cqXfl0vcdcPZ2i4lDU+MTbzRgoJlEl01pZDka6drmwihgjv6aTJSErXtXuR5oeyb
         OGkbyXP2YjT65RgRmU+HovY3vLoXW5D3IGy9eZaYmobquPh27DoCYWpdmxUGSFfG2Xhx
         PuvTmVBRYAga50JlrcTo12smSts9VICYXgEUQ+5LNmThVQSx4FOBGbuJzp5DeIPI0Ees
         UwjtZEETNyTa7S+ykXgOWi3LTBiZB59lrTPqITE1fktnRdz4yr7EBdGTAP1E9Y1Bm4XY
         unJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=33pRDyFymmGt/fkS1UDjenP4e2Tk0azAaW8pWz3y/i8=;
        b=vTBfv1RIbAhSM2lL4AgFRfYfsDou0T/K/Qy1RLLsDPqEgbdvKOi3gOBcWjPXX3h+29
         Ojne09Rei9jgsqBMASbM0tsIYAjoRUfVGOi1gRd9Cey9/Epx0Ix1sHX11ZP8nyLj2Itj
         Ajjinb0gKjuE53numrmXRB2QVvN+EEFzBFoj5HC2HpH6KVe1+5njnldm27tgIq+z1Fo1
         w4q9QenBVZQWyMKih+xD70N+Y3DVP5qTGLdynl+jXDdZkOOE0QD6ZlFwpyHyCRmXjdtU
         QMldjpjXCMKYQievBpXeOr7ipgCzT7XC/M4G2ThQXmZj8CF2yZSeTSZCHBy7gF3dAjEe
         XrtA==
X-Gm-Message-State: AOAM531MOoUH1rQ6U/QnJlQbRGz1GY3Ud9336ERd9iXrN+DaY+4ga0t0
        Zx6yNJ+4OBHOwL1E+UJiRMPELPaqN4KM/g==
X-Google-Smtp-Source: ABdhPJyGu4u6lFnQNFewfZY7xkYLiWpp3DxseNtSwxepeDQF5MKSeJkBcDaF2+cApC/vBYKf+ECQqA==
X-Received: by 2002:a17:903:41c9:b0:13e:e11e:cde7 with SMTP id u9-20020a17090341c900b0013ee11ecde7mr574782ple.19.1633389143052;
        Mon, 04 Oct 2021 16:12:23 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id m73sm3241385pfd.152.2021.10.04.16.12.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Oct 2021 16:12:22 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix memory overwrite during FC-GS IO abort handling
Date:   Mon,  4 Oct 2021 16:12:10 -0700
Message-Id: <20211004231210.35524-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When an FC-GS IO is aborted by lpfc, the driver requires a node pointer
for a dereference operation.  In the abort IO routine, the driver
miscasts a context pointer to the wrong data type and overwrites a
single byte outside of the allocated space.  This miscast is done in the
abort io function handler because the abort io handler works on FC-GS
and FC-LS commands but the code neglected to get the correct job location
for the node.

Fix this by acquiring the necessary node pointer from the correct
job structure depending on the IO type.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3f911cb48cf2..d8c01114442f 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -12308,12 +12308,12 @@ void
 lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 		     struct lpfc_iocbq *rspiocb)
 {
-	struct lpfc_nodelist *ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
+	struct lpfc_nodelist *ndlp = NULL;
 	IOCB_t *irsp = &rspiocb->iocb;
 
 	/* ELS cmd tag <ulpIoTag> completes */
 	lpfc_printf_log(phba, KERN_INFO, LOG_ELS,
-			"0139 Ignoring ELS cmd tag x%x completion Data: "
+			"0139 Ignoring ELS cmd code x%x completion Data: "
 			"x%x x%x x%x\n",
 			irsp->ulpIoTag, irsp->ulpStatus,
 			irsp->un.ulpWord[4], irsp->ulpTimeout);
@@ -12321,10 +12321,13 @@ lpfc_ignore_els_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
 	 * Deref the ndlp after free_iocb. sli_release_iocb will access the ndlp
 	 * if exchange is busy.
 	 */
-	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR)
+	if (cmdiocb->iocb.ulpCommand == CMD_GEN_REQUEST64_CR) {
+		ndlp = cmdiocb->context_un.ndlp;
 		lpfc_ct_free_iocb(phba, cmdiocb);
-	else
+	} else {
+		ndlp = (struct lpfc_nodelist *) cmdiocb->context1;
 		lpfc_els_free_iocb(phba, cmdiocb);
+	}
 
 	lpfc_nlp_put(ndlp);
 }
-- 
2.26.2

