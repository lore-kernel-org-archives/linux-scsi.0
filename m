From: Nick Desaulniers <ndesaulniers@google.com>
Subject: [PATCH] scsi: sg: Prevent potential double frees in sg driver
Date: Thu,  3 Aug 2017 12:02:47 -0700
Message-ID: <20170803190248.51537-1-ndesaulniers@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
Cc: hare@suse.de, jthumshirn@suse.de, hch@lst.de, salyzyn@google.com, gregkh@linuxfoundation.org, Robb Glasser <rglasser@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Robb Glasser <rglasser@google.com>

sg_ioctl could be spammed by requests, leading to a double free in
__free_pages. This protects the entry points of sg_ioctl where the
memory could be corrupted by a double call to __free_pages if multiple
requests are happening concurrently.

Signed-off-by: Robb Glasser <rglasser@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
---
 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 4fe606b000b4..40fe71f4c863 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -883,8 +883,10 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
 			return -ENXIO;
 		if (!access_ok(VERIFY_WRITE, p, SZ_SG_IO_HDR))
 			return -EFAULT;
+		mutex_lock(&sfp->parentdp->open_rel_lock);
 		result = sg_new_write(sfp, filp, p, SZ_SG_IO_HDR,
 				 1, read_only, 1, &srp);
+		mutex_unlock(&sfp->parentdp->open_rel_lock);
 		if (result < 0)
 			return result;
 		result = wait_event_interruptible(sfp->read_wait,
-- 
2.14.0.rc1.383.gd1ce394fe2-goog
