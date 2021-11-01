Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1547DC433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC91960F3A
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Nov 2021 23:28:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229970AbhKAXbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Nov 2021 19:31:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhKAXbX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Nov 2021 19:31:23 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F486C061714
        for <linux-scsi@vger.kernel.org>; Mon,  1 Nov 2021 16:28:49 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id t62-20020a625f41000000b004807e0ed462so4330251pfb.22
        for <linux-scsi@vger.kernel.org>; Mon, 01 Nov 2021 16:28:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=Pi4D0mpaGaQtq9G2tBR3kHrhqZDI6br/iLV4uZVh0U4=;
        b=dOsBedNaDc5D1ZirVjgfGWmSSIx8/lK655WPh8dZxvSpK/xi5gX/WRl6Aktou7bBoJ
         J5JMXobH9uDALgoo1S/TExwJXaTxXPTZkEaPUeTUGKJwcpgBpELsJgRrPPA6j6i+nnxO
         5r6Fezb8dDGZIboN4vyP5o5fbVSGcsTQ2aEnN54+JHOmFJ/A7CfdSXiiBTf7DXn97tmO
         Ix446Oz4gHCrF/UdEg/+eoE937PLpJJri+xEeWhkgakJQYSyrGfBoT29HinhjjE5lv9M
         riPNgcGFybBOO0ugeUHMJFLPHgXYoMcTdAkszOZAvndA77lTzx9HuTPIEKa71rekiqYy
         rx7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=Pi4D0mpaGaQtq9G2tBR3kHrhqZDI6br/iLV4uZVh0U4=;
        b=e3skRlnFh34qupDNNOVkwwT1LxjlOefCf2bN2sznop7DBRcXrNpBL81CLEOAd1XQ8l
         stoUPGC3a32vLQIL6AVE7nfHzanULj0NkJ7Qc3dOupriPsz0aohSNcHTLVerWsFUjBl3
         rbh1rtKaZ4BhxBvMzvdH1p6sZ8YMyU562EelP+jxah2OWAqjgSVGmK84u2/CFvqh9mjE
         /+xdKJZzYYFTlnHmxCeHCEAc/OeLpX6YC5om9rOwheQVy7t/MnXZwCa+wTho9gUMBZ/k
         GliSJbuBsvY+s8otU9go3MyXV8SXTcJ1WyMN4pqYV9Qiv5VsAIzk+F/bzy+J6HZ3UzuR
         dyaQ==
X-Gm-Message-State: AOAM531Fkaaa0K7yvt1m0yp1s477UhMRsXDFt199+gEBbaZWyRwiCGQN
        uEQRfnBNdgvUs07OYl0lRC+YMpO+cGfwuw==
X-Google-Smtp-Source: ABdhPJwtw5r4ebVNWoB65N8jwNalnTdFcNBr90unt7EfQ77TMw+O4+LE8CbJc8IpnP35hJhvfkse+wcZ26PeSg==
X-Received: from ipylypiv.svl.corp.google.com ([2620:15c:2c5:11:3684:4dd2:e6b6:ef66])
 (user=ipylypiv job=sendgmr) by 2002:a17:902:d202:b0:13a:709b:dfb0 with SMTP
 id t2-20020a170902d20200b0013a709bdfb0mr28042255ply.34.1635809328835; Mon, 01
 Nov 2021 16:28:48 -0700 (PDT)
Date:   Mon,  1 Nov 2021 16:28:21 -0700
Message-Id: <20211101232825.2350233-1-ipylypiv@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.1.1089.g2158813163f-goog
Subject: [PATCH 0/4] small pm80xx cleanups and fixes
From:   Igor Pylypiv <ipylypiv@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Vishakha Channapattan <vishakhavc@google.com>,
        Changyuan Lyu <changyuanl@google.com>,
        linux-scsi@vger.kernel.org, Igor Pylypiv <ipylypiv@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Igor Pylypiv (4):
  scsi: pm80xx: Apply byte mask for phy id in mpi_phy_start_resp()
  scsi: pm80xx: Do not check the address-of value for NULL
  scsi: pm80xx: Update WARN_ON check in pm8001_mpi_build_cmd()
  scsi: pm80xx: Use bitmap_zalloc() for tags bitmap allocation

 drivers/scsi/pm8001/pm8001_hwi.c  | 28 +++++++---------------------
 drivers/scsi/pm8001/pm8001_init.c |  4 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c  | 31 +++++++++----------------------
 3 files changed, 18 insertions(+), 45 deletions(-)

-- 
2.33.1.1089.g2158813163f-goog

