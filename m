Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65333C77B72
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Apr 2023 23:07:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbjDQXHF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 17 Apr 2023 19:07:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjDQXHD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Apr 2023 19:07:03 -0400
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 059FB1BDB
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:03 -0700 (PDT)
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-51b514a8424so963273a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 17 Apr 2023 16:07:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681772822; x=1684364822;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vA4e18aquMybyEkWsxVok/UY7EJJQDgUnTje9R3MTrg=;
        b=hHHGd3U9OuLXbNYKG4jCTRky+yWRWTfYzSbKAcnT1r88NdZv7kZHRSYGt4oWEo2kxT
         Ewrljtfe/iDKtHqAHdvbDFpPjZe9JYoga4iPOyBfKuSSTH/k1XdhhZCTa7GVI6BWLgha
         smFHJcrNXVrYWjh11YeNw+FAYM6BDsH0/Zha/DxpVToPeJ/k3/fhf1Ro0J9NhKpM965Q
         2TXZaC+E1cwfiaEL7enpzJl2WkeAID0tnGSHiJtnhoqwavHNxMD+Zim4I+Wb4QySx4oP
         m778H+n540ldCHHDBFXdaOF884ht9JUKB2exxOgSFRXDKTBObVYXQtGLp8+LTi32yXnt
         omnw==
X-Gm-Message-State: AAQBX9cdRs31nPr1Cs99NB6rbQ3Ke1twmCROUMRH+mo3fnBtGLGibO0G
        V6C3cniMPBCR1/t7ZW0a9VjRx7IF/p0=
X-Google-Smtp-Source: AKy350Zp5dsPPzIGTLI2Dba+Nj1l43MBnQGg5R9recUuJZ8X9fbrT0fHtO3hYRSPLSInkByb+XmJ/Q==
X-Received: by 2002:a17:90a:7e11:b0:246:9932:18a2 with SMTP id i17-20020a17090a7e1100b00246993218a2mr77578pjl.31.1681772822394;
        Mon, 17 Apr 2023 16:07:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:2cdd:e77:b589:1518])
        by smtp.gmail.com with ESMTPSA id t4-20020a17090ad14400b002478d21de2bsm2539576pjw.36.2023.04.17.16.07.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Apr 2023 16:07:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/4] SCSI core and UFS patches for kernel v6.4
Date:   Mon, 17 Apr 2023 16:06:52 -0700
Message-ID: <20230417230656.523826-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series includes a patch for making sd_shutdown() fail future I/O
and also two UFS patches.

Patch 3/3 of this series has been posted earlier. Compared to the previous
version of that patch, a Fixes: tag has been added.

Please consider this patch series for the next merge window. 

Thanks,

Bart.

Changes compared to v1:
- Slightly changed the description of patch "scsi: sd: Let sd_shutdown() fail
  future I/O".
- Included patch "scsi: ufs: Fix handling of lrbp->cmd"

Bart Van Assche (4):
  scsi: sd: Let sd_shutdown() fail future I/O
  scsi: ufs: Simplify ufshcd_wl_shutdown()
  scsi: ufs: Increase the START STOP UNIT timeout from one to ten
    seconds
  scsi: ufs: Fix handling of lrbp->cmd

 drivers/scsi/sd.c         | 11 ++++++++++-
 drivers/ufs/core/ufshcd.c | 20 +++-----------------
 2 files changed, 13 insertions(+), 18 deletions(-)

