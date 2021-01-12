Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3B2AC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 01:43:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9F72722E01
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 01:43:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732708AbhALBnu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 20:43:50 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:38050 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1732691AbhALBnt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 Jan 2021 20:43:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610415742;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NIhOT4pNKa7iZOJsHhPrtoYrqMdR04bP0cxzx1U7fOU=;
        b=jA8INp4jhhrTe6uBOwm9rndDoWbVOb+ktO/R6vNwsVrve67Cdfwj6FzWdht1HUOh/yrv3z
        yay/cmDQswg5uO/Jg3LBt4fSrQ/2VtAK+fnvqNTp60PKh3fmuQptfqq3fqxFUvs+QUzexh
        gGSwy7svIkzHaIvdTuPDa/2uvmtZVw8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-489-cqjs8m7gNbWW3Oeu4iQ7DA-1; Mon, 11 Jan 2021 20:42:21 -0500
X-MC-Unique: cqjs8m7gNbWW3Oeu4iQ7DA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B145F15720;
        Tue, 12 Jan 2021 01:42:18 +0000 (UTC)
Received: from T590 (ovpn-13-57.pek2.redhat.com [10.72.13.57])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 577E16F13C;
        Tue, 12 Jan 2021 01:42:07 +0000 (UTC)
Date:   Tue, 12 Jan 2021 09:42:03 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>,
        chenxiang <chenxiang66@hisilicon.com>
Subject: Re: About scsi device queue depth
Message-ID: <20210112014203.GA60605@T590>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jan 11, 2021 at 04:21:27PM +0000, John Garry wrote:
> Hi,
> 
> I was looking at some IOMMU issue on a LSI RAID 3008 card, and noticed that
> performance there is not what I get on other SAS HBAs - it's lower.
> 
> After some debugging and fiddling with sdev queue depth in mpt3sas driver, I
> am finding that performance changes appreciably with sdev queue depth:
> 
> sdev qdepth	fio number jobs* 	1	10	20
> 16					1590	1654	1660
> 32					1545	1646	1654
> 64					1436	1085	1070
> 254 (default)				1436	1070	1050

What does the performance number mean? IOPS or others? What is the fio
io test? random IO or sequential IO?

> 
> fio queue depth is 40, and I'm using 12x SAS SSDs.
> 
> I got comparable disparity in results for fio queue depth = 128 and num jobs
> = 1:
> 
> sdev qdepth	fio number jobs* 	1	
> 16					1640
> 32					1618	
> 64					1577	
> 254 (default)				1437	
> 
> IO sched = none.
> 
> That driver also sets queue depth tracking = 1, but never seems to kick in.
> 
> So it seems to me that the block layer is merging more bios per request, as
> averge sg count per request goes up from 1 - > upto 6 or more. As I see,
> when queue depth lowers the only thing that is really changing is that we
> fail more often in getting the budget in
> scsi_mq_get_budget()->scsi_dev_queue_ready().

Right, the behavior basically doesn't change compared with block legacy
io path. And that is why sdev->queue_depth is a bit important for HDD.

> 
> So initial sdev queue depth comes from cmd_per_lun by default or manually
> setting in the driver via scsi_change_queue_depth(). It seems to me that
> some drivers are not setting this optimally, as above.
> 
> Thoughts on guidance for setting sdev queue depth? Could blk-mq changed this
> behavior?

So far, the sdev queue depth is provided by SCSI layer, and blk-mq can
queue one request only if budget is obtained via .get_budget().


Thanks,
Ming

