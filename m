From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v3 0/6] scsi_debug: bug fixes and cleanups for data integrity support
Date: Sun, 26 May 2013 17:01:16 +0900
Message-ID: <1369555282-17864-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:55643 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758863Ab3EZIBr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 26 May 2013 04:01:47 -0400
Received: by mail-pa0-f46.google.com with SMTP id fa10so5770246pad.5
        for <linux-scsi@vger.kernel.org>; Sun, 26 May 2013 01:01:46 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

This patch set includes bug fixes which I hit when I was tried testing
the data integrity support in scsi_debug on x86_32.

And it also includes cleanups which helps increasing readability and
further bug fixing in data integrity support.

* Changes from v2
- Add new bug fix patch for UNMAP command support
- Change the way to fix for the patch "fix invalid address passed to
  kunmap_atomic()"
- Reduce more lines of code for the patch "reduce duplication between
  prot_verify_read and prot_verify_writ"

* Changes from v1
- Split the patch "fix data integrity support on highmem machine" into
  two separate patches.
- Add new cleanup patch "reduce duplication between prot_verify_read and
  prot_verify_write".

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

Akinobu Mita (6):
  scsi_debug: fix invalid address passed to kunmap_atomic()
  scsi_debug: fix incorrectly nested kmap_atomic()
  scsi_debug: fix NULL pointer dereference with parameters dif=0 dix=1
  scsi_debug: invalidate protection info for unmapped region
  scsi_debug: simplify offset calculation for dif_storep
  scsi_debug: reduce duplication between prot_verify_read and
    prot_verify_write

 drivers/scsi/scsi_debug.c | 176 +++++++++++++++++++---------------------------
 1 file changed, 72 insertions(+), 104 deletions(-)

-- 
1.8.1.4

