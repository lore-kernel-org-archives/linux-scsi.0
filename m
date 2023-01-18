Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E95C46467
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjARWzb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbjARWzK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:10 -0500
Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 91A1F4EE3;
        Wed, 18 Jan 2023 14:55:09 -0800 (PST)
Received: by mail-pj1-f42.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so3176549pjq.0;
        Wed, 18 Jan 2023 14:55:09 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Pdxak3ks4z8LUD82adauJLLCkfT4Il1pbTlxgU/qcbQ=;
        b=8IWk92G06hgv/hdWJhFkEpTwoeBVzMgsrG6mMGuUtlMmrR+ZCugeKjW0Ojw8+5CBZa
         TNLt1zgw7WzSCudQ4Gcnke2cZjHareTv+phkSEtBU6D9PJH85rQhNPFb4L8oaPMzHvQK
         iD/51QhfcG9SR1t3cWIicNi0mRBLkP9eeOceT/0AxHxs/e/a08AkfLpOai3Em2cMzHf6
         td+Za8GNCFdiVD6tnbLDim38R3drmJhDdARO9QewkI1mRqnMS4j7RusMzZbvLJAwfuHj
         rfIeS0sJ0ym3gabka/xMP3BFr3JN+6UtE4g42PxIfzitzad23OxSZ3DEk8qkuwL+U2CK
         iumw==
X-Gm-Message-State: AFqh2ko6UvII7q1LNzY9W7vsaKo8zb2Lw+3J+M8Bn0XROUIkJiu1vlUE
        yyArgw0xcinHM8bQq9NI440=
X-Google-Smtp-Source: AMrXdXvuP1GSpvNRUGFcAH8lvWpT/mj0NSaH3OV5uoRMllKfmFhN3hLeiRwKrA8EQUiTHERrDhFCnQ==
X-Received: by 2002:a17:902:ef8c:b0:189:890c:4f6f with SMTP id iz12-20020a170902ef8c00b00189890c4f6fmr28600134plb.64.1674082508789;
        Wed, 18 Jan 2023 14:55:08 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.55.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:55:08 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v3 8/9] scsi: core: Set BLK_SUB_PAGE_SEGMENTS for small max_segment_size values
Date:   Wed, 18 Jan 2023 14:54:46 -0800
Message-Id: <20230118225447.2809787-9-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The block layer only accepts max_segment_size values smaller than the
page size if the QUEUE_FLAG_SUB_PAGE_SEGMENTS flag is set. Hence this
patch.

Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 9ed1ebcb7443..91f2e7f787d8 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1876,6 +1876,9 @@ void __scsi_init_queue(struct Scsi_Host *shost, struct request_queue *q)
 {
 	struct device *dev = shost->dma_dev;
 
+	if (shost->max_segment_size && shost->max_segment_size < PAGE_SIZE)
+		blk_queue_flag_set(QUEUE_FLAG_SUB_PAGE_SEGMENTS, q);
+
 	/*
 	 * this limit is imposed by hardware restrictions
 	 */
