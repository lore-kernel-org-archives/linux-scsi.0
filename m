Return-Path: <SRS0=2LRe=DO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A18CC4727E
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:20:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F2BD6207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Oct 2020 07:20:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="tLsGziNK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727671AbgJGHUR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Oct 2020 03:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbgJGHUQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Oct 2020 03:20:16 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94F2EC061755
        for <linux-scsi@vger.kernel.org>; Wed,  7 Oct 2020 00:20:16 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id b19so562652pld.0
        for <linux-scsi@vger.kernel.org>; Wed, 07 Oct 2020 00:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=AKIEEcKeE8/9i9HUsSzlMQgzbQ/bmUdgtBYl5wmpO0Q=;
        b=tLsGziNKPTqjyqaZhoPQxWKDGkRg42i7n+a7StQGVjqHPk/18+jFYQcN+JtvcUdbjg
         FdhRn0cyZrF0iXzbvUZmtSxc0o6QPL0BiUpt1/Frl3880Qs3MEtWXXFqGZKtQnwqFqdA
         U4hLtU5vhQupIsWWl6bh3i3VUMDzvs5Na9UmCREAXxAI4gH157cnhFtJDhJDDyoKh46n
         WJfICHSuMPvP+4HDvUIQEbot1X0Pw+XR6atyNBnCiJYuuNilrzk02NXt22ojv/9KllSq
         XjMfeq36Myv4E6og/vUgow2v2D53qDyu3Ue9QLYx6DHmACoisCj50x9RhFZMfXMiAoGJ
         vltA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=AKIEEcKeE8/9i9HUsSzlMQgzbQ/bmUdgtBYl5wmpO0Q=;
        b=sTyZYIgvYCKTyGKn5btrihfBJBViAbYgTCy433Y4+0XnXe6KcbGB5mAAelRTZ7gVP+
         WwTxMuBg5+mWYYCHUypooAs0cT3ggPeS172DeOwuLYmP5flZJievK1xAIeZpmkh5VLyk
         ywNVctmj2rtH8ZgZ9HzmUy2lcwKEAHZfH9MWmhYWq8RSBHftoJccew/KnoqUP9rwuvCO
         tGlDY5OYk9HAHz0bb3QXm8n55kL0ejugJg+nINfDGMzH0povfsXY4EuNmJaxi7RwpgbV
         L+lmyGwoZE8VYUWKA+DDF60Ki7/xKsr708FUTg+2r70jG/FP9sQp3f7lHcvJL2Ym6hJH
         bjcg==
X-Gm-Message-State: AOAM530Naf7K8JHex8QhdGR52QSuAMJ2bn0sot5nw0SCwtrEX+PJsPGC
        RoA5w5XU7+c/Q7jKZJwLUv3HrA==
X-Google-Smtp-Source: ABdhPJxRe1m0UNaavWieph1r3PU8iks0BQhqTlr68cM2slQKW2iaOusuqgrYJDTQeR1a+o7C+fGl1g==
X-Received: by 2002:a17:90a:e697:: with SMTP id s23mr1683200pjy.16.1602055216182;
        Wed, 07 Oct 2020 00:20:16 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id o1sm1662676pgi.41.2020.10.07.00.20.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 07 Oct 2020 00:20:15 -0700 (PDT)
Message-ID: <9846b9ef4f8dcdac543270c3268d1ebb31aad6a7.camel@areca.com.tw>
Subject: [PATCH v3 0/2] scsi: arcmsr: use upper_32_bits() instead of
 dma_addr_hi32()
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Wed, 07 Oct 2020 15:20:14 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.10/scsi-staging.

1. Use upper_32_bits() instead of dma_addr_hi32().
2. Use round_up() instead of logical operation.
---


