From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 0/5] scsi_debug: bug fixes and cleanups for data integrity support
Date: Sun, 19 May 2013 22:42:04 +0900
Message-ID: <1368970929-20006-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-da0-f47.google.com ([209.85.210.47]:60783 "EHLO
	mail-da0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab3ESNmc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 19 May 2013 09:42:32 -0400
Received: by mail-da0-f47.google.com with SMTP id k13so3314998dae.6
        for <linux-scsi@vger.kernel.org>; Sun, 19 May 2013 06:42:32 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This patch set includes bug fixes which I hit when I was tried testing
the data integrity support in scsi_debug on x86_32.

And it also includes cleanups which helps increasing readability and
further bug fixing in data integrity support.

* Changes from v1
- Split the patch "fix data integrity support on highmem machine" into
  two separate patches.
- Add new cleanup patch "reduce duplication between prot_verify_read and
  prot_verify_write".

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Akinobu Mita (5):
  scsi_debug: fix invalid address passed to kunmap_atomic()
  scsi_debug: fix incorrectly nested kmap_atomic()
  scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
  scsi_debug: simplify offset calculation for dif_storep
  scsi_debug: reduce duplication between prot_verify_read and
    prot_verify_write

 drivers/scsi/scsi_debug.c | 164 +++++++++++++++++++---------------------------
 1 file changed, 66 insertions(+), 98 deletions(-)

-- 
1.8.1.4

