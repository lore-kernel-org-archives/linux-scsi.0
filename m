Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89772C6FD18
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Apr 2023 19:01:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231261AbjDRTBu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:01:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbjDRTBt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Apr 2023 15:01:49 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 115CF659F
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:47 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-54f87e44598so183653427b3.5
        for <linux-scsi@vger.kernel.org>; Tue, 18 Apr 2023 12:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1681844507; x=1684436507;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=AAeeT3p1vaSWYTnW7BRdrG3feIz/DGLDWlUjJoHLVqg=;
        b=OwcDT7LOzlCFAeu0xRaCl7iUIBd5PDxPpFkmbfuqYKYvBTruGDFXFp3O7cfM3AFN0u
         y5tqel0Qb/FfiyxXiUCJCM7vp9+2nTofXH3eCB0bjBxrKaNRfKYsKIakhNcS1CyAI6Id
         HugV8UdOjVW8CwD4QuOkKLUkdfhdM/bk6RZoeBOBHb0zhKekacXL1LREoUip2WvdCokp
         KEPA4SecxTOWXfNVprmQYD04fK+rfDv+RcV0uXpu7jQ5DBnKW7ywivcPjcQE5MpShmLt
         KkFvYQs+22HIFvBj2ukr/uHMcvoxadq97exOY+QyT9Zj/oH7DCCXXNCg058YV3N58dp4
         vVCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681844507; x=1684436507;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AAeeT3p1vaSWYTnW7BRdrG3feIz/DGLDWlUjJoHLVqg=;
        b=RrQrKmVAvQMA9bBZnVfjxulqmfu32ue3aKDmgGmgue7ch6W69sqRrwlPszjoz6YlP4
         zWAPtErSAuYfVFyjD1vZhbeDqMRzPnl/WDGwN8vzmAexXk5hM07kIfOP6yR8E0SmEssq
         P5qoTxC0lsllrI3p9repENLTMvmpjhanu0eoNWn+7NmFnbNTPApDeZ5CcO/nYdiR+4kT
         d2DW+1ljSCokNnM1czz4rbbwHT80rlXQdeefTyDYvQrjlcRHTKx3IbWTv2yPPiwg6OCJ
         yfvHO/bPLPbWSjBBx5224TYuGWOBCCn0WaSaMa6kOzQIQg1jy5n43wH1NoM1T4/hBASZ
         +CkA==
X-Gm-Message-State: AAQBX9d6frfKJa1gGMHdqewkjOBF9u+kM0o7knp2ccBTTZUnJXyJsOgg
        BxGJG7s6cObNxTmOVu2TAE5pUe1/r1H8cw==
X-Google-Smtp-Source: AKy350YNTdOC+Qu0ZZDEZvRCkBI3kINVlltGg8N+eFVa3z4O61YIZE3/G2hVitPqSZuFWz5SqN3328lLORQqDQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a0d:ec43:0:b0:541:8285:b25 with SMTP id
 r3-20020a0dec43000000b0054182850b25mr467702ywn.10.1681844507277; Tue, 18 Apr
 2023 12:01:47 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:00:55 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.0.634.g4ca3ef3211-goog
Message-ID: <20230418190101.696345-1-pranavpp@google.com>
Subject: [PATCH 0/6] scsi: pm80xx: Enhanced debug logs for HW events
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

This patch series enhances debug logs for pm80xx HW events, and provides
a minor fix in the case of a hard reset. The log enhancement involves
changing the log severity level to enable logging for HW events
which consequently help debug disk discovery issues.

1. Changed log severity level from MSG to EVENT for HW events.
Enhanced the HW event logs by adding the phyid.

2. Enabled INIT logging.

3. Log portid along with the PHY_UP event.

4. Print phyid and portid sent as part of device registration
request.

5. Log port state during HW events.

6. Update phy_state and phy_attached to correct values after
a hard reset.

Akshat Jain (5):
  scsi: pm80xx: Enable init logging
  scsi: pm80xx: Print port_id in hardware events
  scsi: pm80xx: Log phyid and portid device register request
  scsi: pm80xx: Log port state during HW event
  scsi: pm80xx: Log some HW events by default

Changyuan Lyu (1):
  scsi: pm80xx: Update PHY state after hard reset

 drivers/scsi/pm8001/pm8001_init.c |   3 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c  | 126 +++++++++++++++++++-----------
 3 files changed, 85 insertions(+), 45 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

