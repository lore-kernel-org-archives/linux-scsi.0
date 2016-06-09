From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NVMe over Fabrics target implementation
Date: Wed, 08 Jun 2016 21:36:15 -0700
Message-ID: <1465446975.5365.123.camel@haakon3.risingtidesystems.com>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
	 <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
	 <20160607105550.GB17113@lst.de>
	 <1465363301.5365.81.camel@haakon3.risingtidesystems.com>
	 <20160608121932.GA31316@lst.de> <575819BB.7010209@lightbits.io>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <575819BB.7010209@lightbits.io>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@lightbits.io>
Cc: Christoph Hellwig <hch@lst.de>, axboe@kernel.dk, linux-block@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com, target-devel <target-devel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2016-06-08 at 16:12 +0300, Sagi Grimberg wrote:
> >> *) Extensible to multiple types of backend drivers.
> >>
> >> nvme-target needs a way to absorb new backend drivers, that
> >> does not effect existing configfs group layout or attributes.
> >>
> >> Looking at the nvmet/configfs layout as-is, there are no multiple
> >> backend types defined, nor a way to control backend feature bits
> >> exposed to nvme namespaces at runtime.
> 
> Hey Nic,
> 
> As for different type of backends, I still don't see a big justification
> for adding the LIO backends pscsi (as it doesn't make sense),
> ramdisk (we have brd), or file (losetup).
> 

The configfs ABI should not dictate a single backend use-case.

In the target-core ecosystem today, there are just as many
people using FILEIO atop local file-systems as there are
using IBLOCK and submit_bio().

As mentioned, target_core_iblock.c has absorbed the io-cmd.c
improvements so existing scsi target drivers can benefit
too.  Plus, having interested folks focusing on a single set of
backends for FILEIO + IBLOCK means both scsi and nvme
target drivers benefit from further improvements.

As we've already got both, a target backend configfs ABI
and user ecosystem using /sys/kernel/config/target/core/, it's
a straight forward way to share common code, while still allowing
scsi and nvme to function using their own independent fabric
configfs ABI layouts.

Along with having common code and existing configfs
ABI, we also get a proper starting point for target-core
features that span across endpoints, and are defined for
both scsi and nvme.  PR APTPL immediately comes to mind.

Namely, for the ability of one backend device to interact
between both scsi target luns and nvme target namespaces,
as well as different backends across scsi and nvme exports.

> What kind of feature bits would you want to expose at runtime?

As for feature bits, basically everything currently or
in the future to be reported by ID_NS.  There is T10-PI, and another
example is copy-offload support, once the NVMe spec gets that far..

The main point is that we should be able to add new feature bits to
common code in target-core backend configfs ABI, without having to
change the individual scsi or nvme configfs ABIs.

> 
> > And that's very much intentional.  We have a very well working block
> > layer which we're going to use, no need to reivent it.  The block
> > layer supports NVMe pass through just fine in case we'll need it,
> > as I spent the last year preparing it for that.
> >
> >> Why does it ever make sense for $SUBSYSTEM_NQN_0 with $PORT_DRIVER_FOO
> >> to block operation of $SUBSYSTEM_NQN_1 with $PORT_DRIVER_BAR..?
> >
> > Because it keeps the code simple.  If you had actually participated
> > on our development list you might have seen that until not too long
> > ago we have very fine grainded locks here.  In the end Armen convinced
> > me that it's easier to maintain if we don't bother with fine grained
> > locking outside the fast path, especially as it significantly simplifies
> > the discovery implementation.   If if it ever turns out to be an
> > issue we can change it easily as the implementation is well encapsulated.
> 
> We did change that, and Nic is raising a valid point in terms of having
> a global mutex around all the ports. If the requirement of nvme
> subsystems and ports configuration is that it should happen fast enough
> and scale to the numbers that Nic is referring to, we'll need to change
> that back.
> 
> Having said that, I'm not sure this is a real hard requirement for RDMA
> and FC in the mid-term, because from what I've seen, the workloads Nic
> is referring to are more typical for iscsi/tcp where connections are
> cheaper and you need more to saturate a high-speed interconnects, so
> we'll probably see this when we have nvme over tcp working.

Yes.

Further, my objections to the proposed nvmet configfs ABI are:

  - Doesn't support multiple backend types.
  - Doesn't provide a way to control backend feature bits separate from 
    fabric layout.
  - Doesn't provide a starting point between target features that span
    both scsi and nvme.
  - Doesn't allow for concurrent parallel configfs create + delete 
    operations of subsystem NQNs across ports and host acls.
  - Global synchronization of nvmet_fabric_ops->add_port()
