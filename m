Return-Path: <SRS0=dnbB=CN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91C54C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 41F432084D
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Sep 2020 20:06:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LdZ1iew7"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727051AbgIDUGK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Sep 2020 16:06:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgIDUGI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Sep 2020 16:06:08 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C838FC061244
        for <linux-scsi@vger.kernel.org>; Fri,  4 Sep 2020 13:06:08 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id h2so1673925plr.0
        for <linux-scsi@vger.kernel.org>; Fri, 04 Sep 2020 13:06:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=EcapTIGFf+31wVMqsHZgBSE+2BUv5P+WBgtFpuHKTB4=;
        b=LdZ1iew781MsmUY9b5ayzdV8tZn4cX+ULtEHpTLX2wxSqa3q1eCh2Rb0Vy10Is8vsF
         lqvvA9Y5FyVU4l2ni5ijNwJllCfyu/Qnzqm+C8Bt+PQk6pyKYOm4+/TtSWrK2tk4iq8p
         jn4hXE4r2/V429/yXum1WDMVpeiR3OXCmwh6LnDEnhqYn6tMQxrCYqck8lwfudsdCfla
         BptYvLVcR8IJt9d8H571KslUJDTGF2Yb1IqeNvzDv4hfbM+L6Qwy593y9i0XEYx7gz3g
         LezfpNYnqCZI9ccDXQMeIQ0s50pOgXZTaKa0+bXV/Mmb5QAOPUQ4Pasu/PfKq7pThqhA
         iiLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EcapTIGFf+31wVMqsHZgBSE+2BUv5P+WBgtFpuHKTB4=;
        b=nIp5HDARnxbPQSJZthLy5cQnGyFx6cr7VyioLTWOndKdpH3ohzlPh0Avo1tcqyDj0s
         91q2MeplEFq9FxYXlkrDbhP8qSuqdh0btT/zYQ9FxKrqyoLmAz7qzYjpQgRI8bFs5CUE
         PQIumDXFKTAJgf9LMkl8ZM2rlxWgYWA0PcYj3kZZrUaWibAf+hBpf/liMzRs03wx3VYo
         IfAhtCmev1Ogcm+R4GpiQH0kIkc0/CWYbKo8xbrFM3+pjPCuSgNz9B1pj4T9E9fZ2vnC
         leHDOJI9sLohFFBR+CgUtupMjoa0KlOhY2zWKf294uP9m0L/ngn4SXZBVASclilgwdeH
         l8dw==
X-Gm-Message-State: AOAM530Ypj29PgwjC0D0d8C4DKiTX1Zx4s6wuEaiGWlHhCDDcfQZyWZE
        JxsK6vf4LPpeXoTBTTtzwrk2NZ5SX74=
X-Google-Smtp-Source: ABdhPJz1yHiYC4VvTFmAiQ0vmglbgBCb0gJtN9PCc/o+LHsUI4ZZnc38M7yHnUn8T7Jwjch9qqx3qw==
X-Received: by 2002:a17:902:a60e:: with SMTP id u14mr10353745plq.179.1599249968026;
        Fri, 04 Sep 2020 13:06:08 -0700 (PDT)
Received: from localhost.localdomain ([161.81.62.213])
        by smtp.gmail.com with ESMTPSA id k5sm21131905pjl.3.2020.09.04.13.06.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Sep 2020 13:06:07 -0700 (PDT)
From:   Tom Yan <tom.ty89@gmail.com>
To:     linux-scsi@vger.kernel.org, dgilbert@interlog.com
Cc:     stern@rowland.harvard.edu, James.Bottomley@SteelEye.com,
        akinobu.mita@gmail.com, hch@lst.de, jens.axboe@oracle.com,
        Tom Yan <tom.ty89@gmail.com>
Subject: [PATCH 2/4] scsi: sg: implement BLKSSZGET
Date:   Sat,  5 Sep 2020 04:05:52 +0800
Message-Id: <20200904200554.168979-2-tom.ty89@gmail.com>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200904200554.168979-1-tom.ty89@gmail.com>
References: <CAGnHSE=fY2wkzNeZTSHC37Sp-uD4D8YMEb7LesDkPcQWAfiK=w@mail.gmail.com>
 <20200904200554.168979-1-tom.ty89@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Provide an ioctl to get the logical sector size so that the maximum
bytes per request can be derived.

Follow-up of the BLKSECTGET fix.

Signed-off-by: Tom Yan <tom.ty89@gmail.com>
---
 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index e57831910228..0e3f084141a3 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1118,6 +1118,8 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 		max_sectors = min_t(unsigned int, USHRT_MAX,
 				    queue_max_sectors(sdp->device->request_queue));
 		return put_user(max_sectors, ip);
+	case BLKSSZGET:
+		return put_user(queue_logical_block_size(sdp->device->request_queue), ip);
 	case BLKTRACESETUP:
 		return blk_trace_setup(sdp->device->request_queue,
 				       sdp->disk->disk_name,
-- 
2.28.0

