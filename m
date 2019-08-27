Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D8DCC3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 09:09:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5EDF4217F5
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 09:09:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729254AbfH0JJm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 05:09:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38122 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725805AbfH0JJl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 05:09:41 -0400
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 9A0BB3023080;
        Tue, 27 Aug 2019 09:09:41 +0000 (UTC)
Received: from ming.t460p (ovpn-8-27.pek2.redhat.com [10.72.8.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 564985D717;
        Tue, 27 Aug 2019 09:09:31 +0000 (UTC)
Date:   Tue, 27 Aug 2019 17:09:27 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Johannes Thumshirn <jthumshirn@suse.de>
Cc:     Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Long Li <longli@microsoft.com>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] nvme: pci: pass IRQF_RESCURE_THREAD to
 request_threaded_irq
Message-ID: <20190827090926.GA30871@ming.t460p>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-4-ming.lei@redhat.com>
 <8837ea73-dcf5-801f-f037-267936bd65bc@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8837ea73-dcf5-801f-f037-267936bd65bc@suse.de>
User-Agent: Mutt/1.11.3 (2019-02-01)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.45]); Tue, 27 Aug 2019 09:09:41 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 11:06:20AM +0200, Johannes Thumshirn wrote:
> On 27/08/2019 10:53, Ming Lei wrote:
> [...]
> > +		char *devname;
> > +		const struct cpumask *mask;
> > +		unsigned long irqflags = IRQF_SHARED;
> > +		int vector = pci_irq_vector(pdev, nvmeq->cq_vector);
> > +
> > +		devname = kasprintf(GFP_KERNEL, "nvme%dq%d", nr, nvmeq->qid);
> > +		if (!devname)
> > +			return -ENOMEM;
> > +
> > +		mask = pci_irq_get_affinity(pdev, nvmeq->cq_vector);
> > +		if (mask && cpumask_weight(mask) > 1)
> > +			irqflags |= IRQF_RESCUE_THREAD;
> > +
> > +		return request_threaded_irq(vector, nvme_irq, NULL, irqflags,
> > +				devname, nvmeq);
> 
> This will leak 'devname' which gets allocated by kasprintf() a few lines
> above.

It won't, please see pci_free_irq() in which free_irq() returns the
'devname' passed in.

Thanks,
Ming
