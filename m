Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38ABC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:43:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9022C2067D
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 16:43:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727005AbfHLQnZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 12:43:25 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:37377 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726998AbfHLQnZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 12:43:25 -0400
Received: by mail-pf1-f195.google.com with SMTP id 129so3047918pfa.4
        for <linux-scsi@vger.kernel.org>; Mon, 12 Aug 2019 09:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rnYsVQl3atVSLspNrFTvaX+eONqx34m7oaL9Z34F83w=;
        b=WPpS+duTDUUDa1GGnV4NV4PqrX/AD5NSvPHs/fGtRTLRwrKCp7A8a9T7x2QNuEcZgi
         8MfYYBA1sBlw7/DaYAkYNO5QKUjHpUhLlYVxp3SxzPMOCDfFo0F0ftUPXrw3/zm4Mk7O
         jLGkZSDiJVqu6246NoJECDI3i9AxD1pIwxtnfqSMOru5VPWHa+VKEgGi86RcumcrNLjL
         K3gTFBrDRz+y8uQDx7Pk+MfThCuEr0YoFIfzHCV+FnbUtSwMZGOaOldv4bH5w+A4i2YS
         GdFa2wRGL2DC1WC3oZRHeqmKAk/Bo7q+HdO7ZZnr22rWSO7Ci1mJ6Hh0WeSpgoJUBlYB
         pXIA==
X-Gm-Message-State: APjAAAUYCxKOtKaDepQUEiGdZgxw3gnjGdwVou1BRcNLptR1PC0Lxxsf
        yLtlz/P+Q/yuO5YILO7dlpc=
X-Google-Smtp-Source: APXvYqyiJovEpC8jKFVCqvx5ZmxOrVf2LEtPTs0P+AVCnIo0fgzwZ+MSc2aokzTglkyCEPTB6QFAFA==
X-Received: by 2002:aa7:8711:: with SMTP id b17mr36927254pfo.234.1565628203869;
        Mon, 12 Aug 2019 09:43:23 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id o11sm193398552pfh.114.2019.08.12.09.43.22
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 12 Aug 2019 09:43:23 -0700 (PDT)
Subject: Re: [PATCH v3] SCSI: fix queue cleanup race before
 scsi_requeue_run_queue is done
To:     zhengbin <zhengbin13@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org
Cc:     houtao1@huawei.com, yanaijie@huawei.com
References: <1565575593-114286-1-git-send-email-zhengbin13@huawei.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <c95495ed-c136-9202-40e8-57af3eec6d47@acm.org>
Date:   Mon, 12 Aug 2019 09:43:21 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <1565575593-114286-1-git-send-email-zhengbin13@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/11/19 7:06 PM, zhengbin wrote:
> KASAN reports a use-after-free in 4.19-stable,
> which won't happen after commit 47cdee29ef9d
> ("block: move blk_exit_queue into __blk_release_queue").
> However, backport this patch to 4.19-stable will be a lot of work and
> the risk is great. Moreover, we should make sure scsi_requeue_run_queue
> is done before blk_cleanup_queue in master too.
> 
> BUG: KASAN: use-after-free in dd_has_work+0x50/0xe8
> Read of size 8 at addr ffff808b57c6f168 by task kworker/53:1H/6910
> 
> CPU: 53 PID: 6910 Comm: kworker/53:1H Kdump: loaded Tainted: G
> Hardware name: Huawei TaiShan 2280 /BC11SPCD, BIOS 1.59 01/31/2019
> Workqueue: kblockd scsi_requeue_run_queue
> Call trace:
>   dump_backtrace+0x0/0x270
>   show_stack+0x24/0x30
>   dump_stack+0xb4/0xe4
>   print_address_description+0x68/0x278
>   kasan_report+0x204/0x330
>   __asan_load8+0x88/0xb0
>   dd_has_work+0x50/0xe8
>   blk_mq_run_hw_queue+0x19c/0x218
>   blk_mq_run_hw_queues+0x7c/0xb0
>   scsi_run_queue+0x3ec/0x520
>   scsi_requeue_run_queue+0x2c/0x38
>   process_one_work+0x2e4/0x6d8
>   worker_thread+0x6c/0x6a8
>   kthread+0x1b4/0x1c0
>   ret_from_fork+0x10/0x18
> 
> Allocated by task 46843:
>   kasan_kmalloc+0xe0/0x190
>   kmem_cache_alloc_node_trace+0x10c/0x258
>   dd_init_queue+0x68/0x190
>   blk_mq_init_sched+0x1cc/0x300
>   elevator_init_mq+0x90/0xe0
>   blk_mq_init_allocated_queue+0x700/0x728
>   blk_mq_init_queue+0x48/0x90
>   scsi_mq_alloc_queue+0x34/0xb0
>   scsi_alloc_sdev+0x340/0x530
>   scsi_probe_and_add_lun+0x46c/0x1260
>   __scsi_scan_target+0x1b8/0x7b0
>   scsi_scan_target+0x140/0x150
>   fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>   process_one_work+0x2e4/0x6d8
>   worker_thread+0x6c/0x6a8
>   kthread+0x1b4/0x1c0
>   ret_from_fork+0x10/0x18
> 
> Freed by task 46843:
>   __kasan_slab_free+0x120/0x228
>   kasan_slab_free+0x10/0x18
>   kfree+0x88/0x218
>   dd_exit_queue+0x5c/0x78
>   blk_mq_exit_sched+0x104/0x130
>   elevator_exit+0xa8/0xc8
>   blk_exit_queue+0x48/0x78
>   blk_cleanup_queue+0x170/0x248
>   __scsi_remove_device+0x84/0x1b0
>   scsi_probe_and_add_lun+0xd00/0x1260
>   __scsi_scan_target+0x1b8/0x7b0
>   scsi_scan_target+0x140/0x150
>   fc_scsi_scan_rport+0x164/0x178 [scsi_transport_fc]
>   process_one_work+0x2e4/0x6d8
>   worker_thread+0x6c/0x6a8
>   kthread+0x1b4/0x1c0
>   ret_from_fork+0x10/0x18
> 
> Fixes: 8dc765d438f1 ("SCSI: fix queue cleanup race before queue initialization is done")
> Signed-off-by: zhengbin <zhengbin13@huawei.com>
> ---
>   drivers/scsi/scsi_lib.c | 17 +++++++++++++----
>   1 file changed, 13 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 11e64b5..620771d 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -531,6 +531,11 @@ void scsi_requeue_run_queue(struct work_struct *work)
>   	sdev = container_of(work, struct scsi_device, requeue_work);
>   	q = sdev->request_queue;
>   	scsi_run_queue(q);
> +	/*
> +	 * need to put q_usage_counter which
> +	 * is got in scsi_end_request.
> +	 */
> +	percpu_ref_put(&q->q_usage_counter);
>   }
> 
>   void scsi_run_host_queues(struct Scsi_Host *shost)
> @@ -575,6 +580,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>   	struct scsi_device *sdev = cmd->device;
>   	struct request_queue *q = sdev->request_queue;
> +	bool ret;
> 
>   	if (blk_update_request(req, error, bytes))
>   		return true;
> @@ -613,12 +619,15 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
>   	__blk_mq_end_request(req, error);
> 
>   	if (scsi_target(sdev)->single_lun ||
> -	    !list_empty(&sdev->host->starved_list))
> -		kblockd_schedule_work(&sdev->requeue_work);
> -	else
> +	    !list_empty(&sdev->host->starved_list)) {
> +		ret = kblockd_schedule_work(&sdev->requeue_work);
> +		if (!ret)
> +			percpu_ref_put(&q->q_usage_counter);
> +	} else {
>   		blk_mq_run_hw_queues(q, true);
> +		percpu_ref_put(&q->q_usage_counter);
> +	}
> 
> -	percpu_ref_put(&q->q_usage_counter);
>   	return false;
>   }

Is the new 'bool ret' variable really necessary?

Additionally, have you taken a look at the 
cancel_work_sync(&sdev->requeue_work) call in __scsi_remove_device()? 
Shouldn't the queue refcount be dropped if that cancel call cancels 
queued work?

Thanks,

Bart.
