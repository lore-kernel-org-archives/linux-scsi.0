Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24B99C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 19:38:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F211B2067D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 19:38:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728191AbgF3TiE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 15:38:04 -0400
Received: from netrider.rowland.org ([192.131.102.5]:33883 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1728166AbgF3TiE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jun 2020 15:38:04 -0400
Received: (qmail 464162 invoked by uid 1000); 30 Jun 2020 15:38:02 -0400
Date:   Tue, 30 Jun 2020 15:38:02 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Martin Kepplinger <martin.kepplinger@puri.sm>, jejb@linux.ibm.com,
        Can Guo <cang@codeaurora.org>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel@puri.sm
Subject: Re: [PATCH] scsi: sd: add runtime pm to open / release
Message-ID: <20200630193802.GA463609@rowland.harvard.edu>
References: <20200623111018.31954-1-martin.kepplinger@puri.sm>
 <ed9ae198-4c68-f82b-04fc-2299ab16df96@acm.org>
 <eccacce9-393c-ca5d-e3b3-09961340e0db@puri.sm>
 <1379e21d-c51a-3710-e185-c2d7a9681fb7@acm.org>
 <20200626154441.GA296771@rowland.harvard.edu>
 <c19f1938-ae47-2357-669d-5b4021aec154@puri.sm>
 <20200629161536.GA405175@rowland.harvard.edu>
 <5231c57d-3f4e-1853-d4d5-cf7f04a32246@acm.org>
 <20200630180255.GA459638@rowland.harvard.edu>
 <1804723c-4aaf-a820-d3ef-e70125017cad@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1804723c-4aaf-a820-d3ef-e70125017cad@acm.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 30, 2020 at 12:23:12PM -0700, Bart Van Assche wrote:
> On 2020-06-30 11:02, Alan Stern wrote:
> > Right now there doesn't seem to be any mechanism for resuming the queue 
> > if an REQ_PREEMPT request is added while the queue is suspended.
> 
> I do not agree with the above statement. My understanding is that resuming
> happens as follows if a request is submitted against a runtime suspended
> queue owned by a SCSI LLD:
> 
> blk_queue_enter()
>   -> blk_pm_request_resume()

Assume that BLK_MQ_REQ_PREEMPT is set in flags.  Then where exactly 
does blk_queue_enter(q, flags) call blk_pm_request_resume(q)?

Nowhere, as far as I can see.

Alan Stern

>     -> pm_request_resume(dev)
>       -> __pm_runtime_resume(dev, RPM_ASYNC)
>         -> rpm_resume(dev, RPM_ASYNC)
>           -> dev->power.request = RPM_REQ_RESUME;
>           -> queue_work(pm_wq, &dev->power.work)
>             -> pm_runtime_work()
>               -> rpm_resume(dev, RPM_NOWAIT)
>                 -> callback = scsi_runtime_resume;
>                 -> rpm_callback(callback, dev);
>                   -> scsi_runtime_resume(dev);
>                     -> sdev_runtime_resume(dev);
>                       -> blk_pre_runtime_resume(sdev->request_queue);
>                         -> q->rpm_status = RPM_RESUMING;
>                       -> sd_resume(dev);
>                         -> sd_start_stop_device(sdkp);
>                           -> sd_pm_ops.runtime_resume == scsi_execute(sdp, START);
>                             -> blk_get_request(..., ..., BLK_MQ_REQ_PREEMPT)
>                               -> blk_mq_alloc_request()
>                                 -> blk_queue_enter()
>                                 -> __blk_mq_alloc_request()
>                             -> blk_execute_rq()
>                             -> blk_put_request()
>                       -> blk_post_runtime_resume(sdev->request_queue);
>                         -> q->rpm_status = RPM_ACTIVE;
>                         -> pm_runtime_mark_last_busy(q->dev);
>                         -> pm_request_autosuspend(q->dev);
> 
> Bart.
