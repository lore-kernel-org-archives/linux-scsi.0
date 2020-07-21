Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D48DC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48B6D207CD
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 16:43:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DygfAM0w"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730407AbgGUQnp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 12:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730724AbgGUQmi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jul 2020 12:42:38 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F10A2C0619DC
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:37 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id q5so21844487wru.6
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jul 2020 09:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u/h8ORy4DNqghX0fGvMFmOJAYmeG6EwmneD/txrpUKQ=;
        b=DygfAM0wilefsTFOLpkZloWhTbf1EjyFmvDb+uUwHVdhb0JFLov56x6AGdJpgFX3Qq
         dnFsLI1nMQl9gdysBDPjcyfA3NNUBp459/12QspUG+ePKZdUPn0RWRZXgg5qSv4nlmIS
         1Iq//z1b94Z1uw44379UTuKg/hIxd4Fg9fSuUzpK3w9u4wz4tMdCb5uPIRKdO46WsLEE
         yAh8ehw3AD2Q0Ds2E3XKQlXaJZCxqhhhWWhqcguQjf+alrX4Y85xO+pI3ravneTqbNL/
         2zrBozj/Yy4DG5DejE006yWRnaWi4tGuoSw0MHF8wZ3bF4micjw2euoSWwoJGE8BBPsx
         P8zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u/h8ORy4DNqghX0fGvMFmOJAYmeG6EwmneD/txrpUKQ=;
        b=M0Obs0UIge6AjfJVQIJ6u3uw4mQDULp78pvnxy3yX6003Zhzyw+AIMbXgR/ZxDeGW+
         K5w9opzZKmhv/UBpZcsqJWNInhdSA6UtG+ERTHlnjd2wFqCYkwrxxcpPnmSD4V18QX9Z
         GlyPpFyA/K11xfW8BfkGL2CyoBwiAuBw4V/3wuWA2wEjWzfEKRD17pPiEXSWwgyo3z1u
         d8jNwQkvMmk2xiWN4eEX0XFw9vVjeO1sc/We+tKU8xRt6rWxIK1sPBccA5XeUcclH37N
         QLnKjuVGE2qFIKtK7Z/4FjVk+ZZrVs8dvQihPj5//4xn2LH8h5axb8VpuVymW9AekwnG
         7MpA==
X-Gm-Message-State: AOAM532dmC1XsKpKHPQzEzDUvvnqlRXZqq31pOs134vNi1Alu26A6U1s
        0Wv3+rqYG4kzbF0PeXKprp0+dA==
X-Google-Smtp-Source: ABdhPJxKB+7toSm5UJGRFj6carCJ7zVGoIyBp8xuFw6t1mguDmz17idpSKI4JkNaKCdk85+OV0RD8w==
X-Received: by 2002:adf:f842:: with SMTP id d2mr29696845wrq.55.1595349756699;
        Tue, 21 Jul 2020 09:42:36 -0700 (PDT)
Received: from localhost.localdomain ([2.27.167.94])
        by smtp.gmail.com with ESMTPSA id m4sm3933524wmi.48.2020.07.21.09.42.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2020 09:42:36 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
        linaro-mm-sig@lists.linaro.org
Subject: [PATCH 28/40] scsi: lpfc: lpfc_mem: Provide description for lpfc_mem_alloc()'s 'align' param
Date:   Tue, 21 Jul 2020 17:41:36 +0100
Message-Id: <20200721164148.2617584-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200721164148.2617584-1-lee.jones@linaro.org>
References: <20200721164148.2617584-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/scsi/lpfc/lpfc_mem.c:85: warning: Function parameter or member 'align' not described in 'lpfc_mem_alloc'

Cc: James Smart <james.smart@broadcom.com>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Sumit Semwal <sumit.semwal@linaro.org>
Cc: "Christian König" <christian.koenig@amd.com>
Cc: linux-media@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org
Cc: linaro-mm-sig@lists.linaro.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/scsi/lpfc/lpfc_mem.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_mem.c b/drivers/scsi/lpfc/lpfc_mem.c
index e8c0066eb4aaf..27ff67e9edae7 100644
--- a/drivers/scsi/lpfc/lpfc_mem.c
+++ b/drivers/scsi/lpfc/lpfc_mem.c
@@ -68,6 +68,7 @@ lpfc_mem_alloc_active_rrq_pool_s4(struct lpfc_hba *phba) {
 /**
  * lpfc_mem_alloc - create and allocate all PCI and memory pools
  * @phba: HBA to allocate pools for
+ * @align: alignment requirement for blocks; must be a power of two
  *
  * Description: Creates and allocates PCI pools lpfc_mbuf_pool,
  * lpfc_hrb_pool.  Creates and allocates kmalloc-backed mempools
-- 
2.25.1

