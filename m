Return-Path: <SRS0=19hD=BA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E63DCC433EC
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:55:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C02B822CB3
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jul 2020 10:55:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bx+EqnfP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729486AbgGUKzr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 06:55:47 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57087 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729359AbgGUKzr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 06:55:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595328945;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+3seadylwcW1rKfz25C5YjNc+LNMmMOgRxWnx3VfrYM=;
        b=Bx+EqnfPFCBbu0xN3hG3h//8K66M/FNnZzK44GNUzQyBEmZxh+IO63Zinv+cK2Tl/D14nx
        fLG3mTXGkQ79SPVvDqU3RaquRxGPD/Gg1TY2zaaHgY/Ftq/VA5AapUtE1befrc97eMrwDA
        qrAgfnSWKbDjjaTWeubld6Q6+yRRyPs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-YSjNVmjPOw2mHuqqn-p2Cw-1; Tue, 21 Jul 2020 06:55:42 -0400
X-MC-Unique: YSjNVmjPOw2mHuqqn-p2Cw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 07C091005504;
        Tue, 21 Jul 2020 10:55:39 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.35.206.163])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7482876216;
        Tue, 21 Jul 2020 10:55:26 +0000 (UTC)
From:   Maxim Levitsky <mlevitsk@redhat.com>
To:     linux-kernel@vger.kernel.org
Cc:     Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        linux-block@vger.kernel.org (open list:BLOCK LAYER),
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        linux-nvme@lists.infradead.org (open list:NVM EXPRESS DRIVER),
        linux-scsi@vger.kernel.org (open list:SCSI CDROM DRIVER),
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        linux-mmc@vger.kernel.org (open list:SONY MEMORYSTICK SUBSYSTEM),
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        nbd@other.debian.org (open list:NETWORK BLOCK DEVICE (NBD)),
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        virtualization@lists.linux-foundation.org (open list:VIRTIO CORE AND
        NET DRIVERS), "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>,
        Maxim Levitsky <mlevitsk@redhat.com>
Subject: [PATCH 10/10] block: scsi: sr: use blk_is_valid_logical_block_size
Date:   Tue, 21 Jul 2020 13:52:39 +0300
Message-Id: <20200721105239.8270-11-mlevitsk@redhat.com>
In-Reply-To: <20200721105239.8270-1-mlevitsk@redhat.com>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Plus some tiny refactoring.

Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
---
 drivers/scsi/sr.c | 31 +++++++++++++------------------
 1 file changed, 13 insertions(+), 18 deletions(-)

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index 0c4aa4665a2f9..0e96338029310 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -866,31 +866,26 @@ static void get_sectorsize(struct scsi_cd *cd)
 			cd->capacity = max_t(long, cd->capacity, last_written);
 
 		sector_size = get_unaligned_be32(&buffer[4]);
-		switch (sector_size) {
-			/*
-			 * HP 4020i CD-Recorder reports 2340 byte sectors
-			 * Philips CD-Writers report 2352 byte sectors
-			 *
-			 * Use 2k sectors for them..
-			 */
-		case 0:
-		case 2340:
-		case 2352:
+
+		/*
+		 * HP 4020i CD-Recorder reports 2340 byte sectors
+		 * Philips CD-Writers report 2352 byte sectors
+		 *
+		 * Use 2k sectors for them..
+		 */
+
+		if (!sector_size || sector_size == 2340 || sector_size == 2352)
 			sector_size = 2048;
-			/* fall through */
-		case 2048:
-			cd->capacity *= 4;
-			/* fall through */
-		case 512:
-			break;
-		default:
+
+		cd->capacity *= (sector_size >> SECTOR_SHIFT);
+
+		if (!blk_is_valid_logical_block_size(sector_size)) {
 			sr_printk(KERN_INFO, cd,
 				  "unsupported sector size %d.", sector_size);
 			cd->capacity = 0;
 		}
 
 		cd->device->sector_size = sector_size;
-
 		/*
 		 * Add this so that we have the ability to correctly gauge
 		 * what the device is capable of.
-- 
2.26.2

