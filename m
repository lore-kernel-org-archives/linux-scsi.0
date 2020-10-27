Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EBD44C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:28:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D662151B
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 03:28:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=areca-com-tw.20150623.gappssmtp.com header.i=@areca-com-tw.20150623.gappssmtp.com header.b="kBHF5TaM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504978AbgJ0D2C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Oct 2020 23:28:02 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:34259 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2504976AbgJ0D2B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Oct 2020 23:28:01 -0400
Received: by mail-pj1-f68.google.com with SMTP id b6so125104pju.1
        for <linux-scsi@vger.kernel.org>; Mon, 26 Oct 2020 20:28:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=UgL1OqbLLKBOpo+035gGI2ga82oCmxIxfGnnI3yWATc=;
        b=kBHF5TaMzia6Q1KvnOxxpV13u4ohfEngYW+WyvyWcjbM0gUeKOYJsbPoquhOSC+l/F
         2XAdb+GpFLH5TWOGDnQOaX6A8NMo9V08ieqI0hd3cGPSxpGnAcu9y92X4y1XLXw2Yp91
         Gut3S1dFJu0tNAbC1B5g/8selVIxjiJSH30Hk14JHYzp4PVKoWpfLnBuEwLV3r3AmEwJ
         TvEqFXMUEAMFQgaUfCQy/1nuVhVsR+cDK1+rL3Eg20jMjNUzDavLDnbQ9fgJ8vEiOhZ4
         Byd900RpRO81nkgrwuI+WLBM3Vay4SQNPQN70q9v1LoizUbM+Y5tiurVVopYBQXGY8a0
         +SuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:mime-version
         :content-transfer-encoding;
        bh=UgL1OqbLLKBOpo+035gGI2ga82oCmxIxfGnnI3yWATc=;
        b=JpSsSVV6L+s+SvJmenIJfmNWfgEZSoegTUB0OQR0GTK6Cpi8akaKHQ6AXNBSuaAZFD
         I8CZ7pAc11qSfP9KAVHnq7lihNWfrczEoG1TiS77MOtJQCAKV308Hs7Bwp+Uc2O3lAsA
         LtI4x7gTGQLkVOEr7l0STR9iuLRewmwCd0GH0hXowMs1xBOQSi6IGqGVU0P5INyLw/0a
         vuzyqZuJx622SbXNzCMnsjuq4bIW8IyhCH9lRYTaeV2oO70rjiqgdJK8aDxq4ItbW9Mp
         VMh5nhwPAjy+aHtvRNqPCQnxbn1mcNqZd2v6327Fy43zg7FEnrO8N3O3eR9MAWrpN3NY
         gJLA==
X-Gm-Message-State: AOAM531JMy+EcP1E7JvorGLBcsZ43mkyYpyoBNHpgO4sj3X1KsrS03b8
        aqlfnKTuGXffytk9L6JCFSkVLg==
X-Google-Smtp-Source: ABdhPJz50Vq6kPm31HR2dL70/9FiLagBDMcNydandHW/TTeNonwMePgnt5thZNu6PfUrOSzwKMAYEw==
X-Received: by 2002:a17:902:7c8c:b029:d4:e5b2:fba4 with SMTP id y12-20020a1709027c8cb02900d4e5b2fba4mr432402pll.82.1603769281168;
        Mon, 26 Oct 2020 20:28:01 -0700 (PDT)
Received: from centos78 (60-248-88-209.HINET-IP.hinet.net. [60.248.88.209])
        by smtp.gmail.com with ESMTPSA id n7sm41005pgk.70.2020.10.26.20.27.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 26 Oct 2020 20:28:00 -0700 (PDT)
Message-ID: <53bbf27e75420ae1de09899c40b42e4c2d5edda6.camel@areca.com.tw>
Subject: [PATCH v2 0/2] scsi: arcmsr: configure the default SCSI device
 command timeout value
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date:   Tue, 27 Oct 2020 11:27:59 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-8.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch is against to mkp's 5.10/scsi-fixes.

1. Configure the default SCSI device command timeout value.
2. Confirm get free ccb in spin_lock circle.
---


