From: Tao Ma <tm@tao.ma>
Subject: Re: [PATCH] block: fix blk_queue_end_tag()
Date: Wed, 21 Dec 2011 16:16:46 +0800
Message-ID: <4EF195EE.9010409@tao.ma>
References: <20111220233117.17757.71139.stgit@localhost6.localdomain6>	<4EF17DC4.5010008@tao.ma>	<alpine.SOC.1.00.1112210835010.6858@math.ut.ee>	<4EF18129.7030407@tao.ma> <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:49974 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752414Ab1LUIQu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Dec 2011 03:16:50 -0500
In-Reply-To: <CABE8wwtrq=SuuhAvNDjpSbfPGE+N4cWjjmVGWq8UzaH6sM9kRg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Meelis Roos <mroos@linux.ee>, axboe@kernel.dk, Tao Ma <boyu.mt@taobao.com>, Linux Kernel list <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Ed Nadolski <edmund.nadolski@intel.com>

On 12/21/2011 03:30 PM, Williams, Dan J wrote:
> On Tue, Dec 20, 2011 at 10:48 PM, Tao Ma <tm@tao.ma> wrote:
>> On 12/21/2011 02:36 PM, Meelis Roos wrote:
>>>>> -   if (unlikely(tag >= bqt->max_depth)) {
>>>>> +   if (WARN_ONCE(tag >= bqt->real_max_depth,
>>>>> +                 "%s: tag %d greater than tag map size: %d\n",
>>>>> +                 __func__, tag, bqt->real_max_depth)) {
>>>>>             /*
>>>>>              * This can happen after tag depth has been reduced.
>>>> Please also change the comments here since it should never happen in the
>>>> right workload.
>>>
>>> What do you mean by right workload? Normal workload?
>> yeah, so real_max_depth is the maximum depth we ever have. So in normal
>> case(shrinking queue depth is also a normal user case), we should never
>> arrive here. In another word, if tag >= real_max_depth, we should have a
>> bug in the kernel.
> 
> So this is what Ed Nadolski suggested, just cut to the chase and do,
> the following.  Seems like the comment is what got us into trouble in
> the first place.
> 
> diff --git a/block/blk-tag.c b/block/blk-tag.c
> index e74d6d1..e297d9d7 100644
> --- a/block/blk-tag.c
> +++ b/block/blk-tag.c
> @@ -284,16 +284,7 @@ void blk_queue_end_tag(struct request_queue *q,
> struct request *rq)
>         struct blk_queue_tag *bqt = q->queue_tags;
>         int tag = rq->tag;
> 
> -       BUG_ON(tag == -1);
> -
> -       if (unlikely(tag >= bqt->max_depth)) {
> -               /*
> -                * This can happen after tag depth has been reduced.
> -                * But tag shouldn't be larger than real_max_depth.
> -                */
> -               WARN_ON(tag >= bqt->real_max_depth);
> -               return;
> -       }
> +       BUG_ON(tag == -1 || tag > bqt->real_max_depth);
I guess tag = bqt->real_max_depth should also be a problem.

Thanks
Tao
