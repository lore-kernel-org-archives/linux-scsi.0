Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01BE9C47254
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:20:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3F8020721
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 14:20:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jWM2UWBb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728912AbgEDOUq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 10:20:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726922AbgEDOUq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 10:20:46 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC079C061A0E;
        Mon,  4 May 2020 07:20:45 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id x18so21182568wrq.2;
        Mon, 04 May 2020 07:20:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/m0J6IyUexLr1zelV4bVuf4hcHqGLiMQVhrPq4fGCY=;
        b=jWM2UWBblnsg9pQGaPg0wCqqysmx13BM4x7XoD9Y8wtKQ4qZS7KIPXxf3+dhI6Bb19
         J7TZTilkZzUOMeRcTv2+0zWpmuAuIXnEZtpLx+O+Jsk8HToibKXY3f+L2C9dE343iKAT
         OCAqVWtJpJCwfTOBFY4uhV9UtXhJBPAdsaCHTJwLCFF8JWe6RCiQpmo8F2QrxtCvLifX
         hZZvVtGwWaqZDF2LOQU6yn1viYW6k488stBWbIhtfaWMaJ5yFggVXklLZgJ8GkrUg0FS
         bzwXGmCd92tpi75OPaTNFUQ1ExlEgCC9agZy4enfpnYwTOg5N17z7SPi+RD28Z2JlHpH
         bPnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=K/m0J6IyUexLr1zelV4bVuf4hcHqGLiMQVhrPq4fGCY=;
        b=T7eqN/u66CocrGZNNRtjRqKorLsz6PAyUHiqb3sluwe4QFcj5NTGMikXfjW28fxMYk
         SD7Es22ziujTkonV49gLlpDPfylZ7AePKwrz1K6kLqnP5TRcDRv4BXLGeEaFP8NDatnP
         5Bdn7atvlLKmTfHjFU9/+0tSZ5+MYnmy9NF3PmKUj4U5y3mR3IcvsVRqleiZ84eNSME+
         1Yrosj8cT+v/OT1kKW4hY060mtPwxw7CY8tF6It3DXuT2BOIwku86sccRDJ/KydyrFk4
         6AQlF5LK+AIMwn5Vz4pFlK3XECF0Y9SifMfjxc9AlMR3amFnLZRKQXn1R47vi6MdAsi9
         1+QA==
X-Gm-Message-State: AGi0PuanxRj9M1fHSXhlJC1vSETk1u846WnSoZyq6hjtuornOi0KIjcd
        7n9Of5hp42QW6E9uplkPIUU=
X-Google-Smtp-Source: APiQypKORWfB64ClK3VTsK7FHrBYFJr/4QNBMMjnhyOISosGKqOmozxetUHNR2zett8grkKBjWBn1Q==
X-Received: by 2002:adf:f343:: with SMTP id e3mr18821264wrp.51.1588602044330;
        Mon, 04 May 2020 07:20:44 -0700 (PDT)
Received: from localhost.localdomain (ip5f5bfcc8.dynamic.kabel-deutschland.de. [95.91.252.200])
        by smtp.gmail.com with ESMTPSA id p7sm19196140wrf.31.2020.05.04.07.20.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 07:20:43 -0700 (PDT)
From:   huobean@gmail.com
X-Google-Original-From: beanhuo@micron.com
To:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        cang@codeaurora.org, rdunlap@infradead.org
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hch@infradead.org
Subject: [RESENT PATCH RFC v3 0/5] scsi: ufs: add UFS Host Performance Booster(HPB) support
Date:   Mon,  4 May 2020 16:20:27 +0200
Message-Id: <20200504142032.16619-1-beanhuo@micron.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Bean Huo <beanhuo@micron.com>

Re-sent this patchset since the reference link missed in the cover letter.

This patchset is an RFC to add UFS HPB support in the upstream Linux.
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

This series patch is still based on the [3] branch 5.8/scsi-queue

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

[1] https://github.com/OpenMPDK/HPBDriver
[2] https://www.spinics.net/lists/kernel/msg3449471.html
[3] https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
[4] https://marc.info/?l=linux-scsi&m=158706915110258&w=4

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

