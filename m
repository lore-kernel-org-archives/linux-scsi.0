Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 182B3C54EBE
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Jan 2023 22:55:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230097AbjARWza (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Jan 2023 17:55:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230104AbjARWzG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jan 2023 17:55:06 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A21F03C14;
        Wed, 18 Jan 2023 14:55:05 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so4019599pjg.4;
        Wed, 18 Jan 2023 14:55:05 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W8U5WnK3y+sPKAzy++IL/tcRApHh09TXdzuDO7B9I+Q=;
        b=E9+pJJjTxXylzFvULclWQ+TfQJ5G3h9rzmpSF/dVUlvIOJi+rp3q6pNA1D/PGVY21p
         1jfD5u807mAZUotU8SqT5TXKDSQPWVTKPDlTDr3C4KX7dSVd+KEvN6hVlpvLAqjpJaN8
         TVQ/NHIcC/Dnp4dCljHeFjH1BtS/66+jntpgSNOO4jh5AKFLtBao/U97PKB3mMmgp0LW
         JZ2yQrAMeCqYVkB9Hlhk1DEJjJ6u4WWl9Ygf5l3TrjtmCz/oVb6+S7HglN6tagfGxl6P
         fAb55ohIPM27dTcuQ3XDwx8z347JvBkmj8Ctp8oGlS5YPJBSwx2iMqnV/1HlJG/y8SzK
         2/aA==
X-Gm-Message-State: AFqh2kqA56hMg5crA/7i0mnc6sciV9IMVFCmgm5tsIlyTI7rPWqnYGX7
        xdTDn7vs6SQztZdNzCLWVxk=
X-Google-Smtp-Source: AMrXdXs5On0M3f4/aKhwMNcmr599cWo1FN/AfrQme8wqoc6MdhHbvN2y6A4l+MtC5mcVnCy6EuF59Q==
X-Received: by 2002:a17:902:c10d:b0:185:441e:4cfc with SMTP id 13-20020a170902c10d00b00185441e4cfcmr9451532pli.44.1674082505088;
        Wed, 18 Jan 2023 14:55:05 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:22ae:3ae3:fde6:2308])
        by smtp.gmail.com with ESMTPSA id u7-20020a17090341c700b00186e34524e3sm23649466ple.136.2023.01.18.14.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 14:55:04 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v3 6/9] scsi_debug: Support configuring the maximum segment size
Date:   Wed, 18 Jan 2023 14:54:44 -0800
Message-Id: <20230118225447.2809787-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.0.246.g2a6d74b583-goog
In-Reply-To: <20230118225447.2809787-1-bvanassche@acm.org>
References: <20230118225447.2809787-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Add a kernel module parameter for configuring the maximum segment size.
This patch enables testing SCSI support for segments smaller than the
page size.

Cc: Doug Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8553277effb3..d09f05b440ba 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -752,6 +752,7 @@ static int sdebug_host_max_queue;	/* per host */
 static int sdebug_lowest_aligned = DEF_LOWEST_ALIGNED;
 static int sdebug_max_luns = DEF_MAX_LUNS;
 static int sdebug_max_queue = SDEBUG_CANQUEUE;	/* per submit queue */
+static unsigned int sdebug_max_segment_size = BLK_MAX_SEGMENT_SIZE;
 static unsigned int sdebug_medium_error_start = OPT_MEDIUM_ERR_ADDR;
 static int sdebug_medium_error_count = OPT_MEDIUM_ERR_NUM;
 static atomic_t retired_max_queue;	/* if > 0 then was prior max_queue */
@@ -5205,6 +5206,11 @@ static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 	if (sdebug_verbose)
 		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+
+	if (sdebug_max_segment_size < PAGE_SIZE)
+		blk_queue_flag_set(QUEUE_FLAG_SUB_PAGE_SEGMENTS,
+				   sdp->request_queue);
+
 	return 0;
 }
 
@@ -5841,6 +5847,7 @@ module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IRUGO);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int,
@@ -5917,6 +5924,7 @@ MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
+MODULE_PARM_DESC(max_segment_size, "max bytes in a single segment");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
@@ -6920,6 +6928,12 @@ static int __init scsi_debug_init(void)
 		return -EINVAL;
 	}
 
+	if (sdebug_max_segment_size < SECTOR_SIZE) {
+		pr_err("invalid max_segment_size %d\n",
+		       sdebug_max_segment_size);
+		return -EINVAL;
+	}
+
 	switch (sdebug_dif) {
 	case T10_PI_TYPE0_PROTECTION:
 		break;
@@ -7816,6 +7830,7 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdebug_driver_template.can_queue = sdebug_max_queue;
 	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
+	sdebug_driver_template.max_segment_size = sdebug_max_segment_size;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
