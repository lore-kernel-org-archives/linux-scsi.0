Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31EA2C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D65AB61A19
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 19:29:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237858AbhCXT3W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 15:29:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237709AbhCXT26 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 15:28:58 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59C2FC061763;
        Wed, 24 Mar 2021 12:28:57 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id w18so29017053edc.0;
        Wed, 24 Mar 2021 12:28:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=RiIOfnbR+8TdBRnY/voQl1EAAAK8w4D0IQxep/6jsGs=;
        b=ScdEAcqxuSq7nI41Dv9tFiTSmzdds++uBitmM2TPs7L/MpeutinQjtBK+8bTL7Utos
         HiglRvXfYXyRe9xLIRT5L7Wm2JZ3GYPiMwqFOIL1FR53ijutkfkJQBR+iwWAstLohzK5
         oE88MP+3LNIBr/veHzHD6skCeWakH41yFRpqz5g7h/wpJCvSSU7D/NQhXupiD7C5mB6e
         GQBsXA+f/KE+Yz3MSHNCxGTL/tEZKOYeaJxY+C4sLCKs0GniUdpqlaemgzYM50o2mAex
         Tc56jE60+QcT1a6P4DCUC7ZgboQ8MRiVza5UkTVN6iUvTOoHXuolj2mKaY20t1hTX7Ed
         TE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=RiIOfnbR+8TdBRnY/voQl1EAAAK8w4D0IQxep/6jsGs=;
        b=F1pHLkDrtT2lR9D+nREQE+/7QgZJWoR4u5XnmeYWyTxprMAWTtRn4VJw05ccxEYJ69
         E5Pqs62su+IXgco9U6KGOzKaU9qPKxichqH5fo0tDUdQJnOtt7Ajq4IBEflE1GNciKhr
         dY2MqZMai61leZamZ3Uspt9DfMKNYp2HZOOUq+XtO+ka+QP4QBhwW/vs1tnrkx4dmNd0
         Q5WgUAbHy0IDY2ZlqyhroV0NIrslFn47MC+oAe/d6Zgec4sA4nnKVHIsAm31+VAggstr
         FG6aO4zodyuIoPTuC8KH39MXgMc4jNxE3pOitcrxnZ7r5zCdyUIqh/q+ZP7PY4rQPSsr
         MQaA==
X-Gm-Message-State: AOAM533khv2sXWKKleT/8e8Nq6Q6PLPTV58YdqD+o0aPF1e3ri0P5hGC
        5hGqsA/Y0yODjNMLrErsHDsHe1Rfyt0=
X-Google-Smtp-Source: ABdhPJzl5zbTH31BaXVSOxgeJhmON23M5iWLE+LwjNO15wo3pkV2zKpz6rpkVYCcAkQAx70dcdeVCg==
X-Received: by 2002:aa7:db0c:: with SMTP id t12mr5124012eds.34.1616614136096;
        Wed, 24 Mar 2021 12:28:56 -0700 (PDT)
Received: from localhost (ipbcc11466.dynamic.kabel-deutschland.de. [188.193.20.102])
        by smtp.gmail.com with ESMTPSA id h15sm1585497edb.74.2021.03.24.12.28.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Mar 2021 12:28:55 -0700 (PDT)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 0/6] scsi: target: tcmu: Allow data block size greater than PAGE_SIZE
Date:   Wed, 24 Mar 2021 20:28:36 +0100
Message-Id: <20210324192842.30446-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

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

