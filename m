From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/4] scsi: increase upper limit for max_sectors
Date: Sun, 25 May 2014 21:43:32 +0900
Message-ID: <1401021816-10423-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:44004 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751419AbaEYMoD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 25 May 2014 08:44:03 -0400
Received: by mail-pb0-f41.google.com with SMTP id uo5so6390988pbc.0
        for <linux-scsi@vger.kernel.org>; Sun, 25 May 2014 05:44:02 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

This patchset increases the SCSI mid level's limitation for max_sectors
upto the block layer's limitation for max_hw_sectors, and enables the
scsi_debug driver to request read/write commands with huge transfer
length.  This also includes a few fixes for the problems which can be
caused by huge max_sectors in the block layer.

Akinobu Mita (4):
  block: fix BLKSECTGET ioctl when max_sectors is greater than USHRT_MAX
  block: fix SG_[GS]ET_RESERVED_SIZE ioctl when max_sectors is huge
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

Cc: Jens Axboe <axboe@kernel.dk>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.9.1

