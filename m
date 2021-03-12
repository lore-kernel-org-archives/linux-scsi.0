Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30138C4361A
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1E05A64FFE
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:49:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233225AbhCLJso (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:48:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhCLJsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:48:10 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AC4CC061763
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:09 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id d191so3386065wmd.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:48:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c0xQIWF0LqpD3ejHYQPou8t3hq+GeNU8H9TybOS2LNw=;
        b=q2zFcK2T+TxsaTWb70uP9QaYJfcqs56lOphfBvEwLp5T+od0++x7jWfkS3N6zDqP1L
         qfrcuCzphl+61KYfIle1u5Jda0b8igwFwYOcT43OmZkc2osvqakwuqrh8ZgbURqQ9Dss
         jgbURjjvTli938VDvDY4rMASxyCo0HWwo9zA594QXXmhWoBLIyTmftN/B6MyNwV5OH1N
         Du+tn/W6mRebDhhFDV7pFhYls1ZJy4BCI+CVK73ajDwr1hAFh4sWlAvAfqVW9qUqO7Nj
         Z/4iGzWUVGsPv4AYDL4UDDq/gXq2fszpi9CmXMEofBKQVQatVdfrDoK5c88Oym6aosbX
         B1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0xQIWF0LqpD3ejHYQPou8t3hq+GeNU8H9TybOS2LNw=;
        b=K1lfQNqmYSRu6uAavGUdHOJgUCkrWF4Mxy7WlYIxCYvn0A5GRjDYtZgk8UCUjCluIQ
         xv2qMLaWHQ+8lY/a28tZMjkADEgpeUBndeGKqAGxl7oNOmzeSDJU3J59iPmrGfZB21uM
         TlNjKQBhDjV4iWNCMpp/DEk7XGo/zhVGx6AG7n9pzonhYH1djftcQaqKmexuKFN90peD
         HAXQ1FsYDoV0g6/xTmkqiC9t09MnW3jg0wXtTiQcHjg44M3sEVIUaudfarerzHPdSU70
         RUkt90VovKvHR/MJSfixrW3gUBP2tNrle3x22P24r7wMpd6D1X+PkEUsZeGzS0P+cRp2
         SCiw==
X-Gm-Message-State: AOAM5320+RzJyJGMmtqgfV4NV1k4Vt4gRYlgRBfPb92IwZygliCFcztN
        LcxSkE7OrXjCAVqfc9FWf6JQ7JctQgz+fQ==
X-Google-Smtp-Source: ABdhPJyAIadfdHvWxeWQbQwmY00KbvO0nwtdrsrc6gYF6g1mmfhjr/y+Yh6/XWzTSO/vdh+vzZH7hw==
X-Received: by 2002:a05:600c:4150:: with SMTP id h16mr12249165wmm.120.1615542488358;
        Fri, 12 Mar 2021 01:48:08 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.48.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:48:07 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-drivers@broadcom.com, linux-scsi@vger.kernel.org
Subject: [PATCH 19/30] scsi: be2iscsi: be_iscsi: Fix incorrect naming of beiscsi_iface_config_vlan()
Date:   Fri, 12 Mar 2021 09:47:27 +0000
Message-Id: <20210312094738.2207817-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210312094738.2207817-1-lee.jones@linaro.org>
References: <20210312094738.2207817-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_iscsi.c:312: warning: expecting prototype for beiscsi_set_vlan_tag(). Prototype was for beiscsi_iface_config_vlan() instead

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-drivers@broadcom.com
Cc: linux-scsi@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_iscsi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_iscsi.c b/drivers/scsi/be2iscsi/be_iscsi.c
index a13c203ef7a9a..0e935c49b57bd 100644
--- a/drivers/scsi/be2iscsi/be_iscsi.c
+++ b/drivers/scsi/be2iscsi/be_iscsi.c
@@ -295,7 +295,7 @@ void beiscsi_iface_destroy_default(struct beiscsi_hba *phba)
 }
 
 /**
- * beiscsi_set_vlan_tag()- Set the VLAN TAG
+ * beiscsi_iface_config_vlan()- Set the VLAN TAG
  * @shost: Scsi Host for the driver instance
  * @iface_param: Interface paramters
  *
-- 
2.27.0

