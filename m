From: Howard Cochran <hcochran@kernelspring.com>
Subject: Re: [PATCH] sd: Fix crash due to race when removing scsi disk
Date: Fri, 1 Jul 2016 12:22:46 -0400
Message-ID: <CAEvdpX3jsJrF-BVP+_z+iKA9AAJLiHnHmn1BQvzHCF+dLia3Rg@mail.gmail.com>
References: <1467389699-10571-1-git-send-email-hcochran@kernelspring.com> <CAEvdpX2E_qFrSwF3mTk2eFbczbinKn4ALVrS+sbfwLzJTYsJtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f51.google.com ([209.85.218.51]:34777 "EHLO
	mail-oi0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbcGAQXw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2016 12:23:52 -0400
Received: by mail-oi0-f51.google.com with SMTP id s66so117317765oif.1
        for <linux-scsi@vger.kernel.org>; Fri, 01 Jul 2016 09:22:47 -0700 (PDT)
In-Reply-To: <CAEvdpX2E_qFrSwF3mTk2eFbczbinKn4ALVrS+sbfwLzJTYsJtg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Howard Cochran <hcochran@kernelspring.com>, Howard Cochran <cochran@lexmark.com>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>

On Fri, Jul 1, 2016 at 12:19 PM, Howard Cochran
<hcochran@kernelspring.com> wrote:
> On Fri, Jul 1, 2016 at 12:14 PM, Howard Cochran
> <hcochran@kernelspring.com> wrote:
>> This crash occurred while writing 1 to /sys/block/sda/device/delete at
>> the same instant that another process was closing the block device:
>>
>>  BUG: unable to handle kernel NULL pointer dereference at 00000230

>> This patch fixes the race by making sd_remove() hold bd_mutex during the
>> call to del_gendisk().
>>
>> Fixes: de1414a654e6 ("fs: export inode_to_bdi and use it in favor of
>> mapping->backing_dev_info")
>> Signed-off-by: Howard Cochran <hcochran@kernelspring.com>

Here is a method to reproduce this bug:

You need a system with a SATA or other scsi-disk that you are prepared to
overwrite destructively.

Apply this patch, to exaggerate the race window in the kernel. Obviously,
this isn't strictly necessary, but the window is normally small, so it can
be tricky to reproduce otherwise.

-------- [ Begin patch to exaggerate race window ] --------

>From 336b6ce99adb544f4b475e8f25acfd442504e3dc Mon Sep 17 00:00:00 2001
From: Auto Configured <auto.configured>
Date: Thu, 30 Jun 2016 18:04:21 -0400
Subject: [PATCH] HACK: Widen window to expose sd_remove() race

---
 mm/filemap.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/filemap.c b/mm/filemap.c
index f2479af..c097591 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -35,6 +35,7 @@
 #include <linux/memcontrol.h>
 #include <linux/cleancache.h>
 #include <linux/rmap.h>
+#include <linux/delay.h>
 #include "internal.h"

 #define CREATE_TRACE_POINTS
@@ -308,6 +309,11 @@ int __filemap_fdatawrite_range(struct
address_space *mapping, loff_t start,
  .range_end = end,
  };

+ if (!strcmp(current->comm, "scsi_del_bug")) {
+ printk("BEFORE: 0x%p\n", I_BDEV(mapping->host)->bd_disk);
+ msleep(5000);
+ printk("AFTER : 0x%p\n", I_BDEV(mapping->host)->bd_disk);
+ }
  if (!mapping_cap_writeback_dirty(mapping))
  return 0;

-- 
2.4.11
-------- [ End patch ] --------


Save the following script with the name "scsci_del_bug".  This name must
match exactly, because the patch above tests for it (yes, hacky-hacky). Edit
it to change blk_dev_to_overwrite= to the device you want it to overwrite.
Running this script should cause the NULL pointer crash in the kernel.

-------- [ Begin script - Must be named "scsi_del_bug" ] --------

#!/bin/sh
# WARNING WARNING: THIS SCRIPT WILL OVERWRITE A BLOCK DEVICE!

# Set this to the disk device to overwrite:
blk_dev_to_overwrite=sda

# Tracing mount point (We _rely_ on tracing)
tracedir=/sys/kernel/debug/tracing

# Set up tracing but don't start it yet
echo 0 > $tracedir/tracing_on
echo > $tracedir/trace
echo 1024 > $tracedir/buffer_size_kb
echo 1 > $tracedir/events/syscalls/sys_enter_close/enable


# Create a bunch of dirty disk data (DESTRUCTIVE!!!!)
dd if=/dev/zero of=/dev/$blk_dev_to_overwrite bs=1M count=500 &
pid=$!

# Get tracing to say when dd begins to close its output file & wait for it
echo "common_pid == ${pid} && fd == 1" >
$tracedir/events/syscalls/sys_enter_close/filter
echo 1 > $tracedir/tracing_on
read FOO < $tracedir/trace_pipe

echo "Deleting disk device (while dd is still in close())"
echo 1 > /sys/block/sda/device/delete

-------- [ End scsi_del_bug script ] --------
