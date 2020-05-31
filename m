Return-Path: <SRS0=V0rO=7N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 445EDC433E0
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 215D820723
	for <linux-scsi@archiver.kernel.org>; Sun, 31 May 2020 15:09:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="q/nmFo7C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728318AbgEaPJG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 31 May 2020 11:09:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728228AbgEaPIs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 31 May 2020 11:08:48 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA469C061A0E;
        Sun, 31 May 2020 08:08:47 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id c35so5361633edf.5;
        Sun, 31 May 2020 08:08:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=r8r5svcWyImZ6w7QoO3hY5ggCN6NWRqtw0VlABPCcR8=;
        b=q/nmFo7CUpwfne018Nypvy5mSG+2CnTbbEqtMuHqK6OVR43W1EdoXTh7a6zQ1JrFOM
         x3DdCWFfLx0NfP3kDyVIqh5XYLTm13+0mvGpas32T2MsTFXs1KWkBdG1kd1LWwexCkfK
         nUxFtYuBRDWYj3jKWDVFN5sv+QScuc2fc9X/cE6YdNH38GY7yDie9gi3+ykZIN1AFteI
         HMimIvkeMDlH6mMslVBZeXWDMJvLRFEW2+WqI3lhqfvQCvBniTCjsZ5qfPuEYfvzqCeJ
         0wrOFFdgv8qVxplqzOXHsNwRhdCBWM7dLSLi5zthu6AwC/dyL0za8P33cGM4RcgMQ69V
         6jeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=r8r5svcWyImZ6w7QoO3hY5ggCN6NWRqtw0VlABPCcR8=;
        b=Zb9ulma2N7iuE9waIPNTUBtMnAyxOp9+938HVzS1lANmllGxO2wJYmfoFf8/ekxI6G
         mwPJ8u3grojI/pKKxmLGXt0bSbE6HBIe+QufAugfCi8dEv7IqGC991w2lPu4xXVwiqUM
         OFQSEd7Fj7il56/liKhm4E0rKxK0i2R4AJtuaSFc9q+KhpDc2ujgQbOt92kRsLgYgRAv
         W3jbcfM/K6PTTPbCkEn4/ugxZASyV4ZcTofr3ptUGqf1XlWo7StczJfMMuYUE+WO8yBl
         HMy6pi0VsyEynK+OM/KM7LmCnIlrpwVEJPz9PlYPMkh95XolnPxqkbPYH8ipk3wXwuB3
         JEbQ==
X-Gm-Message-State: AOAM533JGkYeF+99leS2olsGy2MKXXRJ3UCBJqPNuMyRNPDohnPZvfaa
        sofMRts5ckBldC8bj1uko4U=
X-Google-Smtp-Source: ABdhPJwPp/0rbwWDA74IuEo4/S5AWdiSYnpFEIw8E9n9aVzwavto22sZhP8NUGmZlYy7C1guSNxO8w==
X-Received: by 2002:a50:f052:: with SMTP id u18mr17198321edl.16.1590937726497;
        Sun, 31 May 2020 08:08:46 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcfd.dynamic.kabel-deutschland.de. [95.91.252.253])
        by smtp.gmail.com with ESMTPSA id a62sm9564928edf.38.2020.05.31.08.08.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 08:08:46 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v4 3/5] scsi: ufs: fix potential access NULL pointer while memcpy
Date:   Sun, 31 May 2020 17:08:29 +0200
Message-Id: <20200531150831.9946-4-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200531150831.9946-1-huobean@gmail.com>
References: <20200531150831.9946-1-huobean@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

If param_offset is not 0, the memcpy length shouldn't be the
true descriptor length.

Fixes: a4b0e8a4e92b ("scsi: ufs: Factor out ufshcd_read_desc_param")
Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f7e8bfefe3d4..bc52a0e89cd3 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -3211,7 +3211,7 @@ int ufshcd_read_desc_param(struct ufs_hba *hba,
 
 	/* Check wherher we will not copy more data, than available */
 	if (is_kmalloc && param_size > buff_len)
-		param_size = buff_len;
+		param_size = buff_len - param_offset;
 
 	if (is_kmalloc)
 		memcpy(param_read_buf, &desc_buf[param_offset], param_size);
-- 
2.17.1

