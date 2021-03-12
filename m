Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B168FC2BA11
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BE2064FB9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbhCLJsw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233148AbhCLJsX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:23 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6455C061765
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:10 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id d139-20020a1c1d910000b029010b895cb6f2so14778986wmd.5
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2+AJW1JfC267V4VbkGwrESDS7kAwVhhZrAmnvaz3wpc=;
        b=O1HZG9pKPXhi2/2uiwV/azuDXxbonWJ0pNedzgmJEiFRhIQkSvNlPCUid4kweHF91z
         gIwDWMhccLBJn3mr9SNq22dYv5vjrLxtqCBbnGLnXzHjj0j/izHUjnbSUDaqtjkZip0u
         eKMZDX1Z+M81t7k5xu2FThyj7NIvdZCdn8GnFaVkac5N50OXJl34WlmHIUZwn0tElxUP
         HbU4Mle9vuxF+WHdnHO2zClocvyoCf1Pk08B0WDIKOVYiPjc1W/DurTXXurjCgUPpI0c
         LWBmdvyqQn00K10qB/WLDd+XY9yXUbZZ2p4Peqo1xJaKJG4IkY9Jvx8TlND1rZKFgGUr
         9EJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2+AJW1JfC267V4VbkGwrESDS7kAwVhhZrAmnvaz3wpc=;
        b=bPNXap/8CHFdwMCS8IMFYLi9E2Euyynik1nniY6rtQPQSwF5i27Q+rPr/vfRdjze/c
         CffoGlANujJ7AwL0vZd3LIzxNW9fFBiL6vT+CQFssDdI0MrrmNqFOXS1mj+ABapkZRTr
         UhugBrJ/4ZWjRtev6jb/Y1ttejEv2teVCSQPO9RxHldSczZ4WyRxmbn0Y9/KD8i3twrf
         ct0DyTaay5wPeIrU8VTTpfYNiN9qo/R/pcYwnpJ9t2ytlczVMtSE38c8Cuelq1BEcWz2
         soPGS4D8eKdiC5TD7ZZlkpCK1+9qdypJA2p7bUm6b/9+kLAElUK16EuGFfJMSSkjkW/S
         /gmg==
X-Gm-Message-State: AOAM533AQ8qmNuTrX2PeRWEqLXjYhj3RL3OKPl2cogM1NwQKzl8oSkgF
        KIdgTRjTFmO62qZE/olsfQ0Xxw==
X-Google-Smtp-Source: ABdhPJxpw/RCjE9owSu66rCtUR4c1th3a9fvVIAYqX1Lww4ZY4U3NHVX1Vlu4MN2AKV/g9QyFj9MUg==
X-Received: by 2002:a05:600c:2053:: with SMTP id p19mr12224316wmg.87.1615542489224;
        Fri, 12 Mar 2021 01:48:09 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:08 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-drivers@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 20/30] scsi: be2iscsi: be_main: Provide missing function name in header
Date:   Fri, 12 Mar 2021 09:47:28 +0000
Message-Id: <20210312094738.2207817-21-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_main.c:4934: warning: expecting prototype for Boot flag info for iscsi(). Prototype was for BEISCSI_SYSFS_ISCSI_BOOT_FLAGS() instead

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-drivers@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index 90fcddb76f46f..ab32ca535078d 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4927,6 +4927,7 @@ void beiscsi_start_boot_work(struct beiscsi_hba *phba, unsigned int s_handle)
 }
 
 /**
+ * beiscsi_show_boot_tgt_info()
  * Boot flag info for iscsi-utilities
  * Bit 0 Block valid flag
  * Bit 1 Firmware booting selected
-- 
2.27.0

