Return-Path: <SRS0=held=4Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68700C3F2C6
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 14:57:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 366672084E
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Mar 2020 14:57:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VGUfKdUi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726332AbgCHO5B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Mar 2020 10:57:01 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41496 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726289AbgCHO5B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Mar 2020 10:57:01 -0400
Received: by mail-wr1-f66.google.com with SMTP id v4so7908795wrs.8;
        Sun, 08 Mar 2020 07:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=+EPeOxBuzoV58k9L0dhngcCQgLP0uv9482M8AONuPXU=;
        b=VGUfKdUinIcCH6/A0PnoOHKwOkFsC3gS17OnGQaEaHD46N3K2QbrN3R2u2tmK4wORg
         UJ3CyWL3RYR718RAmhtZtY84TpyBDONy31ND75iqrxQndIkc5rpwx2yl0CEfZAXcsywq
         Q4g9FhCkWerHtF5fgx6zXlHkBHJkG2GqcxeP/VfGm36YQCHwgJPVnip3W4Z1nT4UJbBX
         LxaL9fo2eH6xBLIbGhjtXS4bZIfTHGR7VL87pzCznGCmYvhqWs9dLpYxkr/TDBKfqSKG
         cwmv9aIWjLgZb2Fq6RZmgkvG/DRUFLiRzvJFJ8LLNQALk0fL/nuRS7KN1cIvKxnkBv7M
         Ur+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=+EPeOxBuzoV58k9L0dhngcCQgLP0uv9482M8AONuPXU=;
        b=o3tJH4MBjc4tQ/WNt8Ka1+RDUicRaIH6dKX/LSwP5bVDI1GEs38Yn6Hu2uQYjbQMPd
         LGcWlt39ki+EOPwdAKuidnEZgVHOMpmv64jvVmfpl6AoCqOZE9MrlldCMdI+IMHDhOzT
         NbUz4DpM7cS4y+VcaXG/FueWIQF2YM7p9t5zJJ0KsR+evuMfQkf4930G5k1xl3kh6Y0e
         sbW7/jZGQ9nEfUkIvw5jjZGEs8dodf1rKTH1s0NtHb/N5/RKTtvjOx067taRBf38d3Wg
         5pY7lC1YA4xEooVNqzFRQVPW2uCH2ZRn1R0OclScXGzb+wP/eugxjXaZIRh4lyShMvGE
         MGHg==
X-Gm-Message-State: ANhLgQ00kbOyd/D9hiHKVoAlMRkuvG1wQM5tKMh010On+RzAUVC+OJqZ
        eboyGDjBDt6K/l0wzVid5kI=
X-Google-Smtp-Source: ADFU+vsCvUJPsH+IwIxpsNF+YP246pFWI16C7KhrIitV3n531rJPfp6kW/DGioYkjVxd4RRquoIITQ==
X-Received: by 2002:adf:fe84:: with SMTP id l4mr15531895wrr.1.1583679418976;
        Sun, 08 Mar 2020 07:56:58 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id 61sm7383232wrd.58.2020.03.08.07.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 08 Mar 2020 07:56:58 -0700 (PDT)
From:   Bean Huo <huobean@gmail.com>
X-Google-Original-From: Bean Huo <beanhuo@micron.com>
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC PATCH v2 0/1] scsi: ufs: fix lrbp pointer incorrect initialization issue
Date:   Sun,  8 Mar 2020 15:56:47 +0100
Message-Id: <20200308145648.28675-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, Martin and Bart

This is the patch for fixing the issue introduced by the patch

[PATCH v2 4/4] ufs: Let the SCSI core allocate per-command UFS data.

Bean Huo (1):
  scsi: ufs: fix lrbp pointer incorrect initialization issue

 drivers/scsi/ufs/ufshcd.c | 4 ++++
 1 file changed, 4 insertions(+)

-- 
2.17.1

