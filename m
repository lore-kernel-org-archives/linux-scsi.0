Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AE9DCC77B7C
	for <linux-scsi@archiver.kernel.org>; Thu, 11 May 2023 01:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236869AbjEKBRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 10 May 2023 21:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236905AbjEKBRV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 10 May 2023 21:17:21 -0400
Received: from mail-lf1-x12e.google.com (mail-lf1-x12e.google.com [IPv6:2a00:1450:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A7E630F1;
        Wed, 10 May 2023 18:17:13 -0700 (PDT)
Received: by mail-lf1-x12e.google.com with SMTP id 2adb3069b0e04-4f24cfb8539so5415032e87.3;
        Wed, 10 May 2023 18:17:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683767832; x=1686359832;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:dkim-signature
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/wu/asmLWG7VXSPvx3HV/WDjP3cGIdH2ws6SwneJfko=;
        b=esJYT1p1I4AEpumzWHQ+d8jbtMdJ48UPERovmWyNoGTZVHRhdgoadqJf+7T0NE6KrZ
         Fb7OPtO7Tp9gcrKjL39IHrPxAf6tbwgrpnyEms9CGW2ArP9AHYZKCBhQlCF9NKFJ2tRh
         kKeR5OMT/vcC3X0KYkpPm/ISWhYcgR/tPw6dqcc2GHH0qiky0KysQjuPKIWM/v2G5GiR
         8/nsvcafYcXAIWXUd8PoCfT9nIIow+Ak3GRV50MbyKpWmfvTQKHJxdVryadDYbeNwNkc
         azY2fwoj8gAyjuzky2xPBhUO/K65zt4vN8OskaSJpkueDep/OLGqvf2cmJ9z3jjyCTYu
         wREQ==
X-Gm-Message-State: AC+VfDzsqw7DUFUXIAhdFS7zd426BF2KItOBt+EmEzFz533pekotBrMD
        pVFijHRWWbossclFkcUwDcm641d5RRVnLRzr
X-Google-Smtp-Source: ACHHUZ67juxnWR5bb5qmQJoG2Cznbuvwsft7sseyrHfvRoJwow/y5kcSTcQlCQXqjg+FNmzGzOw0WA==
X-Received: by 2002:a05:6512:38ae:b0:4b3:d6e1:26bb with SMTP id o14-20020a05651238ae00b004b3d6e126bbmr1975194lft.29.1683767831839;
        Wed, 10 May 2023 18:17:11 -0700 (PDT)
Received: from flawful.org (c-fcf6e255.011-101-6d6c6d3.bbcust.telenor.se. [85.226.246.252])
        by smtp.gmail.com with ESMTPSA id y13-20020a19750d000000b004eb12329053sm910509lfe.256.2023.05.10.18.17.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 18:17:11 -0700 (PDT)
Received: by flawful.org (Postfix, from userid 112)
        id 872CA3C7; Thu, 11 May 2023 03:17:10 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767830; bh=qOzTwWm7cGaVRwk39mqfQqhEfq+bS1DUhNke3nFW0kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acWonuMR5T8igtiDXfXOfFzR3i6XAu4sVy36euHtTL5vRPMv1GcpKrDgs8YJveY17
         01LahEwUuKifTVl74rKBR0WR3/RdFbQ/pukbi4l35gzWge4QNI3Rczicciy2pTD2uq
         3zc4gCSjpkRA5Dw1yRRojwNDVUtt0f1dtRXTLPHg=
Received: from x1-carbon.. (unknown [64.141.80.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by flawful.org (Postfix) with ESMTPSA id C783E585;
        Thu, 11 May 2023 03:14:45 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=flawful.org; s=mail;
        t=1683767687; bh=qOzTwWm7cGaVRwk39mqfQqhEfq+bS1DUhNke3nFW0kQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hTP+hYGE5q6Gt9OxNqA7Oq9q7K1OplNvB9GWZvp69NtrdkrMsCeDP/uszxzW5UVRH
         Hevn3LdrNuUC+EPVyEuQEQQVnpt+GtSMj7IwUONCTBSsfsQ7TEdtngbgtLBpjPkVeJ
         00fEoSnndaHYR+Pv4rvNeCTlfhyNMz+kkR2WIeGs=
From:   Niklas Cassel <nks@flawful.org>
To:     Jens Axboe <axboe@kernel.dk>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org, Niklas Cassel <niklas.cassel@wdc.com>
Subject: [PATCH v7 03/19] block: introduce BLK_STS_DURATION_LIMIT
Date:   Thu, 11 May 2023 03:13:36 +0200
Message-Id: <20230511011356.227789-4-nks@flawful.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230511011356.227789-1-nks@flawful.org>
References: <20230511011356.227789-1-nks@flawful.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Damien Le Moal <dlemoal@kernel.org>

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

Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Co-developed-by: Niklas Cassel <niklas.cassel@wdc.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 block/blk-core.c          | 3 +++
 include/linux/blk_types.h | 6 ++++++
 2 files changed, 9 insertions(+)

diff --git a/block/blk-core.c b/block/blk-core.c
index 00c74330fa92..04ad13ec6ead 100644
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
index 740afe80f297..dfdcd218aaac 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -171,6 +171,12 @@ typedef u16 blk_short_t;
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
2.40.1

