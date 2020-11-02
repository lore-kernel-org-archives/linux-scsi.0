Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99635C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3BDAF206F8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="j7ZsLrUu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726239AbgKBOYQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgKBOYP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:15 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5375DC061A04
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:15 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id x7so14847304wrl.3
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ctr9VhfYZ+AJvPi8dDIyaqu3jXLLFUsXnVaAd6HF3ME=;
        b=j7ZsLrUuKjibSf84UEEvHvGstvtYaq3go94c4JsyMA7krTUz0IyHA3KrCfOZYtldrx
         QC8ppoamXbxKpbvQ3YLtIK2uzTHHI3bw4gylhO3tHuGGKKMz03KS8/BPwFnvkr00lycV
         QEWdJ8ACc4HlYOQJVV5wn9AmdM1SD066tRzEOLTC+YQdPiHV71YMV5dEOfOvxxfB/fHc
         1gblOPAurhahu4cIukOVimQz6RrcxhmZmrjwpDJwZiJNWKeW6APK+zvIuDvqmMdCRfv2
         VvDL+2QRxN766ax2JbTBIesxWhXf3ZYGkm6CIBnSlx2vooYhd1F7jKX13Lo64RAzf+ax
         rotQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ctr9VhfYZ+AJvPi8dDIyaqu3jXLLFUsXnVaAd6HF3ME=;
        b=AXEPUNtjKTOvMPF5BqJxMV2Gzr7cOtVOGS6cOfAPngJjUett140b4gGoOqpFUZjMKy
         kksBaHuPHXKCGHxMQAfCw4+K2SEtIu7N6j5ONRDYlymCXlnG54HnhSUiphQlHEyVUF9p
         zhxVvuyL4Ql0St4G+lBrwg+01Xa6DTTmlrdW6eHlhexewfGjK5nIRt7grfNlOtcEopdn
         v2nkhDLEy6Mlv1I9+S5KCXhNeC8jUETEA8uM/paGxiST2lzWlWHiM5Ep2r+ypzLf6ew4
         wPE/j+3+J8ywhuR2udrdN8lLW3NXWMJfB+sEAvM7A1VR9D1t1KslS77wQILo7+GkeTsd
         ylbQ==
X-Gm-Message-State: AOAM5334PzT6rOZULWePLeJfGiBbbz5iYFPjCVTrDWaXDK7CplDu6LeW
        FTx912jFMSaROF/vF8Bkb2aEJg==
X-Google-Smtp-Source: ABdhPJw+3QrE/nqtCDYVidZGKvxqC++goqqqygI261m8Ft1/TniRpbgavFjRAZOkUwVZPwzKvxzMlQ==
X-Received: by 2002:a5d:50cf:: with SMTP id f15mr20866404wrt.324.1604327054049;
        Mon, 02 Nov 2020 06:24:14 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:13 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bradley Grove <linuxdrivers@attotech.com>
Subject: [RESEND 08/19] scsi: esas2r: esas2r_disc: Place brackets around a potentially empty if()
Date:   Mon,  2 Nov 2020 14:23:48 +0000
Message-Id: <20201102142359.561122-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/esas2r/esas2r_disc.c: In function ‘esas2r_disc_get_phys_addr’:
 drivers/scsi/esas2r/esas2r_disc.c:1035:17: warning: suggest braces around empty body in an ‘if’ statement [-Wempty-body]

Cc: Bradley Grove <linuxdrivers@attotech.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/esas2r/esas2r_disc.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/esas2r/esas2r_disc.c b/drivers/scsi/esas2r/esas2r_disc.c
index 1c079f4300a56..ba42536d1e87a 100644
--- a/drivers/scsi/esas2r/esas2r_disc.c
+++ b/drivers/scsi/esas2r/esas2r_disc.c
@@ -1031,8 +1031,9 @@ static u32 esas2r_disc_get_phys_addr(struct esas2r_sg_context *sgc, u64 *addr)
 {
 	struct esas2r_adapter *a = sgc->adapter;
 
-	if (sgc->length > ESAS2R_DISC_BUF_LEN)
+	if (sgc->length > ESAS2R_DISC_BUF_LEN) {
 		esas2r_bugon();
+	}
 
 	*addr = a->uncached_phys
 		+ (u64)((u8 *)a->disc_buffer - a->uncached);
-- 
2.25.1

