From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: scsi-mq
Date: Wed, 18 Jun 2014 09:09:13 +0200
Message-ID: <53A13B19.2010305@acm.org>
References: <1402580946-11470-1-git-send-email-hch@lst.de> <53A05068.4080702@acm.org> <53A10B3A.6050705@kernel.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from baptiste.telenet-ops.be ([195.130.132.51]:41859 "EHLO
	baptiste.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751749AbaFRHJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jun 2014 03:09:18 -0400
In-Reply-To: <53A10B3A.6050705@kernel.dk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Robert Elliot <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On 06/18/14 05:44, Jens Axboe wrote:
> Thanks for posting these numbers, Bart. The CPU utilization and IOPS
> speak a very clear message. The only mystery is why the singe threaded
> performance is down. That we need to get sort, but it's not a show
> stopper for inclusion.
> 
> If you run the single threaded tests and watch for queue depths, is
> there a difference between blk-mq=y/scsi-mq and the stock kernel?

Hello Jens,

Fio reports the same queue depth for use_blk_mq=Y (mq below) and 
use_blk_mq=N (sq below), namely ">=64". However, the number of context
switches differs significantly for the random read-write tests. From
the fio output for these tests:

$ grep ctx= {sq,mq}/randrw*
sq/randrw-1.txt:  cpu          : usr=10.25%, sys=89.42%, ctx=2210, majf=0, minf=1
sq/randrw-2.txt:  cpu          : usr=10.23%, sys=89.34%, ctx=5003, majf=0, minf=2
sq/randrw-3.txt:  cpu          : usr=9.36%, sys=90.21%, ctx=7947, majf=0, minf=3
sq/randrw-4.txt:  cpu          : usr=8.96%, sys=90.10%, ctx=19308, majf=0, minf=4
sq/randrw-5.txt:  cpu          : usr=8.97%, sys=89.70%, ctx=31494, majf=0, minf=5
sq/randrw-6.txt:  cpu          : usr=8.39%, sys=90.08%, ctx=47826, majf=0, minf=6
sq/randrw-7.txt:  cpu          : usr=7.65%, sys=89.65%, ctx=130563, majf=0, minf=7
sq/randrw-8.txt:  cpu          : usr=6.47%, sys=84.08%, ctx=753140, majf=0, minf=8
mq/randrw-1.txt:  cpu          : usr=1.43%, sys=14.43%, ctx=500998, majf=0, minf=1
mq/randrw-2.txt:  cpu          : usr=1.37%, sys=14.13%, ctx=979842, majf=0, minf=2
mq/randrw-3.txt:  cpu          : usr=1.47%, sys=14.81%, ctx=1547996, majf=0, minf=3
mq/randrw-4.txt:  cpu          : usr=1.79%, sys=16.51%, ctx=2321154, majf=0, minf=4
mq/randrw-5.txt:  cpu          : usr=2.49%, sys=22.09%, ctx=4145747, majf=0, minf=5
mq/randrw-6.txt:  cpu          : usr=2.98%, sys=27.07%, ctx=6356183, majf=0, minf=6
mq/randrw-7.txt:  cpu          : usr=3.39%, sys=30.48%, ctx=8675960, majf=0, minf=7
mq/randrw-8.txt:  cpu          : usr=3.37%, sys=31.46%, ctx=10462001, majf=0, minf=8

It seems like with the traditional SCSI mid-layer and block core (sq)
that the number of context switches does not depend too much on the
number of I/O operations but that for the multi-queue SCSI core there
are a little bit more than two context switches per I/O in the
particular test I ran. The "randrw" script I used for this test takes
SCSI LUNs as arguments (/dev/sdX) and starts the fio tool as follows:

for d in "$@"; do
    if [ ! -e "$d" ]; then
	echo "Error: device $d not found."
	exit 1
    fi
    bdev="/sys/class/block/$(basename $d)"
    if [ -e $bdev/queue ]; then
	echo 0    >$bdev/queue/add_random
	echo 0    >$bdev/queue/rotational
	echo 2    >$bdev/queue/rq_affinity
	echo noop >$bdev/queue/scheduler
    fi
done

"$(dirname $0)"/disable-frequency-scaling

fio --bs=512 --ioengine=libaio --rw=randrw --iodepth=128          \
    --iodepth_batch=64 --iodepth_batch_complete=64                \
    --buffered=0 --norandommap --thread --loops=$((2**31))        \
    --runtime=60 --group_reporting --gtod_reduce=1 --invalidate=1 \
    $(for d in "$@"; do echo --name=$d --filename=$d; done)

"$(dirname $0)"/restore-frequency-scaling

Bart.
