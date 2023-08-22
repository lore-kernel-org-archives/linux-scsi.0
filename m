Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92B81EE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 19:19:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbjHVTTM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 15:19:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230087AbjHVTTL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 15:19:11 -0400
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4103BE5E;
        Tue, 22 Aug 2023 12:19:02 -0700 (PDT)
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso2832203a12.1;
        Tue, 22 Aug 2023 12:19:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692731941; x=1693336741;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=035k58Gc0xjZLYCOymyww+e8cIPTj80YBwmkGqX/6yA=;
        b=W1vR831sKOTl9lLSpxVVNq/cfnuZnijLJzsR3ZbfbAmSPhHDXUDy+GFKrGupktxbeL
         qDc0EsAOFANkTQYRNY0BWvskaOwJj32s1d1ecJFFP12k8nBiFHKAZqfuqf/VIprB1PAb
         lkrhDPjE2ss6sC71367R+WZYVZgAuwcXnR2UHiQdyke0KJI7xVw9ArrdePb8SLF3nnWS
         R7dx9VKMj1FM4TA5Lx0JRa4DOGiOyHNYIoYkXq2mRke8uUyIIqTczWqh/AX3tx+eAtrh
         K63OWSZA+RxFoWtlLWIfe5H91RNNIImzjDzG/+FaXGsKpAdI4RdV7/pBBKGOmqSeWiRe
         8Ntw==
X-Gm-Message-State: AOJu0YyKHZSoLp9LbIhgHYtK/4muYTPzevC49wmGmsdf5pvGMPfLO9a3
        1WXS7ya9agwGBZpjh496AFQ=
X-Google-Smtp-Source: AGHT+IF2x3gYFSOiPfJrEvGl5FGoBt1bgNbMH79VjAYmJGr1KXjj1AGjYkquukx904anzKhR2nWtvQ==
X-Received: by 2002:a17:90a:88:b0:26d:2086:8c96 with SMTP id a8-20020a17090a008800b0026d20868c96mr7557378pja.43.1692731941546;
        Tue, 22 Aug 2023 12:19:01 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:88be:bf57:de29:7cc])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a414b00b002696bd123e4sm8081632pjg.46.2023.08.22.12.19.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 22 Aug 2023 12:19:01 -0700 (PDT)
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
Subject: [PATCH v11 09/16] scsi: scsi_debug: Add the preserves_write_order module parameter
Date:   Tue, 22 Aug 2023 12:17:04 -0700
Message-ID: <20230822191822.337080-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.rc1.204.g551eb34607-goog
In-Reply-To: <20230822191822.337080-1-bvanassche@acm.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Zone write locking is not used for zoned devices if the block driver
reports that it preserves the order of write commands. Make it easier to
test not using zone write locking by adding support for setting the
driver_preserves_write_order flag.

Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0af50501f9..1ea4925d2c2f 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -832,6 +832,7 @@ static int dix_reads;
 static int dif_errors;
 
 /* ZBC global data */
+static bool sdeb_preserves_write_order;
 static bool sdeb_zbc_in_use;	/* true for host-aware and host-managed disks */
 static int sdeb_zbc_zone_cap_mb;
 static int sdeb_zbc_zone_size_mb;
@@ -5138,9 +5139,13 @@ static struct sdebug_dev_info *find_build_dev_info(struct scsi_device *sdev)
 
 static int scsi_debug_slave_alloc(struct scsi_device *sdp)
 {
+	struct request_queue *q = sdp->request_queue;
+
 	if (sdebug_verbose)
 		pr_info("slave_alloc <%u %u %u %llu>\n",
 		       sdp->host->host_no, sdp->channel, sdp->id, sdp->lun);
+	if (sdeb_preserves_write_order)
+		q->limits.driver_preserves_write_order = true;
 	return 0;
 }
 
@@ -5755,6 +5760,8 @@ module_param_named(statistics, sdebug_statistics, bool, S_IRUGO | S_IWUSR);
 module_param_named(strict, sdebug_strict, bool, S_IRUGO | S_IWUSR);
 module_param_named(submit_queues, submit_queues, int, S_IRUGO);
 module_param_named(poll_queues, poll_queues, int, S_IRUGO);
+module_param_named(preserves_write_order, sdeb_preserves_write_order, bool,
+		   S_IRUGO);
 module_param_named(tur_ms_to_ready, sdeb_tur_ms_to_ready, int, S_IRUGO);
 module_param_named(unmap_alignment, sdebug_unmap_alignment, int, S_IRUGO);
 module_param_named(unmap_granularity, sdebug_unmap_granularity, int, S_IRUGO);
@@ -5812,6 +5819,8 @@ MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
+MODULE_PARM_DESC(preserves_write_order,
+		 "Whether or not to inform the block layer that this driver preserves the order of WRITE commands (def=0)");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
