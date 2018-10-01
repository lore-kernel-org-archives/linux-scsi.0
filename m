From: Evan Green <evgreen@chromium.org>
Subject: [PATCH RESEND] scsi: sg: Prevent potential double frees in sg driver
Date: Mon,  1 Oct 2018 09:15:06 -0700
Message-ID: <20181001161506.100284-1-evgreen@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Gilbert <dgilbert@interlog.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Nick Desaulniers <ndesaulniers@google.com>, Christoph Hellwig <hch@infradead.org>, Robb Glasser <rglasser@google.com>, Evan Green <evgreen@chromium.org>, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Robb Glasser <rglasser@google.com>

sg_ioctl could be spammed by requests, leading to a double free in
__free_pages. This protects the entry points of sg_ioctl where the
memory could be corrupted by a double call to __free_pages if multiple
requests are happening concurrently.

Signed-off-by: Robb Glasser <rglasser@google.com>
Signed-off-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Evan Green <evgreen@chromium.org>
Cc: stable@vger.kernel.org

---
Reposting this patch from last summer, as it looks like it fell in between
the cracks.

 drivers/scsi/sg.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 8a254bb46a9b..25579d8a16b5 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -924,8 +924,10 @@ sg_ioctl(struct file *filp, unsigned int cmd_in, unsigned long arg)
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
2.19.0.605.g01d371f741-goog
