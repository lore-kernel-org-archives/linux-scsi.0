Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849B5C83013
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3C1A62074A
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Nov 2020 18:13:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GsRBcFPe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgK3SMo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Nov 2020 13:12:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729577AbgK3SMn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2020 13:12:43 -0500
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA4CC0613D6;
        Mon, 30 Nov 2020 10:12:02 -0800 (PST)
Received: by mail-ed1-x544.google.com with SMTP id q3so17387898edr.12;
        Mon, 30 Nov 2020 10:12:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Iw8DkWBxJegPtxATK4GsVrbWJUY/AvcV6VruC/RlL4=;
        b=GsRBcFPeMBOBd+Bo0ns3MMhOx1dJqEv6x8WawjD9JiSExz3gec6wDEMt9qu75VtwUk
         W53s9hz2XjBX54D1oLgEf45RwUweHoizi61f33AqGaPFeivkHEJUUE25JjS943HxFkhw
         JTyO/SNjjzJlBBf/LwJIY0Ps/TLzvx7sWVuMxVfsQ/uP4c4U/aIhfSy2LTY0zOU5JF1w
         fbWWWUULx+EAOKKDII7/7QP0oc9/x/VV/dvGCxwAjMj7ysTgAlyZYnPU4OFwXIewjNEf
         T14jdaheWlTYhDdAITB5+iQXFNnmDnEWdpm+HV5FLjheoa6THf7l4TxQLkXlUj/o2Hr8
         VphA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Iw8DkWBxJegPtxATK4GsVrbWJUY/AvcV6VruC/RlL4=;
        b=QnKh+a7E2WpExC4ScUPIaJnZqZutqCeZX4d9iuUF6CgsHKafpdMu86iYx84xSyYwZe
         xpefeI8EMVPDE+TrE7zNUwC8qKPPui2fVJo5sdUDKYRuQbnAR3U8/BxLlsYO/pZeaSBl
         tHN5BkB66HB17aPEn7/xMAwn9pVbm7rlC/HzHVR95hvElYJJy+BkKTLkvL4nWqfcgwDm
         SoVPmChys+/zg7a56alF1Yc9BmbFG6n5c/Bk35w5wOf/crnqpP9l9X8Zc+tCj8I+bifT
         ExfG1mueYApnZIDFinGc5YonaYNG2IhcDJ2h9ZqTfpoemu7FUmihLC3GeROCd+eaxItZ
         AggA==
X-Gm-Message-State: AOAM531yiR2C+GLLaLUzD66Ts29kk3Tcl4KTGy9FesYGI6m8TFxnKsv/
        b+JyoSFpgopJXDfCdwPi4Ro=
X-Google-Smtp-Source: ABdhPJwOcICqd1ZjJJ2iyiPgq8Dxx1GlwcuyeaBQu4FQ5qY97ZclQ37HQYisKx2k3yabu+YbZ1hoHw==
X-Received: by 2002:a50:9e05:: with SMTP id z5mr23148757ede.231.1606759921510;
        Mon, 30 Nov 2020 10:12:01 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id d14sm2702899edn.31.2020.11.30.10.12.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 10:12:00 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] scsi: ufs: Changes comment in the function ufshcd_wb_probe()
Date:   Mon, 30 Nov 2020 19:11:43 +0100
Message-Id: <20201130181143.5739-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201130181143.5739-1-huobean@gmail.com>
References: <20201130181143.5739-1-huobean@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

USFHCD supports WriteBooster "LU dedicated buffer” mode and
“shared buffer” mode both, so changes the comment in the
function ufshcd_wb_probe().

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index eb7a2534b072..2091775ed3e2 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -7166,10 +7166,9 @@ static void ufshcd_wb_probe(struct ufs_hba *hba, u8 *desc_buf)
 		goto wb_disabled;
 
 	/*
-	 * WB may be supported but not configured while provisioning.
-	 * The spec says, in dedicated wb buffer mode,
-	 * a max of 1 lun would have wb buffer configured.
-	 * Now only shared buffer mode is supported.
+	 * WB may be supported but not configured while provisioning. The spec
+	 * says, in dedicated wb buffer mode, a max of 1 lun would have wb
+	 * buffer configured.
 	 */
 	dev_info->b_wb_buffer_type =
 		desc_buf[DEVICE_DESC_PARAM_WB_TYPE];
-- 
2.17.1

