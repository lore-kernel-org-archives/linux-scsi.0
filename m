Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4024CC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 06:15:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240909AbiCOGQs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 02:16:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiCOGQr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 02:16:47 -0400
Received: from mail-ed1-x535.google.com (mail-ed1-x535.google.com [IPv6:2a00:1450:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0E113CA5D;
        Mon, 14 Mar 2022 23:15:35 -0700 (PDT)
Received: by mail-ed1-x535.google.com with SMTP id h13so22832232ede.5;
        Mon, 14 Mar 2022 23:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=YTGTs0DjMy0hvQWXCmfeGu4I6rdTV43J4LhqCKCccmk=;
        b=VAYwMlJhncErpZj1ddCZJhy4RuQhcodpnaD8EKiXXfSymN1jG3pIQj1MoYFjXZFkYU
         xSADENl3rg3LEuh6I8RQ14FFqg3WygrgHXhTh4HA/wW2+TLJ/RE3Tr4wPEpiRjzh0ix3
         LAbVGqDOIanUU90cHM5KPqapqulvvDsbOkgbwvAAzf5jfDZiWtMbg2W28Vn4/12bERR9
         XEdbbM/e3sDbofnIgKHtUTisJennFBg8bTSieoLeL8NO6PNlH3l8U+teb2T+V1u3Wo8T
         /B1muk0wLrzo3TEF7Hs5GA3KG4EaeR/g2Pznl0DmwMr0RWVBy4gTX6ZOA5A1ixwLRuu4
         WsVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=YTGTs0DjMy0hvQWXCmfeGu4I6rdTV43J4LhqCKCccmk=;
        b=fYiIO+BluopSLBhk5ZrEkP0E3GOo+X6+nwRvRwGnY4ZBUrSTliaNofff9+OLpNIPNZ
         75q33bw/ve3zxMrXZOStOhcfxguXaYxf5mLlFlgoh2INht8nEIIjMfmgUR7ePYDwSIYV
         zRYYPC+RsJcFqJolTwImDYH8fM0uxUvXeeNS/8Kuiwo2Rmvazw/GH2Hu7niPfJzTG8GK
         qUF7QKdEzOwTjs+DEGlGVfKyPFc0g/R/NTSl6x1ewxDg6jfT5AG6fTkxbrgyQnnDu50W
         E2k9zHVXJ9denBaZluf8VygDhzLUUE/QVw0q+zo/uPqN0VlHEGYMVNjxUN8tZburwkKj
         5T8g==
X-Gm-Message-State: AOAM533B1PYwKjujucNcp1rZCncSLXfWedvlpQRF3cVTuiTG1nAshKiB
        qYKiF58FFleaB7RSazuWNZg=
X-Google-Smtp-Source: ABdhPJzA1/0wj3wjvlcpvJGfz22qoMu0Mkv5zCp/bmhAQ0W/8ceffGzHJb+1ovvOOO0pRixZhX8twQ==
X-Received: by 2002:a05:6402:5243:b0:417:3a3:c6e with SMTP id t3-20020a056402524300b0041703a30c6emr17593629edd.211.1647324934470;
        Mon, 14 Mar 2022 23:15:34 -0700 (PDT)
Received: from felia.fritz.box (200116b8264e9400282aff0ca67bda3e.dip.versatel-1u1.de. [2001:16b8:264e:9400:282a:ff0c:a67b:da3e])
        by smtp.gmail.com with ESMTPSA id h26-20020aa7cdda000000b0040f75ad0e60sm7562429edw.83.2022.03.14.23.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Mar 2022 23:15:34 -0700 (PDT)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] scsi: scsi_ioctl:drop needless assignment in sg_io()
Date:   Tue, 15 Mar 2022 07:15:20 +0100
Message-Id: <20220315061520.30745-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit ce70fd9a551a ("scsi: core: Remove the cmd field from struct
scsi_request") refactored sg_io(), so that it does not allocate directly
and hence does not return -ENOMEM in its error case. That makes a
remaining assignment of -ENOMEM to the return variable needless.

Drop this needless assignment in sg_io().

No functional change. No change in resulting object code.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
Christoph, please ack.

Martin, please pick this minor clean-up on your -next tree on top of the
commit above.

 drivers/scsi/scsi_ioctl.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/scsi_ioctl.c b/drivers/scsi/scsi_ioctl.c
index 0613015cae39..a480c4d589f5 100644
--- a/drivers/scsi/scsi_ioctl.c
+++ b/drivers/scsi/scsi_ioctl.c
@@ -434,7 +434,6 @@ static int sg_io(struct scsi_device *sdev, struct sg_io_hdr *hdr, fmode_t mode)
 	if (hdr->flags & SG_FLAG_Q_AT_HEAD)
 		at_head = 1;
 
-	ret = -ENOMEM;
 	rq = scsi_alloc_request(sdev->request_queue, writing ?
 			     REQ_OP_DRV_OUT : REQ_OP_DRV_IN, 0);
 	if (IS_ERR(rq))
-- 
2.17.1

