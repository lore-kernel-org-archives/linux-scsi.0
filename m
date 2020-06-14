Return-Path: <SRS0=XB8t=73=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E9E4C433DF
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 43F0C2071A
	for <linux-scsi@archiver.kernel.org>; Sun, 14 Jun 2020 22:39:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgFNWj3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 14 Jun 2020 18:39:29 -0400
Received: from mail-pj1-f66.google.com ([209.85.216.66]:53989 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727924AbgFNWj3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jun 2020 18:39:29 -0400
Received: by mail-pj1-f66.google.com with SMTP id i12so5933173pju.3
        for <linux-scsi@vger.kernel.org>; Sun, 14 Jun 2020 15:39:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EpBTtbBaf7wtpU9OxifXf5Xkacb6UHtUVJCfFlf7yKc=;
        b=Rt9iwJu9LNJnBmG7nMS/g4wB4MdOwdpWwKw6X1EnwstNOaA7xW08+OEs7R5sVHdjt3
         rKZJrIFmyX3RbDkjSWS9kDuMJZpQxX4anjb7AenHnBKH82HQakdUX2Rex+VBbf2PGinh
         PwF0+X7n1p3cSrDUdH4VZT46xRmsy4wjeMjTZ9MuJl6B7j5NJAbzNFfnWq2Cpr/O1XZp
         ZgefczgnFwkAqfMW1uWF59zouOYFXSYgVa8Cp37hvNcK+gNDkafSgCaELGCu8/7jiaHt
         8PVUqRaImS4JjsdrObENF9qobZ1FaueAeVrphg0VsijGPjniFT96CZxmC+Vvh2xe7x03
         FajQ==
X-Gm-Message-State: AOAM531O2Ce0iZ8lFhVd+Qruq/BS+Z98cL4OW7Y9gcyqL3QTS1wtMD7v
        fvQt7buY/mJ5U1yf0xCr3OI=
X-Google-Smtp-Source: ABdhPJztJLkZIATlAXkiZHi+zFQrGXV8b4DlB+k13+rdJJD2tMIzMgfuUZFVM8z98/sRQQwlaBj0hw==
X-Received: by 2002:a17:90a:62ca:: with SMTP id k10mr9575245pjs.87.1592174368188;
        Sun, 14 Jun 2020 15:39:28 -0700 (PDT)
Received: from localhost.localdomain (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id u25sm11768711pfm.115.2020.06.14.15.39.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2020 15:39:27 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/9] qla2xxx patches for kernel v5.9
Date:   Sun, 14 Jun 2020 15:39:12 -0700
Message-Id: <20200614223921.5851-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these patches for kernel v5.9.

Thanks,

Bart.

Bart Van Assche (9):
  qla2xxx: Check the size of struct fcp_hdr at compile time
  qla2xxx: Remove the __packed annotation from struct fcp_hdr and
    fcp_hdr_le
  qla2xxx: Make qla82xx_flash_wait_write_finish() easier to read
  qla2xxx: Initialize 'n' before using it
  qla2xxx: Remove several superfluous casts
  qla2xxx: Make __qla2x00_alloc_iocbs() initialize 32 bits of
    request_t.handle
  qla2xxx: Fix a Coverity complaint in qla2100_fw_dump()
  qla2xxx: Make qla2x00_restart_isp() easier to read
  qla2xxx: Introduce a function for computing the debug message prefix

 drivers/scsi/qla2xxx/qla_bsg.c     |  3 +-
 drivers/scsi/qla2xxx/qla_dbg.c     | 98 +++++++++++-------------------
 drivers/scsi/qla2xxx/qla_init.c    | 39 ++++++------
 drivers/scsi/qla2xxx/qla_iocb.c    |  4 +-
 drivers/scsi/qla2xxx/qla_mr.c      |  3 +-
 drivers/scsi/qla2xxx/qla_nx.c      | 20 +++---
 drivers/scsi/qla2xxx/qla_target.h  |  4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  1 +
 8 files changed, 71 insertions(+), 101 deletions(-)

