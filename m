From: Ming Lei <tom.leiming@gmail.com>
Subject: Re: [PATCH 1/2] block: export __blk_complete_request
Date: Fri, 15 Jun 2018 11:20:40 +0800
Message-ID: <CACVXFVMPAdFbX3x-KUjHCQhb_rT6p9ROYHg63aUtEqdbitEaKQ@mail.gmail.com>
References: <1529027847-29085-1-git-send-email-jianchao.w.wang@oracle.com>
 <CACVXFVMe4zSvfXfuSn0NFayeQqbmDwBBy1kcso=5iznT6EfpSA@mail.gmail.com>
 <3dd3f82a-5b68-f039-3a8a-7c5fe4e24c3e@oracle.com> <e5344293-b0b7-d2e0-f2e7-c0700efdfbe4@oracle.com>
 <CACVXFVMRCM6AvNJjAESbwOeJ_P5AZ+1C-7RfhE9L4u0T=_5h4Q@mail.gmail.com> <3970fdc7-52d9-d05b-4118-059d48bf4f2d@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3970fdc7-52d9-d05b-4118-059d48bf4f2d@oracle.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "jianchao.wang" <jianchao.w.wang@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-block <linux-block@vger.kernel.org>, Linux SCSI List <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 15, 2018 at 11:04 AM, jianchao.wang
<jianchao.w.wang@oracle.com> wrote:
> Hi Ming
>
> Thanks for your kindly response.
>
> On 06/15/2018 10:56 AM, Ming Lei wrote:
>>>> IMO, ref-counter is just to fix the blk-mq req life recycle issue.
>>>> It cannot replace the blk_mark_rq_complete which could avoid the race between
>>>> timeout and io completion path.
>>> The .timeout return BLK_EH_DONE doesn't always mean the request has been completed.
>>> Such as scsi-mid layer, its .timeout callback return BLK_EH_DONE but the timed out
>>> request is still in abort or eh process. What if a completion irq come during that ?
>> For blk-mq, it is avoided by the atomic state change in
>> __blk_mq_complete_request(),
>> that is why I mentioned the question in my last reply.
>>
>
> but blk_mq_check_expired doesn't do that.
> do I miss anything ?

Right, that is the difference between blk-mq and legacy now, then if scsi-mq
drivers can work well, they should work well with the following change in the
non-mq mode:

diff --git a/block/blk-timeout.c b/block/blk-timeout.c
index 4b8a48d48ba1..9fce09d55652 100644
--- a/block/blk-timeout.c
+++ b/block/blk-timeout.c
@@ -88,7 +88,6 @@ static void blk_rq_timed_out(struct request *req)
        switch (ret) {
        case BLK_EH_RESET_TIMER:
                blk_add_timer(req);
-               blk_clear_rq_complete(req);
                break;
        case BLK_EH_DONE:
                /*
@@ -115,8 +114,7 @@ static void blk_rq_check_expired(struct request
*rq, unsigned long *next_timeout
                /*
                 * Check if we raced with end io completion
                 */
-               if (!blk_mark_rq_complete(rq))
-                       blk_rq_timed_out(rq);
+               blk_rq_timed_out(rq);
        } else if (!*next_set || time_after(*next_timeout, deadline)) {
                *next_timeout = deadline;
                *next_set = 1;


Thanks,
Ming Lei
