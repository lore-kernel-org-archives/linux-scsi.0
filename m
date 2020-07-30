Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88B0DC433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6CE3920672
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 08:06:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729250AbgG3IGF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 04:06:05 -0400
Received: from comms.puri.sm ([159.203.221.185]:52986 "EHLO comms.puri.sm"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729235AbgG3IF5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Jul 2020 04:05:57 -0400
Received: from localhost (localhost [127.0.0.1])
        by comms.puri.sm (Postfix) with ESMTP id 08B8CDF97E;
        Thu, 30 Jul 2020 01:05:56 -0700 (PDT)
Received: from comms.puri.sm ([127.0.0.1])
        by localhost (comms.puri.sm [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id q--T1jzJR9pm; Thu, 30 Jul 2020 01:05:55 -0700 (PDT)
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Bart Van Assche <bvanassche@acm.org>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
From:   Martin Kepplinger <martin.kepplinger@puri.sm>
Autocrypt: addr=martin.kepplinger@puri.sm; keydata=
 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
 ekMtxgNYb/8oDry09UFHbGHLsWn6oBo=
Message-ID: <c253dde7-9347-b3dc-9c91-65d685793b29@puri.sm>
Date:   Thu, 30 Jul 2020 10:05:50 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20200629161536.GA405175@rowland.harvard.edu>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 29.06.20 18:15, Alan Stern wrote:
> On Mon, Jun 29, 2020 at 11:42:59AM +0200, Martin Kepplinger wrote:
>>
>>
>> On 26.06.20 17:44, Alan Stern wrote:
>>> Martin's best approach would be to add some debugging code to find out why 
>>> blk_queue_enter() isn't calling bkl_pm_request_resume(), or why that call 
>>> doesn't lead to pm_request_resume().
>>>
>>> Alan Stern
>>>
>>
>> Hi Alan,
>>
>> blk_queue_enter() always - especially when sd is runtime suspended and I
>> try to mount as above - sets success to be true for me, so never
>> continues down to bkl_pm_request_resume(). All I see is "PM: Removing
>> info for No Bus:sda1".
> 
> Aha.  Looking at this more closely, it's apparent that the code in 
> blk-core.c contains a logic bug: It assumes that if the BLK_MQ_REQ_PREEMPT 
> flag is set then the request can be issued regardless of the queue's 
> runtime status.  That is not correct when the queue is suspended.
> 
> Below is my attempt to fix this up.  I'm not sure that the patch is 
> entirely correct, but it should fix this logic bug.  I would appreciate a 
> critical review.
> 
> Martin, does this fix the problem?
> 
> Alan Stern

Hi Alan,

So in the block layer your change below indeed fixes the problem and if
you want to submit that 1:1 feel free to add

Tested-by: Martin Kepplinger <martin.kepplinger@puri.sm>

thanks for your help in this!

                       martin


> 
> 
> 
> Index: usb-devel/block/blk-core.c
> ===================================================================
> --- usb-devel.orig/block/blk-core.c
> +++ usb-devel/block/blk-core.c
> @@ -423,7 +423,8 @@ int blk_queue_enter(struct request_queue
>  			 * responsible for ensuring that that counter is
>  			 * globally visible before the queue is unfrozen.
>  			 */
> -			if (pm || !blk_queue_pm_only(q)) {
> +			if ((pm && q->rpm_status != RPM_SUSPENDED) ||
> +			    !blk_queue_pm_only(q)) {
>  				success = true;
>  			} else {
>  				percpu_ref_put(&q->q_usage_counter);
> @@ -448,8 +449,7 @@ int blk_queue_enter(struct request_queue
>  
>  		wait_event(q->mq_freeze_wq,
>  			   (!q->mq_freeze_depth &&
> -			    (pm || (blk_pm_request_resume(q),
> -				    !blk_queue_pm_only(q)))) ||
> +			    blk_pm_resume_queue(pm, q)) ||
>  			   blk_queue_dying(q));
>  		if (blk_queue_dying(q))
>  			return -ENODEV;
> Index: usb-devel/block/blk-pm.h
> ===================================================================
> --- usb-devel.orig/block/blk-pm.h
> +++ usb-devel/block/blk-pm.h
> @@ -6,11 +6,14 @@
>  #include <linux/pm_runtime.h>
>  
>  #ifdef CONFIG_PM
> -static inline void blk_pm_request_resume(struct request_queue *q)
> +static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
>  {
> -	if (q->dev && (q->rpm_status == RPM_SUSPENDED ||
> -		       q->rpm_status == RPM_SUSPENDING))
> -		pm_request_resume(q->dev);
> +	if (!q->dev || !blk_queue_pm_only(q))
> +		return 1;	/* Nothing to do */
> +	if (pm && q->rpm_status != RPM_SUSPENDED)
> +		return 1;	/* Request allowed */
> +	pm_request_resume(q->dev);
> +	return 0;
>  }
>  
>  static inline void blk_pm_mark_last_busy(struct request *rq)
> @@ -44,8 +47,9 @@ static inline void blk_pm_put_request(st
>  		--rq->q->nr_pending;
>  }
>  #else
> -static inline void blk_pm_request_resume(struct request_queue *q)
> +static inline int blk_pm_resume_queue(const bool pm, struct request_queue *q)
>  {
> +	return 1;
>  }
>  
>  static inline void blk_pm_mark_last_busy(struct request *rq)
> 
