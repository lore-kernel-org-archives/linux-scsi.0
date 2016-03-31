From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Thu, 31 Mar 2016 16:04:22 -0400
Message-ID: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:37663 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571AbcCaUE1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Mar 2016 16:04:27 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dm-devel@redhat.com
Cc: jmoyer@redhat.com, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org, j-nomura@ce.jp.nec.com, hare@suse.de, sagig@dev.mellanox.co.il, Mike Snitzer <snitzer@redhat.com>

I developed these changes some weeks ago but have since focused on
regression and performance testing on larger NUMA systems.

For regression testing I've been using mptest:
https://github.com/snitm/mptest

For performance testing I've been using a null_blk device (with
various configuration permutations, e.g. pinning memory to a
particular NUMA node, and varied number of submit_queues).

By eliminating multipath's heavy use of the m->lock spinlock in the
fast IO paths serious performance improvements are realized.

Overview of performance test setup:
===================================

NULL_BLK_HW_QUEUES=12
NULL_BLK_QUEUE_DEPTH=4096

DM_MQ_HW_QUEUES=12
DM_MQ_QUEUE_DEPTH=2048

FIO_QUEUE_DEPTH=32
FIO_RUNTIME=10
FIO_NUMJOBS=12

NID=0

run_fio() {
    DEVICE=$1
    TASK_NAME=$(basename ${DEVICE})
    PERF_RECORD=$2
    RUN_CMD="${FIO} --numa_cpu_nodes=${NID} --numa_mem_policy=bind:${NID} --cpus_allowed_policy=split --group_reporting --rw=randread --bs=4k --numjobs=${FIO_NUMJOBS} \
              --iodepth=${FIO_QUEUE_DEPTH} --runtime=${FIO_RUNTIME} --time_based --loops=1 --ioengine=libaio \
              --direct=1 --invalidate=1 --randrepeat=1 --norandommap --exitall --name task_${TASK_NAME} --filename=${DEVICE}"
    ${RUN_CMD}
}

modprobe null_blk gb=4 bs=512 hw_queue_depth=${NULL_BLK_QUEUE_DEPTH} nr_devices=1 queue_mode=2 irqmode=1 completion_nsec=1 submit_queues=${NULL_BLK_HW_QUEUES}
run_fio /dev/nullb0

echo ${NID} > /sys/module/dm_mod/parameters/dm_numa_node
echo Y > /sys/module/dm_mod/parameters/use_blk_mq
echo ${DM_MQ_QUEUE_DEPTH} > /sys/module/dm_mod/parameters/dm_mq_queue_depth
echo ${DM_MQ_HW_QUEUES} > /sys/module/dm_mod/parameters/dm_mq_nr_hw_queues
echo "0 8388608 multipath 0 0 1 1 service-time 0 1 2 /dev/nullb0 1 1" | dmsetup create dm_mq
run_fio /dev/mapper/dm_mq
dmsetup remove dm_mq

echo "0 8388608 multipath 0 0 1 1 queue-length 0 1 1 /dev/nullb0 1" | dmsetup create dm_mq
run_fio /dev/mapper/dm_mq
dmsetup remove dm_mq

echo "0 8388608 multipath 0 0 1 1 round-robin 0 1 1 /dev/nullb0 1" | dmsetup create dm_mq
run_fio /dev/mapper/dm_mq
dmsetup remove dm_mq

Test results on 4 NUMA node 192-way x86_64 system with 524G of memory:
======================================================================

Big picture is the move to lockless really helps.

round-robin's repeat_count and percpu current_path code (went upstream
during 4.6 merge) seems to _really_ help (even if repeat_count is 1, as
is the case in all these results).

Below, each set of 4 results in the named file (e.g. "result.lockless_pinned") are:
raw null_blk
service-time
queue-length
round-robin

The files with the trailing "_12" means:
NULL_BLK_HW_QUEUES=12
DM_MQ_HW_QUEUES=12
FIO_NUMJOBS=12

And the file without "_12" means:
NULL_BLK_HW_QUEUES=32
DM_MQ_HW_QUEUES=32
FIO_NUMJOBS=32

lockless: (this patchset applied)
*********
result.lockless_pinned:  read : io=236580MB, bw=23656MB/s, iops=6055.9K, runt= 10001msec
result.lockless_pinned:  read : io=108536MB, bw=10853MB/s, iops=2778.3K, runt= 10001msec
result.lockless_pinned:  read : io=106649MB, bw=10664MB/s, iops=2729.1K, runt= 10001msec
result.lockless_pinned:  read : io=162906MB, bw=16289MB/s, iops=4169.1K, runt= 10001msec

result.lockless_pinned_12:  read : io=165233MB, bw=16522MB/s, iops=4229.6K, runt= 10001msec
result.lockless_pinned_12:  read : io=96686MB, bw=9667.7MB/s, iops=2474.1K, runt= 10001msec
result.lockless_pinned_12:  read : io=97197MB, bw=9718.8MB/s, iops=2488.3K, runt= 10001msec
result.lockless_pinned_12:  read : io=104509MB, bw=10450MB/s, iops=2675.2K, runt= 10001msec

result.lockless_unpinned:  read : io=101525MB, bw=10151MB/s, iops=2598.8K, runt= 10001msec
result.lockless_unpinned:  read : io=61313MB, bw=6130.8MB/s, iops=1569.5K, runt= 10001msec
result.lockless_unpinned:  read : io=64892MB, bw=6488.6MB/s, iops=1661.8K, runt= 10001msec
result.lockless_unpinned:  read : io=78557MB, bw=7854.1MB/s, iops=2010.9K, runt= 10001msec

result.lockless_unpinned_12:  read : io=83455MB, bw=8344.7MB/s, iops=2136.3K, runt= 10001msec
result.lockless_unpinned_12:  read : io=50638MB, bw=5063.4MB/s, iops=1296.3K, runt= 10001msec
result.lockless_unpinned_12:  read : io=56103MB, bw=5609.8MB/s, iops=1436.1K, runt= 10001msec
result.lockless_unpinned_12:  read : io=56421MB, bw=5641.6MB/s, iops=1444.3K, runt= 10001msec

spinlock:
*********
result.spinlock_pinned:  read : io=236048MB, bw=23602MB/s, iops=6042.3K, runt= 10001msec
result.spinlock_pinned:  read : io=64657MB, bw=6465.4MB/s, iops=1655.5K, runt= 10001msec
result.spinlock_pinned:  read : io=67519MB, bw=6751.2MB/s, iops=1728.4K, runt= 10001msec
result.spinlock_pinned:  read : io=81409MB, bw=8140.4MB/s, iops=2083.9K, runt= 10001msec

result.spinlock_pinned_12:  read : io=159782MB, bw=15977MB/s, iops=4090.3K, runt= 10001msec
result.spinlock_pinned_12:  read : io=64368MB, bw=6436.2MB/s, iops=1647.7K, runt= 10001msec
result.spinlock_pinned_12:  read : io=67337MB, bw=6733.5MB/s, iops=1723.7K, runt= 10001msec
result.spinlock_pinned_12:  read : io=75453MB, bw=7544.6MB/s, iops=1931.5K, runt= 10001msec

result.spinlock_unpinned:  read : io=103267MB, bw=10326MB/s, iops=2643.4K, runt= 10001msec
result.spinlock_unpinned:  read : io=34751MB, bw=3474.8MB/s, iops=889526, runt= 10001msec
result.spinlock_unpinned:  read : io=34475MB, bw=3447.2MB/s, iops=882477, runt= 10001msec
result.spinlock_unpinned:  read : io=43793MB, bw=4378.1MB/s, iops=1121.0K, runt= 10001msec

result.spinlock_unpinned_12:  read : io=83573MB, bw=8356.5MB/s, iops=2139.3K, runt= 10001msec
result.spinlock_unpinned_12:  read : io=32715MB, bw=3271.2MB/s, iops=837414, runt= 10001msec
result.spinlock_unpinned_12:  read : io=34249MB, bw=3424.6MB/s, iops=876675, runt= 10001msec
result.spinlock_unpinned_12:  read : io=41486MB, bw=4148.3MB/s, iops=1061.1K, runt= 10001msec

Summary:
========
Pinning this test to a particular NUMA node helps.  As does using more
queues/threads -- which is a nice advance because before DM mpath
really hit a wall.

What makes these favorable results possible is switching over to
bitops, atomic counters and lockless_deference.

Comparing result.lockless_pinned vs result.spinlock_pinned you can see
that this patchset delivers between 40 and 50% IOPs and bandwidth
performance improvement.

Jeff Moyer has been helping review these changes (and has graciously
labored over _really_ understanding all the concurrency at play in DM
mpath) -- his review isn't yet complete but I wanted to get this
patchset out now to raise awareness about how I think DM multipath
will be changing (for inclussion during the Linux 4.7 merge window).

Mike Snitzer (4):
  dm mpath: switch to using bitops for state flags
  dm mpath: use atomic_t for counting members of 'struct multipath'
  dm mpath: move trigger_event member to the end of 'struct multipath'
  dm mpath: eliminate use of spinlock in IO fast-paths

 drivers/md/dm-mpath.c | 351 ++++++++++++++++++++++++++++----------------------
 1 file changed, 195 insertions(+), 156 deletions(-)

-- 
2.6.4 (Apple Git-63)

