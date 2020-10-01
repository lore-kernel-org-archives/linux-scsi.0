Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E057C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:27:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3561E20B1F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:27:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XT3oXB+K"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732145AbgJAM1j (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731926AbgJAM1i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:27:38 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D839CC0613E2;
        Thu,  1 Oct 2020 05:27:38 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id f18so4318928pfa.10;
        Thu, 01 Oct 2020 05:27:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KnvOWxZ63jDVIsDgpt2eg9PovmEULDReeqd1RWk++3Y=;
        b=XT3oXB+KwHrk8NDmUsYAVQar7wtEudnXYvLpo0HLetQqt9/WXcp7tKJhmADJ6pMAyX
         yffVbmBwwOArZ3D2Rf9e5zJUJ+c3EAlVFv2nr1u9LEpoyD9aNnf5yU8lUWpTOlo0i5M5
         lUnwxH0kKfSLMEvU7nXLVMAHd3hYQyCXoj0TUO1NRhgq1qmYfyOv10jGoobekJ5Ta+B7
         1+X/Tl4qyvXOZZ5WxsJkRAnDTpI0QFSrVHD7OtmahZktaHR9+2mZiA9EvYN0BNmqPUYR
         MUJww83bgQQfK6unK2FpmEsfCZ2fam+OdqmIecVxEB8r629Nf7IdmYg1FqipQPT3+KCD
         egFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=KnvOWxZ63jDVIsDgpt2eg9PovmEULDReeqd1RWk++3Y=;
        b=c+a5VOXX2BjHzmlJQfWZy0kpGzSAKARedZat/Yyz2IhNvz9poe+SQM0RgiDuxiD5Aq
         REC+EpfBCaTHGyLjh+9fBozKZQRMlZj9zJaf7oEkYjpBZKv3unWaA5YdQEoV+rP6Hupu
         62zFkdIyzbLwF5TFGIooh5UTbgVyYI8hyr1I+XOSJv42FlxF1+VVX4cAuLJOueIOCn+h
         CsjdfI7PxaY6N8GqS6r+CstagJ0PvVgtIZ7YtT+4YJ/ozr4UMFnebXdgGaaOAC7fV6TZ
         XHlhOvhrPx2qP+qDCgUiRsfpbZGXIL3C3wft1psYOXhNB36oxNTrr2OfT8k72784Fc/b
         J9YA==
X-Gm-Message-State: AOAM531dmU1+tKjPA+U1T8D0QeZBhgIf97XcO/Va2KBSzeIIehY3Ff+g
        wABSmJWg4AT5QDnUWKDEYl4=
X-Google-Smtp-Source: ABdhPJxZxHrN4qdXBPbki0Mn6IkgDW70IP12ApWg4XPJw4fN3UQsJvHGnpRePmsGG3LIJ8wW5pLtFQ==
X-Received: by 2002:a17:902:b70c:b029:d1:9b2d:1132 with SMTP id d12-20020a170902b70cb02900d19b2d1132mr7043930pls.36.1601555258339;
        Thu, 01 Oct 2020 05:27:38 -0700 (PDT)
Received: from varodek.localdomain ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id m13sm5695199pjl.45.2020.10.01.05.27.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:27:37 -0700 (PDT)
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
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
        Jack Wang <jinpu.wang@cloud.ionos.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v3 00/28] scsi: use generic power management
Date:   Thu,  1 Oct 2020 17:54:43 +0530
Message-Id: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
X-Mailer: git-send-email 2.28.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to upgrade power management in xxxxxxxx
drivers. This has been done by upgrading .suspend() and .resume() callbacks.

The upgrade makes sure that the involvement of PCI Core does not change the
order of operations executed in a driver. Thus, does not change its behavior.

In general, drivers with legacy PM, .suspend() and .resume() make use of PCI
helper functions like pci_enable/disable_device_mem(), pci_set_power_state(),
pci_save/restore_state(), pci_enable/disable_device(), etc. to complete
their job.

The conversion requires the removal of those function calls, change the
callbacks' definition accordingly and make use of dev_pm_ops structure.

All patches are compile-tested only.

v3: break down the patches to drop PCI wakeup calls.

Test tools:
    - Compiler: gcc (GCC) 10.2.0
    - allmodconfig build: make -j$(nproc) W=1 all

Vaibhav Gupta (28):
  scsi: megaraid_sas: Drop PCI wakeup calls from .resume
  scsi: megaraid_sas: use generic power management
  scsi: megaraid_sas: update function description
  scsi: aacraid: Drop pci_enable_wake() from .resume
  scsi: aacraid: use generic power management
  scsi: aic7xxx: use generic power management
  scsi: aic79xx: use generic power management
  scsi: arcmsr: Drop PCI wakeup calls from .resume
  scsi: arcmsr: use generic power management
  scsi: esas2r: Drop PCI Wakeup calls from .resume
  scsi: esas2r: use generic power management
  scsi: hisi_sas_v3_hw: Drop PCI Wakeup calls from .resume
  scsi: hisi_sas_v3_hw: use generic power management
  scsi: mpt3sas_scsih: Drop PCI Wakeup calls from .resume
  scsi: mpt3sas_scsih: use generic power management
  scsi: lpfc: use generic power management
  scsi: pm_8001:  Drop PCI Wakeup calls from .resume
  scsi: pm_8001: use generic power management
  scsi: hpsa: use generic power management
  scsi: 3w-9xxx: Drop PCI Wakeup calls from .resume
  scsi: 3w-9xxx: use generic power management
  scsi: 3w-sas: Drop PCI Wakeup calls from .resume
  scsi: 3w-sas: use generic power management
  scsi: mvumi: Drop PCI Wakeup calls from .resume
  scsi: mvumi: use generic power management
  scsi: mvumi: update function description
  scsi: pmcraid: Drop PCI Wakeup calls from .resume
  scsi: pmcraid: use generic power management

 drivers/scsi/3w-9xxx.c                    |  30 ++-----
 drivers/scsi/3w-sas.c                     |  32 ++-----
 drivers/scsi/aacraid/linit.c              |  34 ++------
 drivers/scsi/aic7xxx/aic79xx.h            |  12 +--
 drivers/scsi/aic7xxx/aic79xx_core.c       |   8 +-
 drivers/scsi/aic7xxx/aic79xx_osm_pci.c    |  43 +++-------
 drivers/scsi/aic7xxx/aic79xx_pci.c        |   6 +-
 drivers/scsi/aic7xxx/aic7xxx.h            |  10 +--
 drivers/scsi/aic7xxx/aic7xxx_core.c       |   6 +-
 drivers/scsi/aic7xxx/aic7xxx_osm_pci.c    |  46 +++-------
 drivers/scsi/aic7xxx/aic7xxx_pci.c        |   4 +-
 drivers/scsi/arcmsr/arcmsr_hba.c          |  33 +++----
 drivers/scsi/esas2r/esas2r.h              |   5 +-
 drivers/scsi/esas2r/esas2r_init.c         |  48 +++--------
 drivers/scsi/esas2r/esas2r_main.c         |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  31 +++----
 drivers/scsi/hpsa.c                       |  12 +--
 drivers/scsi/lpfc/lpfc_init.c             | 100 +++++++---------------
 drivers/scsi/megaraid/megaraid_sas_base.c |  54 +++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  35 +++-----
 drivers/scsi/mvumi.c                      |  49 +++--------
 drivers/scsi/pm8001/pm8001_init.c         |  46 ++++------
 drivers/scsi/pmcraid.c                    |  44 +++-------
 23 files changed, 198 insertions(+), 493 deletions(-)

-- 
2.28.0

