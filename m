From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Performance degradation in IO writes vs. reads (was scsi-mq V2)
Date: Thu, 21 Aug 2014 15:32:09 +0300
Message-ID: <53F5E6C9.1020207@dev.mellanox.co.il>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org> <53C39F36.9010003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <53C39F36.9010003@dev.mellanox.co.il>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, viro@ZenIV.linux.org.uk
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, linux-fsdevel@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>, Max Gurtovoy <maxg@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 7/14/2014 12:13 PM, Sagi Grimberg wrote:

<SNIP>

> I'd like to share some benchmarks I took on this patch set using iSER
> initiator (+2 pre-submitted performance improvements) vs LIO iSER target.
> I ran workloads I think are interesting use-cases (single LUN with 1,2,4
> IO threads up to a fully occupied system doing IO to multiple LUNs).
> Overall (except 2 strange anomalies) seems that scsi-mq patches
> (use_blk_mq=N) roughly sustains traditional scsi performance.
> On the other hand scsi-mq code path (use_blk_mq=Y) on its own clearly
> shows better performance (tables below).
>
> At first I too hit the aio issues discussed in this thread and converted
> to scsi-mq.3-no-rebase for testing (thanks Doug & Rob for raising it).
> I must say that for some reason I get very low numbers for writes vs.
> reads (writes perf stuck at ~20K IOPs per thread), this happens
> on 3.16-rc2 even before scsi-mq patches. Did anyone step on this as well
> or is it just a weird problem I'm having in my setup?
> Anyway this is why my benchmarks shows only randread IO pattern (getting
> familiar numbers). I need to figure out whats wrong
> with IO writes - I'll start bisecting on this.
>

Hi,

So I just got back to checking this issue of *extremely low* IO write
performance I got in 3.16-rc2.

Reminder:
I used iSER to benchmark Christoph's scsi-mq patches performance and
noticed that direct-IO writes are stuck at 20-50K IOPs instead of 350K
IOPs I was used to see for a single device. This issue existed also when
I removed the scsi-mq patches, so I started bisecting to see what broke
stuff.

Finally I got to the completely unbisectable bulk that seems to yield
the issue:

/* IO write poor performance*/
2b777c9 ceph_sync_read: stop poking into iov_iter guts
f0d1bec new helper: copy_page_from_iter()
84c3d55 fuse: switch to ->write_iter()
b30ac0f btrfs: switch to ->write_iter()
3ef045c ocfs2: switch to ->write_iter()
bf97f3b xfs: switch to ->write_iter()
50b5551 afs: switch to ->write_iter()
da56e45 gfs2: switch to ->write_iter()
edaf436 nfs: switch to ->write_iter()
f5674c3 ubifs: switch to ->write_iter()
a8f3550 bury __generic_file_aio_write()
3dae875 cifs: switch to ->write_iter()
d4637bc udf: switch to ->write_iter()
9b88416 convert ext4 to ->write_iter()
a832475 Merge ext4 changes in ext4_file_write() into for-next
1456c0a blkdev_aio_write() - turn into blkdev_write_iter()
8174202 write_iter variants of {__,}generic_file_aio_write()
3644424 ceph: switch to ->read_iter()
3aa2d19 nfs: switch to ->read_iter()
a886038 fs/block_dev.c: switch to ->read_iter()
2ba5bbe shmem: switch to ->read_iter()
fb9096a pipe: switch to ->read_iter()
e6a7bcb cifs: switch to ->read_iter()
37c20f1 fuse_file_aio_read(): convert to ->read_iter()
3cd9ad5 ocfs2: switch to ->read_iter()
0279782 ecryptfs: switch to ->read_iter()
b4f5d2c xfs: switch to ->read_iter()
aad4f8b switch simple generic_file_aio_read() users to ->read_iter()
293bc98 new methods: ->read_iter() and ->write_iter()
7f7f25e replace checking for ->read/->aio_read presence with check in 
->f_mode
b318891 xfs: trim the argument lists of xfs_file_{dio,buffered}_aio_write()
37938463 blkdev_aio_read(): switch to generic_file_read_iter(), get rid 
of iov_shorten()
0c94933 iov_iter_truncate()
28060d5 btrfs: switch check_direct_IO() to iov_iter
91f79c4 new helper: iov_iter_get_pages_alloc()
f67da30 new helper: iov_iter_npages()
5b46f25 f2fs: switch to iov_iter_alignment()
c9c37e2 fuse: switch to iov_iter_get_pages()
d22a943 fuse: pull iov_iter initializations up
7b2c99d new helper: iov_iter_get_pages()
3320c60 dio: take updating ->result into do_direct_IO(
71d8e53 start adding the tag to iov_iter
ed978a8 new helper: generic_file_read_iter()
23faa7b fuse_file_aio_write(): merge initializations of iov_iter
05bb2e0 ceph_aio_read(): keep iov_iter across retries
886a391 new primitive: iov_iter_alignment()
26978b8 give ->direct_IO() a copy of iov_iter
31b1403 switch {__,}blockdev_direct_IO() to iov_iter
a6cbcd4 get rid of pointless iov_length() in ->direct_IO()
16b1f05 ext4: switch the guts of ->direct_IO() to iov_iter
619d30b convert the guts of nfs_direct_IO() to iov_iter
d8d3d94 pass iov_iter to ->direct_IO()
cb66a7a kill generic_segment_checks()
0ae5e4d __btrfs_direct_write(): switch to iov_iter
f8579f8 generic_file_direct_write(): switch to iov_iter
e7c2460 kill iov_iter_copy_from_user()
f6c0a19 fs/file.c: don't open-code kvfree()
/* IO write performance is OK*/

I tried to isolate the issue by running fio on a null_blk
device and also got performance degradation although it wasn't
as severe as with iSER/iSCSI. IO write performance decreased
from 360K IOPs to 280 KIOPs.

So at the moment I can't pin point the problem, but I figured
I'd raise the issue in case anyone else had stepped on this one
(hard to imagine that no one saw this...)

I'll run perf comparison to see if I get anything interesting.

CC'ing Al Viro, the author of all the above commits.

Cheers,
Sagi.
