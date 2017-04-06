From: =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?=
        <jeremy.lefaure@lse.epita.fr>
Subject: [PATCH] scsi: sd: fix warning on min_not_zero use
Date: Thu,  6 Apr 2017 14:57:22 -0400
Message-ID: <20170406185722.4761-1-jeremy.lefaure@lse.epita.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from blatinox.fr ([51.254.120.209]:51528 "EHLO vps202351.ovh.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932990AbdDFS5q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 6 Apr 2017 14:57:46 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, =?UTF-8?q?J=C3=A9r=C3=A9my=20Lefaure?= <jeremy.lefaure@lse.epita.fr>, stable@vger.kernel.org

When calling min_not_zero, both arguments should have the same type.
Otherwise the compiler will raise a warning:

  CC      drivers/scsi/sd.o
In file included from ./include/linux/list.h:8:0,
                 from ./include/linux/module.h:9,
                 from drivers/scsi/sd.c:35:
drivers/scsi/sd.c: In function ‘sd_revalidate_disk’:
./include/linux/kernel.h:755:16: warning: comparison of distinct pointer
types lacks a cast
  (void) (&min1 == &min2);   \
                ^
./include/linux/kernel.h:758:2: note: in expansion of macro ‘__min’
  __min(typeof(x), typeof(y),   \
  ^~~~~
./include/linux/kernel.h:783:39: note: in expansion of macro ‘min’
  __x == 0 ? __y : ((__y == 0) ? __x : min(__x, __y)); })
                                       ^~~
drivers/scsi/sd.c:2959:12: note: in expansion of macro ‘min_not_zero’
   rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
            ^~~~~~~~~~~~

Casting the BLK_DEF_MAX_SECTORS constant fixes this issue.

Cc: <stable@vger.kernel.org> # v4.4+
Fixes: c3e62673ee20 ("scsi: sd: Consider max_xfer_blocks if opt_xfer_blocks is unusable")
Signed-off-by: Jérémy Lefaure <jeremy.lefaure@lse.epita.fr>
---
 drivers/scsi/sd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ab9011a6257d..7dce3592033d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -2955,9 +2955,10 @@ static int sd_revalidate_disk(struct gendisk *disk)
 	    logical_to_bytes(sdp, sdkp->opt_xfer_blocks) >= PAGE_SIZE) {
 		q->limits.io_opt = logical_to_bytes(sdp, sdkp->opt_xfer_blocks);
 		rw_max = logical_to_sectors(sdp, sdkp->opt_xfer_blocks);
-	} else
+	} else {
 		rw_max = min_not_zero(logical_to_sectors(sdp, dev_max),
-				      BLK_DEF_MAX_SECTORS);
+				      (sector_t)BLK_DEF_MAX_SECTORS);
+	}
 
 	/* Combine with controller limits */
 	q->limits.max_sectors = min(rw_max, queue_max_hw_sectors(q));
-- 
2.12.2
