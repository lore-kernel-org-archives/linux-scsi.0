Return-Path: <SRS0=d7EE=5G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3483FC43333
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EE0522076F
	for <linux-scsi@archiver.kernel.org>; Sat, 21 Mar 2020 00:42:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rbNQphdT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727855AbgCUAmQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Mar 2020 20:42:16 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:46140 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbgCUAmO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Mar 2020 20:42:14 -0400
Received: by mail-wr1-f68.google.com with SMTP id j17so6166712wru.13;
        Fri, 20 Mar 2020 17:42:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8kENzX2qY4mZrQ14zzMWI8e74GFu+6EPUczTM1fAv88=;
        b=rbNQphdThKy7HQ69Js3pr52IfpuUD46jq8qMAdEy74tzazzyCfwXVuCmOo8PEaA8fx
         3C8nAHZHqk+HpJgHD/9MA736EWot8VxbiBpCzdYCDn8HI1cbSKSMoKT+RrmJkQrNQWW8
         97QHEe+fahFnOqANtA0FuFJbtub+Bs2SodWLuexgYPOGJZaxl4vys5qVCUpcwEA8naew
         7ZIug5iZT0pZK2WwMkz3wcGg95BXZlz10XbzpiqpWNSLkOW+freQPum228Lhs4jaCS3v
         4dVpObH8aaHB1ccYPiBmYxhyz4gZRuRIktl3rA8RDIBpBHW6xmh1g3n2lRzW5JxNBoEY
         SoVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8kENzX2qY4mZrQ14zzMWI8e74GFu+6EPUczTM1fAv88=;
        b=iIVhZLR/ULLT2lQakOdWEnBJQfsFA/0Qd8Yg++gOt+2wdZ5g8kfd4mjiNBIh9VxqeK
         P7Hgeh6frN6pgOEKHMJIjEmAwU+J2ph67eJM+CtABHZSPEE1sAT4caAwpFEN/aL2eznM
         mNEtqrkRZWlGHTh4QDyLtqL8+AajtAoxG+U6gNXBtTp632qxD75AEAH1YFanCGwGVyWL
         oDUVGBaDmicp00GdLoXx7azs2kKxRYis6LcOT2OAVf64s3Tfl7Ifxi1j1jX5wRAq5CUM
         eqBvaD5x+rUK4ZZsRN1xKws49eMF+o85zlRgWQ7qAFbAt86PNAY8LtTRio8TlmqNEPB+
         DnwQ==
X-Gm-Message-State: ANhLgQ1DhknJma+QtIXmn8SGsi9A4UJ62Iax8AxevkbKgD4QUaME8PpL
        TFmOHN4qs7qrIAN5WkWrBbK8XuHI
X-Google-Smtp-Source: ADFU+vtMQDLJAsxI5Q9cENeC2RS3km7cK8I77idkbKRhoJbtAIzLro2jF52kdzpgKDWcsjciYJaLzw==
X-Received: by 2002:adf:ee42:: with SMTP id w2mr6848641wro.168.1584751332307;
        Fri, 20 Mar 2020 17:42:12 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id j6sm8194982wrb.4.2020.03.20.17.42.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 17:42:11 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        ymhungry.lee@samsung.com, j-young.choi@samsung.com
Subject: [PATCH v1 4/5] scsi: ufs: add unit and geometry parameters for HPB
Date:   Sat, 21 Mar 2020 01:41:55 +0100
Message-Id: <20200321004156.23364-5-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200321004156.23364-1-beanhuo@micron.com>
References: <20200321004156.23364-1-beanhuo@micron.com>
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
index 1a0053133a04..1617d000a60e 100644
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
@@ -308,6 +311,10 @@ enum geometry_desc_param {
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

