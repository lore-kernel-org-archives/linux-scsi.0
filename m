From: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>
Subject: Re: [PATCH v5 0/14] Fix race conditions related to stopping block
 layer queues
Date: Wed, 2 Nov 2016 12:52:54 -0600
Message-ID: <cfd115a1-78e1-7ed5-3c19-42334a5dbe72@fb.com>
References: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7460e8b2-2cfd-c0d5-7ae7-7f662d89dad3-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konrad Rzeszutek Wilk <konrad.wilk-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau-Sxgqhf6Nn4DQT0dZR+AlfA@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 10/28/2016 06:18 PM, Bart Van Assche wrote:
> Hello Jens,
>
> Multiple block drivers need the functionality to stop a request queue
> and to wait until all ongoing request_fn() / queue_rq() calls have
> finished without waiting until all outstanding requests have finished.
> Hence this patch series that introduces the blk_mq_quiesce_queue()
> function. The dm-mq, SRP and NVMe patches in this patch series are three
> examples of where these functions are useful. These patches have been
> tested on top of kernel v4.9-rc2. The following tests have been run to
> verify this patch series:
> - Mike's mptest suite that stress-tests dm-multipath.
> - My own srp-test suite that stress-tests SRP on top of dm-multipath.
> - fio on top of the NVMeOF host driver that was connected to the NVMeOF
>   target driver on the same host.
> - Laurence verified the previous version (v3) of this patch series by
>   running it through the Red Hat SRP and NVMe test suites.
>
> The changes compared to the third version of this patch series are:
> - Added a blk_mq_stop_hw_queues() call in blk_mq_quiesce_queue() as
>   requested by Ming Lei.
> - Modified scsi_unblock_target() such that it waits until
>   .queuecommand() finished. Unexported scsi_wait_for_queuecommand().
> - Reordered the two NVMe patches.
> - Added a patch that avoids that blk_mq_requeue_work() restarts stopped
>   queues.
> - Added a patch that removes blk_mq_cancel_requeue_work().

Bart, I have applied the series, except patches 11+12. I don't mind
taking them through the block tree, but they can go through the SCSI
tree as well. Let me know what folks think.

-- 
Jens Axboe

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
