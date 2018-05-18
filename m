From: Alexander Potapenko <glider@google.com>
Subject: [PATCH] scsi: sg: allocate with __GFP_ZERO in sg_build_indirect()
Date: Fri, 18 May 2018 16:23:18 +0200
Message-ID: <20180518142318.200260-1-glider@google.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: jthumshirn@suse.de, jejb@linux.vnet.ibm.com, dgilbert@interlog.com
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, linux-scsi@vger.kernel.org, dvyukov@google.com, hare@suse.com, torvalds@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

This shall help avoid copying uninitialized memory to the userspace
when calling ioctl(fd, SG_IO) with an empty command.

Reported-by: syzbot+7d26fc1eea198488deab@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Potapenko <glider@google.com>
Acked-by: Douglas Gilbert <dgilbert@interlog.com>
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/sg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index c198b96368dd..5c40d809830f 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -1894,7 +1894,7 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
 		num = (rem_sz > scatter_elem_sz_prev) ?
 			scatter_elem_sz_prev : rem_sz;
 
-		schp->pages[k] = alloc_pages(gfp_mask, order);
+		schp->pages[k] = alloc_pages(gfp_mask | __GFP_ZERO, order);
 		if (!schp->pages[k])
 			goto out;
 
-- 
2.17.0.441.gb46fe60e1d-goog
