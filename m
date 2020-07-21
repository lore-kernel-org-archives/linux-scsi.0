Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 044F7C433FB
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D361320792
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SEGxwNgS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730745AbgGUQml (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730703AbgGUQmk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:40 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD990C061794
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:39 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id f18so3545557wml.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GNx0HLKx8SNwi5NCKk3KgzSECetqXmKRuN1En1r1+so=;
        b=SEGxwNgS+ohPWrCnMOok63z4miMvvk9BALkOQD6nUPnCKwDIAL0tSQ2WB9phectVUC
         CUpsIcMZQUm2j+QIXsLcT7A6VkkkX5MWG02OcL7pVqK30gf2quvJAkxFXVHtIK/cbK6X
         /Bok12nkAqg21bEFbjZ6aXLLNXQkemfIfBQyhjL/nwn9MsDeZprwbmz9Cyh1ntafR+E+
         EMSPG06ow6zLVICMRHFeRN9LOKnTND3cT+DkIXoQUhumMmNQ6b/P9hMUCw8z5fY2ZCLy
         Y2KsGwI83xPLeVzLdNBMP6rFxPD8MMGS8DO9UyHe2Ls57tH5KbZRx5WzRU2tXISNXDLU
         hngg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GNx0HLKx8SNwi5NCKk3KgzSECetqXmKRuN1En1r1+so=;
        b=Ck2uM7vP5RqLYJSMGp3vz4nE36zb+Z23uwQDI5XahNh9EdIlyBM64hsmurSsaqxJRy
         GYX7DyiYzz1UCChS83tUk6dVtoO1h0t2CfrccEiUTWsobYEx98fNmjpErV4uyoZAHuuU
         58NCvO0ugkrMczvAf6rOeq36R7ojY6kz3DKVyGp1NR1sw5gUv+Q4W7VrPi6muBH5Yzp3
         ZbescaNZJxdBnKKYqgFbYVU50mCIdTAZBkW4st9LFV+cxAod8dziKUUj+EZRurnskLse
         SKDpvuy4uXtX38ZHGgDSap9ovrfunDJfnmdO/J63+Tr/YnmEoMWS9Qkw/S6L91PWwyTd
         nrCw==
X-Gm-Message-State: AOAM532rY081hJzQgxeBor8Tf3vTbDH8lSydPPaPMXuprQnEz+rI6rif
        SuvlKYNJW11Wn4C3tz5Ji8Nr7A==
X-Google-Smtp-Source: ABdhPJxkqvmxb9k9EDUl+XhDKXZeqvSH8vbe1NbQeXiyNhsQ6SYWAsuS6uS16leWhm1jQWtAiDHPyQ==
X-Received: by 2002:a1c:7209:: with SMTP id n9mr4884978wmc.150.1595349758608;
        Tue, 21 Jul 2020 09:42:38 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:38 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com
Subject: [PATCH 29/40] scsi: qla4xxx: ql4_init: Document qla4xxx_process_ddb()'s 'conn_err'
Date:   Tue, 21 Jul 2020 17:41:37 +0100
Message-Id: <20200721164148.2617584-30-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla4xxx/ql4_init.c:1170: warning: Function parameter or member 'conn_err' not described in 'qla4xxx_process_ddb_changed'

Cc: QLogic-Storage-Upstream@qlogic.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla4xxx/ql4_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/qla4xxx/ql4_init.c b/drivers/scsi/qla4xxx/ql4_init.c
index 4afd43610f68f..4a7ef971a387c 100644
--- a/drivers/scsi/qla4xxx/ql4_init.c
+++ b/drivers/scsi/qla4xxx/ql4_init.c
@@ -1161,6 +1161,7 @@ int qla4xxx_flash_ddb_change(struct scsi_qla_host *ha, uint32_t fw_ddb_index,
  * @ha: Pointer to host adapter structure.
  * @fw_ddb_index: Firmware's device database index
  * @state: Device state
+ * @conn_err: Unused
  *
  * This routine processes a Decive Database Changed AEN Event.
  **/
-- 
2.25.1

