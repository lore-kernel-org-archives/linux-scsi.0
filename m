From: Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Tue, 17 Jan 2017 18:38:43 +0200
Message-ID: <6df6bf6a-7cd3-1700-2b0a-e140325ebf47@grimberg.me>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <53a3fb6c-c75a-519a-f669-2bcab404e01d@grimberg.me>
 <20170117162752.GE6067@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33852 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751035AbdAQQjF (ORCPT
        <rfc822;Linux-scsi@vger.kernel.org>); Tue, 17 Jan 2017 11:39:05 -0500
In-Reply-To: <20170117162752.GE6067@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>


> Just for the record, all tests you've run are with the upper irq_poll_budget of
> 256 [1]?

Yes, but that's the point, I never ever reach this budget because
I'm only processing 1-2 completions per interrupt.

> We (Hannes and me) recently stumbed accross this when trying to poll for more
> than 256 queue entries in the drivers we've been testing.

What do you mean by stumbed? irq-poll should be agnostic to the fact
that drivers can poll more than their given budget?

> Did your system load reduce with irq polling? In theory it should but I have
> seen increases with AHCI at least according to fio. IIRC Hannes saw decreases
> with his SAS HBA tests, as expected.

I didn't see any reduction. When I tested on a single cpu core (to
simplify for a single queue) the cpu was at 100% cpu but got less iops
(which makes sense, a single cpu-core is not enough to max out the nvme
device, at least not the core I'm using). Before irqpoll I got
~230 KIOPs on a single cpu-core and after irqpoll I got ~205 KIOPs
which is consistent with the ~10% iops decrease I've reported in the
original submission.
