Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34CBEC77B75
	for <linux-scsi@archiver.kernel.org>; Tue, 16 May 2023 17:57:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbjEPR5q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 May 2023 13:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229458AbjEPR5p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 May 2023 13:57:45 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CE93125
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 10:57:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 3f1490d57ef6-ba69d93a6b5so14882720276.1
        for <linux-scsi@vger.kernel.org>; Tue, 16 May 2023 10:57:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1684259863; x=1686851863;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=XYAsynXy0qhLt31JsQGFwwPdGuXbkEfsjf2hEcVOFMI=;
        b=HNQtLQVZkKAmG0RuWXNB3Qfs6Eknt+JgqrGmCUosMrev8RfpdcLgxRUtrYSf9HU6Aq
         NBpVag0+ymzcHg4V12fzNfN3ZgY968fkjq+n5QSSCnSeU+88CH1J3BL+qm35cU33Z8Yp
         SG4MVflqYKiwZ/pRq9HbS4v5Oy2Jlhg+geg+Z4LKKKHUYjmVIq1qovsL6nawLruy+U/j
         TRGh/0aneBFevtqdV0ID7PCOYMUv163Qh0zm3oFc33lE2/0cgDxlesyDqbwVFHHTWkFU
         5+X+NhfuAziXHZN7KLQbC5lMue6Xetsw9xSulVJj0UBsucSLUrjpaTfjrwKoIiPtGL+M
         qkRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684259863; x=1686851863;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XYAsynXy0qhLt31JsQGFwwPdGuXbkEfsjf2hEcVOFMI=;
        b=L2/gosb3T8ZAdDxezCxvOgDeLPEAAARButHTEK+HwEut7h7yCiDLCbIcKxPSS2/zqK
         VeNL7uzWdGF6cKNFkZxMx085ZfccS9noZnU5pQxHfd1Lp2jJD2pFILcPlWofMDJvqrKU
         k71BrEtfM0wn/8Iie7ROr7thAamNAAe4i2mzacdaX8WwwsMHcMPxJzuP4yOgW9dUlXHZ
         VGKt9ee0SkIeNLnW7IFc0RRaqqvj/dMg4524ErOGViVUBOHvxJdpU0i54M1zMWWhg5m0
         tQ+AOPqE7BJY9Rmg3gBobS9SonC91uMetb07UpH13tgxXqXx4fTAv2gpGslD0QL09DOJ
         xdQw==
X-Gm-Message-State: AC+VfDwoqlmLGa0GkqtZOm/KK0xqE/FPyJkDRvFFqvrS5BoH4jdwgyPW
        7wanv2t+T5KNGn40Dhk2HwNjTnOSGUK3GQ==
X-Google-Smtp-Source: ACHHUZ6vT+g1sIVdxaiODXjnAKnpgOo7aXFzFwkzqdbwsc/WeEp/ry6zgCaDmFgGXU9H1Utt4ULX94e/Ts3pQQ==
X-Received: from pranav-first.c.googlers.com ([fda3:e722:ac3:cc00:24:72f4:c0a8:390b])
 (user=pranavpp job=sendgmr) by 2002:a25:1bd4:0:b0:ba7:85fd:9d38 with SMTP id
 b203-20020a251bd4000000b00ba785fd9d38mr6534719ybb.4.1684259863386; Tue, 16
 May 2023 10:57:43 -0700 (PDT)
Date:   Tue, 16 May 2023 17:57:37 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.40.1.606.ga4b1b128d6-goog
Message-ID: <20230516175737.1831575-1-pranavpp@google.com>
Subject: [PATCH] scsi: pm80xx: Set phy_attached to zero when device is gone
From:   Pranav Prasad <pranavpp@google.com>
To:     Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Igor Pylypiv <ipylypiv@google.com>,
        Pranav Prasad <pranavpp@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Igor Pylypiv <ipylypiv@google.com>

Set phy_attached to zero when device is gone.

Signed-off-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Pranav Prasad <pranavpp@google.com>
---
 drivers/scsi/pm8001/pm8001_sas.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/pm8001/pm8001_sas.c b/drivers/scsi/pm8001/pm8001_sas.c
index e5673c774f66..c57fc671509d 100644
--- a/drivers/scsi/pm8001/pm8001_sas.c
+++ b/drivers/scsi/pm8001/pm8001_sas.c
@@ -706,6 +706,7 @@ static void pm8001_dev_gone_notify(struct domain_device *dev)
 			spin_lock_irqsave(&pm8001_ha->lock, flags);
 		}
 		PM8001_CHIP_DISP->dereg_dev_req(pm8001_ha, device_id);
+		pm8001_ha->phy[pm8001_dev->attached_phy].phy_attached = 0;
 		pm8001_free_dev(pm8001_dev);
 	} else {
 		pm8001_dbg(pm8001_ha, DISC, "Found dev has gone.\n");
-- 
2.40.1.606.ga4b1b128d6-goog

