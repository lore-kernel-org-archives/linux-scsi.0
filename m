Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DAA2C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jul 2022 23:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229606AbiGKXA6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 19:00:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbiGKXA5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 19:00:57 -0400
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA54F53D05
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:56 -0700 (PDT)
Received: by mail-pf1-f175.google.com with SMTP id d10so5982211pfd.9
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 16:00:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=9rmdT9Gt0LPJemxvJ9q3QSxMdEXlYB2ckj3A+Acn8KA=;
        b=xBKQdOkjie0OpnYHLZer7a3vO5fnqChICVvQe+3RlQ8ERZpeE44OnXdTe3Co9FQgN3
         d1D1NNnZjSskNKnzUfTnqCBvTC7TzaNFRE99gjE/y9j8laWg+eb1Xhrxahybaz2MtNRr
         QJ6RGf4dkbf3kdRNfxbW8DlrKijuYOGq94q+UYJqgAT/gi6jAw3BQrU/7+P2cRqAD+/M
         f+MRnLXNNmaJ0NaRQrVfHqXKIuIqd0Exj7jS6Y/sw57vsi0uzYMIPozRIIAAX893dzYj
         6jmS2yBnPdBjfk0y0INP3w93FxvA3lyMEKXazFz9kuGt2lVfMO6EEwpgMkqhX5OxYT2h
         FfTA==
X-Gm-Message-State: AJIora8rhoMxzOgz6cVEUv4y4dNzmPL3YM/NKqE6n6ijrsUtqX7rljd1
        E0XzY1GhRDsGEKRao4iFmO0=
X-Google-Smtp-Source: AGRyM1v8s6CrWRo5+r7SGbWbSVCK4NA5zc56dK5Uizv/ZI92Jo4KD2bl2dq6wgUAD0aaJW0Xb11X9g==
X-Received: by 2002:a63:d409:0:b0:412:86b2:150d with SMTP id a9-20020a63d409000000b0041286b2150dmr17256820pgh.509.1657580455939;
        Mon, 11 Jul 2022 16:00:55 -0700 (PDT)
Received: from asus.hsd1.ca.comcast.net ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m6-20020a637d46000000b00411955c03e5sm4761886pgn.29.2022.07.11.16.00.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Jul 2022 16:00:55 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH 0/3] Improve READ CAPACITY reporting and handling
Date:   Mon, 11 Jul 2022 16:00:48 -0700
Message-Id: <20220711230051.15372-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

The three patches in this series improve READ CAPACITY reporting for zoned
block devices in the scsi_debug driver and also improve READ CAPACITY handling
in the SCSI disk (sd) driver for zoned block devices.

Please consider these patches for kernel v5.20.

Thanks,

Bart.

Bart Van Assche (3):
  scsi_debug: Set the SAME field in the REPORT ZONES response
  scsi_debug: Make the READ CAPACITY response compliant with ZBC
  scsi: sd_zbc: Fix handling of RC BASIS

 drivers/scsi/scsi_debug.c | 22 +++++++++++++++++++---
 drivers/scsi/sd_zbc.c     | 26 ++++++++++++++++++++++----
 2 files changed, 41 insertions(+), 7 deletions(-)

