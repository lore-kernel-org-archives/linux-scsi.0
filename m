Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7CB4AC433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4EA3E2078B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:46:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AqhuIu0+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726782AbgGIRqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGIRqA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:46:00 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FFB3C08C5CE
        for <linux-scsi@vger.kernel.org>; Thu,  9 Jul 2020 10:46:00 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j4so3274197wrp.10
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:46:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ez9cZtUnYXcwHobMCwZ6WRbdQJMWO8OSEw13aOAjRF4=;
        b=AqhuIu0+Io42DkyiAGeDTpM8gtYQc7ga2djYpn77xw0TkcqCSEhW2kQpy0Qq9ceesu
         rB9qyDdO2XEqWsMxs7k/BbWi+qt71wgCu+ayLaWPBbc6Htup9TqEpBNtaioqqKPFl37e
         DZ5stDKVn/D37q3VBXCXcpvtAcNFomHsZRlyt+GQGo8Mtc7chva9JEREVyJwNOlSGH+N
         Na3Jk+7ArS7AR8iAlFeJFTP+tKG17q4sSY83QBqFT+4cg5y9yyZBm7E8iepcFOTuoTrT
         TnLs4ys4H3ziGMmZLlR0CBKRgxw+xQmxPNAUWsazjGMetZdeuImNrXPoduAm0ocW2dcr
         rVVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Ez9cZtUnYXcwHobMCwZ6WRbdQJMWO8OSEw13aOAjRF4=;
        b=EyDFA3LZofDfHjPcDDFnXcMCR71cC+E9sfyc3thDHPsIMWu/eyg8aIJV6keJfYMqJy
         7+oKuDdCp6zhpmYyQNM07J/m/agTIAbUHzlO+SkAY8tWRezH7SHKMqGkAfEofvpUZSPU
         uTfzA+t8KvM4KV4LpRq4c3y1rvYtnRSwrNxiC/aVt1n5a8ii0Qwaq9iRkdOd3Ii8nWT5
         T7oFfbXBFtmrRGVKMIuI3k6L2Jvyx+ALT+BinvJeN9XpjnXbYg3XsZHHgXosqBDrMSX1
         ywkLRCJiamcHJSt9XR81+QGvCDaSz9hSabv5sfN0NGf1aQB3fylK9UTSa3YLz4/87AV2
         kvZg==
X-Gm-Message-State: AOAM5339M+HC04tkRRp0WUe40/nCTAZhe+sHYEj2GDW43WS5Ieiz5I40
        YxLWnaUrZxi0BHjVgmCNrxY0Ww==
X-Google-Smtp-Source: ABdhPJzEkFZJGyQA3CvHpF0B9hca7kSIEVMwChoMPGrpvSLjRr/U+S8sF1cWgSlUhyKupiS0v3BHmQ==
X-Received: by 2002:adf:8b5a:: with SMTP id v26mr63641254wra.165.1594316758752;
        Thu, 09 Jul 2020 10:45:58 -0700 (PDT)
Received: from localhost.localdomain ([2.27.35.206])
        by smtp.gmail.com with ESMTPSA id f15sm6063854wrx.91.2020.07.09.10.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Jul 2020 10:45:58 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>
Subject: [PATCH 00/24] Set 3: Fix another set of SCSI related W=1 warnings
Date:   Thu,  9 Jul 2020 18:45:32 +0100
Message-Id: <20200709174556.7651-1-lee.jones@linaro.org>
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

This brings the total of W=1 SCSI wanings from 1690 in v5.8-rc1 to 1109.

Lee Jones (24):
  scsi: aacraid: aachba: Repair two kerneldoc headers
  scsi: aacraid: commctrl: Fix a few kerneldoc issues
  scsi: aacraid: dpcsup: Fix logical bug when !DBG
  scsi: aacraid: dpcsup: Remove unused variable 'status'
  scsi: aacraid: dpcsup: Demote partially documented function header
  scsi: aic94xx: aic94xx_seq: Document 'lseq' and repair
    asd_update_port_links() header
  scsi: aacraid: commsup: Fix a bunch of function header issues
  scsi: aic94xx: aic94xx_scb: Fix a couple of formatting and bitrot
    issues
  scsi: aacraid: rx: Fill in the very parameter descriptions for
    rx_sync_cmd()
  scsi: pm8001: pm8001_ctl: Provide descriptions for the many
    undocumented 'attr's
  scsi: ipr: Fix a mountain of kerneldoc misdemeanours
  scsi: virtio_scsi: Demote seemingly unintentional kerneldoc header
  scsi: ipr: Remove a bunch of set but checked variables
  scsi: ipr: Fix struct packed-not-aligned issues
  scsi: myrs: Demote obvious misuse of kerneldoc to standard comment
    blocks
  scsi: megaraid: Fix a whole bunch of function header formatting issues
  scsi: be2iscsi: be_iscsi: Fix API/documentation slip
  scsi: be2iscsi: be_main: Fix misdocumentation of 'pcontext'
  scsi: be2iscsi: be_mgmt: Add missing function parameter description
  scsi: lpfc: lpfc_nvme: Correct some pretty obvious misdocumentation
  scsi: aic7xxx: aic79xx_osm: Remove unused variable 'ahd'
  scsi: aic7xxx: aic79xx_osm: Remove unused variables 'wait' and
    'paused'
  scsi: aic7xxx: aic79xx_osm: Fix 'amount_xferred' set but not used
    issue
  scsi: aic7xxx: aic79xx_osm: Remove set but unused variabes
    'saved_scsiid' and 'saved_modes'

 drivers/scsi/aacraid/aachba.c      |   5 +-
 drivers/scsi/aacraid/commctrl.c    |  14 +-
 drivers/scsi/aacraid/commsup.c     |  12 +-
 drivers/scsi/aacraid/dpcsup.c      |  15 +-
 drivers/scsi/aacraid/rx.c          |  12 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c |  16 +--
 drivers/scsi/aic94xx/aic94xx_scb.c |   6 +-
 drivers/scsi/aic94xx/aic94xx_seq.c |   6 +-
 drivers/scsi/be2iscsi/be_iscsi.c   |  11 +-
 drivers/scsi/be2iscsi/be_main.c    |   4 +-
 drivers/scsi/be2iscsi/be_mgmt.c    |   3 +-
 drivers/scsi/ipr.c                 |  90 +++++++-----
 drivers/scsi/ipr.h                 |   4 +-
 drivers/scsi/lpfc/lpfc_nvme.c      |  38 +++--
 drivers/scsi/megaraid.c            | 218 ++++++++++++++---------------
 drivers/scsi/myrs.c                |  34 ++---
 drivers/scsi/pm8001/pm8001_ctl.c   |  14 ++
 drivers/scsi/virtio_scsi.c         |   2 +-
 18 files changed, 275 insertions(+), 229 deletions(-)

-- 
2.25.1

