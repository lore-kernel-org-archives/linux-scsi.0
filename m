Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFE72C433B4
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B9761422
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:41:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243995AbhDUXmc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:42:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232353AbhDUXmc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:42:32 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DDD2C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:57 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id p2so16029260pgh.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:41:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V+cK+tmbkrwMWy930r++3trt/yTD2rco9Ay/P39OCPo=;
        b=Mapc9uL7DpRJuJfnzKuxYiGz7whkXukCFmf3IMzPczuQDG+wh1cz5FqO7/NlcST90p
         Ge1eLlpQbMAl5aHsISO4DBEeYKykHY9WZZ5c69XltaTYDWYrAhXy9cHg5C3FFGXFjmPI
         nCqYBYKYNSJhYhGaiq11daIfFKagQgTtQdY5J6sZ1CF8Tlt1j3GGHoDMK5z+zs0fRuZY
         cXhadvAUF9SsHnq1sHm2QRMWxyJ0djQauXRQ9/1+A+3pR/oOUWBvTuoZkKbrtjd5nZbp
         eUd3SfkCH/YgqNo/7xw2G+HRtDZGwClAJb0mjFiO7OVtntlqvAm2ZTCiDiKTiiWCbFQ8
         yH9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=V+cK+tmbkrwMWy930r++3trt/yTD2rco9Ay/P39OCPo=;
        b=OMf5EEFONW6ulvRqClZYIR0PCCoyTmUSkeuiheG0a4rDMLwdMSRW9WFbeIgs9wj6Kp
         +a7OdgruozoxUQKfOHmEFFkPSQ7JidlpbZ1W2nLO74DPx3NyhyBaKJKKKWIIQGx91F1v
         ms5mlGXhG21x/Qfj6/4+GMubRze2G5vBzDWAiXOjG0ZQ6mC0gQNIEy9JXO8YPWYzkmbp
         ysVdWP52TsKfU2ezC7kxLnGnx8s/QP70Rdw77UnrSce7PXO/ygkGypf1N3mZIOJ+EFLl
         JWO+Smc+GrDk208q7MezWZeIP4THGxtkua47pxpp+N8RSGihCd63lwzGtaJ7wTzC7pV+
         wm9w==
X-Gm-Message-State: AOAM5331g22FdujnMheO4yJxSZVYv1G0UjVCPqzS5Oftk7QJxyzXmTY8
        AKJNJbiXSGk+8Exq3PsT2pFCbs2YMhM=
X-Google-Smtp-Source: ABdhPJycQLSYjS8puel/NWb+m34olc7+64YnK9p4sa1RRCut+vvmNRzLYagLS2rjPuUt3WriB9DugA==
X-Received: by 2002:a63:5c19:: with SMTP id q25mr623780pgb.402.1619048516586;
        Wed, 21 Apr 2021 16:41:56 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id o15sm3318348pjk.48.2021.04.21.16.41.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:41:56 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH] lpfc: Fix bad memory access during VPD DUMP mailbox command
Date:   Wed, 21 Apr 2021 16:41:52 -0700
Message-Id: <20210421234152.101906-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The dump command for reading a region passes a requested read length
specified in words (4byte units). The response overwrites the same
field with the actual number of bytes read.

The mailbox handler for DUMP which reads VPD data (region 23) is
treating the response field as if it were still a word_cnt, thus
multiplying it by 4 to set the read's "length". Given the read value
was calculated based on the size of the read buffer, the longer
response length runs off the end of the buffer.

Fix by reworking the code to use the response field as a byte count.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>

Notes:
	ECD submit header:

	*******************

	COMMIT-TITLE: Back out svn rev 73205 - causing KASAN error
	COMMIT: 78630
	COMMIT-BZ: 244614
	COMMIT-QC:

  r78630 | jinfante | 2021-04-05 12:40:48 -0700 (Mon, 05 Apr 2021) | 25 lines

  Back out svn rev 73205 - causing KASAN error

  Bugs: 244614

  Reviewers: rkennedy pely

  Symptoms:
  KASAN detected issues
  page dumped because: kasan: bad access detected

  Cause:
  svn rev 73205

  Fix:
  dump mbox takes word count as input, byte count as output.

  Notes:

  Unit Testing:
  Added log message on VPD dump to verify output

  System Testing:

  Review_ID: https://cmengapps1.lvn.broadcom.net/r/34471/
---
 drivers/scsi/lpfc/lpfc_init.c | 12 ++++++------
 drivers/scsi/lpfc/lpfc_sli.c  | 15 ++++++++-------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 1e4c792bb660..5f018d02bf56 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -254,13 +254,13 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 		if (mb->un.varDmp.word_cnt == 0)
 			break;
 
-		i =  mb->un.varDmp.word_cnt * sizeof(uint32_t);
-		if (offset + i >  DMP_VPD_SIZE)
-			i =  DMP_VPD_SIZE - offset;
+		if (mb->un.varDmp.word_cnt > DMP_VPD_SIZE - offset)
+			mb->un.varDmp.word_cnt = DMP_VPD_SIZE - offset;
 		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
-				      lpfc_vpd_data  + offset, i);
-		offset += i;
-	} while (offset < DMP_VPD_SIZE);
+				      lpfc_vpd_data + offset,
+				      mb->un.varDmp.word_cnt);
+		offset += mb->un.varDmp.word_cnt;
+	} while (mb->un.varDmp.word_cnt && offset < DMP_VPD_SIZE);
 
 	lpfc_parse_vpd(phba, lpfc_vpd_data, offset);
 
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 579ac75dfe79..573c8599d71c 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19777,7 +19777,7 @@ lpfc_sli_get_config_region23(struct lpfc_hba *phba, char *rgn23_data)
 	LPFC_MBOXQ_t *pmb = NULL;
 	MAILBOX_t *mb;
 	uint32_t offset = 0;
-	int i, rc;
+	int rc;
 
 	if (!rgn23_data)
 		return 0;
@@ -19808,13 +19808,14 @@ lpfc_sli_get_config_region23(struct lpfc_hba *phba, char *rgn23_data)
 		if (mb->un.varDmp.word_cnt == 0)
 			break;
 
-		i =  mb->un.varDmp.word_cnt * sizeof(uint32_t);
-		if (offset + i >  DMP_RGN23_SIZE)
-			i =  DMP_RGN23_SIZE - offset;
+		if (mb->un.varDmp.word_cnt > DMP_RGN23_SIZE - offset)
+			mb->un.varDmp.word_cnt = DMP_RGN23_SIZE - offset;
+
 		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
-				      rgn23_data  + offset, i);
-		offset += i;
-	} while (offset < DMP_RGN23_SIZE);
+				       rgn23_data + offset,
+				       mb->un.varDmp.word_cnt);
+		offset += mb->un.varDmp.word_cnt;
+	} while (mb->un.varDmp.word_cnt && offset < DMP_RGN23_SIZE);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
 	return offset;
-- 
2.26.2

