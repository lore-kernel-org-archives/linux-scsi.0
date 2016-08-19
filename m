From: Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com>
Subject: Re: Oops when completing request on the wrong queue
Date: Fri, 19 Aug 2016 10:28:38 -0300
Message-ID: <871t1kq455.fsf@linux.vnet.ibm.com>
References: <87a8gltgks.fsf@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <87a8gltgks.fsf@linux.vnet.ibm.com> (Gabriel Krisman Bertazi's
        message of "Wed, 10 Aug 2016 01:04:35 -0300")
Sender: linux-block-owner@vger.kernel.org
To: Keith Busch <keith.busch@intel.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>, Brian King <brking@linux.vnet.ibm.com>, linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Gabriel Krisman Bertazi <krisman@linux.vnet.ibm.com> writes:

> We, IBM, have been experiencing eventual Oops when stressing IO at the
> same time we add/remove processors.  The Oops happens in the IRQ path,
> when we try to complete a request that was apparently meant for another
> queue.
>
> In __nvme_process_cq, the driver will use the cqe.command_id and the
> nvmeq->tags to find out, via blk_mq_tag_to_rq, the request that
> initiated the IO.  Eventually, it happens that the request returned by
> that function is not initialized, and we crash inside
> __blk_mq_complete_request, as shown below.
>
> [ 2679.050701] Faulting instruction address: 0xc000000000549500
> [ 2679.050711] Oops: Kernel access of bad area, sig: 11 [#1]
> [ 2679.050716] SMP NR_CPUS=2048 NUMA pSeries
> [ 2679.050727] Modules linked in: minix nls_iso8859_1 xfs libcrc32c
> rpcsec_gss_krb5 auth_rpcgss
> nfsv4 nfs lockd grace fscache binfmt_misc pseries_rng rtc_generic sunrpc
> autofs4 btrfs xor
> raid6_pq ibmvscsi ibmveth nvme
> [ 2679.050771] CPU: 21 PID: 45045 Comm: ppc64_cpu Not tainted 4.4.0-22-generic #40-Ubuntu
> [ 2679.050780] task: c000000497b07e60 ti: c0000004fff2c000 task.ti: c000000451bc0000
> [ 2679.050786] NIP: c000000000549500 LR: d0000000046b5e84 CTR: c000000000549680
> [ 2679.050803] REGS: c0000004fff2fa80 TRAP: 0300   Not tainted  (4.4.0-22-generic)
> [ 2679.050807] MSR: 8000000100009033 <SF,EE,ME,IR,DR,RI,LE>  CR: 28022428  XER: 00000000
> [ 2679.050824] CFAR: c000000000008468 DAR: 00000000000000b0 DSISR: 40000000 SOFTE: 0 
> GPR00: d0000000046b5e84 c0000004fff2fd00 c0000000015b4300 c0000002799a0a00 
> GPR04: 0000000000000000 0000000000000105 0000000000000004 0000000000000001 
> GPR08: c0000002799a0a50 0000000000000000 0000000000000000 d0000000046bdc68 
> GPR12: c000000000549680 c000000007b1c780 0000000000000008 0000000000000001 
> GPR16: 0000000000000000 0000000000000000 0000000000000000 0000000010005b50 
> GPR20: 0000000010005dc8 c0000000015eaa60 0000000000000001 0000000000000002 
> GPR24: 00000000000001e3 0000000000000000 0000000000000000 ffffffffffffffff 
> GPR28: 0000000000000000 0000000000000000 c0000004f8cd5180 c0000002799a0a00 
> [ 2679.050908] NIP [c000000000549500] __blk_mq_complete_request+0x30/0x1b0
> [ 2679.050924] LR [d0000000046b5e84] __nvme_process_cq+0xf4/0x2c0 [nvme]
> [ 2679.050930] Call Trace:
> [ 2679.050941] [c0000004fff2fd00] [c0000004fff2fd40] 0xc0000004fff2fd40 (unreliable)
> [ 2679.050952] [c0000004fff2fd40] [d0000000046b5e84] __nvme_process_cq+0xf4/0x2c0 [nvme]
> [ 2679.050961] [c0000004fff2fde0] [d0000000046b613c] nvme_irq+0x3c/0xb0 [nvme]
> [ 2679.050972] [c0000004fff2fe10] [c000000000130660] handle_irq_event_percpu+0xa0/0x320
> [ 2679.050981] [c0000004fff2fed0] [c000000000130948] handle_irq_event+0x68/0xc0
> [ 2679.050989] [c0000004fff2ff00] [c000000000135c2c] handle_fasteoi_irq+0xec/0x2b0
> [ 2679.050997] [c0000004fff2ff30] [c00000000012f844] generic_handle_irq+0x54/0x80
> [ 2679.051007] [c0000004fff2ff60] [c000000000011320] __do_irq+0x80/0x1d0
> [ 2679.051020] [c0000004fff2ff90] [c000000000024800] call_do_irq+0x14/0x24
> [ 2679.051037] [c000000451bc3350] [c000000000011508] do_IRQ+0x98/0x140
> [ 2679.051054] [c000000451bc33a0] [c000000000002594]
> hardware_interrupt_common+0x114/0x180
>
> I added some debugging which skipped the Oops and made me think that we
> are fetching the wrong request because we are actually looking at the
> wrong set of tags.
>
> The log below exemplifies what I am saying.  Instead of crashing in the
> Oops, I made the execution skip the request completion and simply
> consider that odd CQE as handled.  The first line of the log does that.
>
>>  nvme nvme0: Skip completion of I/O 309 on queue 35 due to missing q
>>  nvme nvme0: I/O 309 QID 63 timeout, aborting
>>  nvme nvme0: Abort status: 0x0
>>  nvme nvme0: I/O 309 QID 63 timeout, reset controller
>>  nvme nvme0: completing aborted command with status: fffffffc
>>  nvme 0003:03:00.0: Using 64-bit DMA iommu bypass
>>  blk_update_request: I/O error, dev nvme0n1, sector 2105537536
>
> In the first line, we found the request 309 for queue 35, which would
> have crashed the execution.  My debug patch just ignores it.
>
> Then, we can see that eventually, the same IO, 309, will timeout in
> another QID, which was actually expecting for it.  The Abort request
> gets sent and completed, but we never receive the completion of the
> aborted request, thus we timeout again and restart the device.
>
> This only happens when we are changing the SMT settings very
> frequently, which points back to the way we correlate the hctx->tags to
> the nvmeq structure, but I failed to find the exact code spot were
> things get messed up.
>
> I've put a some effort on this code lately, but I definitely need some
> assistance on this one.  Since, as far as I understand, this issue is
> much more likely to reproduce on boxes with a lot of hotpluggable
> processors, I'm willing to test any patches you may find suitable in our
> systems.
>

Hi,

[Adding linux-block, linux-scsi and Jens in CC for blk-mq input]

Made some progress on tracking down the issue.  It's looking more of a
blk-mq bug than nvme to me now.  Let me know if I made any wrong
assumption below:

I started to wonder whether blk-mq is requesting the IO in a wrong queue
or if the request is being moved to another queue during hotplug, as it
would happen in blk_mq_hctx_cpu_offline.

I verified that when the fail occurs, the request never was never
touched in blk_mq_hctx_cpu_offline.  Also, and more interesting, I added
the following BUG_ON to nvme_queue_req:

    BUG_ON(blk_mq_tag_to_rq(*nvmeq->tags, req->tag) != req);

>From my experiments, I could never hit this during normal operation
(without SMT). But, as soon as I start triggering hotplug changes, I hit
it pretty fast.  By changing to WARN_ON, I see that the Oops will happen
almost immediately after this request is submitted, once __process_cq
tries to complete it.

Also, when adding the patch below, we send a few -EIOs back to upper
layers, but it prevents the crash.

I also think i saw a similar hang when running on a virtio_scsi disk.  I
couldn't reproduce it a second time, so we still lack confirmation, but
if confirmed, it indeed points away from nvme and back to the block
layer.

Any suggestions to further track this down?


diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index b927ecf..10f2257 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -599,6 +599,11 @@ static int nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
        if (ret)
                return ret;

+       if(blk_mq_tag_to_rq(*nvmeq->tags, req->tag) != req) {
+         ret = BLK_MQ_RQ_QUEUE_ERROR;
+         goto out;
+       }
+
        ret = nvme_setup_cmd(ns, req, &cmnd);
        if (ret)
                goto out;

