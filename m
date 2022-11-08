Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E1B3C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Nov 2022 23:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiKHXdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Nov 2022 18:33:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229770AbiKHXdt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2022 18:33:49 -0500
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BC6C120A7
        for <linux-scsi@vger.kernel.org>; Tue,  8 Nov 2022 15:33:48 -0800 (PST)
Received: by mail-pl1-f178.google.com with SMTP id v17so15556091plo.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2022 15:33:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZNYYiNNnIbkNVD1y7d8HIqHldYcgiJSSL7JPkIJEtQ=;
        b=HeXIj+fC2XE9orAwHnGSb99O/1uDgq8myMDnln+nK7Ko31oQzYviijzSg97B6VDCKS
         rdkShZvXj0/UTANlgSw4tFWAgG1K+YoWr2+imEkmO6c9VGyv+4aNeP8wGZa3gg0p/srZ
         YtFRPuqKeg+mQNbmPERQOQxw0iNfQ/12LmlpTamxv9KcX5Mk1Acb0rHmDuZK3euP6HNx
         ITaTVbjyipjhWj5uisdhiW04qYqUORTjTtgLlHmwipndryJJC+5FPn6r8OxGEv5C0rl/
         ElUsZCRer0+NbsU6OWVIxraG72KYkUXvORYWFjv0nI6B4vDeZps7aTjDzc5hVKw3QsXh
         MYWg==
X-Gm-Message-State: ACrzQf3IlVE1Kjgpom50Z5NnBcfOSu8EKSHox7Xyr5o+8xuHhCbZahj2
        sLXT1h6bHiM2RXEPW0td8Ps=
X-Google-Smtp-Source: AMsMyM6ZseTp2xAsXgEzVRng479RzNrI23IO92/beZd5A4UuAfWQcUyQy1EAK3zufvdfGnd0+le2sw==
X-Received: by 2002:a17:902:d48b:b0:188:50af:ea11 with SMTP id c11-20020a170902d48b00b0018850afea11mr32237455plg.69.1667950427711;
        Tue, 08 Nov 2022 15:33:47 -0800 (PST)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:44ad:aec5:7cab:4532])
        by smtp.gmail.com with ESMTPSA id q10-20020aa7982a000000b005618189b0ffsm6918088pfl.104.2022.11.08.15.33.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 15:33:46 -0800 (PST)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Adrian Hunter <adrian.hunter@intel.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/5] Prepare for upstreaming Pixel 6 and 7 UFS support
Date:   Tue,  8 Nov 2022 15:33:34 -0800
Message-Id: <20221108233339.412808-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.38.1.431.g37b22c650d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The UFS controller in the Google Pixel 6 and 7 phones requires that SCSI
command processing is suspended while reprogramming encryption keys. The
patches in this series are a first step towards integrating support in the
upstream kernel for the UFS controller in the Pixel 6 and 7. Please consider
these patches for the next merge window.

Note: instructions for downloading the Pixel kernel source code are available
at https://source.android.com/setup/build/building-kernels.

Thanks,

Bart.

Changes compared to v2:
- Addressed more review comments from Avri.

Changes compared to v1:
- Addressed Avri's review comments.
- Added patch "Allow UFS host drivers to override the sg entry size".

Bart Van Assche (4):
  scsi: ufs: Reduce the clock scaling latency
  scsi: ufs: Move a clock scaling check
  scsi: ufs: Pass the clock scaling timeout as an argument
  scsi: ufs: Add suspend/resume SCSI command processing support

Eric Biggers (1):
  scsi: ufs: Allow UFS host drivers to override the sg entry size

 drivers/ufs/core/ufshcd.c | 89 +++++++++++++++++++++++++++------------
 drivers/ufs/host/Kconfig  | 10 +++++
 include/ufs/ufshcd.h      | 35 +++++++++++++++
 include/ufs/ufshci.h      |  9 +++-
 4 files changed, 114 insertions(+), 29 deletions(-)

