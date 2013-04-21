From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/3] scsi_debug: fix data integrity support
Date: Sun, 21 Apr 2013 18:17:56 +0900
Message-ID: <1366535879-20775-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:46049 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3DUJSZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 21 Apr 2013 05:18:25 -0400
Received: by mail-pd0-f173.google.com with SMTP id v10so180234pde.32
        for <linux-scsi@vger.kernel.org>; Sun, 21 Apr 2013 02:18:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

When I tried testing the data integrity support in scsi_debug on x86_32,
I got CONFIG_DEBUG_HIGHMEM warnings and protection errors.  This was
triggered due to misused kmap_atomic/kunmap_atomic.

And then, while I was testing the fix of the above issue with several
combination with module parameters dix and dif, I found that doing
'modprobe scsi_debug dif=0 dix=1' causes kernel crash.

This patch set includes these fixes and cleanup which is related to data
integrity support.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Akinobu Mita (3):
  scsi_debug: fix data integrity support on highmem machine
  scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
  scsi_debug: simplify offset calculation for dif_storep

 drivers/scsi/scsi_debug.c | 29 ++++++++++++-----------------
 1 file changed, 12 insertions(+), 17 deletions(-)

-- 
1.8.1.4

