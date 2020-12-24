Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C219BC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B0D22288
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Dec 2020 17:21:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728266AbgLXRVG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Dec 2020 12:21:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727144AbgLXRVG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Dec 2020 12:21:06 -0500
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C71E3C061575;
        Thu, 24 Dec 2020 09:20:25 -0800 (PST)
Received: by mail-ed1-x52d.google.com with SMTP id c7so2626805edv.6;
        Thu, 24 Dec 2020 09:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=aopfLSwuZWXOzuLcW70/gkbtn81TyXqm8hq0ZyMhNtA=;
        b=eE4WRR6sY1vD5NYrYbFhy8mgE5GkUPD7FMyuAANPJzGYI1AzOHJhlSgJzddzj+REAX
         /sb2zdgS0QZAy0YujeH92PNwYSTEKGXf7WLvV/VyfPrY0kpUyiFVPkSg9KphPMGBByOs
         hsLJ8yv1si3c6zC3MywKEG/fDxlJTskwBRdCqJ+Im3TVpVhwimAhNu7rhq9Za8gc9APi
         F8Fc6+nZ9pwdeS0Ib1c3b+LnCJJs4IV4r5AJEPdIeJhMFxCAQB8Ld1eldcKg3g6D6jt+
         FOfRhGLEk2b7EVXK9f0jmQ171f9VIrj9dubY3ewewwKGbvNeyNarhv9CyJax+yuUEb1m
         loUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=aopfLSwuZWXOzuLcW70/gkbtn81TyXqm8hq0ZyMhNtA=;
        b=JRtscCjvrjEEMyHyvYSbTE4ORkgouYEFxsy7/nq7MUpixMoxwhHg1h0pbwREmAQ7Dl
         AQkyZyny+xPEcJkO9KQ6Tb/gvQ6jVMXEdluSSaBOqsKWnWPwDB2X0lO9e8viZpH/wIEL
         4vCWVtKg2L5nwXb3CoFTdzjm/++B265rgxk8HkiDPpGnlWWrGX4CS5pseN5kLAwrZOBE
         RVN3qvlHLaVOmO7bcZnLnyV2rjKo/7tCjnoGxEKLDVYowqtnTAb1ZLu4fCHgyc629YCU
         IXobQpQplwBUFbB0mcCB9QLK6SPWHkeSF/NeETttwxbE5USVcOkhiWZSa71T/QDXECpD
         YcQg==
X-Gm-Message-State: AOAM531jzSJpuENUdd1ypQlQUNiAIvA4EaPGupVjagCcyfgOEBe1ANUo
        pem5kv5NbyPPweZDkr6JPnI=
X-Google-Smtp-Source: ABdhPJy3wb8CGgBmsggqidmuWTh9g9iy5TEJFCfwuu3mK7lDLfsMGCp+VzTHIqsTnz5dGSjz8zR2SQ==
X-Received: by 2002:aa7:de0f:: with SMTP id h15mr29730128edv.110.1608830424594;
        Thu, 24 Dec 2020 09:20:24 -0800 (PST)
Received: from localhost.localdomain (ip5f5bfce9.dynamic.kabel-deutschland.de. [95.91.252.233])
        by smtp.gmail.com with ESMTPSA id m5sm12874446eja.11.2020.12.24.09.20.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Dec 2020 09:20:24 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net
Subject: [PATCH v2 0/3] Two changes of UFS sysfs
Date:   Thu, 24 Dec 2020 18:20:07 +0100
Message-Id: <20201224172010.10701-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Changelog:

V1---v2:
    1. Add new patch "Let resume callback return -EBUSY after ufshcd_shutdown",
       Because the ufshcd_*_resume still returns successful result 0 after
       ufshcd_shutdown(). Even add handling of the return value of
       pm_runtime_get_sync(), but still there is timeout.

Bean Huo (3):
  scsi: ufs: Replace sprintf and snprintf with sysfs_emit
  scsi: ufs: Add handling of the return value of pm_runtime_get_sync()
  scsi: ufs: Let resume callback return -EBUSY after ufshcd_shutdown

 drivers/scsi/ufs/ufs-sysfs.c | 68 +++++++++++++++++++++++++-----------
 drivers/scsi/ufs/ufshcd.c    | 12 ++++---
 2 files changed, 55 insertions(+), 25 deletions(-)

-- 
2.17.1

