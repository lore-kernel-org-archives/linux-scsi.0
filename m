From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NVMe over Fabrics target implementation
Date: Wed, 08 Jun 2016 20:32:46 -0700
Message-ID: <1465443166.5365.110.camel@haakon3.risingtidesystems.com>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
	 <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
	 <20160607105550.GB17113@lst.de>
	 <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
	 <20160608121932.GA31316@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160608121932.GA31316@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-06-08 at 14:19 +0200, Christoph Hellwig wrote:
> On Tue, Jun 07, 2016 at 10:21:41PM -0700, Nicholas A. Bellinger wrote:
> > *) Extensible to multiple types of backend drivers.
> > 
> > nvme-target needs a way to absorb new backend drivers, that
> > does not effect existing configfs group layout or attributes.
> > 
> > Looking at the nvmet/configfs layout as-is, there are no multiple
> > backend types defined, nor a way to control backend feature bits
> > exposed to nvme namespaces at runtime.
> 
> And that's very much intentional.  We have a very well working block
> layer which we're going to use, no need to reivent it.  The block
> layer supports NVMe pass through just fine in case we'll need it,
> as I spent the last year preparing it for that.
> 
> > Why does it ever make sense for $SUBSYSTEM_NQN_0 with $PORT_DRIVER_FOO
> > to block operation of $SUBSYSTEM_NQN_1 with $PORT_DRIVER_BAR..?
> 
> Because it keeps the code simple.  If you had actually participated
> on our development list you might have seen that until not too long
> ago we have very fine grainded locks here.  In the end Armen convinced
> me that it's easier to maintain if we don't bother with fine grained
> locking outside the fast path, especially as it significantly simplifies
> the discovery implementation.   If if it ever turns out to be an
> issue we can change it easily as the implementation is well encapsulated.

Well, it's rather obvious from the design limitations highlighted
earlier that using a configfs model for nvmet was an after-thought.

You'll recall a prototype of nvmet using target_core_fabric_configfs.c,
which allowed nvmet to work out-of-the-box with LIO userspace, that fit
directly into target_core_pr.c, and other existing target-core features
that scsi and nvme share.

Since our discussions at LSF, I've taken the point that it makes sense
for nvmet to have it's own configfs layout using common configfs
backends, which is reflected in nvmet/configfs-ng RFC from monday.

However, I completely disagree with you that scsi (specifically iscsi)
and nvme models are somehow incompatible from a target subsystem
configfs perspective.

They are not.

Point being, if you took the exact same three top level configfs groups
in the nvmet implementation  using subsystem configfs symlinks into
ports and hosts, and did the same for iscsi by renaming them to:

    /sys/kernel/config/iscsit/

    subsystems -> iqns
    ports -> network portals
    hosts -> acls

You would have the exact same type of scale limitations with iscsi that
have already highlighted.  There is nothing iscsi or nvme specific about
these limitations.

The point is that it's not a question of if this configfs model is
required for a nvme target design, it's a bad model for any configfs
consumer design to follow.

To repeat, any time there are global locks and sequential lookups
across multiple top level configfs groups, you're doing configfs
wrong.

The whole point of configfs is to allow vfs to reference count data
structures using parent/child relationships, and let configfs give you
the reference counting for free.

And getting that reference counting for free in configfs is what allows
existing target-core backends + endpoints to scale creation, operation
and deletion independent from each other.

Any type of medium or larger service provider and hosting environment
requires the ability of it's target mode storage control plane to
function independent of individual tenants.

The limitations as-is of the nvmet/configfs design makes it rather
useless for these environments, and any type of upstream commitment to a
target mode configfs based ABI needs to be able to, at least, scale to
what we've already got in target_core_fabric_configfs.

Otherwise, it will eventually be thrown out for something that both fits
the needs of today's requirements, and can grow into the future while
never breaking user-space ABI compatibility.

We got the /sys/kernel/config/target/$FABRIC/ layout right the first
time back in 2008, have *never* had to break ABI compat, and we are
still able scale to the requirements of today.

I'd like to hope we'd be able to achieve the same goals for nvmet in
2024.
