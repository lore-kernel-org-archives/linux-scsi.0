Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94F89C27C43
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Aug 2023 19:55:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345946AbjHPTz0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Aug 2023 15:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345944AbjHPTzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Aug 2023 15:55:19 -0400
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F597E56;
        Wed, 16 Aug 2023 12:55:18 -0700 (PDT)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-55b0e7efb1cso4096918a12.1;
        Wed, 16 Aug 2023 12:55:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692215718; x=1692820518;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=f1sJsHjb25Up82wy0+rLFEE09ikEWVEcaOgckYbsEWo=;
        b=NYoKrxeNmKAe+LRndYf49EUfUJfUCj+Nhx9pHinsctwRB7jfe7z/nrGETOS4sFGfg0
         EvpMiKCDlVi+LDXH3glwpWtqVVH9xwqMZfq69e5a2ooU854WPFfp6qJgNib+IWQxScA+
         myAvMt8BaQCTVCx25ZRT5XdBmp3gpMGzR887PgDlAuOkzlbQZKnLcs4x/dWYfYIC5Gee
         MoiBtaHa5LTX9A6mtm8PPcioQrpTQk5sJYZAZrahQVJEIZRA92hFzRgfvynIg/t8rGqL
         QYlNBgzkThvAieAhA9xaqczGQpGT4aTWms4gtrAOL89krp1qqIYLpGvJNwb5wCkuHfaG
         T1zQ==
X-Gm-Message-State: AOJu0YwEc1AS8xy8Qj9LeR9W2uvLeikHoZJ+g15x9ozq2QyaoZJaoIWY
        NuSEp301JPaQATwgX2n/ZLU=
X-Google-Smtp-Source: AGHT+IF3d32FeeP5+cAcJ4ILETznyQKerW76vwvgMk9VMZ64yPLkvLT6Be4pXoHC7jcPaBcq1Pjdxg==
X-Received: by 2002:a05:6a00:1389:b0:688:7ccb:5ad1 with SMTP id t9-20020a056a00138900b006887ccb5ad1mr3236591pfg.1.1692215717707;
        Wed, 16 Aug 2023 12:55:17 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7141:e456:f574:7de0])
        by smtp.gmail.com with ESMTPSA id r26-20020a62e41a000000b0068890c19c49sm1588508pfh.180.2023.08.16.12.55.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 16 Aug 2023 12:55:17 -0700 (PDT)
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
Subject: [PATCH v9 09/17] scsi: scsi_debug: Support disabling zone write locking
Date:   Wed, 16 Aug 2023 12:53:21 -0700
Message-ID: <20230816195447.3703954-10-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.694.ge786442a9b-goog
In-Reply-To: <20230816195447.3703954-1-bvanassche@acm.org>
References: <20230816195447.3703954-1-bvanassche@acm.org>
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
