Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACB85C433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 882262074D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 21:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rJLX6yCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729913AbgF3VuY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 17:50:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726737AbgF3VuW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 17:50:22 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42343C061755
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:22 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id j18so20213039wmi.3
        for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2020 14:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=42LZs8EO5buLaZnWw8fHdiS056ty+TQBSCdhfIgXg0w=;
        b=rJLX6yCzASf7MZe+0D9ECK8zaUyNKAzD+uP+UDA0GjIYjYUsrs4a4kcuq9O/EHm5/V
         sAPsyyMN4ITSbtgDhZjZWMOLA537BbAiK1I4CkZI3E66214yYYP7iLhWn3Sedu+i7jUJ
         REL23pXb/pib2IzLc9vSre2J0nSxnrmaHYD78jC5sOtuqiveWkAy0BL5rlPYqeELK6JG
         I6YsEzntD2/JCUqe2AcZb1kteILDkD4df9OUlfSSP9dcfPJygb59CUhKEazOoCjzpyPw
         ki7RGSBxxUppjat5qThc58X/JNT9B7zbr11qOQU7sNjbsNke0MMnsEHGK4sKVQufOl+P
         hKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=42LZs8EO5buLaZnWw8fHdiS056ty+TQBSCdhfIgXg0w=;
        b=LZwgd9Pf11wp6sZsO236fK54vx+D7Yl8uEVJawRvYd6Z41ieTSeFQofkmSPAkYLEcI
         O7AWl31KnIE75AfnJWHyQ/5BnvlciLkiRrw/QsN7s9bIjIciJ1r2zQ8mvl8VIRxsG2uG
         c5GqazcSTkehD0tp/Vz1OG7A4cvT6R3ZOxRygDmkpETQ5OSF/mo2DfLStv+1t/K/KDbw
         Damz2MvYKWwAKK8mmY6KbHlIhlRj2IjIPrnRJYQ8eMp167/ZPQyMtk7LjKti9Xrbuh0x
         EcEKuy028R9fl/1LNNP1GAlKh0tqym4acdaVDz9vfpPL2fsS/pXo9hKkjbArbn0Lzyqa
         DMCg==
X-Gm-Message-State: AOAM530AAVT68I+s5mK5d6BAtrurBWPnLXn0syqdoSfXXUC9bpeWUcfq
        l3i6vtCVL3yzLXY5mgm/Jdz7h5pX
X-Google-Smtp-Source: ABdhPJyu1Qb1fBLXHWxYfQP+3UkTzSHzvipDiENiSgfDTGzNK4TtFVSOarbq90kJLfUClk1heNroqg==
X-Received: by 2002:a05:600c:2f17:: with SMTP id r23mr22353653wmn.167.1593553819475;
        Tue, 30 Jun 2020 14:50:19 -0700 (PDT)
Received: from localhost.localdomain.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id f14sm5518551wro.90.2020.06.30.14.50.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2020 14:50:18 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>
Subject: [PATCH 05/14] lpfc: Fix oops due to overrun when reading SLI3 data
Date:   Tue, 30 Jun 2020 14:49:52 -0700
Message-Id: <20200630215001.70793-6-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200630215001.70793-1-jsmart2021@gmail.com>
References: <20200630215001.70793-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

When using DUMP on SLI3 to read VPD and Port status data (config region
23), the adapter is overruning the kmalloc'd buffer causing havoc on
other consumers of the allocation pools.

Rework the loops processing the dump data and validate/size memory lengths
before performing bcopy's.

Signed-off-by: Dick Kennedy <dick.kennedy@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_init.c | 14 ++++++++------
 drivers/scsi/lpfc/lpfc_sli.c  | 14 +++++++-------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 69a5249e007a..287a78185dc7 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -253,13 +253,15 @@ lpfc_config_port_prep(struct lpfc_hba *phba)
 		 */
 		if (mb->un.varDmp.word_cnt == 0)
 			break;
-		if (mb->un.varDmp.word_cnt > DMP_VPD_SIZE - offset)
-			mb->un.varDmp.word_cnt = DMP_VPD_SIZE - offset;
+
+		i =  mb->un.varDmp.word_cnt * sizeof(uint32_t);
+		if (offset + i >  DMP_VPD_SIZE)
+			i =  DMP_VPD_SIZE - offset;
 		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
-				      lpfc_vpd_data + offset,
-				      mb->un.varDmp.word_cnt);
-		offset += mb->un.varDmp.word_cnt;
-	} while (mb->un.varDmp.word_cnt && offset < DMP_VPD_SIZE);
+				      lpfc_vpd_data  + offset, i);
+		offset += i;
+	} while (offset < DMP_VPD_SIZE);
+
 	lpfc_parse_vpd(phba, lpfc_vpd_data, offset);
 
 	kfree(lpfc_vpd_data);
diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 3c61a6d72a1a..c598bef5cad4 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -19347,7 +19347,7 @@ lpfc_sli_get_config_region23(struct lpfc_hba *phba, char *rgn23_data)
 	LPFC_MBOXQ_t *pmb = NULL;
 	MAILBOX_t *mb;
 	uint32_t offset = 0;
-	int rc;
+	int i, rc;
 
 	if (!rgn23_data)
 		return 0;
@@ -19377,14 +19377,14 @@ lpfc_sli_get_config_region23(struct lpfc_hba *phba, char *rgn23_data)
 		 */
 		if (mb->un.varDmp.word_cnt == 0)
 			break;
-		if (mb->un.varDmp.word_cnt > DMP_RGN23_SIZE - offset)
-			mb->un.varDmp.word_cnt = DMP_RGN23_SIZE - offset;
 
+		i =  mb->un.varDmp.word_cnt * sizeof(uint32_t);
+		if (offset + i >  DMP_RGN23_SIZE)
+			i =  DMP_RGN23_SIZE - offset;
 		lpfc_sli_pcimem_bcopy(((uint8_t *)mb) + DMP_RSP_OFFSET,
-				       rgn23_data + offset,
-				       mb->un.varDmp.word_cnt);
-		offset += mb->un.varDmp.word_cnt;
-	} while (mb->un.varDmp.word_cnt && offset < DMP_RGN23_SIZE);
+				      rgn23_data  + offset, i);
+		offset += i;
+	} while (offset < DMP_RGN23_SIZE);
 
 	mempool_free(pmb, phba->mbox_mem_pool);
 	return offset;
-- 
2.25.0

