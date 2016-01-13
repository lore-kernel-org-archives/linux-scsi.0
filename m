From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
 function
Date: Wed, 13 Jan 2016 01:22:49 -0800
Message-ID: <1452676969.27508.60.camel@haakon3.risingtidesystems.com>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com>
	 <1452458668-11034-2-git-send-email-nab@daterainc.com>
	 <20160112151119.GD2058@lst.de>
	 <1452672566.27508.44.camel@haakon3.risingtidesystems.com>
	 <20160113081700.GB12642@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160113081700.GB12642@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-01-13 at 09:17 +0100, Christoph Hellwig wrote:
> On Wed, Jan 13, 2016 at 12:09:26AM -0800, Nicholas A. Bellinger wrote:
> > > I'd much rather have the fabrics drivers call transport_alloc_session_tags
> > > directly from the callback than growing even more arguments here.
> > > 
> > 
> > What's the point..?
> > 
> > Only vhost-scsi currently needs to allocate extra resources for
> > se_session percpu-ida tag pre-allocation.
> 
> The point is that allocating "tags" (or better command structures) isn't
> fundamentally related to allocating a session, and in fact not even
> used by many drivers.

Huh..?  It's used by iscsi-target, ib_isert, tcm_qla2xxx, vhost-scsi and
tcm_fc.

That's the majority of the drivers people care about.

>  A flow where drivers that need these "tags"
> explicitly allocate them is a lot more obvious than forcing more
> arguments to a function that already has a lot and isn't related to
> these "tags" otherwise.

The goal is to get to the point where all fabric drivers use tag
pre-allocation, and not vice-versa.

That said, I think it makes sense to leave it as is instead of adding
new callbacks for iscsi-target, ib_isert, and tcm_fc to just handle
se_session tag pre-allocation.
