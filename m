Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DF60C761A6
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:48:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238724AbjDFLsy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:48:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238741AbjDFLsi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:48:38 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D912C64E;
        Thu,  6 Apr 2023 04:44:30 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y15so50419178lfa.7;
        Thu, 06 Apr 2023 04:44:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680781421;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mCADFseMMA7mOOQfCXLKrDG3P4srG9r6PeFcrMyq+I4=;
        b=KDiEvUvrQypurXO/KC49xJAo+afYWBiLY5rUfMUbtNlPXX0V4Tqn5zLVHymH3FFfYm
         UHR898x2iomV0EB+9C8uIYaf8OnBX/U0gufaFcKAyiDMpRmq2KTJu0d5+/AHdOcjGW7R
         rjju/gYRW20RRNsv/4l2Fd2p14TLJbKYza5Es4YcPKqZsUPtyQCJPNHRWgWOdwKeK6RB
         xDE357c6UYhNLi3gSwkXZlyN/EuLWJXlxdEfrTVGjpFiDdvgy1zu7l7NQhV8kYRtTe+H
         4poPwQ13MAhlIo39ilVQyE1uIskKfgRHL1jMbcIqnVB7f67j8Cj955s0l+7iJBF5J5Lm
         sp+g==
X-Gm-Message-State: AAQBX9f/bF5yglrI3dksay2/JNNoLn23TjRMQN22STMOZbZR0il2koNU
        Ttk27VErdSXK7JaG5IYKdcMFS/Ttn8jzIw==
X-Google-Smtp-Source: AKy350YBCWj5v1FvvA2Si9q3yeAfmKKV9u221VtQFiGRjlGYP8mP1I6e6ipk0fZZrzDv0j0qI4aokw==
X-Received: by 2002:ac2:4c0d:0:b0:4d5:c996:2940 with SMTP id t13-20020ac24c0d000000b004d5c9962940mr2824445lfq.61.1680781420812;
        Thu, 06 Apr 2023 04:43:40 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id h26-20020a19701a000000b004e1b880ba20sm228568lfc.292.2023.04.06.04.43.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:43:40 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id BFBD2666; Thu,  6 Apr 2023 13:43:38 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680781419; bh=1JaAwgGHLI4jFdeVVjtrT7wVpPnCMuROX+o5Q7kJxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A2JhnYLvi0n6atkZNNWziepH/Gq/0U8+oh6wqCda8+oe1fFjNTxHaZ75fJoyU7h1M
         kvBI8dcYxZVHYJt3odWu5wby3hM0R07lAoVvAq5ykiKQ3IZDZE/u0+JX60hJe5wvtC
         gKctzkJGOxwf9rtUEYLXEG99T4wbvcRKg9tDhwM0=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id A72BE1111;
        Thu,  6 Apr 2023 13:33:17 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780797; bh=1JaAwgGHLI4jFdeVVjtrT7wVpPnCMuROX+o5Q7kJxUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cim58pRbdIEWFmCHG50fohafHO6TVagH1ze9cPkaWjuMvKhYVQhX4qCU1zhcbLy97
         GGrJMLkwk0WHgO6/NjgqvB3D987JvkqCRTzeAvyGvtEcTsZWawozYg/5o/JcFqaNjC
         VEMNBccwMnoVl5u6kL90cTThLwDS2bkGjYyVdDgY=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 15/19] ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
Date:   Thu,  6 Apr 2023 13:32:44 +0200
Message-Id: <20230406113252.41211-16-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
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

