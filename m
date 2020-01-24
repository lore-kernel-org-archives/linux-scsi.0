Return-Path: <SRS0=sMUn=3N=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5204BC35242
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:00:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2643F24125
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jan 2020 02:00:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XuL1nKuM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgAXCAV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Jan 2020 21:00:21 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:38917 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728665AbgAXCAV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Jan 2020 21:00:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579831219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hnarXVIAqNtneR9ncNVtXlarxtvTH0bQ6mx3gW5lHTA=;
        b=XuL1nKuMXFKtaAzik+d/sAkAFfnEhXcA0+Y9XnUNA8Q/fXUmONS8jF1WEMzwUxq6Mmdvo+
        gtJTVjOFNeob/m5E01Pe02K1jfY9gd8A2D0ru8ykLFsp+lPOqijntxUNs82GB7wA4QOu/3
        cRWFFsgrLH130FtlAUUIxKtkPZoncu8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-272-NndhU_ssNni0j6Lk5AUeDQ-1; Thu, 23 Jan 2020 21:00:14 -0500
X-MC-Unique: NndhU_ssNni0j6Lk5AUeDQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF75E14E8;
        Fri, 24 Jan 2020 02:00:11 +0000 (UTC)
Received: from ming.t460p (ovpn-8-19.pek2.redhat.com [10.72.8.19])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1A9E51001925;
        Fri, 24 Jan 2020 02:00:01 +0000 (UTC)
Date:   Fri, 24 Jan 2020 09:59:57 +0800
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
Message-ID: <20200124015957.GA17387@ming.t460p>
References: <20200119071432.18558-1-ming.lei@redhat.com>
 <20200119071432.18558-6-ming.lei@redhat.com>
 <yq1y2u1if7t.fsf@oracle.com>
 <20200123025429.GA5191@ming.t460p>
 <yq1sgk5ejix.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1sgk5ejix.fsf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

On Thu, Jan 23, 2020 at 08:21:42PM -0500, Martin K. Petersen wrote:
> 
> Ming,
> 
> > However, it depends on if the target device returns the congestion to
> > host. From my observation, looks there isn't such feedback from NVMe
> > target.
> 
> It happens all the time with SCSI devices. It is imperative that this
> keeps working.
> 
> > Even if there was such SSD target which provides such congestion
> > feedback, bypassing .device_busy won't cause big effect too since
> > blk-mq's SCHED_RESTART will retry this IO returning STS_RESOURCE only
> > after another in-flight one is completed.
> 
> The reason we back off is that it allows the device to recover by
> temporarily reducing its workload. In addition, the lower queue depth
> alleviates the risk of commands timing out leading to application I/O
> failures.

The timeout risk may only happen when driver/device doesn't return
congestion feedback, meantime the host queue depth is big enough.

So far we don't see such issue on NVMe which hw queue depth is 1023, and
the hw queue count is often 32+, and not see such timeout report
when there are so many inflight IOs(32 * 1023) on single LUN.

Also megaraid sas's queue depth is much less than (32 * 1023), so it
seems much unlikely to happen.

Megaraid guys, could you clarify if it is one issue? Kashyap, Sumit
and Shivasharan?

> 
> > At least, Broadcom guys tests this patch on megaraid raid and the
> > results shows that big improvement was got, that is why the flag is
> > only set on megaraid host.
> 
> I do not question that it improves performance. That's not my point.
> 
> > In theory, .track_queue_depth may only improve sequential IO's
> > performance for HDD., not very effective for SSD. Or just save a bit
> > CPU cycles in case of SSD.
> 
> This is not about performance. This is about how the system behaves when
> a device is starved for resources or experiencing transient failures.

Could you explain a bit how this patch changes the system beaviror? I
understand the EH just retries the incompleted requests, which total
number is just less than host queue depth.


Thanks,
Ming

