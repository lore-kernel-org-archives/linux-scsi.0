From: Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: [PATCH 0/5] virtio-scsi: create a separate workqueue
Date: Wed, 7 Nov 2012 18:18:09 +0800
Message-ID: <1352283494-31200-1-git-send-email-gaowanlong@cn.fujitsu.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>, Paolo Bonzini <pbonzini@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, linux-scsi@vger.kernel.org, kvm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

patch 1-3,5 are some cleanups.
patch 4: create a separate work queue for virtio-scsi
to improve the performance, I tested with tmpfs backed
disk, the config file is like below,
[global]
bsrange=4k-64k
ioengine=libaio
direct=1
iodepth=4
loops=10
size=64M

Before:
Disk stats (read/write):
  sda: ios=6547/5275, merge=37/39, ticks=3144/2645, in_queue=5780, util=81.62%
  sdb: ios=6542/5277, merge=54/59, ticks=3234/3143, in_queue=6364, util=84.50%
  sdc: ios=6532/5244, merge=65/62, ticks=3440/3076, in_queue=6505, util=86.83%

After:
Disk stats (read/write):
  sda: ios=6349/5318, merge=77/89, ticks=4820/3169, in_queue=7991, util=90.62%
  sdb: ios=6364/5358, merge=39/53, ticks=3810/2816, in_queue=6615, util=84.63%
  sdc: ios=6458/5352, merge=74/47, ticks=4425/3048, in_queue=7459, util=88.41%


Wanlong Gao (5):
  virtio-scsi: remove the useless assignment
  virtio-scsi: remove the needless variable gfp_mask
  virtio-scsi: use pr_err instead of printk
  virtio-scsi: create a separate work queue for virtio-scsi
  virtio-scsi: tidy up the goto label in init()



Cc: James E.J. Bottomley <JBottomley@parallels.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-scsi@vger.kernel.org
Cc: kvm@vger.kernel.org
 drivers/scsi/virtio_scsi.c | 43 +++++++++++++++++++++++--------------------
 1 file changed, 23 insertions(+), 20 deletions(-)

-- 
1.8.0
