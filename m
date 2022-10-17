Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ABC8C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 16:35:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbiJQQfb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Oct 2022 12:35:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230096AbiJQQf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Oct 2022 12:35:29 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4177E51A21
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:28 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id d13so6969630qko.5
        for <linux-scsi@vger.kernel.org>; Mon, 17 Oct 2022 09:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=A8NMre4QGtyFkZKy2qLyczfF7yFuzFP9jEXRo5AiHqI=;
        b=HQqZXtXe27btppP5FyDjFaJml1tbQD6DEyEKyGgNebA7UGtjDI4N/X0Qbsrp2SIx46
         f9n1WOn3i+6UgNehm0r+VVmjS5LsDysUMlNevDaZgKb6i4e91gqCAUNibah4Jao19tal
         0dJ0+J5qmANgySL7Bo4g8H43LNTsJhWfO6ccx+VPx5A5i09eJpQu54ecRRlVs9g+0pD+
         nuXtvQ/xGh9Td7qscNabR7Pv08gzB++jW0Rngwa1XumxjDLSO9PBCLR249DVnggfAft6
         /On0brIaKHrnCb/N/8Hnif0+RqixKFyU4PPQfcYOwXgnyPb89EsQK3LBcd1sNMFIU7yA
         15Bw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=A8NMre4QGtyFkZKy2qLyczfF7yFuzFP9jEXRo5AiHqI=;
        b=GfiglJigzvyvqY7WHEk8ciinhj/cxNFC2P1dzPeWaBmZaLX42H5NZ3Ef20rqJb62qg
         SKo6oVMnoQgAAZmMRbCNW+tg5tKl17X/B1rynuG3xX8B6jEimlqi1LPb8FO/syenIv2u
         dY1zzEmQcHORQeCev348g9waWo74JWZrlMFGftC5QrqGc89VVh6v6Af9FAsuZEWTiY+h
         1FINcDwSDg6AglQluCg8Kau7/tuzXIPAMO0Bjv+rUHo83iWxdEd29f5nIjYqbyJye3zR
         Q3AFqoN5pszh+lZn4zy7S3d4N85q8RTqfsjJ6YZnvU1bpJ4ZT/dxsuotZ5xNgbp89oMO
         EsQA==
X-Gm-Message-State: ACrzQf1xfxoneML/tct33on0ZZf+6VoUJJ1GrszEI6bXTCXQ/1nn1bH8
        v2f1UNhWKSG1hYElWOjd+QX/B1LuL88=
X-Google-Smtp-Source: AMsMyM6ZutpS47cxUTV9H3d14BUNdz2eTl1gu/U1A1dJiLmpiv5TuVqmA6Dz/J6SgtSvbbtn3A+F2Q==
X-Received: by 2002:a37:30c:0:b0:6ee:a5d0:e91f with SMTP id 12-20020a37030c000000b006eea5d0e91fmr8213885qkd.309.1666024527086;
        Mon, 17 Oct 2022 09:35:27 -0700 (PDT)
Received: from dhcp-10-231-55-133.dhcp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r2-20020ae9d602000000b006ceb933a9fesm152235qkk.81.2022.10.17.09.35.25
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Oct 2022 09:35:26 -0700 (PDT)
From:   Justin Tee <justintee8345@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     jsmart2021@gmail.com, Justin Tee <justintee8345@gmail.com>,
        Justin Tee <justin.tee@broadcom.com>
Subject: [PATCH 1/5] lpfc: Set sli4_param's cmf option to zero when CMF is turned off
Date:   Mon, 17 Oct 2022 09:43:19 -0700
Message-Id: <20221017164323.14536-1-justintee8345@gmail.com>
X-Mailer: git-send-email 2.38.0.83.gd420dda057
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add missed clearing of phba->sli4_hba.pc_sli4_params.cmf when CMF is turned
off.

Signed-off-by: Justin Tee <justin.tee@broadcom.com>
---
 drivers/scsi/lpfc/lpfc_sli.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
index 99d06dc7ddf6..768294b9bc0b 100644
--- a/drivers/scsi/lpfc/lpfc_sli.c
+++ b/drivers/scsi/lpfc/lpfc_sli.c
@@ -8354,6 +8354,7 @@ lpfc_cmf_setup(struct lpfc_hba *phba)
 			phba->cgn_i = NULL;
 			/* Ensure CGN Mode is off */
 			phba->cmf_active_mode = LPFC_CFG_OFF;
+			sli4_params->cmf = 0;
 			return 0;
 		}
 	}
-- 
2.38.0.83.gd420dda057

