Return-Path: <SRS0=Rfh9=BB=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 422C4C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 01:46:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1454F2073A
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Jul 2020 01:46:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="Ibt/xKcO"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731614AbgGVBq2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jul 2020 21:46:28 -0400
Received: from mail29.static.mailgun.info ([104.130.122.29]:52552 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731592AbgGVBq2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 21 Jul 2020 21:46:28 -0400
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1595382386; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=/jxanz1wFazqMvN3WsdKChaq8AyQBI/wW5LslckLOws=;
 b=Ibt/xKcOOFTEq8mYFEDBGQRNOVa+G1acfczjVaCX8OQGHQaXtIfUf/7Pcj0EGWelGiMfvueQ
 lkGkxsZLD8G0qgE6PDZAWd2aVdpXagnEm1xI1k7NmmItoaUIIFpzlyHq/XqGZbIAWwW8x8Sb
 UBpoZZR2e9OJj7ozOLcRc+1SyJM=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n03.prod.us-east-1.postgun.com with SMTP id
 5f179a64e3bee12510cc0e04 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Wed, 22 Jul 2020 01:46:12
 GMT
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id BD5DFC433C6; Wed, 22 Jul 2020 01:46:11 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: cang)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id CDC1EC433C9;
        Wed, 22 Jul 2020 01:46:10 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 22 Jul 2020 09:46:10 +0800
From:   Can Guo <cang@codeaurora.org>
To:     Alan Stern <stern@rowland.harvard.edu>
Cc:     Bart Van Assche <bvanassche@acm.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2] SCSI and block: Simplify resume handling
In-Reply-To: <20200701183718.GA507293@rowland.harvard.edu>
References: <20200701183718.GA507293@rowland.harvard.edu>
Message-ID: <d2605929ee63b3a2386bc01965202950@codeaurora.org>
X-Sender: cang@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Alan,

On 2020-07-02 02:37, Alan Stern wrote:
> Commit 05d18ae1cc8a ("scsi: pm: Balance pm_only counter of request
> queue during system resume") fixed a problem in the block layer's
> runtime-PM code: blk_set_runtime_active() failed to call
> blk_clear_pm_only().  However, the commit's implementation was
> awkward; it forced the SCSI system-resume handler to choose whether to
> call blk_post_runtime_resume() or blk_set_runtime_active(), depending
> on whether or not the SCSI device had previously been runtime
> suspended.
> 

Yeah, even I thoght it was awkward as I couldn't find a way or a 
existing
API to fix it subtly without changing block layer. I was trying not to
make noise to block layer as I am not an expert of it, so I chose the 
akward
way to keep the fix within driver layer. Anyways, thanks for the change 
and
I will come back after I test it.

Can Guo.

> This patch simplifies the situation considerably by adding the missing
> function call directly into blk_set_runtime_active() (under the
> condition that the queue is not already in the RPM_ACTIVE state).
> This allows the SCSI routine to revert back to its original form.
> Furthermore, making this change reveals that blk_post_runtime_resume()
> (in its success pathway) does exactly the same thing as
> blk_set_runtime_active().  The duplicate code is easily removed by
> making one routine call the other.
> 
> No functional changes are intended.
> 
> Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
> CC: Can Guo <cang@codeaurora.org>
> CC: Bart Van Assche <bvanassche@acm.org>
> 
> ---
> 
> v2:	Don't call blk_clear_pm_only() if the queue's RPM status was
> 	already set to RPM_ACTIVE.  This happens during a system resume
> 	if the device was not in runtime suspend beforehand.
> 
> Martin:
> 
> Since you merged the oritinal 05d18ae1cc8a commit, I'm submitting this 
> to
> you as an update.  If you would prefer to have it go by way of the
> block-layer tree, let me know and I'll resend it.
> 
> 
> [as1939b]
> 
> 
>  block/blk-pm.c         |   30 +++++++++++++++---------------
>  drivers/scsi/scsi_pm.c |   10 ++--------
>  2 files changed, 17 insertions(+), 23 deletions(-)
> 
> Index: usb-devel/block/blk-pm.c
> ===================================================================
> --- usb-devel.orig/block/blk-pm.c
> +++ usb-devel/block/blk-pm.c
> @@ -164,30 +164,21 @@ EXPORT_SYMBOL(blk_pre_runtime_resume);
>   *
>   * Description:
>   *    Update the queue's runtime status according to the return value 
> of the
> - *    device's runtime_resume function. If it is successfully resumed, 
> process
> - *    the requests that are queued into the device's queue when it is 
> resuming
> - *    and then mark last busy and initiate autosuspend for it.
> + *    device's runtime_resume function. If the resume was successful, 
> call
> + *    blk_set_runtime_active() to do the real work of restarting the 
> queue.
>   *
>   *    This function should be called near the end of the device's
>   *    runtime_resume callback.
>   */
>  void blk_post_runtime_resume(struct request_queue *q, int err)
>  {
> -	if (!q->dev)
> -		return;
> -
> -	spin_lock_irq(&q->queue_lock);
>  	if (!err) {
> -		q->rpm_status = RPM_ACTIVE;
> -		pm_runtime_mark_last_busy(q->dev);
> -		pm_request_autosuspend(q->dev);
> -	} else {
> +		blk_set_runtime_active(q);
> +	} else if (q->dev) {
> +		spin_lock_irq(&q->queue_lock);
>  		q->rpm_status = RPM_SUSPENDED;
> +		spin_unlock_irq(&q->queue_lock);
>  	}
> -	spin_unlock_irq(&q->queue_lock);
> -
> -	if (!err)
> -		blk_clear_pm_only(q);
>  }
>  EXPORT_SYMBOL(blk_post_runtime_resume);
> 
> @@ -204,15 +195,24 @@ EXPORT_SYMBOL(blk_post_runtime_resume);
>   * This function can be used in driver's resume hook to correct queue
>   * runtime PM status and re-enable peeking requests from the queue. It
>   * should be called before first request is added to the queue.
> + *
> + * This function is also called by blk_post_runtime_resume() for 
> successful
> + * runtime resumes.  It does everything necessary to restart the 
> queue.
>   */
>  void blk_set_runtime_active(struct request_queue *q)
>  {
>  	if (q->dev) {
> +		int old_status;
> +
>  		spin_lock_irq(&q->queue_lock);
> +		old_status = q->rpm_status;
>  		q->rpm_status = RPM_ACTIVE;
>  		pm_runtime_mark_last_busy(q->dev);
>  		pm_request_autosuspend(q->dev);
>  		spin_unlock_irq(&q->queue_lock);
> +
> +		if (old_status != RPM_ACTIVE)
> +			blk_clear_pm_only(q);
>  	}
>  }
>  EXPORT_SYMBOL(blk_set_runtime_active);
> Index: usb-devel/drivers/scsi/scsi_pm.c
> ===================================================================
> --- usb-devel.orig/drivers/scsi/scsi_pm.c
> +++ usb-devel/drivers/scsi/scsi_pm.c
> @@ -80,10 +80,6 @@ static int scsi_dev_type_resume(struct d
>  	dev_dbg(dev, "scsi resume: %d\n", err);
> 
>  	if (err == 0) {
> -		bool was_runtime_suspended;
> -
> -		was_runtime_suspended = pm_runtime_suspended(dev);
> -
>  		pm_runtime_disable(dev);
>  		err = pm_runtime_set_active(dev);
>  		pm_runtime_enable(dev);
> @@ -97,10 +93,8 @@ static int scsi_dev_type_resume(struct d
>  		 */
>  		if (!err && scsi_is_sdev_device(dev)) {
>  			struct scsi_device *sdev = to_scsi_device(dev);
> -			if (was_runtime_suspended)
> -				blk_post_runtime_resume(sdev->request_queue, 0);
> -			else
> -				blk_set_runtime_active(sdev->request_queue);
> +
> +			blk_set_runtime_active(sdev->request_queue);
>  		}
>  	}
