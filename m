Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DE3DC47080
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D95AB61159
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 02:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232114AbhEXC4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 23 May 2021 22:56:34 -0400
Received: from mail-pg1-f179.google.com ([209.85.215.179]:47072 "EHLO
        mail-pg1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231833AbhEXC4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 23 May 2021 22:56:33 -0400
Received: by mail-pg1-f179.google.com with SMTP id m124so19008107pgm.13
        for <linux-scsi@vger.kernel.org>; Sun, 23 May 2021 19:55:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=5TPQF4MBdfwBaMFONAQiYSAdxV+sDDTPW1OIRm2DlP4=;
        b=g9xLWHAg/7pOKnGjasFH4zyVOcBceSr8w4pMRqxY1SAsvSJcqz1AwKYWlMhRY8EeWW
         Ob79FhG8fu0VLG3t5aOYbAS9iXl3v+KAhFK+Go59xTSu3wWeanws0r1GQf43vkU1mPZM
         piodkyzMfUuFPHge/caqCOLtjRdWPPgNNjPpC6rCd5PundzjZb/+ne8PVdJsBPlzbS1J
         58N2mhtP/l78/VeEdTkyomMQFzBlSD+BpX4R2aJ3/bBZZx8OxmYQZDUHsQb/F0XCGCuj
         /PqIvHbG8hAjLVUqOVvC+VXraymJSmJmpVpfwNYpV2b2swrRMmUEg8ACOImV9Q//F26l
         DoTg==
X-Gm-Message-State: AOAM531IQnIjJWubLWG5U99WvRAtWygmb+0zW6xxHMbRiU05FYpKW3yE
        bFgF5CVOYfBSuFWDF8qhuNcDBltlk08=
X-Google-Smtp-Source: ABdhPJwftdvglvFatCN9JDZy/0Vs3UOsTdwMTiuatMBh4SJRP7CCOri4i2vx08ghmMSdrnvMEEdisQ==
X-Received: by 2002:a65:50c5:: with SMTP id s5mr11080341pgp.138.1621824905051;
        Sun, 23 May 2021 19:55:05 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id g8sm13272926pju.6.2021.05.23.19.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 May 2021 19:55:04 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/3] Introduce enums for SCSI status codes
Date:   Sun, 23 May 2021 19:54:54 -0700
Message-Id: <20210524025457.11299-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series introduces enums for the SAM, message, host and driver
status codes and hence improves static type checking by the compiler.
Please consider this patch series for kernel v5.14.

Thanks,

Bart.

Changes compared to v2:
- Changed SAS_STAT_ prefix into SAS_SAM_STAT_.

Changes compared to v1:
- Modified the comment block at the start of the enum exec_status definition
  in libsas.h.
- Changed the __SAM_STAT_ prefix into SAS_STAT_ for the SAM status codes that
  are also used in the SAS code.
- Restored the reverse-Christmas tree style in two functions.
- Renamed enum host_status and driver_status into enum scsi_host_status and
  scsi_driver_status respectively.

Bart Van Assche (3):
  libsas: Introduce more SAM status code aliases in enum exec_status
  Introduce enums for the SAM, message, host and driver status codes
  Change the type of the second argument of
    scsi_host_complete_all_commands()

 drivers/scsi/aic94xx/aic94xx_task.c    |  2 +-
 drivers/scsi/constants.c               |  4 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c |  8 +--
 drivers/scsi/hisi_sas/hisi_sas_v2_hw.c |  8 +--
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c |  8 +--
 drivers/scsi/hosts.c                   |  8 ++-
 drivers/scsi/isci/request.c            | 10 +--
 drivers/scsi/isci/task.c               |  2 +-
 drivers/scsi/libsas/sas_ata.c          |  7 +-
 drivers/scsi/libsas/sas_expander.c     |  2 +-
 drivers/scsi/libsas/sas_task.c         |  4 +-
 drivers/scsi/mvsas/mv_sas.c            | 10 +--
 drivers/scsi/pm8001/pm8001_hwi.c       | 16 ++---
 drivers/scsi/pm8001/pm8001_sas.c       |  4 +-
 drivers/scsi/pm8001/pm80xx_hwi.c       | 14 ++--
 drivers/target/target_core_pscsi.c     |  2 +-
 include/scsi/libsas.h                  | 12 +++-
 include/scsi/scsi.h                    | 81 +----------------------
 include/scsi/scsi_host.h               |  2 +-
 include/scsi/scsi_proto.h              | 24 +++----
 include/scsi/scsi_status.h             | 89 ++++++++++++++++++++++++++
 21 files changed, 170 insertions(+), 147 deletions(-)
 create mode 100644 include/scsi/scsi_status.h

