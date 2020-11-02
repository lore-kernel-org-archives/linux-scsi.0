Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5FD37C00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2C13208A9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uv1hmw+W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726285AbgKBOYW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726277AbgKBOYU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:20 -0500
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1240CC0617A6
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:19 -0800 (PST)
Received: by mail-wr1-x443.google.com with SMTP id i16so9412143wrv.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ef7dXGUoI/7wCGOrbe2vfPSP8bVd47W9yi6D/rto+eg=;
        b=uv1hmw+WrHlL0OL0oYxvH7RqYtiZnqV3Mh2hXP613H3bUPDmOF3MRTOsrgCXx8LJ9T
         3PidGB3er4AEYDkZdJJdbm+bUDwOcWpvyScyXMKjCSRbXih2F5EL7AoWf2d0gAZkO4yQ
         yBGG0rxkFizdMIysa6U+jnArKssC94gq4VSMHUS4/CgZ7APMwYfjYkOCdJTBFjNfqCcK
         mMBKtKLB8juDgG/Lc2bpU9xA2yoxOKFflL6nFMyNAISs8Z6mDQbhnRY7EX7b+TolRT3l
         mx/wPvkNt2naBeJk/1+bBjZpKo6uxWw3WlLSSOb/1QtKWa889bY8A8erHWDbTObyzdJD
         UF4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ef7dXGUoI/7wCGOrbe2vfPSP8bVd47W9yi6D/rto+eg=;
        b=YiGdGkfrueaAJUUNu7nxNe41UgsQCLnP3PkExbP46v/W+N5vAPttgpubn6NXQDUfAZ
         03GEO6K/cyjbUd1YfiZrKThwQgk+venF2Q0z211IIKQMeQFKKUyOzwS4+CK54cbcZqMr
         Es5ZBK2EUK1AAY9O3U3FeC/uCoay3mAU4bwRsWthQ5fJIORzxS+cxR4zXvsr8DEgKBh6
         bvJYoyzJIJY5TGBjyfKOslps8qEGmhjSMQhh3/DiUwmtdRQQlSFG1fWCS6NGAXt6Taj+
         OK0HUj6OANROXdW/KiIeRekSiTOQBjiEgXP67XlvDGSIdXSBPnxFc6d1YlOsYYNXwK84
         BMpA==
X-Gm-Message-State: AOAM5316MJPuD5LJJKK9xxy8t+vnQFE4NfVDZbOh8MbDMQ60bQkNbROt
        RwPYoonTUMMFeDRTSlCO3wsPEA==
X-Google-Smtp-Source: ABdhPJzzoTKRzCI7bLzhdhGraulqFfTnOUcfPj6FuB86EYfSmmXosL5BeCndbVFcn7KvMY/+w+ILFg==
X-Received: by 2002:a5d:6ca6:: with SMTP id a6mr20395760wra.348.1604327057772;
        Mon, 02 Nov 2020 06:24:17 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:17 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Vinayak Holikatti <h.vinayak@samsung.com>
Subject: [RESEND 11/19] scsi: ufs: ufshcd: Fix some function doc-rot
Date:   Mon,  2 Nov 2020 14:23:51 +0000
Message-Id: <20201102142359.561122-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102142359.561122-1-lee.jones@linaro.org>
References: <20201102142359.561122-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/ufs/ufshcd.c:6603: warning: Function parameter or member 'hba' not described in 'ufshcd_try_to_abort_task'
 drivers/scsi/ufs/ufshcd.c:6603: warning: Function parameter or member 'tag' not described in 'ufshcd_try_to_abort_task'
 drivers/scsi/ufs/ufshcd.c:6603: warning: Excess function parameter 'cmd' description in 'ufshcd_try_to_abort_task'

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Santosh Yaraganavi <santosh.sy@samsung.com>
Cc: Vinayak Holikatti <h.vinayak@samsung.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 2309253d3101c..7ba3e923eb585 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6594,7 +6594,8 @@ static void ufshcd_set_req_abort_skip(struct ufs_hba *hba, unsigned long bitmap)
 
 /**
  * ufshcd_try_to_abort_task - abort a specific task
- * @cmd: SCSI command pointer
+ * @hba: Pointer to adapter instance
+ * @tag: Task tag/index to be aborted
  *
  * Abort the pending command in device by sending UFS_ABORT_TASK task management
  * command, and in host controller by clearing the door-bell register. There can
-- 
2.25.1

