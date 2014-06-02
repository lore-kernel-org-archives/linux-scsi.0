From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 5/6] scsi: increase upper limit for max_sectors
Date: Mon,  2 Jun 2014 22:56:48 +0900
Message-ID: <1401717409-5236-6-git-send-email-akinobu.mita@gmail.com>
References: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:41966 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578AbaFBN5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 09:57:18 -0400
Received: by mail-pd0-f180.google.com with SMTP id y13so3458046pdi.11
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 06:57:17 -0700 (PDT)
In-Reply-To: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

max_sectors in struct Scsi_Host specifies maximum number of sectors
allowed in a single SCSI command.  The data type of max_sectors is
unsigned short, so the maximum transfer length per SCSI command is
limited to less than 256MB in 4096-bytes sector size. (0xffff * 4096)

This commit increases the SCSI mid level's limitation for max_sectors
upto the block layer's limitation for max_hw_sectors by extending the
data type of max_sectors in struct Scsi_Host and scsi_host_template,
so that SCSI lower level drivers can specify more than 0xffff.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
sg and sd changes are splitted into another patches.  Otherwise,
no change from previous version.

 include/scsi/scsi_host.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 94844fc..db7d8bd 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -408,7 +408,7 @@ struct scsi_host_template {
 	/*
 	 * Set this if the host adapter has limitations beside segment count.
 	 */
-	unsigned short max_sectors;
+	unsigned int max_sectors;
 
 	/*
 	 * DMA scatter gather segment boundary limit. A segment crossing this
@@ -652,7 +652,7 @@ struct Scsi_Host {
 	short cmd_per_lun;
 	short unsigned int sg_tablesize;
 	short unsigned int sg_prot_tablesize;
-	short unsigned int max_sectors;
+	unsigned int max_sectors;
 	unsigned long dma_boundary;
 	/* 
 	 * Used to assign serial numbers to the cmds.
-- 
1.9.1

