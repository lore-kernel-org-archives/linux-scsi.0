Return-Path: <SRS0=1Um0=3I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1670C32771
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:13:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 89C9724683
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jan 2020 00:13:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VwUJuf7j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgASANu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 18 Jan 2020 19:13:50 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:51383 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727012AbgASANu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 18 Jan 2020 19:13:50 -0500
Received: by mail-wm1-f65.google.com with SMTP id d73so10892480wmd.1;
        Sat, 18 Jan 2020 16:13:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KZioIIcbbcqxpuu4wmoEytiac0TGQtoB//BlF7jteso=;
        b=VwUJuf7jYFeG/ZR9CyKRdjB2zpBPl2jeBMTQQl8iS52CRTZIkBfGFWKTFPvhFTF8N/
         Wh16vZf3ViGPgD21Z0hX5c+TJ1lKvtaVWhPXST+rcVrmoaeqcgq+FAx0Em1E6TxcioQV
         w3ieDiDpHbkstFIEnDyKHAZU/n2u9JJ0Jh6SwKYT2y1oz/SAvszKr5SpG7W/EOKMi4M5
         Rkw6HJTNfYuhb24Vz19qUvJ8DhygM7xq1B9GchmZePFI4MJqtyN4r8HGT9JN4AZaeuOs
         ejiJOVBbsPFHCqMG78OPN/FecMO3bHn70NqowfOXHTA2BAJvUF47tZKL2P3oZU24viT0
         juQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KZioIIcbbcqxpuu4wmoEytiac0TGQtoB//BlF7jteso=;
        b=ExvXJ2TWf4FIi6hyP9oWe4v9jxa+Srz9pIpXMCcij1Wlrow+t+1hS1S6IeVX7zH6LT
         ZZ9tTr8wALnXIsq2buD6JFkl5Q2rO1rIDgjVurPv0qLGR56AJX2ATqbhLU4x9/ChK74j
         wjn04QoDMKHvgw6umRDWvsb/5LqP160fKFsBHWRSkVkyWZLL/K5U3JlFbEiAsHYVTSyY
         psClK2qo8udOeetG7NEtZa+34aNroqbiUrZ45KS7yaa3PT54y+v8lxgAj7+KeV39b5ZF
         3zWJn7wG3enjHVM02Cl4fopjowfXfCVXXuTMGwRraKeHLMyqG8npvsWJkESOwoY4Tsom
         cngw==
X-Gm-Message-State: APjAAAVpqpLPEsa2sQOtZqD1CYojqyVQz/W7Qym15UoGeNO8I/UqNDq+
        vXWYX9Zx5RLOlcBRyLlj/ZI=
X-Google-Smtp-Source: APXvYqzXzPbLjct7u/ZLNkgXs+72wJJ8Bs81rt+C0XlM4C6c0OX1tXtZmoWLeZb7bRxHg9DETIQlxg==
X-Received: by 2002:a7b:c183:: with SMTP id y3mr11267942wmi.45.1579392828402;
        Sat, 18 Jan 2020 16:13:48 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id i8sm42177432wro.47.2020.01.18.16.13.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 18 Jan 2020 16:13:47 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <huobean@gmail.com>
Subject: [PATCH v3 0/8] Use UFS device indicated maximum LU number
Date:   Sun, 19 Jan 2020 01:13:19 +0100
Message-Id: <20200119001327.29155-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series of patches is to simplify UFS driver initialization flow
and add a new parameter max_lu_supported used to specify how many LUs 
supported by the UFS device.
This series of patches being tested on my two platforms, Qualcomm SOC 
based and Hisilicon SOC based platforms.

v1-v2:
    1. Split ufshcd_probe_hba() based on its called flow                                                                                                                                                   
    2. Delete two unnecessary functions
    3. Add a fixup patch
v2-v3:
    1. Combine patches 7/9 and 8/9 of v2 to patch 7/8 of v3
    2. Change patches 1/8 and 5/8 subject
    3. Change the name of two functions in patch 7/8

Bean Huo (8):
  scsi: ufs: Fix ufshcd_probe_hba() reture value in case
    ufshcd_scsi_add_wlus() fails
  scsi: ufs: Delete struct ufs_dev_desc
  scsi: ufs: Split ufshcd_probe_hba() based on its called flow
  scsi: ufs: move ufshcd_get_max_pwr_mode() to ufs_init_params()
  scsi: ufs: Inline two functions into their callers
  scsi: ufs: Delete is_init_prefetch from struct ufs_hba
  scsi: ufs: Add max_lu_supported in struct ufs_dev_info
  scsi: ufs: Use UFS device indicated maximum LU number

 drivers/scsi/ufs/ufs-mediatek.c |   7 +-
 drivers/scsi/ufs/ufs-qcom.c     |   6 +-
 drivers/scsi/ufs/ufs-sysfs.c    |   2 +-
 drivers/scsi/ufs/ufs.h          |  25 ++-
 drivers/scsi/ufs/ufs_quirks.h   |   9 +-
 drivers/scsi/ufs/ufshcd.c       | 276 +++++++++++++++++++-------------
 drivers/scsi/ufs/ufshcd.h       |   9 +-
 7 files changed, 196 insertions(+), 138 deletions(-)

-- 
2.17.1

