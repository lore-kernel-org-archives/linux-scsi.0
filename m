Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BE0E8C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:36:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D0B22BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:36:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hr1rw70u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726506AbgGTNgp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:36:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726095AbgGTNgo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:36:44 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C4EC061794;
        Mon, 20 Jul 2020 06:36:44 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id m16so8695224pls.5;
        Mon, 20 Jul 2020 06:36:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svzex4JoBI+TqIlNVYqV7CeQSTsDrNY3zs1taUIVD5o=;
        b=hr1rw70u7ky7+dRggM5mt3aq8ONWDggtxFNOAA9WSmQsI/+0FloFoqkkHSmme0evgW
         RzvobflXJsaWGSsQHY8z19pznc7W/e/S3h9xUhGorgr3WvXOH9ONPf/jdG6pc9BoJcOy
         Kxr3X0ONONg0sQnPEMDy8QGJ7S6nd90m8E7oI4QtYmvqqOIfQlYlSzKpQVTRtq7I1ZCV
         IEjZFUVy6hTQkU6Bot/mVQPOzg2sPbctaeo91pVUCvJO3ubPBNHiGs3Ixbz+B4C4vJaC
         yUXWfsMJEpO/N+xACsJEhqoHO7ZWu3kXuPDJdos4keO+asmb3pOZzwgO/5SxDLIdEmsb
         5S2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=svzex4JoBI+TqIlNVYqV7CeQSTsDrNY3zs1taUIVD5o=;
        b=PiKz8WySgBTIrRLSFtOc1WWH2NirC2EeXpjm9yR97ZNpV0I+V79YHABwgjVt1fZ3po
         4edW2DFKD+fce2cxfiojSJTrLMuIWfH7lTXej7Gpa38w9P7UAAMNF1sUB7UB+xtJt5Zf
         zef41UOfyZREwNT4MrolKEzgfLPuHmBwfN2H3d4W0S5/r0dztvNt/YIQl6MJbmovt8sG
         QEvm+nbyGAouNLMJDKAGcCeKIDVIhxTdeGhOMWyQvTXGFMGapXM2ZJjhlyVyBpB9ta3D
         yyN4UDawbDPoK+5hG6tHQj6UOxGuPlqduSkq+SFtejPHfzjaRFTZfVTaaDj5UiaarpR3
         2N3w==
X-Gm-Message-State: AOAM530Lgy03ZTE51kNv0eGS4RL+wYY73z9IduoCTqvaw/9RwBadeMt9
        cIhvQ+Ra2+zw/gHPPGCbHPE=
X-Google-Smtp-Source: ABdhPJzy2QoavlFCn058EI7KFEuJF+P+jZbpO9UumXH4k+wYBjn/nR5URm+RG/8UlGc/aYV/ewxhoA==
X-Received: by 2002:a17:902:9683:: with SMTP id n3mr17800342plp.65.1595252203990;
        Mon, 20 Jul 2020 06:36:43 -0700 (PDT)
Received: from varodek.iballbatonwifi.com ([103.105.153.67])
        by smtp.gmail.com with ESMTPSA id s6sm17042183pfd.20.2020.07.20.06.36.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2020 06:36:43 -0700 (PDT)
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
Subject: [PATCH v2 00/15] scsi: use generic power management
Date:   Mon, 20 Jul 2020 19:04:13 +0530
Message-Id: <20200720133427.454400-1-vaibhavgupta40@gmail.com>
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

v2: kbuild error in v1.

All patches are compile-tested only.

Test tools:
    - Compiler: gcc (GCC) 10.1.0
    - allmodconfig build: make -j$(nproc) W=1 all

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
 drivers/scsi/esas2r/esas2r_init.c         |  48 +++--------
 drivers/scsi/esas2r/esas2r_main.c         |   3 +-
 drivers/scsi/hisi_sas/hisi_sas_v3_hw.c    |  32 +++----
 drivers/scsi/hpsa.c                       |  12 +--
 drivers/scsi/lpfc/lpfc_init.c             | 100 +++++++---------------
 drivers/scsi/megaraid/megaraid_sas_base.c |  61 ++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c      |  36 +++-----
 drivers/scsi/mvumi.c                      |  49 +++--------
 drivers/scsi/pm8001/pm8001_init.c         |  46 ++++------
 drivers/scsi/pmcraid.c                    |  44 +++-------
 23 files changed, 212 insertions(+), 489 deletions(-)

-- 
2.27.0

