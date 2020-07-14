Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4537C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:45:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F12D22208
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 10:45:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KALDCuTH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727033AbgGNKpC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 06:45:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:54170 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725906AbgGNKpB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 06:45:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594723500;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nB0vBIsbq9kkNJtg9zWJf5hj13k3BrOa2zG52GC1LTM=;
        b=KALDCuTHVYPcdNefJivl36hSP2cGjaZi3mmIS5RQWereYDC48ysGV/N1QkLR5s62cTeoPt
        lQwnv55r8h0E+u3oSW/Ivb3sw4AffMte8txABwbzwx2DPmm8AiZH67Rh3d9FjRsovNFy1a
        NDr7dOpjemRFBSN7/ondDVaKQwYN50k=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-500-fPT6jNIqPN2QgEbf-1OaLg-1; Tue, 14 Jul 2020 06:44:55 -0400
X-MC-Unique: fPT6jNIqPN2QgEbf-1OaLg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 96E88108B;
        Tue, 14 Jul 2020 10:44:52 +0000 (UTC)
Received: from T590 (ovpn-13-177.pek2.redhat.com [10.72.13.177])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DCD0A710B5;
        Tue, 14 Jul 2020 10:44:41 +0000 (UTC)
Date:   Tue, 14 Jul 2020 18:44:37 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     John Garry <john.garry@huawei.com>, don.brace@microsemi.com,
        axboe@kernel.dk, jejb@linux.ibm.com, martin.petersen@oracle.com,
        kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        bvanassche@acm.org, hare@suse.com, hch@lst.de,
        shivasharan.srikanteshwara@broadcom.com,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        megaraidlinux.pdl@broadcom.com
Subject: Re: [PATCH RFC v7 12/12] hpsa: enable host_tagset and switch to MQ
Message-ID: <20200714104437.GB602708@T590>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-13-git-send-email-john.garry@huawei.com>
 <939891db-a584-1ff7-d6a0-3857e4257d3e@huawei.com>
 <3b3ead84-5d2f-dcf2-33d5-6aa12d5d9f7e@suse.de>
 <4319615a-220b-3629-3bf4-1e7fd2d27b92@huawei.com>
 <20200714080631.GA600766@T590>
 <3584bcc3-830a-d50d-bb55-8ac0b686cdc0@huawei.com>
 <799af415-cb02-278e-1af2-c6179a94a8a8@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <799af415-cb02-278e-1af2-c6179a94a8a8@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 14, 2020 at 12:19:07PM +0200, Hannes Reinecke wrote:
> On 7/14/20 11:53 AM, John Garry wrote:
> > On 14/07/2020 09:06, Ming Lei wrote:
> >>> v7 is here:
> >>>
> >>> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7
> >>>
> >>>
> >>> So that should be good to test with for now.
> >>>
> >>> And I was going to ask this same question about smartpqi, so can you
> >>> please
> >>> let me know about this one?
> > 
> > Hi Ming,
> > 
> >> smartpqi is real MQ HBA, do you need any change wrt. shared tags?
> > 
> > Is it really?
> > 
> > As I see, today it maintains a single tagset per HBA. So Hannes' change
> > in this series seems ok. However, I do worry that mainline code may be
> > wrong, as block layer may send can_queue * nr_hw_queues requests, when
> > it seems the HBA can only handle can_queue requests.
> > 
> Correct. There is only one tagset per host, even if the host supports
> several queues (guess why it's called smart PQI :-).
> And mainline code isn't really wrong, it just allocates the next free
> tag from the host tagset; it's not using the block-layer tags at all.
> Precisely because the block layer currently cannot guarantee that tags
> are unique per host.

OK, pqi_alloc_io_request() does the real tag allocation, which looks a
very bad implementation, cause the real tags can be used up easily.

In my machine, there are 32 queues(32 cpu cores), each queue has 1013
tags, so there can be 32*1013 requests coming from block layer, meantime
smartpqi can only handles 1013 requests. I guess it isn't hard to
trigger softlock by running heavy/concurrent smartpqi IO.

> 
> And the point of this patchset is exactly that the block layer will only
> send up to 'can_queue' requests, irrespective on how many hardware
> queues are present.

That is only true for shared tags.

Thanks,
Ming

