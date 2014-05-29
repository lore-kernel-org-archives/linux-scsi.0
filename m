From: Dave Jones <davej@redhat.com>
Subject: block: remove dead code in scsi_ioctl:blk_verify_command
Date: Thu, 29 May 2014 15:11:30 -0400
Message-ID: <20140529191130.GA10405@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: Linux Kernel <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

filter gets assigned the address of blk_default_cmd_filter on
entry to this function, so the !filter condition can never be true.

Signed-off-by: Dave Jones <davej@redhat.com>

diff --git a/block/scsi_ioctl.c b/block/scsi_ioctl.c
index 26487972ac54..9c28a5b38042 100644
--- a/block/scsi_ioctl.c
+++ b/block/scsi_ioctl.c
@@ -205,10 +205,6 @@ int blk_verify_command(unsigned char *cmd, fmode_t has_write_perm)
 	if (capable(CAP_SYS_RAWIO))
 		return 0;
 
-	/* if there's no filter set, assume we're filtering everything out */
-	if (!filter)
-		return -EPERM;
-
 	/* Anybody who can open the device can do a read-safe command */
 	if (test_bit(cmd[0], filter->read_ok))
 		return 0;
