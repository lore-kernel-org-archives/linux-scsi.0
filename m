Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65C41C7EE26
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 21:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237571AbjEWVlp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 17:41:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234456AbjEWVlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 17:41:44 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C08AEFA
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:41:43 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba88ec544ddso434869276.1
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 14:41:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684878103; x=1687470103;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DYoP+7y3H6KxflmECkTj0wmu7P4fg+DdkxFWOe2r+Gw=;
        b=fiYfRUVv6NDJ5NH3wVrtXPpRMWJsZHcc72EYpz6mfFUVqJDMQiDkSDwLuV4tuZZNmr
         KosGFPNUODdxyPJN1Vvbm4TX8BuYIaiDAxPkmc1SqOgSIG11U7rNSFHupVCZ6wK3fxSo
         BU7elBqN6D8meTOn6NGXNNEm7R3q0E/7/6nVvKkaCR8xhB7LxWjhavNXEdfEGgqRnIiY
         MfUNRvkYtfBjOxhGPlnv0lyKaF4EQr5ClEgmq85xIQW0T/Vn0f77GUhuiN4SvCmjSZtg
         roT5Rt04/ombtVEqKPDShkUvMMSJCQYGpu20Fhs/lYQzOPVmUyXz0ApyqENH6TTE3brK
         QOHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684878103; x=1687470103;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DYoP+7y3H6KxflmECkTj0wmu7P4fg+DdkxFWOe2r+Gw=;
        b=gDgvSd6teLMop42k67N9H1UjyJsZmV5Sh88yNFo0CTI2nr0/CV+bEhEJb98r66eJ/y
         Yu8nbc+AzVGLsuPLCD5XKlTQlo64PDZAUCRvkUZWu5M8nBI/u+THzj50U72kXuAcQKVA
         Z2EHB3rVXA4WGzTlHCJZnLYnmQjOdi5o7FHEtvun11cFH+XEWk65xjneWPM6p8BbK4dV
         y7SeNx130cqTqVX0/PRg94msT24xv2sgZPRlXwjRCGKsm0FxO26TudL91MWiAH7W8tQ7
         JQoZdtBOwGpWDySN+WLJOk0gnTtHAjnuEIk9Zqngk3nXQf7gD5e2jSItqPPM5/DrmRt6
         tyZg==
X-Gm-Message-State: AC+VfDx31JqkCv01uxYoQY/+xs4IrQZtMFJLePYqGmCum0YCvYnMKI74
        xce4PtSveoaqI3keWJDqVerHgpqQhLqeKA==
X-Google-Smtp-Source: ACHHUZ6rDfhPdvFJHBI17huMiHUy5WPeuPTapN6ej6oM5BcAycgGa2pPMIjNcbUEz1/tKeG7b+/AjLfxaHlMuQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a05:6902:3c2:b0:ba8:939b:6574 with SMTP
 id g2-20020a05690203c200b00ba8939b6574mr9212761ybs.12.1684878103088; Tue, 23
 May 2023 14:41:43 -0700 (PDT)
Date:   Tue, 23 May 2023 21:41:25 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
Message-ID: <20230523214127.4006891-1-pranavpp@google.com>
Subject: [PATCH 0/2] scsi: pm80xx: Fatal error checks
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

