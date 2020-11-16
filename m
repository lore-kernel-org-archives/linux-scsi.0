Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30613C4742C
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:05:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5DA422265
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 07:05:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mT6a5U26"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727234AbgKPHAq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 02:00:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726524AbgKPHAq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Nov 2020 02:00:46 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA65CC0613CF;
        Sun, 15 Nov 2020 23:00:44 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id h21so1827882wmb.2;
        Sun, 15 Nov 2020 23:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=/WS+PJRE2OGyeY6RdUzMuAsaLGec+mJ+W+Kppo7JUTk=;
        b=mT6a5U26s+LjfpqwX2Q+Ilm57J/7WiUUItSDp3s462F7bbtdwHhev2bL9n671X6x0X
         lbtarwKYDmxY7ZrnrOMAy9dDvLTPGxplGnFsChFmTrueaFHMFuEIPOlme7iPMPu9s6bH
         remHDWst0JePDJqZkOoEPryZeORpe8+X8hTYJN/k7bw/4hn873VcSY2Q9CxvmiPZ8MAc
         d2zahCvE0JoKfA+DcmGEBbqjfZaeMXqFoxQQryTcG2+TZZ+8lpaveEnjC7uajvXSPy9p
         Lde3nDgNnLnwAQU2SM4kKrjgtXGaHog3VbSfq//aNy+JOWxgV5IL1QrKhtEglJZ9Wc+b
         J8XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=/WS+PJRE2OGyeY6RdUzMuAsaLGec+mJ+W+Kppo7JUTk=;
        b=d/9MHg8bdWSTMqYDqO8TCH4DPgEIrXKpIkjfCn5OXRpk4oDcXbfLUq99WLNNXpc7Oa
         OXuG9qn7hJPWBNPt6WQkmeyJFuFqnxyktuw7KDAQQk2vsG91UmKSHlItcaVqJbT0APAv
         4Bp0A06KNt1m7NoF0fLDmsBjimbcKd4+frgMDWUlwP7TF2l1sv9g8foFEvocccZ8Y2gA
         oxtOLREMv9F2kFZFXmuBiY5+Zgn/DjS8SYU46fJfxfbcMHWiVlVEJp9YC53NIVuTq5pE
         txrlrUoXRGXYwQcQNqrvtnwNPra34Yuv5zdeIYmhaiVMl8XKI4jJeuW6d7iDXD1jbntP
         /z0A==
X-Gm-Message-State: AOAM533w801J3ijYH8mRw6O3bsAc+73lnpNnizPnaJU2vIFsb+Ci1BFM
        zZ9/EiSyHQcvRbiBxwNzHb8=
X-Google-Smtp-Source: ABdhPJyRr2lPY09u6b19zO7iBZ3oI+I7YiQQo5QkM5PA4TRlPOgnU6fg+mtPEQtiEzTLzvvJ0iCLNw==
X-Received: by 2002:a7b:c1ce:: with SMTP id a14mr13996360wmj.126.1605510043378;
        Sun, 15 Nov 2020 23:00:43 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2de6:ad00:939:47a9:70b9:fe5b])
        by smtp.gmail.com with ESMTPSA id o63sm18676667wmo.2.2020.11.15.23.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 23:00:42 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Tom Rix <trix@redhat.com>,
        Nathan Chancellor <natechancellor@gmail.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        clang-built-linux@googlegroups.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] scsi: sd: remove obsolete variable in sd_remove()
Date:   Mon, 16 Nov 2020 08:00:35 +0100
Message-Id: <20201116070035.11870-1-lukas.bulwahn@gmail.com>
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

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
applies cleanly on current master and next-20201113

Christoph, Hannes, please ack.

Martin, James, please pick this minor non-urgent clean-up patch.

 drivers/scsi/sd.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 106a9cda0eb7..82d0cb97b758 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -3513,10 +3513,8 @@ static int sd_probe(struct device *dev)
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

