Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E407C6FA86
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 01:44:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiI0Bof (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 21:44:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbiI0Bob (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 21:44:31 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC96FA74E7
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:28 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id 129so6678509pgc.5
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 18:44:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Gw9lyqQe5R+yw+IDPoV4+8Za+H046k5YKHvd8lw2rPY=;
        b=N0ygZaFhLSOXkV8fuZqHVSFTMa/CFtuXkka+qByZM4y/jLM4N7XGTKIRmXsUIUHrON
         3xw/74DNSgBGpgoVZi5QLh/wZc1wsmK9f+44t89KaCF9k8cJDA1unvlZlkR+JNBM4Y32
         JVSVDHu/2ByQpfKZJPkcQK3WPaFQjwh4QKyWOnegEVT/KegEFa6ydXk+zn0Hh71SCb3E
         AkSNsCF45qlH3oMFjCWFG3IK+mMS2HkWwZgHtEbMES8GCHhmXPAayxJsUrxMP5o3pxN3
         Wd03JthVfnQhbLCxYibxseOrQ9fhcin8EAGRuttygUZlR4eg0jcZRycz+DOG5IA4VI/p
         oQCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Gw9lyqQe5R+yw+IDPoV4+8Za+H046k5YKHvd8lw2rPY=;
        b=k9u38c1PgtmBQl2Wh9Myydh66nAbWyTY8tWMFhWdgSbwPtUZBqdD/u0zZWoyUXrd7j
         FxHegx2REWs9Ls0cnge0iviBY6zPx/IiJmZW1sPnN43DBK27QY9+oYCQlGC8CSCOv9B1
         bRQpjjukOa+QvFwaI7321um4zlP83RmtzlDiXFeR+5grOUDEyFzrg+bTp+kLIGzA2ipr
         Vw2y6W2wABXNpcZCDW311bWnG5HHPJm6LkWcI8DaHz506IMVpH8/zS46rc6uupu+O3te
         iJLyW8zTq8sGnc8ZDqpYR9bblpSuAR+OgY7MFyFavC6E7i95gX4HFGe33GyRIFRCNqkK
         mVfA==
X-Gm-Message-State: ACrzQf3gMpuzNyHLxaj8UZy5iC5SyjDNYov86TdMFq/w02mHdK7nNOSx
        LnuakMJ+qbCTDkpw461qbNl4iw==
X-Google-Smtp-Source: AMsMyM76dVAl8IUXKH4912uerp2IA/RXyHJpj8bhTIn05ne6zZSO1S91VEgYu/TmSWlfMDVcAlB4Pw==
X-Received: by 2002:a63:2ac4:0:b0:41d:95d8:45b6 with SMTP id q187-20020a632ac4000000b0041d95d845b6mr23016941pgq.132.1664243067888;
        Mon, 26 Sep 2022 18:44:27 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id o2-20020aa79782000000b00537d60286c9sm183062pfp.113.2022.09.26.18.44.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 18:44:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        Jens Axboe <axboe@kernel.dk>, Stefan Roesch <shr@fb.com>
Subject: [PATCH 5/5] nvme: enable batched completions of passthrough IO
Date:   Mon, 26 Sep 2022 19:44:20 -0600
Message-Id: <20220927014420.71141-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220927014420.71141-1-axboe@kernel.dk>
References: <20220927014420.71141-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Now that the normal passthrough end_io path doesn't need the request
anymore, we can kill the explicit blk_mq_free_request() and just pass
back RQ_END_IO_FREE instead. This enables the batched completion from
freeing batches of requests at the time.

This brings passthrough IO performance at least on par with bdev based
O_DIRECT with io_uring. With this and batche allocations, peak performance
goes from 110M IOPS to 122M IOPS. For IRQ based, passthrough is now also
about 10% faster than previously, going from ~61M to ~67M IOPS.

Co-developed-by: Stefan Roesch <shr@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 drivers/nvme/host/ioctl.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 9e356a6c96c2..d9633f426690 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -423,8 +423,7 @@ static enum rq_end_io_ret nvme_uring_cmd_end_io(struct request *req,
 	else
 		io_uring_cmd_complete_in_task(ioucmd, nvme_uring_task_cb);
 
-	blk_mq_free_request(req);
-	return RQ_END_IO_NONE;
+	return RQ_END_IO_FREE;
 }
 
 static enum rq_end_io_ret nvme_uring_cmd_end_io_meta(struct request *req,
-- 
2.35.1

