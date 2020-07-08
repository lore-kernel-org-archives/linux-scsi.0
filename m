Return-Path: <SRS0=1cZD=AT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C984C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0618020739
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jul 2020 12:04:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wYVP4yTr"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728933AbgGHMEB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jul 2020 08:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729122AbgGHMCu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jul 2020 08:02:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A227AC08E6DC
        for <linux-scsi@vger.kernel.org>; Wed,  8 Jul 2020 05:02:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so48633707wrw.12
        for <linux-scsi@vger.kernel.org>; Wed, 08 Jul 2020 05:02:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZwSMA5UIb7oM9+D5j+l12KsCqeP4op1hhjOFtyL2ps=;
        b=wYVP4yTrdIb3gPXKLBwSIe8aCHTr6bqSOLL6eZHfT2SvX4q7eX66ukJezKlb3lJqzz
         CMDoawaoFMDHzHmDGUCKQ6z7g/1iBWboIw+C6XhatxXuamWkI+POzEoQS8TVmKkIoHjn
         lDqKVIY9a1/orsCpupEsEuTM39RugV8ru6SmhANSET57A7VpxrvkQJ+SE2M2lcl2jD0b
         n2EXTHaIJfjG7vIhxcWdJTpZqeBDEtlI96662m8C4+2T7wWh/+pZOhrRQB1snq6rGvuy
         ldFuM1a634U11GCgiL8GLL8ONxQ1GezKf3CdyRcJet9PeWu1yxrI1x04pzhr6hv//mrS
         SmrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZwSMA5UIb7oM9+D5j+l12KsCqeP4op1hhjOFtyL2ps=;
        b=i56wROMmpppp9KqXicCHXXSHR0DyMEVvFSreLC8QnQCjEHTWdTa2uAsH4WVjAgLsGg
         CA//nCS/S1aQr/3KDRf2gEBYioz4pSCy+Cdk5MAJGcHPzP7HAUc77BJkTl9Nb09JhMdw
         vqa537BLAeIPSCmgpr0ME2NSXZRC2PNlFugM+N7suaB41BJtsmtLO/iE0QODAJMiwa4x
         XBC8DMH5F/dcmwhOyJALajtCX7ddzubJWAjkzBkM2J/ba+Thov0VNSC3UzyKdG92turT
         nydf54i/D45fBX3nnSzXXGAo4dkU/5oC9Ov21JCIrAYBIfTAU05zZjpadrwK6Ihbvool
         lp/w==
X-Gm-Message-State: AOAM5331ENgS9eybv+hYwxwccJ0dhHA8apsoPHup8i/d5bNI2vwuMhBb
        sx1sncPzfwo91woErbQO17pkow==
X-Google-Smtp-Source: ABdhPJzUhN5+/7ZGY9cHq+7oMDlNaKPxbiI8XirtTADjCEmOj88jT3VDHFhh0FBXmjOTu9U+a4GNVg==
X-Received: by 2002:a5d:6412:: with SMTP id z18mr56966206wru.310.1594209767822;
        Wed, 08 Jul 2020 05:02:47 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id m62sm3964997wmm.42.2020.07.08.05.02.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Jul 2020 05:02:47 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, support@areca.com.tw
Subject: [PATCH 16/30] scsi: arcmsr: arcmsr_hba: Make room for the trailing NULL, even if it is over-written
Date:   Wed,  8 Jul 2020 13:02:07 +0100
Message-Id: <20200708120221.3386672-17-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200708120221.3386672-1-lee.jones@linaro.org>
References: <20200708120221.3386672-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Ensure we do not copy the final one (which is not overwitten).

Fixes the following W=1 kernel build warning(s):

 In file included from include/linux/bitmap.h:9,
 from include/linux/nodemask.h:95,
 from include/linux/mmzone.h:17,
 from include/linux/gfp.h:6,
 from include/linux/umh.h:4,
 from include/linux/kmod.h:9,
 from include/linux/module.h:16,
 from drivers/scsi/arcmsr/arcmsr_hba.c:47:
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3055:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 4 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3053:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 16 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~
 In function ‘strncpy’,
 inlined from ‘arcmsr_handle_virtual_command’ at drivers/scsi/arcmsr/arcmsr_hba.c:3051:3:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output truncated before terminating nul copying 8 bytes from a string of the same length [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~

Cc: support@areca.com.tw
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/arcmsr/arcmsr_hba.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
index 1c252934409c7..5feed135eb26c 100644
--- a/drivers/scsi/arcmsr/arcmsr_hba.c
+++ b/drivers/scsi/arcmsr/arcmsr_hba.c
@@ -3031,7 +3031,7 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 {
 	switch (cmd->cmnd[0]) {
 	case INQUIRY: {
-		unsigned char inqdata[36];
+		unsigned char inqdata[37];
 		char *buffer;
 		struct scatterlist *sg;
 
@@ -3048,16 +3048,16 @@ static void arcmsr_handle_virtual_command(struct AdapterControlBlock *acb,
 		/* ISO, ECMA, & ANSI versions */
 		inqdata[4] = 31;
 		/* length of additional data */
-		strncpy(&inqdata[8], "Areca   ", 8);
+		strncpy(&inqdata[8], "Areca   ", 9);
 		/* Vendor Identification */
-		strncpy(&inqdata[16], "RAID controller ", 16);
+		strncpy(&inqdata[16], "RAID controller ", 17);
 		/* Product Identification */
-		strncpy(&inqdata[32], "R001", 4); /* Product Revision */
+		strncpy(&inqdata[32], "R001", 5); /* Product Revision */
 
 		sg = scsi_sglist(cmd);
 		buffer = kmap_atomic(sg_page(sg)) + sg->offset;
 
-		memcpy(buffer, inqdata, sizeof(inqdata));
+		memcpy(buffer, inqdata, sizeof(inqdata) - 1);
 		sg = scsi_sglist(cmd);
 		kunmap_atomic(buffer - sg->offset);
 
-- 
2.25.1

