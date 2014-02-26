From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/7] scsi_debug: several bug fixes and enable clustering support
Date: Wed, 26 Feb 2014 22:56:57 +0900
Message-ID: <1393423024-8063-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:49575 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750717AbaBZN5U (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Feb 2014 08:57:20 -0500
Received: by mail-pd0-f175.google.com with SMTP id x10so981016pdj.20
        for <linux-scsi@vger.kernel.org>; Wed, 26 Feb 2014 05:57:19 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

Hi James,

Please consider to apply these patches to your tree.  There is no
change since the previous version except for adding Reviewed-by lines
from Douglas and Martin.

This patch set includes several bug fixes and patches for enabling
clustering support for scsi_debug.

The reason why I would like to enable clustering is to test commands
with huge transfer length.  Without enabling clustering support, the
transfer length for read and write scsi commands is limited upto 8MB
when page size is 4KB and sg_tablesize is 2048
(= SCSI_MAX_SG_CHAIN_SEGMENTS).

Changes from v2:
- add Reviewed-by lines

Akinobu Mita (7):
  scsi_debug: fix false positive logical block reference tag check fail
  scsi_debug: make pseudo_primary static
  scsi_debug: fix duplicate dif_errors increment
  scsi_debug: fix resp_xdwriteread() return value when running out of
    memory
  scsi_debug: prepare to enable clustering
  scsi_debug: protect device access with atomic_rw lock
  scsi_debug: add ability to enable clustering

 drivers/scsi/scsi_debug.c | 141 +++++++++++++++++++++++++++-------------------
 1 file changed, 82 insertions(+), 59 deletions(-)

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org
-- 
1.8.3.2

