Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1C22C433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1DC64F70
	for <linux-scsi@archiver.kernel.org>; Fri, 12 Mar 2021 09:48:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhCLJr5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Mar 2021 04:47:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232902AbhCLJru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2021 04:47:50 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E5CEC061761
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:50 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id e18so1402340wrt.6
        for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2021 01:47:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em20XkthwICjiY73AZrmRzIE2o4bcVYz3Wx+RRleUw8=;
        b=qWhWXHynw6L7tdvIznjScb03heP0XtJwArJFYycejfWffaIDD+mus/hJLY17eM1NDv
         CVQGMyKdDwWEBZFi8KLrtslwPux/3ZWqueepGcArHbI9Ar1ATwZ/04VkLr7Qn1EQ+Kbx
         hI4WNfYBVQd1cx7sZdgyuSM5GijmJk5yY1r7x7Ch82RANAjLvVif1z2KwxwB51ZKBf7Q
         C8QTX6Cz6831VoTbTqsKa2CV5+aVMvv5IZ9AGrqCBsA6YBqiIejMUuF9V03pTIkGywwj
         pr1y9cIZA42AXY6ZOmngahjsUpre1tCDkCAKMMu7s//p2qOw1f+/WOVdSkqkfITgROQ3
         LDuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=em20XkthwICjiY73AZrmRzIE2o4bcVYz3Wx+RRleUw8=;
        b=qDxUv9/gb9AvJR9kRSCqEJkH25rAi5hvKk5fdFU7t/JdMgLD24XLZ13zPDEYgeF2yJ
         ZYEr7S9IKhs68tZcKxm4a2nMRJ5DoDfZ1QKQTKLl+iuUGbCey4aP3l2896rZ9VpLYRTv
         EzuLC71NVrlRIrLplu9va6/q7qTLpw7ekGqy+dEBKsiNODZy/jP3SA0S/zve7bsLnsVX
         jO4Y1C5JLBwZPZ+HJbBYl7Mr3HeSZi57KKPwW4k2j80DMyexltVGwaoEhgexDiFWkcjY
         jJ2i5Eg8GaoKshjrczHsOijWzLBZOMPy/Rxx1Jlg+ANxZ1NwSbp5prCaVAIPd2JDSnyy
         kmKQ==
X-Gm-Message-State: AOAM533qWNM3u/0iBqz5WF788HWbEep1sHkio6jNGRtOemrkrMUuvUke
        SBJg3s86jzNnqwiD5Vk53ONwbA==
X-Google-Smtp-Source: ABdhPJzYvThiLKP/sQoUTU8EbxldMH+/VO2nLSI6jWOTcyd248Iul68f6eueUFLMEeUxhQQ9atnVow==
X-Received: by 2002:adf:b30f:: with SMTP id j15mr13088971wrd.132.1615542468763;
        Fri, 12 Mar 2021 01:47:48 -0800 (PST)
Received: from dell.default ([91.110.221.204])
        by smtp.gmail.com with ESMTPSA id f7sm1539536wmq.11.2021.03.12.01.47.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 01:47:48 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ali Akcaagac <aliakc@web.de>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Anil Veerabhadrappa <anilgv@broadcom.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        Christoph Hellwig <hch@lst.de>,
        "C.L. Huang" <ching@tekram.com.tw>, dc395x@twibble.org,
        de Melo <acme@conectiva.com.br>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Dimitris Michailidis <dm@chelsio.com>,
        Doug Ledford <dledford@redhat.com>,
        Eddie Wai <eddie.wai@broadcom.com>,
        Erich Chen <erich@tekram.com.tw>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Hannes Reinecke <hare@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        James Smart <james.smart@broadcom.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Jan Kotas <jank@cadence.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Joel Jacobson <linux@3ware.com>, Karen Xie <kxie@chelsio.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        linux-drivers@broadcom.com, Linux GmbH <hare@suse.com>,
        linux-scsi@vger.kernel.org,
        Manish Rangankar <mrangankar@marvell.com>,
        Marcelo Tosatti <marcelo@conectiva.com.br>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Nathaniel Clark <nate@misrule.us>,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        Nilesh Javali <njavali@marvell.com>,
        Oliver Neukum <oliver@neukum.org>,
        QLogic-Storage-Upstream@qlogic.com,
        Santosh Yaraganavi <santosh.sy@samsung.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Vinayak Holikatti <h.vinayak@samsung.com>,
        Vladislav Bolkhovitin <vst@vlnb.net>
Subject: [PATCH 00/30] [Set 2] Rid W=1 warnings in SCSI
Date:   Fri, 12 Mar 2021 09:47:08 +0000
Message-Id: <20210312094738.2207817-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (30):
  scsi: mpt3sas: mpt3sas_config: Fix a bunch of potential naming doc-rot
  scsi: ufs: ufshcd: Fix incorrectly named
    ufshcd_find_max_sup_active_icc_level()
  scsi: lpfc: lpfc_scsi: Fix a bunch of kernel-doc misdemeanours
  scsi: lpfc: lpfc_attr: Fix a bunch of misnamed functions
  scsi: libfc: fc_rport: Fix incorrect naming of fc_rport_adisc_resp()
  scsi: mpt3sas: mpt3sas_transport: Fix a couple of misdocumented
    functions/params
  scsi: libfc: fc_fcp: Fix misspelling of fc_fcp_destroy()
  scsi: qla2xxx: qla_mr: Fix a couple of misnamed functions
  scsi: mpt3sas: mpt3sas_ctl: Fix some kernel-doc misnaming issues
  scsi: qla2xxx: qla_nx2: Fix incorrectly named function
    qla8044_check_temp()
  scsi: qla2xxx: qla_target: Fix a couple of misdocumented functions
  scsi: lpfc: lpfc_debugfs: Fix incorrectly documented function
    lpfc_debugfs_commonxripools_data()
  scsi: lpfc: lpfc_bsg: Fix a few incorrectly named functions
  scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the
    heap
  scsi: lpfc: lpfc_nvme: Fix kernel-doc formatting issue
  scsi: ufs: cdns-pltfrm: Supply function names for headers
  scsi: cxgbi: cxgb3i: cxgb3i: Fix misnaming of ddp_setup_conn_digest()
  scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for
    esas2r_log_master()
  scsi: be2iscsi: be_iscsi: Fix incorrect naming of
    beiscsi_iface_config_vlan()
  scsi: be2iscsi: be_main: Provide missing function name in header
  scsi: be2iscsi: be_mgmt: Fix beiscsi_phys_port()'s name in header
  scsi: bnx2i: bnx2i_sysfs: Fix bnx2i_set_ccell_info()'s name in
    description
  scsi: initio: Remove unused variable 'prev'
  scsi: a100u2w: Remove unused variable 'bios_phys'
  scsi: dc395x: Fix incorrect naming in function headers
  scsi: atp870u: Fix naming and demote incorrect and non-conformant
    kernel-doc header
  scsi: myrs: Remove a couple of unused 'status' variables
  scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and
    'tw_dev'
  scsi: 3w-9xxx: Remove a few set but unused variables
  scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'

 drivers/scsi/3w-9xxx.c                   | 14 ++++----------
 drivers/scsi/3w-sas.c                    | 10 ++--------
 drivers/scsi/3w-xxxx.c                   |  6 ++----
 drivers/scsi/a100u2w.c                   |  2 --
 drivers/scsi/atp870u.c                   |  7 +++----
 drivers/scsi/be2iscsi/be_iscsi.c         |  2 +-
 drivers/scsi/be2iscsi/be_main.c          |  1 +
 drivers/scsi/be2iscsi/be_mgmt.c          |  2 +-
 drivers/scsi/bfa/bfa_fcs_lport.c         | 20 ++++++++++++++------
 drivers/scsi/bnx2i/bnx2i_sysfs.c         |  2 +-
 drivers/scsi/cxgbi/cxgb3i/cxgb3i.c       |  2 +-
 drivers/scsi/dc395x.c                    |  6 +++---
 drivers/scsi/esas2r/esas2r_log.c         |  7 +++++++
 drivers/scsi/initio.c                    |  5 ++---
 drivers/scsi/libfc/fc_fcp.c              |  2 +-
 drivers/scsi/libfc/fc_rport.c            |  2 +-
 drivers/scsi/lpfc/lpfc_attr.c            | 12 ++++++------
 drivers/scsi/lpfc/lpfc_bsg.c             |  6 +++---
 drivers/scsi/lpfc/lpfc_debugfs.c         |  2 +-
 drivers/scsi/lpfc/lpfc_nvme.c            |  2 +-
 drivers/scsi/lpfc/lpfc_scsi.c            | 24 ++++++++++++------------
 drivers/scsi/mpt3sas/mpt3sas_config.c    | 10 +++++-----
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       | 16 ++++++++--------
 drivers/scsi/mpt3sas/mpt3sas_transport.c |  7 ++++---
 drivers/scsi/myrs.c                      |  6 ++----
 drivers/scsi/qla2xxx/qla_mr.c            |  4 ++--
 drivers/scsi/qla2xxx/qla_nx2.c           |  2 +-
 drivers/scsi/qla2xxx/qla_target.c        |  4 ++--
 drivers/scsi/ufs/cdns-pltfrm.c           |  4 ++++
 drivers/scsi/ufs/ufshcd.c                |  2 +-
 30 files changed, 96 insertions(+), 95 deletions(-)

Cc: Adam Radford <aradford@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Ali Akcaagac <aliakc@web.de>
Cc: Alim Akhtar <alim.akhtar@samsung.com>
Cc: Andre Hedrick <andre@suse.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Avri Altman <avri.altman@wdc.com>
Cc: Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Brian Macy <bmacy@sunshinecomputing.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: "C.L. Huang" <ching@tekram.com.tw>
Cc: dc395x@twibble.org
Cc: de Melo <acme@conectiva.com.br>
Cc: Dick Kennedy <dick.kennedy@broadcom.com>
Cc: Dimitris Michailidis <dm@chelsio.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Eddie Wai <eddie.wai@broadcom.com>
Cc: Erich Chen <erich@tekram.com.tw>
Cc: GR-QLogic-Storage-Upstream@marvell.com
Cc: Hannes Reinecke <hare@kernel.org>
Cc: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: James Smart <james.smart@broadcom.com>
Cc: Jamie Lenehan <lenehan@twibble.org>
Cc: Jan Kotas <jank@cadence.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: Joel Jacobson <linux@3ware.com>
Cc: Karen Xie <kxie@chelsio.com>
Cc: Ketan Mukadam <ketan.mukadam@broadcom.com>
Cc: Kurt Garloff <garloff@suse.de>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: linux-drivers@broadcom.com
Cc: Linux GmbH <hare@suse.com>
Cc: linux-scsi@vger.kernel.org
Cc: Manish Rangankar <mrangankar@marvell.com>
Cc: Marcelo Tosatti <marcelo@conectiva.com.br>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: Nathaniel Clark <nate@misrule.us>
Cc: "Nicholas A. Bellinger" <nab@kernel.org>
Cc: Nilesh Javali <njavali@marvell.com>
Cc: Oliver Neukum <oliver@neukum.org>
Cc: QLogic-Storage-Upstream@qlogic.com
Cc: Santosh Yaraganavi <santosh.sy@samsung.com>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Stanley Chu <stanley.chu@mediatek.com>
Cc: Subbu Seetharaman <subbu.seetharaman@broadcom.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: Vinayak Holikatti <h.vinayak@samsung.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>
-- 
2.27.0

