Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F01A7C43217
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 22:46:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbiI2WqD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 18:46:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230263AbiI2Wpg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 18:45:36 -0400
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C82D6D48
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:36 -0700 (PDT)
Received: by mail-pf1-f172.google.com with SMTP id b23so2671805pfp.9
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 15:44:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SpmXLmWlYQVnn1BcyLp3cCBXB/Od6Q2CqnBaVZAdo34=;
        b=P+lErRmtWJm0wipLhJxy8T9fToQRF/yToEN35cdLCCvlgyq8lIZ8BHYsFc6omx2hUM
         2MWyXybqFYFB189UUEsa9lbKjlX+8w/qhenXs8PijHkjKVmUwWknVRDhFGl13l2NUCij
         Zdzu5bszELnSjcOjTW7JCF7FOc/Mh75atZoPaABJiv8zbmS413tc3X4zqtg29fIuxb5m
         syuok06JFp9OZBKfWfEbKMfxJu4Ue5ep+7Km6PN8B0yX0Epld3myl6ag4hKvrkF++zis
         co4/dFl2kHuFjAOy16gpl2CnaTacJJNxd4UonFPFXdu0kXM782AXaCuaiQ65myy8jhAS
         Yhkw==
X-Gm-Message-State: ACrzQf0X1oKwO5fmCi4OyfTVxD+4lWtlVG0amg3DC36RUSxtKtX3rLas
        uQC+1c8hLsDU/YK/Ry3VHws=
X-Google-Smtp-Source: AMsMyM4h6Uc/PckpHjHc7FlTEV86GP1oSE4/o4/RWpLCzV28fDS+qKAZrd9UHou33cRj9I8xcp6s6w==
X-Received: by 2002:a05:6a00:1d9b:b0:541:1894:d5db with SMTP id z27-20020a056a001d9b00b005411894d5dbmr5701846pfw.78.1664491475826;
        Thu, 29 Sep 2022 15:44:35 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:56f2:482f:20c2:1d35])
        by smtp.gmail.com with ESMTPSA id w22-20020a1709026f1600b0016d1b70872asm404508plk.134.2022.09.29.15.44.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 15:44:35 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>,
        John Garry <john.garry@huawei.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 1/8] scsi: esas2r: Initialize two host template members implicitly
Date:   Thu, 29 Sep 2022 15:44:14 -0700
Message-Id: <20220929224421.587465-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.0.rc1.362.ged0d419d3c-goog
In-Reply-To: <20220929224421.587465-1-bvanassche@acm.org>
References: <20220929224421.587465-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Prepare for removing the 'proc_dir' and 'present' members from the SCSI
host template by implicitly initializing 'present' and 'emulated' in
'driver_template'.

Reviewed-by: John Garry <john.garry@huawei.com>
Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: Mike Christie <michael.christie@oracle.com>
Cc: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/esas2r/esas2r_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/esas2r/esas2r_main.c b/drivers/scsi/esas2r/esas2r_main.c
index 7a4eadad23d7..27f6e7ccded8 100644
--- a/drivers/scsi/esas2r/esas2r_main.c
+++ b/drivers/scsi/esas2r/esas2r_main.c
@@ -248,8 +248,6 @@ static struct scsi_host_template driver_template = {
 	.sg_tablesize			= SG_CHUNK_SIZE,
 	.cmd_per_lun			=
 		ESAS2R_DEFAULT_CMD_PER_LUN,
-	.present			= 0,
-	.emulated			= 0,
 	.proc_name			= ESAS2R_DRVR_NAME,
 	.change_queue_depth		= scsi_change_queue_depth,
 	.max_sectors			= 0xFFFF,
