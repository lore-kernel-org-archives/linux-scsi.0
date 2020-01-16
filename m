Return-Path: <SRS0=K2E6=3F=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A4C3C33CAF
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 21:59:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4D43C20728
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Jan 2020 21:59:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Og3iD9d+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388582AbgAPV7e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Jan 2020 16:59:34 -0500
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42659 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729380AbgAPV7e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Jan 2020 16:59:34 -0500
Received: by mail-wr1-f65.google.com with SMTP id q6so20630465wro.9;
        Thu, 16 Jan 2020 13:59:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=t83N3+9WJqUvuIBAC7zFFsBQFwJFpSx4DUQ61Zxbb/Y=;
        b=Og3iD9d+pnKWaSzeQZ/qk/DMnlyCLuT9irX9znmG9X1bn7IzzPRvRnNjOy22ygSJty
         5brqnyYtklz5XRuZw9O6zrFBdbjlaLgzqcP33kTGjIDGADl8tiPd1wiHLyq/aqaasnmp
         yzCyOnf9EmApUVK3NIrfKguNj3GIdxVb0Jj4jxlUm7FYij6M6XoxJSiJZ9j17pdm3CMD
         MFo6ectD3e3gc+IfYfUAKh8wb4BivutGEiYNrgbm4531uMwAILq6RXgROZzuvMRqTdy3
         LYI0mT2iFPx7e5g1rEheJeekUu1sIU5dlpUAbw3LLVKDBO/8LhbhCX8WKuGcNdhj+rX7
         Hv5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=t83N3+9WJqUvuIBAC7zFFsBQFwJFpSx4DUQ61Zxbb/Y=;
        b=mt9Ztpx91Hz4IdO8VMM/v0J+s+xvQyt9TtO+prcw3iVzt4snzUDH0beoD+2yXi4CbY
         cxtXIWuTW41+Uctv0jZvC4HnPu15vU4NHNGcRwrSaPfzuEVwrKeYXnjn+KWgXJoLXr8m
         LU8r5CAo0hJ/eZi7WsD2Iv7wdlZsC9KzTH0oWwzTdZsp39K0lga0o57/vjr8zR0tKCBG
         eUg4hkTRCEmcPhsM92cDvU2VJEyP9vNYlRxDqxRWDRLQiTXEeHqoWZ4QGDWg31nKRYzz
         0QDtcSw1Shv1TcAWLZADHQDBFmQoPduwSmf1z36hw6IQKizgrRj9OjOzJVFBOuJOFduZ
         I62A==
X-Gm-Message-State: APjAAAVv/okErlJuqBeVrE4Wmj69a0B8hSx9a8lBZp80lFZ++IoVyNmQ
        jl9IEcCwiIgmJeH1NJ24UYU=
X-Google-Smtp-Source: APXvYqxz68Xmtig5svF9YDXSouqQLFnlrLN65cxiMQ6A+0uM4PExZM4eR9hs167eIgx0Ms0OxTEynQ==
X-Received: by 2002:adf:e6d2:: with SMTP id y18mr5633294wrm.262.1579211972414;
        Thu, 16 Jan 2020 13:59:32 -0800 (PST)
Received: from localhost.localdomain (ip5f5bee3c.dynamic.kabel-deutschland.de. [95.91.238.60])
        by smtp.gmail.com with ESMTPSA id a14sm32418131wrx.81.2020.01.16.13.59.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jan 2020 13:59:31 -0800 (PST)
From:   Bean Huo <huobean@gmail.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <huobean@gmail.com>
Subject: [PATCH v2 0/9] Use UFS device indicated maximum LU number
Date:   Thu, 16 Jan 2020 22:59:05 +0100
Message-Id: <20200116215914.16015-1-huobean@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series of patches is to simplify UFS driver initialization flow
and add a new parameter max_lu_supported used to specify how many LUs
supported by the UFS device.

v1-v2:
    1. Split ufshcd_probe_hba() based on its called flow
    2. Delete two unnecessary functions
    3. Add a fixup patch

Bean Huo (9):
  scsi: ufs: goto with returned value while failed to add WL
  scsi: ufs: Delete struct ufs_dev_desc
  scsi: ufs: Split ufshcd_probe_hba() based on its called flow
  scsi: ufs: Move ufshcd_get_max_pwr_mode() to ufs_init_params()
  scsi: ufs: Delete two unnecessary functions
  scsi: ufs: Delete is_init_prefetch from struct ufs_hba
  scsi: ufs: Add max_lu_supported in struct ufs_dev_info
  scsi: ufs: Initialize max_lu_supported
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

