Return-Path: <SRS0=cdy6=WX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FF78C3A5A3
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:36:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1D4D020828
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Aug 2019 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1566916571;
	bh=ULPFwYVf6Y7RcoZ/Gl43B+LwZQoiZk0sIrGPUnp+RMU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=cfOWiph3BjcBNk/nY9WWsO5lRuedf9mrK3DfJhhZANOxXeH0is1A1D009OE913BJg
	 Cr1dB1iMi+Plmiaz4rnjI7b65ub9YBpevE+rW5jRDIdTf9xXKIvHJ210rnR62F72wa
	 F5ta3k615czfLwG8t9u9W721+5gqmOdFp25+0pZA=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726134AbfH0OgK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Aug 2019 10:36:10 -0400
Received: from mga05.intel.com ([192.55.52.43]:11072 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726054AbfH0OgK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Aug 2019 10:36:10 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 27 Aug 2019 07:36:08 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,437,1559545200"; 
   d="scan'208";a="197319834"
Received: from unknown (HELO localhost.localdomain) ([10.232.112.69])
  by fmsmga001.fm.intel.com with ESMTP; 27 Aug 2019 07:36:08 -0700
Date:   Tue, 27 Aug 2019 08:34:21 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Johannes Thumshirn <jthumshirn@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, Long Li <longli@microsoft.com>,
        Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.com>,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/4] nvme: pci: pass IRQF_RESCURE_THREAD to
 request_threaded_irq
Message-ID: <20190827143421.GA23091@localhost.localdomain>
References: <20190827085344.30799-1-ming.lei@redhat.com>
 <20190827085344.30799-4-ming.lei@redhat.com>
 <8837ea73-dcf5-801f-f037-267936bd65bc@suse.de>
 <20190827090926.GA30871@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190827090926.GA30871@ming.t460p>
User-Agent: Mutt/1.9.1 (2017-09-22)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 27, 2019 at 05:09:27PM +0800, Ming Lei wrote:
> On Tue, Aug 27, 2019 at 11:06:20AM +0200, Johannes Thumshirn wrote:
> > On 27/08/2019 10:53, Ming Lei wrote:
> > [...]
> > > +		char *devname;
> > > +		const struct cpumask *mask;
> > > +		unsigned long irqflags = IRQF_SHARED;
> > > +		int vector = pci_irq_vector(pdev, nvmeq->cq_vector);
> > > +
> > > +		devname = kasprintf(GFP_KERNEL, "nvme%dq%d", nr, nvmeq->qid);
> > > +		if (!devname)
> > > +			return -ENOMEM;
> > > +
> > > +		mask = pci_irq_get_affinity(pdev, nvmeq->cq_vector);
> > > +		if (mask && cpumask_weight(mask) > 1)
> > > +			irqflags |= IRQF_RESCUE_THREAD;
> > > +
> > > +		return request_threaded_irq(vector, nvme_irq, NULL, irqflags,
> > > +				devname, nvmeq);
> > 
> > This will leak 'devname' which gets allocated by kasprintf() a few lines
> > above.
> 
> It won't, please see pci_free_irq() in which free_irq() returns the
> 'devname' passed in.

Only if request_threaded_irq() doesn't return an error.

I think you should probably just have pci_irq_get_affinity() take a flags
argument, or make a new function like __pci_irq_get_affinity() that
pci_irq_get_affinity() can call with a default flag.
