Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80E9EC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 09:26:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5C3F464F6D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 09:26:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229519AbhCSJ0F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 05:26:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbhCSJZc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 05:25:32 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FE80C06174A;
        Fri, 19 Mar 2021 02:25:32 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id c4so2150371qkg.3;
        Fri, 19 Mar 2021 02:25:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FRCh2wX8tgMUCklcnZV+Qo3HupS3FlJjITrZLEDGD4g=;
        b=q1nJjhnRV5OcbsC6B50JNzLkKnOZ/oVBGivWeTPwJJ5GqDoRwdF2z3g8Wilo811rL9
         oBth0jmpWFdNtvphQ7HWLB0F5yz40y/R74tDysE/9+0EFRDzbTZVHjkhzPlDGfJcLy29
         SwrG/zsckK7yrJzq7gZiodZEaPY6h8rDIcWMZOr8R1uKUnS6UQnE1VF8+MlgHrapEPP+
         kfPkt1eSbv/FjoAWk+1dH7I9YclYxde3A43i3uMfmDQQIb7mF++fAsXAeC35DEpeCMjB
         9GbZ5q7JvDEtodMYnpRkDD4ZKIi4xl0RErxBAjG5uZUJisM454L7vQ0TRm1dYAEQObWq
         UrwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=FRCh2wX8tgMUCklcnZV+Qo3HupS3FlJjITrZLEDGD4g=;
        b=cGoWfWvSvYsMq7FBWeT7oHDBFupbqyPwpCB5UFf7PYGORpsKPc0WMI5EZ9J5OPo+Sn
         NW2F3ItkCdi1Rai1iqeYKGuPAo25hFW95pkug9d0YoWBR0GnCN9xMOboDdP0SSKNTZ9U
         N3XjY1c1YrZXVmFMCCwFM2uetgFQ74BRNbYDY/4slNwmsnhm2SiBx8rwcqo7xa94QFum
         sJX46WLhP2UlhmGyFsY+o51ADX41noQTLGpW8f+fGN8JmNld8v+u9XdUP036CTbuSy7T
         5D3+MV1vlXT6cEcpbXZcqfoV43bwmmG7w6H0I4xO9ssoupVibYVQIdexWUygPozW3LmE
         slRA==
X-Gm-Message-State: AOAM530FY/4xXpuaVE2g+4bS9GzE/RCGYKE+O5U4tNBd2N7iIcUhczUs
        TJqWFzHyejfhwQ5oUy0DMEkEkNbtcNYMD/qM
X-Google-Smtp-Source: ABdhPJwA+QL6CEKzMcSjMX02ysy42INTYOMwQEteAeSMuRLORWfY/QCg3BHwJb/HSO3yMcxFYyxhSg==
X-Received: by 2002:a37:bc43:: with SMTP id m64mr1397070qkf.186.1616145931321;
        Fri, 19 Mar 2021 02:25:31 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.87])
        by smtp.gmail.com with ESMTPSA id r2sm3318539qti.4.2021.03.19.02.25.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 02:25:30 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        unixbhaskar@gmail.com, lee.jones@linaro.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] scsi: csiostor: Fix a typo
Date:   Fri, 19 Mar 2021 14:53:11 +0530
Message-Id: <20210319092311.31776-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


s/boudaries/boundaries/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/scsi/csiostor/csio_hw_t5.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/csiostor/csio_hw_t5.c b/drivers/scsi/csiostor/csio_hw_t5.c
index 1df8891d3725..86fded97d799 100644
--- a/drivers/scsi/csiostor/csio_hw_t5.c
+++ b/drivers/scsi/csiostor/csio_hw_t5.c
@@ -244,7 +244,7 @@ csio_t5_edc_read(struct csio_hw *hw, int idx, uint32_t addr, __be32 *data,
  *
  * Reads/writes an [almost] arbitrary memory region in the firmware: the
  * firmware memory address, length and host buffer must be aligned on
- * 32-bit boudaries.  The memory is transferred as a raw byte sequence
+ * 32-bit boundaries.  The memory is transferred as a raw byte sequence
  * from/to the firmware's memory.  If this memory contains data
  * structures which contain multi-byte integers, it's the callers
  * responsibility to perform appropriate byte order conversions.
--
2.26.2

