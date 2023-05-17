Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A140DC77B75
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:09:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjEQXJ4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:09:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230046AbjEQXJu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:09:50 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2DECF5270
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:38 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-643990c5319so999948b3a.2
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364977; x=1686956977;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ayP7PD7vRVU1mwC0IUNGGeoZSbvK9/rrOfR1Ufk+uSw=;
        b=I6waPoZYcg6h8O84vkVE7YHIWI+JwBYsXqEXqVuybAMyvKvzobBUWgXw7NtFQMEb5U
         OvG8DUnE9tWzo/Uw/1OA7tu3P3SsELlySsTTvPVdUEej8lLbNs5T/n4UIRPjtCmU9RHi
         jf3f+8qexxX3YOEFyylApYL/bVPwZlehVijnYtLwAQouDKzbwK5ltTiJv00ScaL2ZUyj
         22yau6dTv4p/HA0kzmBscdZhS4cs0C6CsUdMdvqU4bhUmcgzIBQrW/CQIr9yFMHNQzn3
         819cT9Fim8jTAMOy5JCe3gnyPdHUL4NWdHde8unTTlCrjSnv8fiwofKvaLMzdrT8ioTB
         tcaA==
X-Gm-Message-State: AC+VfDz4Roi3/lHzRTP6s8gGPwQjn/kLgYqWF1HQuPp74upfq6AVbd3t
        LNaYzMZ7XTWGwY5Pz5FUkIQ=
X-Google-Smtp-Source: ACHHUZ45vIUmaZgBORY4vgSKE+1M7dVxZwOMeznua/L70337e7/EBmm/mMmfXmiecSg4hdxyIX/dBw==
X-Received: by 2002:a05:6a00:190e:b0:643:558d:9ce2 with SMTP id y14-20020a056a00190e00b00643558d9ce2mr1655301pfi.21.1684364977599;
        Wed, 17 May 2023 16:09:37 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a656789000000b005286ea6190esm15080694pgr.20.2023.05.17.16.09.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:09:37 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v3 4/4] scsi: core: Delay running the queue if the host is blocked
Date:   Wed, 17 May 2023 16:09:27 -0700
Message-ID: <20230517230927.1091124-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
In-Reply-To: <20230517230927.1091124-1-bvanassche@acm.org>
References: <20230517230927.1091124-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Tell the block layer to rerun the queue after a delay instead of
immediately if the SCSI LLD decided to block the host.

Note: neither scsi_run_host_queues() nor scsi_run_queue() are called
from the fast path.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>
Cc: John Garry <john.g.garry@oracle.com>
Cc: Mike Christie <michael.christie@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_lib.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e4f34217b879..b37718ebbbfc 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1767,7 +1767,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		break;
 	case BLK_STS_RESOURCE:
 	case BLK_STS_ZONE_RESOURCE:
-		if (scsi_device_blocked(sdev))
+		if (scsi_device_blocked(sdev) || shost->host_self_blocked)
 			ret = BLK_STS_DEV_RESOURCE;
 		break;
 	case BLK_STS_AGAIN:
