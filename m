Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D5D3C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7238560EB9
	for <linux-scsi@archiver.kernel.org>; Thu, 22 Jul 2021 22:17:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbhGVVg5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 22 Jul 2021 17:36:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232024AbhGVVg4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 22 Jul 2021 17:36:56 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D8D9C061575
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:31 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id j8-20020a17090aeb08b0290173bac8b9c9so6277654pjz.3
        for <linux-scsi@vger.kernel.org>; Thu, 22 Jul 2021 15:17:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnCbvb88j7pbjQqr0WLXN5U2oaO7BKVFe8Xaj6f+Mms=;
        b=E/28hCmUiPHYTgMhdNvbKaS6hRUbAJgh0hYF5OqjSQzXIid5iIBC35CEtdC3T8sHZ5
         i8n6Hd+G12XrvN2gDvMGD/Ih/GC/X8qBS/AhQUotEGe7QYTuL8DyX24um7hR/3VkqsXG
         NeJBpOXbaZanlFuPlri2pd7eORsglXOtnZFcSlnsNJrirTBa1c1ArT3QOaYH1MEVuhAi
         CqypbwjaniT7liErGpf8vsdkjyC5XjQgz4x5RWKDStq23W9m7GZXZhkjUhsEYp+OLkWK
         v6s4J1TG2K+b1SkqAbD/RXJZax7G5zuD8+YAeEfniA8lsRl0EYpD0G8ihpWKkYBbT5ym
         FDUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EnCbvb88j7pbjQqr0WLXN5U2oaO7BKVFe8Xaj6f+Mms=;
        b=q59pIdlVZGnsBepKmBN2JtQXfzC7yWXRZvUuXG9w/aJILvdegaBeAxmyhWqcM57laQ
         WPqmEHBQGsxdlF+LORWJSvI1P7NXohMHFIJp2YZXXugnlgx/YRALBThJf2etqSqPS2dN
         voGbGBP2EoSpkqxC0Y2uoH4dr/TtRam8NDcucLShYzKj5maF77TJJZ+9of7JS4PyV+CT
         JldDvrfER/KqfkAh3DKNDzKQHjgn9Vhk6Q0zmZmg4PRhiwQYe3s24zFlKJ63bqVlctRg
         MwT+1eTM7qMgYwVwKTzEnjWb0bja1v+R0yytXzZwEMhtn7a/sNi8vKbI44FHHu7HSAno
         SV+Q==
X-Gm-Message-State: AOAM5301kZyy8l5W+2QfG4grZWMTjrucR0sO6q48v+5xNWlOms+CLqvV
        eEGejfXjv5FLd4d2bUtw8xqrPrwNmV0=
X-Google-Smtp-Source: ABdhPJzRH4zd0vUVi1WSR8ARQSaTY2U/ojOD1NU6hdGyK5hPPJnkUXwxHdnZTjz5tB0SkgWu8e4DAQ==
X-Received: by 2002:a63:1e59:: with SMTP id p25mr2017735pgm.110.1626992250566;
        Thu, 22 Jul 2021 15:17:30 -0700 (PDT)
Received: from localhost.localdomain ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a18sm31374460pfi.6.2021.07.22.15.17.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Jul 2021 15:17:30 -0700 (PDT)
From:   James Smart <jsmart2021@gmail.com>
To:     linux-scsi@vger.kernel.org
Cc:     James Smart <jsmart2021@gmail.com>
Subject: [PATCH 0/6] lpfc: Update lpfc to revision 14.0.0.0
Date:   Thu, 22 Jul 2021 15:17:15 -0700
Message-Id: <20210722221721.74388-1-jsmart2021@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Update lpfc to revision 14.0.0.0

This patch set adds support for the new G7+ ASIC found on the LPe37xxx
and LPe38xxx adapter models.

The set:
- Adds support for the new PCI ID's
- Corrects a bug found due to higher resource counts
- Rather than patching in new PCI ID's to capability checks, refactor
  to pick up the ASIC Family values which automatically picks up the
  new chip.
- Add in 256 Link support, which can now be seen on trunk links

The patches were cut against Martin's 5.15/scsi-staging tree


James Smart (6):
  lpfc: Add pci id support for LPe37000/LPe38000 series adapters
  lpfc: Fix cq_id truncation in rq create
  lpfc: Revise Topology and RAS support checks for new adapters
  lpfc: Add 256Gb link speed support
  lpfc: Update lpfc version to 14.0.0.0
  lpfc: Copyright updates for 14.0.0.0 patches

 drivers/scsi/lpfc/lpfc_attr.c    | 17 +++++++++----
 drivers/scsi/lpfc/lpfc_ct.c      |  5 ++++
 drivers/scsi/lpfc/lpfc_els.c     |  8 ++++++
 drivers/scsi/lpfc/lpfc_hbadisc.c |  1 +
 drivers/scsi/lpfc/lpfc_hw.h      |  3 ++-
 drivers/scsi/lpfc/lpfc_hw4.h     |  6 ++++-
 drivers/scsi/lpfc/lpfc_ids.h     |  4 ++-
 drivers/scsi/lpfc/lpfc_init.c    | 42 +++++++++++++++++++++-----------
 drivers/scsi/lpfc/lpfc_mbox.c    |  5 ++--
 drivers/scsi/lpfc/lpfc_scsi.c    |  8 ++----
 drivers/scsi/lpfc/lpfc_scsi.h    |  6 ++++-
 drivers/scsi/lpfc/lpfc_version.h |  2 +-
 12 files changed, 75 insertions(+), 32 deletions(-)

-- 
2.26.2

