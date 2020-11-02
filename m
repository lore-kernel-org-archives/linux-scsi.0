Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81B0FC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:26:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 271EF2231B
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 10:26:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ltwTwnox"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728387AbgKBKZ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 05:25:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728005AbgKBKZ7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 05:25:59 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6479CC0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 02:25:59 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id x7so13935302wrl.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 02:25:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZYQcgr+JUloSfLnkLvWfee7pGDY8gdNHXe6cOnUHb6s=;
        b=ltwTwnoxJBMV83W52Xk1mxeiyhHXpROzlSsJV8F/Xv4iknM3OjN+8ZDEwFjyg1hZYP
         Awp1iF6GnLQ9HPn+NEe5GnljG3Lzi/uFIp5ZWUoijEBvfIdCZ4AySrOR78rsYGGYk8ag
         uh11Aw2YHc0lx/9W8m+VJ7biVY/Jm3uobvIX1u/KXrenL3WiQIy/2zOayOZSx4uhZ7UI
         VH2EDAdi0pn9gsy17Bt7M+cNtb3FYAJgc5KpPQgOH131xBtNu/lFpVMrWtt3B+iL97Y4
         9wRZ/gu1JiHJ5jSULfEO+lMxZUGHLBaQ0en4OtBvviEwPteZfdeJxuAEKWmcocwVNWMv
         Y3ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZYQcgr+JUloSfLnkLvWfee7pGDY8gdNHXe6cOnUHb6s=;
        b=JDKD6mUlho/KFKAwouu/GPsUA9XVzLtESulALMesfA3Upm9YjFOcHi+jZwQHV44fmQ
         XfeiG1U0nOjrCHR0bU+2iwQHrucfys/gG18+/7uWnXEuIyLZyNRVBh9njMlZPSBzUAD3
         /vR3xxBOYwkjlBNFkB6UymFg6LcnqFPYFFm1CDheFf3DRAW2TUWs+DvQoL+tkpaR8TEo
         GFiX72BSoJdeU/NuR/e9UiaElFEe8dDnpj0/ZTl+KrKUXDgZhIMt36eNYBL2QEN8yvlx
         hgkgXBOuLzngy7GFGyCm20uARh0YHGfib9VpmFh39AYp7efYaHbfYabn5a4gFbGa3oWX
         kHLQ==
X-Gm-Message-State: AOAM531yoQ3DXc36r1+dyacz7TsgZ7nGLiMNB3r1EJ78QFNkeqkjDHbt
        dMnUQRO7MIrA7Txb3OXvWBDCgA==
X-Google-Smtp-Source: ABdhPJyyqXM9lXCTlshysJusVXnuPANkqdMk75AUdCjGYpnMP7GIs/wllcZu2K+rk6reSQqAgZTGBw==
X-Received: by 2002:a5d:4747:: with SMTP id o7mr20063411wrs.423.1604312758178;
        Mon, 02 Nov 2020 02:25:58 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id o7sm21766730wrp.23.2020.11.02.02.25.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:25:57 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 2/3] scsi: pm8001: pm8001_sas: Fix strncpy() warning when space is not left for NUL
Date:   Mon,  2 Nov 2020 10:25:43 +0000
Message-Id: <20201102102544.1018706-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102102544.1018706-1-lee.jones@linaro.org>
References: <20201102102544.1018706-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This string is not NUL terminated.

Fixes the following W=1 kernel build warning(s):

 from drivers/scsi/pm8001/pm8001_sas.c:41:
 In function ‘strncpy’,
 inlined from ‘pm8001_issue_ssp_tmf’ at drivers/scsi/pm8001/pm8001_sas.c:919:2:
 include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ specified bound 8 equals destination size [-Wstringop-truncation]
 297 | #define __underlying_strncpy __builtin_strncpy
 | ^
 include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
 307 | return __underlying_strncpy(p, q, size);
 | ^~~~~~~~~~~~~~~~~~~~

Cc: Jack Wang <jinpu.wang@cloud.ionos.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/pm8001/pm8001_sas.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index 9889bab7d31c1..5edfba3c622b4 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -916,7 +916,7 @@ static int pm8001_issue_ssp_tmf(struct domain_device *dev,
 	if (!(dev->tproto & SAS_PROTOCOL_SSP))
 		return TMF_RESP_FUNC_ESUPP;
 
-	strncpy((u8 *)&ssp_task.LUN, lun, 8);
+	memcpy((u8 *)&ssp_task.LUN, lun, 8);
 	return pm8001_exec_internal_tmf_task(dev, &ssp_task, sizeof(ssp_task),
 		tmf);
 }
-- 
2.25.1

