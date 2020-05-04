Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9A2CC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86CFD2075A
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:05:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hoa6/WOf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgEDOFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:05:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726404AbgEDOFp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:05:45 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E5F8C061A0E;
        Mon,  4 May 2020 07:05:45 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id e16so15977667wra.7;
        Mon, 04 May 2020 07:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qv9VZ/vdkXWlYpTQ4wVqr8Dh+vZPTpn4XvM2OS4ssaw=;
        b=Hoa6/WOfkdDmyXdxlJ6VnSmQIZTCxAx2D21cB8txWwICPVReJBlsJ3lgtmoA9nm4zY
         ZskXgZ7c2HoY4RfG6+IjDAZiNebS3ZW9E72QBOa4x6D/5f5hFg2ZDJE3n/uSfaPloefU
         OERZgDsrNR8snr8/hfv++M1h/JhopQ+/p6/zJkbpzqWzuGTsxkuS3NhXT1CDizUvPn49
         OnKUedJQOrnEfQc6/v3di8HppEHm9yGIZnCvOTjd2ugpLCpZ+GJ/SymOt0rhSjtd+NsJ
         fphfn1lkOjXIN/0lK19K1Q2eUsJLsbJao3qpz9U2Uz4KBnnB14AAY4j80alCv9WntHQw
         gNhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Qv9VZ/vdkXWlYpTQ4wVqr8Dh+vZPTpn4XvM2OS4ssaw=;
        b=M3eukG+D5QzWfYrfKBjCsxq7QR9g9D/Nlym/jYYt7B/MkqZf2wBipNxG9VlF5h+g2y
         lYdcAkPzdBc6YKJbsr7bSPQP2z3cOrt3C0/RqWjrRVz3P6rgLNzG+lTVHRwC5HXAle0S
         +0f60KAaIrRpUYuu8p5oL3rGDVNNy3VZdcpTw3h3ElHeSRz4zhOQA4OER+yn/SYq7IY6
         T7pOY/+5y0tiwTJG060CFkEGRTlIA3SjSYLmAQeG7zRfHFmRf/VdAnpgrdQbBKezolQw
         M6/Lh3vN45R37Luf8Elx8BSefmikMFpTa5xW0lPUSWPWX9MvJIdFimiRZYuIRengFian
         OZ8w==
X-Gm-Message-State: AGi0PuYD0f8iph5m/B5odO/ikvh1QjcUJLOq/BGptBmUOybmxd/nQnO4
        ymu8KcuDCTV+AgjMxh50jPo=
X-Google-Smtp-Source: APiQypIrE3NnD0YRvvKblCx0u2Ymj1FHj8pfr2ipwJZtxrHBHyWALEnVLhlrQeMzaUzw9OjvZq7pyw==
X-Received: by 2002:a5d:4d0b:: with SMTP id z11mr9116427wrt.81.1588601144263;
        Mon, 04 May 2020 07:05:44 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id h137sm273832wme.0.2020.05.04.07.05.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:05:43 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [PATCH RFC v3 0/5] scsi: ufs: add UFS Host Performance Booster(HPB) support
Date:   Mon,  4 May 2020 16:05:26 +0200
Message-Id: <20200504140531.16260-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

This patchset is just an RFC to add UFS HPB support in the upstream Linux.
Before this series, I have submitted two versions [2] and [4] of UFS
HPB driver in the community. The first two series HPB driver patchsets
follow the Samsung HPB driver[1] approach, in which the HPB driver submits
its HPB READ BUFFER  and HPB WRITE BUFFER requests to the SCSI
device->request_queueu to execute. Since this fly submission is unacceptable,
in this RFC version, I changed it, and now the HPB requests will be directly
submitted to UFS device, don't go backwards to SCSI mid-layer. In this
approach, the L2P mapping entries loading path will be shorter, and the
latency is smaller.

Regarding the UFS HPB feature, which is defined in Jedec Standard Universal
Flash (UFS) Host Performance Booster (HPB) Extension Version 1.0, its purpose
is to improve read performance by utilizing the host side memory. For the more
detail information about HPB, you can refer to the HPB Spec. If the approach
in this RFC patchset is accepted and feasible, it is necessary to add a
document to detail HPB feature and its implementation later.

Based on the Avri's comments in the second patchset, to be reviewable patches,
I shortened HPB driver, deleted HPB host control mode. Also, for change tracing,
this patch is RFC v3, including the first two patchsets changes.

This series patch is still based on the [4] branch 5.8/scsi-queue

v2--v3
    1. delete GET_BYTE_* and SHIFT_BYTE_* macro definition , using
       get_unaligned_*()/put_unaligned_*() instead. (Bart Van Assche)
    2. change Kconfig help message (Randy Dunlap)
    3. delete HPB host control mode code
    4. change the way of submission of HPB request, and let the HPB
       driver directly submit HPB request to UFS.

v1--v2:
    1. Rebased the patch on the [3] branch 5.8/scsi-queue
    2. Optimized and simplified several functions
    3. Add parameter read_threshold in HPB sysfs, by which the user can change
       read_threshold for the HPB host control mode
    4. Add HPB memory limitation, let the user adjust its size according to the
       system memory capacity


Bean Huo (5):
  scsi; ufs: add device descriptor for Host Performance Booster
  scsi: ufs: make ufshcd_read_unit_desc_param() non-static func
  scsi: ufs: add ufs_features parameter in structure ufs_dev_info
  scsi: ufs: add unit and geometry parameters for HPB
  scsi: ufs: UFS Host Performance Booster(HPB) driver

 drivers/scsi/ufs/Kconfig  |   62 +
 drivers/scsi/ufs/Makefile |    1 +
 drivers/scsi/ufs/ufs.h    |   15 +
 drivers/scsi/ufs/ufshcd.c |  245 +++-
 drivers/scsi/ufs/ufshcd.h |   28 +-
 drivers/scsi/ufs/ufshpb.c | 2767 +++++++++++++++++++++++++++++++++++++
 drivers/scsi/ufs/ufshpb.h |  423 ++++++
 7 files changed, 3534 insertions(+), 7 deletions(-)
 create mode 100644 drivers/scsi/ufs/ufshpb.c
 create mode 100644 drivers/scsi/ufs/ufshpb.h

-- 
2.17.1

