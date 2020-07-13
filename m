Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B68D8C433FB
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93E5020674
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WVs2+uF6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729247AbgGMHsX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbgGMHrF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:05 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C14EC061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id s10so14620458wrw.12
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=sZwSMA5UIb7oM9+D5j+l12KsCqeP4op1hhjOFtyL2ps=;
        b=WVs2+uF6EIGxSusGMZCNpP6EUsgaIKOXWGq+dOaevV6oaUpV5lUiIg9YswM1zqBUNW
         eOabfzNTnHYSzTXdtc6GDH+16lFI+k1myn4G1zaFxhmEBq8aVoAUQpUqyor3lyAU6ZFy
         Q0CtP8+oU+OAdFffEu/8V/JJqGFswWdTMgxTvNiVv/vW/rTRvDQCzrx9LsejztDI9MSX
         wmOdoit455RnLFjYMPpjuccL6aoi7/h8zEEaDqSFCnwNoVnHu9tlLFrlUqfZJZvuZGGZ
         vslI8fKjwbjtjXnApNZDLJgdu39rwxDGcBuDdYLsTaa2Q8Q4etMIMFRgBpMfj+jcxOa4
         AVug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sZwSMA5UIb7oM9+D5j+l12KsCqeP4op1hhjOFtyL2ps=;
        b=uWyZDtv1GJMlEBBOT/lNijMdu7FNilDZPXO6Q60vkzMt611OTZ8N8JqRRmHSnhSarg
         HhS6g+1484pkmOP/uP9LFkSfYvCsgcoIQc6QJshxYd4aoGwMCZvHXUd6Tg5do3e6LQD3
         bOS6dWmE06JpMxiVQV7l04O8oJqd+V6zmy/PAZAxlgQNrLvs9z078LqIoE/lzGBclS6O
         HecFFcfiVGC3oBc0hmo7AShgtNOWIFFvg4F3xyUUmuNC9zHwGtHR7hsZ+MJx7CC4RVDF
         V4SVg5jIDdAdeLbdzsZ6lnUZmMhXgixYjsWDDgCabSKDzjYVOx7W1bOJZtFSzwk4A7mn
         ZFDA==
X-Gm-Message-State: AOAM531h5aO2u9VNq5IU6huCa/kgoAlmvR0RSfM9JbataOpOAznxPZNZ
        pXWdvl1gzkFY0fUWWGk7daJGOCqod8Q=
X-Google-Smtp-Source: ABdhPJy+uxQHBO2J6qki0bYZWsWz/7igxa0pYfaoVnCCNQ6H8KfBH7/wDT7xu5Nd1xK7Pko3/gk5lQ==
X-Received: by 2002:adf:ed8c:: with SMTP id c12mr45033798wro.359.1594626423812;
        Mon, 13 Jul 2020 00:47:03 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:03 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>, support@areca.com.tw
Subject: [PATCH v2 15/29] scsi: arcmsr: arcmsr_hba: Make room for the trailing NULL, even if it is over-written
Date:   Mon, 13 Jul 2020 08:46:31 +0100
Message-Id: <20200713074645.126138-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
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

