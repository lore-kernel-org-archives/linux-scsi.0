Return-Path: <SRS0=UT6l=YD=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84665ECE58C
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 00:43:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 667E4218AC
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Oct 2019 00:43:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732559AbfJJAno (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Oct 2019 20:43:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55144 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731542AbfJJAnn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Oct 2019 20:43:43 -0400
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 42FC881F11;
        Thu, 10 Oct 2019 00:43:43 +0000 (UTC)
Received: from ming.t460p (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6507E19C69;
        Thu, 10 Oct 2019 00:43:34 +0000 (UTC)
Date:   Thu, 10 Oct 2019 08:43:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [RFC PATCH V4 2/2] scsi: core: don't limit per-LUN queue depth
 for SSD
Message-ID: <20191010004328.GA23292@ming.t460p>
References: <20191009093241.21481-1-ming.lei@redhat.com>
 <20191009093241.21481-3-ming.lei@redhat.com>
 <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <75fe51d7-714f-8a51-89b5-aeeb7d318fdc@acm.org>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.25]); Thu, 10 Oct 2019 00:43:43 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 09, 2019 at 09:05:26AM -0700, Bart Van Assche wrote:
> On 10/9/19 2:32 AM, Ming Lei wrote:
> > @@ -354,7 +354,8 @@ void scsi_device_unbusy(struct scsi_device *sdev, struct scsi_cmnd *cmd)
> >   	if (starget->can_queue > 0)
> >   		atomic_dec(&starget->target_busy);
> > -	atomic_dec(&sdev->device_busy);
> > +	if (!blk_queue_nonrot(sdev->request_queue))
> > +		atomic_dec(&sdev->device_busy);
> >   }
> 
> Hi Ming,
> 
> Does this patch impact the meaning of the queue_depth sysfs attribute (see
> also sdev_store_queue_depth()) and also the queue depth ramp up/down
> mechanism (see also scsi_handle_queue_ramp_up())? Have you considered to

This patch only ignores to track inflight SCSI commands on each
LUN, so it doesn't affect the meaning of sdev->queue_depth, which is
just bypassed for SSD.

> enable/disable busy tracking per LUN depending on whether or not
> sdev->queue_depth < shost->can_queue?

Yeah, we can do it, but that isn't contradictory with this patch, :-)
And we can do it even though sdev->queue_depth < shost->can_queue.

Usually sdev->queue_depth is used for the following reasons:

1) this limit isn't a hard limit, which may improve IO merge with cost
of IO latency.

2) fair dispatch among LUNs.

This patch just tries to not apply per-LUN queue depth for SSD, because:

1) fair dispatch has been done by blk-mq in allocating driver tag

2) IO merge doesn't play big role for SSD, and IO latency can be
increased by applying per-LUN queue depth.

3) NVMe doesn't apply per-ns queue depth

> 
> The megaraid and mpt3sas drivers read sdev->device_busy directly. Is the
> current version of this patch compatible with these drivers?

For megaraid, sdev->device_busy is checked for choosing reply queue,
this way shouldn't be better than using default managed IRQ's mapping.
Similar usage is done on _base_get_high_iops_msix_index().

The only effect may be in scsih_dev_reset(), and 'SUCCESS' message
is dumped even though there is in-flight command on this LUN, but it
can be fixed easily.


Thanks,
Ming
