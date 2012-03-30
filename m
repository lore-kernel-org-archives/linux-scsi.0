From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 3/4] block: replace rssd_disk_name_format() to disk_name_format()
Date: Fri, 30 Mar 2012 17:53:27 +0800
Message-ID: <4F758297.5020600@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:17687 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760587Ab2C3JxI (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2012 05:53:08 -0400
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>

  Currently, block core has been supplied "disk_name_format()", so
we should remove duplicate function "rssd_disk_name_format()"
and use the new function to format rssd disk names.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
  mtip32xx.c |   33 +--------------------------------
  1 file changed, 1 insertion(+), 32 deletions(-)

diff --git a/drivers/block/mtip32xx/mtip32xx.c 
b/drivers/block/mtip32xx/mtip32xx.c
index 8eb81c9..8950bb5 100644
--- a/drivers/block/mtip32xx/mtip32xx.c
+++ b/drivers/block/mtip32xx/mtip32xx.c
@@ -2836,37 +2836,6 @@ static int mtip_hw_resume(struct driver_data *dd)
  }

  /*
- * Helper function for reusing disk name
- * upon hot insertion.
- */
-static int rssd_disk_name_format(char *prefix,
-                                int index,
-                                char *buf,
-                                int buflen)
-{
-       const int base = 'z' - 'a' + 1;
-       char *begin = buf + strlen(prefix);
-       char *end = buf + buflen;
-       char *p;
-       int unit;
-
-       p = end - 1;
-       *p = '\0';
-       unit = base;
-       do {
-               if (p == begin)
-                       return -EINVAL;
-               *--p = 'a' + (index % unit);
-               index = (index / unit) - 1;
-       } while (index >= 0);
-
-       memmove(begin, p, end - p);
-       memcpy(buf, prefix, strlen(prefix));
-
-       return 0;
-}
-
-/*
   * Block layer IOCTL handler.
   *
   * @dev Pointer to the block_device structure.
@@ -3140,7 +3109,7 @@ static int mtip_block_initialize(struct 
driver_data *dd)
         if (rv)
                 goto ida_get_error;

-       rv = rssd_disk_name_format("rssd",
+       rv = disk_name_format("rssd",
                                 index,
                                 dd->disk->disk_name,
                                 DISK_NAME_LEN);

