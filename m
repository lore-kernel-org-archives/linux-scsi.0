Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49284C76196
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Apr 2023 11:41:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238741AbjDFLlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Apr 2023 07:41:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238447AbjDFLlE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Apr 2023 07:41:04 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF45186A7;
        Thu,  6 Apr 2023 04:37:06 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id g29so533921lfj.4;
        Thu, 06 Apr 2023 04:37:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680780957;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dr2Hww8UkSMsbtWPl+uiEpvBEwJnNqlS9FIB4hVpH0g=;
        b=KQ2/qZnNAGnBOyOS934Ob7aJpWH7Pz23j5Mqv+boLPIe94pB/JoDWooDsxJtso+0b6
         FeflB6DlV30us/xPUOhm5aNvbJKPRDP0IP1IDlF6V0zOIRCgIg7O9sobC4Sq63mKTz1C
         4Ab2ZCKxAZmV0HxzUPpt7ATCd8K6h5vyr+vyK3mqvD1Qzzoy2OKps0ju++i2+lXlOqzR
         ehpGIxO1YEWyyxZG3i4lNUfbsIdDi3FycTJFQLk4Jq10QYhh3/cfJ4a5M9p7Z6tzkzZC
         ovpnHhod465rPevhr45+Hu942Sgbx8RKYPr6j9BXGSG68VZVKvysgcbHRuAy8YgZ6Z9r
         ZkoQ==
X-Gm-Message-State: AAQBX9dFbOiNVcX0y74rAnZoV5EaxQ/Qxa+LkTzG+jcgaO52NeRb5sOf
        5iCc9ex6VqCU9l5VIYpcGRHjIlhG7iI2zg==
X-Google-Smtp-Source: AKy350ZctK27GN5EalBhlORsrxLbdDBl/BiheiEdoP9KfkEepVgZ11mXi/EEu7Vfnzet/kjYS3rr8w==
X-Received: by 2002:ac2:46f6:0:b0:4e9:c6bc:601b with SMTP id q22-20020ac246f6000000b004e9c6bc601bmr2395097lfo.64.1680780957129;
        Thu, 06 Apr 2023 04:35:57 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id q12-20020ac2528c000000b004db39e80733sm226552lfm.155.2023.04.06.04.35.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 04:35:56 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id EA13369A; Thu,  6 Apr 2023 13:35:55 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780956; bh=Ml7y/jf7AIB69js3iH/Wxe2UpbdPAiIMGTLWNNw4CTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LyvsX3M5Zoe3QR9zfczY4NwgS27ZqdVPV+NdvFxCtr3b+akOM+t+omOt/biLkPlCH
         1PwBgaIPx0Y1qjkYJ/klXnmxnmHMh5pKTvZNG2/ZxpCKtoghpugYegVN3vPG+R897q
         Gg1aPDZALapd78wo2L4vucRyOlgDP5MEOOhaTeCw=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id CDC256D4;
        Thu,  6 Apr 2023 13:33:07 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680780788; bh=Ml7y/jf7AIB69js3iH/Wxe2UpbdPAiIMGTLWNNw4CTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iokZ8Ff14pXTPl9z/wTIeaMPtkBCylmJ2YQCeGlr51TT9hDoFtZTNGKh/M10Hb1Tw
         PdHardtCiG7D/XLzUnm+v6X2Ph/T98Ua5VU4WHOhVaiug4EE47Md65rJVgObg16ARE
         wOWwqCXja/eJ8FsRjOSODhGLqHaFLrSKgF8lBkgw=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Damien Le Moal <dlemoal@fastmail.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v6 03/19] block: introduce BLK_STS_DURATION_LIMIT
Date:   Thu,  6 Apr 2023 13:32:32 +0200
Message-Id: <20230406113252.41211-4-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230406113252.41211-1-nks@flawful.org>
References: <20230406113252.41211-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
report command that failed due to a command duration limit being
exceeded. This new status is mapped to the ETIME error code to allow
users to differentiate "soft" duration limit failures from other more
serious hardware related errors.

If we compare BLK_STS_DURATION_LIMIT with BLK_STS_TIMEOUT:
-BLK_STS_DURATION_LIMIT means that the drive gave a reply indicating that
the command duration limit was exceeded before the command could be
completed. This IO status is mapped to ETIME for user space.

-BLK_STS_TIMEOUT means that the drive never gave a reply at all.
This IO status is mapped to ETIMEDOUT for user space.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c          | 3 +++
 include/linux/blk_types.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 42926e6cb83c..be7facaa11a6 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -170,6 +170,9 @@ static const struct {
 	[BLK_STS_ZONE_OPEN_RESOURCE]	= { -ETOOMANYREFS, "open zones exceeded" },
 	[BLK_STS_ZONE_ACTIVE_RESOURCE]	= { -EOVERFLOW, "active zones exceeded" },
 
+	/* Command duration limit device-side timeout */
+	[BLK_STS_DURATION_LIMIT]	= { -ETIME, "duration limit exceeded" },
+
 	/* everything else not covered above: */
 	[BLK_STS_IOERR]		= { -EIO,	"I/O" },
 };
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 99be590f952f..cde997590765 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -166,6 +166,12 @@ typedef u16 blk_short_t;
  */
 #define BLK_STS_OFFLINE		((__force blk_status_t)17)
 
+/*
+ * BLK_STS_DURATION_LIMIT is returned from the driver when the target device
+ * aborted the command because it exceeded one of its Command Duration Limits.
+ */
+#define BLK_STS_DURATION_LIMIT	((__force blk_status_t)18)
+
 /**
  * blk_path_error - returns true if error may be path related
  * @error: status the request was completed with
-- 
2.39.2

