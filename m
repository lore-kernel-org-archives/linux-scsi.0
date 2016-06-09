From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 0/2] nvme/loop: Add support for controllers-per-port model
Date: Wed, 08 Jun 2016 22:13:53 -0700
Message-ID: <1465449233.5365.139.camel@haakon3.risingtidesystems.com>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
	 <20160608121448.GA31119@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160608121448.GA31119@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-06-08 at 14:14 +0200, Christoph Hellwig wrote:
> Hi Nic,
> 
> multiple ports have been on the todo list ever since we put that short
> cut in place, but your patches aren't really how this should work.
> 
> The host NQN is not available for the actual drivers - we need to be able
> to virtualize it for containers for example, that's why we need to pass
> it by pointer depending on the arguments.  Also there is no need to
> add another sysfs interface - just like for real drivers we can simply
> create the ports in configfs and assign an address to it, we just need
> to stop ignoring it.
> 

Not sure what you mean, but my patch does not propose 'to add another
sysfs interface'.

It simply follows what drivers/target/loopback/ already does for scsi,
and allocates a controller from nvmet/configfs-ng at subsystem NQN
port enable time.

I still don't see why a loopback controller on a port of an individual
subsystem NQN can't be created + deleted directly from configfs, and
operate independently of other loopback controllers on a port of a
different subsystem NQNs.

> Something like the patch below is the right way, it just needs a bit more
> fine tuning and proper test cases:

I don't see how adding a internal mutex for loopback ports, and doing
internal sequential list lookup holding the global nvmet_config_sem
whilst doing nvmet_fabric_ops->add_port() helps to scale at all..

AFAICT for loopback, neither of these is necessary.  Why can't a
loopback controller on a port for a individual subsystem NQN be created
+ deleted directly from configfs, independent of other subsystem NQN's
loopback controller ports..?

Now for rdma, just like with iscsi-target + iser with network portals,
we do need to keep an internal list of ports, given that ports can be
shared across different target endpoints.

That's the part that I'm working on next for nvmet/configfs-ng.
