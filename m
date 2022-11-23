Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6428AC433FE
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Nov 2022 20:58:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbiKWU6Z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Nov 2022 15:58:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239354AbiKWU6S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Nov 2022 15:58:18 -0500
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B7EB140DC;
        Wed, 23 Nov 2022 12:58:17 -0800 (PST)
Received: by mail-pl1-f181.google.com with SMTP id 4so17747258pli.0;
        Wed, 23 Nov 2022 12:58:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RFVPNR8S50CoEUmmic/+TdXIVTdXYTFAywePSuWS/vg=;
        b=uggAH6eiYpVqABs5toRVcVUFtTu5sejgLcGLGSOPOvrd7C3jPoiGdKTx/vMN0tV4d+
         /AvArV8h0V9pM2YOYOsNS8AqDVo1ausneXo+s/LedLg4mvnz3zDUMU+oR1bDFccgavs8
         5d8GIZUULX+1QLnrc6e6cQWEVdnaY7l1j8NMWP5ITRrhXzIJtNFL9oNv8lS7qBqnatZO
         HQFYk+2R9FZKCDJRwbLF3vkr06gP/Pck5lT5PUyoTtfYksh4sdOtGowWUyqKynhQiYF4
         3g9QaftxiJhxLzZKGpe65DaA+Wn+f3gwioH3H2XbJC6L1fDTL/z0awHF1MBMZSQdrt8L
         eC2g==
X-Gm-Message-State: ANoB5pnei9wxPWqHaj7Efihin7QLeehVBjes/IF+zhI64ppZ52ke7MOF
        SkKxt9kQce99hHgqLmZwDndGjs7v1Lc=
X-Google-Smtp-Source: AA0mqf5yS+Nq0J4bdlyuZeBTsZ9+CAHVtHH1wpeSDUq/JdzeDl/ju/41d+RC1SbhEDycEC1J6Tyt+w==
X-Received: by 2002:a17:902:b101:b0:188:abb9:288 with SMTP id q1-20020a170902b10100b00188abb90288mr12659090plr.123.1669237096711;
        Wed, 23 Nov 2022 12:58:16 -0800 (PST)
Received: from bvanassche-glaptop2.roam.corp.google.com ([2601:642:4c02:686d:4311:4764:eee7:ac6d])
        by smtp.gmail.com with ESMTPSA id i89-20020a17090a3de200b0020b2082e0acsm1858809pjc.0.2022.11.23.12.58.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 12:58:15 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Doug Gilbert <dgilbert@interlog.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH v2 7/8] scsi_debug: Support configuring the maximum segment size
Date:   Wed, 23 Nov 2022 12:57:39 -0800
Message-Id: <20221123205740.463185-8-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.584.g0f3c55d4c2-goog
In-Reply-To: <20221123205740.463185-1-bvanassche@acm.org>
References: <20221123205740.463185-1-bvanassche@acm.org>
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
 drivers/scsi/scsi_debug.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index bebda917b138..ea8f762c55c3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -770,6 +770,7 @@ static int sdebug_sector_size = DEF_SECTOR_SIZE;
 static int sdeb_tur_ms_to_ready = DEF_TUR_MS_TO_READY;
 static int sdebug_virtual_gb = DEF_VIRTUAL_GB;
 static int sdebug_vpd_use_hostno = DEF_VPD_USE_HOSTNO;
+static unsigned int sdebug_max_segment_size = -1U;
 static unsigned int sdebug_lbpu = DEF_LBPU;
 static unsigned int sdebug_lbpws = DEF_LBPWS;
 static unsigned int sdebug_lbpws10 = DEF_LBPWS10;
@@ -5851,6 +5852,7 @@ module_param_named(ndelay, sdebug_ndelay, int, S_IRUGO | S_IWUSR);
 module_param_named(no_lun_0, sdebug_no_lun_0, int, S_IRUGO | S_IWUSR);
 module_param_named(no_rwlock, sdebug_no_rwlock, bool, S_IRUGO | S_IWUSR);
 module_param_named(no_uld, sdebug_no_uld, int, S_IRUGO);
+module_param_named(max_segment_size, sdebug_max_segment_size, uint, S_IRUGO);
 module_param_named(num_parts, sdebug_num_parts, int, S_IRUGO);
 module_param_named(num_tgts, sdebug_num_tgts, int, S_IRUGO | S_IWUSR);
 module_param_named(opt_blks, sdebug_opt_blks, int, S_IRUGO);
@@ -7815,6 +7817,7 @@ static int sdebug_driver_probe(struct device *dev)
 
 	sdebug_driver_template.can_queue = sdebug_max_queue;
 	sdebug_driver_template.cmd_per_lun = sdebug_max_queue;
+	sdebug_driver_template.max_segment_size = sdebug_max_segment_size;
 	if (!sdebug_clustering)
 		sdebug_driver_template.dma_boundary = PAGE_SIZE - 1;
 
