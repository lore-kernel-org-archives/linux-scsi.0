Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29CC9C001DB
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Aug 2023 15:48:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232143AbjHDPsk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Aug 2023 11:48:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjHDPsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Aug 2023 11:48:35 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B1A849CC;
        Fri,  4 Aug 2023 08:48:34 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-686bc261111so1691387b3a.3;
        Fri, 04 Aug 2023 08:48:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691164114; x=1691768914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iKserUc7+qK0U76dK5VQGcFoPHl5fU7xJij7hQDUDFE=;
        b=L/qrKScd1HOaP9tfNf66d3acO7IJ3nsxdW0UvhOXplUZcD9ga3Y5GmS42WNLNYYn7K
         7WMZM4ETQv9YtR/trKf7XyBcDIWLMDREXa2X6WsgLx6T8v7TAxHXBxEqudJId7sfZc+e
         RInv8TnFGX/kJwanDm6mdtz5gRoA5WpALot+FT2Nct4CGsx8BQYP1Ntsr3kqlMEa/4J/
         b8wp2hGdn9nlkZCNOFHyelobxh+7BUeTayKB/noZtu8DJr42IiNkGHGWEDjyr7gsyTev
         DCRZTshJRL5cOdoCSVnKGEAVbMBQ4VFo1AoTffcwpLW/W/lwmxSrUp2B0izvWMeb+XhN
         4oCw==
X-Gm-Message-State: AOJu0YyqeLB+ksyIpKp0a3n6J0qgM1L3A5ndgrMq6RXbDjMxj3e4MGNZ
        ZVGHs3iA2rCfc+uO4H8eo60jTTGlRVs=
X-Google-Smtp-Source: AGHT+IHq/LODUFwVPhm9/l3MznRO5BfLb9qFl2e4yClrfOn1hQJLpg7yicoblQURkA/Caa/HbdJHHA==
X-Received: by 2002:a05:6a00:24c5:b0:687:542b:f11 with SMTP id d5-20020a056a0024c500b00687542b0f11mr2290922pfv.25.1691164113763;
        Fri, 04 Aug 2023 08:48:33 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:4af5:d063:a66d:403b])
        by smtp.gmail.com with ESMTPSA id h8-20020a62b408000000b00640ddad2e0dsm1760839pfn.47.2023.08.04.08.48.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Aug 2023 08:48:33 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: [PATCH v6 4/7] scsi: scsi_debug: Support disabling zone write locking
Date:   Fri,  4 Aug 2023 08:48:02 -0700
Message-ID: <20230804154821.3232094-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.41.0.640.ga95def55d0-goog
In-Reply-To: <20230804154821.3232094-1-bvanassche@acm.org>
References: <20230804154821.3232094-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make it easier to test handling of QUEUE_FLAG_NO_ZONE_WRITE_LOCK by
adding support for setting this flag for scsi_debug request queues.

Cc: Martin K. Petersen <martin.petersen@oracle.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 9c0af50501f9..57c6242bfb26 100644
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
+		blk_queue_flag_set(QUEUE_FLAG_NO_ZONE_WRITE_LOCK, q);
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
