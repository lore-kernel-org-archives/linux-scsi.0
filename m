Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB7A0C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61BFB64E33
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 08:57:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhCQI5R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 Mar 2021 04:57:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbhCQI5H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Mar 2021 04:57:07 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63001C06175F
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:07 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id t5-20020a1c77050000b029010e62cea9deso849415wmi.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Mar 2021 01:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wVUxohbsfODPlJl3e1edTwvvrJeFWzCJfamwkCreXQ=;
        b=IYgLtZTY7WoXHTe6XoxbNP9IG4gzinQ889fwNtBUHEwHJHDn6k7qtirS8GXP3SKz7I
         w3HBQ6W9vCxmK7fVqv3FBzzGZHOX3SVfoJWzx3Gv1u8L3g/DpAqI3xIyOtAvtoiBPU70
         ps1ABIYnj6hrxqYGR2AGbyF7EH+klmkDnKa+aEcZrnbakW+kUy7lvKGksZQvN1yr1MHj
         RFO597U0OwGxuVBE0o3W60iIGe2Dd5VFEBYnRKtOK61GqUr6WZC8ixFskprN8M9T7fA5
         73MGEIEijX6EJuk408gV+6NULmlapZcAU5huUAKTcdYATmJiEjCoSBJdTaQMjLS9fuJb
         7cHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=8wVUxohbsfODPlJl3e1edTwvvrJeFWzCJfamwkCreXQ=;
        b=p882+cH0ugSawtph+CkGPQi7hD+Y0ZtdhcD9Jqemkx5/yh03Cx1RH4VaEaqVgSVcPz
         0YmKMA1Mo9DSmd9RSvUnInrhxXUsLRnclXb9kEBJkNOdaUcEZNGPddorHpbZRLiUE0AI
         O61Nklb9ZaDCvJT7pKJCy7LmOd+Psd1ATZzV6+fnV049vLksPt23UK5XEPWivOyS64Gq
         qACbNnsGE6CZBssyxnQ+4m9MDp+d68ZVDwxB9IShmnJvsasKNnTO/NykaAGiOfqSI380
         6/kFFZwCT7gtdRmSCqXDmPo6qob0JqdVG6rxfvYoIXqhKXwTkL27zmymWBoiat2DN6v+
         XumQ==
X-Gm-Message-State: AOAM531kp5hLYKI8FZOFPZXWojrL1DZsYIW7UF9USH4eriH5REVCcNlF
        +2oSJEoqlPdauo3Oh9rJqhJysQ==
X-Google-Smtp-Source: ABdhPJy1WxEldnSEoa91DUSjnpGbdUAkrmiOqKjHsdynmfFCTAvvvqZPHQkJcQwmBl7uSWswCqHJrg==
X-Received: by 2002:a7b:c151:: with SMTP id z17mr2653536wmi.189.1615971426070;
        Wed, 17 Mar 2021 01:57:06 -0700 (PDT)
Received: from dell.default ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id j123sm1807243wmb.1.2021.03.17.01.57.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 01:57:05 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-kernel@vger.kernel.org, Adam Radford <aradford@gmail.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Andre Hedrick <andre@suse.com>,
        Anil Gurumurthy <anil.gurumurthy@qlogic.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Bradley Grove <linuxdrivers@attotech.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        c by <James.Bottomley@SteelEye.com>,
        Christoph Hellwig <hch@lst.de>,
        David Chaw <david_chaw@adaptec.com>,
        de Melo <acme@conectiva.com.br>,
        Doug Ledford <dledford@redhat.com>,
        GOTO Masanori <gotom@debian.or.jp>, gotom@debian.org,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Joel Jacobson <linux@3ware.com>,
        Khalid Aziz <khalid@gonehiking.org>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        Linux GmbH <hare@suse.com>, linux-scsi@vger.kernel.org,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        Richard Hirst <richard@sleepie.demon.co.uk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
Subject: [PATCH 00/18] [Set 3] Rid W=1 warnings in SCSI
Date:   Wed, 17 Mar 2021 08:56:43 +0000
Message-Id: <20210317085701.2891231-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This set contains functional changes.

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (18):
  scsi: aic94xx: aic94xx_dump: Remove code that has been unused for at
    least 13 years
  scsi: mpt3sas: mpt3sas_scs: Move a little data from the stack onto the
    heap
  scsi: bfa: bfa_fcs_lport: Move a large struct from the stack onto the
    heap
  scsi: esas2r: esas2r_log: Supply __printf(x, y) formatting for
    esas2r_log_master()
  scsi: BusLogic: Supply __printf(x, y) formatting for blogic_msg()
  scsi: nsp32: Supply __printf(x, y) formatting for nsp32_message()
  scsi: initio: Remove unused variable 'prev'
  scsi: a100u2w: Remove unused variable 'bios_phys'
  scsi: myrs: Remove a couple of unused 'status' variables
  scsi: 3w-xxxx: Remove 2 unused variables 'response_que_value' and
    'tw_dev'
  scsi: 3w-9xxx: Remove a few set but unused variables
  scsi: 3w-sas: Remove unused variables 'sglist' and 'tw_dev'
  scsi: nsp32: Remove or exclude unused variables
  scsi: FlashPoint: Remove unused variable 'TID' from
    'FlashPoint_AbortCCB()'
  scsi: sim710: Remove unused variable 'err' from sim710_init()
  scsi: isci: port: Make local function 'port_state_name()' static
  scsi: isci: remote_device: Make local function
    isci_remote_device_wait_for_resume_from_abort() static
  scsi: nsp32: Correct expected types in debug print formatting

 drivers/scsi/3w-9xxx.c               |  14 +-
 drivers/scsi/3w-sas.c                |  10 +-
 drivers/scsi/3w-xxxx.c               |   6 +-
 drivers/scsi/BusLogic.c              |   2 +-
 drivers/scsi/FlashPoint.c            |   4 -
 drivers/scsi/a100u2w.c               |   2 -
 drivers/scsi/aic94xx/aic94xx_dump.c  | 184 ---------------------------
 drivers/scsi/bfa/bfa_fcs_lport.c     |  20 ++-
 drivers/scsi/esas2r/esas2r_log.c     |   7 +
 drivers/scsi/initio.c                |   5 +-
 drivers/scsi/isci/port.c             |   2 +-
 drivers/scsi/isci/remote_device.c    |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  38 ++++--
 drivers/scsi/myrs.c                  |   6 +-
 drivers/scsi/nsp32.c                 |  31 ++---
 drivers/scsi/sim710.c                |  14 +-
 16 files changed, 77 insertions(+), 270 deletions(-)

Cc: Adam Radford <aradford@gmail.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andre Hedrick <andre@suse.com>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>
Cc: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Bas Vermeulen <bvermeul@blackstar.xs4all.nl>
Cc: Bradley Grove <linuxdrivers@attotech.com>
Cc: Brian Macy <bmacy@sunshinecomputing.com>
Cc: c by <James.Bottomley@SteelEye.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: David Chaw <david_chaw@adaptec.com>
Cc: de Melo <acme@conectiva.com.br>
Cc: Doug Ledford <dledford@redhat.com>
Cc: GOTO Masanori <gotom@debian.or.jp>
Cc: gotom@debian.org
Cc: Hannes Reinecke <hare@kernel.org>
Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc: Joel Jacobson <linux@3ware.com>
Cc: Khalid Aziz <khalid@gonehiking.org>
Cc: "Leonard N. Zubkoff" <lnz@dandelion.com>
Cc: Linux GmbH <hare@suse.com>
Cc: linux-scsi@vger.kernel.org
Cc: Luben Tuikov <luben_tuikov@adaptec.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: MPT-FusionLinux.pdl@avagotech.com
Cc: MPT-FusionLinux.pdl@broadcom.com
Cc: Richard Hirst <richard@sleepie.demon.co.uk>
Cc: Sathya Prakash <sathya.prakash@broadcom.com>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>
Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Cc: YOKOTA Hiroshi <yokota@netlab.is.tsukuba.ac.jp>
-- 
2.27.0

