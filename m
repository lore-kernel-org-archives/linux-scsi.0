From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: NVMe over Fabrics target implementation
Date: Mon, 06 Jun 2016 23:23:52 -0700
Message-ID: <1465280632.5365.58.camel@haakon3.risingtidesystems.com>
References: <1465248177-17970-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465248177-17970-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: axboe@kernel.dk, keith.busch@intel.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi HCH & Co,

On Mon, 2016-06-06 at 23:22 +0200, Christoph Hellwig wrote:
> This patch set adds a generic NVMe over Fabrics target. The
> implementation conforms to the NVMe 1.2b specification (which
> includes Fabrics) and provides the NVMe over Fabrics access
> to Linux block devices.
>=20

Thanks for all of the development work by the fabric_linux_driver team
(HCH, Sagi, Ming, James F., James S., and Dave M.) over the last year.=20

Very excited to see this code get a public release now that NVMf
specification is out.  Now that it's in the wild, it's a good
opportunity to discuss some of the more interesting implementation
details, beyond the new NVMf wire-protocol itself.

(Adding target-devel + linux-scsi CC')

> The target implementation consists of several elements:
>=20
> - NVMe target core: defines and manages the NVMe entities (subsystems=
,
>   controllers, namespaces, ...) and their allocation, responsible
>   for initial commands processing and correct orchestration of
>   the stack setup and tear down.
>=20
> - NVMe admin command implementation: responsible for parsing and
>   servicing admin commands such as controller identify, set features,
>   keep-alive, log page, ...).
>=20
> - NVMe I/O command implementation: responsible for performing the act=
ual
>   I/O (Read, Write, Flush, Deallocate (aka Discard).  It is a very th=
in
>   layer on top of the block layer and implements no logic of it's own=
=2E
>   To support exporting file systems please use the loopback block dri=
ver
>   in direct I/O mode, which gives very good performance.
>=20
> - NVMe over Fabrics support: responsible for servicing Fabrics comman=
ds
>   (connect, property get/set).
>=20
> - NVMe over Fabrics discovery service: responsible to serve the Disco=
very
>   log page through a special cut down Discovery controller.
>=20
> The target is configured using configfs, and configurable entities ar=
e:
>=20
>  - NVMe subsystems and namespaces
>  - NVMe over Fabrics ports and referrals
>  - Host ACLs for primitive access control - NVMe over Fabrics access
>    control is still work in progress at the specification level and
>    will be implemented once that work has finished.
>=20
> To configure the target use the nvmetcli tool from
> http://git.infradead.org/users/hch/nvmetcli.git, which includes detai=
led
> setup documentation.
>=20
> In addition to the Fabrics target implementation we provide a loopbac=
k
> driver which also conforms the NVMe over Fabrics specification and al=
lows
> evaluation of the target stack with local access without requiring a =
real
> fabric.
>=20

So as-is, I have two main objections that been discussed off-list for
some time, that won't be a big surprise to anyone following
fabrics_linux_driver list.  ;P

=46irst topic, I think nvme-target name-spaces should be utilizing
existing configfs logic, and sharing /sys/kernel/config/target/core/
backend driver symlinks as individual nvme-target subsystem namespaces.

That is, we've already got a configfs ABI in place for target mode
back-ends that today is able to operate independently from SCSI
architecture model dependencies.

To that end, the prerequisite series to allow target-core backends to
operate independent of se_cmd, and allow se_device backends to be
configfs symlinked directly into /sys/kernel/config/nvmet/, outside
of /sys/kernel/config/target/$FABRIC/ has been posted earlier here:

http://marc.info/?l=3Dlinux-scsi&m=3D146527281416606&w=3D2

Note the -v2 series has absorbed the nvmet/io-cmd execute_rw()
improvements from Sagi + Ming (inline bio/bvec and blk_poll) into
target_core_iblock.c driver code.

Second topic, and more important from a kernel ABI perspective are the
current scale limitations around the first pass of nvmet configfs.c
layout code in /sys/kernel/config/nvmet/.

Namely, the design of having three top level configfs groups in
/sys/kernel/config/nvmet/[subsystems,ports,hosts] that are configfs
symlinked between each other, with a single rw_mutex (nvmet_config_sem)
used for global list lookup and enforcing a globally synchronized
nvmet_fabrics_ops->add_port() creation across all subsystem NQN ports.

=46rom the shared experience in target_core_fabric_configfs.c over the
last 8 years, perhaps the greatest strength of configfs has been it's
ability to allow config_item_type parent/child relationships to exist
and operate independently of one another.

Specifically in the context of storage tenants, this means creation +
deletion of one backend + target fabric endpoint tenant, should not
block creation + deletion of another backend + target fabric endpoint
tenant.

As-is, a nvmet configfs layout holding a global mutex across
subsystem/port/host creation + deletion, and doing internal list lookup
within configfs ->allow_link + ->drop_link callbacks ends up being
severely limiting when scaling up the total number of nvmet subsystem
NQNs and ports.

Specifically, modern deployments of /sys/kernel/config/target/iscsi/
expect backends + fabric endpoints to be configured in parallel at
< 100ms from user-space, in order to actively migrate and fail-over
100s of storage instances (eg: iscsi IQNs -> NVMf NQN) across physical
cluster nodes and L3 networks.

So in order to reach this level of scale with nvmet/configfs, the layou=
t
I think is necessary to match iscsi-target in a multi-tenant environmen=
t
will, in it's most basic form look like:

/sys/kernel/config/nvmet/subsystems/
=E2=94=94=E2=94=80=E2=94=80 nqn.2003-01.org.linux-iscsi.NVMf.skylake-ep
    =E2=94=9C=E2=94=80=E2=94=80 hosts
    =E2=94=9C=E2=94=80=E2=94=80 namespaces
    =E2=94=82   =E2=94=94=E2=94=80=E2=94=80 ns_1
    =E2=94=82       =E2=94=94=E2=94=80=E2=94=80 1 -> ../../../../../../=
target/core/rd_mcp_1/ramdisk0
    =E2=94=94=E2=94=80=E2=94=80 ports
        =E2=94=9C=E2=94=80=E2=94=80 pcie:$SUPER_TURBO_FABRIC_EAST
        =E2=94=9C=E2=94=80=E2=94=80 pcie:$SUPER_TURBO_FABRIC_WEST
        =E2=94=9C=E2=94=80=E2=94=80 rdma:[$IPV6_ADDR]:$PORT
        =E2=94=9C=E2=94=80=E2=94=80 rdma:10.10.1.75:$PORT
        =E2=94=94=E2=94=80=E2=94=80 loop

That is, both NQN ports groups and host ACL groups exist below the
nvmet_subsys->group, and NQN namespaces are configfs symlinked directly
from /sys/kernel/config/target/core/ backends as mentioned in point #1.

To that end, I'll be posting a nvmet series shortly that implements a
multi-tenant configfs layout WIP using nvme/loop, using existing
target-core backends as configfs symlinked nvme namespaces.

Comments..?
