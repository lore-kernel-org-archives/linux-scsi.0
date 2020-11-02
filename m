Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0EE8EC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEEE421556
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:24:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="a43Ibixd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726303AbgKBOYg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726337AbgKBOY2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:28 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052AFC061A48
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:28 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id c18so9577142wme.2
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2Z/rYVelMIJ0thLYpCaKwCBLjzrrX0gmiBVcQfZUNhI=;
        b=a43Ibixdgp8CdDIAlCKn79g6oo4TN6ixx34gLoSxKOPrE7hM5BMX1SmrdYfK5RyQCI
         Y1dxgPr7PJb/prADNUHh6ypmasZsbI1UTcOJkTEZ+ddF52XZrWbAS7t/kWKljTVXdfZ0
         1fCw20D2h9HqIso1Me34Gt/C3E58gR0cBKfL2ck9WhrWgtotMTN1zlREgxJIX2PlZSnC
         hc3vCS/u74X7za9OSavMhM7P0ioOH4t5XVFDrdZ4mSRDdMNF4BARq5mKtnGtTUf4IDJF
         TDsY/fohl9vaAek84VKgNKxN4X9zgzy+uGp/lHko3Pqwm2vR/MQH5bDaYsweijGFuU8T
         SmhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2Z/rYVelMIJ0thLYpCaKwCBLjzrrX0gmiBVcQfZUNhI=;
        b=K6RBp3iTTebXu34PM1bFRzIOYm28twVIr4PX5oX4m4m6mvwc9DiAVvt0fPdTXvSSG5
         eucPxwy2Xzf0QVaIDPmfPxT/2XnrDhWB+dRyaG1cS8eaNCH8fu45wuG/8gWmKeXT3Hqc
         RUTM6mlC6FRPKIPdJ9MTd6nWrKkFkIYs9XN3YznUhMwlPQdHJCxeBf+wC6NSCi0WipS5
         jBWOg/zxdD25YUEAEE2loDdQY+Rp6GoaY0tIuxkAGNCPROWwmCHhDabNLD0xodVYMgOb
         52teyqrCZSIs6tGfOFbIFd8bA/d+e+tjV7nqYi7Pry43T0ojBP4TwWdaciK+72ydHXVg
         W+CA==
X-Gm-Message-State: AOAM533xcWxEtKzV43Y+VBVcJ6+m5yXtPr7d4ca8Ksn+7LUABzoUwCFG
        cn73M6LiekU0Hq0E5bagFVcwBg==
X-Google-Smtp-Source: ABdhPJwXM083olNC5t7SXnFBoD+pbFPet9vzejwV1MTKjWOozcBoDh18itooPxjjlBnDBBi/r2o3vg==
X-Received: by 2002:a1c:bbc4:: with SMTP id l187mr11568263wmf.133.1604327066726;
        Mon, 02 Nov 2020 06:24:26 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Oliver Neukum <oliver@neukum.org>,
        Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "C.L. Huang" <ching@tekram.com.tw>,
        Erich Chen <erich@tekram.com.tw>,
        Kurt Garloff <garloff@suse.de>, dc395x@twibble.org
Subject: [RESEND 18/19] scsi: dc395x: Mark 's_stat2' as __maybe_unused
Date:   Mon,  2 Nov 2020 14:23:58 +0000
Message-Id: <20201102142359.561122-19-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

It's only utilised when debugging is enabled.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/dc395x.c: In function ‘start_scsi’:
 drivers/scsi/dc395x.c:1359:6: warning: variable ‘s_stat2’ set but not used [-Wunused-but-set-variable]

Cc: Oliver Neukum <oliver@neukum.org>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: "C.L. Huang" <ching@tekram.com.tw>
Cc: Erich Chen <erich@tekram.com.tw>
Cc: Kurt Garloff <garloff@suse.de>
Cc: dc395x@twibble.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/dc395x.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/dc395x.c b/drivers/scsi/dc395x.c
index f838fe8d74578..7b522ff345d5e 100644
--- a/drivers/scsi/dc395x.c
+++ b/drivers/scsi/dc395x.c
@@ -1356,7 +1356,7 @@ void selection_timeout_missed(unsigned long ptr)
 static u8 start_scsi(struct AdapterCtlBlk* acb, struct DeviceCtlBlk* dcb,
 		struct ScsiReqBlk* srb)
 {
-	u16 s_stat2, return_code;
+	u16 __maybe_unused s_stat2, return_code;
 	u8 s_stat, scsicommand, i, identify_message;
 	u8 *ptr;
 	dprintkdbg(DBG_0, "start_scsi: (0x%p) <%02i-%i> srb=%p\n",
-- 
2.25.1

