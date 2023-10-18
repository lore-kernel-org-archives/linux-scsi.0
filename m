Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 277F4C41513
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Oct 2023 17:57:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232821AbjJRR5A (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Oct 2023 13:57:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232659AbjJRR4s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Oct 2023 13:56:48 -0400
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B63B12F;
        Wed, 18 Oct 2023 10:56:40 -0700 (PDT)
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-581ed744114so750129eaf.0;
        Wed, 18 Oct 2023 10:56:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697651799; x=1698256599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=035k58Gc0xjZLYCOymyww+e8cIPTj80YBwmkGqX/6yA=;
        b=eNcF/r2oh/tJYcuiuzSjJhzm35WwfZPAYuX6UZxKpOgwzfYtd95/mqyZm6q0pANpFR
         ghzhJrwJpBTrwe/LIir/cmpDCYZv4tj8btRypMfYf0teKEkz8MfNSeLcHzRoQ1MblUqR
         uUBBviUakgjQsTKekBUbuOIG53hkqn2t3Nc3Jc9mYi9nO20rah2KLPduXeyNCWLm9RaH
         2dEy27CSJzAeT9jMzSCpPJVEqF3YD94w30csk65VYenIKRyXpBLXog25lhCtAvlgsVOp
         XtS3MlpPqy+skcfQbaqZglHi74/vSbgZAkL23z9I8P7cTCmQOak2Dkd9P0ikvAhlb1Yw
         fmWQ==
X-Gm-Message-State: AOJu0Yw9Zf/xwpAq1XNL97BxNEc4mNqPWX2H3IPpMRZCEFF+hhQnuySY
        KUVTxikwXKVrV9iUz2tfYbY=
X-Google-Smtp-Source: AGHT+IFwoWBuwBEsyPNdpDkTWGLbT4dcp55zLUuEJdwLdyVStxzW14WP/OWThzFA3AheRDVR8JaA9g==
X-Received: by 2002:a05:6358:3a0f:b0:166:f348:a8b3 with SMTP id g15-20020a0563583a0f00b00166f348a8b3mr1954618rwe.28.1697651799305;
        Wed, 18 Oct 2023 10:56:39 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:66c1:dd00:1e1e:add3])
        by smtp.gmail.com with ESMTPSA id p15-20020aa7860f000000b00690cd981652sm3628612pfn.61.2023.10.18.10.56.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Oct 2023 10:56:38 -0700 (PDT)
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
Subject: [PATCH v13 11/18] scsi: scsi_debug: Add the preserves_write_order module parameter
Date:   Wed, 18 Oct 2023 10:54:33 -0700
Message-ID: <20231018175602.2148415-12-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
In-Reply-To: <20231018175602.2148415-1-bvanassche@acm.org>
References: <20231018175602.2148415-1-bvanassche@acm.org>
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
