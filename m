From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH 2/9] IB: add a proper completion queue abstraction
Date: Sun, 22 Nov 2015 08:55:54 -0800
Message-ID: <5651F39A.2020003@acm.org>
References: <1447422410-20891-1-git-send-email-hch@lst.de>
	<1447422410-20891-3-git-send-email-hch@lst.de>
	<564B697A.2020601@sandisk.com>
	<564C2F01.6020407@dev.mellanox.co.il> <564CC15E.7030602@sandisk.com>
	<20151120101644.GC24298@lst.de> <564F4F38.9040505@sandisk.com>
	<56519011.6060204@dev.mellanox.co.il> <20151122101308.GA12189@lst.de>
	<56519A90.5010502@dev.mellanox.co.il> <20151122132352.GA14154@lst.de>
	<5651D7D3.7030509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sf1.bxl.stone.is ([87.238.167.214]:53918 "EHLO sf1.bxl.stone.is"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751930AbbKVQ4Y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 22 Nov 2015 11:56:24 -0500
In-Reply-To: <5651D7D3.7030509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>, Christoph Hellwig <hch@lst.de>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "axboe@fb.com" <axboe@fb.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On 11/22/15 06:57, Sagi Grimberg wrote:
>>> I think that bart wants to allow the caller to select cpu affinity
>>> per CQ. In this case ib_alloc_cq in workqueue mode would need to
>>> accept a affinity_hint from the caller (default to wild-card
>>> WORK_CPU_UNBOUND).
>>
>> Hmm, true.  How would be set that hint from userspace?  I'd really prefer
>> to see a practical justification for it first.
>
> In order to assign CPUs from user-space we'd need an ethtool like
> interface for isert/srpt/<xxxt>. Given that this is something we don't
> want to get into right now, I assumed that Bart meant that srpt
> would take a "least used" approach from srpt driver (which isn't better
> taking the wild-card option I'd say), So I'll let Bart answer...

Hello Christoph and Sagi,

My intention is indeed to allow to control CPU affinity per CQ. One use 
case is to implement a least-used policy in RDMA drivers that use 
multiple completion queues. Another use case is to make CPU affinity 
configurable from user space through something similar to ethtool or via 
sysfs.

Bart.
