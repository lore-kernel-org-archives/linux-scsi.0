Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AF90C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 21:45:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244210AbiFMVpD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 17:45:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234515AbiFMVpC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 17:45:02 -0400
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08DB644E
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:01 -0700 (PDT)
Received: by mail-pl1-f172.google.com with SMTP id d13so6153050plh.13
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 14:45:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dPrPrVe3LVDn2hDmwncIaapMLSuS6BrlsJp+FS1/j9M=;
        b=4vkehRqNsrDw4Ir/yoG9LZ6M0ILmdjE6vKqJaJiNm85feiqrVgaVK7MIM0wZ5D2oWn
         fU0ES5iW5oRVqLeknuhdHQesHCqvs5c9HcbmHmaH6/TEeqqNSdAxL6Scd2sQeQLkwt34
         k+NP0Qny0C1L5YJXR6XvzKahLM/JLW1hT/LnBY6mNAGi8Go1cOx26zpJ8SOVurQ6x5Y+
         AAPtB0TSmVER/wAW2dnJ1hhNAXH5nzG9VuSpG6011CtgNjThbd55dcZoKK+gOzNRwTlk
         dM5KdKBFEKoVvoLJY9T5TNSJVis5iOEyEb9wBtfltz8M3FmS5tLqgt5igu4qYGe9T+Ky
         nlmw==
X-Gm-Message-State: AJIora8boUPAVjNaaAHBrjiU/0lry87aWeGZ08WzRQ3wGOJHcN/A5MaF
        BNK/skUYcjcEXv+8cd+QRaM=
X-Google-Smtp-Source: AGRyM1tZaQTLBj7HEpNYcGfkC646wgUy2QLqtlCOPDd3qDPOus8+D0Bzc6o77rUF8aXY4o9qtEZVJQ==
X-Received: by 2002:a17:90a:1c02:b0:1e0:df7:31f2 with SMTP id s2-20020a17090a1c0200b001e00df731f2mr839332pjs.222.1655156700952;
        Mon, 13 Jun 2022 14:45:00 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:6862:a290:1a09:5af5])
        by smtp.gmail.com with ESMTPSA id ji2-20020a170903324200b001622c377c3esm5585833plb.117.2022.06.13.14.44.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jun 2022 14:45:00 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v2 0/3] ufs: Fix a race between the interrupt handler and the reset handler
Date:   Mon, 13 Jun 2022 14:44:39 -0700
Message-Id: <20220613214442.212466-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1.476.g0c4daa206d-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

This patch series is version two of a fix between the UFS interrupt handler and
reset handlers. Please consider this patch series for kernel v5.20.

Changes compared to v1:
- Converted a single patch into three patches.
- Modified patch 3/3 such that only cleared requests are completed.

Bart Van Assche (3):
  scsi: ufs: Simplify ufshcd_clear_cmd()
  scsi: ufs: Support clearing multiple commands at once
  scsi: ufs: Fix a race between the interrupt handler and the reset
    handler

 drivers/ufs/core/ufshcd.c | 76 ++++++++++++++++++++++++---------------
 1 file changed, 48 insertions(+), 28 deletions(-)

