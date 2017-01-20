From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Fri, 20 Jan 2017 13:22:54 +0100
Message-ID: <20170120122254.GA5947@linux-x5ow.site>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <499af528-7810-f82d-1f11-cbf8f3a5b21c@grimberg.me>
 <f10b8508-22a2-2959-c369-2dd29f271d2c@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44488 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751941AbdATMn4 (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Fri, 20 Jan 2017 07:43:56 -0500
Content-Disposition: inline
In-Reply-To: <f10b8508-22a2-2959-c369-2dd29f271d2c@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>

On Tue, Jan 17, 2017 at 05:45:53PM +0200, Sagi Grimberg wrote:
> 
> >--
> >[1]
> >queue = b'nvme0q1'
> >     usecs               : count     distribution
> >         0 -> 1          : 7310 |****************************************|
> >         2 -> 3          : 11       |      |
> >         4 -> 7          : 10       |      |
> >         8 -> 15         : 20       |      |
> >        16 -> 31         : 0        |      |
> >        32 -> 63         : 0        |      |
> >        64 -> 127        : 1        |      |
> >
> >[2]
> >queue = b'nvme0q1'
> >     usecs               : count     distribution
> >         0 -> 1          : 7309 |****************************************|
> >         2 -> 3          : 14       |      |
> >         4 -> 7          : 7        |      |
> >         8 -> 15         : 17       |      |
> >
> 
> Rrr, email made the histograms look funky (tabs vs. spaces...)
> The count is what's important anyways...
> 
> Just adding that I used an Intel P3500 nvme device.
> 
> >We can see that most of the time our latency is pretty good (<1ns) but with
> >huge tail latencies (some 8-15 ns and even one in 32-63 ns).
> 
> Obviously is micro-seconds and not nano-seconds (I wish...)

So to share yesterday's (and today's) findings:

On AHCI I see only one completion polled as well.

This probably is because in contrast to networking (with NAPI) in the block
layer we do have a link between submission and completion whereas in networking
RX and TX are decoupled. So if we're sending out one request we get the
completion for it.

What we'd need is a link to know "we've sent 10 requests out, now poll for the
10 completions after the 1st IRQ". So basically what NVMe already did with
calling __nvme_process_cq() after submission. Maybe we should even disable
IRQs when submitting and re-enable after submitting so the
submission patch doesn't get preempted by a completion.

Does this make sense?

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
