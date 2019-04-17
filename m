From: Pan Bian <bianpan2016@163.com>
Subject: scsi: osst: drop SCSI devie reference taken before
Date: Wed, 17 Apr 2019 15:40:00 +0800
Message-ID: <1555486800-107606-1-git-send-email-bianpan2016@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Willem Riede <osst@riede.org>, "James E.J. Bottomley" <jejb@linux.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: osst-users@lists.sourceforge.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Pan Bian <bianpan2016@163.com>
List-Id: linux-scsi@vger.kernel.org

In the function __os_scsi_tape_open, scsi_device_get is called to take a
reference of the device. The reference should be dropped when it is no
longer used. However, when scsi_block_when_processing_errors returns a
false value, the reference is not dropped. This patch fixes the bug.

Signed-off-by: Pan Bian <bianpan2016@163.com>
---
 drivers/scsi/osst.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/osst.c b/drivers/scsi/osst.c
index be3c73e..f2b2b86 100644
--- a/drivers/scsi/osst.c
+++ b/drivers/scsi/osst.c
@@ -4489,7 +4489,8 @@ static int __os_scsi_tape_open(struct inode * inode, struct file * filp)
 	STp->rew_at_close = TAPE_REWIND(inode);
 
 	if( !scsi_block_when_processing_errors(STp->device) ) {
-		return -ENXIO;
+		retval = -ENXIO;
+		goto err_out;
 	}
 
 	if (mode != STp->current_mode) {
-- 
2.7.4
