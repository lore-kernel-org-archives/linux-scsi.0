Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC933C43334
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jul 2022 00:10:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbiGIAKc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 20:10:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229710AbiGIAKa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 20:10:30 -0400
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C6B17AB34;
        Fri,  8 Jul 2022 17:10:27 -0700 (PDT)
Received: by mail-pl1-x631.google.com with SMTP id y18so105751plb.2;
        Fri, 08 Jul 2022 17:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=Znnh5yc4eACm6GbvMKNRyMYBShbC5U9fFWv3XrkdJpA=;
        b=NQt4zr6/Vl+VeP3WhN2Za8K2BgSe9VezvRg0bNt4nvKOzscNgiAoX44NIycpeV5FCH
         k0ZprtiB5bIjVB07b0nsDLpsP/J3uJC3PwVh9xfwKtULlPiwFN0ZcFgasEmiZ37w9ztm
         vHoF0h8DUw8lVQx+pqwTW4btsE64A2kgk5Gi0Nc4Xh6WnbuwlKGNJFn+IQNwKZ2gt9wt
         tuo44BXe/yguDw8od3CQLRedVizQVi3lsDk72ckmCTB0Ps52UuhfiiwbSnSyLLUYsUbO
         SCE3Iv8ToIGhFFNru78aRTMP6K0FvX+D4goQy7PumGDb2JLI/4TPWp2ktKLIUvgjBLVc
         P7hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Znnh5yc4eACm6GbvMKNRyMYBShbC5U9fFWv3XrkdJpA=;
        b=7WNX0NBnLkrZH02qikjB4Qjz23iT5WyK0KO6ax1fvEyCcX1XskaYrg0poH5VEQJUiI
         sW0B8DaEu2DucddXo6TRmOEGgxvTmrzhOQdnADHtd6+D3SHTnXehJCsr942xk3jfqL0h
         p3vkKD/X0nsYV1rrNXGPlN2ib/2aeWddm03TVL8gT7CbRo96IKzgR7eisxiz+bVz+7KN
         6zq8ByxhZf0+VVCO7TcufZP4IMrFPwW8czJmMVRHwCAygR0kHoMSzItBEwh6qEWqQn0h
         YqmzQPCGNnu4TkKCWglT5UkOoOB+6FLguawHDTpW0hcWc1eJ6U6twkRmyQadX81KUsBH
         vbLw==
X-Gm-Message-State: AJIora97flIKITO5TMi+S7m+3S8eXgqkkQoUOOxrYvBdtjB1JsmKXEno
        FXt4pkpMrApGYRXhvp+GE5sDf3ciH1s=
X-Google-Smtp-Source: AGRyM1ulmKuOy2iOcGYgz7mHLp1YssxuXaqBkKoZZPmuz0xIPd42wTbdK2qRvqIGVVoHhEmqTM67jA==
X-Received: by 2002:a17:903:228b:b0:16b:edb1:a609 with SMTP id b11-20020a170903228b00b0016bedb1a609mr5976840plh.77.1657325425750;
        Fri, 08 Jul 2022 17:10:25 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (222-155-0-244-adsl.sparkbb.co.nz. [222.155.0.244])
        by smtp.gmail.com with ESMTPSA id t123-20020a625f81000000b0052842527052sm146393pfb.189.2022.07.08.17.10.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 Jul 2022 17:10:25 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id 690D7360325; Sat,  9 Jul 2022 12:10:21 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     linux-m68k@vger.kernel.org, arnd@kernel.org
Cc:     linux-scsi@vger.kernel.org, geert@linux-m68k.org
Subject: [PATCH v1 0/4] Convert m68k MVME147 WD33C93 SCSI driver to DMA API
Date:   Sat,  9 Jul 2022 12:10:15 +1200
Message-Id: <20220709001019.11149-1-schmitzmic@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This series was precipitated by Arnd removing CONFIG_VIRT_TO_BUS. The
m68k WD33C93 still used virt_to_bus to convert virtual addresses to
physical addresses suitable for the DMA engines (note m68k does not
have an IOMMU and uses a direct mapping for DMA addresses). 

Arnd suggested to use dma_map_single() to set up dma mappings instead
of open-coding much the same in every driver dma_setup() function. An
earlier patch series has converted the three Amiga WD33C93 drivers,
this series now takes care of the sole remaining m68k WD33C93 driver.

The m68k VME mvme147 driver has no DMA addressing or alignment
restrictions and can be converted in the same way as the Amiga a3000
one in my previous series, but requires conversion to a platform
device driver first.

Only compile tested so far, and hardware testing might be hard to do.
I'd appreciate someone giving this a thorough review.

The first two patches shoukd be taken through Geert's tree before the other
two can be applied by the SCSI maintainers. Please advise should you prefer
this to be split into two separate series.

Cheers,

   Michael


