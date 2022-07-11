Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41453C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:01:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiGKXBC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGKXBA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:01:00 -0400
Received: from mail-pf1-f179.google.com (mail-pf1-f179.google.com [209.85.210.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5EF05C944
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:59 -0700 (PDT)
Received: by mail-pf1-f179.google.com with SMTP id j3so5994528pfb.6
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MwViGzXbdResYrRh1SJJofBtxGgreKrPyJ8NRT/IJic=;
        b=mBvKPforcoSlEP5JaMSOa+Cw36mmxSxl9+TiVkA97l/GvvGlNwCxxFTMSVDqk6q2YX
         Vxuyh0Asffj5wu7Glnu29IyxYHbkR4QzUV3ERLvLrGzHUHB5fkq2oZBceWISevcbUrHE
         VJsOnxV7Boh7LA/+mRuwKnnGKpKWMUxUNTwCPaq/UQU4llaCnejuuaNbMklVue4aT+Ny
         FSMf0Q2JduDpQP9KDq9UdkwL0urwUGzbw1zhf5twrPNLFBwArKfLlNbRM7xr7PAqpbFL
         7aNhS1aMpBm7jH8Bu0D15lvjMSGqeVsqE9BYDJNSAYXZsEqENn9wZax+0sDXKC17Ori8
         1ZwA==
X-Gm-Message-State: AJIora/krFQR822tbgABeDKSjY1nZhlNDR8xSYoWISWFtm+6Cog3XPMb
        j9NVWOVQ+LFWsEy8cq5CcNv42ywf6wg=
X-Google-Smtp-Source: AGRyM1ueYScEI8ro4cqAyIvF5/5bGW88A6Gxna1d3SVOA++ypXjAHLNdWNCwCiUOxeCadi5jQXo8IQ==
X-Received: by 2002:a62:a50e:0:b0:528:cc50:82db with SMTP id v14-20020a62a50e000000b00528cc5082dbmr20735645pfm.43.1657580458990;
        Mon, 11 Jul 2022 16:00:58 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m6-20020a637d46000000b00411955c03e5sm4761886pgn.29.2022.07.11.16.00.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 16:00:58 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 2/3] scsi_debug: Make the READ CAPACITY response compliant with ZBC
Date:   Mon, 11 Jul 2022 16:00:50 -0700
Message-Id: <20220711230051.15372-3-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711230051.15372-1-bvanassche@acm.org>
References: <20220711230051.15372-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From ZBC-1:
* RC BASIS = 0: The RETURNED LOGICAL BLOCK ADDRESS field indicates the
  highest LBA of a contiguous range of zones that are not sequential write
  required zones starting with the first zone.
* RC BASIS = 1: The RETURNED LOGICAL BLOCK ADDRESS field indicates the LBA
  of the last logical block on the logical unit.

The current scsi_debug READ CAPACITY response does not comply with the above
if there are one or more sequential write required zones. Hence this patch.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Fixes: 64e14ece0700 ("scsi: scsi_debug: Implement ZBC host-aware emulation")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5a8efc328fb5..c5f4af774078 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -304,6 +304,7 @@ struct sdebug_dev_info {
 	unsigned int nr_exp_open;
 	unsigned int nr_closed;
 	unsigned int max_open;
+	unsigned int rc_basis:2;
 	ktime_t create_ts;	/* time since bootup that this device was created */
 	struct sdeb_zone_state *zstate;
 };
@@ -1901,6 +1902,8 @@ static int resp_readcap16(struct scsi_cmnd *scp,
 
 	arr[15] = sdebug_lowest_aligned & 0xff;
 
+	arr[12] |= devip->rc_basis << 4;
+
 	if (have_dif_prot) {
 		arr[12] = (sdebug_dif - 1) << 1; /* P_TYPE */
 		arr[12] |= 1; /* PROT_EN */
@@ -5107,10 +5110,12 @@ static int sdebug_device_create_zones(struct sdebug_dev_info *devip)
 			zsp->z_size =
 				min_t(u64, devip->zsize, capacity - zstart);
 		} else if ((zstart & (devip->zsize - 1)) == 0) {
-			if (devip->zmodel == BLK_ZONED_HM)
+			if (devip->zmodel == BLK_ZONED_HM) {
 				zsp->z_type = ZBC_ZTYPE_SWR;
-			else
+				devip->rc_basis = 1;
+			} else {
 				zsp->z_type = ZBC_ZTYPE_SWP;
+			}
 			zsp->z_cond = ZC1_EMPTY;
 			zsp->z_wp = zsp->z_start;
 			zsp->z_size =
