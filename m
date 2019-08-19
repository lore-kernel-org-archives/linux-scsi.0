Return-Path: <SRS0=CaZB=WP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D8AC3A59B
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 04:08:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8BF792082C
	for <linux-scsi@archiver.kernel.org>; Mon, 19 Aug 2019 04:08:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725872AbfHSEIy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Aug 2019 00:08:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38670 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725536AbfHSEIx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 19 Aug 2019 00:08:53 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 27F08C04959E;
        Mon, 19 Aug 2019 04:08:43 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D227C114BF2;
        Mon, 19 Aug 2019 04:08:36 +0000 (UTC)
Date:   Mon, 19 Aug 2019 12:08:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     zhengbin <zhengbin13@huawei.com>
Cc:     bvanassche@acm.org, jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, houtao1@huawei.com, yanaijie@huawei.com
Subject: Re: [PATCH 4.19-stable] SCSI: fix queue cleanup race before
 scsi_requeue_run_queue is done
Message-ID: <20190819040830.GA7173@ming.t460p>
References: <1566182345-7544-1-git-send-email-zhengbin13@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1566182345-7544-1-git-send-email-zhengbin13@huawei.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Mon, 19 Aug 2019 04:08:53 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 19, 2019 at 10:39:05AM +0800, zhengbin wrote:
> KASAN reports a use-after-free in 4.19-stable,
> which won't happen after commit 47cdee29ef9d
> ("block: move blk_exit_queue into __blk_release_queue").
> However, backport this patch to 4.19-stable will be a lot of work and
> the risk is great. Moreover, we should make sure scsi_requeue_run_queue
> is done before blk_cleanup_queue.

I have backported that patchset to v4.18 based kernel, and it won't
take lots of work at all.

> 
> BUG: KASAN: use-after-free in dd_has_work+0x50/0xe8
> Read of size 8 at addr ffff808b57c6f168 by task kworker/53:1H/6910
> 
> CPU: 53 PID: 6910 Comm: kworker/53:1H Kdump: loaded Tainted: G
> Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.59 01/31/2019
> Workqueue: kblockd scsi_requeue_run_queue
> Call trace:
>  dump_backtrace+0x0/0x270
>  show_stack+0x24/0x30
>  dump_stack+0xb4/0xe4
>  print_address_description+0x68/0x278
>  kasan_report+0x204/0x330
>  __asan_load8+0x88/0xb0
>  dd_has_work+0x50/0xe8
>  blk_mq_run_hw_queue+0x19c/0x218
>  blk_mq_run_hw_queues+0x7c/0xb0
>  scsi_run_queue+0x3ec/0x520
>  scsi_requeue_run_queue+0x2c/0x38
>  process_one_work+0x2e4/0x6d8
>  worker_thread+0x6c/0x6a8
>  kthread+0x1b4/0x1c0
>  ret_from_fork+0x10/0x18
> 
> Allocated by task 46843:
>  kasan_kmalloc+0xe0/0x190
>  kmem_cache_alloc_node_trace+0x10c/0x258
>  dd_init_queue+0x68/0x190
>  blk_mq_init_sched+0x1cc/0x300
>  elevator_init_mq+0x90/0xe0
>  blk_mq_init_allocated_queue+0x700/0x728
>  blk_mq_init_queue+0x48/0x90
>  scsi_mq_alloc_queue+0x34/0xb0
>  scsi_alloc_sdev+0x340/0x530
>  scsi_probe_and_add_lun+0x46c/0x1260
>  __scsi_scan_target+0x1b8/0x7b0
>  scsi_scan_target+0x140/0x150
>  fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>  process_one_work+0x2e4/0x6d8
>  worker_thread+0x6c/0x6a8
>  kthread+0x1b4/0x1c0
>  ret_from_fork+0x10/0x18
> 
> Freed by task 46843:
>  __kasan_slab_free+0x120/0x228
>  kasan_slab_free+0x10/0x18
>  kfree+0x88/0x218
>  dd_exit_queue+0x5c/0x78
>  blk_mq_exit_sched+0x104/0x130
>  elevator_exit+0xa8/0xc8
>  blk_exit_queue+0x48/0x78
>  blk_cleanup_queue+0x170/0x248
>  __scsi_remove_device+0x84/0x1b0
>  scsi_probe_and_add_lun+0xd00/0x1260
>  __scsi_scan_target+0x1b8/0x7b0
>  scsi_scan_target+0x140/0x150
>  fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>  process_one_work+0x2e4/0x6d8
>  worker_thread+0x6c/0x6a8
>  kthread+0x1b4/0x1c0
>  ret_from_fork+0x10/0x18
> 
> Fixes: 8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>  drivers/scsi/scsi_lib.c   | 24 ++++++++++++++++++------
>  drivers/scsi/scsi_sysfs.c |  3 ++-
>  2 files changed, 20 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 75b926e..42f1475 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -208,7 +208,13 @@ static void __scsi_queue_insert(struct scsi_cmnd *cmd, int reason, bool unbusy)
>  	}
>  	spin_lock_irqsave(q->queue_lock, flags);
>  	blk_requeue_request(q, cmd->request);
> -	kblockd_schedule_work(&device->requeue_work);
> +	/*
> +	 * need to get q_usage_counter which will be
> +	 * put in scsi_requeue_run_queue.
> +	 */
> +	percpu_ref_get(&q->q_usage_counter);
> +	if (!kblockd_schedule_work(&device->requeue_work))
> +		percpu_ref_put(&q->q_usage_counter);
>  	spin_unlock_irqrestore(q->queue_lock, flags);
>  }
> 
> @@ -548,6 +554,11 @@ void scsi_requeue_run_queue(struct work_struct *work)
>  	sdev = container_of(work, struct scsi_device, requeue_work);
>  	q = sdev->request_queue;
>  	scsi_run_queue(q);
> +	/*
> +	 * need to put q_usage_counter which is got in
> +	 * scsi_end_request or __scsi_queue_insert.
> +	 */
> +	percpu_ref_put(&q->q_usage_counter);
>  }
> 
>  /*
> @@ -706,12 +717,13 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>  		__blk_mq_end_request(req, error);
> 
>  		if (scsi_target(sdev)->single_lun ||
> -		    !list_empty(&sdev->host->starved_list))
> -			kblockd_schedule_work(&sdev->requeue_work);
> -		else
> +		    !list_empty(&sdev->host->starved_list)) {
> +			if (!kblockd_schedule_work(&sdev->requeue_work))
> +				percpu_ref_put(&q->q_usage_counter);
> +		} else {
>  			blk_mq_run_hw_queues(q, true);
> -
> -		percpu_ref_put(&q->q_usage_counter);
> +			percpu_ref_put(&q->q_usage_counter);
> +		}
>  	} else {
>  		unsigned long flags;
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 3aee946..2dc422e 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -1392,7 +1392,8 @@ void __scsi_remove_device(struct scsi_device *sdev)
>  	mutex_unlock(&sdev->state_mutex);
> 
>  	blk_cleanup_queue(sdev->request_queue);
> -	cancel_work_sync(&sdev->requeue_work);
> +	if (cancel_work_sync(&sdev->requeue_work))
> +		percpu_ref_put(&sdev->request_queue->q_usage_counter);
> 
>  	if (sdev->host->hostt->slave_destroy)
>  		sdev->host->hostt->slave_destroy(sdev);

Getting/putting the percpu ref from different contexts is just a
nightmare for maintaining the correctness.


Thanks,
Ming
