From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 0/2] nvme/loop: Add support for controllers-per-port model
Date: Thu, 09 Jun 2016 23:34:20 -0700
Message-ID: <1465540460.5365.194.camel@haakon3.risingtidesystems.com>
References: <1465356861-4321-1-git-send-email-nab@linux-iscsi.org>
	 <20160608121448.GA31119@lst.de>
	 <1465449233.5365.139.camel@haakon3.risingtidesystems.com>
	 <20160609133937.GA29580@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:37977 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596AbcFJGeY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jun 2016 02:34:24 -0400
In-Reply-To: <20160609133937.GA29580@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-nvme <linux-nvme@lists.infradead.org>, Jens Axboe <axboe@fb.com>, Keith Busch <keith.busch@intel.com>, Jay Freyensee <james.p.freyensee@intel.com>, Martin Petersen <martin.petersen@oracle.com>, Sagi Grimberg <sagi@grimberg.me>, Hannes Reinecke <hare@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, Dave B Minturn <dave.b.minturn@intel.com>

On Thu, 2016-06-09 at 15:39 +0200, Christoph Hellwig wrote:
> On Wed, Jun 08, 2016 at 10:13:53PM -0700, Nicholas A. Bellinger wrote:
> > I still don't see why a loopback controller on a port of an individual
> > subsystem NQN can't be created + deleted directly from configfs, and
> > operate independently of other loopback controllers on a port of a
> > different subsystem NQNs.
> 
> I think you are misunderstanding the NVMe entities - there is no port
> of a subsystem.  There are port, and there are subsystems and there
> is an N to M relation between them, not an N to one relation.
> 

Yes, the mapping of subsystem NQNs and ports works identically to how
iscsi IQNs and network portals work.

That is, network portals can be setup across multiple IQNs, or setup
specifically to one IQN.

> Multiple controllers may and usually will use the same port to access
> one or more subsystems, but multiple controllers may also use different
> ports to use the same subsystem.
> 

Yes.  Also similar to MC/S in a single IQN across multiple network
portals setup.  ;)

> For full NVMe functionality we thus need to be able to create all
> these objects indepdently.

Yes.

> While loopback ports are extremtly cheap
> I see no reason to introduce a shortcut to break this model for our
> debug local implementation - the whole point of the loopback driver
> is to give you the full NVMe over Fabrics experience without needing
> an (possibly expensive) transport.
> 

I think making this extra step for loopback in pointless, and just adds
unnecessary list lookups, and is something that configfs is better
suited to handle directly.

But loopback is a special case, both for drivers/target/loopback/ and
driver/nvme/target/loop.c code.

So why not just let configfs do it..?

However, your point is taken about using the global hostnqn for loopback
controllers in this patch.  Following what we do for SCSI loopback, I
think it makes the sense to have each loopback subsystem port setup it's
own hostnqn instead.

Updating the patch to do this.

> > > Something like the patch below is the right way, it just needs a bit more
> > > fine tuning and proper test cases:
> > 
> > I don't see how adding a internal mutex for loopback ports, and doing
> > internal sequential list lookup holding the global nvmet_config_sem
> > whilst doing nvmet_fabric_ops->add_port() helps to scale at all..
> 
> Scalability of the controller creation is not the prime goal for the
> nvme-loop driver.  It's supposed to be the simples possible implementation
> of a NVMe over Fabrics transport.
> 

Btw, I consider adding a global list for loopback to be 'less' simple.

> > AFAICT for loopback, neither of these is necessary.  Why can't a
> > loopback controller on a port for a individual subsystem NQN be created
> > + deleted directly from configfs,
> 
> We could trivially do this, but I think it's counter productive.  NVMe
> over Fabrics does not automatically create one or multiple controllers,
> and nvme-loop is just another transport that follows the higher level
> spec.
> 

I disagree.  The more interesting question is if to enforce a limit to
the amount of loopback ports that be allocated with this patch
per /sys/kernel/config/nvmet/subsystems/$NQN.FOO/.

That is, each echo 1 > ../$NQN_FOO/$ANY_LOOPBACK/enable will create it's
own controller, regardless if another loopback controller already exists
on the subsystem NQN.

Leaving that as-is for -v2.

