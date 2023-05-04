Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A685C77B7C
	for <linux-scsi@archiver.kernel.org>; Thu,  4 May 2023 23:51:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjEDXvP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 May 2023 19:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229878AbjEDXvP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 May 2023 19:51:15 -0400
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF0E212E81
        for <linux-scsi@vger.kernel.org>; Thu,  4 May 2023 16:51:12 -0700 (PDT)
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ab1ce53ca6so8257825ad.0
        for <linux-scsi@vger.kernel.org>; Thu, 04 May 2023 16:51:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683244272; x=1685836272;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V8Uxvj/wTD2T5ak8fwHtVdBHmpOAUkbVV/O+znsathM=;
        b=b4niL1GuuFEFYj6HkV0ie1jy+g0PhoUmfWznpai9/cviriaHNNduGeSl19HTN3HW2j
         jatjy5eg0PKVUrIpDvhpC09UtNKjlu44NSui/OkLHse5UsUirCDSNKBS8ei5+jt/XAGL
         JpwQ4X9XAIsTeyFRhuh0SPlGI5z1CYGQplkOTl3JkKlMKDfjcQw7i9C/dZAikkVBDCJw
         2RgueWUk3tu8IjVwrUEe/0dxkiC88OUzsP0yfSbKt5euMTD8+CaeQJDFZisjIkmIuVdG
         NgWKUejzF26Tr0h95PwHHbfVc9ejH9zBQpWwQcCXLfWN+XRcZE1/xlk8E4D3lRcBveO2
         JoAA==
X-Gm-Message-State: AC+VfDzBPmFIy6ksfcTHtdd6lngZ8BNbCGyprC/0NZ+A/n8YSaclexa8
        Tp6z3C+EjXLnK740/8W8Q30=
X-Google-Smtp-Source: ACHHUZ6pPlUuHVI27nuAMDRIGBfjH9rnyOy4cOKZnD9oZM1Ngsk75fYwzwqL44tx+Wg73m5X3Zr+Yw==
X-Received: by 2002:a17:902:cece:b0:1a6:413c:4a3e with SMTP id d14-20020a170902cece00b001a6413c4a3emr6487631plg.5.1683244271844;
        Thu, 04 May 2023 16:51:11 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id j13-20020a170902758d00b001aad4be4503sm143169pll.2.2023.05.04.16.51.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 16:51:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/5] ufs: Do not requeue while ungating the clock
Date:   Thu,  4 May 2023 16:50:47 -0700
Message-Id: <20230504235052.4423-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

In the traces we recorded while testing zoned storage we noticed that UFS
commands are requeued while the clock is being ungated. Command requeueing
makes it harder than necessary to preserve the command order. Hence this
patch series that modifies the SCSI core and also the UFS driver such that
clock ungating does not trigger command requeueing.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (5):
  scsi: core: Rework scsi_host_block()
  scsi: core: Support setting BLK_MQ_F_BLOCKING
  scsi: ufs: Enable the BLK_MQ_F_BLOCKING flag
  scsi: ufs: core: Unexport ufshcd_hold() and ufshcd_release()
  scsi: ufs: Ungate the clock synchronously

 drivers/scsi/scsi_lib.c          | 26 ++++++-----
 drivers/ufs/core/ufs-sysfs.c     |  2 +-
 drivers/ufs/core/ufshcd-crypto.c |  2 +-
 drivers/ufs/core/ufshcd-priv.h   |  2 +-
 drivers/ufs/core/ufshcd.c        | 78 ++++++++++----------------------
 include/scsi/scsi_host.h         |  3 ++
 include/ufs/ufshcd.h             |  3 --
 7 files changed, 45 insertions(+), 71 deletions(-)

