Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23888C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B51EE6044F
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Mar 2021 03:29:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231194AbhCRD3F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 23:29:05 -0400
Received: from mail-pl1-f173.google.com ([209.85.214.173]:34761 "EHLO
        mail-pl1-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229880AbhCRD2r (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 23:28:47 -0400
Received: by mail-pl1-f173.google.com with SMTP id o2so580397plg.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 20:28:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J2ZU5xXLOtYIwuBU9d8v08b0n15tYYvxPC6N3W1E3Qk=;
        b=Kml4jBrLlu0T9ckBUeDkQMnRLT8G99vpcgMseLYxRhF6ng/UwpA7LgqVuFSdeMYakS
         zsklBQb5hYQhERa0lf7GmF9Agp8RGtm/AdVUNGBiKPjhG2OAmbYIaL5loqk5dzli55O3
         9aFZsU1T24D84ZrVlm09y4JaItDBvAiZGEmsfqPOjghbJunC0L6nfpuL96r5XaRN3VBo
         vG58mntD+D+D26V5wlaUb4QG/X8zjXYMJHbB50a8g1UwzaLU0DyRnXU4Zy5M2dB04O80
         6WvrgDkVID656oXv3yzIAOdReKwr13OWG6peT01p4IvINHGjB/fN66Y6EAaFw62tzGjF
         WX5g==
X-Gm-Message-State: AOAM531YNeYUMokNC3NtuN9AYrRUZOvu3BHBjv3hHH8E6cKWGm7QHbNS
        cXRdPxrMXkX9SiHYwk9rSbo=
X-Google-Smtp-Source: ABdhPJwtHDu9SVDzeCjWWnNeyxAoCDDo5baCxJSh3qJ+qdF6ph8DhKahbRXbUMBqm6175F9Ddv7haw==
X-Received: by 2002:a17:90a:7a8b:: with SMTP id q11mr2047836pjf.215.1616038127304;
        Wed, 17 Mar 2021 20:28:47 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:7fb2:1f41:ab33:bae6])
        by smtp.gmail.com with ESMTPSA id y68sm473687pgy.5.2021.03.17.20.28.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 20:28:46 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/6] qla2xxx patches for kernel v5.12 and v5.13
Date:   Wed, 17 Mar 2021 20:28:34 -0700
Message-Id: <20210318032840.7611-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.30.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider the first patch in this series for kernel v5.12 and the
remaining patches for kernel v5.13.

Thanks,

Bart.

Changes compared to v1:
- Improved the description of patch 1/6.
- Dropped one patch that is already upstream.

Bart Van Assche (6):
  Revert "qla2xxx: Make sure that aborted commands are freed"
  qla2xxx: Constify struct qla_tgt_func_tmpl
  qla2xxx: Fix endianness annotations
  qla2xxx: Suppress Coverity complaints about dseg_r*
  qla2xxx: Simplify qla8044_minidump_process_control()
  qla2xxx: Always check the return value of qla24xx_get_isp_stats()

 drivers/scsi/qla2xxx/qla_attr.c    |  6 +++++-
 drivers/scsi/qla2xxx/qla_def.h     |  4 ++--
 drivers/scsi/qla2xxx/qla_iocb.c    |  3 ++-
 drivers/scsi/qla2xxx/qla_isr.c     |  2 +-
 drivers/scsi/qla2xxx/qla_mr.c      | 12 ++++++------
 drivers/scsi/qla2xxx/qla_mr.h      |  4 ++--
 drivers/scsi/qla2xxx/qla_nx2.c     |  8 --------
 drivers/scsi/qla2xxx/qla_sup.c     |  9 +++++----
 drivers/scsi/qla2xxx/qla_target.c  | 13 +++++--------
 drivers/scsi/qla2xxx/tcm_qla2xxx.c |  6 +-----
 10 files changed, 29 insertions(+), 38 deletions(-)

