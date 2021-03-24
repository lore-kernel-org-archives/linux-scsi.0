Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8AB1FC433E8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:58:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7261D619E8
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:58:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238070AbhCXT6Y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238002AbhCXT6P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:58:15 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C152AC061763;
        Wed, 24 Mar 2021 12:58:14 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id l4so34901119ejc.10;
        Wed, 24 Mar 2021 12:58:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=9V6SsDhhMXhdXrid4mMv9PJC6LihGTvVs22SJXBywjc=;
        b=pwSAfWK9zt5gUlbxQYrOGM7QLiBn92jqEOvRwYsv05Z0yOCOr/yrCUXlDKBkAKE7C+
         x6AxeNGrNfH1OGbRbIjkZV0SgL2+FXsLA7gU4ZKBmwyRF1Owk12vpITzSV19yFCfGOt2
         hkNitfjgAP8bKe2aRXc04BqDIaJPnA10GzmcOPcedRHavy8jqvixDiRQozATHOSg4Vfx
         dnzbYO4H6Rey9+D/I7kgiaVV62DHcxnQMNDo41Kt25g23Cipbq+ZABFF2VRNmThymg4H
         njDmrnv5H/rPZh1Dx2Zz7U/KWwId/U9YrdkGpTnlP0bkmW9LfoUszeV5ImErFXSjhIEP
         BHUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=9V6SsDhhMXhdXrid4mMv9PJC6LihGTvVs22SJXBywjc=;
        b=DVGL/LkUpUkjkYyxMdGSr9um+gx07LVYtQbeMt66ZdloJ3CkYQURVauJAozwSBBDs2
         UAoWqu5FQPSwceM7uSGqAdQn70QjjXH5EAVnCKDknYoGEvb3+QvVB3gZ8RVFTOgc6ykx
         pgRLHnOGgGe9fBfrAZYTXlmkJaLAi4itXQTmWBTK86GtKbZiIe7RkZZfnasYt+DRsDux
         BAi0mjZNfT3tDY4K0z2aGfp4Me3NSZzd2qoVPAv4rgVpmxrt/svmeBoQ+1SBOxLRcIar
         4cTM21tXnETi8FSeIGNissEkiyPRpYhrzPQGATzrVb94QA4dpvEou3iKXk6dnLHw5ytm
         9usA==
X-Gm-Message-State: AOAM532+MMINIpTfyd3bIXAqOCdM4DFwK03gI67/zr/6mkJbenKsFRVv
        dQGgApwNETaNcYfPR3nbc2Gv9885fNo=
X-Google-Smtp-Source: ABdhPJzqZPKgBhXAI3wsIP1EgJ9kxyMr9mqTUiKd3mH+06xwgEcShlLXZFut+Q+BD2nKcyWaj4LX/g==
X-Received: by 2002:a17:906:684b:: with SMTP id a11mr5377902ejs.329.1616615893557;
        Wed, 24 Mar 2021 12:58:13 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id r13sm1623440edy.3.2021.03.24.12.58.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:58:13 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH v2 0/6] scsi: target: tcmu: Allow data block size greater than PAGE_SIZE
Date:   Wed, 24 Mar 2021 20:57:52 +0100
Message-Id: <20210324195758.2021-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm resending this series as v2, because the previous patches
partly contained my old email address. So please silently ignore
them.
Sorry for the noise.

V2:
   Changed From and Singed-off-by to contain proper
   email address bostroesser ... gmail

-----

This series is made on top of Martin's for-next branch.

The data area tcmu uses for data transfer to and from userspace
currently is assigned in data blocks of fixed size PAGE_SIZE.
For big data areas this means, that a big bitmap needs to be
searched for free data blocks. It also means, that the data
buffer for a single scsi cmd can consist of pages which are not
consecutive from userspace point of view.
In that case, userspace receives a long list of IO vecs in the
cmd ring, each vec pointing to another part of the cmd's buffer.

The following patches allow to configure data block size as a
multiple of PAGE_SIZE. For compatibility reasons the default
is 1 * PAGE_SIZE.

Memory allocation for the data area is still done in single
pages. So we do not depend on availability of bigger memory
chunks. Since memory is allocated only once and then re-used
for many commands, it does not cause performance issues.

Advantages of big data blocks:
 - bitmap for data block reservation smaller, search of free
   blocks faster and less blocks needed (less searches)
 - Fewer IO vecs in cmd ring
 - If data block size is enhanced to max data tranfer size,
   userspace always receives consecutive data buffers with
   one IO vec only.

Disadvantage:
 - If data block size is big compared to mean size of data
   transfers, memory allocation can be higher compared to
   data block size = PAGE_SIZE.

Remark:
If this patch set is accepted, I probably have to prepare
a change for rtslib-fb to support new UDEV/config param
data_pages_per_blk (UDEV/info: DataPagesPerBlk)

Bodo Stroesser (6):
  scsi: target: tcmu: Adjust names of variables and definitions
  scsi: target: tcmu: Prepare for PAGE_SIZE != DATA_BLOCK_SIZE
  scsi: target: tcmu: Support DATA_BLOCK_SIZE = N * PAGE_SIZE
  scsi: target: tcmu: Remove function tcmu_get_block_page
  scsi: target: tcmu: Replace block size definitions with new udev
    members
  scsi: target: tcmu: Make data_pages_per_blk changeable via configFS

 drivers/target/target_core_user.c | 383 +++++++++++++++++++++++---------------
 1 file changed, 234 insertions(+), 149 deletions(-)

-- 
2.12.3

