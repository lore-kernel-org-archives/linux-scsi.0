Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E290C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 10 May 2022 20:00:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233112AbiEJUAj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 May 2022 16:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233342AbiEJUAh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2022 16:00:37 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A616299579
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:36 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id j14so17717759plx.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 May 2022 13:00:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VqJsIc0SbJbGEuXy3GranTUcHueIpqcNhClDhLvd1Ak=;
        b=Bj4mkjtA9Qj5rl3Y0dDYgQPEFLrpHSmq+zVhPtmwzLfMjK2bH9bEY8MwXMSxhOJ/x5
         bDeUDLXCnXwE7SxfF4/Xd1NyT7Z9x2UnieVEeJhrEr0Si3wnAGshA6+2VBpEwSaFZT4a
         d5j4IG6QwHZUxAks8oM3IREcqUeLLfqF5qhLP2FVnp/ppBNX8lg/iXMp3kf02jT2/XwC
         o7tVW538wWsvV76Mkao8CroEEq5MDpw2J8XuD8ydc99mBnB7OMZNvfPkMfIgjAd//9P0
         OymrO/87qiV+i3vTJWPE3JtjD6RjgX7Az40KiyXFPKA54ietCpc936chTybDTeKpArPF
         4XmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VqJsIc0SbJbGEuXy3GranTUcHueIpqcNhClDhLvd1Ak=;
        b=xsE1Y/d0rl1XwUyS4ESwqm5cbmgOBUhwgJk3WbQUdqZCbq4EJ46F7NSrnD9IwinFQY
         sqWZM9jFPHAw6hJXn4Iq9f0j4prMkWYVp7pudGNJ3LWuXWlH6w4JZ9h8sItWQB111Bhs
         Y11QXGinoxrGMavdEmKYzOlMY3Ku1MdCBdGaPycci8prns/8Y9AZGkQlpldjfbfuu3or
         BF0fkAS8B7kJaI/18AoUD6plpV1o2klua3bjb9r6fex53612jIYldi5mQriWW8vAd+zu
         guwSPkskk7CA28XyKwWlehNk6Xjkd5IIy8NoUT6CAjlQMnu84tbgpfNp6haxQV1Nsihn
         yG3Q==
X-Gm-Message-State: AOAM5308nMSEJY7kvGSzSUZRNz81ez9yCOD0gx8J9Fd9dQY8jK/wtD/W
        /8fNlSJQxdv6Vn16Vd0t+l7fABSRmzA=
X-Google-Smtp-Source: ABdhPJy3n/8nzMr4Ggjf4DWYHoVuCwuUYLoPVj1opnotMITyM3Dmx7x0ICa8tZfpIheoCrhDxTTNgg==
X-Received: by 2002:a17:90b:3646:b0:1d8:15c5:464b with SMTP id nh6-20020a17090b364600b001d815c5464bmr1532084pjb.63.1652212835584;
        Tue, 10 May 2022 13:00:35 -0700 (PDT)
Received: from mail-ash-it-01.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2d2sm2422679plb.284.2022.05.10.13.00.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 May 2022 13:00:35 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org, James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/4] Add VMID support to nvme-fc transport and lpfc driver
Date:   Tue, 10 May 2022 13:00:24 -0700
Message-Id: <20220510200028.37399-1-jsmart2021@gmail.com>
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

James Smart (3):
  lpfc: commonize VMID code location
  lpfc: rework lpfc_vmid_get_appid() to be protocol independent
  lpfc: Add support for vmid tagging of NVMe I/Os

Muneendra (1):
  nvme-fc: Add new routine nvme_fc_io_getuuid

 drivers/nvme/host/fc.c         |  16 ++
 drivers/scsi/lpfc/Makefile     |   2 +-
 drivers/scsi/lpfc/lpfc_crtn.h  |   3 +
 drivers/scsi/lpfc/lpfc_nvme.c  |  45 ++++++
 drivers/scsi/lpfc/lpfc_scsi.c  | 263 +-----------------------------
 drivers/scsi/lpfc/lpfc_vmid.c  | 288 +++++++++++++++++++++++++++++++++
 include/linux/nvme-fc-driver.h |  14 ++
 7 files changed, 371 insertions(+), 260 deletions(-)
 create mode 100644 drivers/scsi/lpfc/lpfc_vmid.c

-- 
2.26.2

