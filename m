From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/6] scsi_debug: a few bug fixes and enable clustering support
Date: Mon,  6 Jan 2014 08:33:06 +0900
Message-ID: <1388964792-3546-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f170.google.com ([209.85.192.170]:35727 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaAEXdZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Jan 2014 18:33:25 -0500
Received: by mail-pd0-f170.google.com with SMTP id g10so17418518pdj.15
        for <linux-scsi@vger.kernel.org>; Sun, 05 Jan 2014 15:33:24 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This patch set includes a few bug fixes and patches for enabling
clustering support for scsi_debug.  Some of bug fixes were already
sent before.

The reason why I would like to enable clustering is to test commands
with huge transfer length.  Without enabling clustering support, the
transfer length for read and write scsi commands is limited upto 8MB
when page size is 4KB and sg_tablesize is 2048
(= SCSI_MAX_SG_CHAIN_SEGMENTS).

Akinobu Mita (6):
  scsi_debug: fix false positive logical block reference tag check fail
  scsi_debug: make pseudo_primary static
  scsi_debug: fix duplicate dif_errors increment
  scsi_debug: fix resp_xdwriteread() return value when running out of
    memory
  scsi_debug: prepare to enable clustering
  scsi_debug: add ability to enable clustering

 drivers/scsi/scsi_debug.c | 137 +++++++++++++++++++++++++++-------------------
 1 file changed, 80 insertions(+), 57 deletions(-)

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.8.3.2

