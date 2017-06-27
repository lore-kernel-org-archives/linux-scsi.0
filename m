From: "Gustavo A. R. Silva" <garsilva@embeddedor.com>
Subject: [PATCH] scsi: osst: remove useless variable assignments in
 osst_int_ioctl()
Date: Tue, 27 Jun 2017 17:23:55 -0500
Message-ID: <20170627222355.GA8908@embeddedgus>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Gustavo A. R. Silva" <garsilva@embeddedor.com>
List-Id: linux-scsi@vger.kernel.org

Value assigned to variable blkno at lines
4123:if (blkno >= 0) blkno += arg; and
4127:if (blkno >= 0) blkno -= arg;
is overwritten at line 4131:blkno  = STps->drv_block;
before it can be used.

This makes such variable assignments useless.

Addresses-Coverity-ID: 1397685
Signed-off-by: Gustavo A. R. Silva <garsilva@embeddedor.com>
---
 drivers/scsi/osst.c | 13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index 929ee7e..a62c1f2 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4118,14 +4118,11 @@ static int osst_int_ioctl(struct osst_tape * STp, struct osst_request ** aSRpnt,
 		   printk(OSST_DEB_MSG "%s:D: Skipping %lu blocks %s from logical block %d\n",
 				name, arg, cmd_in==MTFSR?"forward":"backward", logical_blk_num);
 #endif
-		if (cmd_in == MTFSR) {
-		   logical_blk_num += arg;
-		   if (blkno >= 0) blkno += arg;
-		}
-		else {
-		   logical_blk_num -= arg;
-		   if (blkno >= 0) blkno -= arg;
-		}
+		if (cmd_in == MTFSR)
+			logical_blk_num += arg;
+		else
+			logical_blk_num -= arg;
+
 		ioctl_result = osst_seek_logical_blk(STp, &SRpnt, logical_blk_num);
 		fileno = STps->drv_file;
 		blkno  = STps->drv_block;
-- 
2.5.0
