Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A1B56C77B7A
	for <linux-scsi@archiver.kernel.org>; Thu, 18 May 2023 02:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjERClB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 17 May 2023 22:41:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbjERClA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 17 May 2023 22:41:00 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3141A4
        for <linux-scsi@vger.kernel.org>; Wed, 17 May 2023 19:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1684377615;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rXkSB9jfwGCWMCTsTJhRgp+dpc2WRKDS72vdcWXZKuE=;
        b=JsGDi2EozG4AVfzm7Ug8PgXY5sFcp5KVYmdxD6KSmoBnUc2p5JUfKo1XC25UpmooP44u6E
        6baFBKwvyQNB0TOoqrOb0tMOWVLMNpA8VKF/nn+1of7WaURtJNim+PZ2AC1G4oLHiQ7Lva
        SMBEFfwCVbjbR3Sqic096wZfRES0BUE=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-569-KoTcBLsTMiuP4A_GIRUMuA-1; Wed, 17 May 2023 22:40:10 -0400
X-MC-Unique: KoTcBLsTMiuP4A_GIRUMuA-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 179D9185A78B;
        Thu, 18 May 2023 02:40:10 +0000 (UTC)
Received: from ovpn-8-16.pek2.redhat.com (ovpn-8-25.pek2.redhat.com [10.72.8.25])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1FF94492C3F;
        Thu, 18 May 2023 02:40:04 +0000 (UTC)
Date:   Thu, 18 May 2023 10:39:59 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.g.garry@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH v3 4/4] scsi: core: Delay running the queue if the host
 is blocked
Message-ID: <ZGWP/3dX1sgpRj+t@ovpn-8-16.pek2.redhat.com>
References: <20230517230927.1091124-1-bvanassche@acm.org>
 <20230517230927.1091124-5-bvanassche@acm.org>
 <ZGV8YfsLYIR2H21/@ovpn-8-16.pek2.redhat.com>
 <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07c13761-7f71-3281-fff7-60ec196759c5@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 17, 2023 at 07:34:38PM -0700, Bart Van Assche wrote:
> On 5/17/23 18:16, Ming Lei wrote:
> > On Wed, May 17, 2023 at 04:09:27PM -0700, Bart Van Assche wrote:
> > > @@ -1767,7 +1767,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_ctx *hctx,
> > >   		break;
> > >   	case BLK_STS_RESOURCE:
> > >   	case BLK_STS_ZONE_RESOURCE:
> > > -		if (scsi_device_blocked(sdev))
> > > +		if (scsi_device_blocked(sdev) || shost->host_self_blocked)
> > >   			ret = BLK_STS_DEV_RESOURCE;
> > 
> > What if scsi_unblock_requests() is just called after the above check and
> > before returning to block layer core? Then this request is invisible to
> > scsi_run_host_queues()<-scsi_unblock_requests(), and io hang happens.
> 
> If returning BLK_STS_DEV_RESOURCE could cause an I/O hang, wouldn't that be
> a bug in the block layer core? Isn't the block layer core expected to rerun
> the queue after a delay if a block driver returns BLK_STS_DEV_RESOURCE? See
> also blk_mq_dispatch_rq_list().

Please see comment for BLK_STS_DEV_RESOURCE:

/*
 * BLK_STS_DEV_RESOURCE is returned from the driver to the block layer if
 * device related resources are unavailable, but the driver can guarantee
 * that the queue will be rerun in the future once resources become
 * available again. This is typically the case for device specific
 * resources that are consumed for IO. If the driver fails allocating these
 * resources, we know that inflight (or pending) IO will free these
 * resource upon completion.

Basically it requires driver to re-run queue.

In reality, it can be full of race, maybe we can just remove
BLK_STS_DEV_RESOURCE.

Thanks,
Ming

