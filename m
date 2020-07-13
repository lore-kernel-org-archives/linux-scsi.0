Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8232C43469
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B85732072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 08:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="shosgGIq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbgGMIAK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 04:00:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgGMIAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 04:00:10 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED20AC061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:09 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id f7so14761048wrw.1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 01:00:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0025PyTY/eWJewtXJ8I/jkg/HPx62AopbKf5qsThd0=;
        b=shosgGIqEV5Mi43/el0Qv3n5SrwGOeatsv60Jx9hdx9avXnYhxdW+EndMvsg1rCMjv
         shGen7E57TNPkoGMqud+THaV6Pxm5a1cFSN6eJHKBEgy7yv4jFRHSFf7f/eI9o8m9zNx
         fQ6UB5BXKUASSQZX4ijyMpS7qqQ7EtQqCB4U4PFCY5Z3UAtutQ3ZPu9eccfAugAxDvzy
         A7cVnIeVlLgB7VEEpche2qEH/rMQNUvpv+jsED0gn2TRhxSWffJUk5M/R2dbASwUvjaF
         X1lLwy4wo3Bv//etcDgghdkUqRB+Xy1/GjvCTbSuCMnajegNbsvInGm5DwUue+WQJFea
         0ZXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=g0025PyTY/eWJewtXJ8I/jkg/HPx62AopbKf5qsThd0=;
        b=j7Zir4O/FHAQMO4d3f1VctoF/8rEw8wn8nUfRSoYqzLEi27LJO9LY7jGqbiuu4t/A2
         W/daA3+vhXysyEIbhl9r9f2rsRzsxhWapQmVFXY1GomBP+VCVhB1TW5Aa5O8ZnHUXARy
         ytIkjwpRWdLeq7tYHd/cWbDSrR/mH41tgVkbCARWZQzjePOuAOvQLA4LAilU3w2MaPqs
         ZeJKIuDelVrBicIB8ZBCWQmhcxL9YoRd2AYK7iMmYHTuxx/1Jvj2PhJRgfDWNA40oQgn
         e6FlgW35PN69hoz+O0ix5BGBWPuOjEkBrnkq2Im5WoPDYHMs+CMi0E9pUwIzQ4WlAi3g
         5v8g==
X-Gm-Message-State: AOAM530+ciUDKR6Y+/D98vp65kKCceYj9/Xve59tXWe1UVEwgNgkR3rH
        StVrGazVlnB1VZwYbyKeO9CxNA==
X-Google-Smtp-Source: ABdhPJwOcTyhG/RhUEn4cJVs5ajgV1jbVXvClhi9FjHPoCdiHUpma4xUuuP55L87YUuycheYAyP02A==
X-Received: by 2002:a5d:464e:: with SMTP id j14mr78277009wrs.393.1594627207673;
        Mon, 13 Jul 2020 01:00:07 -0700 (PDT)
Received: from localhost.localdomain ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id 33sm24383549wri.16.2020.07.13.01.00.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 01:00:06 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [PATCH v2 00/24] Set 3: Fix another set of SCSI related W=1 warnings
Date:   Mon, 13 Jul 2020 08:59:37 +0100
Message-Id: <20200713080001.128044-1-lee.jones@linaro.org>
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

Changelog:

v1 => v2
 - Collected *-bys
 - Removed inert function-calls when removing unused variables
   - As suggested by James Bottomley
 
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
 drivers/scsi/aic7xxx/aic79xx_osm.c |  14 +-
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
 18 files changed, 273 insertions(+), 229 deletions(-)

-- 
2.25.1

