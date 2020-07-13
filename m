Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DCEBAC433F2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD89620720
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="awfg1w8h"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729204AbgGMHrF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:47:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729184AbgGMHrD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:47:03 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1760DC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:03 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id f2so14621654wrp.7
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:47:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u+pt3rF/aF9MXBxaxOWkhoV3OTeQnwTFN7tbYNZX5zs=;
        b=awfg1w8hLZaUeONe8FwFH8j88+Ggd4dTWQYwOx4LJBDj/hooZxwrwNsyZPuFQpyKqD
         01XRGH++ZXUAUk6tFVGrk2nqMdjfW1wcQldXKsZIj7u2DzDUZu2y5LkDTEKCfCnYixgU
         UFFIxMW/qOECoEjRPY0Cfn8mdpxL4gRQpEtc7owyS+zGUQ4fx9Qy7n94Yh2+u7qR2fh4
         47Di5k6+PNiKW7wgNJsxV+JBGngbT0y/zMH3RWnt64Fj5HDXXKM6se95Sn7/z0K9ciMm
         h02W4SFvKbl07l4Gh/BGJySnn89OkKt+I9xBlMJjt7THbizS2equRg/VUbMWtnIaZmvI
         8oZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u+pt3rF/aF9MXBxaxOWkhoV3OTeQnwTFN7tbYNZX5zs=;
        b=NvRXgYOT7FTkg4xcumfVIDdF1UtIU9rP+weytZ7jogz1V2Bdxh+qyoZj83P6fMmuKl
         cMUfqN8ShGmue3/SDyPn3d+9tUKKhV+dh5DRyLyzBUkz5iCopMDLOUTMzgfP2SpSF7cU
         RHDuaGnig7dkFoD8BaUlCZ2XIM/8FlW0O/RywPQuZc+td8ID4KrjhGN0jpu3B4wuW009
         w/DhshKc/XUQZQ4D1B1MKEH4rdRmfi9up7iShjVq+/HZbkM/k0XqmC9VJj+ZRfiIZifB
         cDAWsXVIgoUUSWHn5hZUuYB18yr1BCcBiXrWwsbOrlb2QFzK3+EsnwIvCgu7sy/GVR0J
         0QSg==
X-Gm-Message-State: AOAM533uGhqnuEnMIC/IjOFSQIAlzAXu/Xj0mDRTuFPy8A1RdUCa5yFO
        NX+ZDDfd10SxljESgY3P0auGpQ==
X-Google-Smtp-Source: ABdhPJxZbAHPn5pqfgwXCi4N+vnMcu57B+yNhS6xaLCLcT9XR5lJhp1zez0iYsnzWTLEzSFEurFjgQ==
X-Received: by 2002:adf:f209:: with SMTP id p9mr74769708wro.86.1594626421826;
        Mon, 13 Jul 2020 00:47:01 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.47.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:47:01 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Prakash Gollapudi <bprakash@broadcom.com>
Subject: [PATCH v2 13/29] scsi: bnx2fc: bnx2fc_hwi: Fix a couple  of bitrotted function documentation headers
Date:   Mon, 13 Jul 2020 08:46:29 +0100
Message-Id: <20200713074645.126138-14-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200713074645.126138-1-lee.jones@linaro.org>
References: <20200713074645.126138-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Likely a result of documentation not keeping up with API updates (a.k.a. bitrot).

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/bnx2fc/bnx2fc_hwi.c:493: warning: Function parameter or member 'hba' not described in 'bnx2fc_send_session_destroy_req'
 drivers/scsi/bnx2fc/bnx2fc_hwi.c:493: warning: Excess function parameter 'port' description in 'bnx2fc_send_session_destroy_req'
 drivers/scsi/bnx2fc/bnx2fc_hwi.c:1345: warning: Function parameter or member 'context' not described in 'bnx2fc_indicate_kcqe'
 drivers/scsi/bnx2fc/bnx2fc_hwi.c:1345: warning: Function parameter or member 'kcq' not described in 'bnx2fc_indicate_kcqe'
 drivers/scsi/bnx2fc/bnx2fc_hwi.c:1345: warning: Excess function parameter 'hba' description in 'bnx2fc_indicate_kcqe'
 drivers/scsi/bnx2fc/bnx2fc_hwi.c:1345: warning: Excess function parameter 'kcqe' description in 'bnx2fc_indicate_kcqe'

Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Prakash Gollapudi <bprakash@broadcom.com>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/bnx2fc/bnx2fc_hwi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/bnx2fc/bnx2fc_hwi.c b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
index 8c0d6866cf3b8..e72d7bb7f4f42 100644
--- a/drivers/scsi/bnx2fc/bnx2fc_hwi.c
+++ b/drivers/scsi/bnx2fc/bnx2fc_hwi.c
@@ -485,7 +485,7 @@ int bnx2fc_send_session_disable_req(struct fcoe_port *port,
 /**
  * bnx2fc_send_session_destroy_req - initiates FCoE Session destroy
  *
- * @port:		port structure pointer
+ * @hba:		adapter structure pointer
  * @tgt:		bnx2fc_rport structure pointer
  */
 int bnx2fc_send_session_destroy_req(struct bnx2fc_hba *hba,
@@ -1334,8 +1334,8 @@ static void bnx2fc_init_failure(struct bnx2fc_hba *hba, u32 err_code)
 /**
  * bnx2fc_indicae_kcqe - process KCQE
  *
- * @hba:	adapter structure pointer
- * @kcqe:	kcqe pointer
+ * @context:	adapter structure pointer
+ * @kcq:	kcqe pointer
  * @num_cqe:	Number of completion queue elements
  *
  * Generic KCQ event handler
-- 
2.25.1

