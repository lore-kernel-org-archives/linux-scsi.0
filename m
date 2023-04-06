Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60A7EC761A6
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238664AbjDFLpr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:45:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239148AbjDFLp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:45:29 -0400
Received: from mail-lf1-x12b.google.com (mail-lf1-x12b.google.com [IPv6:2a00:1450:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2534E049;
        Thu,  6 Apr 2023 04:41:24 -0700 (PDT)
Received: by mail-lf1-x12b.google.com with SMTP id k37so50472950lfv.0;
        Thu, 06 Apr 2023 04:41:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781214;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YOmBYhlHKavGamh83AreBloEjMraMOzlAtrB/N4emK4=;
        b=ktjTr/vDZjf91H7Ii+OcVE4GXEkbvJ5BJdogoUXplDfDTlEatfpVBR5aaCef9Irh+g
         hAtUXsWH1SRoIvpprJ4ZrcBbfjGns9BGUnvgxk8NXfwZaGQwM1lvrXp/JjjFi3bNxjjY
         hRTLnzgqEZWQvNWtmhkDnDlx/N6GLu9GQbclBOlppN8NCLmfi5crmOZm62KP8RmzCcrG
         SUtGocSYn/0LF9WB1hOREsAeeL4VtvqKOLh+kO32SbPOX0LXAw46KjGYNiwEBsDhefSY
         TxkH9akHkjZrEwK0tqjTW2qS02kY4IK9jZQHaIBEAALtXXuaMWa2V3+HSZkJFqL9IB5j
         tGtA==
X-Gm-Message-State: AAQBX9dRq3+fkjE9IOqMxoMBtfo9N3VjoNf8GiZju0KQL3aosTjtb5OH
        7cLy9PvWp5QKp/il6Wm4jT339W8ctpx0nQ==
X-Google-Smtp-Source: AKy350Z6lV51qRwJreVW6dzfzPUW2xDcLUl3s3StOLPcOcQpSHwOxILRgKbshYM9tVPnuo/3u/Pgyw==
X-Received: by 2002:ac2:44d9:0:b0:4e8:57b1:9498 with SMTP id d25-20020ac244d9000000b004e857b19498mr2430976lfm.5.1680781213797;
        Thu, 06 Apr 2023 04:40:13 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v25-20020a197419000000b004eb0c12df21sm228324lfe.128.2023.04.06.04.40.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:40:13 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id D8FE767E; Thu,  6 Apr 2023 13:40:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781212; bh=YW716/MVayNMgybxCgi8heRbDuTZ7zCwKD8x5cBf3as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XkdOtlYmxCPryh4tn1qipXVwFPmlH/MkXYn111pUDAELuhexxry0phUwMPSzbSOYW
         2mVAXBANoxn/ZT30eWvudzBkLODTp8ukM3yxaIvuQrAIpkmbSPhhA/nxPC8GiReH4X
         KroJd4MXEUORBYM3gihnL/hfpwxJo7iwM+9ynBx0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DD8BDAE0;
        Thu,  6 Apr 2023 13:33:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780794; bh=YW716/MVayNMgybxCgi8heRbDuTZ7zCwKD8x5cBf3as=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t5dopKiq4elfrayEpVG1pyBIIgKsY9CmvXekggGzrEFkZhCWsix1Z5gYoLUUYm/jj
         yihMTFa0gmWFmTvj2Q+dymdv+jCUSyaMU1lcypHW27LScvikCkQsC6kcbaQq2adVWA
         yGfcn7w51tmKtlzBKWbKYqUPTfxQ5upYn1TwyQHE=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 10/19] scsi: sd: set read/write commands CDL index
Date:   Thu,  6 Apr 2023 13:32:39 +0200
Message-Id: <20230406113252.41211-11-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

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

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/sd.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 2dc4223a4c97..c265b8cf2890 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1042,13 +1042,14 @@ static blk_status_t sd_setup_flush_cmnd(struct scsi_cmnd *cmd)
 
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
@@ -1058,12 +1059,12 @@ static blk_status_t sd_setup_rw32_cmnd(struct scsi_cmnd *cmd, bool write,
 
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
@@ -1115,6 +1116,31 @@ static blk_status_t sd_setup_rw6_cmnd(struct scsi_cmnd *cmd, bool write,
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
@@ -1126,6 +1152,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	unsigned int mask = logical_to_sectors(sdp, 1) - 1;
 	bool write = rq_data_dir(rq) == WRITE;
 	unsigned char protect, fua;
+	unsigned int dld;
 	blk_status_t ret;
 	unsigned int dif;
 	bool dix;
@@ -1175,6 +1202,7 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 	fua = rq->cmd_flags & REQ_FUA ? 0x8 : 0;
 	dix = scsi_prot_sg_count(cmd);
 	dif = scsi_host_dif_capable(cmd->device->host, sdkp->protection_type);
+	dld = sd_cdl_dld(sdkp, cmd);
 
 	if (dif || dix)
 		protect = sd_setup_protect_cmnd(cmd, dix, dif);
@@ -1183,10 +1211,10 @@ static blk_status_t sd_setup_read_write_cmnd(struct scsi_cmnd *cmd)
 
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
2.39.2

