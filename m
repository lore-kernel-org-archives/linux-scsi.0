From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 0/6] scsi: increase upper limit for max_sectors
Date: Mon,  2 Jun 2014 22:56:43 +0900
Message-ID: <1401717409-5236-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f42.google.com ([209.85.160.42]:60766 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753850AbaFBN5E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Jun 2014 09:57:04 -0400
Received: by mail-pb0-f42.google.com with SMTP id md12so4270892pbc.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Jun 2014 06:57:03 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "Elliott, Robert" <Elliott@hp.com>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

This patchset increases the SCSI mid level's limitation for max_sectors
upto the block layer's limitation for max_hw_sectors, and enables the
scsi_debug driver to request read/write commands with huge transfer
length.  This also includes a few fixes for the problems which can be
caused by huge max_sectors.

* Changes in v2
- Add Reviewed-by line
- Split the scsi core change into three patches, suggested by Christoph Hellwig
- Reorder conditional in command selection, suggested by Elliott, Robert

Akinobu Mita (6):
  block: fix BLKSECTGET ioctl when max_sectors is greater than USHRT_MAX
  block: fix SG_[GS]ET_RESERVED_SIZE ioctl when max_sectors is huge
  sg: prevent integer overflow when converting from sectors to bytes
  sd: use READ_16 or WRITE_16 when transfer length is greater than
    0xffff
  scsi: increase upper limit for max_sectors
  scsi_debug: allow huge transfer length for read/write commands

 block/compat_ioctl.c      |  6 ++++--
 block/ioctl.c             |  5 ++++-
 block/scsi_ioctl.c        | 15 +++++++++++----
 drivers/scsi/scsi_debug.c |  6 +++---
 drivers/scsi/sd.c         |  5 +----
 drivers/scsi/sg.c         | 17 +++++++++++++----
 include/scsi/scsi_host.h  |  4 ++--
 7 files changed, 38 insertions(+), 20 deletions(-)

Cc: "Elliott, Robert" <Elliott@hp.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

