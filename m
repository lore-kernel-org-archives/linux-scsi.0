Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC69CC3404D
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 02:16:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B5B6A207FD
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 02:16:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DxU6PHiN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727333AbgBSCQG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 21:16:06 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:47838 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726882AbgBSCQG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 21:16:06 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582078564;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qK22eFnPp6Y6N7ivF93PnBHTh+akjIs7qzO+QRbCQwU=;
        b=DxU6PHiN/FGe9iPebGZT2lgIBZMAloWZHfM2/BqynT8R1eiPObbQBsX272Q02zCNl/MO+O
        W/5O9Mp4OJFTS9dHrlN6Zo1G9zJAdH78tOFdp0nwDP5AVDp4+Nj018UCEgmTqiMBjPMHzy
        9okJut1XlxCtQNjJ1CPrwdGRNMBEGzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-330-8J29FEukOL-h00bsx0WeBA-1; Tue, 18 Feb 2020 21:15:54 -0500
X-MC-Unique: 8J29FEukOL-h00bsx0WeBA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 68A7C107ACC5;
        Wed, 19 Feb 2020 02:15:53 +0000 (UTC)
Received: from ming.t460p (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1BE3D17DC8;
        Wed, 19 Feb 2020 02:15:45 +0000 (UTC)
Date:   Wed, 19 Feb 2020 10:15:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Keith Busch <kbusch@kernel.org>,
        Tim Walker <tim.t.walker@seagate.com>,
        Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200219021540.GC31488@ming.t460p>
References: <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com>
 <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
 <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
 <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
 <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com>
 <20200219013137.GA31488@ming.t460p>
 <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 01:53:53AM +0000, Damien Le Moal wrote:
> On 2020/02/19 10:32, Ming Lei wrote:
> > On Wed, Feb 19, 2020 at 02:41:14AM +0900, Keith Busch wrote:
> >> On Tue, Feb 18, 2020 at 10:54:54AM -0500, Tim Walker wrote:
> >>> With regards to our discussion on queue depths, it's common knowledge
> >>> that an HDD choses commands from its internal command queue to
> >>> optimize performance. The HDD looks at things like the current
> >>> actuator position, current media rotational position, power
> >>> constraints, command age, etc to choose the best next command to
> >>> service. A large number of commands in the queue gives the HDD a
> >>> better selection of commands from which to choose to maximize
> >>> throughput/IOPS/etc but at the expense of the added latency due to
> >>> commands sitting in the queue.
> >>>
> >>> NVMe doesn't allow us to pull commands randomly from the SQ, so the
> >>> HDD should attempt to fill its internal queue from the various SQs,
> >>> according to the SQ servicing policy, so it can have a large number of
> >>> commands to choose from for its internal command processing
> >>> optimization.
> >>
> >> You don't need multiple queues for that. While the device has to fifo
> >> fetch commands from a host's submission queue, it may reorder their
> >> executuion and completion however it wants, which you can do with a
> >> single queue.
> >>  
> >>> It seems to me that the host would want to limit the total number of
> >>> outstanding commands to an NVMe HDD
> >>
> >> The host shouldn't have to decide on limits. NVMe lets the device report
> >> it's queue count and depth. It should the device's responsibility to
> > 
> > Will NVMe HDD support multiple NS? If yes, this queue depth isn't
> > enough, given all NSs share this single host queue depth.
> > 
> >> report appropriate values that maximize iops within your latency limits,
> >> and the host will react accordingly.
> > 
> > Suppose NVMe HDD just wants to support single NS and there is single queue,
> > if the device just reports one host queue depth, block layer IO sort/merge
> > can only be done when there is device saturation feedback provided.
> > 
> > So, looks either NS queue depth or per-NS device saturation feedback
> > mechanism is needed, otherwise NVMe HDD may have to do internal IO
> > sort/merge.
> 
> SAS and SATA HDDs today already do internal IO reordering and merging, a
> lot. That is partly why even with "none" set as the scheduler, you can see
> iops increasing with QD used.

That is why I asked if NVMe HDD will attempt to sort/merge IO among SQs
from the beginning, but Tim said no, see:

https://lore.kernel.org/linux-block/20200212215251.GA25314@ming.t460p/T/#m2d0eff5ef8fcaced0f304180e571bb8fefc72e84

It could be cheap for NVMe HDD to do that, given all queues/requests
just stay in system's RAM.

Also I guess internal IO sort/merge may not be good enough compared with
SW's implementation:

1) device internal queue depth is often low, and the participated requests won't
be enough many, but SW's scheduler queue depth is often 2 times of
device queue depth.

2) HDD drive doesn't have context info, so when concurrent IOs are run from
multiple contexts, HDD internal reorder/merge can't work well enough. blk-mq
doesn't address this case too, however the legacy IO path does consider that
via IOC batch.


Thanks, 
Ming

