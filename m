From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [LSF/MM TOPIC][LSF/MM ATTEND] NAPI polling for block drivers
Date: Thu, 12 Jan 2017 13:53:38 +0100
Message-ID: <20170112125338.GH3598@linux-x5ow.site>
References: <20170111134312.GH6286@linux-x5ow.site>
 <cc00cc1f-17d7-105e-ef2c-61791b7cc676@kernel.dk>
 <d60d4499-6ed8-0a69-edbf-db205a6dba6a@kernel.dk>
 <8b47ca34-d2ff-26dc-721e-2cb1e18f1efc@grimberg.me>
 <20170112100251.GB3598@linux-x5ow.site>
 <879a91ba-eff7-682d-12a9-5d83f26e7e09@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:38752 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750856AbdALMxp (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
        Thu, 12 Jan 2017 07:53:45 -0500
Content-Disposition: inline
In-Reply-To: <879a91ba-eff7-682d-12a9-5d83f26e7e09@grimberg.me>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: Jens Axboe <axboe@kernel.dk>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@infradead.org>, Keith Busch <keith.busch@intel.com>, linux-nvme@lists.infradead.org, Linux-scsi@vger.kernel.org

On Thu, Jan 12, 2017 at 01:44:05PM +0200, Sagi Grimberg wrote:
[...]
> Its pretty basic:
> --
> [global]
> group_reporting
> cpus_allowed=0
> cpus_allowed_policy=split
> rw=randrw
> bs=4k
> numjobs=4
> iodepth=32
> runtime=60
> time_based
> loops=1
> ioengine=libaio
> direct=1
> invalidate=1
> randrepeat=1
> norandommap
> exitall
> 
> [job]
> --
> 
> **Note: when I ran multiple threads on more cpus the performance
> degradation phenomenon disappeared, but I tested on a VM with
> qemu emulation backed by null_blk so I figured I had some other
> bottleneck somewhere (that's why I asked for some more testing).

That could be because of the vmexits as every MMIO access in the guest
triggers a vmexit and if you poll with a low budget you do more MMIOs hence
you have more vmexits.

Did you do testing only in qemu or with real H/W as well?

> 
> Note that I ran randrw because I was backed with null_blk, testing
> with a real nvme device, you should either run randread or write, and
> if you do a write, you can't run it multi-threaded (well you can, but
> you'll get unpredictable performance...).

Noted, thanks.

Byte,
	Johannes
-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
