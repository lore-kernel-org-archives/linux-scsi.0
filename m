Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41DA5C18E5A
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:29:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 14FEE22525
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 11:29:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d0lRn6AB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729058AbgCKL3l (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 07:29:41 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:41400 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbgCKL3k (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 07:29:40 -0400
Received: by mail-wr1-f66.google.com with SMTP id s14so2110298wrt.8;
        Wed, 11 Mar 2020 04:29:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=F/1IjY74pBxnbZAUC/tSx+RiXpp/LVmOLwLIf85D7FY=;
        b=d0lRn6ABE5qWra0CLlK2bhJ/dlNno9C070G9gKL/LsIXVl0vow/djfBBj5+/fDJNuW
         HTLqJMr5dlBP9j4eZJvLfi+yQ6O257cWRfx2+O7EvG/C85kKtA/38VDPwWdXKciT6AW6
         nFUWBzmX1pUvInpxQ3IcOGzuK1w5FGznEnIQoc1ir4VdhACggCqn1sOMw0HC96a4GjXZ
         ND/z8JjYThiFyGrMdSeDpljZQQIw8zWLvX9KIy3natqYmdBtz7HoHruqB+QPmsywytwU
         +LHR1rZ30tyqwA1PPNWNp+6/AoIjkBAe2+RfdnIdY4FWbT0uv7gqz+4YIXjpbZEG/8TW
         8nSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=F/1IjY74pBxnbZAUC/tSx+RiXpp/LVmOLwLIf85D7FY=;
        b=GDwYLGcHaNmMKd32wZgLnfvms8WZ2wSy9hcc9ZBk9NrvsfSE281VYrpw78+G4QXTiA
         FjRbPzRXh3iMrvuPTquR5rLgnmCSRjTU6boRbFG2vnN3YwFKyw98LpDlpNFnTPqJMD3t
         rsBz3gch+70wGAP71nXEzrFqgDQ+sjG1JNXBUHR2hp3PZltwqJ0Omf6Y8oNQHFLd/X4u
         sRuOpFr8Cvg8KiNLvIYgKLvNLAfAfgaoHwDnXkPkdHaCUY51Ow1wCM2g+KxkRu+VB4sY
         rvZuZfKN80S6MucA7OwucpBGKQZPKoDDQdjH4WJ+Rqiy+n1FHMrr8GC5s2Ma7E50Q32o
         scoQ==
X-Gm-Message-State: ANhLgQ3hVjLryL3OF7bOpwKytogLWzqLKI2nVvTO3njBqQ9NmhZdccti
        gOOsE5LkZwR8th5Q2EasUpY=
X-Google-Smtp-Source: ADFU+vu94/0g3Ai+2NOGtniTLjXfMqe4XX0B950G1NhcTNpERstbQBnS7eidIwjhblo7ehgQWM7WUw==
X-Received: by 2002:adf:c40e:: with SMTP id v14mr3992518wrf.408.1583926176989;
        Wed, 11 Mar 2020 04:29:36 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bee49.dynamic.kabel-deutschland.de. [95.91.238.73])
        by smtp.gmail.com with ESMTPSA id l64sm8190735wmf.30.2020.03.11.04.29.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Mar 2020 04:29:36 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"
Date:   Wed, 11 Mar 2020 12:29:20 +0100
Message-Id: <20200311112921.29031-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Hi, Martin

Based on Bart's feedack, the less risky way is to revert commit:

34656dda81ac "scsi: ufs: Let the SCSI core allocate per-command UFS data"

Bean Huo (1):
  Revert "scsi: ufs: Let the SCSI core allocate per-command UFS data"

 drivers/scsi/ufs/ufshcd.c | 198 ++++++++++++++------------------------
 drivers/scsi/ufs/ufshcd.h |   5 +
 2 files changed, 75 insertions(+), 128 deletions(-)

-- 
2.17.1

