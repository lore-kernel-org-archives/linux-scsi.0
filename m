Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B88DC433E4
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:36:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 42BE32071A
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 06:36:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FuhR7AEN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726998AbgGQGgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 02:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726234AbgGQGgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jul 2020 02:36:18 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F330C061755;
        Thu, 16 Jul 2020 23:36:18 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id g67so6208958pgc.8;
        Thu, 16 Jul 2020 23:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fuLbBhPUhKAR3I+8q0SKnGOpN3cxYtGrBhqDxxyRUk8=;
        b=FuhR7AENpGuNAggdn7GFuVjmvAwOLgp5wsm5TjTGHb0s6g3tCkJJWQaAoTZt31h8OK
         pSIvNYxVWnQt0XVwCHUbFzU62AokgKo9SwJvjy/7ggnro6gp5PFuh1+MUCqzNCEdTa4T
         vbTofkSxIL2ohZoZSJj4UtWgw6cfM4GpJAqF/hObVtERDsZoFaiPfaeprsHFVNphMLgw
         xIFRy8PjR6vgHR8xoxhKemhD71CMLJew0yqX54JdlDas03e3JUEaLEJvkc6I0WKRtEwz
         /FEGpid2HHRavSZn3sUiG8qTmwA0rLdCRq+znNkqdXPYVWEMTdxYWUS1lgEhzVCY9XFO
         J4nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=fuLbBhPUhKAR3I+8q0SKnGOpN3cxYtGrBhqDxxyRUk8=;
        b=XUA+T/l7lq5xjVs/0nl5C0W7ldy/XYwMpdRSJFHlD6riVOXv9kZB2S4M3SNQW2rfRY
         QsxZjpajcp0gvTBNcOvgzybkayDKRAAdIjcGk6CTRmqWH+CXTC+vvbTj1a2Qz2oqJfv9
         +ZHBzH6dHDPTkvl+V/WGoI8T6eQMzg95GsL0+GlFaQtfLBzmg1HQs7cAq3fdOMMQDm4l
         9jvg4snbTv+to/NqtIa4X06kd5Jj1/BhWppMJK53hUEV99J3miz/uUx/bB2eaJv9a2Hq
         w8bisyaunPe0H+M+bOiiB36kZe3NDTNAZsZ/L1vdSHRAAasbAL2tHD2KbAsSmHlr6gVz
         v2Cw==
X-Gm-Message-State: AOAM533HtL9YHCUNhB5FSxoSx5yjc7OIoG/P0rdD1YbUq36s/khuw75/
        9a9PgAdmptYFdXvWA2oIwqw=
X-Google-Smtp-Source: ABdhPJxmGs8PQMT/xY21Q4L1G8znzEuRE+0Deq1bt+KZPU72UfztLi9k6nCm5FwF046HkfepC1ye6Q==
X-Received: by 2002:a63:1f11:: with SMTP id f17mr7213867pgf.217.1594967777748;
        Thu, 16 Jul 2020 23:36:17 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id y22sm1683392pjp.41.2020.07.16.23.36.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 23:36:17 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Adam Radford <aradford@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        Hannes Reinecke <hare@suse.com>,
        Bradley Grove <linuxdrivers@attotech.com>,
        John Garry <john.garry@huawei.com>,
        Don Brace <don.brace@microsemi.com>,
        James Smart <james.smart@broadcom.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v1 00/15] scsi: use generic power management
Date:   Fri, 17 Jul 2020 12:04:23 +0530
Message-Id: <20200717063438.175022-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to upgrade power management in scsi
drivers. This has been done by upgrading .suspend() and .resume() callbacks.

The upgrade makes sure that the involvement of PCI Core does not change the
order of operations executed in a driver. Thus, does not change its behavior.

In general, drivers with legacy PM, .suspend() and .resume() make use of PCI
helper functions like pci_request/release_regions(), pci_set_power_state(),
pci_save/restore_state(), pci_enable/disable_device(), etc. to complete
their job.

The conversion requires the removal of those function calls, change the
callbacks' definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

Vaibhav Gupta (15):
  scsi: megaraid_sas: use generic power management
  scsi: aacraid: use generic power management
  scsi: aic7xxx: use generic power management
  scsi: aic79xx: use generic power management
  scsi: arcmsr: use generic power management
  scsi: esas2r: use generic power management
  scsi: hisi_sas_v3_hw: use generic power management
  scsi: mpt3sas_scsih: use generic power management
  scsi: lpfc: use generic power management
  scsi: pm_8001: use generic power management
  scsi: hpsa: use generic power management
  scsi: 3w-9xxx: use generic power management
  scsi: 3w-sas: use generic power management
  scsi: mvumi: use generic power management
  scsi: pmcraid: use generic power management

 drivers/scsi/3w-9xxx.c                    |  30 ++-----
 drivers/scsi/3w-sas.c                     |  31 ++-----
 drivers/scsi/aacraid/linit.c              |  34 ++------
 drivers/scsi/aic7xxx/aic79xx.h            |  12 +--
 drivers/scsi/aic7xxx/aic79xx_core.c       |   8 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c    |  43 +++-------
 drivers/scsi/aic7xxx/aic79xx_pci.c        |   6 +-
 drivers/scsi/aic7xxx/aic7xxx.h            |  10 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c       |   6 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c    |  46 +++-------
 drivers/scsi/aic7xxx/aic7xxx_pci.c        |   4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |  35 +++-----
 drivers/scsi/esas2r/esas2r.h              |   5 +-
 drivers/scsi/esas2r/esas2r_init.c         |  46 +++-------
 drivers/scsi/esas2r/esas2r_main.c         |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  32 +++----
 drivers/scsi/hpsa.c                       |  12 +--
 drivers/scsi/lpfc/lpfc_init.c             | 100 +++++++---------------
 drivers/scsi/megaraid/megaraid_sas_base.c |  57 ++++--------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  36 +++-----
 drivers/scsi/mvumi.c                      |  49 +++--------
 drivers/scsi/pm8001/pm8001_init.c         |  43 ++++------
 drivers/scsi/pmcraid.c                    |  42 +++------
 23 files changed, 208 insertions(+), 482 deletions(-)

-- 
2.27.0

