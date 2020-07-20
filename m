Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF1CC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 01:32:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 207DD208B3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 01:32:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BFfsi3/8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726530AbgGTBca (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jul 2020 21:32:30 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:28679 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726468AbgGTBca (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jul 2020 21:32:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595208749;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LKXUgkFTtCjgOzaIWPHlugk+9da50v8Cx/Ge5BvU5Q4=;
        b=BFfsi3/8bQT7sfuNZFZy+h7BMrNKFY442nRR6Lxe0iogqMhTJkt33DSlr2dFDdtrHcpfUF
        Ad/ZLRKg4Hhw397g+mKbTZ7op9QGw8Ae1ze052nZAMoEjSCDTGa/ObkkEW59zpQxuWebjx
        iPQU+8OgZ9OLQ6hkz1qC/NLY3Lz/BB0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-293-ZHsXdbn8MKWiFUENKQkPWQ-1; Sun, 19 Jul 2020 21:32:26 -0400
X-MC-Unique: ZHsXdbn8MKWiFUENKQkPWQ-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A6E5F801A03;
        Mon, 20 Jul 2020 01:32:24 +0000 (UTC)
Received: from T590 (ovpn-13-88.pek2.redhat.com [10.72.13.88])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 02A9F872E6;
        Mon, 20 Jul 2020 01:32:17 +0000 (UTC)
Date:   Mon, 20 Jul 2020 09:32:13 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] scsi: core: run queue in case of IO queueing failure
Message-ID: <20200720013213.GA791101@T590>
References: <20200708131405.3346107-1-ming.lei@redhat.com>
 <bd3039d4-0c24-ad67-bdfe-85096ad60721@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd3039d4-0c24-ad67-bdfe-85096ad60721@acm.org>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 18, 2020 at 01:22:27PM -0700, Bart Van Assche wrote:
> On 2020-07-08 06:14, Ming Lei wrote:
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 534b85e87c80..4d7fab9e8af9 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -1694,6 +1694,16 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> >  		 */
> >  		if (req->rq_flags & RQF_DONTPREP)
> >  			scsi_mq_uninit_cmd(cmd);
> > +
> > +		/*
> > +		 * Requests may be held in block layer queue because of
> > +		 * resource contention. We usually run queue in normal
> > +		 * completion for queuing these requests again. Block layer
> > +		 * will finish this failed request simply, run queue in case
> > +		 * of IO queueing failure so that requests can get chance to
> > +		 * be finished.
> > +		 */
> > +		scsi_run_queue(q);
> >  		break;
> >  	}
> >  	return ret;
> 
> So this patch causes blk_mq_run_hw_queues() to be called synchronously
> from inside blk_mq_run_hw_queues()? Wouldn't it be better to avoid such

OK, look this patch may risk to overflow stack.

> recursion and to run the queue asynchronously instead of synchronously
> from inside scsi_queue_rq()? The following code already exists in
> scsi_end_request():
> 
> 	blk_mq_run_hw_queues(q, true);

How about the following change?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index b9adee0a9266..9798fbffe307 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -564,6 +564,15 @@ static void scsi_mq_uninit_cmd(struct scsi_cmnd *cmd)
 	scsi_uninit_cmd(cmd);
 }
 
+static void scsi_run_queue_async(struct scsi_device *sdev)
+{
+	if (scsi_target(sdev)->single_lun ||
+	    !list_empty(&sdev->host->starved_list))
+		kblockd_schedule_work(&sdev->requeue_work);
+	else
+		blk_mq_run_hw_queues(sdev->request_queue, true);
+}
+
 /* Returns false when no more bytes to process, true if there are more */
 static bool scsi_end_request(struct request *req, blk_status_t error,
 		unsigned int bytes)
@@ -608,11 +617,7 @@ static bool scsi_end_request(struct request *req, blk_status_t error,
 
 	__blk_mq_end_request(req, error);
 
-	if (scsi_target(sdev)->single_lun ||
-	    !list_empty(&sdev->host->starved_list))
-		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(q, true);
+	scsi_run_queue_async(sdev);
 
 	percpu_ref_put(&q->q_usage_counter);
 	return false;
@@ -1721,6 +1726,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
 		 */
 		if (req->rq_flags & RQF_DONTPREP)
 			scsi_mq_uninit_cmd(cmd);
+		scsi_run_queue_async(sdev);
 		break;
 	}
 	return ret;


Thanks,
Ming

