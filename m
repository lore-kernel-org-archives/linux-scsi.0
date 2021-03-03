Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55EE9C4361B
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 432106146D
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 00:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388057AbhCDAb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 19:31:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244419AbhCCOs0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 09:48:26 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B8CFC0613E2
        for <linux-scsi@vger.kernel.org>; Wed,  3 Mar 2021 06:46:44 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id u14so23984637wri.3
        for <linux-scsi@vger.kernel.org>; Wed, 03 Mar 2021 06:46:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QFi9T+E/g8V3YsAnSZJJVAc9TXJo52o0NpqktVEIKdw=;
        b=ZYh5jmZHnR3UgmUDrFZUwUXHTN8rG1lpAeCiLfkVk9wOllZP5B463CAeaE5CPiTXBU
         PaTq0vpL/WvMIVCrJYsTd+pzenjEU8khfmgTqOO/tIPAlUxH8evimfYnKpAV9rWLYmgn
         0Mx9jZPaVk6bqWHDW7FD8pU8UxX0Cg0M4ZyX60LoeCA4Ptpq6f+wV+BTqTmVBlFtWL1U
         5Sm+fPLpMJM74M5LwXxINJ0h7bfItbIlkq1FynPDAPq+GM8kZGez0JGWfYiWsOwiAos7
         LaV5E0NzoR5E8lrcq83Zaf9SKITfXrvj3c5+VL3jBoJOIeGTRCsLGuviwbiLhj9eVTy5
         6LvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QFi9T+E/g8V3YsAnSZJJVAc9TXJo52o0NpqktVEIKdw=;
        b=BFJriRR44DkGCosvptIB4LYdWyUGQVIAMEsGLheJZlFCukO8B4d0bR0VvF5coCfUEA
         n7SPwBUTQWhVkGKck10eLTCxwmrYMRVgtgWSlFXaTejgyh/cfipSxq6RywBPpUU1H7k7
         YbpJY2qOxyaFRa1h7Jgyd8HlXrVikdtsgchpkxf8yPcwRvRPp3HnFOLByu63aH3GH8lA
         s2GPIWrFyBPtbthm3uH5YnvhZR+p5MAFNxGc+EbLvA0yuVSGSFiPVqqU4gAORzhu5bGS
         6kdksPbUr2wDWOCmVO9c07URdLU130FLIdEk8fibl6gJqti7lxUHjzG5Qfuujapzourv
         SFGQ==
X-Gm-Message-State: AOAM531hVqj96DYDoiQ4fC4Z7wQ+0wo7fKOzNInuvrbvDfwAP5rttMCM
        +JuxFfAeXBRcx9vn3REBg09WsA==
X-Google-Smtp-Source: ABdhPJyFEYZyODmwSj8L4In3YWPgE8FpGflz9nPBfBP0ld8nT3CDiDCvShIovuKdMp8S9fyjSsQWKQ==
X-Received: by 2002:adf:d1ce:: with SMTP id b14mr27612863wrd.126.1614782803009;
        Wed, 03 Mar 2021 06:46:43 -0800 (PST)
Received: from dell.default ([91.110.221.155])
        by smtp.gmail.com with ESMTPSA id a14sm36567233wrg.84.2021.03.03.06.46.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Mar 2021 06:46:42 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Atul Mukker <Atul.Mukker@lsi.com>,
        Sreenivas Bagalkote <Sreenivas.Bagalkote@lsi.com>,
        Manoj Jose <Manoj.Jose@lsi.com>, megaraidlinux@lsi.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 04/30] scsi: megaraid: megaraid_mbox: Fix function name megaraid_queue_command_lck() in description
Date:   Wed,  3 Mar 2021 14:46:05 +0000
Message-Id: <20210303144631.3175331-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210303144631.3175331-1-lee.jones@linaro.org>
References: <20210303144631.3175331-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/megaraid/megaraid_mbox.c:1438: warning: expecting prototype for megaraid_queue_command(). Prototype was for megaraid_queue_command_lck() instead

Cc: Kashyap Desai <kashyap.desai@broadcom.com>
Cc: Sumit Saxena <sumit.saxena@broadcom.com>
Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Atul Mukker <Atul.Mukker@lsi.com>
Cc: Sreenivas Bagalkote <Sreenivas.Bagalkote@lsi.com>
Cc: Manoj Jose <Manoj.Jose@lsi.com>
Cc: megaraidlinux@lsi.com
Cc: megaraidlinux.pdl@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/megaraid/megaraid_mbox.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/megaraid/megaraid_mbox.c b/drivers/scsi/megaraid/megaraid_mbox.c
index d57e93872d7b5..b1a2d3536add6 100644
--- a/drivers/scsi/megaraid/megaraid_mbox.c
+++ b/drivers/scsi/megaraid/megaraid_mbox.c
@@ -1427,7 +1427,7 @@ mbox_post_cmd(adapter_t *adapter, scb_t *scb)
 
 
 /**
- * megaraid_queue_command - generic queue entry point for all LLDs
+ * megaraid_queue_command_lck - generic queue entry point for all LLDs
  * @scp		: pointer to the scsi command to be executed
  * @done	: callback routine to be called after the cmd has be completed
  *
-- 
2.27.0

