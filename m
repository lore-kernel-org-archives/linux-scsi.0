Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17870C43334
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jun 2022 10:24:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230334AbiFWKYm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jun 2022 06:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiFWKYl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Jun 2022 06:24:41 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6BD3D1D5
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:24:39 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id o9so18614776edt.12
        for <linux-scsi@vger.kernel.org>; Thu, 23 Jun 2022 03:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfw/oqSRc7jJkqLT2O3j70flMW81hcxsf9QLGgg3TxE=;
        b=pdkI3dOIUymZXZMjipN7aeVaZnFtMIIrCNse0DVS6HmwM6HRRDwrHjgfUVy5QBR2Hx
         aVbQodWA5QdqfeM00s2hMSb9dpw6hFwgDZwqVp67QupLLSjbZakh7G9G+EwIOwLr/iWN
         kGFZL9VDLToNs3L6ihg7kbaGxbqaE9mfBB0Y2ooIiEAUYGBL4Lhr2zDrIEgA4XMpOu8X
         a5++cV48z//OdQas+BTWRWXvDjaPGNHN/9+FZHXHj88XRcNtOc+y+YvFuUvSy/0sP3eB
         2UIs4XMurbslDEi50lVcoY0HIKHJaQ3lka1hd+ZXSKvrXiA+Dy55mjjptQCnu/I9+jUx
         nf0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mfw/oqSRc7jJkqLT2O3j70flMW81hcxsf9QLGgg3TxE=;
        b=23rPywZi4exgdJ+ZGc2vGCp7bVbJYvhmu2LMTlLU03TLKJ5w7j+aScKICXD0ZM3eNq
         Xq6geoDntwvjtYcAo+STiHFJeLUr7wbRZp7/0wBRjt8jONP4Ya8sYChFufU7k1z3QqnJ
         RbTsD0o30av9KoCjPrawU7kD3LvNZwArnDVHA0tELvwBTNSFCUpQ1ujIMKuc8OtjYevF
         Kjc8l5VDJqurf88JWSgV6bpZKxcgzIn3NOT2H88NZt6UcXoAdc+ybr9YLLN1EVjcLPFi
         VrAuw9lOtzOr2JGSMI2dROq8nU0avq2fqeH685BqAtxNOPUuPL/GUNwjCU+kIKuKoXAK
         Xvxw==
X-Gm-Message-State: AJIora/mApbJ8YbA680EAAJrUPtnz9TC6xou6y8G6MAPeeXUEs8MEjx9
        BbL/qiOiVlMWpW5c9BTAqbjhcw==
X-Google-Smtp-Source: AGRyM1vggeoVW8pOdEHFp/0lhUzsmATuAVubgnVo8nujs0nLNyEmo8Rh64YhDbN/3RiIvugnkG6hSw==
X-Received: by 2002:a05:6402:354d:b0:435:93f9:fc0b with SMTP id f13-20020a056402354d00b0043593f9fc0bmr9889391edd.288.1655979878287;
        Thu, 23 Jun 2022 03:24:38 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-176-92.adslplus.ch. [188.155.176.92])
        by smtp.gmail.com with ESMTPSA id 15-20020a170906300f00b006f3ef214dd9sm10692128ejz.63.2022.06.23.03.24.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jun 2022 03:24:37 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org
Cc:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: [PATCH v4 0/3] scsi: ufs: minor cleanups
Date:   Thu, 23 Jun 2022 12:24:29 +0200
Message-Id: <20220623102432.108059-1-krzysztof.kozlowski@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

Changes since v3
================
1. Patch 3: make array static const, correct language in commit msg (Bart).
2. Add Rb tags.

Changes since v2
================
1. More whitespace cleanups.

Changes since v1
================
1. Drop patch 1 (needs further work).
2. Rebase on current linux-next (including Bart Van Assche's work).

v1: https://lore.kernel.org/all/20220408103027.311624-1-krzysztof.kozlowski@linaro.org/

Best regards,
Krzysztof

Krzysztof Kozlowski (3):
  scsi: core: fix white-spaces
  scsi: ufs: ufshcd-pltfrm: constify pointed data
  scsi: ufs: ufshcd: constify pointed data

 drivers/scsi/scsi_debug.c         |  2 +-
 drivers/scsi/scsi_priv.h          |  4 +--
 drivers/scsi/scsi_proc.c          | 14 ++++-----
 drivers/scsi/scsi_scan.c          | 10 +++----
 drivers/scsi/scsi_sysfs.c         |  4 +--
 drivers/scsi/scsi_transport_spi.c | 49 +++++++++++++++----------------
 drivers/scsi/scsicam.c            |  6 ++--
 drivers/scsi/sr.c                 |  8 ++---
 drivers/ufs/core/ufshcd-priv.h    |  6 ++--
 drivers/ufs/core/ufshcd.c         | 42 +++++++++++++-------------
 drivers/ufs/host/ufshcd-pltfrm.c  | 10 +++----
 drivers/ufs/host/ufshcd-pltfrm.h  |  4 +--
 include/linux/libata.h            |  6 ++--
 include/scsi/scsi_cmnd.h          |  2 +-
 include/scsi/scsi_device.h        | 10 +++----
 include/scsi/scsi_host.h          | 13 ++++----
 include/scsi/scsi_ioctl.h         |  2 +-
 include/scsi/scsi_transport.h     |  2 +-
 include/scsi/scsi_transport_spi.h |  2 +-
 include/scsi/scsicam.h            |  2 +-
 include/scsi/sg.h                 |  2 +-
 include/ufs/ufshcd.h              |  6 ++--
 22 files changed, 103 insertions(+), 103 deletions(-)

-- 
2.34.1

