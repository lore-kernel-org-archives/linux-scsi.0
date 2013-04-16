From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 0/6] scsi_debug: fix logical block provisioning support
Date: Tue, 16 Apr 2013 22:11:54 +0900
Message-ID: <1366117920-11740-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f182.google.com ([209.85.192.182]:64449 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755214Ab3DPNMY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Apr 2013 09:12:24 -0400
Received: by mail-pd0-f182.google.com with SMTP id 3so286414pdj.13
        for <linux-scsi@vger.kernel.org>; Tue, 16 Apr 2013 06:12:23 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

I tried testing the logical block provisioning support in scsi_debug,
but it didn't work as I expected.

For example, load scsi_debug module with UNMAP command supported
and fill the storage with random data.

	# modprobe scsi_debug lbpu=1
	# dd if=/dev/urandom of=/dev/sdb

Then, try to unmap LBA 0, but Get LBA status reports:

	# sg_unmap --lba=0 --num=1 /dev/sdb
	# sg_get_lba_status --lba=0 /dev/sdb
	descriptor LBA: 0x0000000000000000  blocks: 16384  mapped

This is unexpected result.  Because UNMAP command to LBA 0 finished
without any errors, but Get LBA status shows that LBA 0 is still mapped.

I looked around the logical block provisioning support in scsi_debug,
and I found several problems there.  This patch series tries to fix
these problems and it is broken into small patches as much as possible
for ease of review.

Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>

Akinobu Mita (6):
  scsi_debug: call map_region() and unmap_region() only when needed
  scsi_debug: prohibit scsi_debug_unmap_granularity ==
    scsi_debug_unmap_alignment
  scsi_debug: clear correct memory region when LBPRZ is enabled
  scsi_debug: add translation functions between LBA and index of
    provisioning map
  scsi_debug: fix initialization of provisioning map
  scsi_debug: fix logical block provisioning support

 drivers/scsi/scsi_debug.c | 97 ++++++++++++++++++++++++-----------------------
 1 file changed, 50 insertions(+), 47 deletions(-)

-- 
1.8.1.4

