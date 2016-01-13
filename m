From: Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH-for-4.6 1/6] target: Add target_alloc_session() helper
	function
Date: Wed, 13 Jan 2016 09:17:00 +0100
Message-ID: <20160113081700.GB12642@lst.de>
References: <1452458668-11034-1-git-send-email-nab@daterainc.com> <1452458668-11034-2-git-send-email-nab@daterainc.com> <20160112151119.GD2058@lst.de> <1452672566.27508.44.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1452672566.27508.44.camel@haakon3.risingtidesystems.com>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 13, 2016 at 12:09:26AM -0800, Nicholas A. Bellinger wrote:
> > I'd much rather have the fabrics drivers call transport_alloc_session_tags
> > directly from the callback than growing even more arguments here.
> > 
> 
> What's the point..?
> 
> Only vhost-scsi currently needs to allocate extra resources for
> se_session percpu-ida tag pre-allocation.

The point is that allocating "tags" (or better command structures) isn't
fundamentally related to allocating a session, and in fact not even
used by many drivers.  A flow where drivers that need these "tags"
explicitly allocate them is a lot more obvious than forcing more
arguments to a function that already has a lot and isn't related to
these "tags" otherwise.
