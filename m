From: Adrian Bunk <bunk@stusta.de>
Subject: [2.6 patch] drivers/scsi/sg.c: fix check after use
Date: Sun, 27 Mar 2005 22:43:30 +0200
Message-ID: <20050327204330.GZ4285@stusta.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Received: from emailhub.stusta.mhn.de ([141.84.69.5]:27664 "HELO
	mailout.stusta.mhn.de") by vger.kernel.org with SMTP
	id S261539AbVC0Und (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2005 15:43:33 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

This patch fixes a check after use found by the Coverity checker.

Signed-off-by: Adrian Bunk <bunk@fs.tum.de>

--- linux-2.6.12-rc1-mm1-full/drivers/scsi/sg.c.old	2005-03-23 04:57:20.000000000 +0100
+++ linux-2.6.12-rc1-mm1-full/drivers/scsi/sg.c	2005-03-23 04:57:50.000000000 +0100
@@ -1208,11 +1208,14 @@
 sg_mmap(struct file *filp, struct vm_area_struct *vma)
 {
 	Sg_fd *sfp;
-	unsigned long req_sz = vma->vm_end - vma->vm_start;
+	unsigned long req_sz;
 	Sg_scatter_hold *rsv_schp;
 
 	if ((!filp) || (!vma) || (!(sfp = (Sg_fd *) filp->private_data)))
 		return -ENXIO;
+
+	req_sz = vma->vm_end - vma->vm_start;
+
 	SCSI_LOG_TIMEOUT(3, printk("sg_mmap starting, vm_start=%p, len=%d\n",
 				   (void *) vma->vm_start, (int) req_sz));
 	if (vma->vm_pgoff)

