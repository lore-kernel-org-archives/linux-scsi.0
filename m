Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2B9C9C43459
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0AEEB2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 07:48:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="FMscau92"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgGMHqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 03:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727834AbgGMHqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 03:46:49 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D242C061794
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:49 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id l2so12173421wmf.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 00:46:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=25A0DNh94uDAwTRVOnoqazisStMi7w4KenkXTOS40VY=;
        b=FMscau92B/Kn9iOgY9/nhvxdFFGi5eYsGXjuJHfYIPqyqyyXGBmKaLgaD7dlArcrIX
         g32DbvicFtnn2dVQMo5lFmwtjbLAQcqc77myliOR2N/vpvFEnvScvYlR43tJwqx05loI
         TM0Bzy094tngfkKpYgxZSJykLb1gn8XLrguoMlrxuVGOkBiCSKbhznRZ6uY5DE9jP3MT
         jfVrh+kqyCNbK94P9QNYhOxQP2xOMBReQSlBnQZvlqKRdPeKMK1+StVUiOnd57VofXIU
         Ne2f5YwcgXZHkcGV+Anm7i/WJ1oTRId/VDVlshUJSC1+UDudau5fbRIorlzFR6khwhGK
         cKrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=25A0DNh94uDAwTRVOnoqazisStMi7w4KenkXTOS40VY=;
        b=QS1qdWdrCisB2dtAzgzmkFq5tGg5COJydmbWzs0IBgwUEnUyGvLcuz0kKcz0hWJpvd
         K2+O4UID4PtKbSYPKdLFX61iPxAMqB7SOZIm7ccHoTsR+UEfbLTwVDFRoM5gM1LxhNQW
         qehHaEiKGxTg6Pi3TE4s01fl+PKYXJ9bOsaKRLnZ95L2W0/FLUMfRVj2ELtwCz3gNYBN
         NqBN/DPq2CiFku5HH6wiqVXM7lYaG91zx5WE0RJgHB39Hq0QLrKsdQcWk/CE3u+KPZ/a
         88Zx3RG0oJ1jO7/gTrpyEsvq1SB0EQcBlA/oiWiDonLGP6plnEei3jCpbpbsG1FHTItv
         R7Cw==
X-Gm-Message-State: AOAM533iCSM6dq5tSE61gHAxzaQrVcL3TLX4OhZxelyP9K3jcEGnY+Yv
        Wjb4tOJuQ9/UhkLprjkLQE8hnw==
X-Google-Smtp-Source: ABdhPJwHHQGD+YW9ySoK+Fa+ZTUh/gG5Athu/oAFZbb9J4bQHGlzJPMTOFjVx1fCHoOeke6LoMzZ7A==
X-Received: by 2002:a1c:9c89:: with SMTP id f131mr9910553wme.126.1594626407933;
        Mon, 13 Jul 2020 00:46:47 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id k11sm25142488wrd.23.2020.07.13.00.46.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 00:46:47 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 00/29] Fix a bunch more SCSI related W=1 warnings
Date:   Mon, 13 Jul 2020 08:46:16 +0100
Message-Id: <20200713074645.126138-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Slowly working through the SCSI related ones.  There are many.

Change-log:

v1 => v2
 - Collected *-by tags
 - Squashed patch 13 => 11
   - Suggested by Johannes Thumshirn

Lee Jones (29):
  scsi: libfc: fc_exch: Supply some missing kerneldoc struct/function
    attributes/params
  include: scsi: scsi_transport_fc: Match HBA Attribute Length with
    HBAAPI V2.0 definitions
  scsi: libfc: fc_disc: trivial: Fix spelling mistake of 'discovery'
  scsi: fcoe: fcoe: Fix various kernel-doc infringements
  scsi: fcoe: fcoe_ctlr: Fix a myriad of documentation issues
  scsi: fcoe: fcoe_transport: Correct some kernel-doc issues
  scsi: bnx2fc: bnx2fc_fcoe: Repair a range of kerneldoc issues
  scsi: qedf: qedf_main: Demote obvious misuse of kerneldoc to standard
    comment blocks
  scsi: qedf: qedf_main: Remove set but not checked variable 'tmp'
  scsi: libfc: fc_lport: Repair function parameter documentation
  scsi: libfc: fc_rport: Fix a couple of misdocumented function
    parameters
  scsi: libfc: fc_fcp: Provide missing and repair existing function
    documentation
  scsi: bnx2fc: bnx2fc_hwi: Fix a couple  of bitrotted function
    documentation headers
  scsi: arcmsr: arcmsr_hba: Remove some set but unused variables
  scsi: arcmsr: arcmsr_hba: Make room for the trailing NULL, even if it
    is over-written
  scsi: qedf: qedf_io: Remove a whole host of unused variables
  scsi: bnx2fc: bnx2fc_tgt: Demote obvious misuse of kerneldoc to
    standard comment blocks
  scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'tinfo'
  scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'ahc'
  scsi: aic7xxx: aic7xxx_osm: Remove unused variable 'targ'
  scsi: aic7xxx: aic7xxx_osm: Fix 'amount_xferred' set but not used
    issue
  scsi: qedf: qedf_debugfs: Demote obvious misuse of kerneldoc to
    standard comment blocks
  scsi: aacraid: linit: Provide suggested curly braces around empty body
    of if()
  scsi: aacraid: linit: Fix a couple of small kerneldoc issues
  scsi: aic94xx: aic94xx_init: Demote seemingly unintentional kerneldoc
    header
  scsi: pm8001: pm8001_init: Demote obvious misuse of kerneldoc and
    update others
  scsi: aic94xx: aic94xx_hwi: Repair kerneldoc formatting error and
    remove extra param
  scsi: aacraid: aachba: Fix a bunch of function doc formatting errors
  scsi: qla4xxx: ql4_init: Provide a missing function param description
    and fix formatting

 drivers/scsi/aacraid/aachba.c       | 17 +++-------------
 drivers/scsi/aacraid/linit.c        |  6 +++---
 drivers/scsi/aic7xxx/aic7xxx_osm.c  | 13 ++----------
 drivers/scsi/aic94xx/aic94xx_hwi.c  |  3 +--
 drivers/scsi/aic94xx/aic94xx_init.c |  2 +-
 drivers/scsi/arcmsr/arcmsr_hba.c    | 31 ++++++++++++-----------------
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c   | 18 ++++++++---------
 drivers/scsi/bnx2fc/bnx2fc_hwi.c    |  6 +++---
 drivers/scsi/bnx2fc/bnx2fc_tgt.c    |  7 +++----
 drivers/scsi/fcoe/fcoe.c            | 10 ++++------
 drivers/scsi/fcoe/fcoe_ctlr.c       | 26 ++++++++++++------------
 drivers/scsi/fcoe/fcoe_transport.c  |  4 +++-
 drivers/scsi/libfc/fc_disc.c        |  2 +-
 drivers/scsi/libfc/fc_exch.c        |  7 ++++++-
 drivers/scsi/libfc/fc_fcp.c         | 11 ++++++----
 drivers/scsi/libfc/fc_lport.c       |  7 +++++--
 drivers/scsi/libfc/fc_rport.c       |  4 ++--
 drivers/scsi/pm8001/pm8001_init.c   | 30 ++++++++++++++--------------
 drivers/scsi/qedf/qedf_debugfs.c    | 18 ++++++++---------
 drivers/scsi/qedf/qedf_io.c         | 30 ++++------------------------
 drivers/scsi/qedf/qedf_main.c       | 10 ++++------
 drivers/scsi/qla4xxx/ql4_init.c     |  7 ++++---
 include/scsi/fc/fc_ms.h             |  4 ++--
 23 files changed, 115 insertions(+), 158 deletions(-)

-- 
2.25.1

