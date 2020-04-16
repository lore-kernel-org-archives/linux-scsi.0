Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4C98C38A29
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99DE42222D
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 20:32:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="eEp9tlqv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgDPUcN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 16:32:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729865AbgDPUbw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 16:31:52 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C86C061A0F;
        Thu, 16 Apr 2020 13:31:51 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d17so38257wrg.11;
        Thu, 16 Apr 2020 13:31:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=eEp9tlqv0ORzIJg2YcgBOGYH9+8YOTfcZANW8nddrqLImUdvpNHJYYJg29O1ai9h80
         a9JXBl4DcMDqxpbO8IPxA8VE2Rof7qCfyzeO50TzWvOfkAS430pu3bu2O31svge59hk8
         rR2ed9Xa8cT5NgRDmzZFRYReW0sR4S/9W4j3oDvJpoQTWQ4vLkiubEH6VWmXGT4oTCp/
         g1jgpKa2VUMIth1Rc76Tmibm9xwvzAdjqAFq88g+Ln3FTHg2rZDFt68/yqC3K2tSSHEA
         mhv9XdkGlSxn7EVw/lYtJ3347ubA7YFOZq1G2uBuL/KPBqJkV6GmxST6YaIMPKdBudDF
         hSdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=rpnVsBnvafAlWV03sM0JVCBlOwPyiIhXAiUy+eBT1T6cgzRCuC33KMXChy3jR1GGaJ
         p/2EJXOqHjSiME2O8kypwux2MHZnHImMyzNty0jyZ6I7V1R4hrAU9S0Gzabw0Ek5oaS0
         j697ZMlF32cf/zGF4Yr8+s10cykMnrV4tdQ9wCOt3a0dFGOk+dOcTTRA87pVsH5XMi2y
         mFPHHEhw1jbjc4VtEXDx7NMoJp9FQIpzybZNQ+q0fh7hXSuWTHfHMb0ByulXKTHFzr0T
         CnREwLdFz9udLjuadAzgKkd2tuW70jmpgKqSJF+mLm/GC5fl7Ry3OsQ+q83xBgHPYvcA
         PrbA==
X-Gm-Message-State: AGi0PubXrn1iarXEQArvXyxEGsNaOZTTJoKkXq3a4gvwcOY5N9c9SNlR
        rjBuowPSJDjksgRCrR7LIEQ=
X-Google-Smtp-Source: APiQypLK0WleV13gkTNvEkwRRg0zB45F9rv1L3qN/MdiGoll8ow+kVTc6U4HHHOprDDXEdx1YqvV7A==
X-Received: by 2002:a5d:62cc:: with SMTP id o12mr8975wrv.75.1587069110620;
        Thu, 16 Apr 2020 13:31:50 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id s9sm17638864wrg.27.2020.04.16.13.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Apr 2020 13:31:50 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 4/5] scsi: ufs: add unit and geometry parameters for HPB
Date:   Thu, 16 Apr 2020 22:31:25 +0200
Message-Id: <20200416203126.1210-5-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200416203126.1210-1-beanhuo@micron.com>
References: <20200416203126.1210-1-beanhuo@micron.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Add HPB related parameters introduced in Unit Descriptor and
Geometry Descriptor.

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufs.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
index 1f2d4b4950b8..6210e489d2ce 100644
--- a/drivers/scsi/ufs/ufs.h
+++ b/drivers/scsi/ufs/ufs.h
@@ -219,6 +219,9 @@ enum unit_desc_param {
 	UNIT_DESC_PARAM_PHY_MEM_RSRC_CNT	= 0x18,
 	UNIT_DESC_PARAM_CTX_CAPABILITIES	= 0x20,
 	UNIT_DESC_PARAM_LARGE_UNIT_SIZE_M1	= 0x22,
+	UNIT_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS	= 0x23,
+	UNIT_DESC_PARAM_HPB_PIN_REGION_START_OFFSET	= 0x25,
+	UNIT_DESC_PARAM_HPB_NUM_PIN_REGIONS             = 0x27,
 };
 
 /* Device descriptor parameters offsets in bytes*/
@@ -304,6 +307,10 @@ enum geometry_desc_param {
 	GEOMETRY_DESC_PARAM_ENM4_MAX_NUM_UNITS	= 0x3E,
 	GEOMETRY_DESC_PARAM_ENM4_CAP_ADJ_FCTR	= 0x42,
 	GEOMETRY_DESC_PARAM_OPT_LOG_BLK_SIZE	= 0x44,
+	GEOMETRY_DESC_PARAM_HPB_REGION_SIZE	= 0x48,
+	GEOMETRY_DESC_PARAM_HPB_NUMBER_LU	= 0x49,
+	GEOMETRY_DESC_PARAM_HPB_SUBREGION_SIZE  = 0x4A,
+	GEOMETRY_DESC_PARAM_HPB_MAX_ACTIVE_REGIONS = 0x4B,
 };
 
 /* Health descriptor parameters offsets in bytes*/
-- 
2.17.1

