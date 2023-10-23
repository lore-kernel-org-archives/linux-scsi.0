Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F0F1C25B46
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Oct 2023 20:36:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbjJWUgv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Oct 2023 16:36:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjJWUgu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Oct 2023 16:36:50 -0400
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18E83D78;
        Mon, 23 Oct 2023 13:36:49 -0700 (PDT)
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-6b9af7d41d2so3098718b3a.0;
        Mon, 23 Oct 2023 13:36:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698093408; x=1698698208;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FgLrUB7eiLnDutwZM1YOsEZDerSDuOWUKcD279kgNF0=;
        b=pzGGn7TqUy12Etfng4/3hOdlZ/eZjqrLB72qauuvbWtpfrPXBJdQHCkM9hixODWB7Y
         0mefzTh7Xdab0Goki1+cILvoAltIReS8vLkmVGa40ue5QYIG0iRFFB8RYhSwl5+i36UN
         3HvoGd1LVNpcwY3mzh1XqwcQqtpLAKpWPu3dSL9rvvYkHEQt5IxkqdJp78yVmMwgXaXp
         hrN8rM+w/lXDDODhDdHzv5Db3mc9qay6A4LLE+30eO3WO5YPyGUMNqmKD78lCmM1+qBQ
         n4OgoEs47pMdW41ouWtuntRNV7+sjU7aeEBOAZNATpTME1YVtBxngBUqrrCeHCox+FNv
         bH9A==
X-Gm-Message-State: AOJu0YxRLj9ZwubolRvpLv7wz8Dtv27+P43zf0qZc5Ma83BjXOOV5cIy
        t2k1o5addvGGj1ooUbaee3aVe7hHdog=
X-Google-Smtp-Source: AGHT+IHt8LvvDoMVIDXFMH6DbcJHj7LDxCyk8v+2tpGULBPum6YGItQPa7JoU4xU7k1k3JVk12VlsQ==
X-Received: by 2002:a05:6a00:b47:b0:68f:f650:3035 with SMTP id p7-20020a056a000b4700b0068ff6503035mr9434293pfo.12.1698093408344;
        Mon, 23 Oct 2023 13:36:48 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:14f9:170e:9304:1c4e])
        by smtp.gmail.com with ESMTPSA id g29-20020aa79ddd000000b0068be4ce33easm5776025pfq.96.2023.10.23.13.36.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 13:36:47 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/3] Support disabling fair tag sharing
Date:   Mon, 23 Oct 2023 13:36:32 -0700
Message-ID: <20231023203643.3209592-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.758.gaed0368e0e-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

Performance of UFS devices is reduced significantly by the fair tag sharing
algorithm. This is because UFS devices have multiple logical units and a
limited queue depth (32 for UFS 3.1 devices) and also because it takes time to
give tags back after activity on a request queue has stopped. This patch series
addresses this issue by introducing a flag that allows block drivers to
disable fair sharing.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v3:
 - Instead of disabling fair tag sharing for all block drivers, introduce a flag
   for disabling it conditionally.

Changes between v2 and v3:
 - Rebased on top of the latest kernel.

Changes between v1 and v2:
 - Restored the tags->active_queues variable and thereby fixed the
   "uninitialized variable" warning reported by the kernel test robot.

Bart Van Assche (3):
  block: Introduce flag BLK_MQ_F_DISABLE_FAIR_TAG_SHARING
  scsi: core: Support disabling fair tag sharing
  scsi: ufs: Disable fair tag sharing

 block/blk-mq-debugfs.c    | 1 +
 block/blk-mq.h            | 3 ++-
 drivers/scsi/hosts.c      | 1 +
 drivers/scsi/scsi_lib.c   | 2 ++
 drivers/ufs/core/ufshcd.c | 1 +
 include/linux/blk-mq.h    | 1 +
 include/scsi/scsi_host.h  | 6 ++++++
 7 files changed, 14 insertions(+), 1 deletion(-)

