Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5438CA9ED2
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:12:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C8AF321897
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 01:12:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727736AbfKBBMR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 21:12:17 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:51642 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726947AbfKBBMR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 21:12:17 -0400
Received: by kvm5.telegraphics.com.au (Postfix, from userid 502)
        id B6FE429915; Fri,  1 Nov 2019 21:12:15 -0400 (EDT)
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     "Michael Schmitz" <schmitzmic@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Jonathan Corbet" <corbet@lwn.net>,
        "Bartlomiej Zolnierkiewicz" <b.zolnierkie@samsung.com>,
        "Jens Axboe" <axboe@kernel.dk>,
        "Viresh Kumar" <vireshk@kernel.org>,
        "Oliver Neukum" <oneukum@suse.com>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        usb-storage@lists.one-eyed-alien.net, linux-doc@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-usb@vger.kernel.org
Message-Id: <b4779b7a6563f6bd8d259ee457871c1c463c420e.1572656814.git.fthain@telegraphics.com.au>
In-Reply-To: <cover.1572656814.git.fthain@telegraphics.com.au>
References: <cover.1572656814.git.fthain@telegraphics.com.au>
From:   Finn Thain <fthain@telegraphics.com.au>
Subject: [PATCH 2/2] scsi: Clean up SG_NONE
Date:   Sat, 02 Nov 2019 12:06:54 +1100
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Remove SG_NONE and a related misleading comment. Update documentation.

This patch does not affect behaviour as zero initialization is redundant.

Cc: Jonathan Corbet <corbet@lwn.net>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Viresh Kumar <vireshk@kernel.org>
Cc: Oliver Neukum <oneukum@suse.com>
Cc: Alan Stern <stern@rowland.harvard.edu>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: usb-storage@lists.one-eyed-alien.net
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
---
 Documentation/scsi/scsi_mid_low_api.txt |  3 ++-
 drivers/ata/pata_arasan_cf.c            |  1 -
 drivers/scsi/atp870u.c                  |  2 +-
 drivers/usb/storage/uas.c               |  1 -
 include/scsi/scsi_host.h                | 13 -------------
 5 files changed, 3 insertions(+), 17 deletions(-)

diff --git a/Documentation/scsi/scsi_mid_low_api.txt b/Documentation/scsi/scsi_mid_low_api.txt
index c1dd4939f4ae..2a4be1c3e6db 100644
--- a/Documentation/scsi/scsi_mid_low_api.txt
+++ b/Documentation/scsi/scsi_mid_low_api.txt
@@ -1084,7 +1084,8 @@ of interest:
                    commands to the adapter.
     this_id      - scsi id of host (scsi initiator) or -1 if not known
     sg_tablesize - maximum scatter gather elements allowed by host.
-                   0 implies scatter gather not supported by host
+                   Set this to SG_ALL or less to avoid chained SG lists.
+                   Must be at least 1.
     max_sectors  - maximum number of sectors (usually 512 bytes) allowed
                    in a single SCSI command. The default value of 0 leads
                    to a setting of SCSI_DEFAULT_MAX_SECTORS (defined in
diff --git a/drivers/ata/pata_arasan_cf.c b/drivers/ata/pata_arasan_cf.c
index ebecab8c3f36..135173c8d138 100644
--- a/drivers/ata/pata_arasan_cf.c
+++ b/drivers/ata/pata_arasan_cf.c
@@ -219,7 +219,6 @@ struct arasan_cf_dev {
 
 static struct scsi_host_template arasan_cf_sht = {
 	ATA_BASE_SHT(DRIVER_NAME),
-	.sg_tablesize = SG_NONE,
 	.dma_boundary = 0xFFFFFFFFUL,
 };
 
diff --git a/drivers/scsi/atp870u.c b/drivers/scsi/atp870u.c
index e41f0bbdc9fd..c6a752309dda 100644
--- a/drivers/scsi/atp870u.c
+++ b/drivers/scsi/atp870u.c
@@ -1680,7 +1680,7 @@ static struct scsi_host_template atp870u_template = {
      .bios_param        	= atp870u_biosparam	/* biosparm */,
      .can_queue         	= qcnt			/* can_queue */,
      .this_id           	= 7			/* SCSI ID */,
-     .sg_tablesize      	= ATP870U_SCATTER	/*SG_ALL*/ /*SG_NONE*/,
+     .sg_tablesize      	= ATP870U_SCATTER	/*SG_ALL*/,
      .max_sectors		= ATP870U_MAX_SECTORS,
 };
 
diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
index bf80d6f81f58..fd9c0d2c111f 100644
--- a/drivers/usb/storage/uas.c
+++ b/drivers/usb/storage/uas.c
@@ -879,7 +879,6 @@ static struct scsi_host_template uas_host_template = {
 	.eh_abort_handler = uas_eh_abort_handler,
 	.eh_device_reset_handler = uas_eh_device_reset_handler,
 	.this_id = -1,
-	.sg_tablesize = SG_NONE,
 	.skip_settle_delay = 1,
 	.dma_boundary = PAGE_SIZE - 1,
 };
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 31e0d6ca1eba..d7cf9c7fecac 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -23,19 +23,6 @@ struct scsi_host_cmd_pool;
 struct scsi_transport_template;
 
 
-/*
- * The various choices mean:
- * NONE: Self evident.	Host adapter is not capable of scatter-gather.
- * ALL:	 Means that the host adapter module can do scatter-gather,
- *	 and that there is no limit to the size of the table to which
- *	 we scatter/gather data.  The value we set here is the maximum
- *	 single element sglist.  To use chained sglists, the adapter
- *	 has to set a value beyond ALL (and correctly use the chain
- *	 handling API.
- * Anything else:  Indicates the maximum number of chains that can be
- *	 used in one scatter-gather request.
- */
-#define SG_NONE 0
 #define SG_ALL	SG_CHUNK_SIZE
 
 #define MODE_UNKNOWN 0x00
-- 
2.23.0

