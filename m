Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF799ECAAD4
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Aug 2022 21:05:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbiH3VFX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Aug 2022 17:05:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231416AbiH3VFU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Aug 2022 17:05:20 -0400
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E2333A24
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 14:05:17 -0700 (PDT)
Received: by mail-pj1-f51.google.com with SMTP id o4so12290144pjp.4
        for <linux-scsi@vger.kernel.org>; Tue, 30 Aug 2022 14:05:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc;
        bh=j+UoGBVSciY5IIT/IcVBFMr3cDV2DFid6PiosTmhrOI=;
        b=1Q6EbFla54JqNI1G/FWc5EYbh1bABC/FAEiGGxH3NI1C+55GdOWOhxj2faMAgKdMEc
         S9JEGdQAb9ojaVYVbtIqw3PerMzdX1sywbTEW1BHbyhimhgilAXOmmDhkBacetzAYtnK
         d5F/DWTj8+acrfoxMq4o+iyWOxL78OwrQYys/V1AApx87Yn01mtvA0Dt491Wv1mdhLWl
         sSiet51QFwiGEp6A74QQJq3Wk/9liX0EudT32wq6/LV2KdXRdZS9TZ1nDvam7IP6s54F
         qluPG4Ot6G3wTaMdQQ6eWErDIonIYpzw9wxvYuZ6XvD6lld7zEhE9jJANFi2dkyu1K6/
         CiDw==
X-Gm-Message-State: ACgBeo34glYWBevs8vtzCX8CEqMaIKmC2WATFirFQKqKSYCVUsSJXZ8P
        OkKXB8OLoeEx80gOFeWXfb8=
X-Google-Smtp-Source: AA6agR7tDPUNHZm5oiDObY0zqgBe1zpiRnc+Z6XVRKhaW9hOfxHON7Rq3mZjemGadmNcOf/URQ7Q8Q==
X-Received: by 2002:a17:902:ec8a:b0:172:f018:4b46 with SMTP id x10-20020a170902ec8a00b00172f0184b46mr22594678plg.12.1661893516746;
        Tue, 30 Aug 2022 14:05:16 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([12.219.165.6])
        by smtp.gmail.com with ESMTPSA id z5-20020a170903018500b00174da27b8e3sm4612841plg.8.2022.08.30.14.05.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Aug 2022 14:05:16 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/2] Prepare for constifying SCSI host templates
Date:   Tue, 30 Aug 2022 14:05:07 -0700
Message-Id: <20220830210509.1919493-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.37.2.672.g94769d06f0-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series prepares for constifying SCSI host templates by moving the
members that are not constant out of the SCSI host template. Please consider
this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1: fix the CONFIG_SCSI_PROC_FS=n build.

Bart Van Assche (2):
  scsi: esas2r: Introduce scsi_template_proc_dir()
  scsi: core: Introduce a new list for SCSI proc directory entries

 drivers/scsi/esas2r/esas2r_main.c |  18 +++--
 drivers/scsi/scsi_proc.c          | 106 ++++++++++++++++++++++++++----
 include/scsi/scsi_host.h          |  18 ++---
 3 files changed, 110 insertions(+), 32 deletions(-)

