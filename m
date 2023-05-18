Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6FC4C7EE25
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 19:32:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjERTcH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 May 2023 15:32:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjERTcG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 May 2023 15:32:06 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F588E51
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:05 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-64d2981e3abso448104b3a.1
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2023 12:32:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684438324; x=1687030324;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W7p0kNk2INlMmjQio6iqxyfwbLgYk2uKoPUQuecn1To=;
        b=ZavaJkYt3AhKuqY2EWr4yf9ESwWzUB/jYnTYodhc+Sc7uFDjurSHbHdha27L4HFnjM
         AdEfMKOWPohEl87hIMIgDIYhl15Am2WahC6EcGq7oUwZeqJRYt1R7DtpNJ9LIhrfzFBi
         LPdJBKuhNspGKmRgu9pUqp5BBBxVM7RAIbJRg152o3gDBpdQUnL7eJm3qfw7PQEv2IKc
         Z8kIC+NGI9QjuGqNap6p6F3eJuvhdP4F0IHx6Tu8S65wZ/y8TyqGzK7+rAGNERJ8R9o3
         hSPYRGR6lABCbdQP3htq1Fus5ufmmTygLwZyKBho7JBmyhd/2ohCia2cvXnfJI0Ueoxg
         6nVw==
X-Gm-Message-State: AC+VfDyLpO5pgBXMlkr1WYYbCXc72XeTOQV9lAJZ/nBDZpBM4ts3gz9S
        GZ4hkOc4vSbtkM2ZOEGCxbw=
X-Google-Smtp-Source: ACHHUZ4Ekguj9eQwtJZm28wOLFeybyELzk+X9PNpXeuchX2G3Oz7jqeQuzDe/7K4zNaNk1AbCHtLOg==
X-Received: by 2002:a05:6a00:2d1c:b0:643:b489:246d with SMTP id fa28-20020a056a002d1c00b00643b489246dmr7115372pfb.3.1684438324525;
        Thu, 18 May 2023 12:32:04 -0700 (PDT)
Received: from bvanassche-glaptop2.roam.corp.google.com ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 11-20020a63050b000000b0051afa49e07asm1619047pgf.50.2023.05.18.12.32.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 May 2023 12:32:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v4 0/3] SCSI core patches
Date:   Thu, 18 May 2023 12:31:56 -0700
Message-ID: <20230518193159.1166304-1-bvanassche@acm.org>
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

Changes compared to v3:
- Changed the SCSI tracing format to make it less likely to break existing
  user space software that parses SCSI trace information.
- Dropped patch "Delay running the queue if the host is blocked".

Changes compared to v2:
- Dropped patch "Update a source code comment".
- In patch "Trace SCSI sense data", changed the format for the sense key and
  left out a superfluous parenthese.
- In patch "Only kick the requeue list if necessary", moved the
  blk_mq_kick_requeue_list() call from scsi_run_host_queues() into
  scsi_run_queue().

Changes compared to v1:
- Improved the SCSI tracing patch as requested by Steven Rostedt and
  Niklas Cassel.
- Added patch "Delay running the queue if the host is blocked".

Bart Van Assche (3):
  scsi: core: Use min() instead of open-coding it
  scsi: core: Trace SCSI sense data
  scsi: core: Only kick the requeue list if necessary

 drivers/scsi/scsi_common.c  |  3 +--
 drivers/scsi/scsi_lib.c     | 13 ++++++++-----
 include/trace/events/scsi.h | 21 +++++++++++++++++++--
 3 files changed, 28 insertions(+), 9 deletions(-)

