Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BB43C00140
	for <linux-scsi@archiver.kernel.org>; Sun, 21 Aug 2022 22:05:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbiHUWFQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 Aug 2022 18:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231465AbiHUWFN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Aug 2022 18:05:13 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 302BA13F75
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:13 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id m15so1185373pjj.3
        for <linux-scsi@vger.kernel.org>; Sun, 21 Aug 2022 15:05:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=1rIWBeR0IOKw3d+ll/XkxHrj9heOxfjsNKVKzFXct/U=;
        b=WSxdi4kyjSKAWpR7Lu7sDbfQPfgZ0ytasEclYQqRJAIWOMCVX4q4RcZVli+VW+DxPs
         UoT/C5+cqYRqQ7yFvD0P6rnCLKCzxeOST30T3KFmu7DFWoXc1TqbM27bDNY0W5pWBJ0r
         2Ls0zhBgiUJrS4gk+5EMFixhBWBHhK8hvgOQRSN6eX/j4BQuSefggvudEmlzqs3Jvzg8
         QylvTJBy3EljFxDjXjLTANX1bjXzIcW7AtoD0tCcrL3SrHSRwIce/iVBbD9IGF/RvoEU
         +rcFhxeiFqCmvKa1kAk4wIi3vidP7IBllVDxKZgftdCJE5RnXUasmMPjlGYV9/N+Rb3b
         cMvg==
X-Gm-Message-State: ACgBeo0tKTAdiqQv/LLZEFRhkXW17XkFTeWcNbHlk3HWO0w9+ZI3gqKU
        zjEIFIcUgyQ9a+2xvmSh5beOO8/T9lM=
X-Google-Smtp-Source: AA6agR5lxSjLR9D+b1dBMWIwAXWVQXZ4fmurNuNdOlJY/a7EY/EH5sCeilDVLo99P6EPmY10wHum5Q==
X-Received: by 2002:a17:90a:5d83:b0:1fa:c5ca:b90d with SMTP id t3-20020a17090a5d8300b001fac5cab90dmr20629966pji.89.1661119512462;
        Sun, 21 Aug 2022 15:05:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id f17-20020a170902ce9100b0016c09a0ef87sm3110994plg.255.2022.08.21.15.05.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Aug 2022 15:05:10 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Revert "Call blk_mq_free_tag_set() earlier"
Date:   Sun, 21 Aug 2022 15:04:58 -0700
Message-Id: <20220821220502.13685-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Since a device, target or host reference may be held when scsi_remove_host()
or scsi_remove_target() is called and since te patch series "Call
blk_mq_free_tag_set() earlier" makes these functions wait until all references
are gone, that patch series may trigger a deadlock. Hence this request to
revert the patch series "Call blk_mq_free_tag_set() earlier".

Thanks,

Bart.

Bart Van Assche (4):
  scsi: core: Revert "Call blk_mq_free_tag_set() earlier"
  scsi: core: Revert "Simplify LLD module reference counting"
  scsi: core: Revert "Make sure that hosts outlive targets"
  scsi: core: Revert "Make sure that targets outlive devices"

 drivers/scsi/hosts.c       | 18 +++++-------------
 drivers/scsi/scsi.c        |  9 +++------
 drivers/scsi/scsi_scan.c   |  9 ---------
 drivers/scsi/scsi_sysfs.c  | 29 ++++++++++++-----------------
 include/scsi/scsi_device.h |  2 --
 include/scsi/scsi_host.h   |  3 ---
 6 files changed, 20 insertions(+), 50 deletions(-)

