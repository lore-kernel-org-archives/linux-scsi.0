From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [RFC PATCH 0/4] dm mpath: vastly improve blk-mq IO performance
Date: Fri, 1 Apr 2016 09:22:19 -0400
Message-ID: <20160401132219.GA24355@redhat.com>
References: <1459454666-76428-1-git-send-email-snitzer@redhat.com>
 <6c6623e7f92e31daf1586d266fa03e1d@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:34837 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750751AbcDANWV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 1 Apr 2016 09:22:21 -0400
Content-Disposition: inline
In-Reply-To: <6c6623e7f92e31daf1586d266fa03e1d@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: dm-devel@redhat.com, linux-scsi@vger.kernel.org, sagig@dev.mellanox.co.il, linux-block@vger.kernel.org, jmoyer@redhat.com, j-nomura@ce.jp.nec.com

On Fri, Apr 01 2016 at  4:12am -0400,
Johannes Thumshirn <jthumshirn@suse.de> wrote:

> On 2016-03-31 22:04, Mike Snitzer wrote:
> >I developed these changes some weeks ago but have since focused on
> >regression and performance testing on larger NUMA systems.
> >
> >For regression testing I've been using mptest:
> >https://github.com/snitm/mptest
> >
> >For performance testing I've been using a null_blk device (with
> >various configuration permutations, e.g. pinning memory to a
> >particular NUMA node, and varied number of submit_queues).
> >
> >By eliminating multipath's heavy use of the m->lock spinlock in the
> >fast IO paths serious performance improvements are realized.
> 
> Hi Mike,
> 
> Are this the patches you pointed Hannes to?
> 
> If yes, please add my Tested-by: Johannes Thumshirn <jthumshirn@suse.de>

No they are not.

Hannes seems to have last pulled in my DM mpath changes that (ab)used RCU.
I ended up dropping those changes and this patchset is the replacement.

So please retest with this patchset (I know you guys have a large setup
that these changes are very relevant for).  If you could actually share
_how_ yo've tested that'd help me understand how these changes are
holding up.  So far all looks good for me...

Mike
