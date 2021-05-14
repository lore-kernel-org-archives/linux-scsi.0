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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BA09C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 717EF615FF
	for <linux-scsi@archiver.kernel.org>; Fri, 14 May 2021 19:56:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232896AbhENT5T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 15:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232838AbhENT5S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 15:57:18 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC2C5C06174A
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:06 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e18so76868plh.8
        for <linux-scsi@vger.kernel.org>; Fri, 14 May 2021 12:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7ibq0v3jx7A60zF5F2u55QM1VTj+2Trs3hYQZdVcQvo=;
        b=kGYOvrAiNC89+LU1aYCadcc9+NnwMI7MQ7pEowBjkeTqYXUYu0vH/wwhanN2k8i7Gt
         0gCQ7ddcJ8+EqpRS5JUsMmBcZqtdeO1vzSmYfc2tZcv8TfhfEDFit2riVHlhr4DMBnVA
         6R1PIqYMsLXFVGk/lN0L7B4QNSnOHJX/MM2YAF18diIkuSUBlASLS566VunZUyH3cG8M
         oDA9YaerG7ZEtp2Dw0qgmGIfdf+BiVN46ghl4F92YqYEy2CJ4NMXkxRZrYFS0/HbpFjA
         zEBpPivFkISkbqG8Xl6hTimQgK5uu598T9VBRuCeNuOzfOcU4f38pvxK/tmhTQc9MOfc
         +5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7ibq0v3jx7A60zF5F2u55QM1VTj+2Trs3hYQZdVcQvo=;
        b=KcnQQumTz9E6jdTnvKpK1ouiLbF4Fy59pDjcW3TcuzmErFjEqJ1DYlEB2G8RLZHFa9
         Ug0YZJpNk7eop1ucXK6MhIXS3iovFP1AmAFAsYmToGUwwCj+16yIcEDpO/4bfGNF2tlS
         79Mt9nRTaSoJVOvwVyEAy2ti0DXnKdngzColh6+zGY/1W1CnsnvshEwnxfgRLO98b7oB
         ANlIbfHVjsvGvthXDkeu+3lwNu/2Kjc2+CI1GxSPyMf4br+vSBq0hJIctfbFoQixPFDu
         T1q8EFHgqabHqwLdubp2N0FnoPzwQQqxdqiIgT/2f+EhOof/5/JOPDjDIJ0e8/3jFFUU
         Jc8Q==
X-Gm-Message-State: AOAM5332hs98gatbHfx2R8JOAUL9xlgFe7nbHIPFDlJXns3rnJBWK+nd
        SK9uIPhLVQlxrpF7hcwLPcNdhr0hLrY=
X-Google-Smtp-Source: ABdhPJxqlCL47yFCrHQJXytb81BZzd0JpLcq3UXE18vavvwllpUz7kBeuCbJ5Q+Po+oQRaxN1ujxjQ==
X-Received: by 2002:a17:90a:b388:: with SMTP id e8mr12719197pjr.167.1621022166038;
        Fri, 14 May 2021 12:56:06 -0700 (PDT)
Received: from localhost.localdomain (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id v15sm4961850pgc.57.2021.05.14.12.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 May 2021 12:56:05 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 02/11] lpfc: Fix non-optimized ERSP handling
Date:   Fri, 14 May 2021 12:55:50 -0700
Message-Id: <20210514195559.119853-3-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210514195559.119853-1-jsmart2021@gmail.com>
References: <20210514195559.119853-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When processing an nvme ERSP IU which didn't match the optimized
CQE-only path, the status was being left to the WQE status. WQE status
is non-zero as it is indicating a non-optimized completion that needs
to be handled by the driver.

Fix by clearing the status field when falling into the non-optimized
case. log message added to track optimized vs non-optimized debug.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_nvme.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_nvme.c b/drivers/scsi/lpfc/lpfc_nvme.c
index 41e49f61fac2..bcc804cefd30 100644
--- a/drivers/scsi/lpfc/lpfc_nvme.c
+++ b/drivers/scsi/lpfc/lpfc_nvme.c
@@ -1049,9 +1049,19 @@ lpfc_nvme_io_cmd_wqe_cmpl(struct lpfc_hba *phba, struct lpfc_iocbq *pwqeIn,
 			nCmd->transferred_length = wcqe->total_data_placed;
 			nCmd->rcv_rsplen = wcqe->parameter;
 			nCmd->status = 0;
-			/* Sanity check */
-			if (nCmd->rcv_rsplen == LPFC_NVME_ERSP_LEN)
+
+			/* Check if this is really an ERSP */
+			if (nCmd->rcv_rsplen == LPFC_NVME_ERSP_LEN) {
+				lpfc_ncmd->status = IOSTAT_SUCCESS;
+				lpfc_ncmd->result = 0;
+
+				lpfc_printf_vlog(vport, KERN_INFO, LOG_NVME,
+					 "6084 NVME Completion ERSP: "
+					 "xri %x placed x%x\n",
+					 lpfc_ncmd->cur_iocbq.sli4_xritag,
+					 wcqe->total_data_placed);
 				break;
+			}
 			lpfc_printf_vlog(vport, KERN_ERR, LOG_TRACE_EVENT,
 					 "6081 NVME Completion Protocol Error: "
 					 "xri %x status x%x result x%x "
-- 
2.26.2

