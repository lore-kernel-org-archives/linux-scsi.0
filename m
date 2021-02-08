Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 541ECC433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 09:26:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0794F64E7B
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 09:26:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231307AbhBHJ0c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 04:26:32 -0500
Received: from so15.mailgun.net ([198.61.254.15]:29379 "EHLO so15.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231171AbhBHJYX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 8 Feb 2021 04:24:23 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612776228; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=I/bB5csHyQa5LojQBmfZSqE+Dm4Nn4V/dZ5cfnA1UYE=;
 b=T7wF63BJP0J3c8RUmhw1AhynIoJ+UHUUwAC7u3dqs22RZYJg4upVi8hOHVjRCL3hISRqkk4j
 KfCkVybmFdjab1bguc2UStAzTRx5rDyPCxUUJXw8EYfcder4/2MJWGaQwvXgbrZVxB4XiKFD
 R9y6Mln4GEKt2r2HpyzDldgxk/0=
X-Mailgun-Sending-Ip: 198.61.254.15
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n07.prod.us-west-2.postgun.com with SMTP id
 6021030134db06ef790e834d (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 08 Feb 2021 09:23:13
 GMT
Sender: cang=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 108FEC43464; Mon,  8 Feb 2021 09:23:12 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 23D27C433CA;
        Mon,  8 Feb 2021 09:23:12 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 08 Feb 2021 17:23:12 +0800
From:   Can Guo <cang@codeaurora.org>
To:     daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        huobean@gmail.com, bvanassche@acm.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v19 2/3] scsi: ufs: L2P map management for HPB read
In-Reply-To: <20210208085346epcms2p1c11b70be9d258df66cb2ca4542835fac@epcms2p1>
References: <88b608e2e133ba7ccd5bb452898848fd@codeaurora.org>
 <5bd43da52369a56f18867fa18efb3020@codeaurora.org>
 <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
 <20210129053005epcms2p323338fbb83459d2786fc0ef92701b147@epcms2p3>
 <20210208080333epcms2p59403f0acbc9730c9a605d265836a956d@epcms2p5>
 <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p1>
 <20210208085346epcms2p1c11b70be9d258df66cb2ca4542835fac@epcms2p1>
Message-ID: <5b9f5edbe26930765ee4adaa786db7da@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-02-08 16:53, Daejun Park wrote:
>>>> @@ -342,13 +1208,14 @@ void ufshpb_suspend(struct ufs_hba *hba)
>>>> >          struct scsi_device *sdev;
>>>> >
>>>> >          shost_for_each_device(sdev, hba->host) {
>>>> > -                hpb = sdev->hostdata;
>>>> > +                hpb = ufshpb_get_hpb_data(sdev);
>>>> >                  if (!hpb)
>>>> >                          continue;
>>>> >
>>>> >                  if (ufshpb_get_state(hpb) != HPB_PRESENT)
>>>> >                          continue;
>>>> >                  ufshpb_set_state(hpb, HPB_SUSPEND);
>>>> > +                ufshpb_cancel_jobs(hpb);
>>>> 
>>>> Here may have a dead lock problem - in the case of runtime suspend,
>>>> when ufshpb_suspend() is invoked, all of hba's children scsi devices
>>>> are in RPM_SUSPENDED state. When this line tries to cancel a running
>>>> map work, i.e. when ufshpb_get_map_req() calls below lines, it will
>>>> be stuck at blk_queue_enter().
>>>> 
>>>> req = blk_get_request(hpb->sdev_ufs_lu->request_queue,
>>>>                       REQ_OP_SCSI_IN, 0);
>>>> 
>>>> Please check block layer power management, and see also commit
>>>> d55d15a33
>>>> ("scsi: block: Do not accept any requests while suspended").
>>> 
>>> I am agree with your comment.
>>> How about add BLK_MQ_REQ_NOWAIT flag on blk_get_request() to avoid
>>> hang?
>>> 
>> 
>> That won't work - BLK_MQ_REQ_NOWAIT allows one to fast fail from
>> blk_mq_get_tag(),
>> but blk_queue_enter() comes before __blk_mq_alloc_request();
>> 
> In blk_queue_enter(), BLK_MQ_REQ_NOWAIT flag can make error than wait 
> rpm
> resume. Please refer following code.

Oops, sorry, my memory needs to be refreshed on that part.

But will BLK_MQ_REQ_NOWAIT flag breaks your original purpose? When
runtime suspend is out of the picture, if traffic is heavy on the
request queue, map_work() will be stopped frequently once it is
not able to get a request from the queue - that shall pull down the
efficiency of one map_work(), that may hurt random performance...

Can Guo.

> 
> int blk_queue_enter(struct request_queue *q, blk_mq_req_flags_t flags)
> {
> 	const bool pm = flags & BLK_MQ_REQ_PM;
> 
> 	while (true) {
> 		bool success = false;
> 
> 		rcu_read_lock();
> 		if (percpu_ref_tryget_live(&q->q_usage_counter)) {
> 			/*
> 			 * The code that increments the pm_only counter is
> 			 * responsible for ensuring that that counter is
> 			 * globally visible before the queue is unfrozen.
> 			 */
> 			if ((pm && queue_rpm_status(q) != RPM_SUSPENDED) ||
> 			    !blk_queue_pm_only(q)) {
> 				success = true;
> 			} else {
> 				percpu_ref_put(&q->q_usage_counter);
> 			}
> 		}
> 		rcu_read_unlock();
> 
> 		if (success)
> 			return 0;
> 
> 		if (flags & BLK_MQ_REQ_NOWAIT)
> 			return -EBUSY;	<-- out from the function.
> 
> Thanks,
> Daejun
