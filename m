Return-Path: <SRS0=g50V=BP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98CD6C433DF
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 08:41:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7ADD022B40
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Aug 2020 08:41:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YpfDa2hQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgHEIlF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Aug 2020 04:41:05 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:43279 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726841AbgHEIk7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Aug 2020 04:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596616857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vCqdC0QayVIHiEIjRosykAcabVSJOwH5cXt4Ri7q9RA=;
        b=YpfDa2hQ+5zfc8qcE5yHRIOyPrUS97cj+JxuqFIfblUzMEo1jZRhjEJASo6hHxVcc/4dqK
        QmXOkZwiesartzHFsOSBfvJ7T1aG11ME3e57tbJRlQe/QFUKlb/y3+5wb/Dlx579BwIFo6
        LlUC8aVN3+g0GvDlgkcj+TskFd7WJq4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-18-JLox6VvKNkWfmobMcNlDaQ-1; Wed, 05 Aug 2020 04:40:52 -0400
X-MC-Unique: JLox6VvKNkWfmobMcNlDaQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 943A8106B243;
        Wed,  5 Aug 2020 08:40:50 +0000 (UTC)
Received: from T590 (ovpn-13-169.pek2.redhat.com [10.72.13.169])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C82655DA6A;
        Wed,  5 Aug 2020 08:40:37 +0000 (UTC)
Date:   Wed, 5 Aug 2020 16:40:31 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, Sumit Saxena <sumit.saxena@broadcom.com>,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        "PDL,MEGARAIDLINUX" <megaraidlinux.pdl@broadcom.com>
Subject: Re: [PATCH RFC v7 10/12] megaraid_sas: switch fusion adapters to MQ
Message-ID: <20200805084031.GA1995289@T590>
References: <20200723140758.GA957464@T590>
 <f4a896a3-756e-68bb-7700-cab1e5523c81@huawei.com>
 <20200724024704.GB957464@T590>
 <6531e06c-9ce2-73e6-46fc-8e97400f07b2@huawei.com>
 <20200728084511.GA1326626@T590>
 <965cf22eea98c00618570da8424d0d94@mail.gmail.com>
 <20200729153648.GA1698748@T590>
 <7f94eaf2318cc26ceb64bde88d59d5e2@mail.gmail.com>
 <20200804083625.GA1958244@T590>
 <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afe5eb1be7f416a48d7b5d473f3053d0@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 04, 2020 at 02:57:52PM +0530, Kashyap Desai wrote:
> > >
> > > > However, it looks a bit
> > > > complicated, and I was thinking if one simpler approach can be
> > > > figured
> > > out.
> > >
> > > I was thinking your original approach is simple, but if you think some
> > > other simple approach I can test as part of these series.
> > > BTW, I am still not getting why you think your original approach is
> > > not good design.
> >
> > It is still not straightforward enough or simple enough for proving its
> > correctness, even though the implementation isn't complicated.
> 
> Ming -
> 
> I noted your comments.
> 
> I have completed testing and this particular latest performance issue on
> Volume is outstanding.
> Currently it is 20-25% performance drop in IOPs and we want that to be
> closed before shared host tag is enabled for <megaraid_sas> driver.
> Just for my understanding - What will be the next steps on this ?
> 
> I can validate any new approach/patch for this issue.
> 

Hello,

What do you think of the following patch?

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index c866a4f33871..49f0fc5c7a63 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -552,8 +552,24 @@ static void scsi_run_queue_async(struct scsi_device *sdev)
 	if (scsi_target(sdev)->single_lun ||
 	    !list_empty(&sdev->host->starved_list))
 		kblockd_schedule_work(&sdev->requeue_work);
-	else
-		blk_mq_run_hw_queues(sdev->request_queue, true);
+	else {
+		/*
+		 * smp_mb() implied in either rq->end_io or blk_mq_free_request
+		 * is for ordering writing .device_busy in scsi_device_unbusy()
+		 * and reading sdev->restarts.
+		 */
+		int old = atomic_read(&sdev->restarts);
+
+		if (old) {
+			blk_mq_run_hw_queues(sdev->request_queue, true);
+
+			/*
+			 * ->restarts has to be kept as non-zero if there is
+			 *  new budget contention comes.
+			 */
+			atomic_cmpxchg(&sdev->restarts, old, 0);
+		}
+	}
 }
 
 /* Returns false when no more bytes to process, true if there are more */
@@ -1612,8 +1628,34 @@ static void scsi_mq_put_budget(struct request_queue *q)
 static bool scsi_mq_get_budget(struct request_queue *q)
 {
 	struct scsi_device *sdev = q->queuedata;
+	int ret = scsi_dev_queue_ready(q, sdev);
 
-	return scsi_dev_queue_ready(q, sdev);
+	if (ret)
+		return true;
+
+	/*
+	 * If all in-flight requests originated from this LUN are completed
+	 * before setting .restarts, sdev->device_busy will be observed as
+	 * zero, then blk_mq_delay_run_hw_queue() will dispatch this request
+	 * soon. Otherwise, completion of one of these request will observe
+	 * the .restarts flag, and the request queue will be run for handling
+	 * this request, see scsi_end_request().
+	 */
+	atomic_inc(&sdev->restarts);
+
+	/*
+	 * Order writing .restarts and reading .device_busy, and make sure
+	 * .restarts is visible to scsi_end_request(). Its pair is implied by
+	 * __blk_mq_end_request() in scsi_end_request() for ordering
+	 * writing .device_busy in scsi_device_unbusy() and reading .restarts.
+	 *
+	 */
+	smp_mb__after_atomic();
+
+	if (unlikely(atomic_read(&sdev->device_busy) == 0 &&
+				!scsi_device_blocked(sdev)))
+		blk_mq_delay_run_hw_queues(sdev->request_queue, SCSI_QUEUE_DELAY);
+	return false;
 }
 
 static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index bc5909033d13..1a5c9a3df6d6 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -109,6 +109,7 @@ struct scsi_device {
 	atomic_t device_busy;		/* commands actually active on LLDD */
 	atomic_t device_blocked;	/* Device returned QUEUE_FULL. */
 
+	atomic_t restarts;
 	spinlock_t list_lock;
 	struct list_head starved_entry;
 	unsigned short queue_depth;	/* How deep of a queue we want */

Thanks, 
Ming

