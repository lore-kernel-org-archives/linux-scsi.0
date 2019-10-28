Return-Path: <SRS0=wJ7M=YV=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DD0ECA9EC0
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E83D1214B2
	for <linux-scsi@archiver.kernel.org>; Mon, 28 Oct 2019 20:07:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732265AbfJ1UHP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Oct 2019 16:07:15 -0400
Received: from mail-pg1-f194.google.com ([209.85.215.194]:41832 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732221AbfJ1UHP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Oct 2019 16:07:15 -0400
Received: by mail-pg1-f194.google.com with SMTP id l3so7651843pgr.8;
        Mon, 28 Oct 2019 13:07:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1oBXLCEA6bDkeKywgn+CtEH0L7iMtQpOWpVW8yEPhC8=;
        b=pZozOzvz5TipYCS9/zypTBWWMRY54LS7opQOiX6Esqx/bj3O2l7qz6FbxN+2QuK/8X
         aoUvy52Y4n3ktCunLan/FbPfF/BLN4UJse43ZKQVqtvZbhCwxwpqUun4AW/LQdjYnNHZ
         YejYl0VufjXXNnOSbOXjfJ/kccc21sW3uViFATXMqe/1Nkyd+jfiPGgzkn2MrPVd75Vu
         aofHNlHd7rmPQRyRKZ0kK3v9jyhSGNsrKc6ZRXP24MHeGm0tb2L27v9UmNyqXprqDpHg
         RzFMPr22Rax16MeNP6lKwYEA7bjN05NVo9C3iguh0PfCdCARoC3Mb8sPoyRWybly1i6Q
         JRCQ==
X-Gm-Message-State: APjAAAVchpEhbnnUkC254jCJImMiDnxR5RbH4/PgfoQFeCVf11420uIS
        YXxBBye4FXic5+W3Qj9VPKo=
X-Google-Smtp-Source: APXvYqyGZXaHAoKPYMZmixkQ/UpGd7ZSzk81MMGfj89a70nSjdOribyZ590gaws8mhw8BrSVyQu44w==
X-Received: by 2002:aa7:8046:: with SMTP id y6mr21932294pfm.222.1572293234040;
        Mon, 28 Oct 2019 13:07:14 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id p3sm11084218pgp.41.2019.10.28.13.07.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Oct 2019 13:07:13 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Jonathan Cameron <jic23@kernel.org>,
        Hartmut Knaack <knaack.h@gmx.de>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Subject: [PATCH 4/9] drivers/iio: Sign extend without triggering implementation-defined behavior
Date:   Mon, 28 Oct 2019 13:06:55 -0700
Message-Id: <20191028200700.213753-5-bvanassche@acm.org>
X-Mailer: git-send-email 2.24.0.rc0.303.g954a862665-goog
In-Reply-To: <20191028200700.213753-1-bvanassche@acm.org>
References: <20191028200700.213753-1-bvanassche@acm.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From the C standard: "The result of E1 >> E2 is E1 right-shifted E2 bit
positions. If E1 has an unsigned type or if E1 has a signed type and a
nonnegative value, the value of the result is the integral part of the
quotient of E1 / 2E2 . If E1 has a signed type and a negative value, the
resulting value is implementation-defined."

Hence use sign_extend_24_to_32() instead of "<< 8 >> 8".

Cc: Jonathan Cameron <jic23@kernel.org>
Cc: Hartmut Knaack <knaack.h@gmx.de>
Cc: Lars-Peter Clausen <lars@metafoo.de>
Cc: Peter Meerwald-Stadler <pmeerw@pmeerw.net>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
---
 drivers/iio/common/st_sensors/st_sensors_core.c | 7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

diff --git a/drivers/iio/common/st_sensors/st_sensors_core.c b/drivers/iio/common/st_sensors/st_sensors_core.c
index 4a3064fb6cd9..94a9cec69cd7 100644
--- a/drivers/iio/common/st_sensors/st_sensors_core.c
+++ b/drivers/iio/common/st_sensors/st_sensors_core.c
@@ -21,11 +21,6 @@
 
 #include "st_sensors_core.h"
 
-static inline u32 st_sensors_get_unaligned_le24(const u8 *p)
-{
-	return (s32)((p[0] | p[1] << 8 | p[2] << 16) << 8) >> 8;
-}
-
 int st_sensors_write_data_with_mask(struct iio_dev *indio_dev,
 				    u8 reg_addr, u8 mask, u8 data)
 {
@@ -556,7 +551,7 @@ static int st_sensors_read_axis_data(struct iio_dev *indio_dev,
 	else if (byte_for_channel == 2)
 		*data = (s16)get_unaligned_le16(outdata);
 	else if (byte_for_channel == 3)
-		*data = (s32)st_sensors_get_unaligned_le24(outdata);
+		*data = get_unaligned_signed_le24(outdata);
 
 st_sensors_free_memory:
 	kfree(outdata);
-- 
2.24.0.rc0.303.g954a862665-goog

