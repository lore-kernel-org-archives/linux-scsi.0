Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F4BBC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:32:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2ECD3610FC
	for <linux-scsi@archiver.kernel.org>; Mon, 31 May 2021 17:32:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233475AbhEaRd6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 31 May 2021 13:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232174AbhEaRdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 31 May 2021 13:33:49 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29CDBC05025F;
        Mon, 31 May 2021 09:31:33 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id cb9so2204179edb.1;
        Mon, 31 May 2021 09:31:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bW33yA6ZdV60A7GQBn0eZ2jngsXo5olQoHO89x826M=;
        b=avsz0mW4pXQ6RMrwjVGZlNe1jgkl9lYrmU6V0HNvhZ9DUWWrjJ5IjDeAp9KYWKxUJL
         npBre1epEzfYFh6VH7hF3FIJzRLkIJ5asXWemyf0gaE7pdkAvYM/MvArYTwS1pVYVOAm
         0o51S09vp8DSHq4ifKRtsfrRgYnc3a5/WhT1Ssgv9b549/8BLZc9tpu3yKHgSpb2J7pX
         DtAuyEr6psW7XBTxOPXk6+56wmVudeyViFkhVKPk58G7gHJBY4rz1VF4Uomnvy2c94Qs
         hdTdbGwr2z6IZyXXDO+IitAyg7UDVEM/bnFLjWRqMaI10hXvtFoQNr4q3x4uJ9ZYH1zp
         yI/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6bW33yA6ZdV60A7GQBn0eZ2jngsXo5olQoHO89x826M=;
        b=RnzePHEkUmFYZJeSKz1UIkqguksdEDNpLxL9fUch6k/Gjf0ErGlTUIRs1gFTQgk3sa
         xToL8pZBtImdfyRC+puNXOUVt6rW479Kr0E+CAuzv6zIpRhzk8b1vvCIalPllrc1dNb8
         mi3V7P5ZzL/+K8aT0+F06hYJYBhcAjKEFXGasvI7QeTwmLbB8vwk1o1R1RK7Lsi2krlx
         wtbMUmQdnvUw6/cuY7ZGKveUyRrYaQsx1+pM37FCz5tbgrV5cDcM4R8nOtLcPUPvS7aR
         SzD1vrlMNk9Umdi9L45kZHmWzLqkUvWFAnS0lCyOeM07jlx9OKQXv79ytVUWKx4NSkn7
         RKEg==
X-Gm-Message-State: AOAM531kjRMOxRq7GyedgpSUsD9k2NW6QBbRIrBxWwIuFldf1hIY5JAW
        5J8bkM5NkQPbk+zYwI6vK80=
X-Google-Smtp-Source: ABdhPJztJIopAo+FXeQ4QllggctbrcdvfKojYwCmN4ke1ysjCSrKv645uU6XXB2nTteTgLIbJXijyg==
X-Received: by 2002:aa7:c349:: with SMTP id j9mr18502942edr.48.1622478691845;
        Mon, 31 May 2021 09:31:31 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.gmail.com with ESMTPSA id n8sm6042180ejl.0.2021.05.31.09.31.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 09:31:31 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com, bvanassche@acm.org,
        tomas.winkler@intel.com, cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: ufs: Fix a kernel-doc related formatting issue
Date:   Mon, 31 May 2021 18:31:22 +0200
Message-Id: <20210531163122.451375-1-huobean@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Fix the following W=1 kernel build warning:

drivers/scsi/ufs/ufshcd.c:9773: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst

Signed-off-by: Bean Huo <beanhuo@micron.com>
---
 drivers/scsi/ufs/ufshcd.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 02267b090729..2cdd1f6da670 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -9769,10 +9769,7 @@ static const struct dev_pm_ops ufs_rpmb_pm_ops = {
 	SET_SYSTEM_SLEEP_PM_OPS(NULL, ufshcd_rpmb_resume)
 };
 
-/**
- * Describes the ufs rpmb wlun.
- * Used only to send uac.
- */
+/* ufs_rpmb_wlun_template - Describes UFS rpmb wlun. Used only to send uac. */
 static struct scsi_driver ufs_rpmb_wlun_template = {
 	.gendrv = {
 		.name = "ufs_rpmb_wlun",
-- 
2.25.1

