Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99E6DC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 735B5207F9
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VesfxsaF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728459AbgGIRqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728648AbgGIRqW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:22 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17651C08E6DC
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:22 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so3318060wrw.1
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XHlEfo3tdu7fpK4dx4b1MtHnaLwguM9Twh58pG6oyd8=;
        b=VesfxsaFFBKFlk9a9thYrVO38tZFUIsXefQpeuQaw8W8zrnsJ6vUqOtgK2Ak4YziVP
         SAMUUQZT8+evcb3M8m1ZVqmUtNYL8Rnkub3E3tFQUMxT+MJd1UFZrrynIrBhOJC/OCUR
         iif8eqkIRWByhR4s1B2m/awq1KuBDP5E9pjlGmzfhv3hq78ZpFA6jmfuJxb1Xowjx8qC
         /f4Z+MhPjjAI7u2iGyboKKcpmTG5YzMnYT1OSWxNGuOg2y5YfkUo9eOK+x2fEmeaPSxQ
         onsYPfz7Ong2fnJtK8U0qd6zZddcDgvw9vgobA377uZw6ps0DoKK21yIP3eA5NXb3iuO
         sPZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XHlEfo3tdu7fpK4dx4b1MtHnaLwguM9Twh58pG6oyd8=;
        b=V9ZGRiNSrIIPlRBf6KhFN+5gRGKw9myFePAJvRMwcdCX43Z1iLrApsG4XfVr2a9NQh
         +LuttL5RhK0ji7gqyyPlP/7K0ZgoJK+FYSab+F7iLnCTnCpf9NU8Qc47qgI57zxx38wQ
         Mlupz7SIOzYY2uaGiLjTrt1dvYj2XWCQWcY3ZDdKFICllBV3vf5EI2NwlMD5Z+6dxTrO
         Lp9D/Ut8hU9pfUvbxzVaIjdY7hPuEExdn5lq1ObZPD2Gu6p0XT0qZRGX70qxHMfZPs7a
         tAsIOPI+MWKdg8R/K8d4mEbYDOyev0MZY2OPMEmwnYpA6rPv/7IGkYceVjLRzFBT9pFO
         9AOA==
X-Gm-Message-State: AOAM530shCNH4MwNOHBf4+YzOlvsyyuW7RoOZEXSPM666wVBUVoaXZqj
        1f52ZgSVEuv+scVa3nK5KyxThQ==
X-Google-Smtp-Source: ABdhPJzy5HBCuvGp2iVQ86W6+Mz0CNvvbimic6tKdTb+zeyOYZkAgFLlD+bWSTCF7ehNYJab+WbGFg==
X-Received: by 2002:a5d:6987:: with SMTP id g7mr63785648wru.79.1594316780854;
        Thu, 09 Jul 2020 10:46:20 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.46.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:46:20 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        linux-drivers@broadcom.com
Subject: [PATCH 19/24] scsi: be2iscsi: be_mgmt: Add missing function parameter description
Date:   Thu,  9 Jul 2020 18:45:51 +0100
Message-Id: <20200709174556.7651-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200709174556.7651-1-lee.jones@linaro.org>
References: <20200709174556.7651-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Also promote fully documented function header to kerneldoc.

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/be2iscsi/be_mgmt.c:112: warning: Function parameter or member 'phba' not described in 'mgmt_open_connection'

Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: linux-drivers@broadcom.com
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/be2iscsi/be_mgmt.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/be2iscsi/be_mgmt.c b/drivers/scsi/be2iscsi/be_mgmt.c
index a2d69b287c7bb..96d6e384b2b25 100644
--- a/drivers/scsi/be2iscsi/be_mgmt.c
+++ b/drivers/scsi/be2iscsi/be_mgmt.c
@@ -97,6 +97,7 @@ unsigned int mgmt_vendor_specific_fw_cmd(struct be_ctrl_info *ctrl,
 
 /**
  * mgmt_open_connection()- Establish a TCP CXN
+ * @phba: driver priv structure
  * @dst_addr: Destination Address
  * @beiscsi_ep: ptr to device endpoint struct
  * @nonemb_cmd: ptr to memory allocated for command
@@ -209,7 +210,7 @@ int mgmt_open_connection(struct beiscsi_hba *phba,
 	return tag;
 }
 
-/*
+/**
  * beiscsi_exec_nemb_cmd()- execute non-embedded MBX cmd
  * @phba: driver priv structure
  * @nonemb_cmd: DMA address of the MBX command to be issued
-- 
2.25.1

