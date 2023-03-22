Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38573C6FD1F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Mar 2023 08:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjCVI5n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Mar 2023 04:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbjCVI5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Mar 2023 04:57:36 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C9055D47D
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 01:57:31 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id fy10-20020a17090b020a00b0023b4bcf0727so18491818pjb.0
        for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2023 01:57:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=areca-com-tw.20210112.gappssmtp.com; s=20210112; t=1679475451;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=2Juje1TVQx9Ir6TCrjjYr/9fB6NcAn5fIZLLXlfSDEo=;
        b=oNQzP0dukP/A7MuNRdlbB7Kqk3Z1UH2gZqPOxBqV5zwD0alq000MNUTJ2tu/wlqNAb
         /sl+veH6npPUS+889YV+ZzJIAHNtu//H1xFA7WsX8Pj66Sf0Lhd+7zQujOzIBNlZGO/M
         4C4ipK5jHh1F6Qjpv8rH+WH3d/JhawU3CI9bAkWA1q8Px1JpVt+YhxX1Nzh5A9RqckL1
         +LU4E0gjJzmVyLG9S/mTHX6SOFNSjPPupOSmwMrgKe52dZB2hpADmN/wUtjjYy/JOK7A
         aHEMnxgU55bTIM2EzXWAbZKbUuAWeVceYKDVGm5D0VB80h6+HYyrqntlA1pSywrLIkes
         3KjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679475451;
        h=content-transfer-encoding:mime-version:date:to:from:subject
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2Juje1TVQx9Ir6TCrjjYr/9fB6NcAn5fIZLLXlfSDEo=;
        b=1AXvyw8aVCqnCSEUqS2qpJSMMYId54fT/FxRkqeLmMg1tDqGnTnFMvEr77CUmvjHbo
         hvkGVto8L7S0oSh09zN9mr7hTeEp8hj5cV1u/sykt95qZ7k7phjjUXMCVVwyotfCl/43
         b6dnjGCLhuorGPkOVT5LWBV3fVdK5M2JRc3RyI2+OwWBRvNIXNn+bR/0ab/S2OBIBshP
         7LNWT1TGFR0znm45F2R/BOJq0hdV8L0IghBoKnhTaPCeIzY0OnWc+EU9JDImVa3JInZE
         xxUrmumpaHYf0LY1vYqVjf3WBchppPf7MEKxSXpFsnFFZGQEax0jfmTK4DY9UIBgac4H
         BVMw==
X-Gm-Message-State: AO0yUKUDunQS6EYFyc0uz6FyNEQe0LdUvPYtE1ZZR0zso/ZlCOOUwpe5
        bE1uPtIZD2K6SaR8f1wLQpOWBw==
X-Google-Smtp-Source: AK7set8dI/0YZUWwik1LXJ9k+RGWdA5H1O9HkHJA/yPcJ9IgPwsEWVg+Ga1cCZ90yAwECJuOKN1oqw==
X-Received: by 2002:a17:903:430f:b0:19e:ecaf:c4b4 with SMTP id jz15-20020a170903430f00b0019eecafc4b4mr1970578plb.4.1679475451445;
        Wed, 22 Mar 2023 01:57:31 -0700 (PDT)
Received: from centos78 (60-248-88-209.hinet-ip.hinet.net. [60.248.88.209])
        by smtp.googlemail.com with ESMTPSA id g5-20020a170902c38500b0019cbec6c17bsm10080147plg.190.2023.03.22.01.57.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 22 Mar 2023 01:57:31 -0700 (PDT)
Message-ID: <6f3eb04dbe89d2b9f239600dd2c575227f3c0afc.camel@areca.com.tw>
Subject: [PATCH 0/5] scsi: arcmsr: fix reading buffer empty length error
From:   ching Huang <ching2048@areca.com.tw>
To:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 23 Mar 2023 00:57:29 +0800
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-10.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patched were made over mkp's 6.4/scsi-staging

This series comtain some fixes.
- deprecated arcmsr_pci_unmap_dma()
- fixed ADAPTER_TYPE_B 64bits dma compatibility issue
- fixed reading buffer empty length error
- added driver proc_name
- updated driver's version to v1.50.00.13-20230206
---

