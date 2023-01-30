Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17D7CC636CD
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Jan 2023 21:27:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231134AbjA3V1R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Jan 2023 16:27:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjA3V1Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jan 2023 16:27:16 -0500
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378DB47434;
        Mon, 30 Jan 2023 13:27:15 -0800 (PST)
Received: by mail-pl1-f172.google.com with SMTP id p24so13022748plw.11;
        Mon, 30 Jan 2023 13:27:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SldGN1dTvTGuXHNWg2lfvw9/Jk1AJrvi4a6o1b8Gk+4=;
        b=FaQKMH6v5RKuz/jr+Hq5OGGHmH2hzu//7knzMSejFc5YOhCQR+1nh7qws6CiQFQxPM
         8zxxyvmqtqusg5+8VJJ4dmol1ioYYXgBqj/s5QMJ1WcUq5hD7n7VZ0o8ptvzzNTJQ8OA
         a5DP6zRyn1x2uMkrEkLS2+T+ErPy5nRS3IBm0H9Arps5bkNggnbJgJYK+068u0vzyOp/
         l0OiiW80KnWlNnMckQAYbFMv8LVXsetW0TUJQ9UxlF0P/ioq26lID7mQSbuXMzgNiTOk
         ReIIGaYZ6YnswliXm7luQSZkKSYze4zSKHhwFiDZpeAUP7gDERw/aHezz44eJhe7IQc2
         ZvEw==
X-Gm-Message-State: AO0yUKV8Q/IfL4Ot29YdTMj9zdBJXdwatBU451P++Wdg7ad06QJc5ZI+
        mNu2hrkcHrM7zRhCNduYxuY=
X-Google-Smtp-Source: AK7set/xOe7eZz8L05C1PTkr4NN1MCrz5XuzkPY+weBmhgTZmsWgWvpzdZ0//FREt41xOwYf5wMjfQ==
X-Received: by 2002:a17:902:c7cd:b0:196:5852:4092 with SMTP id r13-20020a170902c7cd00b0019658524092mr6758166pla.56.1675114034647;
        Mon, 30 Jan 2023 13:27:14 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:5016:3bcd:59fe:334b])
        by smtp.gmail.com with ESMTPSA id u18-20020a170902e5d200b00196087a3d7csm7425613plf.77.2023.01.30.13.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jan 2023 13:27:13 -0800 (PST)
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
Subject: [PATCH v4 6/7] scsi_debug: Support configuring the maximum segment size
Date:   Mon, 30 Jan 2023 13:26:55 -0800
Message-Id: <20230130212656.876311-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.39.1.456.gfc5497dd1b-goog
In-Reply-To: <20230130212656.876311-1-bvanassche@acm.org>
References: <20230130212656.876311-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 8553277effb3..603c9faac56f 100644
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
@@ -5841,6 +5842,7 @@ module_param_named(lowest_aligned, sdebug_lowest_aligned, int, S_IRUGO);
 module_param_named(lun_format, sdebug_lun_am_i, int, S_IRUGO | S_IWUSR);
 module_param_named(max_luns, sdebug_max_luns, int, S_IRUGO | S_IWUSR);
 module_param_named(max_queue, sdebug_max_queue, int, S_IRUGO | S_IWUSR);
+module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IRUGO);
 module_param_named(medium_error_count, sdebug_medium_error_count, int,
 		   S_IRUGO | S_IWUSR);
 module_param_named(medium_error_start, sdebug_medium_error_start, int,
@@ -5917,6 +5919,7 @@ MODULE_PARM_DESC(lowest_aligned, "lowest aligned lba (def=0)");
 MODULE_PARM_DESC(lun_format, "LUN format: 0->peripheral (def); 1 --> flat address method");
 MODULE_PARM_DESC(max_luns, "number of LUNs per target to simulate(def=1)");
 MODULE_PARM_DESC(max_queue, "max number of queued commands (1 to max(def))");
+MODULE_PARM_DESC(max_segment_size, "max bytes in a single segment");
 MODULE_PARM_DESC(medium_error_count, "count of sectors to return follow on MEDIUM error");
 MODULE_PARM_DESC(medium_error_start, "starting sector number to return MEDIUM error");
 MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
@@ -7816,6 +7819,7 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdebug_driver_template.can_queue = sdebug_max_queue;
 	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
+	sdebug_driver_template.max_segment_size = sdebug_max_segment_size;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
