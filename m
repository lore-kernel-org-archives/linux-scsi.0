From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [LSF/MM ATTEND][LSF/MM TOPIC] Multipath redesign
Date: Wed, 13 Jan 2016 10:42:43 -0500
Message-ID: <20160113154243.GA2563@redhat.com>
References: <56961493.5010901@suse.de>
 <56962BDB.4080509@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:51731 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752014AbcAMPmp (ORCPT <rfc822;Linux-scsi@vger.kernel.org>);
	Wed, 13 Jan 2016 10:42:45 -0500
Content-Disposition: inline
In-Reply-To: <56962BDB.4080509@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: Hannes Reinecke <hare@suse.de>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, device-mapper development <dm-devel@redhat.com>, "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>, "linux-scsi@vger.kernel.org" <Linux-scsi@vger.kernel.org>

On Wed, Jan 13 2016 at  5:50am -0500,
Sagi Grimberg <sagig@dev.mellanox.co.il> wrote:
 
> Another (adjacent) topic is multipath performance with blk-mq.
> 
> As I said, I've been looking at nvme multipathing support and
> initial measurements show huge contention on the multipath lock
> which really defeats the entire point of blk-mq...
> 
> I have yet to report this as my work is still in progress. I'm not sure
> if it's a topic on it's own but I'd love to talk about that as well...

This sounds like you aren't actually using blk-mq for the top-level DM
multipath queue.  And your findings contradicts what I heard from Keith
Busch when I developed request-based DM's blk-mq support, from commit 
bfebd1cdb497 ("dm: add full blk-mq support to request-based DM"):

     "Just providing a performance update. All my fio tests are getting
      roughly equal performance whether accessed through the raw block
      device or the multipath device mapper (~470k IOPS). I could only push
      ~20% of the raw iops through dm before this conversion, so this latest
      tree is looking really solid from a performance standpoint."

> >But in the end we should be able to do strip down the current (rather
> >complex) multipath-tools to just handle topology changes; everything
> >else will be done internally.
> 
> I'd love to see that happening.

Honestly, this needs to be a hardened plan that is hashed out _before_
LSF and then findings presented.  It is a complete waste of time to
debate nuance with Hannes in a one hour session.

Until I implemented the above DM core changes hch and Hannes were very
enthusiastic to throw away the existing DM multipath and multipath-tools
code (the old .request_fn queue lock bottleneck being the straw that
broke the camel's back).  Seems Hannes' enthusiasm hasn't tempered but
his hand-waving is still in full form.

Details matter.  I have no doubts aspects of what we have could be
improved but I really fail to see how moving multipathing to blk-mq is a
constructive way forward.
