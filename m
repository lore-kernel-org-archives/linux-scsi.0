Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7364C19F4F
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:56:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345964AbjHPTzx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345902AbjHPTzV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:21 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC184E55;
        Wed, 16 Aug 2023 12:55:19 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686f94328a4so158093b3a.0;
        Wed, 16 Aug 2023 12:55:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215719; x=1692820519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PniZFVm0KVVX2uS5WNDISfoYsmok7mUzRbqporfC4VQ=;
        b=J3sMhDWVqq7fmdpFcWKDTs7i90PubmupA1qINMbWrzNv6EZju5NY8Vg2HEsqFmpceF
         G+r7YWTVxyGs/BOvxrNQYAEEB+AHOvKpwXjvj2RSIypEMM+3sjM7s8zKebbpWOnBoNhx
         5Eb+Kkr0erQ360YuxCI7x4kQfPfe0jGHTnjsBMIAjodGxJleZg5nCv29Zdb4UDGjxgAx
         l6fcMkXipJhCHFf43wUrKEnkUD8kUpd5rzwoBeOZxxmvj1jbrhjnET4QQmhkPO9ToRgp
         5q7jUhWzcwWg9hke/jEEPcmJYJgkL1RaGZbXdKqHIaHms1OQ22oAw+BqYxdnDz5O+a3B
         P0EQ==
X-Gm-Message-State: AOJu0YzuCLEYpN8DjwtWfTghmV4KIudEZscDbT7Rhp1pUhYyEn0e9+Xc
        zjyvqTw7xGc0cVPqSwrS9sY=
X-Google-Smtp-Source: AGHT+IHjyb4MplqOB5ZI7uN2J6oIHoppcFqeMU9iVyvBkiXadvXwekCM0l2rnmBosM03Z1rMtVd9NA==
X-Received: by 2002:a05:6a00:847:b0:67a:72d5:3365 with SMTP id q7-20020a056a00084700b0067a72d53365mr825477pfk.6.1692215719003;
        Wed, 16 Aug 2023 12:55:19 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:18 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v9 10/17] scsi: scsi_debug: Support injecting unaligned write errors
Date:   Wed, 16 Aug 2023 12:53:22 -0700
Message-ID: <20230816195447.3703954-11-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Allow user space software, e.g. a blktests test, to inject unaligned
write errors.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index c44c523bde2c..c92bd6d00249 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -181,6 +181,7 @@ static const char *sdebug_version_date = "20210520";
 #define SDEBUG_OPT_NO_CDB_NOISE		0x4000
 #define SDEBUG_OPT_HOST_BUSY		0x8000
 #define SDEBUG_OPT_CMD_ABORT		0x10000
+#define SDEBUG_OPT_UNALIGNED_WRITE	0x20000
 #define SDEBUG_OPT_ALL_NOISE (SDEBUG_OPT_NOISE | SDEBUG_OPT_Q_NOISE | \
 			      SDEBUG_OPT_RESET_NOISE)
 #define SDEBUG_OPT_ALL_INJECTING (SDEBUG_OPT_RECOVERED_ERR | \
@@ -188,7 +189,8 @@ static const char *sdebug_version_date = "20210520";
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR | \
 				  SDEBUG_OPT_SHORT_TRANSFER | \
 				  SDEBUG_OPT_HOST_BUSY | \
-				  SDEBUG_OPT_CMD_ABORT)
+				  SDEBUG_OPT_CMD_ABORT | \
+				  SDEBUG_OPT_UNALIGNED_WRITE)
 #define SDEBUG_OPT_RECOV_DIF_DIX (SDEBUG_OPT_RECOVERED_ERR | \
 				  SDEBUG_OPT_DIF_ERR | SDEBUG_OPT_DIX_ERR)
 
@@ -3587,6 +3589,14 @@ static int resp_write_dt0(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 	struct sdeb_store_info *sip = devip2sip(devip, true);
 	u8 *cmd = scp->cmnd;
 
+	if (unlikely(sdebug_opts & SDEBUG_OPT_UNALIGNED_WRITE &&
+		     atomic_read(&sdeb_inject_pending))) {
+		atomic_set(&sdeb_inject_pending, 0);
+		mk_sense_buffer(scp, ILLEGAL_REQUEST, LBA_OUT_OF_RANGE,
+				UNALIGNED_WRITE_ASCQ);
+		return check_condition_result;
+	}
+
 	switch (cmd[0]) {
 	case WRITE_16:
 		ei_lba = 0;
