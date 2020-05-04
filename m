Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6836CC47258
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 45B742075A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:21:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tPyV3hPp"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729134AbgEDOVM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:21:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729016AbgEDOUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:54 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB907C061A10;
        Mon,  4 May 2020 07:20:53 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id g13so21135978wrb.8;
        Mon, 04 May 2020 07:20:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=tPyV3hPp0PG8Fx23d8yS8xUZ5PDaRUR7FCwLRt/owPbofFDHZ53HQQgy70LsjVb1KU
         F1GaHAdwE5yzmePCxutAhrDTC64yAG4AZKQtQ7V/Ft2qMQznN538q07OYVzc6b0IE5Kv
         hbq/1KQuntYdm2GphNqIIbADnrEjsgL+SjeNrCYwTEWU3xc6nf97BWpxzJjxljtUYFEC
         5WFbZ40//GlowX/+nbBez7xj/L/MO2/+exoqpkE8/NZ2+EOqJz/jyhpiVHUXNHugt8H1
         Qfu3Bdnq6/xKII+54dyAsQmZ5tPp5exGEpWqXGN462I7cPpmcNS9G9cMcx5e2gXLhD8l
         s4Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NOGahbgFbrGavSQQTAIEOH3ZDeZsbOUYsFMx2n9Uex0=;
        b=T8rlRVaKqWX/eWe69g5T9Q7Nvc4VsZEk9+9Q+ksMPiIwhM1XKOYnu1M4M4VkjWRzEs
         w9DlE9w59xF+DZcR4RxogvJHbhb84pOImROzCDaW9AcwdiFjkvszi3bndJh1//DACCqR
         28v6xsujGnupe7xNSddw4SGpPseTNXjLxFnMhGcz4HIv+JnszZUGM5ixs4c4WhRZ+9sc
         BJlwwMGwiww1YkDGlwFsWgPt3bmjMlXl8CsyUKa21B1sBPrX9lf5YfZQvlc8YHKHwH2g
         /kd4M5ainKDT9U0sTvBydMMLHr+rrFDLfjZ3GqtzKHcJUdna+vppj/V6/qSPypo9bQ/b
         sUmA==
X-Gm-Message-State: AGi0PuZJOrqt+gtxf7WdZ1chdWS0RL3VcInThuxArJKCLrZUpXOGC6+E
        gYl3D4+PHBX7FJj63RjQiSs=
X-Google-Smtp-Source: APiQypLBt6FV37S7ZWmd6A1HD4lHdQi5M+Ugq8m8PY3uxaMCcu6Zddyr6PIHhqm5Z+jxzi/2SEYmXQ==
X-Received: by 2002:a5d:4704:: with SMTP id y4mr12099618wrq.96.1588602052521;
        Mon, 04 May 2020 07:20:52 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:52 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 4/5] scsi: ufs: add unit and geometry parameters for HPB
Date:   Mon,  4 May 2020 16:20:31 +0200
Message-Id: <20200504142032.16619-5-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504142032.16619-1-beanhuo@micron.com>
References: <20200504142032.16619-1-beanhuo@micron.com>
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

