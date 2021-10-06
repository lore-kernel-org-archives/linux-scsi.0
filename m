Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA89EC433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B2451611C6
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Oct 2021 21:55:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbhJFV4z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Oct 2021 17:56:55 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:34566 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJFV4z (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Oct 2021 17:56:55 -0400
Received: by mail-pg1-f175.google.com with SMTP id 133so3722725pgb.1
        for <linux-scsi@vger.kernel.org>; Wed, 06 Oct 2021 14:55:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1VHX4F/LhjD0jCTdgMCcFCxMJkAZlgJ3yiCVI15BXH8=;
        b=ege5v9AWRp/g1b9YjYWrLgtJ3E8d4hvH4jUTMtqjV2mYmbVuJ2fRo0MddKqwfStf9Q
         NwtPBxWShSf3dIDDON9IEEwj5PrxsVzebRZBT95Rt+K/9eXYbwZKRWGfnn395LEmOGjg
         XLByMUDcU8rvVV0R66SQbUN3tBLGPYZ4bvvqG5Oqcoj1wzl3nVbtwD6J7x615Wx3Pbjm
         Zr6ICr53cTYKZFB1Ad6H6tot9lZ6R3kUJKkgWpDTfWrjODWySXVcKa+fzEtTFrl9Djry
         MiwThsk2Oiytv7jiyqPH74NOBRd9nOA5/88sRa+8g0JXGlm/MhSAsu+4aBDZGe1i3GFS
         kjXA==
X-Gm-Message-State: AOAM531mOOmx4kVaT7wKnzBcA6KN95ElDD4T0H5P5g4/ldvCSlKqDxYk
        Y60BeNR5wyN8ogeTSN4WNByxUmtT/9c=
X-Google-Smtp-Source: ABdhPJw8wIimKYC5rCYB/YUWf82LASa0EnTsRnSlbc/j6/+IF67qHCSLRq1OW8WG5fwgDmggcEx5MQ==
X-Received: by 2002:a63:490d:: with SMTP id w13mr349643pga.481.1633557302103;
        Wed, 06 Oct 2021 14:55:02 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:7a81:1c54:a610:d139])
        by smtp.gmail.com with ESMTPSA id x7sm5902586pjl.55.2021.10.06.14.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 14:55:01 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Rework SCSI runtime power management support
Date:   Wed,  6 Oct 2021 14:54:50 -0700
Message-Id: <20211006215453.3318929-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.33.0.800.g4c38ced690-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

For the UFS driver it is undesired that the SCSI power management core
activates runtime suspended devices during system resume. This patch
series leaves SCSI devices runtime suspended during system resume if
these were runtime suspended before the system was suspended. Please
consider this patch series for Linux kernel v5.16.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: pm: Rely on the device driver core for async power management
  scsi: sd: Rename sd_resume() into sd_resume_system()
  scsi: pm: Only runtime resume if necessary

 drivers/scsi/hosts.c      |   1 +
 drivers/scsi/scsi.c       |   8 ---
 drivers/scsi/scsi_pm.c    | 105 +++++---------------------------------
 drivers/scsi/scsi_priv.h  |   4 +-
 drivers/scsi/scsi_scan.c  |  17 ++++++
 drivers/scsi/scsi_sysfs.c |   1 +
 drivers/scsi/sd.c         |  18 +++++--
 7 files changed, 46 insertions(+), 108 deletions(-)

