Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA65FC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C192920705
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="padA/V7z"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729020AbgEDOF4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729011AbgEDOFx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:05:53 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3BE71C061A0E;
        Mon,  4 May 2020 07:05:52 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id v4so107433wme.1;
        Mon, 04 May 2020 07:05:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=padA/V7zxCf6eQGuKFupaidAbzrpcPp0P3IAtvr/RKtdO74/xt9gjhfj+TonhP4XYy
         J2Eit2R/d7Mz2m9/ZlpT8d4vZAYwM/35xnbCQhdSIno6Q6prxqOtodwOUSGGA7Lcv/qc
         hnbmKUF9haaMz7X9UGJfD3NWKHzUd4iOxwOOXlAMKD3Z8814BsTITRYndH0rEC3XiUvZ
         7hmrBL2ZiTkwBj4nc5MvCbQoxWcYO55rplM+8QNC1KszyVanNsflyE8tZkUl2lOlezy7
         bnMqzTQlDHcmBaEn3E1DbDT1d/TbAIWATLk6YO152DjTthoFLDqdllkJIyFq8xch7H8S
         snlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=O7hXVS0OxyhBubpu82xCFsrNwUf9NRm7K9Vtqp64z31Sf7xtE3XkY6H5GubUTHueKN
         1sqQFjZOeFw8qKwgBnKI4CWBz+FTIG7WYPwiDOgsuX1KfoSfqnbpFob0rf5zhwGc6Q+s
         8+tFKPM1YO4NQCJnrxzzlJlpWcLH0I5njBF4Xesln3Ye5OeECFH2HFNkDBzsdP2bDDad
         glU4xa8rfnGis/3rYUFbb0yRSkErZGuY3ZQWaTgXk4wUZyosU/VzDPqskPJXwRkP/ObV
         opzfLNc3iYehe0GGRwWtyT4cHhCO2lk8cG6J2+ZD9P7uMVVs657e9v9OzfHeJoAf5Fbm
         aVKA==
X-Gm-Message-State: AGi0PuZyj7lV70ICWMqGQCQA+2TmDqM2CpxEwvf7Kag5x7ZYl75mGsNv
        Pbyod/SJIJBF6IONnf4PLXJjWemkb3c=
X-Google-Smtp-Source: APiQypIPkaq7V4RR9kg/1mTGaoHEa4q95OL23MlwLlzrym/XRov0RCMvN3TsNfEowSDlKAcEg8ELfw==
X-Received: by 2002:a1c:4d07:: with SMTP id o7mr15945780wmh.59.1588601151032;
        Mon, 04 May 2020 07:05:51 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id h137sm273832wme.0.2020.05.04.07.05.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:05:50 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [PATCH RFC v3 4/5] scsi: ufs: add unit and geometry parameters for HPB
Date:   Mon,  4 May 2020 16:05:30 +0200
Message-Id: <20200504140531.16260-5-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504140531.16260-1-beanhuo@micron.com>
References: <20200504140531.16260-1-beanhuo@micron.com>
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

