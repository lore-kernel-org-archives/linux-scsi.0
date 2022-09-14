Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8812CECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Sep 2022 22:56:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229768AbiINW4v (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Sep 2022 18:56:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229708AbiINW4t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Sep 2022 18:56:49 -0400
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB0B282F95
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:48 -0700 (PDT)
Received: by mail-pj1-f52.google.com with SMTP id n23-20020a17090a091700b00202a51cc78bso14279878pjn.2
        for <linux-scsi@vger.kernel.org>; Wed, 14 Sep 2022 15:56:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=SpmXLmWlYQVnn1BcyLp3cCBXB/Od6Q2CqnBaVZAdo34=;
        b=5l/cRVXFVk4wvWcG7SoyUpjk07FsIzX54k01dXKcT8DZs1FiEYecFuVqiYR4BjrEED
         /pWrI5ueHPycytJ6KrV29vDG355YhkqIVvjz9TBfijZ9tVQt1o0CrqDgk/oAIjmmtTdl
         vl32AFWbFohYi3A1n0dT49mnZ6RGLiohg9fVtbZWuRBUldkXyGwPk1ow34nc13lXF0qh
         CgR8n2PW8y5ik69/vJ5dJqi1w2+1ms5nZMUCTx7EqggRxkd5q4CG+Xllp6XpB/i0sh0w
         9RJOFwb2Z7V/TtwTWA5+Q6aqHi/8KgwgvwC8olgXTnB6b/2CSCxzTxR5eF8g65D9rVdM
         jCvQ==
X-Gm-Message-State: ACrzQf2eWk3UMPZoXx4psFc5zwMIcuwfeF1sSv9lw5xT/bIexCVryxXB
        rrwtBy5x/+6dHgaibF4h4jwXBLha86g=
X-Google-Smtp-Source: AMsMyM6O+oUGQqIm4FYtCdXbSnE6bkw7VZ2zPLFCK/+ZtL3DmAmqrdpfbHGC29eg1JxgipmQ1JLI+w==
X-Received: by 2002:a17:902:bc84:b0:174:505b:2d67 with SMTP id bb4-20020a170902bc8400b00174505b2d67mr1268540plb.33.1663196208362;
        Wed, 14 Sep 2022 15:56:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:9147:e0c1:9227:cf53])
        by smtp.gmail.com with ESMTPSA id w9-20020a170902d70900b0016d1b70872asm2606926ply.134.2022.09.14.15.56.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 15:56:47 -0700 (PDT)
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
Subject: [PATCH v5 1/7] scsi: esas2r: Initialize two host template members implicitly
Date:   Wed, 14 Sep 2022 15:56:15 -0700
Message-Id: <20220914225621.415631-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.789.g6183377224-goog
In-Reply-To: <20220914225621.415631-1-bvanassche@acm.org>
References: <20220914225621.415631-1-bvanassche@acm.org>
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
