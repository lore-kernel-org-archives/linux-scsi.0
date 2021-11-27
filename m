Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D51BC433EF
	for <linux-scsi@archiver.kernel.org>; Sat, 27 Nov 2021 16:51:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355666AbhK0QyY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 27 Nov 2021 11:54:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238091AbhK0QwX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Nov 2021 11:52:23 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D46C3C06174A
        for <linux-scsi@vger.kernel.org>; Sat, 27 Nov 2021 08:49:08 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id e8so12285628ilu.9
        for <linux-scsi@vger.kernel.org>; Sat, 27 Nov 2021 08:49:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:in-reply-to:references:subject:message-id:date
         :mime-version:content-transfer-encoding;
        bh=74KPh8uSppZNL+D6j5siIoZQyA62KjAQqI0tS1Kt2ew=;
        b=c1av8W8YwZl0rYTuLK41+9Y6KbEjsC054OmipQjloy3iXYC7YyFXB2Wtp+ZXxxoRIv
         w+2A5+9S6UJOj82FhyfbX6/sYgPT7QR4FW52XxB49Zw/HrDH+S9dcxSlUmarUsj3cjbk
         S997QYhw6+Vi21IGwDYKTezdwn03IlEIC9rAW7VmJrAC+7yG1SfSqBn3DhIzRio4K0JE
         iv74BA10O+6qSfhwztZzv5GPrZ4cuFRAMH7zLRsJvFKQSWFTcjHqkkFqkhBgfi3YT5qp
         YXHGWDFyvA7KxYYwJDvDnj3qqyyH1jGOgaTRcU+EnvvBNLJ+PJ9SejG9pqhb1UfntRh6
         hbqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:in-reply-to:references:subject
         :message-id:date:mime-version:content-transfer-encoding;
        bh=74KPh8uSppZNL+D6j5siIoZQyA62KjAQqI0tS1Kt2ew=;
        b=sN97WVP7HAhW99EiTp62lg1wUYmLm00Rh2hyM+WlgfUemk1RXF0ZYi8VEz1PXOxU9c
         rfbRmlY6rG1SqD/u/IYLL7HtYvmaK8h1hjNFRKnZSvweD+CbVLoqIeFksUNRGqVA3596
         EO1kLb8AObYXhCdqGtX8+5ODMjxhZffEdV2c4AvIlG/iPb1G4hs/YI+bEOOhvBtviNrL
         PsfGYYhodoi4towtCeFV1OX1IgFuy76peE0ObvC1uaZrfupvJqEpfkQzwttXP3gBFaaW
         ietwNrNV3FQH2B6gdR/E43PNrPpTSbpfDo1lByxLzd1gc955/bqPLVG/f31GeIUE+R4i
         H+cA==
X-Gm-Message-State: AOAM533TgWcJ9UwXjFxU0tcCi+IOGJZO/mEuPjdyM1jIitA17IYUPW2U
        395/43hdc/6/nWMs3D6pLoJa64X4XFkeilXt
X-Google-Smtp-Source: ABdhPJzVO6OubbKRB4/DxJw16wVuobuViqS9/AcFVO+7BaRidIpnYUeZLIcUTT54fZ6eWNYxFicUbg==
X-Received: by 2002:a05:6e02:188f:: with SMTP id o15mr10128692ilu.269.1638031748183;
        Sat, 27 Nov 2021 08:49:08 -0800 (PST)
Received: from [127.0.1.1] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id a4sm5201613ild.52.2021.11.27.08.49.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 27 Nov 2021 08:49:07 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Richard Weinberger <richard@nod.at>,
        linux-scsi@vger.kernel.org, linux-mtd@lists.infradead.org,
        Miquel Raynal <miquel.raynal@bootlin.com>
In-Reply-To: <20211126121802.2090656-1-hch@lst.de>
References: <20211126121802.2090656-1-hch@lst.de>
Subject: Re: remove ->rq_disk v2
Message-Id: <163803174742.18774.4130157406940181436.b4-ty@kernel.dk>
Date:   Sat, 27 Nov 2021 09:49:07 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Nov 2021 13:17:57 +0100, Christoph Hellwig wrote:
> this series removes the rq_disk field in struct request, which isn't
> needed now that we can get the disk from the request_queue.
> 
> Changes since v1:
>  - rebased to the latests for-5.17/block tree
> 
> Diffstat:
>  block/blk-flush.c                  |    3 --
>  block/blk-merge.c                  |    7 ------
>  block/blk-mq.c                     |   24 +++++++-------------
>  block/blk.h                        |    2 -
>  block/bsg-lib.c                    |    2 -
>  drivers/block/amiflop.c            |    2 -
>  drivers/block/ataflop.c            |    6 ++---
>  drivers/block/floppy.c             |    6 ++---
>  drivers/block/mtip32xx/mtip32xx.c  |    2 -
>  drivers/block/null_blk/trace.h     |    2 -
>  drivers/block/paride/pcd.c         |    2 -
>  drivers/block/paride/pd.c          |    6 ++---
>  drivers/block/paride/pf.c          |    4 +--
>  drivers/block/pktcdvd.c            |    2 -
>  drivers/block/rnbd/rnbd-clt.c      |    4 +--
>  drivers/block/sunvdc.c             |    2 -
>  drivers/block/sx8.c                |    4 +--
>  drivers/block/virtio_blk.c         |    2 -
>  drivers/md/dm-mpath.c              |    1
>  drivers/mmc/core/block.c           |   12 +++++-----
>  drivers/mtd/mtd_blkdevs.c          |   10 +-------
>  drivers/nvme/host/core.c           |    4 +--
>  drivers/nvme/host/fault_inject.c   |    2 -
>  drivers/nvme/host/pci.c            |    7 ++----
>  drivers/nvme/host/trace.h          |    6 ++---
>  drivers/nvme/target/passthru.c     |    3 --
>  drivers/scsi/ch.c                  |    2 -
>  drivers/scsi/scsi_bsg.c            |    2 -
>  drivers/scsi/scsi_error.c          |    2 -
>  drivers/scsi/scsi_ioctl.c          |   43 ++++++++++++++-----------------------
>  drivers/scsi/scsi_lib.c            |    5 ++--
>  drivers/scsi/scsi_logging.c        |    4 ++-
>  drivers/scsi/sd.c                  |   26 +++++++++++-----------
>  drivers/scsi/sd_zbc.c              |    8 +++---
>  drivers/scsi/sg.c                  |    6 ++---
>  drivers/scsi/sr.c                  |   11 ++++-----
>  drivers/scsi/st.c                  |    4 +--
>  drivers/scsi/ufs/ufshpb.c          |    4 +--
>  drivers/scsi/virtio_scsi.c         |    2 -
>  drivers/target/target_core_pscsi.c |    2 -
>  drivers/usb/storage/transport.c    |    2 -
>  include/linux/blk-mq.h             |   11 ++-------
>  include/scsi/scsi_cmnd.h           |    2 -
>  include/scsi/scsi_device.h         |    4 +--
>  include/scsi/scsi_ioctl.h          |    4 +--
>  include/trace/events/block.h       |    8 +++---
>  kernel/trace/blktrace.c            |    2 -
>  47 files changed, 124 insertions(+), 157 deletions(-)
> 
> [...]

Applied, thanks!

[1/5] mtd_blkdevs: remove the sector out of range check in do_blktrans_request
      commit: c9e9ff5c8923f562091bebcd72164206cb48f08b
[2/5] block: don't check ->rq_disk in merges
      commit: e14b671dc11db224aad647a51581ee0320e132f7
[3/5] block: remove the ->rq_disk field in struct request
      commit: dc6d79f09226f4b4ff50dfa689c6982962ca53d1
[4/5] block: remove the gendisk argument to blk_execute_rq
      commit: 3d5ff0d19d14d9d2576f12621608600f562cef5c
[5/5] scsi: remove the gendisk argument to scsi_ioctl
      commit: 6273dc67219580d76880cb930d9fa97c52feee20

Best regards,
-- 
Jens Axboe


