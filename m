Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF47CCDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 20:48:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbjJQUsG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 16:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231944AbjJQUsG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 16:48:06 -0400
Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B9519F;
        Tue, 17 Oct 2023 13:48:04 -0700 (PDT)
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-6ccfe703184so590946a34.0;
        Tue, 17 Oct 2023 13:48:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697575684; x=1698180484;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbBT1xDh7WYKSKNXnHCqCoE9Yu3usLjG2NJObTTm2fQ=;
        b=XduhaDKcElJECbQ3ooBX+qEPyFKDWH2un+ixNE+2YygjWIh3mFNLIJl3A2wGuziIjB
         thALPaeaGLQWkjlM5uPyOn530VIoDBxg50imT3ekCMnvvFu9XJ5IQ29oV/4wLZadBwR/
         tZD5TSV5oeIypmRnrgY5bXnFS7Q6fQJJeJRan7+uOOnMyAMn83XwbbBCRfJNWOBN3YTn
         Dr5KVyicAf34ov4rdVMGOxDHXTGOp0ddPwHhey9Wk+sHT0YtH/WLeu8BZk32UV6uCJsD
         jDDWHJYFQCJX9tRcsxes5/d+evOJxworxl93POx1xI/eKEqU7hYiDrLg2cNCzJdHeo7J
         Wt3A==
X-Gm-Message-State: AOJu0YxC+BYraJxD34zOEBCZN5/5db2ntHqcJXUeTa5jf1EhK3Xa4AyN
        QW9p32jB2oPU2qEXX3xo9ZY=
X-Google-Smtp-Source: AGHT+IHHbuqPJ2VB3wK+8HHomLZL5aKX1G2MTg+XemJ1Mz3DuHjHPLAQ6ActyfmxNJZluiHMSqi4Hw==
X-Received: by 2002:a9d:67c4:0:b0:6c4:eea8:cf13 with SMTP id c4-20020a9d67c4000000b006c4eea8cf13mr3400933otn.27.1697575683770;
        Tue, 17 Oct 2023 13:48:03 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:8f02:2919:9600:ac09])
        by smtp.gmail.com with ESMTPSA id fa36-20020a056a002d2400b006b2e07a6235sm1874704pfb.136.2023.10.17.13.48.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 13:48:03 -0700 (PDT)
From:   Bart Van Assche <bvanassche@acm.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Avri Altman <Avri.Altman@wdc.com>,
        Bean Huo <huobean@gmail.com>,
        Daejun Park <daejun7.park@samsung.com>,
        Bart Van Assche <bvanassche@acm.org>
Subject: [PATCH v3 00/14] Pass data temperature information to SCSI disk devices
Date:   Tue, 17 Oct 2023 13:47:08 -0700
Message-ID: <20231017204739.3409052-1-bvanassche@acm.org>
X-Mailer: git-send-email 2.42.0.655.g421f12c284-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Jens,

UFS vendors need the data lifetime information to achieve good performance.
Without this information there is significantly higher write amplification due
to garbage collection. Hence this patch series that add support in F2FS and
also in the block layer for data lifetime information. The SCSI disk (sd)
driver is modified such that it passes write hint information to SCSI devices
via the GROUP NUMBER field.

Please consider this patch series for the next merge window.

Thanks,

Bart.

Changes compared to v1:
- Instead of storing data lifetime information in bi_ioprio, introduce the
  new struct bio member bi_lifetime and also the struct request member
  'lifetime'.
- Removed the bio_set_data_lifetime() and bio_get_data_lifetime() functions
  and replaced these with direct assignments.
- Dropped all changes related to I/O priority.
- Improved patch descriptions.

Changes compared to v1:
- Use six bits from the ioprio field for data lifetime information. The
  bio->bi_write_hint / req->write_hint / iocb->ki_hint members that were
  introduced in v1 have been removed again.
- The F_GET_FILE_RW_HINT and F_SET_FILE_RW_HINT fcntls have been removed.
- In the SCSI disk (sd) driver, query the stream status and check the PERM bit.
- The GET STREAM STATUS command has been implemented in the scsi_debug driver.

Bart Van Assche (14):
  fs: Move enum rw_hint into a new header file
  block: Restore data lifetime support in struct bio and struct request
  fs: Restore write hint support
  fs/f2fs: Restore data lifetime support
  scsi: core: Query the Block Limits Extension VPD page
  scsi_proto: Add structures and constants related to I/O groups and
    streams
  sd: Translate data lifetime information
  scsi_debug: Reduce code duplication
  scsi_debug: Support the block limits extension VPD page
  scsi_debug: Rework page code error handling
  scsi_debug: Rework subpage code error handling
  scsi_debug: Implement the IO Advice Hints Grouping mode page
  scsi_debug: Implement GET STREAM STATUS
  scsi_debug: Maintain write statistics per group number

 Documentation/filesystems/f2fs.rst |  70 ++++++++
 block/bio.c                        |   2 +
 block/blk-crypto-fallback.c        |   1 +
 block/blk-merge.c                  |   6 +
 block/blk-mq.c                     |   1 +
 block/bounce.c                     |   1 +
 block/fops.c                       |   3 +
 drivers/scsi/scsi.c                |   2 +
 drivers/scsi/scsi_debug.c          | 247 +++++++++++++++++++++--------
 drivers/scsi/scsi_sysfs.c          |  10 ++
 drivers/scsi/sd.c                  | 111 ++++++++++++-
 drivers/scsi/sd.h                  |   3 +
 fs/f2fs/data.c                     |   2 +
 fs/f2fs/f2fs.h                     |  10 ++
 fs/f2fs/segment.c                  |  95 +++++++++++
 fs/f2fs/super.c                    |  32 +++-
 fs/fcntl.c                         |   1 +
 fs/inode.c                         |   1 +
 fs/iomap/buffered-io.c             |   2 +
 fs/iomap/direct-io.c               |   1 +
 fs/mpage.c                         |   1 +
 include/linux/blk-mq.h             |   2 +
 include/linux/blk_types.h          |   2 +
 include/linux/fs.h                 |  16 +-
 include/linux/rw_hint.h            |  20 +++
 include/scsi/scsi_device.h         |   1 +
 include/scsi/scsi_proto.h          |  75 +++++++++
 27 files changed, 635 insertions(+), 83 deletions(-)
 create mode 100644 include/linux/rw_hint.h

