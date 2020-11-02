Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 57441C4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16E1E222B9
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 16:50:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tctn+aOn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726886AbgKBQuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 11:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726788AbgKBQuU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 11:50:20 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31279C0617A6;
        Mon,  2 Nov 2020 08:50:20 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id k9so9584044pgt.9;
        Mon, 02 Nov 2020 08:50:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WJdqGZqtqi7lYaSTKy9+VN9HroJgepJgPjf8dagooAQ=;
        b=tctn+aOnt+DNJU9GfdIXIhjbifj58D71oNC6YIwWIvdWmCvNuJVwEB6yJJ8tHi3FtH
         IOwjfPy6l1Vfc9T/rB6gxtSM7KDCSbbklr0Zv6n6RAcFOTzLNZsSW4kDURtMedBhYv1O
         TFYny84yg0o/H9oPLu0tZvMVXEfq6vI8d40dHlgYueeWLKBe4Em4oU4l9Wf/QsaoLII7
         RohNxfj49HGbs46kFwD/tpf57l9rRj9KwJgnpdbLnaT1m3rNg0Vvct7cug5QK2pM5+YW
         RzSOzDrLzPArvrlBMz6Zm2V4qdzpW4t9Pj3XnKFLMsw+/UyrFmSVrSxbzswuOdsc2M3k
         D+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=WJdqGZqtqi7lYaSTKy9+VN9HroJgepJgPjf8dagooAQ=;
        b=m2GES4q7CRFZm5NTYiCU7Gff+a7V6nTdzLMOguCjMzx352pEA1WJU65zVQHwa3I6Xq
         /k5CG8TAQSWen5PDm9ga5sdOLNIAU2xBDS8o7aVi7NYeGDYt03p270J+eFwblQozdp9i
         BOi7Y37oxzofW8AA5yG8CQfuaLdtG2/DRLsa8O8t7mmH3n3DcqKeLhlmq0MUnDXrR0Pk
         o0FjUcx9EOTLO9Fw2JEzaqogk73WpcXtPVZ6GdV8QbEaPiyCpfVlom1Xav/CDbZPlXYr
         zenz3FjUab4AGTpKdNeKwUCwnsFPOA7PVBhRCDiABwZVzTrEMikzFFeHoutStBKNdV7l
         vyEQ==
X-Gm-Message-State: AOAM5324OM8kFPUyTdxOQPk9F+SJDsbdQoJwWWCJEBtzXG3y3IbJjOKE
        m9MpD7O2kKYDhr8igsFLf+E=
X-Google-Smtp-Source: ABdhPJzIKOnT0Gt9y13Ubo/Hzn4znwvj+BAjperZXTohj5lDyC0BHZHI3GAascSoDsuLMbbRX6cTLQ==
X-Received: by 2002:a17:90a:d201:: with SMTP id o1mr17693268pju.46.1604335819397;
        Mon, 02 Nov 2020 08:50:19 -0800 (PST)
Received: from varodek.localdomain ([223.179.149.110])
        by smtp.gmail.com with ESMTPSA id t74sm4953233pfc.47.2020.11.02.08.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 08:50:18 -0800 (PST)
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
        Xiang Chen <chenxiang66@hisilicon.com>,
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
        Balsundar P <balsundar.p@microchip.com>
Cc:     Vaibhav Gupta <vaibhavgupta40@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        megaraidlinux.pdl@broadcom.com, MPT-FusionLinux.pdl@broadcom.com
Subject: [PATCH v4 00/29] scsi: use generic power management
Date:   Mon,  2 Nov 2020 22:17:01 +0530
Message-Id: <20201102164730.324035-1-vaibhavgupta40@gmail.com>
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

Test tools:
    - Compiler: gcc (GCC) 10.2.0
    - allmodconfig build: make -j$(nproc) W=1 all

Vaibhav Gupta (29):
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
  scsi: hisi_sas_v3_hw: Don't use PCI helper functions
  scsi: hisi_sas_v3_hw: Remove extra function calls for runtime pm
  scsi: mpt3sas_scsih: Drop PCI Wakeup calls from .resume
  scsi: mpt3sas_scsih: use generic power management
  scsi: lpfc: use generic power management
  scsi: pm_8001: Drop PCI Wakeup calls from .resume
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
 drivers/scsi/arcmsr/arcmsr_hba.c          |  29 ++-----
 drivers/scsi/esas2r/esas2r.h              |   5 +-
 drivers/scsi/esas2r/esas2r_init.c         |  48 +++--------
 drivers/scsi/esas2r/esas2r_main.c         |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  41 ++-------
 drivers/scsi/hpsa.c                       |  12 +--
 drivers/scsi/lpfc/lpfc_init.c             | 100 +++++++---------------
 drivers/scsi/megaraid/megaraid_sas_base.c |  54 +++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  35 +++-----
 drivers/scsi/mvumi.c                      |  49 +++--------
 drivers/scsi/pm8001/pm8001_init.c         |  46 ++++------
 drivers/scsi/pmcraid.c                    |  44 +++-------
 23 files changed, 193 insertions(+), 504 deletions(-)

-- 
2.28.0

