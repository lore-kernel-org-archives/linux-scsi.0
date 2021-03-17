Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A276AC43603
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7883B64D5D
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 09:14:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbhCQJNk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 05:13:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229996AbhCQJM5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 05:12:57 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD4B6C0613D8
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:56 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id 61so991444wrm.12
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 02:12:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=CwQndVf+ajRvG7BvBjO6FK3EJF72tSCBcXH+xkZnA9A=;
        b=cAXpZfWbnwYLQJVEJPJuJoAGyyDL3+O2ZQp0SB0cXTfefaBs9II3OuXE5qb9u4u8A0
         drgxbimN1BySjwmM659Xhu+412YUtXOG5TYow2HC9+UKJttZw7bomixtpiO5svjxx14E
         7PzHl8RFlF1sHLB3rMiPLdpni4UoEGXwXeXBPdH/21QHhus1ulL9/VN4swFOA2+vo7O7
         hgpRqnuJWEjhOLve2tO8x6GGvBrmIoC6WcZ6zK7jYcFtGEZWZJrXzbQl4FmmjEjfxs6l
         waPhgQ38yYJ8KyF4IMEArZfPKRC+tb0kmDt+YhdBXkZcCOtI7kTsfjv9IFQrh9fORuZ5
         PhuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=CwQndVf+ajRvG7BvBjO6FK3EJF72tSCBcXH+xkZnA9A=;
        b=MfM1Ej4HVnj57eMVpM/eaAzYl0uFlupaDHY3odhAGK2VdiczdbTgLMdSekCq/lFOR+
         a5S3oqsxvq7rqFQG7T6UGqaF2NlXmjTsrpQ5Hd3bO07RgYWyZds6zTgqffu2rhh728m2
         TkLvM0o4ww3E/3RHB6ttB4o1QRUtbPFPCbR57cgevmCVTrYfRKuqyPe0VjoXZ4g9SH77
         OD65XZvyG/TeqCbeF0aA85EQmnAl1L2jlynmfH7uRY5S5FeDOMF7XaigdqJuYRnwGDls
         jqi0k/N/7QYFaks1wRp7ZNWj30asmb4cxKIwgDLAcOunPzVLjsyJ1foh5K4C6Jcdb7IM
         eFLw==
X-Gm-Message-State: AOAM533h56d3NbGqhX1dNREyTVL57HcVkOPgq2cNgOcWjl+oWNnIndo0
        gQoYbW7LtE9NH79slc7n+RbMAA==
X-Google-Smtp-Source: ABdhPJw0wNwtzWgZ2Lv4V+1/bBqKcq0BDja0ZIePOUdVVGVe+N152oGckEzVMK/3pw4K918+K+1yCA==
X-Received: by 2002:adf:fecc:: with SMTP id q12mr3245072wrs.317.1615972375699;
        Wed, 17 Mar 2021 02:12:55 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id e18sm12695886wru.73.2021.03.17.02.12.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 02:12:55 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-drivers@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 15/36] scsi: be2iscsi: be_main: Demote incomplete/non-conformant kernel-doc header
Date:   Wed, 17 Mar 2021 09:12:09 +0000
Message-Id: <20210317091230.2912389-16-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210317091230.2912389-1-lee.jones@linaro.org>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_main.c:4937: warning: Function parameter or member 'data' not described in 'beiscsi_show_boot_tgt_info'
 drivers/scsi/be2iscsi/be_main.c:4937: warning: Function parameter or member 'type' not described in 'beiscsi_show_boot_tgt_info'
 drivers/scsi/be2iscsi/be_main.c:4937: warning: Function parameter or member 'buf' not described in 'beiscsi_show_boot_tgt_info'

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-drivers@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be_main.c
index eac67878b2b1b..22cf7f4b8d8c8 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -4927,7 +4927,7 @@ void beiscsi_start_boot_work(struct beiscsi_hba *phba, unsigned int s_handle)
 }
 
 #define BEISCSI_SYSFS_ISCSI_BOOT_FLAGS	3
-/**
+/*
  * beiscsi_show_boot_tgt_info()
  * Boot flag info for iscsi-utilities
  * Bit 0 Block valid flag
-- 
2.27.0

