Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DCC3C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Sep 2022 11:56:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235678AbiI2L43 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Sep 2022 07:56:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235632AbiI2L4E (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Sep 2022 07:56:04 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 944D06459
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 04:55:28 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id z2so1640176edi.1
        for <linux-scsi@vger.kernel.org>; Thu, 29 Sep 2022 04:55:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=arrikto-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=nIQwUXStFE6ZXmm/UqIlIJqOenj3jzDptsTgpxiMbfQ=;
        b=V2lUGevzx1ajly1+Ss26/eKZWmzAtC2Yk9JzAPgkUqepTSL2EQCLMcPHkXE/dw3V4H
         aoCuR+rgWqcRKR8390Z9PtQx+DpaqmzqDpqvm2m4Z/YalyBSLCTq7pUxqkoYylMgVr+A
         lLgRXqMRQKon4uDa5c2okPoYYBt1MuyRWBxZLQNe51w7HWbVRHCYqiB71g4UQMIuIo7y
         OIOntHQZyCnurYDushv632IwHgSZSKY3ByX8iNoZ17pes6t0SN/7KrynaqLrCqFh43wZ
         EowYyf70sd1CuSodGHgYpuibzcrzEQ4CJssxfu+W8J69y8ags/5mwtsmFd4PkOw9KUf/
         LElg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=nIQwUXStFE6ZXmm/UqIlIJqOenj3jzDptsTgpxiMbfQ=;
        b=U5qApmVqJ2VH3Ko5wANRxIZnYZtIMrY/Dv7Q/WDIkK+uNfSNRPXHNjDQ6kNiiOD5p5
         x1oagRYfBgwEZ1DV9zbqXvObt8RxCwQi2Gb+PwvGRFWJfSnKw6QNsA/FHo7qJQDxqEgR
         p1qQezGsUW0xKcak4V0GK4DhIN0ZBkUZTxHor3Y3GvutG/KoZ62oLldCY9bIDRx8cN+G
         4OB5cgOqDpgiXhKXJTREmWiKbTGB15DX1XxOIptBpsCYmUzgviGS5mD3HcdLSpTM1GOS
         7tObFralL8Wl2BP4dcvwKxUc/EWmYYj8fO/+HZQj7dt2ZrJXKdg2J4Tr+0xI/SBS8q/e
         7CxQ==
X-Gm-Message-State: ACrzQf1E9R+w+eHgAyOTdS/uxYBtWeHxTYL5xr+6ig0Dn0A0YdFJ53NG
        hlIJEbWr1QZ5XFEEv02WzSYEYw==
X-Google-Smtp-Source: AMsMyM4eH07fVWCjS+UKWKhA/I75dhlerkb/xFHcLotRoJzp3jTNJ5+QgxmUp0J/8kywG6GZdBlijg==
X-Received: by 2002:a05:6402:4402:b0:453:6a9:ef8a with SMTP id y2-20020a056402440200b0045306a9ef8amr2890187eda.85.1664452526705;
        Thu, 29 Sep 2022 04:55:26 -0700 (PDT)
Received: from marvin.hq.arr ([185.109.18.135])
        by smtp.gmail.com with ESMTPSA id s3-20020a056402520300b00453d8dee355sm5379367edd.60.2022.09.29.04.55.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Sep 2022 04:55:25 -0700 (PDT)
From:   Nikos Tsironis <ntsironis@arrikto.com>
To:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     ntsironis@arrikto.com
Subject: [PATCH] tcm_loop: Increase maximum request size
Date:   Thu, 29 Sep 2022 14:55:04 +0300
Message-Id: <20220929115504.23806-1-ntsironis@arrikto.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Increase the maximum request size for tcm_loop, by setting sg_tablesize
to SG_MAX_SEGMENTS.

The current value of 256 for sg_tablesize limits the request size to
PAGE_SIZE * 256, which for 4K pages is 1MiB.

Signed-off-by: Nikos Tsironis <ntsironis@arrikto.com>
---
 drivers/target/loopback/tcm_loop.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
index 4407b56aa6d1..6d7c3ebd8613 100644
--- a/drivers/target/loopback/tcm_loop.c
+++ b/drivers/target/loopback/tcm_loop.c
@@ -308,7 +308,7 @@ static struct scsi_host_template tcm_loop_driver_template = {
 	.eh_device_reset_handler = tcm_loop_device_reset,
 	.eh_target_reset_handler = tcm_loop_target_reset,
 	.this_id		= -1,
-	.sg_tablesize		= 256,
+	.sg_tablesize		= SG_MAX_SEGMENTS,
 	.max_sectors		= 0xFFFF,
 	.dma_boundary		= PAGE_SIZE - 1,
 	.module			= THIS_MODULE,
-- 
2.30.2

