Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1684DC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:01:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiGKXBH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:01:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbiGKXBC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:01:02 -0400
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52F7561B1D
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:01:01 -0700 (PDT)
Received: by mail-pl1-f181.google.com with SMTP id l12so5686977plk.13
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:01:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ie36p2rZzY5GvCYUO5UdUwYiXQgaNmEth6QGiyc7UXg=;
        b=DqfV1+OlH1s4KxruICRaPBklOjzUE+w9uJOL8NcsbdAahtbKWbY49r4YbSluT7EXy3
         vRMWv3lL8rJgWai0Lqxg+1NXPDgkDQq5/KYU5XGbOT7mxQv8EbJoILPkVv/alXVp9Ca8
         PMzuaAJlnW8BCdfGESwHFoQbBLFEGVnZorp5UGqhgAxcv5i6QMrVCwBlpcvV7uhZO5aJ
         KBP6AY93iswax774g4Md8u+5Lv6ZeAV+fqC/Mo4Zwy0JCGcjWXkK9+EoSt1TjBFZrxei
         1jRodyem2uWaSx+3Xt42Hs77ITrOPQwI0vcv6+hKt5YqZrKDwG448RFNpCkb5l3LtohD
         EWDg==
X-Gm-Message-State: AJIora9vH/i8cyOtSOu+Hi0e0nggyJThSro0SJcSXumj6Uexr+IfzZjp
        R1kgHR/inEqpLf0QeeM3bsk=
X-Google-Smtp-Source: AGRyM1szUiOrROfBzh2t1n8qpt7Kc0ueKXRaSmlrJqQyqIwO6gMX32RTChTywwTxrt0sSYKpsda3wg==
X-Received: by 2002:a17:902:cecb:b0:16c:40a8:88ff with SMTP id d11-20020a170902cecb00b0016c40a888ffmr9751096plg.33.1657580460588;
        Mon, 11 Jul 2022 16:01:00 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m6-20020a637d46000000b00411955c03e5sm4761886pgn.29.2022.07.11.16.00.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 16:00:59 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Hannes Reinecke <hare@suse.com>
Subject: [PATCH 3/3] scsi: sd_zbc: Fix handling of RC BASIS
Date:   Mon, 11 Jul 2022 16:00:51 -0700
Message-Id: <20220711230051.15372-4-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220711230051.15372-1-bvanassche@acm.org>
References: <20220711230051.15372-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Using the RETURNED LOGICAL BLOCK ADDRESS field + 1 as the capacity (largest
addressable LBA) if RC BASIS = 0 is wrong if there are sequential write
required zones. Hence only use the RC BASIS = 0 capacity if there are no
sequential write required zones.

Cc: Damien Le Moal <damien.lemoal@wdc.com>
Cc: Hannes Reinecke <hare@suse.com>
Fixes: d2e428e49eec ("scsi: sd_zbc: Reduce boot device scan and revalidate time")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/scsi/sd_zbc.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 6acc4f406eb8..41ff1c0fd04b 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -699,7 +699,7 @@ static int sd_zbc_check_zoned_characteristics(struct scsi_disk *sdkp,
  *
  * Get the device zone size and check that the device capacity as reported
  * by READ CAPACITY matches the max_lba value (plus one) of the report zones
- * command reply for devices with RC_BASIS == 0.
+ * command reply.
  *
  * Returns 0 upon success or an error code upon failure.
  */
@@ -709,6 +709,7 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	u64 zone_blocks;
 	sector_t max_lba;
 	unsigned char *rec;
+	u8 same;
 	int ret;
 
 	/* Do a report zone to get max_lba and the size of the first zone */
@@ -716,9 +717,26 @@ static int sd_zbc_check_capacity(struct scsi_disk *sdkp, unsigned char *buf,
 	if (ret)
 		return ret;
 
-	if (sdkp->rc_basis == 0) {
-		/* The max_lba field is the capacity of this device */
-		max_lba = get_unaligned_be64(&buf[8]);
+	/*
+	 * From ZBC-1: "If the ZONE LIST LENGTH field is zero then the SAME
+	 * field is invalid and should be ignored by the application client."
+	 */
+	if (get_unaligned_be32(&buf[0]) == 0) {
+		sd_printk(KERN_INFO, sdkp, "No zones have been reported\n");
+		return -EIO;
+	}
+
+	same = buf[4] & 0xf;
+	max_lba = get_unaligned_be64(&buf[8]);
+	/*
+	 * The max_lba field is the largest addressable LBA of the disk if:
+	 * - Either RC BASIS == 1.
+	 * - Or RC BASIS == 0, there is at least one zone in the response
+	 *   (max_lba != 0) and all zones have the same type (same == 1 ||
+	 *   same == 2).
+	 */
+	if ((sdkp->rc_basis == 0 && max_lba && (same == 1 || same == 2)) ||
+	    sdkp->rc_basis == 1) {
 		if (sdkp->capacity != max_lba + 1) {
 			if (sdkp->first_scan)
 				sd_printk(KERN_WARNING, sdkp,
