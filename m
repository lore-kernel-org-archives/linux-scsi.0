Return-Path: <SRS0=fhi0=3M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5097EC3F68F
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 281F324673
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Jan 2020 02:54:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ApLmwZQ+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgAWCyz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Jan 2020 21:54:55 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:60899 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725911AbgAWCyy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Jan 2020 21:54:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579748092;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IjYQVjPqOQ1qGfooRJJ7hb+eYyaT9PGEQqIBw0hq/MA=;
        b=ApLmwZQ+/gGJLvRo2ek3RAZvrn8VgEu2BBwVTvCzbn9AnIh/EyZsvd52Q8MbhEACDe6vmb
        Jw3Y1bhbF8ZEr7CRWLNwq5q4h5a3f2uU3mZnbM4kbV8VReZJyKSqBlUSnw/sR9+XEV+kcm
        R4L0OOA/BrigdRGh3xUFlbiuenfzhMk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-309-WLOrVAL8PoitTupn_QVZeg-1; Wed, 22 Jan 2020 21:54:46 -0500
X-MC-Unique: WLOrVAL8PoitTupn_QVZeg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7E2A01005513;
        Thu, 23 Jan 2020 02:54:44 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9FCA480A46;
        Thu, 23 Jan 2020 02:54:33 +0000 (UTC)
Date:   Thu, 23 Jan 2020 10:54:29 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
Subject: Re: [PATCH 5/6] scsi: core: don't limit per-LUN queue depth for SSD
 when HBA needs
Message-ID: <20200123025429.GA5191@ming.t460p>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-6-ming.lei@redhat.com>
 <yq1y2u1if7t.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1y2u1if7t.fsf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Mon, Jan 20, 2020 at 11:52:06PM -0500, Martin K. Petersen wrote:
> 
> Ming,
> 
> > NVMe doesn't have such per-request-queue(namespace) queue depth, so it
> > is reasonable to ignore the limit for SCSI SSD too.
> 
> It is really not. A free host tag does not guarantee that the target
> device can queue the command.

Yeah, I agree.

> 
> The assumption that SSDs are somehow special because they are "fast" is
> not valid. Given the common hardware queue depth for a SAS device of
> ~128 it is often trivial to drive a device into a congestion
> scenario. We see it all the time for non-rotational devices, SSDs and
> arrays alike. The SSD heuristic is simply not going to fly.

In reality, the channel number of SSD is very limited, it should be
dozens of in enterprise grade SSD, so the device itself can be
saturated by limited in-flight IOs.

However, it depends on if the target device returns the congestion
to host. From my observation, looks there isn't such feedback
from NVMe target.

If SSD target device doesn't provide such kind of congestion feedback,
tracking in-flight per-LUN IO via .device_busy doesn't make any
difference.

Even if there was such SSD target which provides such congestion
feedback, bypassing .device_busy won't cause big effect too since
blk-mq's SCHED_RESTART will retry this IO returning STS_RESOURCE
only after another in-flight one is completed.

> 
> Don't get me wrong, I am very sympathetic to obliterating device_busy in
> the hot path. I just don't think it is as easy as just ignoring the
> counter and hope for the best. Dynamic queue depth management is an
> integral part of the SCSI protocol, not something we can just decide to
> bypass because a device claims to be of a certain media type or speed.

At least, Broadcom guys tests this patch on megaraid raid and the results
shows that big improvement was got, that is why the flag is only set
on megaraid host.

> 
> I would prefer not to touch drivers that rely on cmd_per_lun / untagged
> operation and focus exclusively on the ones that use .track_queue_depth.
> For those we could consider an adaptive queue depth management scheme.
> Something like not maintaining device_busy until we actually get a
> QUEUE_FULL condition. And then rely on the existing queue depth ramp up
> heuristics to determine when to disable the busy counter again. Maybe
> with an additional watermark or time limit to avoid flip-flopping.
> 
> If that approach turns out to work, we should convert all remaining
> non-legacy drivers to .track_queue_depth so we only have two driver
> queuing flavors to worry about.

In theory, .track_queue_depth may only improve sequential IO's
performance for HDD., not very effective for SSD. Or just save a bit
CPU cycles in case of SSD.

I will study the related drivers/device a bit more wrt. track_queue_depth().


Thanks,
Ming

