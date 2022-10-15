Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91AE8C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 15 Oct 2022 00:25:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229749AbiJOAZA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Oct 2022 20:25:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiJOAYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 Oct 2022 20:24:46 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0149F65E2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:42 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id u71so5682949pgd.2
        for <linux-scsi@vger.kernel.org>; Fri, 14 Oct 2022 17:24:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7XmQEiLahFERiW82A0FHr4JWq40+ZHBdBXdCRFPHXPU=;
        b=tXy94ZoBAQNMlgHwbW5Tuv5Fj7lhBMF79o9NpajA7CTvKKJM8JkLEgsQbHdmuBffP6
         PK9KGZc+fgsmsJgb5Nb8rvdx+ee0c22yUK7qTzCmb3UukE1MH+fM2pdZOH0aHz61lv0+
         PF8DFIWk9EuaNxHsbkRAIQnDNLyvWwwE/a/e+w652Kjx106WreoJcTWqDaqDk0WweGnt
         xKAmWVeyGZ4Dc8R8lOLPLnxBmImKkv0vEmkoEYO4kpxudFO5ZUZDuvydPBckUZicuQoF
         U+Uol0u5bDC6D430Gyj2peeRFSSIAj+od8euMDsruUsYEtHB97IqKbA8pFQFe8A9eTgD
         djbw==
X-Gm-Message-State: ACrzQf3dXOL8NjTvvQcVgFZWp4+2AzxIDR55xY9qI3caZgtLLua1aZwi
        tUhicP6PCPsNm0NK0DYvJmc=
X-Google-Smtp-Source: AMsMyM4BgzRjmgxk854KS6b7ndXBpTo8K7dQG+X1aN3fUuSI3tteLPcaKaJCwOuVmPLB6EbW0V+MEQ==
X-Received: by 2002:a05:6a00:ac6:b0:530:3197:48b6 with SMTP id c6-20020a056a000ac600b00530319748b6mr432052pfl.80.1665793481289;
        Fri, 14 Oct 2022 17:24:41 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id y17-20020a634951000000b0046a1c832e9fsm1937953pgk.34.2022.10.14.17.24.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 17:24:40 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v7 7/8] scsi: core: Remove the put_device() call from scsi_device_get()
Date:   Fri, 14 Oct 2022 17:24:17 -0700
Message-Id: <20221015002418.30955-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20221015002418.30955-1-bvanassche@acm.org>
References: <20221015002418.30955-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

scsi_device_get() may be called from atomic context, e.g. by
shost_for_each_device(). A later patch will allow put_device() to sleep
for SCSI devices. Hence this patch that removes the put_device() call
from scsi_device_get().

According to Rusty Russell's "Module Refcount and Stuff mini-FAQ",
calling module_put() from atomic context is allowed since considerable
time. See also https://lkml.org/lkml/2002/11/18/330.

Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index c59eac7a32f2..9feb0323bc44 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -563,14 +563,14 @@ int scsi_device_get(struct scsi_device *sdev)
 {
 	if (sdev->sdev_state == SDEV_DEL || sdev->sdev_state == SDEV_CANCEL)
 		goto fail;
-	if (!get_device(&sdev->sdev_gendev))
-		goto fail;
 	if (!try_module_get(sdev->host->hostt->module))
-		goto fail_put_device;
+		goto fail;
+	if (!get_device(&sdev->sdev_gendev))
+		goto fail_put_module;
 	return 0;
 
-fail_put_device:
-	put_device(&sdev->sdev_gendev);
+fail_put_module:
+	module_put(sdev->host->hostt->module);
 fail:
 	return -ENXIO;
 }
