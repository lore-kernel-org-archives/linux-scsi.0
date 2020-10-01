Return-Path: <SRS0=33X3=DI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDD34C4727F
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 68D59208B6
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Oct 2020 12:36:11 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rt4knFN4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731993AbgJAMgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Oct 2020 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731888AbgJAMgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2020 08:36:10 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E64D0C0613D0;
        Thu,  1 Oct 2020 05:36:09 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id o20so4331134pfp.11;
        Thu, 01 Oct 2020 05:36:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HeCnOn1AQe3noYdugT04ghfsqOvbH2UWxnYiZwAM8pA=;
        b=rt4knFN4h3KcmnWb2GEvtruXlgj4A3ABG4c+p+lZgq8d0S7BPuavcOqsp+hpCWYnXa
         GBhlDx9GAoZl/WT4QarzotnCcoaOig5MEEZM2w7ayQ4/6mExeprO3yX59LvJ/ZKTEope
         eCX6NsiVakdbaUT2AWNV5OPVcv7hk0hAWqbuJHMBGmPftGR5rliKLLWIw+ArUCGw++Hi
         BYqj8x3qN3xTOFBPD6eXwGnf4PgImhLpbfDnF0PK/pXDXiRpnaYXcY1KmpO7fMelw5Yk
         +URRcsC8D8J3ceuBDE98YcASVGn0qhELhALvmdAFyYF2MGzybK0bSSKgrZbfeP/7jLkw
         zMdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HeCnOn1AQe3noYdugT04ghfsqOvbH2UWxnYiZwAM8pA=;
        b=SpnpKF03RatQTUSSR4/BHbKazm8PlqDFHV7M8Bt8MqCLji+9Ax3dsM6qbmxx6hmFBq
         iTszxyds25jL9wplgbVgztHkAKwPjQrtlK2mleGzU+dclZ+nZ8i4FJFBDULz9NEFQnmV
         SDjuejwbvLCeP0pDaK/sZGG2NeucL6QttgEcU0cxxabn4PB3jRxAi9T6p3zB/k7TaoSl
         /32g40qx2OCK8gAlBUXc7yut4c6iinn0I5YbDISn8wFI8VPgMZFQWdOx1xjj7jJ+ufcB
         DRoFmDOTSpRDCPLyjfPdruiusev9fOeZWQ59CG4QnZ6OZddmmyG4yy6UC5LsACWHgiI6
         KeZQ==
X-Gm-Message-State: AOAM530QNZCSeBr0+z4KXR1RqWjXsn9ms3UyhMzyP2qyN/Qn5tswEfzd
        +4sJiKwfdRbeCW0FhJdx+Zs=
X-Google-Smtp-Source: ABdhPJzxdm0M5/Xa1AF4jzUYvFX502HO3gy4L4RNmkZ3YO7ybIdtABi+PhN71CQD6sxdwWBSwF+ZHQ==
X-Received: by 2002:a17:902:ff07:b029:d1:e5fa:aa1d with SMTP id f7-20020a170902ff07b02900d1e5faaa1dmr7173912plj.84.1601555769436;
        Thu, 01 Oct 2020 05:36:09 -0700 (PDT)
Received: from gmail.com ([171.61.143.130])
        by smtp.gmail.com with ESMTPSA id n3sm3590631pjv.29.2020.10.01.05.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2020 05:36:08 -0700 (PDT)
Date:   Thu, 1 Oct 2020 18:03:58 +0530
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
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: Re: [PATCH v3 00/28] scsi: use generic power management
Message-ID: <20201001123358.GA1075511@gmail.com>
References: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201001122511.1075420-1-vaibhavgupta40@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Oct 01, 2020 at 05:54:43PM +0530, Vaibhav Gupta wrote:
Linux Kernel Mentee: Remove Legacy Power Management.

The purpose of this patch series is to upgrade power management in SCSI
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

