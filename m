Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C495C00140
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Aug 2022 20:46:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233698AbiHLUqP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Aug 2022 16:46:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229942AbiHLUqO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Aug 2022 16:46:14 -0400
Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C8F598C94
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:13 -0700 (PDT)
Received: by mail-pg1-f170.google.com with SMTP id 12so1722886pga.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Aug 2022 13:46:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=booqPLZIA2OIYiqYi/U9VEcjmoXXSa+ZI/2UgzYhBIQ=;
        b=dOJ9XzdCGTaASKhmBTn2Ttr8M8q+My/6EgJj7GSZdnF6IU+yQ1/KzBeoS2kDMW3sIC
         R8CxAKQDW5sZjBTF8/4io+hfsbQzs6UKC7wxAWPe2684Q5EVRjiAPSCAAP7M+esSGVFy
         b2pMP5K+aArRk+yVe6WUqj33UV5aQtPRPHctsYiBOE4UJGTlOlGIHma2AEcWwYLO6rYw
         51tvohqM0m03T+sRGv7MXhiJTlCW/A0iwlbEuIg0IlTNO6vnJmafLdifEww21WJv0Zl9
         /ugIUsSFNqxpBxcfUb4ObbbjWfGvcdtxpdu75MpZH8mnEBKOMKEBOgmy5XjQ7Ecdholg
         c+PQ==
X-Gm-Message-State: ACgBeo3If8FE+RC5OFOksBIfhN4uu5/EU3BEuwAfl3K4McZzLAf0Zu/i
        mAFIkRUBGCR0U7ThAvZz8n4=
X-Google-Smtp-Source: AA6agR6A9oBxo3l+xAbMTg6Gf2yqlNG+QxuadOhBCHJI/dQ/XmwttTmXkQKxMjLdD44XCMYQtpjUGg==
X-Received: by 2002:a05:6a00:1d9e:b0:52d:aa13:67fc with SMTP id z30-20020a056a001d9e00b0052daa1367fcmr5257364pfw.73.1660337172632;
        Fri, 12 Aug 2022 13:46:12 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2414:9f13:41de:d21d])
        by smtp.gmail.com with ESMTPSA id o8-20020a17090a4e8800b001ef7c7564fdsm243189pjh.21.2022.08.12.13.46.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Aug 2022 13:46:11 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/4] Remove procfs support
Date:   Fri, 12 Aug 2022 13:45:49 -0700
Message-Id: <20220812204553.2202539-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.1.595.g718a3a8f04-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The SCSI sysfs interface made the procfs interface superfluous. sysfs support was
added in the most prominent user of the procfs interface (sg3_utils) in 2008. The
implementation of the procfs interface makes it harder than necessary to constify
the SCSI host templates. Hence this patch series that removes the procfs interface.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Bart Van Assche (4):
  scsi: esas2r: Rename two functions and two variables
  scsi: esas2r: Remove procfs support
  scsi: core: Remove procfs support
  scsi: core: Update a source code comment

 drivers/scsi/Kconfig               |  11 -
 drivers/scsi/Makefile              |   1 -
 drivers/scsi/esas2r/esas2r.h       |   4 +-
 drivers/scsi/esas2r/esas2r_ioctl.c |   2 +-
 drivers/scsi/esas2r/esas2r_main.c  |  43 +--
 drivers/scsi/hosts.c               |   5 -
 drivers/scsi/scsi.c                |   8 +-
 drivers/scsi/scsi_devinfo.c        | 146 ---------
 drivers/scsi/scsi_priv.h           |  17 -
 drivers/scsi/scsi_proc.c           | 477 -----------------------------
 drivers/scsi/sg.c                  | 358 ----------------------
 include/scsi/scsi_host.h           |   8 +-
 12 files changed, 14 insertions(+), 1066 deletions(-)
 delete mode 100644 drivers/scsi/scsi_proc.c

