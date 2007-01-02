From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH] SCSI: fix error code check in sr_block_ioctl()
Date: Tue, 2 Jan 2007 17:41:04 +0900
Message-ID: <20070102084104.GC10987@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [221.139.199.108] ([221.139.199.108]:40050 "EHLO htj.dyndns.org"
	rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S932996AbXABJNR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Jan 2007 04:13:17 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

sr_block_ioctl() should proceed to SCSI ioctls if cdrom_ioctl()
returns -ENOSYS.  However it tested for ENOSYS instead of -ENOSYS
rendering all SCSI ioctls other than GET_IDLUN and GET_BUS_NUMBER
inaccessible.  Fix it.

Signed-off-by: Tejun Heo <htejun@gmail.com>

diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
index fae6e95..89e9b36 100644
--- a/drivers/scsi/sr.c
+++ b/drivers/scsi/sr.c
@@ -468,7 +468,7 @@ static int sr_block_ioctl(struct inode *inode, struct file *file, unsigned cmd,
 	}
 
 	ret = cdrom_ioctl(file, &cd->cdi, inode, cmd, arg);
-	if (ret != ENOSYS)
+	if (ret != -ENOSYS)
 		return ret;
 
 	/*
