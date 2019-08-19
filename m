Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 155F9C3A59D
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 11:49:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D84E520843
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 11:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726717AbfHSLtA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 07:49:00 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:36474 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726594AbfHSLtA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Aug 2019 07:49:00 -0400
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 5B1138FA85F590B59A0C;
        Mon, 19 Aug 2019 19:48:55 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS407-HUB.china.huawei.com
 (10.3.19.207) with Microsoft SMTP Server id 14.3.439.0; Mon, 19 Aug 2019
 19:48:48 +0800
Subject: Re: [PATCH 4.19-stable] SCSI: fix queue cleanup race before
 scsi_requeue_run_queue is done
To:     Ming Lei <ming.lei@redhat.com>
CC:     <bvanassche@acm.org>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <houtao1@huawei.com>, <yanaijie@huawei.com>
References: <1566182345-7544-1-git-send-email-zhengbin13@huawei.com>
 <20190819040830.GA7173@ming.t460p>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <a98b4de5-f4c9-7449-3d9b-33fe26cf523f@huawei.com>
Date:   Mon, 19 Aug 2019 19:48:46 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <20190819040830.GA7173@ming.t460p>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/8/19 12:08, Ming Lei wrote:
> On Mon, Aug 19, 2019 at 10:39:05AM +0800, zhengbin wrote:
>> KASAN reports a use-after-free in 4.19-stable,
>> which won't happen after commit 47cdee29ef9d
>> ("block: move blk_exit_queue into __blk_release_queue").
>> However, backport this patch to 4.19-stable will be a lot of work and
>> the risk is great. Moreover, we should make sure scsi_requeue_run_queue
>> is done before blk_cleanup_queue.
> I have backported that patchset to v4.18 based kernel, and it won't
> take lots of work at all.

In fact, I want to backport it to 4.19, if backport, we need to do:

1. need to backport 0d945c1f966b ("block: remove the queue_lock indirection"), cause commit 47cdee29ef9d

("block: move blk_exit_queue into __blk_release_queue") reverts a063057d7c73

("block: Fix a race between request queue removal and the block cgroup controller"), if we do not backport 0d945c1f966b,

the bug fixed by a063057d7c73 will exist too.

2. If we backport 0d945c1f966b, see the comment: "With the legacy request path gone there is no good reason to keep queue_lock as a pointer".

we need to backport the driver patches which kill the queue_lock. For example:

89c6b1650969 ("paride: convert pcd to blk-mq")  --->the second para of blk_init_queue is queue_lock

99fe8b02a825 ("paride: convert pd to blk-mq")

...

3. In SCSI, 4.19-stable has blk-sq(single queue) & mq.  Blk-sq uses queue_lock, while these need  to adapt. For example:

scsi_lib.c:     spin_lock_irqsave(q->queue_lock, flags);
scsi_lib.c:     spin_unlock_irqrestore(q->queue_lock, flags);
scsi_lib.c:              * drops the queue_lock and can add us back to the
scsi_lib.c:     spin_lock_irqsave(q->queue_lock, flags);
scsi_lib.c:     spin_unlock_irqrestore(q->queue_lock, flags);
scsi_lib.c:             spin_lock_irqsave(q->queue_lock, flags);
scsi_lib.c:             spin_unlock_irqrestore(q->queue_lock, flags);
scsi_lib.c: * Called with the queue_lock held.
...

>> BUG: KASAN: use-after-free in dd_has_work+0x50/0xe8
>> Read of size 8 at addr ffff808b57c6f168 by task kworker/53:1H/6910
>>
>> CPU: 53 PID: 6910 Comm: kworker/53:1H Kdump: loaded Tainted: G
>> Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.59 01/31/2019
>> Workqueue: kblockd scsi_requeue_run_queue
>> Call trace:
>>  dump_backtrace+0x0/0x270
>>  show_stack+0x24/0x30
>>  dump_stack+0xb4/0xe4
>>  print_address_description+0x68/0x278
>>  kasan_report+0x204/0x330
>>  __asan_load8+0x88/0xb0
>>  dd_has_work+0x50/0xe8
>>  blk_mq_run_hw_queue+0x19c/0x218
>>  blk_mq_run_hw_queues+0x7c/0xb0
>>  scsi_run_queue+0x3ec/0x520
>>  scsi_requeue_run_queue+0x2c/0x38
>>  process_one_work+0x2e4/0x6d8
>>  worker_thread+0x6c/0x6a8
>>  kthread+0x1b4/0x1c0
>>  ret_from_fork+0x10/0x18
>>
>> Allocated by task 46843:
>>  kasan_kmalloc+0xe0/0x190
>>  kmem_cache_alloc_node_trace+0x10c/0x258
>>  dd_init_queue+0x68/0x190
>>  blk_mq_init_sched+0x1cc/0x300
>>  elevator_init_mq+0x90/0xe0
>>  blk_mq_init_allocated_queue+0x700/0x728
>>  blk_mq_init_queue+0x48/0x90
>>  scsi_mq_alloc_queue+0x34/0xb0
>>  scsi_alloc_sdev+0x340/0x530
>>  scsi_probe_and_add_lun+0x46c/0x1260
>>  __scsi_scan_target+0x1b8/0x7b0
>>  scsi_scan_target+0x140/0x150
>>  fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>>  process_one_work+0x2e4/0x6d8
>>  worker_thread+0x6c/0x6a8
>>  kthread+0x1b4/0x1c0
>>  ret_from_fork+0x10/0x18
>>
>> Freed by task 46843:
>>  __kasan_slab_free+0x120/0x228
>>  kasan_slab_free+0x10/0x18
>>  kfree+0x88/0x218
>>  dd_exit_queue+0x5c/0x78
>>  blk_mq_exit_sched+0x104/0x130
>>  elevator_exit+0xa8/0xc8
>>  blk_exit_queue+0x48/0x78
>>  blk_cleanup_queue+0x170/0x248
>>  __scsi_remove_device+0x84/0x1b0
>>  scsi_probe_and_add_lun+0xd00/0x1260
>>  __scsi_scan_target+0x1b8/0x7b0
>>  scsi_scan_target+0x140/0x150
>>  fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>>  process_one_work+0x2e4/0x6d8
>>  worker_thread+0x6c/0x6a8
>>  kthread+0x1b4/0x1c0
>>  ret_from_fork+0x10/0x18
>>
>> Fixes: 8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
>> Signed-off-by: zhengbin <zhengbin13@huawei.com>
>> ---
>>  drivers/scsi/scsi_lib.c   | 24 ++++++++++++++++++------
>>  drivers/scsi/scsi_sysfs.c |  3 ++-
>>  2 files changed, 20 insertions(+), 7 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>> index 75b926e..42f1475 100644
>> --- a/drivers/scsi/scsi_lib.c
>> +++ b/drivers/scsi/scsi_lib.c
>> @@ -208,7 +208,13 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>>  	}
>>  	spin_lock_irqsave(q->queue_lock, flags);
>>  	blk_requeue_request(q, cmd->request);
>> -	kblockd_schedule_work(&device->requeue_work);
>> +	/*
>> +	 * need to get q_usage_counter which will be
>> +	 * put in scsi_requeue_run_queue.
>> +	 */
>> +	percpu_ref_get(&q->q_usage_counter);
>> +	if (!kblockd_schedule_work(&device->requeue_work))
>> +		percpu_ref_put(&q->q_usage_counter);
>>  	spin_unlock_irqrestore(q->queue_lock, flags);
>>  }
>>
>> @@ -548,6 +554,11 @@ void scsi_requeue_run_queue(struct work_struct *work)
>>  	sdev = container_of(work, struct scsi_device, requeue_work);
>>  	q = sdev->request_queue;
>>  	scsi_run_queue(q);
>> +	/*
>> +	 * need to put q_usage_counter which is got in
>> +	 * scsi_end_request or __scsi_queue_insert.
>> +	 */
>> +	percpu_ref_put(&q->q_usage_counter);
>>  }
>>
>>  /*
>> @@ -706,12 +717,13 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>>  		__blk_mq_end_request(req, error);
>>
>>  		if (scsi_target(sdev)->single_lun ||
>> -		    !list_empty(&sdev->host->starved_list))
>> -			kblockd_schedule_work(&sdev->requeue_work);
>> -		else
>> +		    !list_empty(&sdev->host->starved_list)) {
>> +			if (!kblockd_schedule_work(&sdev->requeue_work))
>> +				percpu_ref_put(&q->q_usage_counter);
>> +		} else {
>>  			blk_mq_run_hw_queues(q, true);
>> -
>> -		percpu_ref_put(&q->q_usage_counter);
>> +			percpu_ref_put(&q->q_usage_counter);
>> +		}
>>  	} else {
>>  		unsigned long flags;
>>
>> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
>> index 3aee946..2dc422e 100644
>> --- a/drivers/scsi/scsi_sysfs.c
>> +++ b/drivers/scsi/scsi_sysfs.c
>> @@ -1392,7 +1392,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>>  	mutex_unlock(&sdev->state_mutex);
>>
>>  	blk_cleanup_queue(sdev->request_queue);
>> -	cancel_work_sync(&sdev->requeue_work);
>> +	if (cancel_work_sync(&sdev->requeue_work))
>> +		percpu_ref_put(&sdev->request_queue->q_usage_counter);
>>
>>  	if (sdev->host->hostt->slave_destroy)
>>  		sdev->host->hostt->slave_destroy(sdev);
> Getting/putting the percpu ref from different contexts is just a
> nightmare for maintaining the correctness.
>
>
> Thanks,
> Ming
>
> .
>

