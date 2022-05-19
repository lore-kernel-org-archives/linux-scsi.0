Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E00A4C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 19 May 2022 12:31:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237905AbiESMb0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 May 2022 08:31:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiESMbT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 May 2022 08:31:19 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF501759F
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:17 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id i17so4646153pla.10
        for <linux-scsi@vger.kernel.org>; Thu, 19 May 2022 05:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oiA6uiLQZSwvY/0jBnBgVrltTu8yb3o9abMqa/qFOXg=;
        b=R6ldpVwsTE4CVUrBYHWqee3M8xzqw4+8mc88wsNGLQP/XAXR9DQ92ecg1uf+kvlgUo
         mUWqcdHz85zydl5AwGFaj7tLi+w9h8TdVFROA6KuGVprU/yqajOtHujpcp2wieT+bMW0
         XzfUS4/OxrJOIkpCeN5mhrTLsCbdmr6t1tkNwCrGEOFwISPQ5sW2ewpEoH64hxEW/CoB
         6rmrwprFHCiwGwDoc8vxV+VNXh/ioIlXldEBARsEiPdGXpHYsF5wwcefakGAwsklpwmT
         +Hh3ZlTzgZTgY+EzDObyLw4GYpCwXdj/UcCgHn0u8IQQRQYLglU9YwzCaQNmrOvSvb+l
         J0gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oiA6uiLQZSwvY/0jBnBgVrltTu8yb3o9abMqa/qFOXg=;
        b=hYoqd3RHdVUj7pEsFekmUKZI38U9zQu554+1QW0JRybVe40M0r0KJ4GAnIMnlbmGz6
         e0GFkImgrE0vb9dyLs9tEHvS1FpAdJ/j5bYOaJdhEBtyKCytfkktDvzqOF7hOuILf//6
         P8EBrMThgxtWmT1V1WLLuWfGmj630CPBKKamm73IKhW1dDdrlBjlMGBPiGe0wHFt9v7u
         5qngE2XnB9l6kkF0yb/VTW0QUGVov5g4P6iGwEYtfG62wmtEXNnmrFdpWKeyU/gzKnHW
         QAN/u+TZ9YJFMt2hDYggyRAXRkjelCVjGfzoZ5Rj6Qu77xw8h5CrENXWGmpVTJbtHd7X
         j40w==
X-Gm-Message-State: AOAM5324aA3rcbCs+VS4rD4+8/+kzSoytd0sDSgs3YPLdEujO8jq4Fk6
        RTHgNK0HYtXUFbyPUoCvkRJEI5pkuTw=
X-Google-Smtp-Source: ABdhPJzR5Yus1C91XEZYExrsAaApATfMh2spzjXAM6WhQqJUCzEMe36Ef7GbqYNOeyQEliMzZogLyw==
X-Received: by 2002:a17:902:db0e:b0:15e:b847:2937 with SMTP id m14-20020a170902db0e00b0015eb8472937mr4699942plx.8.1652963477196;
        Thu, 19 May 2022 05:31:17 -0700 (PDT)
Received: from mail-lvn-it-01.broadcom.com (ip174-67-196-173.oc.oc.cox.net. [174.67.196.173])
        by smtp.gmail.com with ESMTPSA id z26-20020aa79e5a000000b005180f4733a8sm3581797pfq.106.2022.05.19.05.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 May 2022 05:31:16 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH v2 0/4] Add VMID support to nvme-fc transport and lpfc driver
Date:   Thu, 19 May 2022 05:31:06 -0700
Message-Id: <20220519123110.17361-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch adds vmid support to the nvme-fc transport.

Various virtualization technologies used in Fibre Channel
SAN deployments have the ability to identify and associate traffic
with specific virtualized applications. The T11 standard defines
an application services tag that can be added to FC traffic to aid
in identification and monitoring of traffic associated with the
applications.

VMID support is present in the kernel in blkcg, the SCSI fc transport
has tied into the infrastructure, and libvirt has been
updated to support the blkcg settings.  Refer to:
https://lore.kernel.org/all/20210608043556.274139-1-muneendra.kumar@broadcom.com/

This patch set ties the nvme-fc transport into the blkcg infrastructure
so that vmid tags can be added to nvme traffic. The patch set also
updates the lpfc driver to utilize the nvme-fc transport addition.

Although the patch adds a nvme interface, it is being sent to the SCSI
maintainers tree due to the lpfc dependencies.  As there is no other
consumer of the new interface, when the scsi tree merges with mainline,
the new interface will be picked up there.

Patches cut against scsi 5.19/scsi-queue tree with lpfc 14.2.0.3 patches
included.

V2:
Revised the first patch which calls blkcg_get_fc_appid().
Fixes build errors when merged with 
 blk-cgroup: move blkcg_{get,set}_fc_appid out of line
 commit db05628435aa


James Smart (3):
  lpfc: commonize VMID code location
  lpfc: rework lpfc_vmid_get_appid() to be protocol independent
  lpfc: Add support for vmid tagging of NVMe I/Os

Muneendra (1):
  nvme-fc: Add new routine nvme_fc_io_getuuid

 drivers/nvme/host/fc.c         |  18 +++
 drivers/scsi/lpfc/Makefile     |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h  |   3 +
 drivers/scsi/lpfc/lpfc_nvme.c  |  45 ++++++
 drivers/scsi/lpfc/lpfc_scsi.c  | 263 +-----------------------------
 drivers/scsi/lpfc/lpfc_vmid.c  | 288 +++++++++++++++++++++++++++++++++
 include/linux/nvme-fc-driver.h |  14 ++
 7 files changed, 373 insertions(+), 260 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_vmid.c

-- 
2.26.2

