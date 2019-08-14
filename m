Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67AA8C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3719520866
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 23:57:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ITFlNPQz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729076AbfHNX53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Aug 2019 19:57:29 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45889 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726119AbfHNX51 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Aug 2019 19:57:27 -0400
Received: by mail-pl1-f193.google.com with SMTP id y8so319169plr.12
        for <linux-scsi@vger.kernel.org>; Wed, 14 Aug 2019 16:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KSzEmMIFwEkQnQXdwP+KZk5P0GXPZH+DkJKJwg5ojV4=;
        b=ITFlNPQz7d+dRD5hbifAvca1NnVKXtuCfyv2oJsljN2gLtcDLK/JHfaTEdSKRRTPcq
         YFJz1XJB0tO7/Fv6j80MhVkaeuOlVrNHnMp8ex1KbcG4tiGHri/RmYKQQd89vgUc9YaF
         4SMq6FSDbXy/J8RTGFzwG2NcMavVIfdqZGIuUTG8mzFWccLdxy3VJTpnTmqQ7Cvcjy8o
         dwqLS0CTMScaLCIcMiOeJ4JvGv4ICXawFvQVdd5Q4NF2q7qr/BfnKQ3vRhwzWr630LR1
         bBt1HGModqzI08L9+4PUd3E166bJLf6okPvOOcyRUjCg8yRofEwpZMrDWD12w5/xK97a
         TOqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KSzEmMIFwEkQnQXdwP+KZk5P0GXPZH+DkJKJwg5ojV4=;
        b=LMuS86gJx7vmths+Kj4CVLTsqqRX91wKtE3iiGkttpF0R4BtE9gjsvABDw09QDFVRe
         DhXybUtvMr2wMB3C5rkYIRvJNLUE8WunXxEAICngRGgGQyocLJWVUrdJyilVXW9DJt6Z
         fehnTTNLjB8btM/H1jTlWREVe7X0Yy/JZ86I8ALvr+625DWP5TdgK36426Kv0PLW1Oev
         uE2M4E8wNcYdVkA0IXfbOxdDse2HsEbJGQe6/5f8MttRS/SvKGWcLdpXCsRhJvIGKNAJ
         MdeyL2m49OVHruQW0I5mbUQX6mp1pf91kLTytDdd7ln3M6bzHK2XAtsbjMxvj7FGyi6F
         cznw==
X-Gm-Message-State: APjAAAX+l1MSBghNWN7q/+v/vpsYfoYe9kGhtJme9T1ZdpgphA3oZ3vl
        xJ2cKcyQ9T2Wd+kCq3liwICcUb3E
X-Google-Smtp-Source: APXvYqyvR2xb6iWnwUOWxD/Cx/CCoaHN3+ZYSLjOa/Wic0PdOyoiP/3fZik2Ve9gGfxnmchWcYIFTg==
X-Received: by 2002:a17:902:b413:: with SMTP id x19mr1812425plr.121.1565827042516;
        Wed, 14 Aug 2019 16:57:22 -0700 (PDT)
Received: from pallmd1.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k22sm987299pfk.157.2019.08.14.16.57.21
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 14 Aug 2019 16:57:21 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 00/42] lpfc: Update lpfc to revision 12.4.0.0
Date:   Wed, 14 Aug 2019 16:56:30 -0700
Message-Id: <20190814235712.4487-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.13.7
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 12.4.0.0

This patch set contains a laundry list of fixes for lpfc. Most are small.
There are a couple of cleanup patches and several functional additions
at the tail of the patch set.

The patches were cut against Martin's 5.4/scsi-queue tree


James Smart (42):
  lpfc: Limit xri count for kdump environment
  lpfc: Fix PLOGI failure with high remoteport count
  lpfc: Fix ELS field alignments
  lpfc: Fix crash on driver unload in wq free
  lpfc: Fix failure to clear non-zero eq_delay after io rate reduction
  lpfc: Fix leak of ELS completions on adapter reset
  lpfc: Fix port relogin failure due to GID_FT interaction
  lpfc: Fix discovery when target has no GID_FT information
  lpfc: Fix ADISC reception terminating login state if a NVME target
  lpfc: Fix issuing init_vpi mbox on SLI-3 card
  lpfc: Fix Oops in nvme_register with target logout/login
  lpfc: Fix irq raising in lpfc_sli_hba_down
  lpfc: Fix oops when fewer hdwqs than cpus
  lpfc: Fix FLOGI handling across multiple link up/down conditions
  lpfc: Fix null ptr oops updating lpfc_devloss_tmo via sysfs attribute
  lpfc: Fix devices that don't return after devloss followed by
    rediscovery
  lpfc: Fix loss of remote port after devloss due to lack of RPIs
  lpfc: Fix propagation of devloss_tmo setting to nvme transport
  lpfc: Fix sg_seg_cnt for HBAs that don't support NVME
  lpfc: Fix driver nvme rescan logging
  lpfc: Fix error in remote port address change
  lpfc: Fix deadlock on host_lock during cable pulls
  lpfc: Fix crash due to port reset racing vs adapter error handling
  lpfc: Fix too many sg segments spamming in kernel log
  lpfc: Fix hang when downloading fw on port enabled for nvme
  lpfc: Fix nvme target mode ABTSing a received ABTS
  lpfc: Fix nvme sg_seg_cnt display if HBA does not support NVME
  lpfc: Fix sli4 adapter initialization with MSI
  lpfc: Fix upcall to bsg done in non-success cases
  lpfc: Fix Max Frame Size value shown in fdmishow output
  lpfc: Fix reported physical link speed on a disabled trunked link
  lpfc: Fix BlockGuard enablement on FCoE adapters
  lpfc: Fix nvme first burst module parameter description
  lpfc: Fix coverity warnings
  lpfc: Add simple unlikely optimizations to reduce NVME latency
  lpfc: Migrate to %px and %pf in kernel print calls
  lpfc: Add first and second level hardware revisions to sysfs reporting
  lpfc: Add MDS driver loopback diagnostics support
  lpfc: Support dynamic unbounded SGL lists on G7 hardware.
  lpfc: Add NVMe sequence level error recovery support
  lpfc: Merge per-protocol WQ/CQ pairs into single per-cpu pair
  lpfc: Update lpfc version to 12.4.0.0

 drivers/scsi/lpfc/lpfc.h           |   9 +-
 drivers/scsi/lpfc/lpfc_attr.c      |  76 +++-
 drivers/scsi/lpfc/lpfc_bsg.c       |  24 +-
 drivers/scsi/lpfc/lpfc_crtn.h      |   3 +-
 drivers/scsi/lpfc/lpfc_ct.c        |  68 ++-
 drivers/scsi/lpfc/lpfc_debugfs.c   |  96 +----
 drivers/scsi/lpfc/lpfc_debugfs.h   |  61 +--
 drivers/scsi/lpfc/lpfc_disc.h      |   3 +
 drivers/scsi/lpfc/lpfc_els.c       | 116 ++++-
 drivers/scsi/lpfc/lpfc_hbadisc.c   | 176 +++++---
 drivers/scsi/lpfc/lpfc_hw.h        |   6 +-
 drivers/scsi/lpfc/lpfc_hw4.h       |  34 ++
 drivers/scsi/lpfc/lpfc_init.c      | 857 +++++++++++++++++++------------------
 drivers/scsi/lpfc/lpfc_mem.c       |  44 +-
 drivers/scsi/lpfc/lpfc_nportdisc.c |  43 +-
 drivers/scsi/lpfc/lpfc_nvme.c      | 389 ++++++++++-------
 drivers/scsi/lpfc/lpfc_nvmet.c     |  28 +-
 drivers/scsi/lpfc/lpfc_scsi.c      | 512 ++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.c       | 529 +++++++++++++++++------
 drivers/scsi/lpfc/lpfc_sli.h       |  11 +-
 drivers/scsi/lpfc/lpfc_sli4.h      |  47 +-
 drivers/scsi/lpfc/lpfc_version.h   |   2 +-
 drivers/scsi/lpfc/lpfc_vport.c     |   8 +-
 23 files changed, 1965 insertions(+), 1177 deletions(-)

-- 
2.13.7

