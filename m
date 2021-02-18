Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67D4EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15DD464EB4
	for <linux-scsi@archiver.kernel.org>; Thu, 18 Feb 2021 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbhBRTOI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Feb 2021 14:14:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230442AbhBRRvk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Feb 2021 12:51:40 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACAFBC0613D6;
        Thu, 18 Feb 2021 09:50:57 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id l12so5468115edt.3;
        Thu, 18 Feb 2021 09:50:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=ivQkfVgsx4WZGsQoMHh5wg3U5BQ3QtJ3+c6FaZcc3oY=;
        b=QfoAJYjm7aYDJ/g4vcV2mJ14et0jiBhEZ/4xGS4mIuVyw0hSM37YTMSM2E9NQ66/GI
         MoiBmtfqSVX+aBD0/EoCYHPmjX4TiXZiS+XNaj5jtf1mgCyOVLaHx1tp3Lsumo6ZwJbw
         La/8rSd0V2P//IL+C9xozR2fdMDLm4agP+Gs9jrzNKf3oZkkwi0+izGf/3IxdU6GYYAO
         VqBOOPB0BotabYfLHMEexHq3hA/F8+5bVnl2mfFzfp3XS5TU7r2/WjGx4HA/H3rE9kxU
         1DHuVxYWOfOYBecjFnqUIoXfO5qimxzF+yp4RPVI+jOnRxMoivnEhY4mcxIyp1MuhwD3
         g+Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ivQkfVgsx4WZGsQoMHh5wg3U5BQ3QtJ3+c6FaZcc3oY=;
        b=IDIBrGaSD3U+u4B4ij6p+TnpK82KXrhEJ7HljL1rHvX80I9etd9CWL7reE0gyoRMwa
         7X8gYmVEMHfTVVcxG5Eu1Vlz2eU2CmT5uL55C1LCh4f0WXh1BIV9EY6hKZkRpAJE2Isx
         SwsVHRunWdbqIOolorAyXQff91OnqU71i5zKvfb3DQ2oZkCAkxvR834sLGKfwr2sVXvR
         pJBs/pLcuPh6eZ37eQzpJVscGqfvGbMakHwnItI9wkTxl/0iWbcZU1h4EHKr3kn0fWJ4
         YmVbHOQ+DHwWpesc3MhTls9vd3q0s0qB0DRbOvSTLcCYICNF10YRp2aGGYb5UBmRhxC7
         urnQ==
X-Gm-Message-State: AOAM5322RY0a4ZEerfdKMfX5Kb3aXhUzIi6a7gJ6JN+kiQ3QX9vTpxoI
        G8W4E6+DlmteQfkS36ijKlL0p+Lpyfc=
X-Google-Smtp-Source: ABdhPJzLWCaqXJ8haxRabVrDPE4iIpRxR0FRcRbAG0M/L04sBm3bfUyRqzb++QJllW2S97/F0G0AMQ==
X-Received: by 2002:a05:6402:2694:: with SMTP id w20mr5316533edd.200.1613670656488;
        Thu, 18 Feb 2021 09:50:56 -0800 (PST)
Received: from localhost (ipbcc06d06.dynamic.kabel-deutschland.de. [188.192.109.6])
        by smtp.gmail.com with ESMTPSA id k13sm2933118ejc.23.2021.02.18.09.50.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 18 Feb 2021 09:50:56 -0800 (PST)
From:   Bodo Stroesser <bostroesser@gmail.com>
To:     linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 0/2] scsi: target: tcmu: Fix memory leak
Date:   Thu, 18 Feb 2021 18:50:37 +0100
Message-Id: <20210218175039.7829-1-bostroesser@gmail.com>
X-Mailer: git-send-email 2.12.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This small series applies to Martin's for-next.

This is the third attempt to fix a severe memory leak in tcmu.
Previous patches:
  https://lore.kernel.org/linux-scsi/20201218141534.9918-1-bostroesser@gmail.com/
  and
  https://lore.kernel.org/linux-scsi/20210210194031.7422-1-bostroesser@gmail.com/

Tcmu's refcounting relies on tcmu_open and tcmu_release being
called symmetrically by uio. But that is not true if userspace
daemon holds the uio device open or mmap'ed while tcmu calls
uio_unregister device. So refcount can stay above 0 for ever,
which means that tcmu does not free resources of a tcmu device.
In extreme cases the amount of memory leaked can be > 1 GB for
a single destroyed tcmu device.

This new patch series fixes the problem by moving refcounting from
tcmu_open/tcmu_release to new vm_operations_struct::open/*::close
handlers, which are called under all conditions.

Bodo Stroesser (2):
  scsi: target: tcmu: Move some functions without code change
  scsi: target: tcmu: Fix memory leak caused by wrong uio usage

 drivers/target/target_core_user.c | 189 +++++++++++++++++++++-----------------
 1 file changed, 106 insertions(+), 83 deletions(-)

-- 
2.12.3

