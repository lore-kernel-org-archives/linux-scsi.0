From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH 1/2] scsi_debug: fix endianness bug in sdebug_build_parts()
Date: Mon, 26 Aug 2013 22:08:40 +0900
Message-ID: <1377522521-9371-2-git-send-email-akinobu.mita@gmail.com>
References: <1377522521-9371-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f176.google.com ([209.85.192.176]:40526 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756372Ab3HZNJ6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Aug 2013 09:09:58 -0400
Received: by mail-pd0-f176.google.com with SMTP id q10so3435861pdj.35
        for <linux-scsi@vger.kernel.org>; Mon, 26 Aug 2013 06:09:57 -0700 (PDT)
In-Reply-To: <1377522521-9371-1-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, Douglas Gilbert <dgilbert@interlog.com>

With module parameter num_parts > 0, partition table is built on the
ramdisk storage when loading the driver.  Unfortunately, there is an
endianness bug in sdebug_build_parts().  So the partition table is not
correctly initialized on big-endian systems.

Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Acked-by: Martin Peschke <mpeschke@linux.vnet.ibm.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Douglas Gilbert <dgilbert@interlog.com>
Cc: linux-scsi@vger.kernel.org
---
 drivers/scsi/scsi_debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index cb4fefa..2f39b13 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -2659,8 +2659,8 @@ static void __init sdebug_build_parts(unsigned char *ramp,
 			       / sdebug_sectors_per;
 		pp->end_sector = (end_sec % sdebug_sectors_per) + 1;
 
-		pp->start_sect = start_sec;
-		pp->nr_sects = end_sec - start_sec + 1;
+		pp->start_sect = cpu_to_le32(start_sec);
+		pp->nr_sects = cpu_to_le32(end_sec - start_sec + 1);
 		pp->sys_ind = 0x83;	/* plain Linux partition */
 	}
 }
-- 
1.8.3.1

