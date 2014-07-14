From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: scsi-mq V2
Date: Mon, 14 Jul 2014 12:13:26 +0300
Message-ID: <53C39F36.9010003@dev.mellanox.co.il>
References: <1403715121-1201-1-git-send-email-hch@lst.de> <20140708144829.GA5539@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20140708144829.GA5539@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jens Axboe <axboe@kernel.dk>, Bart Van Assche <bvanassche@fusionio.com>, Robert Elliott <Elliott@hp.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Or Gerlitz <ogerlitz@mellanox.com>, Oren Duer <oren@mellanox.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, Bart Van Assche <bvanassche@acm.org>
List-Id: linux-scsi@vger.kernel.org

On 7/8/2014 5:48 PM, Christoph Hellwig wrote:
<SNIP>
> I've pushed out a new scsi-mq.3 branch, which has been rebased on the
> latest core-for-3.17 tree + the "RFC: clean up command setup" series
> from June 29th.  Robert Elliot found a problem with not fully zeroed
> out UNMAP CDBs, which is fixed by the saner discard handling in that
> series.
>
> There is a new patch to factor the code from the above series for
> blk-mq use, which I've attached below.  Besides that the only changes
> are minor merge fixups in the main blk-mq usage patch.

Hey Christoph & Co,

I'd like to share some benchmarks I took on this patch set using iSER=20
initiator (+2 pre-submitted performance improvements) vs LIO iSER targe=
t.
I ran workloads I think are interesting use-cases (single LUN with 1,2,=
4=20
IO threads up to a fully occupied system doing IO to multiple LUNs).
Overall (except 2 strange anomalies) seems that scsi-mq patches=20
(use_blk_mq=3DN) roughly sustains traditional scsi performance.
On the other hand scsi-mq code path (use_blk_mq=3DY) on its own clearly=
=20
shows better performance (tables below).

At first I too hit the aio issues discussed in this thread and converte=
d=20
to scsi-mq.3-no-rebase for testing (thanks Doug & Rob for raising it).
I must say that for some reason I get very low numbers for writes vs.=20
reads (writes perf stuck at ~20K IOPs per thread), this happens
on 3.16-rc2 even before scsi-mq patches. Did anyone step on this as wel=
l=20
or is it just a weird problem I'm having in my setup?
Anyway this is why my benchmarks shows only randread IO pattern (gettin=
g=20
familiar numbers). I need to figure out whats wrong
with IO writes - I'll start bisecting on this.

I also reviewed the patch set and at this point, I don't have any=20
comments. So you can add to the series:
Reviewed-by: Sagi Grimberg '<sagig@dev.mellanox.co.il>' (or Tested-by -=
=20
whatever you choose).

I want to state that I tested a traditional iSER initiator - no scsi-mq=
=20
adoption at all.
I started looking into adopting scsi-mq to iSCSI/iSER recently and I=20
must that say the scsi-mq adoption is not so
trivial due to iSCSI session-wide CmdSN/StatSN ordering constraints=20
(can't just use more RDMA channels per connection...)
I'll be on vacation for the next couple of weeks, so I'll start a=20
separate thread to get the community input on this matter.


Results: table entries are KIOPS(CPU%)
3.16-rc2 (scsi-mq patches reverted)
    Threads/LUN   1           2            4
#LUNs
  1             231(6.5%)   355(18.5%)   337(31.1%)
  2             446(13.6%)  673(37.2%)   654(49.8%)
  4             594(25%)    960(49.41%) 1165(99.3%)
  8            1018(50.3%) 1563(99.6%)  1696(99.9%)
  16           1660(86.5%) 1731(99.6%)  1710(100%)


3.16-rc2 (scsi-mq included, use_blk_mq=3DN)
    Threads/LUN   1           2            4
#LUNs
  1             231(6.5%)   351(18.5%)   337(31.4%)
  2             446(13.6%)  660(37.3%)   647(50%)
  4             591(25%)    967(49.7%)  1136(98.1%)
  8            1014(52.1%) 1296(100%)   1470(100%)
  16           1741(100%)  1761(100%)   1853(100%)


3.16-rc2 (scsi-mq included, use_blk_mq=3DY)
    Threads/LUN   1           2            4
#LUNs
  1             265(6.4%)   465(13.4%)   572(27.9%)
  2             507(13.4%)  902(27.8%)  1034(45.9%)
  4             697(25%)   1197(49.5%)  1477(98.6%)
  8            1257(53.6%) 1856(98.7%)  1906(100%)
  16           1991(100%)  2021(100%)   2020(100%)

Notes:
     - IOPs measurements are the average of a 60 seconds runs.
     - The CPU measurement is the total usage across all CPUs, In order
       to understand per-CPU utilization value should be normalized to =
16
       cores.
     - scsi_mq (use_blk_mq=3DN) has roughly the same performance as
       traditional scsi IO path but I see an anomaly in test cases
       {8 LUNs, 2/4 threads per LUN}. This may result in NUMA
       misalignment for threads/interrupts =96 requires further
       investigation.
     - iSER initiator has no Multi-Queue awareness.

Testing environment:
     - Initiator and target systems of 16 (8x2) cores (Hyperthreading
       disabled).
     - CPU model: Intel(R) Xeon(R) @ 2.60GHz
     - Block Layer settings:
     - scheduler=3Dnoop
         - rq_affinity=3D1
         - add_random=3D0
         - nomerges=3D1
     - Single FDR link between the target and initiator.
     - Device model: Mellanox ConnectIB (the numbers are also familiar
       with Mellanox ConnectX-3).
     - MSIX interrupt vectors were spread across system cores.
     - irqbalancer was disabled.
     - scsi_host settings:
         - cmd_per_lun=3D32 (default)
         - can_queue=3D113 (default)
     - In the multi-LUN test cases, each LUN exposed via different
       scsi_host (iSCSI session).

Software:
     - fio version: 2.0.13
     - LIO iSER target (target-pending for-next)
     - Null backing devices (NULLIO)
     - Upstream based iSER initiator + internal pre-submitted
       performance enhancements.

fio configuration:
rw=3Drandread
bs=3D1k
iodepth=3D128
loops=3D1
ioengine=3Dlibaio
direct=3D1
invalidate=3D1
fsync_on_close=3D1
randrepeat=3D1
norandommap

Cheers,
Sagi.
