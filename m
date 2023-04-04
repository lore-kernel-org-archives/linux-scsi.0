Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE525C77B60
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:37:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236364AbjDDShf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:37:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236241AbjDDShT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:37:19 -0400
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35847729A;
        Tue,  4 Apr 2023 11:35:47 -0700 (PDT)
Received: by mail-lj1-x22c.google.com with SMTP id x20so34869503ljq.9;
        Tue, 04 Apr 2023 11:35:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680633346;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mCADFseMMA7mOOQfCXLKrDG3P4srG9r6PeFcrMyq+I4=;
        b=Tc9awV0GfeEORdcKum+tjF1xB/yLrA0uGMx6MuBydYFO6ip0fYl42aPavJEHz6RJW7
         QK0xrWpuZ86ugrxWcJ4UhVWk9d1fRALFOtXWnSsxu7/uvwP1e/YVGTZgYuhyhQuEVgpL
         s+jqUzyZk09KCzr95gpqtQE1SCxk/ATGPYI7qKUee6iYpK8yLlcNwct3w8dpCA83oVUl
         F7bYrea4rU5R7dNcWS9Zb3+Wp6E0ChypP4ndS6QV5/zK32BZ011YM49jcoM6Scgm+qBQ
         SoP11vsXxJDD78xdwV9WAOcBbvsX1RUKBMgAd+kpgGRFW/L4suTPEjo5yKCp/1ZqfxT5
         xn4Q==
X-Gm-Message-State: AAQBX9dpcau/AvJ+wF2F4SjU5aIDahcFY7JBedPB8ny0nX7AY4CX1wj2
        HhTUaZXq1dnP1c8wFLynuw1bzjZUHGUNfA==
X-Google-Smtp-Source: AKy350ZtkF8xPSYGaH40QrUE9Y8RQoJWq6HrWF7YRcbiAbNej0crtm7puPMuvfFcBaoLPFM6qgDnwA==
X-Received: by 2002:a2e:86c4:0:b0:2a6:2444:9892 with SMTP id n4-20020a2e86c4000000b002a624449892mr1082443ljj.25.1680633346103;
        Tue, 04 Apr 2023 11:35:46 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id h20-20020a2e9ed4000000b0028b6e922ba1sm2445005ljk.30.2023.04.04.11.35.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:35:45 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id DB516865; Tue,  4 Apr 2023 20:35:44 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680633345; bh=1JaAwgGHLI4jFdeVVjtrT7wVpPnCMuROX+o5Q7kJxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UIgcDpt2mfy3u2LnkmmqekXJsK5RPR+1TPNCo37ROU9SET0nRmQKQEjitO5d9re/j
         siAXfJeYDRKUM5WCCmJloEajLvhr5dpoKWxYnMjEMzSmKgZ9yG6sk5diSVQZJ+GrtW
         Y94PH9xxZRIQenEDYugW52zEd2ARJ9s6nccmvYj0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C10AB1197;
        Tue,  4 Apr 2023 20:25:53 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632754; bh=1JaAwgGHLI4jFdeVVjtrT7wVpPnCMuROX+o5Q7kJxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O0eG7x7U74Xnk+XQcrPOvOLzhjA2HECDawQyp+Abq7C4s5f0WcAIu9wiycv806Qic
         sgNQdvte1YvOXla4PQ4VcX+amkfhB8RMHxRSb1SlbpyEQvEza1L0z2XD+YniVLbXC7
         B3514xMQ63mhwmZ69PJ1CfL01LlNHdnJsD8N4RNo=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 15/19] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Tue,  4 Apr 2023 20:24:20 +0200
Message-Id: <20230404182428.715140-16-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

For a scsi MAINTENANCE_IN/MI_REPORT_SUPPORTED_OPERATION_CODES operation,
add the translation of the rwcdlp and cdlp bits for the READ16 and
WRITE16 commands. If the ATA device does not support command duration
limits, these bits are always 0. If the ATA device supports command
duration limits, the rwcdlp bit is set to 1 for READ16 and WRITE16 and
the cdlp bits are set to 0x1 for READ16 and 0x2 for WRITE16. These
correspond to the T2A mode page containing the read descriptors and
to the T2B mode page containing the write descriptors, as defined in
SAT-5.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/ata/libata-scsi.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 716c33af999c..2a0a04c9e658 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3235,7 +3235,7 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 {
 	struct ata_device *dev = args->dev;
 	u8 *cdb = args->cmd->cmnd;
-	u8 supported = 0;
+	u8 supported = 0, cdlp = 0, rwcdlp = 0;
 	unsigned int err = 0;
 
 	if (cdb[2] != 1 && cdb[2] != 3) {
@@ -3262,10 +3262,8 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case MAINTENANCE_IN:
 	case READ_6:
 	case READ_10:
-	case READ_16:
 	case WRITE_6:
 	case WRITE_10:
-	case WRITE_16:
 	case ATA_12:
 	case ATA_16:
 	case VERIFY:
@@ -3275,6 +3273,28 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 	case START_STOP:
 		supported = 3;
 		break;
+	case READ_16:
+		supported = 3;
+		if (dev->flags & ATA_DFLAG_CDL) {
+			/*
+			 * CDL read descriptors map to the T2A page, that is,
+			 * rwcdlp = 0x01 and cdlp = 0x01
+			 */
+			rwcdlp = 0x01;
+			cdlp = 0x01 << 3;
+		}
+		break;
+	case WRITE_16:
+		supported = 3;
+		if (dev->flags & ATA_DFLAG_CDL) {
+			/*
+			 * CDL write descriptors map to the T2B page, that is,
+			 * rwcdlp = 0x01 and cdlp = 0x02
+			 */
+			rwcdlp = 0x01;
+			cdlp = 0x02 << 3;
+		}
+		break;
 	case ZBC_IN:
 	case ZBC_OUT:
 		if (ata_id_zoned_cap(dev->id) ||
@@ -3290,7 +3310,9 @@ static unsigned int ata_scsiop_maint_in(struct ata_scsi_args *args, u8 *rbuf)
 		break;
 	}
 out:
-	rbuf[1] = supported; /* supported */
+	/* One command format */
+	rbuf[0] = rwcdlp;
+	rbuf[1] = cdlp | supported;
 	return err;
 }
 
-- 
2.39.2

