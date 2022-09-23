Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97738C6FA82
	for <linux-scsi@archiver.kernel.org>; Fri, 23 Sep 2022 14:51:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232136AbiIWOvY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 23 Sep 2022 10:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230055AbiIWOvW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 23 Sep 2022 10:51:22 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6199B12849B
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 07:51:20 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id c11so330574wrp.11
        for <linux-scsi@vger.kernel.org>; Fri, 23 Sep 2022 07:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date;
        bh=jzpvzviXTgxdaGIkP6ni8Vu+qZd6ChhilJYt2SFB8Os=;
        b=WGq6+dSwvF+C8MsdQQ7TSk0E8wYwP197dxpGzG4woN3Rb4JVINsKKTrfY+ZJCYG5eV
         NI3FjwsEwTmQD4S8NePH/XTZ7x5hODdJjPi/r3WXoIe/zhHGjuM8hzJLnMmdAfj+JspU
         A67RwTtFSSiephEElByGGdxe2isMYG6yfvWyb9ImKgtR5DEw2o4YEIzxvAG5gpOCrwun
         KKN+0GYgtwqKC2NDTwvDiuD6+OEQ6K4HA4x+Wjkgrtg7bNocpbgqmJOG0yv1yeuCckIc
         PTt8I2Ncl4XmzNLcZxFVWxBHhXmr4CwbZAycK0ZQPCSn3sxXx08ZvM3h5hAq7/Tnjdzy
         IIWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=jzpvzviXTgxdaGIkP6ni8Vu+qZd6ChhilJYt2SFB8Os=;
        b=QxwcuUMg4AhRiwU1Mpov7i7Sa8iAkP35tPGh8ve9UXx5YzISR5aiVd8aEj+u+XOUT6
         aloGmXv+u3kgVD496AW89FMa2QOaTnQ3XGE1i1yhTjm1Db130SKy2ZV3sco+jh9wlKi0
         YNV71/YSM/4+SQlrT9k1fKYj6iDLZvONw7krBCQwESSFn37CSQm8sgUdPOZhgySef5cj
         O4I3mvZWxL7exYApkq4PDeEPdLdQkEZ+twDzjHYJSQ/9inXX3hILk/4qUAfXMq6gbden
         JRG8Q630GNo3zfn9xtGupx651c0bIj3mHs2hcWjd4wNge1S7uux8YXrga1ZEGJtZ9Ut7
         DPtQ==
X-Gm-Message-State: ACrzQf0jV3tkQWCtaryCXs7Bg68kONRa/989Y5GBDmAohUDZUp/moavf
        maiJrJ/iEa+dzFvbyKjIoquOrncVhPNV6NIInArno/v/9usUJg==
X-Google-Smtp-Source: AMsMyM4o6uO6/+pDEZdsqvYToD9aHUbyC/9X3oOTvUNC7PGGmgU90ASAaMcebM90CJgm7FTd4/zO9MG5IwP/NpmVkEw=
X-Received: by 2002:adf:e186:0:b0:22a:3329:540f with SMTP id
 az6-20020adfe186000000b0022a3329540fmr5424962wrb.278.1663944678867; Fri, 23
 Sep 2022 07:51:18 -0700 (PDT)
MIME-Version: 1.0
From:   Hao Peng <flyingpenghao@gmail.com>
Date:   Fri, 23 Sep 2022 22:51:07 +0800
Message-ID: <CAPm50aJ_aW4RmL3_n=5CpGL9D3dXENenFuo5QG0Q2DJO9Gv_1w@mail.gmail.com>
Subject: [PATCH ] scsi/ipr: keep the order of locks
To:     "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Peng Hao <flyingpeng@tencent.com>

ipr_ata_post_internal:
    acquire host_lock
       acquire hrrq->_lock
             ipr_device_reset
                 ipr_send_blocking_cmd
                    release host_lock
                    acquire host_lock
       release hrrq->_lock
    release host_lock

As shown above, there are two lock acquisition order changes.
At the same time, when ipr_device_reset is executed, the lock
hrrq->_lock does not need to be held.

Signed-off-by: Peng Hao <flyingpeng@tencent.com>
---
 drivers/scsi/ipr.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/ipr.c b/drivers/scsi/ipr.c
index 9d01a3e3c26a..6ca987dda397 100644
--- a/drivers/scsi/ipr.c
+++ b/drivers/scsi/ipr.c
@@ -6837,7 +6837,9 @@ static void ipr_ata_post_internal(struct
ata_queued_cmd *qc)
                spin_lock(&hrrq->_lock);
                list_for_each_entry(ipr_cmd, &hrrq->hrrq_pending_q, queue) {
                        if (ipr_cmd->qc == qc) {
+                               spin_unlock(&hrrq->_lock);
                                ipr_device_reset(ioa_cfg, sata_port->res);
+                               spin_lock(&hrrq->_lock);
                                break;
                        }
                }
--
2.27.0
