Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B412CCCA480
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:01:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230074AbiGKXBA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:01:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229933AbiGKXA7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:00:59 -0400
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D1FD57260
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:58 -0700 (PDT)
Received: by mail-pj1-f44.google.com with SMTP id 89-20020a17090a09e200b001ef7638e536so9723290pjo.3
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dZxOsRkLHqoOw46AFUipp3IJm8J9vVNYvBGrby4bQNY=;
        b=CYx7+i2ratqxhg8jYPDUB2Wy8x7OpsGPML+x5mGLrmO+hq4AbbKLxvdOBoDQOYhXvq
         Vjlj1+aYtXzN4Zi1LkMev0/PtnrRdxkkCdC6+2bO5k1Kk744mWJZO7SzpQjIGjnIVIyK
         LjppzfsaZhVCnJNAoDgWUHGqMpu9AaE9bLKjK7Rg+0Sq+Tfmw0oSthWhc+8RvUv5ekM+
         OA2VPamw2IskVJhdpr9yg7jyddHIE/CUy49dMqp4w7LXw9mN/4y7neq0EGEYTF7aK5v9
         86X1OkpzoFQnNA3O+2NSMNg/k+QtvnDRyK8QHSYr2LZ8pv7qdQiUyZLeV0eGImBIVnkl
         ohQw==
X-Gm-Message-State: AJIora/McfydGXzdH+089t8e8AEjpI5/oODnWz7Tj0Z9YB8KXMM5vKrx
        iM/vw0iFw5A28lUbrMWBaBs=
X-Google-Smtp-Source: AGRyM1ss8lZl0Oj2W+wBBCFmcsrOWxOZ2+eNrdKSqO5+10n+Bxk5CiYzjjFVsF9QKxVx384eIeTFsg==
X-Received: by 2002:a17:902:c405:b0:16c:1dc:c7f8 with SMTP id k5-20020a170902c40500b0016c01dcc7f8mr20770435plk.59.1657580457491;
        Mon, 11 Jul 2022 16:00:57 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m6-20020a637d46000000b00411955c03e5sm4761886pgn.29.2022.07.11.16.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 16:00:56 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 1/3] scsi_debug: Set the SAME field in the REPORT ZONES response
Date:   Mon, 11 Jul 2022 16:00:49 -0700
Message-Id: <20220711230051.15372-2-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711230051.15372-1-bvanassche@acm.org>
References: <20220711230051.15372-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide information to the SCSI initiator about whether or not all examined
zones have the same zone type and zone length. From the description of the
SAME field in ZBC-1:
* 0: The zone type and zone length in each zone descriptor may be different.
* 1: The zone type and zone length in each zone descriptor are equal to the
  zone type and zone length indicated in the first zone descriptor in the
  zone descriptor list.

Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/scsi_debug.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b8a76b89f85a..5a8efc328fb5 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4476,8 +4476,10 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	u64 lba, zs_lba;
 	u8 *arr = NULL, *desc;
 	u8 *cmd = scp->cmnd;
-	struct sdeb_zone_state *zsp = NULL;
+	struct sdeb_zone_state *zsp = NULL, *first_reported_zone = NULL;
 	struct sdeb_store_info *sip = devip2sip(devip, false);
+	/* 1: all zones in the response have the same type and length. */
+	u8 same = 1;
 
 	if (!sdebug_dev_is_zoned(devip)) {
 		mk_sense_invalid_opcode(scp);
@@ -4571,6 +4573,13 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 			goto fini;
 		}
 
+		if (first_reported_zone) {
+			if (zsp->z_type != first_reported_zone->z_type ||
+			    zsp->z_size != first_reported_zone->z_size)
+				same = 0;
+		} else {
+			first_reported_zone = zsp;
+		}
 		if (nrz < rep_max_zones) {
 			/* Fill zone descriptor */
 			desc[0] = zsp->z_type;
@@ -4592,6 +4601,8 @@ static int resp_report_zones(struct scsi_cmnd *scp,
 	/* Report header */
 	/* Zone list length. */
 	put_unaligned_be32(nrz * RZONES_DESC_HD, arr + 0);
+	/* SAME field. */
+	arr[4] = same;
 	/* Maximum LBA */
 	put_unaligned_be64(sdebug_capacity - 1, arr + 8);
 	/* Zone starting LBA granularity. */
