From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: [PATCH 4/4] virtio_blk: use disk_name_format() to support mass of
 disks naming
Date: Fri, 30 Mar 2012 17:53:52 +0800
Message-ID: <4F7582B0.5010609@cn.fujitsu.com>
References: <4F7581D4.4040301@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:18383 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1760591Ab2C3Jxd (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 30 Mar 2012 05:53:33 -0400
In-Reply-To: <4F7581D4.4040301@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Tejun Heo <tj@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, SCSI <linux-scsi@vger.kernel.org>, KVM <kvm@vger.kernel.org>, VIRTUAL <virtualization@lists.linux-foundation.org>

  The current virtblk's naming algorithm only supports 263  disks.
If there are mass of virtblks(exceeding 263), there will be disks
with the same name.

By renaming "sd_format_disk_name()" to "disk_name_format()"
and moving it into block core, virtio_blk can use this function to
support mass of disks.

Signed-off-by: Ren Mingxin <renmx@cn.fujitsu.com>
---
   virtio_blk.c |   13 +------------
  1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index c4a60ba..54612c2 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -442,18 +442,7 @@ static int __devinit virtblk_probe(struct 
virtio_device *vdev)

         q->queuedata = vblk;

-       if (index < 26) {
-               sprintf(vblk->disk->disk_name, "vd%c", 'a' + index % 26);
-       } else if (index < (26 + 1) * 26) {
-               sprintf(vblk->disk->disk_name, "vd%c%c",
-                       'a' + index / 26 - 1, 'a' + index % 26);
-       } else {
-               const unsigned int m1 = (index / 26 - 1) / 26 - 1;
-               const unsigned int m2 = (index / 26 - 1) % 26;
-               const unsigned int m3 =  index % 26;
-               sprintf(vblk->disk->disk_name, "vd%c%c%c",
-                       'a' + m1, 'a' + m2, 'a' + m3);
-       }
+       disk_name_format("vd", index, vblk->disk->disk_name, DISK_NAME_LEN);

         vblk->disk->major = major;
         vblk->disk->first_minor = index_to_minor(index);

