From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: initial LIO iSER performance numbers [was: GIT PULL] target updates
 for v3.10-rc1)
Date: Thu, 2 May 2013 16:58:44 +0300
Message-ID: <51827114.9010907@mellanox.com>
References: <1367290766.16334.77.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367290766.16334.77.camel-XoQW25Eq2zviZyQQd+hFbcojREIfoBdhmpATvIKMPHk@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Asias He <asias-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Michael S. Tsirkin" <mst-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org, Shlomi Sasson <shlomis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On 30/04/2013 05:59, Nicholas A. Bellinger wrote:
> Hello Linus!
>
> Here are the target pending changes for the v3.10-rc1 merge window.
>
> Please go ahead and pull from:
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.g=
it for-next-merge
>
> The highlights this round include:
>
>   - Add fileio support for WRITE_SAME w/ UNMAP=3D1 discard (asias)
>   - Add fileio support for UNMAP discard (asias)
>   - Add tcm_vhost hotplug support to work with upstream QEMU
>     vhost-scsi-pci code (asias + mst)
>   - Check for aborted sequence in tcm_fc response path (mdr)
>   - Add initial iscsit_transport support into iscsi-target code (nab)
>   - Refactor iscsi-target RX PDU logic + export request PDU handling =
 (nab)
>   - Refactor iscsi-target TX queue logic + export response PDU creati=
on (nab)
>   - Add new iSCSI Extentions for RDMA (ISER) target driver (Or + nab)
>
> The biggest changes revolve around iscsi-target refactoring in order =
to
> support the iser-target driver.  This includes the conversion of the
> iscsi-target data-path to use modern se_cmd->cmd_kref counting, and
> allowing transport independent aspects of RX/TX PDU request/response
> handling be shared across existing traditional iscsi-target code, and
> the new iser-target code.

Hi Nic, everyone,

So LIO iser target code is now merged into Linus tree, and will be in=20
kernel 3.10, exciting!

Here's some data on raw performance numbers we were able to get with th=
e=20
LIO iser code.

=46or single initiator and single lun, block sizes varying over the ran=
ge=20
1KB,2KB... 128KB
doing random read:

1KB 227,870K
2KB 458,099K
4KB 909,761K
8KB 1,679,922K
16KB 3,233,753K
32KB 4,905,139K
64KB 5,294,873K
128KB 5,565,235K

When enlarging the number of luns and still with single initiator, for=20
1KB randomreads we get:

1 LUN  =3D 230k IOPS
2 LUNs =3D 420k IOPS
4 LUNs =3D 740k IOPS

When enlarging the number of initiators, and each having four lunswe ge=
t=20
for 1KB random reads:

1 initiator  x 4 LUNs =3D 740k  IOPS
2 initiators x 4 LUNs =3D 1480k IOPS
3 initiators x 4 LUNs =3D 1570k IOPS

So all in all, things scale pretty nicely, and we observe a some bottle=
neck
in the IOPS rate around 1.6 Million IOPS, so there's where to improve..=
=2E

Here's the fio command line used by the initiators

$ fio --cpumask=3D0xfc --rw=3Drandread --bs=3D1k --numjobs=3D2 --iodept=
h=3D128=20
--runtime=3D62 --time_based --size=3D1073741824k --loops=3D1 --ioengine=
=3Dlibaio=20
--direct=3D1 --invalidate=3D1 --fsync_on_close=3D1 --randrepeat=3D1=20
--norandommap --group_reporting --exitall --name=20
dev-sdb-randread-1k-2thr-libaio-128iodepth-62sec --filename=3D/dev/sdb

And some details on the setup:

The nodes are HP ProLiant DL380p Gen8 with the following CPU: Intel(R)=20
Xeon(R) CPU E5-2650 0 @ 2.00GHz
two NUMA nodes with eight cores each, 32GB RAM, PCI express gen3 8x, th=
e=20
HCA being Mellanox ConnectX3 with firmware 2.11.500

The target node was running upstream kernel and the initiators RHEL 6.3=
=20
kernel, all X86_64

We used RAMDISK_MCP backend which was patched to act as NULL device, so=
=20
we can test the raw iSER wire performance.

Or.

>
> Thanks to Or Gerlitz + Mellanox for supporting the iser-target develo=
pment effort!
>
> Thank you,
>
> --nab
>
> Andy Grover (2):
>    target/iscsi: Remove chap_set_random()
>    target/iscsi: Use ISCSI_LOGIN_CURRENT/NEXT_STAGE macros
>
> Asias He (10):
>    target/file: Add WRITE_SAME w/ UNMAP=3D1 emulation support
>    target/file: Add UNMAP emulation support
>    target/file: Add fd_do_unmap() helper
>    target/iblock: Add iblock_do_unmap() helper
>    target: Add sbc_execute_unmap() helper
>    target/file: Set is_nonrot attribute
>    tcm_vhost: Refactor the lock nesting rule
>    tcm_vhost: Add hotplug/hotunplug support
>    tcm_vhost: Add ioctl to get and set events missed flag
>    tcm_vhost: Enable VIRTIO_SCSI_F_HOTPLUG
>
> J=C3=B6rn Engel (2):
>    qla2xxx: Remove unused function
>    target: Change default sense key of NOT_READY
>
> Mark Rustad (1):
>    tcm_fc: Check for aborted sequence
>
> Nicholas Bellinger (9):
>    target: Add export of target_get_sess_cmd symbol
>    iscsi-target: Add iscsit_transport API template
>    iscsi-target: Initial traditional TCP conversion to iscsit_transpo=
rt
>    iscsi-target: Add iser-target parameter keys + setup during login
>    iscsi-target: Add per transport iscsi_cmd alloc/free
>    iscsi-target: Refactor RX PDU logic + export request PDU handling
>    iscsi-target: Refactor TX queue logic + export response PDU creati=
on
>    iscsi-target: Add iser network portal attribute
>    iser-target: Add iSCSI Extensions for RDMA (iSER) target driver
>
> Wei Yongjun (1):
>    tcm_fc: using kfree_rcu() to simplify the code
>
>   drivers/infiniband/Kconfig                     |    1 +
>   drivers/infiniband/Makefile                    |    1 +
>   drivers/infiniband/ulp/isert/Kconfig           |    5 +
>   drivers/infiniband/ulp/isert/Makefile          |    2 +
>   drivers/infiniband/ulp/isert/ib_isert.c        | 2281 +++++++++++++=
+++++++++++
>   drivers/infiniband/ulp/isert/ib_isert.h        |  138 ++
>   drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
>   drivers/scsi/qla2xxx/qla_target.c              |   19 -
>   drivers/scsi/qla2xxx/qla_target.h              |    1 -
>   drivers/target/iscsi/Makefile                  |    3 +-
>   drivers/target/iscsi/iscsi_target.c            | 1184 ++++++++-----
>   drivers/target/iscsi/iscsi_target.h            |    3 +-
>   drivers/target/iscsi/iscsi_target_auth.c       |   28 +-
>   drivers/target/iscsi/iscsi_target_configfs.c   |   98 +-
>   drivers/target/iscsi/iscsi_target_core.h       |   26 +-
>   drivers/target/iscsi/iscsi_target_device.c     |    7 +-
>   drivers/target/iscsi/iscsi_target_erl1.c       |   13 +-
>   drivers/target/iscsi/iscsi_target_login.c      |  472 ++++--
>   drivers/target/iscsi/iscsi_target_login.h      |    6 +
>   drivers/target/iscsi/iscsi_target_nego.c       |  194 +--
>   drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
>   drivers/target/iscsi/iscsi_target_parameters.c |   87 +-
>   drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
>   drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
>   drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
>   drivers/target/iscsi/iscsi_target_transport.c  |   55 +
>   drivers/target/iscsi/iscsi_target_util.c       |   53 +-
>   drivers/target/iscsi/iscsi_target_util.h       |    1 +
>   drivers/target/target_core_file.c              |  122 ++-
>   drivers/target/target_core_iblock.c            |  108 +-
>   drivers/target/target_core_sbc.c               |   85 +
>   drivers/target/target_core_transport.c         |   13 +-
>   drivers/target/tcm_fc/tfc_io.c                 |    9 +-
>   drivers/target/tcm_fc/tfc_sess.c               |    9 +-
>   drivers/vhost/tcm_vhost.c                      |  262 +++-
>   drivers/vhost/tcm_vhost.h                      |   13 +
>   include/target/iscsi/iscsi_transport.h         |   83 +
>   include/target/target_core_backend.h           |    4 +
>   include/target/target_core_fabric.h            |    2 +-
>   39 files changed, 4470 insertions(+), 1002 deletions(-)
>   create mode 100644 drivers/infiniband/ulp/isert/Kconfig
>   create mode 100644 drivers/infiniband/ulp/isert/Makefile
>   create mode 100644 drivers/infiniband/ulp/isert/ib_isert.c
>   create mode 100644 drivers/infiniband/ulp/isert/ib_isert.h
>   create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
>   create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
>   create mode 100644 include/target/iscsi/iscsi_transport.h
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
