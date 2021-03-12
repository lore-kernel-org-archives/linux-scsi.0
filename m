Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8820C28E85
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A51D764FB9
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbhCLJsq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233120AbhCLJsQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:16 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903DFC061764
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:01 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id v11so1399591wro.7
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=N9wGEZYJoAIhx351pyXi5TmAw4uiOf0aUU7wFJx73AA=;
        b=aT+b5fgyqnDqnX7G5hdmSnKGdVhd9/KtvR4wfW6CaqISTqzo1QWxh7kdAkq/1Ibjpc
         qpeXdoXLK6hueG+4qGj7plD0J70Wm6rd7ElVOEdFvRCj+mkkj3PZhzhmztTfbNTphipW
         028VkRDg4vGaTVotU4tB73nUGkhIrqiVKJLNMeSPqwzStwybxdzQ/9GiL1+hIqnPH/7f
         axRG75uF9535F3DGUbQUqCymVWkQxv4cB6m37A4LC9BW9qSUE+JQcYK3g7jHEYARZLlf
         gYZThZbE0Ym7c7yMJ2i7NYSIQBXiLSD673ZvEOP14ROber75e9NknV+mVPrJfy1u1Kwz
         8tPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=N9wGEZYJoAIhx351pyXi5TmAw4uiOf0aUU7wFJx73AA=;
        b=RaymuOEcF6MHM3tT9v9kw6WJlilMnZgYYOw7BCGL/9u2eeBUAtoUjqjejJ9oTaYLtU
         v88cGIhfXpamnIgnNv/ZNh2Z1J7NVNvz3g9oUXs6sTKSRDxoUq3/82Yo88gO1gWvd2Di
         /sbpVH1UcFoVuD/1WDBUeW5nYGTrt7MnpVxhoEyp/lgAd0yjuJLJyYi1gVOs6CoJlOFt
         W6gh+o0Z14iqP6q60V0wkuWEYHY2cAI0ZRSqrfzS/2rjUzFtZ1W9iGd1pc3HyoirlUmL
         rDl+DIvlupIsl8yn/Cs/pneHqy3qMEuRIBA42CKekLo8zAQf14pb6cq8+fg6d2HZDyaf
         ppUQ==
X-Gm-Message-State: AOAM533CIZLeEl9vGikNDYnx0disIey4Nwditueg/4CBGJj0AFXHnbds
        RujvGYcrvt47boYrbNq3L7gyfA==
X-Google-Smtp-Source: ABdhPJy4jSKuKcRpT3rqMHJb0ZPqCblkctt5Ebx8UNzjoft9Q7wfdmHUGu0Dun5/0VYuxQw+cWMWrg==
X-Received: by 2002:adf:e482:: with SMTP id i2mr13034372wrm.392.1615542480270;
        Fri, 12 Mar 2021 01:48:00 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:59 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>,
        Nathaniel Clark <nate@misrule.us>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        linux-scsi@vger.kernel.org
Subject: [PATCH 11/30] scsi: qla2xxx: qla_target: Fix a couple of misdocumented functions
Date:   Fri, 12 Mar 2021 09:47:19 +0000
Message-Id: <20210312094738.2207817-12-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/qla2xxx/qla_target.c:6476: warning: expecting prototype for qla_tgt_lport_register(). Prototype was for qlt_lport_register() instead
 drivers/scsi/qla2xxx/qla_target.c:6546: warning: expecting prototype for qla_tgt_lport_deregister(). Prototype was for qlt_lport_deregister() instead

Cc: Nilesh Javali <njavali@marvell.com>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Nathaniel Clark <nate@misrule.us>
Cc: "Nicholas A. Bellinger" <nab@kernel.org>
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/qla2xxx/qla_target.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
index c48daf52725d9..67c6a2710360a 100644
--- a/drivers/scsi/qla2xxx/qla_target.c
+++ b/drivers/scsi/qla2xxx/qla_target.c
@@ -6462,7 +6462,7 @@ static void qlt_lport_dump(struct scsi_qla_host *vha, u64 wwpn,
 }
 
 /**
- * qla_tgt_lport_register - register lport with external module
+ * qlt_lport_register - register lport with external module
  *
  * @target_lport_ptr: pointer for tcm_qla2xxx specific lport data
  * @phys_wwpn: physical port WWPN
@@ -6538,7 +6538,7 @@ int qlt_lport_register(void *target_lport_ptr, u64 phys_wwpn,
 EXPORT_SYMBOL(qlt_lport_register);
 
 /**
- * qla_tgt_lport_deregister - Degister lport
+ * qlt_lport_deregister - Degister lport
  *
  * @vha:  Registered scsi_qla_host pointer
  */
-- 
2.27.0

