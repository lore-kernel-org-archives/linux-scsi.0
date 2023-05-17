Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8A11C7EE2A
	for <linux-scsi@archiver.kernel.org>; Wed, 17 May 2023 23:10:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbjEQXKA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 19:10:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230029AbjEQXJt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 19:09:49 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DAB794
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:34 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-6434e65d808so1325363b3a.3
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 16:09:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684364973; x=1686956973;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ncMK8Ugm8M4NlRUB5CMYbK0tGMcjM+SGm9gH17Np2TA=;
        b=jMObdtoFyxoA4vAWHSwaLmit6gGz3IbE8hjFNCNQVkz5uR9CsJ3jlsOxoplf5+qH+w
         dqsSXZRzYGrY98jSd4POjShHZ5ehBFf3+icOFiU/ISgJdQmMbZj1/0k/DSdzGXc3r8QX
         j8KBLUXYTWZErnvw3JHH6DUWVA7TceoY/7l4DCXbm0rpzfBOeCQ9sNIT3gMWLKWkFEiZ
         lWF3yJbDm+yJRl2SDwVRNyDsNWIK4uxk4gZNAwIfv3ij3T1p75j9/lpxwzBbxyFOdAhX
         N4Mwz37JJP1P+UJ6zFhOLpTICXOJgVjjP45ihQzBDcr3P6QrbubrKh0EFDLQD+y4hLWs
         ViNA==
X-Gm-Message-State: AC+VfDwnvlCUbGYxbr/OF7o8xcZoGKNQ+U9B7U1jVghwi8XKgEh7kBDX
        b212crQC8p5UuoiEn30nAmagMT9qUbQ=
X-Google-Smtp-Source: ACHHUZ5N+M7gwzHfiJHH+rCVFWJfXSEKX2Du81mF+HqvE/3qQU2W3SJSHSY4hBjTpnA/wgjb7sHe0Q==
X-Received: by 2002:a05:6a20:3947:b0:104:70cf:eeb8 with SMTP id r7-20020a056a20394700b0010470cfeeb8mr26923710pzg.33.1684364973422;
        Wed, 17 May 2023 16:09:33 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id e9-20020a656789000000b005286ea6190esm15080694pgr.20.2023.05.17.16.09.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 16:09:32 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 0/4] SCSI core patches
Date:   Wed, 17 May 2023 16:09:23 -0700
Message-ID: <20230517230927.1091124-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.40.1.698.g37aff9b760-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Please consider these SCSI core patches for the next merge window.

Thanks,

Bart.

Changes compared to v2:
- Dropped patch "scsi: core: Update a source code comment".
- In patch "scsi: core: Trace SCSI sense data", changed the format for the
  sense key and left out a superfluous parenthese.
- In patch "scsi: core: Only kick the requeue list if necessary", moved the
  blk_mq_kick_requeue_list() from scsi_run_host_queues() into scsi_run_queue().

Changes compared to v1:
- Improved the SCSI tracing patch as requested by Steven Rostedt and
  Niklas Cassel.
- Added patch "scsi: core: Delay running the queue if the host is blocked".

Bart Van Assche (4):
  scsi: core: Use min() instead of open-coding it
  scsi: core: Trace SCSI sense data
  scsi: core: Only kick the requeue list if necessary
  scsi: core: Delay running the queue if the host is blocked

 drivers/scsi/scsi_common.c  |  3 +--
 drivers/scsi/scsi_lib.c     | 15 +++++++++------
 include/trace/events/scsi.h | 21 +++++++++++++++++++--
 3 files changed, 29 insertions(+), 10 deletions(-)

