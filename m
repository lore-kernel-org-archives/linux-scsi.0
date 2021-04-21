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
	by smtp.lore.kernel.org (Postfix) with ESMTP id EB68DC433ED
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:45:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BBD41613DC
	for <linux-scsi@archiver.kernel.org>; Wed, 21 Apr 2021 23:45:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243880AbhDUXpv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 21 Apr 2021 19:45:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237429AbhDUXpu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Apr 2021 19:45:50 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DAB6C06174A
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:45:15 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id y62so6578916pfg.4
        for <linux-scsi@vger.kernel.org>; Wed, 21 Apr 2021 16:45:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1CZgnScmKH+RViEX9RX8GQYmbcXFPCJDMmkicsZUZs=;
        b=CpyFn0ig5llmzULpmiw04tf6HUkdd4Isc21e7FSK/QG/NcU0nhZhvgR52fkwvwCEXG
         FriWTwh3oUqZGtQi097VowJjnwF9gops78hbcg0L0NlB1fOrIXDGl7lXixsAg69stARX
         1PRzjVBR6y+EGUvgavD2jm5thC/opZHS1+ax6W1PZcSt3h9o7Oc6Zqf6BdEA+qlWaENT
         aaU8LoDklxx+dxCJic8kg8EnfJitwnxCyW4td3CCEDjW4M7krXrRMMShdg8/8gAdkR00
         oMGxxC3rWPFJJUH0MYNLOqs4f9BXP0GD01J17QcXUw04z5io0n224aoQtVMRwfntaHNk
         NYYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=i1CZgnScmKH+RViEX9RX8GQYmbcXFPCJDMmkicsZUZs=;
        b=rVE/9ga1MVm8mjTeDx/xYfI8UAvtvaToxDYGTwi0bfbB8Scuv5tdVJywRRsMEI+vpu
         c7lv5LDcubeYAc0DoytjnNAxSzfUPmc216g0KQ3lUjp/rwgRww/z7ihBGMQlBFv70sGI
         FM3QXW/1CNG5Gb9DRxBId6p47KR+yF9+Qn/k9gSi0hNd12Hjl0g97BhhT2ZToVE9UbHz
         CfcX380p5xXz5EqpWwyWVgb5LXnIjVjsd6N+5+fkHqFx5+t9AhbP6otNjltDrWUh/eRZ
         zusOBk1PPZrPUunyyrR8gwc/U9aKrOQg7z/tyUwr/u2/pG8bBlWv8ub8jrru69KG1mH7
         RBQA==
X-Gm-Message-State: AOAM533YEu6lakAYQsier94qX7dxEObOFHVNfdxHGr6sh+d4Ao0b20Mi
        IeB6h1m18tsciEFFWyuMmB7G8y7Y8iM=
X-Google-Smtp-Source: ABdhPJxDYdkSeeuGAAJnTpTheR5UR0ErclZ9q9FWLg8qkiLNTFOk1JISkwJP8WQvABfbi1001T+M+A==
X-Received: by 2002:aa7:800a:0:b029:250:c8c5:64b3 with SMTP id j10-20020aa7800a0000b0290250c8c564b3mr427864pfi.23.1619048714998;
        Wed, 21 Apr 2021 16:45:14 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c11sm379687pgk.83.2021.04.21.16.45.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Apr 2021 16:45:14 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH][REPOST] lpfc: Fix bad memory access during VPD DUMP mailbox command
Date:   Wed, 21 Apr 2021 16:45:11 -0700
Message-Id: <20210421234511.102206-1-jsmart2021@gmail.com>
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

