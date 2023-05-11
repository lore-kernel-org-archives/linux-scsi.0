Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1B8C7EE26
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:20:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236939AbjEKBU6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236907AbjEKBUy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:20:54 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0ED949E0;
        Wed, 10 May 2023 18:20:50 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id 2adb3069b0e04-4f004cc54f4so8997576e87.3;
        Wed, 10 May 2023 18:20:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768048; x=1686360048;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tQnmaBLfliRFPVBvPAgIuF3DzRTDHxBUbR4pCAvDYAo=;
        b=PWwuT9j8+bKSOzOpOT9h3Q+d0cHvw6gi7JOnOx6A1UStOp+uBdyX63ApfOCs+gaWwa
         8lH7ur5aXH77NEqvNEgAP6x4rqvOLPvmunBZosrLH6cNWOaUEQx4mQPW2XzuZ9qrXmoq
         Zh4CBtc5zFyxmEobPTz6Gy/mxfrDqp0Ilw8L7ZJXgU3IA1RSSQ5druDFdVRF4cGrTU1p
         3wgesXfHa4MUg1bEvRBSsiWWcNVZ1ibpgoNBaRpvqiOY3ZFHfz5Ga8/aOrdkDsKSAvRY
         AVwLRjpG3IHTgGAHyFnUaTzvsJz7Qricu7g206sWEsECNKImm53o6dSFP0FXskK9nTJt
         +baQ==
X-Gm-Message-State: AC+VfDy8yzCtCe0Y4LzWGnNADfQFMQkR+FVXvdgwvjP3klNiv9vhpYjS
        oFJpdmvbCvOTAgD+Oaeg6/uMn5wxR0q1wmjN
X-Google-Smtp-Source: ACHHUZ7FNKY/4gQOv18bibXUlhBWrM0B5zpkU6jqcXrT4yPmj0+7wBhtMmfLjz/ANjSy6bcn5RKK6w==
X-Received: by 2002:ac2:4c08:0:b0:4ee:8ff3:c981 with SMTP id t8-20020ac24c08000000b004ee8ff3c981mr2377353lfq.10.1683768048253;
        Wed, 10 May 2023 18:20:48 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id y10-20020ac2446a000000b004f24cb9ef14sm910762lfl.47.2023.05.10.18.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:20:48 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 2C4F23C7; Thu, 11 May 2023 03:20:46 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768047; bh=Yc7aAR1XfQNo05yTlzshBLjU7Ck5BhKyc0alYxImpkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tScP1kXKwM7GjCUti0Y99d4jkF9b/skRBtkBhN2h740iVQmBv880nH2+ZOpYUPes+
         iNg2VqAdjz7/XxX+wuE8qqhkB9ZLwIZ7G1f+pi9ZtFy930H1D6coBbEG12eXAzak0Y
         kCcDtF4ZuJkYwwtWRucqsDZ5lYUzPlQDHq7F6jLI=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 5A693762;
        Thu, 11 May 2023 03:15:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767719; bh=Yc7aAR1XfQNo05yTlzshBLjU7Ck5BhKyc0alYxImpkE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rFC4QylBHhUa9r4eibo376Qdg35VmgKS60omnntB/GbmxWYe1VtreQ4ZeI0MVsJ+U
         7DFnT1qXmeboyDhgRRoYJkdNQRfXWl2n7bt8kzQ5gf3GFck3j296+mcVR6vxq4e39g
         w57B6evWBtCBqOEeiFkQuvMbkH1y/kSqVRb3b32c=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 10/19] scsi: sd: set read/write commands CDL index
Date:   Thu, 11 May 2023 03:13:43 +0200
Message-Id: <20230511011356.227789-11-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

Introduce the command duration limits helper function sd_cdl_dld() to
set the DLD bits of READ/WRITE 16 and READ/WRITE 32 commands to
indicate to the device the command duration limit descriptor to apply
to the commands.

When command duration limits are enabled, sd_cdl_dld() obtains the
index of the descriptor to apply to the command using the hints field of
the request IO priority value (hints IOPRIO_HINT_DEV_DURATION_LIMIT_1 to
IOPRIO_HINT_DEV_DURATION_LIMIT_7).

If command duration limits is disabled (which is the default), the limit
index "0" is always used to indicate "no limit" for a command.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/sd.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index a76092663246..3825e4d159fc 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1041,13 +1041,14 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 
 static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len = SD_EXT_CDB_SIZE;
 	cmd->cmnd[0]  = VARIABLE_LENGTH_CMD;
 	cmd->cmnd[7]  = 0x18; /* Additional CDB len */
 	cmd->cmnd[9]  = write ? WRITE_32 : READ_32;
 	cmd->cmnd[10] = flags;
+	cmd->cmnd[11] = dld & 0x07;
 	put_unaligned_be64(lba, &cmd->cmnd[12]);
 	put_unaligned_be32(lba, &cmd->cmnd[20]); /* Expected Indirect LBA */
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[28]);
@@ -1057,12 +1058,12 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 
 static blk_status_t sd_setup_rw16_cmnd(struct scsi_cmnd *cmd, bool write,
 				       sector_t lba, unsigned int nr_blocks,
-				       unsigned char flags)
+				       unsigned char flags, unsigned int dld)
 {
 	cmd->cmd_len  = 16;
 	cmd->cmnd[0]  = write ? WRITE_16 : READ_16;
-	cmd->cmnd[1]  = flags;
-	cmd->cmnd[14] = 0;
+	cmd->cmnd[1]  = flags | ((dld >> 2) & 0x01);
+	cmd->cmnd[14] = (dld & 0x03) << 6;
 	cmd->cmnd[15] = 0;
 	put_unaligned_be64(lba, &cmd->cmnd[2]);
 	put_unaligned_be32(nr_blocks, &cmd->cmnd[10]);
@@ -1114,6 +1115,31 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
 	return BLK_STS_OK;
 }
 
+/*
+ * Check if a command has a duration limit set. If it does, and the target
+ * device supports CDL and the feature is enabled, return the limit
+ * descriptor index to use. Return 0 (no limit) otherwise.
+ */
+static int sd_cdl_dld(struct scsi_disk *sdkp, struct scsi_cmnd *scmd)
+{
+	struct scsi_device *sdp = sdkp->device;
+	int hint;
+
+	if (!sdp->cdl_supported || !sdp->cdl_enable)
+		return 0;
+
+	/*
+	 * Use "no limit" if the request ioprio does not specify a duration
+	 * limit hint.
+	 */
+	hint = IOPRIO_PRIO_HINT(req_get_ioprio(scsi_cmd_to_rq(scmd)));
+	if (hint < IOPRIO_HINT_DEV_DURATION_LIMIT_1 ||
+	    hint > IOPRIO_HINT_DEV_DURATION_LIMIT_7)
+		return 0;
+
+	return (hint - IOPRIO_HINT_DEV_DURATION_LIMIT_1) + 1;
+}
+
 static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 {
 	struct request *rq = scsi_cmd_to_rq(cmd);
@@ -1125,6 +1151,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
+	unsigned int dld;
 	blk_status_t ret;
 	unsigned int dif;
 	bool dix;
@@ -1174,6 +1201,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
 	dix = scsi_prot_sg_count(cmd);
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
+	dld = sd_cdl_dld(sdkp, cmd);
 
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
@@ -1182,10 +1210,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
 	if (protect && sdkp->protection_type == T10_PI_TYPE2_PROTECTION) {
 		ret = sd_setup_rw32_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if (sdp->use_16_for_rw || (nr_blocks > 0xffff)) {
 		ret = sd_setup_rw16_cmnd(cmd, write, lba, nr_blocks,
-					 protect | fua);
+					 protect | fua, dld);
 	} else if ((nr_blocks > 0xff) || (lba > 0x1fffff) ||
 		   sdp->use_10_for_rw || protect) {
 		ret = sd_setup_rw10_cmnd(cmd, write, lba, nr_blocks,
-- 
2.40.1

