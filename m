From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 5/9] block: Extend blk_freeze_queue_start() to the
 non-blk-mq path
Date: Tue, 27 Sep 2016 08:55:42 -0700
Message-ID: <d15c920e-8333-b970-4e8c-4a3fbf148bb4@sandisk.com>
References: <7948dbb8-6333-dc62-2673-4da35b4dfdbc@sandisk.com>
 <7c8af8d2-2ac9-2767-5e5f-8de72eba3814@sandisk.com>
 <CACVXFVO=GFp=ArC_FT+xPSmL84m01fX6bzReBQ8DeLQ4fUD5cQ@mail.gmail.com>
 <a8e8796e-7266-4c8a-a4eb-31cedf73ec8a@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a8e8796e-7266-4c8a-a4eb-31cedf73ec8a-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ming Lei <tom.leiming-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Jens Axboe <axboe-b10kYP2dOMg@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, James Bottomley <jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Mike Snitzer <snitzer-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org" <linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 09/27/2016 07:42 AM, Bart Van Assche wrote:
> Jens, regarding non-blk-mq mode and q_usage_counter: do you prefer that
> I rework patch 8/9 such that blk_quiesce_queue() and blk_resume_queue()
> are only used in blk-mq mode or are you OK with adding a
> blk_queue_enter() call in get_request() and a blk_queue_exit() call to
> __blk_put_request()?

(replying to my own e-mail)

Although it is easy to make q_usage_counter count non-blk-mq requests, 
extending the blk_quiesce_queue() waiting mechanism to the non-blk-mq 
path is non-trivial. To limit the number of changes in this patch series 
I will drop the non-blk-mq changes from this patch series.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
