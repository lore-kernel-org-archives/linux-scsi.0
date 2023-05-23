Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DE7FC7EE23
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 21:39:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238617AbjEWVjY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 17:39:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238325AbjEWVjX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 17:39:23 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50D00119
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:39:22 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 3f1490d57ef6-ba9d8b01f82so457671276.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684877961; x=1687469961;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DYoP+7y3H6KxflmECkTj0wmu7P4fg+DdkxFWOe2r+Gw=;
        b=k422eVrA6fDyydzitMAUgA2r/qnrQx3xF/tcqF59GxVqCShRzRg+N7Wq9rm5NbQfWW
         z5e4qyiz3RDva2Adh70L+JCtIsFJYG8aickJkoE550FSPN29CkPxC5rPZyfxZSyS1E2F
         UK/7GXhsUVEOGD13zSi5LxupV6swxC/PTX/cqV+07xqwkczw/291xohgRVSL+A4+oH3v
         ien9Ol3VSQjSSLXfXe/RPaLDPNwIIBUXaTZQkjfWJArf6QeTyxwlPcB0T3wMG9spdZjQ
         fJL4oADoF5YbWWX2Fe+mm+vB282fG6Kmr/bGIYTDl9mlt/SgcdV7AXH5t0dXoBmmCZA7
         /2OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684877961; x=1687469961;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYoP+7y3H6KxflmECkTj0wmu7P4fg+DdkxFWOe2r+Gw=;
        b=leAtD034uuoUNg92917gDBStWUIu+OEno8BguGlxmVKinvNnTSUt1nLwhHDD3ROfA4
         ibWX0uTGDolWDkSotH99+qg74O85ew2OyepLtx7el6Kq+7w2NFi1uN+Vn2edlK9kMmfR
         X2RpEVwpzOuMxDPEhB/mj1Zu0w6VjPjesYI816QpnCe25JasB0mfklWP8squMasSnJ7E
         RTSz48EmGQ9SmozI5+g3ukL/a787wuzVXNPt/R0Zyl3ynf1ieY3RNky6aSULVNKtDyhP
         FI5Pi3vASk6ngGKgyXI6WhotY7o+yvRsvYf0HpniWKy3m0Olp7DizrA20er1i2oyGvWo
         FgaA==
X-Gm-Message-State: AC+VfDwCETAz3xmd2GsJCHK7MFV0urX/9PzA7U6PTkfllZh/vd8I8ygo
        E9/NkW8bYpetPb2nlseUTzVj8N8pJDL4mg==
X-Google-Smtp-Source: ACHHUZ4KOVqeROcsaIln6n/RyrzYJhz0YdaKsjzfxCm5OaISXvJWu4eXlRwxUTJ/QOJv0yXbMHASyg02e/yptA==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a5b:909:0:b0:ba8:736a:5bec with SMTP id
 a9-20020a5b0909000000b00ba8736a5becmr9228478ybq.6.1684877961612; Tue, 23 May
 2023 14:39:21 -0700 (PDT)
Date:   Tue, 23 May 2023 21:39:10 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523213912.4006380-1-pranavpp@google.com>
Subject: [PATCH 0/2]
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch series adds fatal error checks for pm8001 driver
functions pm8001_phy_control() and pm8001_lu_reset().

1. Added a fatal error check in pm8001_phy_control().

2. Added a fatal error check in pm8001_lu_reset().

Changyuan Lyu (1):
  scsi: pm80xx: Add fatal error check for pm8001_phy_control()

Igor Pylypiv (1):
  scsi: pm80xx: Add fatal error check for pm8001_lu_reset()

 drivers/scsi/pm8001/pm8001_sas.c | 20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

-- 
2.40.1.698.g37aff9b760-goog

