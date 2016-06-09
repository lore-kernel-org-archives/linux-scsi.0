From: Christoph Hellwig <hch@lst.de>
Subject: Re: [RFC 0/2] nvme/loop: Add support for controllers-per-port model
Date: Thu, 9 Jun 2016 15:39:37 +0200
Message-ID: <20160609133937.GA29580@lst.de>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org> <20160608121448.GA31119@lst.de> <1465449233.5365.139.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1465449233.5365.139.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jun 08, 2016 at 10:13:53PM -0700, Nicholas A. Bellinger wrote:
> I still don't see why a loopback controller on a port of an individual
> subsystem NQN can't be created + deleted directly from configfs, and
> operate independently of other loopback controllers on a port of a
> different subsystem NQNs.

I think you are misunderstanding the NVMe entities - there is no port
of a subsystem.  There are port, and there are subsystems and there
is an N to M relation between them, not an N to one relation.

Multiple controllers may and usually will use the same port to access
one or more subsystems, but multiple controllers may also use different
ports to use the same subsystem.

For full NVMe functionality we thus need to be able to create all
these objects indepdently.   While loopback ports are extremtly cheap
I see no reason to introduce a shortcut to break this model for our
debug local implementation - the whole point of the loopback driver
is to give you the full NVMe over Fabrics experience without needing
an (possibly expensive) transport.

> > Something like the patch below is the right way, it just needs a bit more
> > fine tuning and proper test cases:
> 
> I don't see how adding a internal mutex for loopback ports, and doing
> internal sequential list lookup holding the global nvmet_config_sem
> whilst doing nvmet_fabric_ops->add_port() helps to scale at all..

Scalability of the controller creation is not the prime goal for the
nvme-loop driver.  It's supposed to be the simples possible implementation
of a NVMe over Fabrics transport.

> AFAICT for loopback, neither of these is necessary.  Why can't a
> loopback controller on a port for a individual subsystem NQN be created
> + deleted directly from configfs,

We could trivially do this, but I think it's counter productive.  NVMe
over Fabrics does not automatically create one or multiple controllers,
and nvme-loop is just another transport that follows the higher level
spec.

> independent of other subsystem NQN's
> loopback controller ports..?

The only limitation at the moment is that there is only one port.  I've
shown you a fairly trivial patch to lift that limitation.  Subsystem
can be created and deleted independently from each other, as can
controllers, and as can ports for transport where more than one can
exists.
