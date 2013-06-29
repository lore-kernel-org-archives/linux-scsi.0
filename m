From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v4 0/6] scsi_debug: bug fixes and cleanups for data integrity support
Date: Sat, 29 Jun 2013 17:59:13 +0900
Message-ID: <1372496359-21100-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55687 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab3F2JAI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jun 2013 05:00:08 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq13so3277094pab.25
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jun 2013 02:00:07 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: JBottomley@parallels.com
Cc: Akinobu Mita <akinobu.mita@gmail.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

Hi James,

Please consider to apply these patches to your tree.  The only difference
between v3 and v4 is adding Acked-by from Douglas and Martin.

This patch set includes bug fixes which I hit when I was tried testing
the data integrity support in scsi_debug on x86_32.

And it also includes cleanups which helps increasing readability and
further bug fixing in data integrity support.

* Changes from v3
- Add Acked-by lines

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

