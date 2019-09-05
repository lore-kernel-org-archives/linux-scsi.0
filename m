Return-Path: <SRS0=/77Q=XA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFB40C3A5A5
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 93DEF21743
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Sep 2019 09:51:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="ZaFrLXNa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732596AbfIEJv4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Sep 2019 05:51:56 -0400
Received: from esa6.hgst.iphmx.com ([216.71.154.45]:25332 "EHLO
        esa6.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387610AbfIEJvx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Sep 2019 05:51:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1567677113; x=1599213113;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/XtlwHOsIPicnyo2flJ5KzL1vmCB4hpFdRCl5+DsDD4=;
  b=ZaFrLXNajUGEKwPIdZg601bnVY55rqLkeuSUuKJpqBGybaR9Z+k1Cnkg
   KhhiWkh0A9n2Hvi6tnQd+D1NBfI0DM9qTNzJfxpds06IAm6jnuECbgms4
   E05j5jaT6Cj23p7lsIO4gqz2S1cf5rPo42bM5ecREvxZk73J+fGHZexfW
   FJCG8tDwGnPa/Qr2yJ19XjjtNtMwSs6XL1xLeT1VdRt9Rn2TyqzToZgvU
   0PEwau2OcMWzBEr3xcA2oYxeTS66ip7q93CqySBx2r7J8RahNW14c2yUw
   lMhr6FAITONSsk8zQ6MUuqrxZB96w1sp0u6+Zhosgez6p/RFGF+kNmM7k
   w==;
IronPort-SDR: v4cAabHgIJyO4MVWVb2B1zhADh4GTxSoy/ug9c/XTQM6gYIBbMFuQpYu+lqXExik3XXZDVOJ3t
 jqiAsoWYTk7zaju5zsORHH+vftot3gE2l8/J5O92cSjJrdXbS2iDFGtLi5Ervu5y/FojQudlY3
 udYrfdU0IzJGuTsTnDtpXw3X/ohWJ4LVAwX4cEOPkR9DNAdwZIfXPRfZhmTfccovVaIZHt526E
 BI48QKt3Wmb9EDiasz4DrCGYcolGlorWbotgHk8C1PtXHN0MVOOFeGBe3pL2W1pMsvXEL9L11t
 EDA=
X-IronPort-AV: E=Sophos;i="5.64,470,1559491200"; 
   d="scan'208";a="119106283"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 05 Sep 2019 17:51:46 +0800
IronPort-SDR: hUlJUPcK66iQjuFAMR8oNMTDPNNpzVHWFHmLlYjeEG5foXKgwZPV2ygUWr9Nn2pzRHx/CtKT4l
 66t7sRUmIBZOu1jrRVZYBvwm6itE23RNSItS70Z7v7iMi7bxWlRrz1T+6f1YoW4J9WmZnvajG2
 ZJsyHEFv8eWX3cX2rXPfA7xlnsrX9SKsG7hgW1ly4WG1d9Qv5Nue7JHb7j//xU9q7JRBJgUYAE
 MJSnMdCEb5vv4REsv42rV/HIxU2L3jMSSjMfGXIo3UIhdEri4bFx1c39HvNAjAQwQPV3imAWsk
 zzGkzLsTCSlhhP51G1FcZIZS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Sep 2019 02:48:42 -0700
IronPort-SDR: PMcqYEJtk0jNIxalMYnj1tGVSoFhITi6da+9KU/BbwBavagIEJVYSrRDsTM+vRMVIhqb4doxaC
 kWs/cbz3itasjn4XhJExza74T8zJXrlVKgF16N2qLo9ED5Gpr/LnPa/himSsRWGYLYDjGCFtv0
 STrpHKMJiJS84SBMdTyKHRZHqd0C7HlprXT0V8ZnoE67PHSxG/6lbaaVjVLJ+ptkqjkjnY4g8Z
 ROg1ezQjpPJmmoeUX4o/5AB0aEA6jPX1G8VKMCa/3b1V6N5RrYlOG27+l4NgXPoMxhbwWl3Cag
 fWc=
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip01.wdc.com with ESMTP; 05 Sep 2019 02:51:46 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc:     Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v5 7/7] sd: Set ELEVATOR_F_ZBD_SEQ_WRITE for ZBC disks
Date:   Thu,  5 Sep 2019 18:51:35 +0900
Message-Id: <20190905095135.26026-8-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190905095135.26026-1-damien.lemoal@wdc.com>
References: <20190905095135.26026-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the helper blk_queue_required_elevator_features(), set the
elevator feature ELEVATOR_F_ZBD_SEQ_WRITE as required for the request
queue of SCSI ZBC disks.

This feature requirement can always be satisfied as the mq-deadline
elevator is always selected for in-kernel compilation when
CONFIG_BLK_DEV_ZONED (zoned block device support) is enabled.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sd_zbc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 367614f0e34f..de4019dc0f0b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -493,6 +493,8 @@ int sd_zbc_read_zones(struct scsi_disk *sdkp, unsigned char *buf)
 	blk_queue_chunk_sectors(sdkp->disk->queue,
 			logical_to_sectors(sdkp->device, zone_blocks));
 	blk_queue_flag_set(QUEUE_FLAG_ZONE_RESETALL, sdkp->disk->queue);
+	blk_queue_required_elevator_features(sdkp->disk->queue,
+					     ELEVATOR_F_ZBD_SEQ_WRITE);
 	nr_zones = round_up(sdkp->capacity, zone_blocks) >> ilog2(zone_blocks);
 
 	/* READ16/WRITE16 is mandatory for ZBC disks */
-- 
2.21.0

