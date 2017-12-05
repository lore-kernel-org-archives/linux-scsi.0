From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI: run queue if SCSI device queue isn't ready and queue is idle
Date: Tue, 05 Dec 2017 15:29:55 +0100
Message-ID: <mqd374ptfh8.fsf@linux-x5ow.site>
References: <20171205075256.10319-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171205075256.10319-1-ming.lei@redhat.com> (Ming Lei's message
        of "Tue, 5 Dec 2017 15:52:56 +0800")
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Omar Sandoval <osandov@osandov.com>
Cc: Jens Axboe <axboe@fb.com>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>, Bart Van Assche <bart.vanassche@sandisk.com>, linux-kernel@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Holger =?utf-8?Q?Hoffst=C3=A4tte?= <holger@applied-asynchrony.com>
List-Id: linux-scsi@vger.kernel.org

[ +Cc Omar ]

Ming Lei <ming.lei@redhat.com> writes:
> Before commit 0df21c86bdbf ("scsi: implement .get_budget and .put_budget
> for blk-mq"), we run queue after 3ms if queue is idle and SCSI device
> queue isn't ready, which is done in handling BLK_STS_RESOURCE. After
> commit 0df21c86bdbf is introduced, queue won't be run any more under
> this situation.
>
> IO hang is observed when timeout happened, and this patch fixes the IO
> hang issue by running queue after delay in scsi_dev_queue_ready, just like
> non-mq. This issue can be triggered by the following script[1].
>
> There is another issue which can be covered by running idle queue:
> when .get_budget() is called on request coming from hctx->dispatch_list,
> if one request just completes during .get_budget(), we can't depend on
> SCSI's restart to make progress any more. This patch fixes the race too.
>
> With this patch, we basically recover to previous behaviour(before commit
> 0df21c86bdbf) of handling idle queue when running out of resource.
>
> [1] script for test/verify SCSI timeout
> rmmod scsi_debug
> modprobe scsi_debug max_queue=1
>
> DEVICE=`ls -d /sys/bus/pseudo/drivers/scsi_debug/adapter*/host*/target*/*/block/* | head -1 | xargs basename`
> DISK_DIR=`ls -d /sys/block/$DEVICE/device/scsi_disk/*`
>
> echo "using scsi device $DEVICE"
> echo "-1" >/sys/bus/pseudo/drivers/scsi_debug/every_nth
> echo "temporary write through" >$DISK_DIR/cache_type
> echo "128" >/sys/bus/pseudo/drivers/scsi_debug/opts
> echo none > /sys/block/$DEVICE/queue/scheduler
> dd if=/dev/$DEVICE of=/dev/null bs=1M iflag=direct count=1 &
> sleep 5
> echo "0" >/sys/bus/pseudo/drivers/scsi_debug/opts
> wait
> echo "SUCCESS"

SO I turned the above into a blktest but have found some shortcommings
of my bash skills. Maybe you or Omar has a soution for it:

--- 8< ---
>From 80e5810011d52bc188cd858962ce202bfd4dbee5 Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <jthumshirn@suse.de>
Date: Tue, 5 Dec 2017 15:21:08 +0100
Subject: [PATCH blktests] block/013: add test for scsi_device queue starvation

Add a test for Ming Lei's patch titled "SCSI: run queue if SCSI device
queue isn't ready and queue is idle"

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>

---
This test case has two shortcommings, which need to be addressed I'm
just lacking a bit of the shell magic to address them properly.

1) Testing without the patch applied hangs the test forever as it
   doesn't get killed after a specific timeout (I think this should be
   solved in a common function).
2) It has a nasty sleep at it's end to wait for scsi_debug's refcounts
   to drop to 0 before removing the module or removing will fail and thus
   the test case. This as well should be solved in a more generic way.
---
 tests/block/013     | 63 +++++++++++++++++++++++++++++++++++++++++++++++++++++
 tests/block/013.out |  2 ++
 2 files changed, 65 insertions(+)
 create mode 100755 tests/block/013
 create mode 100644 tests/block/013.out

diff --git a/tests/block/013 b/tests/block/013
new file mode 100755
index 000000000000..f73724fc9ed2
--- /dev/null
+++ b/tests/block/013
@@ -0,0 +1,63 @@
+#!/bin/bash
+#
+# Regression test for patch "SCSI: delay run queue if device is
+# blocked in scsi_dev_queue_ready()"
+#
+# Copyright (C) 2017 Johannes Thumshirn
+#
+# This program is free software: you can redistribute it and/or modify
+# it under the terms of the GNU General Public License as published by
+# the Free Software Foundation, either version 3 of the License, or
+# (at your option) any later version.
+#
+# This program is distributed in the hope that it will be useful,
+# but WITHOUT ANY WARRANTY; without even the implied warranty of
+# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+# GNU General Public License for more details.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program.  If not, see <http://www.gnu.org/licenses/>.
+
+. common/scsi_debug
+
+DESCRIPTION="Test if a SCSI device's queue can be run if it isn't ready but the device is idle"
+TIMED=1
+
+requires() {
+	_have_scsi_debug && _have_module sd_mod && \
+		grep -q Y /sys/module/scsi_mod/parameters/use_blk_mq
+}
+
+test_one_device()
+{
+    local device=$1
+
+    echo "-1" > /sys/bus/pseudo/drivers/scsi_debug/every_nth
+    echo "temporary write through" > \
+	/sys/block/"${device}"/device/scsi_disk/"$(basename $(readlink /sys/block/${device}/device))"/cache_type
+    echo "128" > /sys/bus/pseudo/drivers/scsi_debug/opts
+    echo "none" > /sys/block/${device}/queue/scheduler
+    dd if=/dev/"${device}" of=/dev/null bs=1M iflag=direct \
+	count=1 2> /dev/null &
+    sleep 5
+    echo 0 > /sys/bus/pseudo/drivers/scsi_debug/opts
+    wait
+}
+
+test() {
+	echo "Running ${TEST_NAME}"
+
+	if ! _init_scsi_debug statistics=1 max_queue=1; then
+		return
+	fi
+
+	local device
+	for device in "${SCSI_DEBUG_DEVICES[@]}"; do
+	    test_one_device ${device}	    
+	done
+
+	sleep 5 # to free up all scsi_debug refcnts
+	_exit_scsi_debug
+
+	echo "Test complete"
+}
diff --git a/tests/block/013.out b/tests/block/013.out
new file mode 100644
index 000000000000..947bd04e2104
--- /dev/null
+++ b/tests/block/013.out
@@ -0,0 +1,2 @@
+Running block/013
+Test complete
-- 
2.13.6



-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
