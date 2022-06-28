Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C072C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 22:24:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232348AbiF1WY5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 18:24:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232335AbiF1WYk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 18:24:40 -0400
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B18C3AA7C
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 15:21:38 -0700 (PDT)
Received: by mail-pf1-f180.google.com with SMTP id x4so13288574pfq.2
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 15:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=LXE0Tl9IpQfUvs65BlqtnZmrs4l9TCVt6e7+LjXJTIc=;
        b=o5fCm12a94NcqFqaGemC7fsugdEfu0etGVM42/69fjyXvUdkDEbBTC4AlKibDTtVdg
         ZLMGphm7K2hTId1tOA9KBvB1NA3CadR0edY/mrbKK0kEZYg2wQW/uVAHHfMLXh+mpPH1
         lVam6zGpe18F3EBkJVi9aw0pVBHlzLqhmNbK5s+ZVs+iLJWmVZEMiCFWeNSbyGzW1aSm
         0Kd/spTY8/1iHM43Aik9DUmtOyjOibLubVV3WThPKIg/mrYp0p6pKmOS/UE4DQuTDDG5
         i+FvZzm2KSASeK5ZjBxYrUmNpOAz/iWGG77i5Q4i6ulY2kVeUE9AvyLH2Kvuhv1OSnzB
         JMRQ==
X-Gm-Message-State: AJIora9S1aBf+wbEOlurzFizXR1nVoBNzrZOFjinbH905dhB4Ihjzd64
        omqKDwVlm5VNP2ZeeQJPNO4=
X-Google-Smtp-Source: AGRyM1uS/lYAZuWVAWpiiTuS2u0stoOoc+gb967k66ovS1UHvDgeMosQEuhO4zMvccvc5wczYexCJw==
X-Received: by 2002:a65:6e9b:0:b0:3fc:587a:6dcd with SMTP id bm27-20020a656e9b000000b003fc587a6dcdmr144070pgb.200.1656454897258;
        Tue, 28 Jun 2022 15:21:37 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id x9-20020a17090a294900b001eaae89de5fsm413599pjf.1.2022.06.28.15.21.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 15:21:36 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Reduce ATA disk resume time
Date:   Tue, 28 Jun 2022 15:21:28 -0700
Message-Id: <20220628222131.14780-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Recently it was reported that patch "scsi: core: pm: Rely on the device driver
core for async power management" causes resuming to take longer if an ATA disk
is present. This patch series fixes that regression. Please consider this
patch series for kernel v5.20.

Thanks,

Bart.

Bart Van Assche (3):
  scsi: core: Move the definition of SCSI_QUEUE_DELAY
  scsi: core: Retry after a delay if the device is becoming ready
  scsi: sd: Rework asynchronous resume support

 drivers/scsi/scsi_error.c |  4 +-
 drivers/scsi/scsi_lib.c   | 14 +++----
 drivers/scsi/sd.c         | 79 ++++++++++++++++++++++++++++++---------
 drivers/scsi/sd.h         |  5 +++
 4 files changed, 75 insertions(+), 27 deletions(-)

