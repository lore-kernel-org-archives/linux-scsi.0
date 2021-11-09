Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4196CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 03:19:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 285CB61284
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Nov 2021 03:19:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236884AbhKIDWG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Nov 2021 22:22:06 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:48702 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231910AbhKIDWG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Nov 2021 22:22:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1636427960;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/tDkykZsFN5OZCu57vQp5oNz6gnK/qbWS+eRe3IMJqQ=;
        b=EcH8FMrT6DRvQ8/CtUANDowEgDp+lp18cUlWWh0BzrHFPSGOZBcBqEqQ6kWJB+3IsjWJRi
        m4lzNedl17x3SGOcvldEokubRUXa/deuUjwqP7wtNo3r/7Job0OgjLIuNhMvZfRm981dEL
        1eKqL6F46UjkHe2Ed6HnTdzBwBAjnF4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-IujRaP_1Ng-F6m1Cre3dgA-1; Mon, 08 Nov 2021 22:19:17 -0500
X-MC-Unique: IujRaP_1Ng-F6m1Cre3dgA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4E4681006AA1;
        Tue,  9 Nov 2021 03:19:16 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4BD2660BE5;
        Tue,  9 Nov 2021 03:19:01 +0000 (UTC)
Date:   Tue, 9 Nov 2021 11:18:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Yi Zhang <yi.zhang@redhat.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] scsi: make sure that request queue queiesce and
 unquiesce balanced
Message-ID: <YYnooJNLvHIQA0Xk@T590>
References: <20211103034305.3691555-1-ming.lei@redhat.com>
 <20211103034305.3691555-4-ming.lei@redhat.com>
 <08f0e186093b0d5067347a1376228010cb4cc7f4.camel@HansenPartnership.com>
 <YYnEVuwp/jMngPYo@T590>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYnEVuwp/jMngPYo@T590>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James,

On Tue, Nov 09, 2021 at 08:44:06AM +0800, Ming Lei wrote:
> Hello James,
> 
> On Mon, Nov 08, 2021 at 11:42:01AM -0500, James Bottomley wrote:
> > On Wed, 2021-11-03 at 11:43 +0800, Ming Lei wrote:
> > [...]
> > > +void scsi_start_queue(struct scsi_device *sdev)
> > > +{
> > > +	if (cmpxchg(&sdev->queue_stopped, 1, 0))
> > > +		blk_mq_unquiesce_queue(sdev->request_queue);
> > > +}
> > > +
> > > +static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
> > > +{
> > > +	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
> > > +		if (nowait)
> > > +			blk_mq_quiesce_queue_nowait(sdev-
> > > >request_queue);
> > > +		else
> > > +			blk_mq_quiesce_queue(sdev->request_queue);
> > > +	} else {
> > > +		if (!nowait)
> > > +			blk_mq_wait_quiesce_done(sdev->request_queue);
> > > +	}
> > > +}
> > 
> > This looks counter intuitive.  I assume it's done so that if we call
> > scsi_stop_queue when the queue has already been stopped, it waits until
> 
> The motivation is to balance blk_mq_quiesce_queue_nowait()/blk_mq_quiesce_queue()
> and blk_mq_unquiesce_queue().
> 
> That needs one extra mutex to cover the quiesce action and update
> the flag, but we can't hold the mutex in scsi_internal_device_block_nowait(),
> so take this way with the atomic flag.
> 
> > the queue is actually quiesced before returning so the behaviour is the
> > same in the !nowait case?  Some sort of comment explaining that would
> > be useful.
> 
> I will add comment on the current usage.

Are you fine with the following comment?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e8925a35cb3a..9e3bf028f95a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -2661,6 +2661,13 @@ void scsi_start_queue(struct scsi_device *sdev)
 
 static void scsi_stop_queue(struct scsi_device *sdev, bool nowait)
 {
+	/*
+	 * The atomic variable of ->queue_stopped covers that
+	 * blk_mq_quiesce_queue* is balanced with blk_mq_unquiesce_queue.
+	 *
+	 * However, we still need to wait until quiesce is done
+	 * in case that queue has been stopped.
+	 */
 	if (!cmpxchg(&sdev->queue_stopped, 0, 1)) {
 		if (nowait)
 			blk_mq_quiesce_queue_nowait(sdev->request_queue);


Thanks,
Ming

