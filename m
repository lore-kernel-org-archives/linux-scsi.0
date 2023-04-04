Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BA89C77B6C
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 18:31:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbjDDSbc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 14:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbjDDSbQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 14:31:16 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 174107DA8;
        Tue,  4 Apr 2023 11:28:08 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id bi9so43473763lfb.12;
        Tue, 04 Apr 2023 11:28:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680632886;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dr2Hww8UkSMsbtWPl+uiEpvBEwJnNqlS9FIB4hVpH0g=;
        b=h4k40g8vQJajU78yuzkHpUfM6d2X7fiC3yvzXT7wR0VP+Verp6bnLxw1h1u0xTTWoQ
         ArkSYfcTQjUBpFWBDy/CX+Ee9ikPMlkNANUKaMBP/DqLjr4GvIvVQbAkXBlyHHNvtpOX
         HDWRyb/g3yCttC+g8WvzTrREx6WgJgCjpW7n0e7zXPyI9Fu63pf+dwY2D9cAB3pQjqBU
         xUS+OxSqOpk+m0nOxK2j0gLD0jocQi5LQ99SLaAOAuyPk0KDvlJa2XW4gH3Y5N9rOJDw
         ni5jQZhbW9Y24H6CzQgX2+NhY6HEzCo0ggzI38R0Jhw7qVo5PvQcBIk7jWTBpkerxayi
         xaUg==
X-Gm-Message-State: AAQBX9efizTDchny1OWGI1TvWNK286ayynQX2hi+5wGSGbzzanbgG5H5
        9rHBugSVAPaO1bq1oF1gYsDZCvtCqbokVQ==
X-Google-Smtp-Source: AKy350aRYtv6EJShn5WeYu6AwRQkfCJFaJW9Per6FhKhpuQwL6IS43eFhsvk+l4P7JaHkaDh5RcAIQ==
X-Received: by 2002:a05:6512:38c2:b0:4dd:cb1d:b3cc with SMTP id p2-20020a05651238c200b004ddcb1db3ccmr782804lft.11.1680632886047;
        Tue, 04 Apr 2023 11:28:06 -0700 (PDT)
Received: from flawful.org (c-a3f5e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.245.163])
        by smtp.gmail.com with ESMTPSA id a14-20020a056512020e00b004eae7890269sm2422268lfo.138.2023.04.04.11.28.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 04 Apr 2023 11:28:05 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id AA5DE2C0; Tue,  4 Apr 2023 20:28:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632883; bh=Ml7y/jf7AIB69js3iH/Wxe2UpbdPAiIMGTLWNNw4CTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bIqu4ZJL798Pl2Z3UogpuQNhSnArYFFbTh6cgleIvYG0s/m6/lAfI73UIZMQiat4b
         h4SQokQNld0N/x1sT+Jn9yUjMuWEHySu2d8JXjgct+XcTnA7bHObWmsnKo2O/ydhrC
         1JaA70AYCBKQiifryZwdKnS+2Nj7AkoHrzRJOk6s=
Received: from x1-carbon.lan (OpenWrt.lan [192.168.1.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id DF04C89C;
        Tue,  4 Apr 2023 20:25:32 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1680632733; bh=Ml7y/jf7AIB69js3iH/Wxe2UpbdPAiIMGTLWNNw4CTk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tuFdalKspLSIzF6JcaH68N4L3lNX/v6hh3QPLjnJcEBifajrU4YnSAd+uURxL15Qg
         ypfni1XWP9wQK0GHfv/zveDFsINw0+41cmv82sY/GOsw2m4mw+zUMdIeMFxPKyUchw
         dRj4BzzKMJa7z3/Hedak23Qcky01VPy9YrxMuHrg=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v5 03/19] block: introduce BLK_STS_DURATION_LIMIT
Date:   Tue,  4 Apr 2023 20:24:08 +0200
Message-Id: <20230404182428.715140-4-nks@flawful.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230404182428.715140-1-nks@flawful.org>
References: <20230404182428.715140-1-nks@flawful.org>
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

