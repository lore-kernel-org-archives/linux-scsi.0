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
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6700C433ED
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 08:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B463361184
	for <linux-scsi@archiver.kernel.org>; Mon, 17 May 2021 08:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235614AbhEQI0E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 May 2021 04:26:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbhEQI0D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 May 2021 04:26:03 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EF63C061573
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 01:24:46 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id m124so4112135pgm.13
        for <linux-scsi@vger.kernel.org>; Mon, 17 May 2021 01:24:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SaM9n3J86BM05nGJQj36RgfUxU1DAUoct0gjqp9HMDA=;
        b=NdupwJNTgspaxM9+hee9zJKkbxslwpIKFTmd71JdJJqh3+JO+DnJVyfZ71fFaUzIl4
         TF7vS1hiN5N7UTZen7TgwF7Wqn1zhdF/KTohbFZTDFwYtBQm5B1eI9R/Tlw/SKWJivNJ
         MTNbzMswteRz03Ca2CPi9UOpYWOmx53tRUO2MRxW4iktKrzNrbY7wFz/20+loyRzXYb/
         emvIyVnSUiygpZ36NuJDMhQkNU0HooSaJkDy0dV6SlmX24kzqLg9Q6/cG3lZEpVxvabM
         qwX8vnV9OP10Jnn+T+FzWPDvfWq6pDWR/Vs3parbN22AEG0U/bZ8oCMLC7/cDJC4O/9Q
         UxzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SaM9n3J86BM05nGJQj36RgfUxU1DAUoct0gjqp9HMDA=;
        b=EimGCa3rQURbIJvX8pSHPZNwKwFuGfTrjfxL13vYCg3eC8DZ+w8LXhjRfvncdD8zut
         7hu+XQgtZ4eebSqLBmXDBIN+utiXvHk0LLmEds8ZLvvieL23ed5vmlXyMj/69+n2KX6T
         dTh4o/5GfKGe0umtiHljgI53uyceLzEZntPV3uImV9/QAHreqBl416eAC1zpMXekp8Dj
         SJhWU8svr+Sku2M8vA95M1r7p26GkDU7QFM1M7xqDLSqTRLgrZgENqgVLJ6MJZoGyZd+
         e+XJfNiDEP0ZS6Q92ikBUT3IUUo3NCtddtcZ1qOhsPMJ19eS0Pvkl4rJQ0jA7/Dro1un
         UrHQ==
X-Gm-Message-State: AOAM530nrCV473gpSxBRd3YAgFDx9p+G3fbks23G0dMo1K0wO4xOwPzY
        GG5FDW2TOgoS562tXcJdqF8=
X-Google-Smtp-Source: ABdhPJyiUYjQgBWTFTKZ9TH9LQY3B4ln+2t1vevFmOdc9sTlUboCmzMvhsmSXA29tY4uoXBq4CA0CQ==
X-Received: by 2002:a05:6a00:1a41:b029:2dd:823b:3dce with SMTP id h1-20020a056a001a41b02902dd823b3dcemr114356pfv.35.1621239885914;
        Mon, 17 May 2021 01:24:45 -0700 (PDT)
Received: from yguoaz-VirtualBox.hz.ali.com ([106.11.30.46])
        by smtp.googlemail.com with ESMTPSA id p17sm2782914pfw.202.2021.05.17.01.24.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 01:24:45 -0700 (PDT)
From:   Yiyuan GUO <yguoaz@gmail.com>
X-Google-Original-From: Yiyuan GUO <yguoaz@cse.ust.hk>
To:     shivasharan.srikanteshwara@broadcom.com
Cc:     linux-scsi@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
        sumit.saxena@broadcom.com, kashyap.desai@broadcom.com,
        yguoaz@gmail.com, Yiyuan GUO <yguoaz@cse.ust.hk>
Subject: [PATCH] scsi: megaraid: check the value of quad->diff before using it in division
Date:   Mon, 17 May 2021 16:24:36 +0800
Message-Id: <20210517082436.73551-1-yguoaz@cse.ust.hk>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function get_strip_from_row and mr_update_span_set uses the
variable quad->diff as a divisor withou checking (by passing it
to the function mega_mod64 and mega_div64_32 respectively). The
variable quad->diff may equal to zero, leading to potential divide
by zero problems. Similar checks on quad->diff are already enforced
in the function mr_spanset_get_span_block.

Signed-off-by: Yiyuan GUO <yguoaz@cse.ust.hk>
---
 drivers/scsi/megaraid/megaraid_sas_fp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/megaraid/megaraid_sas_fp.c b/drivers/scsi/megaraid/megaraid_sas_fp.c
index b6c08d620..0e242632e 100644
--- a/drivers/scsi/megaraid/megaraid_sas_fp.c
+++ b/drivers/scsi/megaraid/megaraid_sas_fp.c
@@ -562,6 +562,7 @@ static u64 get_strip_from_row(struct megasas_instance *instance,
 					spanBlock[span].block_span_info.quad[info];
 				if (le64_to_cpu(quad->logStart) <= row  &&
 					row <= le64_to_cpu(quad->logEnd)  &&
+					le32_to_cpu(quad->diff) &&
 					mega_mod64((row - le64_to_cpu(quad->logStart)),
 					le32_to_cpu(quad->diff)) == 0) {
 					strip = mega_div64_32
@@ -1242,6 +1243,8 @@ void mr_update_span_set(struct MR_DRV_RAID_MAP_ALL *map,
 					spanBlock[span].block_span_info.
 					quad[element];
 
+				if (!le32_to_cpu(quad->diff))
+					continue;
 				span_set->diff = le32_to_cpu(quad->diff);
 
 				for (count = 0, span_row_width = 0;
-- 
2.25.1

