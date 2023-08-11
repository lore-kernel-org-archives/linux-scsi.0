Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE1CC04A94
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 21:36:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236967AbjHKVg1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 17:36:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236953AbjHKVgW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 17:36:22 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 678BB2684;
        Fri, 11 Aug 2023 14:36:22 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1bc34b32785so17987205ad.3;
        Fri, 11 Aug 2023 14:36:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691789782; x=1692394582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1sJsHjb25Up82wy0+rLFEE09ikEWVEcaOgckYbsEWo=;
        b=ce7RHME4s/VP9AWSKWT+EUFev5PealTv5akMS69gkdmon1cTTo2FR1bWdXtoUV0zBo
         GCioN4K+IMeFJHtD50r7YD5b1on6fHV9/8AavcxsyBdmWEMSbjghDWSXp24OCAbjiV43
         ALQroklZLiO7g4pq8cyvWrOcZBWe+1169gJKc0MkuAO5O7wEmRmqrxYzTy08PH/SV3mD
         zvtfoXGe8jX9Swuz/AfUrQLwK06DPhyVOa7+5VXCevAB9HY58tXthhovccmrlXpGOi6j
         iBLEgUL6x0DMWoW25RSNLWXmNmNewdeySyVGvBAxmYmx30v3A2OD3dPP+iz1COroTf2o
         zHoA==
X-Gm-Message-State: AOJu0Yzcu3p3MfL60IjFY85bmXIxfJ2jg2nd764JFItHu6st+G5CKDPc
        TuVbTsKylm0RyQ2ViTyGvns2cCwq928=
X-Google-Smtp-Source: AGHT+IG8c4wGJtGRdc1Rjch42EG34wEZInEi1sxfwXp9Xv05f/OHlhxQDfJ2e4tcBd6Te7BSleLTmA==
X-Received: by 2002:a17:902:9009:b0:1bb:f1d9:432e with SMTP id a9-20020a170902900900b001bbf1d9432emr2637854plp.37.1691789781787;
        Fri, 11 Aug 2023 14:36:21 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:cdd8:4c3:2f3c:adea])
        by smtp.gmail.com with ESMTPSA id c10-20020a170903234a00b001b89c313185sm4394865plh.205.2023.08.11.14.36.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 14:36:21 -0700 (PDT)
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
Subject: [PATCH v8 6/9] scsi: scsi_debug: Support disabling zone write locking
Date:   Fri, 11 Aug 2023 14:35:40 -0700
Message-ID: <20230811213604.548235-7-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230811213604.548235-1-bvanassche@acm.org>
References: <20230811213604.548235-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test not using zone write locking by supporting
disabling zone write locking in the scsi_debug driver.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <dlemoal@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0af50501f9..c44c523bde2c 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -832,6 +832,7 @@ static int dix_reads;
 static int dif_errors;
 
 /* ZBC global data */
+static bool sdeb_no_zwrl;
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
+	if (sdeb_no_zwrl)
+		q->limits.driver_preserves_write_order = true;
 	return 0;
 }
 
@@ -5738,6 +5743,7 @@ module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
 module_param_named(no_rwlock, sdebug_no_rwlock, bool, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
+module_param_named(no_zone_write_lock, sdeb_no_zwrl, bool, S_IRUGO);
 module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
 module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
@@ -5812,6 +5818,8 @@ MODULE_PARM_DESC(ndelay, "response delay in nanoseconds (def=0 -> ignore)");
 MODULE_PARM_DESC(no_lun_0, "no LU number 0 (def=0 -> have lun 0)");
 MODULE_PARM_DESC(no_rwlock, "don't protect user data reads+writes (def=0)");
 MODULE_PARM_DESC(no_uld, "stop ULD (e.g. sd driver) attaching (def=0))");
+MODULE_PARM_DESC(no_zone_write_lock,
+		 "Disable serialization of zoned writes (def=0)");
 MODULE_PARM_DESC(num_parts, "number of partitions(def=0)");
 MODULE_PARM_DESC(num_tgts, "number of targets per host to simulate(def=1)");
 MODULE_PARM_DESC(opt_blks, "optimal transfer length in blocks (def=1024)");
