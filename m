Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 827AFC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4D6D3613A9
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 17:07:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347070AbhDMRHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 13:07:42 -0400
Received: from mail-pj1-f46.google.com ([209.85.216.46]:41957 "EHLO
        mail-pj1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347043AbhDMRHk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 13:07:40 -0400
Received: by mail-pj1-f46.google.com with SMTP id z22-20020a17090a0156b029014d4056663fso9352915pje.0
        for <linux-scsi@vger.kernel.org>; Tue, 13 Apr 2021 10:07:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=BTLtB4mGXqOzIn6Snig/HOr/5pLiE9a02WuKScP2RC8=;
        b=nlz1/dhUcSzYJk1fGkxg2qb0tmuv6JvvnaYyznHWwXjNgbD0LTOuSNouO8n1VGjgCI
         AAYQ2NAat8pPOUUZBmLjqPw8NJS/upWtnfMaO6O1YeyCm4bNyRi67MPujBaGAw59Mil8
         JF7gs7Am7len4OOf3wW/6QTRnNbiz1WiAl9gksvYi/XZSvY+CD6eysgxLrXd9bQJJEIC
         uAkWyPGzhcs1T++3xUAkTkRpRMDD9KE4svPMIqMn4XDHc2wUAVoWv9nHM0o152huszO1
         +cOGSEygXukgwf+8VF0sTMl4nIW5ED2373pX0/dQs90vRlGTF68Kx7fZ3SmN/DznjBuR
         TXJg==
X-Gm-Message-State: AOAM532qBl/k3la1kxnVGBhZA9AeWRtslQOG/A3iMBABbaoOswk/eXnA
        c0XRamagAwgt4FKySF/mvBw=
X-Google-Smtp-Source: ABdhPJwbnA8pyEDsurVLXavtdi2nymNRasrccVS3gXzo9jbqQgUqls8fy8d0xA3fwbQKVX4NIUkq5A==
X-Received: by 2002:a17:90a:2c0f:: with SMTP id m15mr1034419pjd.83.1618333640809;
        Tue, 13 Apr 2021 10:07:20 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:345f:c70d:97e0:e2ef])
        by smtp.gmail.com with ESMTPSA id z10sm6736078pfe.218.2021.04.13.10.07.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 13 Apr 2021 10:07:20 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 00/20] SCSI patches for kernel v5.13
Date:   Tue, 13 Apr 2021 10:06:54 -0700
Message-Id: <20210413170714.2119-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes the following changes:
- Modify a few source code comments.
- Rename scsi_softirq_done().
- Introduce enum scsi_disposition.
- Address CC=clang W=1 warnings.

Please consider these patches for Linux kernel v5.13.

Thanks,

Bart.

Bart Van Assche (20):
  Make the scsi_alloc_sgtables() documentation more accurate
  Remove an incorrect comment
  Rename scsi_softirq_done() into scsi_complete()
  Modify the scsi_send_eh_cmnd() return value for the SDEV_BLOCK case
  Introduce enum scsi_disposition
  aacraid: Remove an unused function
  libfc: Fix a format specifier
  fcoe: Suppress a compiler warning
  iscsi: Suppress two clang format mismatch warnings
  mpt3sas: Fix two kernel-doc headers
  myrb: Remove unused functions
  myrs: Remove unused functions
  qla4xxx: Remove an unused function
  smartpqi: Remove unused functions
  53c700: Open-code status_byte(u8) calls
  dc395x: Open-code status_byte(u8) calls
  sd: Introduce a new local variable in sd_check_events()
  target: Compare explicitly with SAM_STAT_GOOD
  target: Fix several format specifiers
  target/tcm_fc: Fix a kernel-doc header

 drivers/ata/libata-eh.c                    |  2 +-
 drivers/scsi/53c700.c                      |  4 +-
 drivers/scsi/aacraid/aachba.c              |  5 --
 drivers/scsi/dc395x.c                      |  4 +-
 drivers/scsi/device_handler/scsi_dh_alua.c |  4 +-
 drivers/scsi/device_handler/scsi_dh_emc.c  |  4 +-
 drivers/scsi/device_handler/scsi_dh_rdac.c |  4 +-
 drivers/scsi/fcoe/fcoe_transport.c         |  2 +-
 drivers/scsi/libfc/fc_lport.c              |  2 +-
 drivers/scsi/libiscsi.c                    |  5 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c        |  4 +-
 drivers/scsi/myrb.c                        | 71 ----------------
 drivers/scsi/myrs.c                        | 99 ----------------------
 drivers/scsi/qla4xxx/ql4_nx.c              |  6 --
 drivers/scsi/scsi_error.c                  | 66 ++++++++-------
 drivers/scsi/scsi_lib.c                    | 19 +++--
 drivers/scsi/scsi_priv.h                   |  2 +-
 drivers/scsi/sd.c                          |  5 +-
 drivers/scsi/smartpqi/smartpqi_init.c      | 10 ---
 drivers/target/target_core_configfs.c      |  6 +-
 drivers/target/target_core_pr.c            |  6 +-
 drivers/target/target_core_pscsi.c         |  2 +-
 drivers/target/tcm_fc/tfc_sess.c           |  2 +-
 include/scsi/scsi.h                        | 21 ++---
 include/scsi/scsi_device.h                 |  2 +-
 include/scsi/scsi_dh.h                     |  3 +-
 include/scsi/scsi_eh.h                     |  2 +-
 27 files changed, 92 insertions(+), 270 deletions(-)

