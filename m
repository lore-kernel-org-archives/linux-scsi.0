Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3670DC77B7D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:25:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236782AbjEKBZI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236955AbjEKBYu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:24:50 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B69915FCA;
        Wed, 10 May 2023 18:24:45 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f22908a082so5914988e87.1;
        Wed, 10 May 2023 18:24:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683768284; x=1686360284;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jTJYTbIzIXP7MZIofaNTt+HJ+lOeeGhc02kHWx4qm38=;
        b=DaBzPk5ZDOMf4ImU2Gz5qXw+kVfoX1k3VqkDpl0ERekPeSYWPMBhk/wUsBrO1/O9pK
         zlC+MqdcznrkjSaRedyQXeRbgjFSGKzMYhPU8SVKOvEZopBDxOrYID1Lhg5E98BVHVDX
         Cze8WlVK4RtrnICBpH9r071xGpSbAOtFdWgZWvHF4sz3/TVCjH+nko6eFgoxQ3r4i9T/
         tWoZd2QzMc9XVDexF1q1BZxwGyCxWnQcvGllhHrH1Ew0Y/+dAPYurCvH3CDnCe9Lp4Xt
         bFE/6KTLKVDCjQh41AMZFhJfLk8K06N4PzM8RS8laNao6k8/Ni63LiU+ErEOEkar9Vqs
         XlqA==
X-Gm-Message-State: AC+VfDweJZFSn4lUzQ5mhyYHBsMeiNWVm8pDnalTN5SgvwoLxZ7+s038
        5rcm5GM2PCXqGSCjjaitxs7IsZgw8dO+ukRM
X-Google-Smtp-Source: ACHHUZ52C/gIZpz3s3wzuglVxcycooX8+XExrf5fpMnoKcqaWhx+WrQX7Om3QFV4NdMIF+HzV8HIZw==
X-Received: by 2002:ac2:5315:0:b0:4eb:680:391c with SMTP id c21-20020ac25315000000b004eb0680391cmr2556902lfh.10.1683768283944;
        Wed, 10 May 2023 18:24:43 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id v20-20020ac25594000000b004efef5cf939sm897165lfg.83.2023.05.10.18.24.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:24:43 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id C741F585; Thu, 11 May 2023 03:24:42 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683768283; bh=U5BCz+nPCm4fe1bRBykUSFpNY02AMJNjIB+/Vi6FaU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfP7mhbthxZuymbAEGpSvFbC6lOUNsNyJeMy53/42Ynu83ehW8qspb8+rq4Y5UuRf
         86UQ2ae3c/CBozNekARd+NxW95nKAt6IcEs2rkp5wU05IBWwFmgkyi4Cj/VbSNc2or
         sSBgWct1sP3AIkXUVldV26vTW29CGVNYJo2MvuPc=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id 39BF67BE;
        Thu, 11 May 2023 03:15:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767734; bh=U5BCz+nPCm4fe1bRBykUSFpNY02AMJNjIB+/Vi6FaU8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nLW/zY9q2ts+UAa4xVir7Qv5KAmCDg4l3PgAinxJz2kGhEYFvUKqBHJxKeVwo11bQ
         Gc6aYE0+mA3Lqesy6kSu2vLGrcPGkkEsT0CnQu1qhRGT0JGyjEwATDUm3097wIdnwR
         aJUSUjUib7Gd/xvSHVT5r1ub4LjS+e2N3/9RcuI0=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 15/19] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Thu, 11 May 2023 03:13:48 +0200
Message-Id: <20230511011356.227789-16-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

For a scsi MAINTENANCE_IN/MI_REPORT_SUPPORTED_OPERATION_CODES operation,
add the translation of the rwcdlp and cdlp bits for the READ16 and
WRITE16 commands. If the ATA device does not support command duration
limits, these bits are always 0. If the ATA device supports command
duration limits, the rwcdlp bit is set to 1 for READ16 and WRITE16 and
the cdlp bits are set to 0x1 for READ16 and 0x2 for WRITE16. These
correspond to the T2A mode page containing the read descriptors and
to the T2B mode page containing the write descriptors, as defined in
SAT-5.

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/ata/libata-scsi.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 3434fec8ca5c..4245242664d9 100644
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
2.40.1

