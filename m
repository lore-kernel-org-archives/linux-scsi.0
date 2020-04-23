Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12138C54FD0
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DCBE620736
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 07:23:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NzHffN96"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726254AbgDWHXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 03:23:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725562AbgDWHXp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 03:23:45 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01130C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:45 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id 188so5247777wmc.2
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 00:23:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=DyYca2JKsEwk62uzP3wkNMhI1zOC/JE0y8i4FRmxdvY=;
        b=NzHffN96BpvUMAglOnq262gd3iC5Nzw/v5sLIj2TANBirc3+Wp6IqdhPGOJw/m/sFh
         hV53bOdIizUbu7NgoyoooiEbqXQO+7rqVOspFpS//G5fGff/inHeqMrsfb4s2cScUTuM
         I6k5itm4Sy3iLlSN3YcCeVbPiZG4Ngv+/958M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=DyYca2JKsEwk62uzP3wkNMhI1zOC/JE0y8i4FRmxdvY=;
        b=T15Z9F/3KibmnhQn8kJ0n3BloFaLRQ+tKg1GnJCKWJkSC+nFjMPYfy6OPL6olZLxkJ
         sCxq9kLwKfe95l0qWcG/jtuO2Xokwc6xwpZD5LHBi1R8R7z6QyvLY2slj7C0a5RBNds8
         CEqBfjrLOeKrmVwr5gGOu0pGfTfFKXIo7c/tToOCwI1TL+KPuhvivvPlUqteX2mx6bXk
         /vq300hc3KBqf0oEohQqtkDcuynZxvCS5Y+RcfxVM2mnpCMna7leoJcE7jaUEmmseGFj
         KlpOfJVbBHb5sNxgvgnTAXOJwGlPd2HHLvGpNSYT/8b716aslSeS86R7kly9cml7O1Tr
         J3wA==
X-Gm-Message-State: AGi0PubmQxyJzonD/6FcgIV+NJyCD85aj8gOybrEmnY80fv7p312Ydus
        rXkgQUNDS0+bbirrPFAqHFKsXRrH86cx1psh9zClkBlZrJ8cQ7Ql5JBY9MrQjN9iyMGfAcEWDIP
        3W0hBEP+BkO2E8zv89HmfMLKfn2UOcXuWMzKAQTWmJoI3wafZKRFUKj66ZA+DpZ6uebVjudb6ut
        k1PaITnspqmf+hEDRNK5EX
X-Google-Smtp-Source: APiQypKnzqIZczZas4KF9+0uduN5PzeeLqpK555ukZ9V35laLtmhb93LNfF32IH10YpawUcAhEz/Gg==
X-Received: by 2002:a7b:c390:: with SMTP id s16mr2512035wmj.14.1587626623222;
        Thu, 23 Apr 2020 00:23:43 -0700 (PDT)
Received: from dhcp-10-123-20-36.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id l4sm2336130wrw.25.2020.04.23.00.23.40
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 23 Apr 2020 00:23:42 -0700 (PDT)
From:   Suganath Prabu <suganath-prabu.subramani@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     hch@infradead.org, Sathya.Prakash@broadcom.com,
        sreekanth.reddy@broadcom.com,
        Suganath Prabu <suganath-prabu.subramani@broadcom.com>
Subject: [v2 0/5] mpt3sas: Fix changing coherent mask after allocation
Date:   Thu, 23 Apr 2020 03:23:11 -0400
Message-Id: <1587626596-1044-1-git-send-email-suganath-prabu.subramani@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

* Set the coherent dma mask to 64 bit and then allocate RDPQ pools,
make sure that each of the RDPQ pools satisfies the 4gb boundary
restriction. if any of the RDPQ pool doesn't satisfies this
restriction then deallocate the pools and reallocate them after
changing the coherent dma mask to 32 bit.
* With this there is no need to change DMA coherent
mask when there are outstanding allocations in mpt3sas.
* Code-Refactoring

Suganath Prabu (5):
  mpt3sas: don't change the dma coherent mask after allocations
  mpt3sas: Rename function name is_MSB_are_same
  mpt3sas: Separate out RDPQ allocation to new function.
  mpt3sas: Handle RDPQ DMA allocation in same 4G region
  mpt3sas: Update mpt3sas version to 33.101.00.00

 drivers/scsi/mpt3sas/mpt3sas_base.c | 256 +++++++++++++++++++++---------------
 drivers/scsi/mpt3sas/mpt3sas_base.h |   9 +-
 2 files changed, 154 insertions(+), 111 deletions(-)

-- 
1.8.3.1

Thanks,
Suganath
