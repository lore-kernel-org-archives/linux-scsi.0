Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D46A1C433ED
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:50:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B5BD061154
	for <linux-scsi@archiver.kernel.org>; Tue, 18 May 2021 17:50:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351306AbhERRve (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 May 2021 13:51:34 -0400
Received: from mail-pj1-f54.google.com ([209.85.216.54]:44780 "EHLO
        mail-pj1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345502AbhERRvb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 May 2021 13:51:31 -0400
Received: by mail-pj1-f54.google.com with SMTP id h20-20020a17090aa894b029015db8f3969eso1340123pjq.3
        for <linux-scsi@vger.kernel.org>; Tue, 18 May 2021 10:50:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=SE2xr3ZbTChxrxRHmxo+UPjQVytQUG5XmbMgUYeTfxg=;
        b=bnyN4wjw5wxmwaUcZKKIXR1Ao8I9VNf1BqAs8GKra/g/wO2A5T3n6u7Pi2FgJoSbxI
         9hNrGw1erhDJUUmyG7b1+qn8uCRfTizGOWcfcmrewgD9e/7V6Qi4vPTA7geX3CxTvJN4
         ouoLc8U91pXFRbEId2GrFgLJ605JF1vxWy0Zmy5DwX8gMT+wbxJqbxqFnNzuoRxMjBnr
         hG2RaZRBfILXlCc4+6sr/lQ2KJXCtYpTT1jD3gEPZ+yP2iUr4s+HtG1K33M7MMdHRjyt
         b6UCBM0x36ysJ5RqjXReYBBdnhqmmZpCj/JZjElLcLyC9OoVphFY5EdMenydMngWixaH
         CKvQ==
X-Gm-Message-State: AOAM532p3plqKiMBVlnjUeqxiqVOTDxjGDV1dxwTMfIOlJsxCEIcb5cg
        foMuGSkODk0ihQWQ17IUhUc=
X-Google-Smtp-Source: ABdhPJw3A3yjQzBkVOBUnv1ZugZIMVooh+HviECPOlD4vMKjt8dY2eHEYsTMX1z125cq2qrkre4+Gw==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr6273255pjp.155.1621360212435;
        Tue, 18 May 2021 10:50:12 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:4ae4:fc49:eafe:4150])
        by smtp.gmail.com with ESMTPSA id a2sm613762pfv.156.2021.05.18.10.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 10:50:12 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] Introduce enums for SCSI status codes
Date:   Tue, 18 May 2021 10:50:03 -0700
Message-Id: <20210518175006.21308-1-bvanassche@acm.org>
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

