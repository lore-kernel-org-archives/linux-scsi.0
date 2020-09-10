Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,
	DKIM_ADSP_CUSTOM_MED,DKIM_INVALID,DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D66A9C433E2
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 10:15:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C32020829
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 10:15:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=google.com header.i=@google.com header.b="uwSjVicy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726808AbgIJKPs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 06:15:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730718AbgIJKPS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 06:15:18 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D88C061573
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 03:15:18 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id l186so4972834ybf.3
        for <linux-scsi@vger.kernel.org>; Thu, 10 Sep 2020 03:15:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=mYpLRmqZZNbowlnMVp5aofFQ5BShHcephw2SKa0G+DA=;
        b=uwSjVicytfVIBYIjNeLQ0S++GaFHI6da2IvVQ1a7tPxuevmnOvVFRW8+HwjHJ8tZXr
         gXArB/ETfRlhFAbs/BrfA2takdMvL9pHyuWt2qVvc6kQBmwqpwARV3uCMCr+xAhyTxqd
         g4qiYBX3bwWmJWBPoys1yHgg23Qhhz4ZdhRrEpOqhFkVQYt1znuPerz2O+E3tUB/sair
         4v8jtMYMu2pN5SAU4Dwlfc6ztiLmgYkSUODfLiQWpI2810zlOOrm7rLNyts87EGr/3mZ
         N0H7ptJWMVDSBGZrNtiUZyfOMVC5FVb0HTQw4M3EyhEXv0Ueyq2+XZ95uw5qSyXE5kEs
         Gu0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=mYpLRmqZZNbowlnMVp5aofFQ5BShHcephw2SKa0G+DA=;
        b=MBXwNCwLb5XirZjQdsQ9dA7ll+ywg4lLlVNB/SI6vz4ij5wgflsPxMuRZ0U74UmZVp
         lXXiPN/ZhuXuHER0tFGSXOpmqb4+G6tjG95I39UOkeycRXZ2sYu/VtHGAGfpSYN3PohM
         tTtyKUoafP1H/nL0oNLsGrX7jp6IbaHt1Rj2ISSqZFpbBcXvmwr9ZV+65IUWSyAxwzij
         jnwk/oDCAsOGwA+N+6/+HFdLL21gyup2z8oWuLIsEARnEhrD6/l5osPZa68X2mWk6mRL
         VH4grP//ihX6DP7XkXc7q2rFDVtj5ZkHdhUsG/YJaBF2Y1uiR4gkaXICilh9b4bmuee2
         soMA==
X-Gm-Message-State: AOAM530E2xRmCA6Mhxwljam8hJoOscictwUUxA5vm3ZKW3qke6/vQXgv
        kwQmdaW4VnpxZWwZZb6nOoSzFoLm8gvCaJ1QoeA=
X-Google-Smtp-Source: ABdhPJzATmV4RhOQNteGALkdPJ93cqcUh0oOS9eTKpZbNLT9tBvt6yJnMdaRqHNDDwBwIi8UrQjYI1T9+go2q3X89kg=
X-Received: from huangrandall-z840-2.tao.corp.google.com ([2401:fa00:fd:2:3e52:82ff:fe5f:bc1])
 (user=huangrandall job=sendgmr) by 2002:a25:da8c:: with SMTP id
 n134mr12091694ybf.84.1599732917609; Thu, 10 Sep 2020 03:15:17 -0700 (PDT)
Date:   Thu, 10 Sep 2020 18:15:13 +0800
Message-Id: <20200910101513.2900079-1-huangrandall@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.526.ge36021eeef-goog
Subject: [PATCH] scsi: clear UAC before sending SG_IO
From:   Randall Huang <huangrandall@google.com>
To:     dgilbert@interlog.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     huangrandall@google.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Make sure UAC is clear before sending SG_IO.

Signed-off-by: Randall Huang <huangrandall@google.com>
---
 drivers/scsi/sg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 20472aaaf630..ad11bca47ae8 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -922,6 +922,7 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 	int result, val, read_only;
 	Sg_request *srp;
 	unsigned long iflags;
+	int _cmd;
 
 	SCSI_LOG_TIMEOUT(3, sg_printk(KERN_INFO, sdp,
 				   "sg_ioctl: cmd=0x%x\n", (int) cmd_in));
@@ -933,6 +934,13 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
 			return -ENODEV;
 		if (!scsi_block_when_processing_errors(sdp->device))
 			return -ENXIO;
+
+		_cmd = SCSI_UFS_REQUEST_SENSE;
+		if (sdp->device->host->wlun_clr_uac) {
+			sdp->device->host->hostt->ioctl(sdp->device, _cmd, NULL);
+			sdp->device->host->wlun_clr_uac = false;
+		}
+
 		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
 				 1, read_only, 1, &srp);
 		if (result < 0)
