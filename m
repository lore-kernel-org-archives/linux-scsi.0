From: Sasha Levin <sasha.levin@oracle.com>
Subject: Re: scsi: non atomic allocation in mempool_alloc in atomic context
Date: Mon, 05 Jan 2015 10:17:55 -0500
Message-ID: <54AAAB23.1090108@oracle.com>
References: <54A43CFB.2080705@oracle.com> <20150105091516.GA22226@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20150105091516.GA22226@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: bvanassche@acm.org, hare@suse.de, JBottomley@parallels.com, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 01/05/2015 04:15 AM, Christoph Hellwig wrote:
> On Wed, Dec 31, 2014 at 01:14:19PM -0500, Sasha Levin wrote:
>> Hi Christoph,
>>
>> I'm seeing an issue which was bisected down to 3c356bde1 ("scsi: stop passing
>> a gfp_mask argument down the command setup path"):
> 
> ->queue_rq in blk-mq context is designed to be able to sleep and be called
> from process context without any spinlocks held or irqs disabled, so we
> really should fix the
> caller instead.
> 
> That being said your trace seems odd to me:
> 
>> [ 3395.328221] BUG: sleeping function called from invalid context at mm/mempool.c:206
>> [ 3395.329540] in_atomic(): 1, irqs_disabled(): 0, pid: 6399, name: trinity-c531
>> [ 3395.331104] no locks held by trinity-c531/6399.
>> [ 3395.331849] Preemption disabled blk_execute_rq_nowait (block/blk-exec.c:95)
> 
> blk_execute_rq_nowait only takes a lock for the non-blk-mq case.  In my
> current kernel that's in line 79, but can you verify that for you
> line 95 is the spin_lock_irq in the !q->mq_ops case?

That's line 79 for me as well. I'm not sure why addr2line said it's line 95 here.

>> [ 3395.348571] __might_sleep (kernel/sched/core.c:7308)
>> [ 3395.351944] mempool_alloc (mm/mempool.c:206 (discriminator 1))
>> [ 3395.355196] scsi_sg_alloc (drivers/scsi/scsi_lib.c:582)
>> [ 3395.356893] __sg_alloc_table (lib/scatterlist.c:282)
>> [ 3395.358844] ? sdev_disable_disk_events (drivers/scsi/scsi_lib.c:577)
>> [ 3395.360873] scsi_alloc_sgtable (drivers/scsi/scsi_lib.c:608)
>> [ 3395.362769] scsi_init_sgtable (drivers/scsi/scsi_lib.c:1087)
>> [ 3395.364583] ? lockdep_init_map (kernel/locking/lockdep.c:2986)
>> [ 3395.366354] scsi_init_io (drivers/scsi/scsi_lib.c:1122)
>> [ 3395.368092] ? do_init_timer (kernel/time/timer.c:669)
>> [ 3395.369837] scsi_setup_cmnd (drivers/scsi/scsi_lib.c:1220 drivers/scsi/scsi_lib.c:1268)
>> [ 3395.371743] scsi_queue_rq (drivers/scsi/scsi_lib.c:1875 drivers/scsi/scsi_lib.c:1980)
>> [ 3395.373471] __blk_mq_run_hw_queue (block/blk-mq.c:751)
>> [ 3395.375481] blk_mq_run_hw_queue (block/blk-mq.c:831)
>> [ 3395.377324] blk_mq_insert_request (block/blk-mq.h:92 block/blk-mq.c:974)
>> [ 3395.379377] ? blk_rq_map_user (block/blk-map.c:78 block/blk-map.c:142)
>> [ 3395.381307] ? trace_hardirqs_on_caller (kernel/locking/lockdep.c:2559 kernel/locking/lockdep.c:2601)
>> [ 3395.383485] blk_execute_rq_nowait (block/blk-exec.c:95)
> 
> But this clearly is the blk-mq case.  How does your version of
> blk_execute_rq_nowait look like?

It's whatever -next had. I've looked at objdump and it looks like the compiler made
something "interesting" with it that might explain the odd line numbering for the
preemption off thing:

/home/sasha/linux-next/block/blk-exec.c:69
                blk_mq_insert_request(rq, at_head, true, false);
  b9:   31 f6                   xor    %esi,%esi
  bb:   45 85 ff                test   %r15d,%r15d
  be:   48 89 df                mov    %rbx,%rdi
  c1:   40 0f 95 c6             setne  %sil
  c5:   ba 01 00 00 00          mov    $0x1,%edx
  ca:   31 c9                   xor    %ecx,%ecx
  cc:   e8 00 00 00 00          callq  d1 <blk_execute_rq_nowait+0xd1>
                        cd: R_X86_64_PC32       blk_mq_insert_request-0x4
/home/sasha/linux-next/block/blk-exec.c:95
        __blk_run_queue(q);
        /* the queue is stopped so it won't be run */
        if (is_pm_resume)
                __blk_run_queue_uncond(q);
        spin_unlock_irq(q->queue_lock);
}
  d1:   48 83 c4 18             add    $0x18,%rsp
  d5:   5b                      pop    %rbx
  d6:   41 5c                   pop    %r12
  d8:   41 5d                   pop    %r13
  da:   41 5e                   pop    %r14
  dc:   41 5f                   pop    %r15
  de:   5d                      pop    %rbp
  df:   c3                      retq

Or with the whole stack trace really...


Thanks,
Sasha
