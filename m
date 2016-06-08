From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NVMe over Fabrics target implementation
Date: Tue, 07 Jun 2016 22:21:41 -0700
Message-ID: <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
	 <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
	 <20160607105550.GB17113@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160607105550.GB17113@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, 2016-06-07 at 12:55 +0200, Christoph Hellwig wrote:
> There is absolutely no point in dragging in an overcomplicated configfs 
> structure for a very simple protocol which also is very different from
> SCSI in it's nitty gritty details.

Please be more specific wrt the two individual points that have been
raised.

>  Keeping the nvme target self contains
> allows it to be both much simpler and much easier to understand, as well
> as much better testable - see the amount of test coverage we could easily
> add for example.

I disagree.

> 
> Or to put it the other way around - if there was any major synergy in
> reusing the SCSI target code that just shows we're missing functionality
> in the block layer or configfs.
> 

To reiterate the points again.

*) Extensible to multiple types of backend drivers.

nvme-target needs a way to absorb new backend drivers, that
does not effect existing configfs group layout or attributes.

Looking at the nvmet/configfs layout as-is, there are no multiple
backend types defined, nor a way to control backend feature bits
exposed to nvme namespaces at runtime.

What is being proposed is a way to share target-core backends via
existing configfs symlinks across SCSI and NVMe targets.

Which means:

   - All I/O state + memory submission is done at RCU protected
     se_device level via sbc_ops
   - percpu reference counting is done outside of target-core
   - Absorb all nvmet/io-cmd optimizations into target_core_iblock.c
   - Base starting point for features in SCSI + NVMe that span
     across multiple endpoints and instances (reservations + APTPL, 
     multipath, copy-offload across fabric types)

Using target-core backends means we get features like T10-PI and
sbc_ops->write_same for free that don't exist in nvmet, and can
utilize a common set of backend drivers for SCSI and NVMe via an
existing configfs ABI and python userspace community.

And to the second, and more important point for defining a configfs ABI
that works for both today's requirements, as well into the 2020s
without breaking user-space compatibility.

As-is, the initial design using top level nvmet configfs symlinks of
subsystem groups into individual port + host groups does not scale.

That is, it currently does:

  - Sequential list lookup under global rw_mutex of top-level nvmet_port
    and nvmet_host symlink ->allow_link() and ->drop_link() configfs
    callbacks.
  - nvmet_fabrics_ops->add_port() callback invoked under same global
    rw mutex.

This is very bad for several reasons.

As-is, this blocks all other configfs port + host operations from
occurring even during normal operation, which makes it quite useless for
any type of multi-tenant target environment where the individual target
endpoints *must* be able to operate independently.

Seriously, there is never a good reason why configfs group or item
callbacks should be performing list lookup under a global lock at
this level.

Why does it ever make sense for $SUBSYSTEM_NQN_0 with $PORT_DRIVER_FOO
to block operation of $SUBSYSTEM_NQN_1 with $PORT_DRIVER_BAR..?

A simple example where this design breaks down quickly is a NVMf
ops->add_port() call that requires a HW reset, or say reloading of
firmware that can take multiple seconds. (qla2xxx comes to mind).

There is a simple test to highlight this limitation.  Take any
nvme-target driver that is capable of multiple ports, and introduce
a sleep(5) into each ops->add_port() call.

Now create 256 different subsystem NQNs with 256 different ports
across four different user-space processes.

What happens to other subsystems, ports and host groups configfs
symlinks when this occurs..?

What happens to the other user-space processes..?
