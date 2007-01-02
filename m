From: Mark Lord <liml@rtr.ca>
Subject: [PATCH 2.6.20-rc3] fix broken retval test in sr_block_ioctl
Date: Tue, 2 Jan 2007 17:24:39 -0500
Message-ID: <200701021724.39613.liml@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>, Jeff Garzik <jgarzik@pobox.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

With recent kernels (and possibly much older ones, too),
ioctl() calls for ATAPI devices never make it to the driver layers.

The reason for this is a borked return code test in drivers/scsi/sr.c.
This patch fixes it.

Signed-off-by:  Mark Lord <mlord@pobox.com>

---
--- old/drivers/scsi/sr.c	2006-11-29 16:57:37.000000000 -0500
+++ linux/drivers/scsi/sr.c	2007-01-02 16:40:33.000000000 -0500
@@ -468,7 +468,7 @@
 	}
 
 	ret = cdrom_ioctl(file, &cd->cdi, inode, cmd, arg);
-	if (ret != ENOSYS)
+	if (ret != -ENOSYS)
 		return ret;
 
 	/*
