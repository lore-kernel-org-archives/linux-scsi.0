Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4D30C4742C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C1C42084C
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 14:25:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J1pfvM9g"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbgKBOYL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 09:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726031AbgKBOYE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 09:24:04 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08DE2C061A04
        for <linux-scsi@vger.kernel.org>; Mon,  2 Nov 2020 06:24:04 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id c9so8035480wml.5
        for <linux-scsi@vger.kernel.org>; Mon, 02 Nov 2020 06:24:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfaEdHgBmw2l0HgsbZl3mj1NuXZBElDuHydbjKuUqqI=;
        b=J1pfvM9g1qpPeI81gjB/VYKQEg+2KdGsJzuKhlfX5oHLKbyxX12KVMOF56Rx8VEz4Y
         7DCyhYtXYG4JKFMcrjB0NZjTXQ1rGiQ2W6apTgNdzXdpll/VXXiUAEoJ+UyAjkW3EbPI
         B0juqx/Sw2Tmi6RSpKHxUKQrGQntKG4pUsxi+YYDr0qzOWrJdPNsu96OP2Kb1pOtNhva
         KGJNWG/pzyZOi4rWVCD6Kqe8HLGgZnw1XDZNxuyEh8YGZXq2Qt5NiGNvDpsV6pHrcFy2
         kBdyMOHgGRYAMN+EVrXL+s5fbpedS/fBc2Wk4Q9d0btIfTzOvBVAdH1KmJa8n/x+ANdM
         kT6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pfaEdHgBmw2l0HgsbZl3mj1NuXZBElDuHydbjKuUqqI=;
        b=O1+3NDWme/CXuNSEP4u+MGLZfXgq3JT3jnlffdEPYVyAxqNNv5j3CpBspnw0CMJD2m
         0OTeKFmNUV9MJLk7osI4nEx6RWeqigrPI+r3SPjlwpzyZgi71uNLhKONo+kz3JG4YLke
         qYDQJ6+Npdl/9JahRtCaVLf5uA7K8OQJ2txxhD/lvC4sCJURISdLs/cjwMdk9Qf87i89
         QO9qKB5vfR2InvADKP+vCyM0RBRM6Wxv8aqvaHXrwT3KKgUQHQlsgI0gxiFFWgKrbu/X
         x9RAVoX4eyQvdFqYbmt3b+KJmwHcm2a1GxdWscgooft+FqQmFgrRwd8uljcYPtzOfGJq
         kWmw==
X-Gm-Message-State: AOAM531hywjpBF2Kyt+j1qqvTdgy+Jlx/9K+Ta3A8sz4eDStCbLVHgTY
        Z/5bRtQZyf13R1vAGyaHpz72hg==
X-Google-Smtp-Source: ABdhPJxptVEKDqrhUDqsGd1T2xKfaeFsV7xZnIIIySqexTSIanwWk9hgMFroEGh99uCK2iovzdLGeQ==
X-Received: by 2002:a1c:6302:: with SMTP id x2mr19015414wmb.121.1604327041826;
        Mon, 02 Nov 2020 06:24:01 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id f7sm23542501wrx.64.2020.11.02.06.24.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 06:24:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     martin.petersen@oracle.com, jejb@linux.ibm.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>
Subject: [RESEND 00/19] Rid W=1 warnings in SCSI
Date:   Mon,  2 Nov 2020 14:23:40 +0000
Message-Id: <20201102142359.561122-1-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[Resending to include the SCSI ML as per Martin's request]

This set is part of a larger effort attempting to clean-up W=1
kernel builds, which are currently overwhelmingly riddled with
niggly little warnings.

Lee Jones (19):
  scsi: aic7xxx: aic79xx_osm: Remove unused variable 'saved_scsiid'
  scsi: mpt3sas: mpt3sas_scsih: Fix function documentation formatting
  scsi: lpfc: lpfc_scsi: Fix a whole host of kernel-doc issues
  scsi: lpfc: lpfc_attr: Demote kernel-doc format for redefined
    functions
  scsi: lpfc: lpfc_attr: Fix-up a bunch of kernel-doc misdemeanours
  scsi: lpfc: lpfc_debugfs: Fix a couple of function documentation
    issues
  scsi: lpfc: lpfc_bsg: Provide correct documentation for a bunch of
    functions
  scsi: esas2r: esas2r_disc: Place brackets around a potentially empty
    if()
  scsi: esas2r: esas2r_init: Place brackets around a potentially empty
    if()
  scsi: lpfc: lpfc_nvme: Remove unused variable 'phba'
  scsi: ufs: ufshcd: Fix some function doc-rot
  scsi: lpfc: lpfc_nvme: Fix some kernel-doc related issues
  scsi: esas2r: esas2r_int: Add brackets around potentially empty if()s
  scsi: lpfc: lpfc_nvmet: Fix-up some formatting and doc-rot issues
  scsi: esas2r: esas2r_main: Demote non-conformant kernel-doc header
  scsi: advansys: Relocate or remove unused variables
  scsi: dc395x: Remove a few unused variables
  scsi: dc395x: Mark 's_stat2' as __maybe_unused
  scsi: hpsa: Strip out a bunch of set but unused variables

 drivers/scsi/advansys.c              | 16 ++------
 drivers/scsi/aic7xxx/aic79xx_osm.c   |  3 +-
 drivers/scsi/dc395x.c                | 15 +++-----
 drivers/scsi/esas2r/esas2r_disc.c    |  3 +-
 drivers/scsi/esas2r/esas2r_init.c    |  5 ++-
 drivers/scsi/esas2r/esas2r_int.c     |  8 ++--
 drivers/scsi/esas2r/esas2r_main.c    |  8 +---
 drivers/scsi/hpsa.c                  | 25 ++++---------
 drivers/scsi/lpfc/lpfc_attr.c        | 56 +++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_bsg.c         | 34 ++++++++---------
 drivers/scsi/lpfc/lpfc_debugfs.c     |  3 +-
 drivers/scsi/lpfc/lpfc_nvme.c        | 37 ++++++++----------
 drivers/scsi/lpfc/lpfc_nvmet.c       | 17 ++++-----
 drivers/scsi/lpfc/lpfc_scsi.c        | 48 +++++++++++++++---------
 drivers/scsi/mpt3sas/mpt3sas_scsih.c |  8 ++--
 drivers/scsi/ufs/ufshcd.c            |  3 +-
 16 files changed, 141 insertions(+), 148 deletions(-)

-- 
2.25.1

