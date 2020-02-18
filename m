Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0961C34048
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB0B12464E
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 17:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582047682;
	bh=KQhF/XCgFDGqcQGvzAyuvxtX381KYo5JSJAgfzEVDZg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=g+LXAdLFleQ3i1v8nhS/nZTPw34s6odJi8IZQmkDFMbdiXHJBwJH34Qw3My2P7QVU
	 xmb+bhvSjlRLx9Zwbvie5H9ABVPeTL3VNRV+Vri6TxsW9ShnkX3U7jQoNZ48Q2dMyC
	 gZoML6gmnQNJkwwb2w3oYPYSkYe8csS+UPDY3R9c=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726567AbgBRRlW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 12:41:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:59008 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726403AbgBRRlV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 18 Feb 2020 12:41:21 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F89D24649;
        Tue, 18 Feb 2020 17:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582047681;
        bh=KQhF/XCgFDGqcQGvzAyuvxtX381KYo5JSJAgfzEVDZg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NYklz1TWM2ogfetiDX/78TQ3U3TX6aQUc7hzJ6lFKs5jVyuAaKKTWUQRRPVPcNEWV
         puZObhizJKKIXVDUtsgo3+ni0/vzVqQ3/vkAFh6UGUz2gLBoWvhS1/b6T/kCCGKtgu
         XsnXix5fQaoLmtT8eP3ebvhLdtQTQscn4b19tbP0=
Date:   Wed, 19 Feb 2020 02:41:14 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com>
References: <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
 <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com>
 <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
 <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
 <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
 <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 18, 2020 at 10:54:54AM -0500, Tim Walker wrote:
> With regards to our discussion on queue depths, it's common knowledge
> that an HDD choses commands from its internal command queue to
> optimize performance. The HDD looks at things like the current
> actuator position, current media rotational position, power
> constraints, command age, etc to choose the best next command to
> service. A large number of commands in the queue gives the HDD a
> better selection of commands from which to choose to maximize
> throughput/IOPS/etc but at the expense of the added latency due to
> commands sitting in the queue.
> 
> NVMe doesn't allow us to pull commands randomly from the SQ, so the
> HDD should attempt to fill its internal queue from the various SQs,
> according to the SQ servicing policy, so it can have a large number of
> commands to choose from for its internal command processing
> optimization.

You don't need multiple queues for that. While the device has to fifo
fetch commands from a host's submission queue, it may reorder their
executuion and completion however it wants, which you can do with a
single queue.
 
> It seems to me that the host would want to limit the total number of
> outstanding commands to an NVMe HDD

The host shouldn't have to decide on limits. NVMe lets the device report
it's queue count and depth. It should the device's responsibility to
report appropriate values that maximize iops within your latency limits,
and the host will react accordingly.
