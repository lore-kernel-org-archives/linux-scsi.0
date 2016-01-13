From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 11:21:03 -0500
Message-ID: <20160113162102.GA2933@redhat.com>
References: <56961493.5010901@suse.de>
 <56962BDB.4080509@dev.mellanox.co.il>
 <20160113154243.GA2563@redhat.com>
 <569675F5.8070501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:39890 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752785AbcAMQVE (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 11:21:04 -0500
Content-Disposition: inline
In-Reply-To: <569675F5.8070501@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Wed, Jan 13 2016 at 11:06am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:

> 
> >This sounds like you aren't actually using blk-mq for the top-level DM
> >multipath queue.
> 
> Hmm. I turned on /sys/module/dm_mod/parameters/use_blk_mq and indeed
> saw a significant performance improvement. Anything else I was missing?

You can enable CONFIG_DM_MQ_DEFAULT so you don't need to manually set
use_blk_mq.

> >And your findings contradicts what I heard from Keith
> >Busch when I developed request-based DM's blk-mq support, from commit
> >bfebd1cdb497 ("dm: add full blk-mq support to request-based DM"):
> >
> >      "Just providing a performance update. All my fio tests are getting
> >       roughly equal performance whether accessed through the raw block
> >       device or the multipath device mapper (~470k IOPS). I could only push
> >       ~20% of the raw iops through dm before this conversion, so this latest
> >       tree is looking really solid from a performance standpoint."
> 
> I too see ~500K IOPs, but my nvme can push ~1500K IOPs...
> Its a simple nvme loopback [1] backed by null_blk.
> 
> [1]:
> http://lists.infradead.org/pipermail/linux-nvme/2015-November/003001.html
> http://git.infradead.org/users/hch/block.git/shortlog/refs/heads/nvme-loop.2

OK, so you're only getting 1/3 of the throughput.  Time for us to hunt
down the bottleneck (before real devices hit it).
