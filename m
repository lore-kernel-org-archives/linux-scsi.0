Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36628C1B0E3
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 09:55:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E46B622A84
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Dec 2020 09:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733256AbgLNJzS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Dec 2020 04:55:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729399AbgLNJzN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Dec 2020 04:55:13 -0500
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7838C0613D3;
        Mon, 14 Dec 2020 01:54:32 -0800 (PST)
Received: by mail-ej1-x641.google.com with SMTP id q22so3943992eja.2;
        Mon, 14 Dec 2020 01:54:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+TLqkNu+h8gO95ZaplkB/B/fxqrw+QmRfatUThxlnac=;
        b=pA2b4V26JigMdUJ9g3xzRZKQqhWaOOWSKkyTku3KsiSyBxRN8c3oCSOr/XnVZR0JM9
         /sMVjJxQp/4KvDXARAwx+xTDXe4tMmM8EB5Nblp5gSSb3+xbtw2wOephhVWbptsYZ9xl
         4mKsE86ExOV90EV/GLsaIu/d6zxKXZzrMWSwXDLz+Z2hNmtqiqD35bgCbKq9XV9dAml2
         /vzh8kGui8ZkL8NJ7fHq37+zUa88BsiRbCJn74V5KKYX2/DBvG2Jek0ol1+PjEcuKNTf
         YXbJACqjP230Y05RBCwxUtRjzbbeGSTlGz2YqkzspKiCz5oYKzfhWH1AFbvzLv3d9hi3
         pFKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+TLqkNu+h8gO95ZaplkB/B/fxqrw+QmRfatUThxlnac=;
        b=i1brFsqzqRy3VZH4mnOC5DNf9YMzoat/kTx2BvcC3O40hSK2kygCT7l+BeI3nEUywp
         wCn8c/a2OGWuVFjhV1+KLEQEOxIOXWQQ9CDo+bo11ms0cnnEjcey02lPVwb5gR4hfmgg
         ys4+L8eKptKeBXgepECGQGWHWEPFXd6c3XCyRWp1WfcaFmjypLKB4tvyTJ3tZpi1HtJF
         iW774Q03Mzw0GQMp1sUNCtAF+grlYUSo75dqWQiavejXsCoVTZtUMpR1m7H/INCbPOcD
         c0tZpa/FzACqqlPx19+hN2BVB7EUD8Xi1YNqQrxzU0L0zWte1p3WCZkMiZZzD5N9yToC
         Gg3A==
X-Gm-Message-State: AOAM5314W4NmcZVUUlD9zNy+k3sE1UM/if8WO8Z/mSBDv0n7a3CkEeG6
        3d+hotztDeGI6tyN7uF3taU=
X-Google-Smtp-Source: ABdhPJx2BLvNpvotfHBPfnyEpidTSKq9CyRpYFMgbp28a/tT4rvBmhwGk1WP3mEUKpiXqgxkXWlu1Q==
X-Received: by 2002:a17:906:7687:: with SMTP id o7mr22009036ejm.209.1607939671569;
        Mon, 14 Dec 2020 01:54:31 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2dd4:5300:de8:a057:1d20:a710])
        by smtp.gmail.com with ESMTPSA id d14sm16140932edn.31.2020.12.14.01.54.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Dec 2020 01:54:30 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v2] scsi: sd: remove obsolete variable in sd_remove()
Date:   Mon, 14 Dec 2020 10:54:24 +0100
Message-Id: <20201214095424.12479-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 140ea3bbf39a ("sd: use __register_blkdev to avoid a modprobe for an
unregistered dev_t") removed blk_register_region(devt, ...) in sd_remove()
and since then, devt is unused in sd_remove().

Hence, make W=1 warns:

  drivers/scsi/sd.c:3516:8:
      warning: variable 'devt' set but not used [-Wunused-but-set-variable]

Simply remove this obsolete variable.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Nathan Chancellor <natechancellor@gmail.com>
Acked-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on current master and next-20201113, next-20201211

The patch was submitted for inclusion in scsi:

  https://lore.kernel.org/lkml/20201116070035.11870-1-lukas.bulwahn@gmail.com/

v1 -> v2:

Christoph and Nathan reviewed, and I added the tags here.
Martin asked the patch to go through block.

Jens, can you please pick this minor non-urgent clean-up patch?

 drivers/scsi/sd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 679c2c025047..21675a98620d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3510,10 +3510,8 @@ static int sd_probe(struct device *dev)
 static int sd_remove(struct device *dev)
 {
 	struct scsi_disk *sdkp;
-	dev_t devt;
 
 	sdkp = dev_get_drvdata(dev);
-	devt = disk_devt(sdkp->disk);
 	scsi_autopm_get_device(sdkp->device);
 
 	async_synchronize_full_domain(&scsi_sd_pm_domain);
-- 
2.17.1

