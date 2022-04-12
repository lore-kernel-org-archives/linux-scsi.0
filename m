Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 748E9C433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Apr 2022 23:33:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230430AbiDLXgH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Apr 2022 19:36:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231356AbiDLXcx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Apr 2022 19:32:53 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0DB5AC6243
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id z6-20020a17090a398600b001cb9fca3210so102190pjb.1
        for <linux-scsi@vger.kernel.org>; Tue, 12 Apr 2022 15:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gcMweyFm+jYex6XnJ1/matsS9enCr7fz32a/KoDpvIs=;
        b=psf5uk+xaqVDeEvigAy3mpeCPqm8ZRrap5xsvRiVet+s8W5Uhd7a6NbJ3fdpVSFQnK
         7U/kIknER0RBe8H9oRNSrO7RCMoKVJI0okgrFs3e49uBMjTg/Vsym9X448a0VVABdiNR
         mfrse63sEeqP5LzinEfRH2/YYQ0FQ4Fz3ucdYi4Mjoelz7bUnzzmrs2R9FhXA315y/3l
         K4Qu2f9tUZ6Jj6Epjh3hs6cNJhfY2yrHOOBtRitD3yF6zWr1lnCJb6Q5+H4ALgGMQpSg
         p0Ynrc1LMYEncztWxszbjMHNXb/5qTcVY4CVzktY6jlqzmQRxT2hyQU8m0NJ3e6JV8kK
         1idA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gcMweyFm+jYex6XnJ1/matsS9enCr7fz32a/KoDpvIs=;
        b=SWg2OXIACgZA+oh4vO9BQ70xpI68XYoux/3P7il0Tdm2CXm1LtTSeSWz9LzPyhXNnB
         UZZOeTZokRmp619Cv1FkPxi33Vt9oHNOiKeQCRzRQGxpgr6GhNOadEYNo5A/IxSxjHBL
         IXfZatgGmZm4hRudDb5uub8j34yjXMbCChr8WPrQDTbIqL3iD7DBKgx/g6fkPAUU3SOR
         kxUEDOGCmXoA5gYftr/OQuBhVFZ96JX4TpwfiBuUbfUlSdtkYy04Uxzz0XotCWQkky1B
         kDhhT9eoNNRQsbxu/7Ph5FsBkyOryBd2I+R5Q+bYxCqZI3rO1at02x9uK8U9lPq+gmej
         kFAA==
X-Gm-Message-State: AOAM5314EjmK0HDYEXVJIm9757EqjHrMdNMr9gm7ZiZTWpR2m0Sq6sLg
        DW1N1y4x6KWtImU6wZlA+BNJ6Ga+ICM=
X-Google-Smtp-Source: ABdhPJz7NB7mgXTv3TeKNLPjDSFqefB3nBHMDotKXj+8p37GvnQqxRrwkinrHon1VSzi5tpkpd+kzQ==
X-Received: by 2002:a17:90a:9313:b0:1cd:4053:9cf3 with SMTP id p19-20020a17090a931300b001cd40539cf3mr3074631pjo.182.1649802027327;
        Tue, 12 Apr 2022 15:20:27 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id g15-20020a056a000b8f00b004fa9dbf27desm40429824pfj.55.2022.04.12.15.20.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 15:20:27 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 16/26] lpfc: Revise FDMI reporting of supported port speed for trunk groups
Date:   Tue, 12 Apr 2022 15:19:58 -0700
Message-Id: <20220412222008.126521-17-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20220412222008.126521-1-jsmart2021@gmail.com>
References: <20220412222008.126521-1-jsmart2021@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Trunk port FDMI supported port speed shows single port supported
speed rather than the trunked port speed.

Modify supported port speed logic calculation during registration.

Co-developed-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: Justin Tee <justin.tee@broadcom.com>
Signed-off-by: James Smart <jsmart2021@gmail.com>
---
 drivers/scsi/lpfc/lpfc_ct.c | 68 ++++++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 20 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
index 4334bd358c5a..5f2b2d8eacbf 100644
--- a/drivers/scsi/lpfc/lpfc_ct.c
+++ b/drivers/scsi/lpfc/lpfc_ct.c
@@ -2830,31 +2830,59 @@ lpfc_fdmi_port_attr_support_speed(struct lpfc_vport *vport,
 	struct lpfc_hba   *phba = vport->phba;
 	struct lpfc_fdmi_attr_entry *ae;
 	uint32_t size;
+	u32 tcfg;
+	u8 i, cnt;
 
 	ae = &ad->AttrValue;
 
 	ae->un.AttrInt = 0;
 	if (!(phba->hba_flag & HBA_FCOE_MODE)) {
-		if (phba->lmt & LMT_256Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_256GFC;
-		if (phba->lmt & LMT_128Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_128GFC;
-		if (phba->lmt & LMT_64Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_64GFC;
-		if (phba->lmt & LMT_32Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_32GFC;
-		if (phba->lmt & LMT_16Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_16GFC;
-		if (phba->lmt & LMT_10Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_10GFC;
-		if (phba->lmt & LMT_8Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_8GFC;
-		if (phba->lmt & LMT_4Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_4GFC;
-		if (phba->lmt & LMT_2Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_2GFC;
-		if (phba->lmt & LMT_1Gb)
-			ae->un.AttrInt |= HBA_PORTSPEED_1GFC;
+		cnt = 0;
+		if (phba->sli_rev == LPFC_SLI_REV4) {
+			tcfg = phba->sli4_hba.conf_trunk;
+			for (i = 0; i < 4; i++, tcfg >>= 1)
+				if (tcfg & 1)
+					cnt++;
+		}
+
+		if (cnt > 2) { /* 4 lane trunk group */
+			if (phba->lmt & LMT_64Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_256GFC;
+			if (phba->lmt & LMT_32Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_128GFC;
+			if (phba->lmt & LMT_16Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_64GFC;
+		} else if (cnt) { /* 2 lane trunk group */
+			if (phba->lmt & LMT_128Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_256GFC;
+			if (phba->lmt & LMT_64Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_128GFC;
+			if (phba->lmt & LMT_32Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_64GFC;
+			if (phba->lmt & LMT_16Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_32GFC;
+		} else {
+			if (phba->lmt & LMT_256Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_256GFC;
+			if (phba->lmt & LMT_128Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_128GFC;
+			if (phba->lmt & LMT_64Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_64GFC;
+			if (phba->lmt & LMT_32Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_32GFC;
+			if (phba->lmt & LMT_16Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_16GFC;
+			if (phba->lmt & LMT_10Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_10GFC;
+			if (phba->lmt & LMT_8Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_8GFC;
+			if (phba->lmt & LMT_4Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_4GFC;
+			if (phba->lmt & LMT_2Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_2GFC;
+			if (phba->lmt & LMT_1Gb)
+				ae->un.AttrInt |= HBA_PORTSPEED_1GFC;
+		}
 	} else {
 		/* FCoE links support only one speed */
 		switch (phba->fc_linkspeed) {
-- 
2.26.2

