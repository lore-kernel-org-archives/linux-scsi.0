From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.10-rc1
Date: Mon, 29 Apr 2013 19:59:26 -0700
Message-ID: <1367290766.16334.77.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Asias He <asias@redhat.com>, Roland Dreier <roland@kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target pending changes for the v3.10-rc1 merge window. =20

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next-merge

The highlights this round include:

 - Add fileio support for WRITE_SAME w/ UNMAP=3D1 discard (asias)
 - Add fileio support for UNMAP discard (asias)
 - Add tcm_vhost hotplug support to work with upstream QEMU =20
   vhost-scsi-pci code (asias + mst)
 - Check for aborted sequence in tcm_fc response path (mdr)
 - Add initial iscsit_transport support into iscsi-target code (nab)
 - Refactor iscsi-target RX PDU logic + export request PDU handling  (n=
ab)
 - Refactor iscsi-target TX queue logic + export response PDU creation =
(nab)
 - Add new iSCSI Extentions for RDMA (ISER) target driver (Or + nab)

The biggest changes revolve around iscsi-target refactoring in order to
support the iser-target driver.  This includes the conversion of the
iscsi-target data-path to use modern se_cmd->cmd_kref counting, and
allowing transport independent aspects of RX/TX PDU request/response
handling be shared across existing traditional iscsi-target code, and
the new iser-target code.

Thanks to Or Gerlitz + Mellanox for supporting the iser-target
development effort!

Thank you,

--nab

Andy Grover (2):
  target/iscsi: Remove chap_set_random()
  target/iscsi: Use ISCSI_LOGIN_CURRENT/NEXT_STAGE macros

Asias He (10):
  target/file: Add WRITE_SAME w/ UNMAP=3D1 emulation support
  target/file: Add UNMAP emulation support
  target/file: Add fd_do_unmap() helper
  target/iblock: Add iblock_do_unmap() helper
  target: Add sbc_execute_unmap() helper
  target/file: Set is_nonrot attribute
  tcm_vhost: Refactor the lock nesting rule
  tcm_vhost: Add hotplug/hotunplug support
  tcm_vhost: Add ioctl to get and set events missed flag
  tcm_vhost: Enable VIRTIO_SCSI_F_HOTPLUG

J=C3=B6rn Engel (2):
  qla2xxx: Remove unused function
  target: Change default sense key of NOT_READY

Mark Rustad (1):
  tcm_fc: Check for aborted sequence

Nicholas Bellinger (9):
  target: Add export of target_get_sess_cmd symbol
  iscsi-target: Add iscsit_transport API template
  iscsi-target: Initial traditional TCP conversion to iscsit_transport
  iscsi-target: Add iser-target parameter keys + setup during login
  iscsi-target: Add per transport iscsi_cmd alloc/free
  iscsi-target: Refactor RX PDU logic + export request PDU handling
  iscsi-target: Refactor TX queue logic + export response PDU creation
  iscsi-target: Add iser network portal attribute
  iser-target: Add iSCSI Extensions for RDMA (iSER) target driver

Wei Yongjun (1):
  tcm_fc: using kfree_rcu() to simplify the code

 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/ulp/isert/Kconfig           |    5 +
 drivers/infiniband/ulp/isert/Makefile          |    2 +
 drivers/infiniband/ulp/isert/ib_isert.c        | 2281 ++++++++++++++++=
++++++++
 drivers/infiniband/ulp/isert/ib_isert.h        |  138 ++
 drivers/infiniband/ulp/isert/isert_proto.h     |   47 +
 drivers/scsi/qla2xxx/qla_target.c              |   19 -
 drivers/scsi/qla2xxx/qla_target.h              |    1 -
 drivers/target/iscsi/Makefile                  |    3 +-
 drivers/target/iscsi/iscsi_target.c            | 1184 ++++++++-----
 drivers/target/iscsi/iscsi_target.h            |    3 +-
 drivers/target/iscsi/iscsi_target_auth.c       |   28 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   98 +-
 drivers/target/iscsi/iscsi_target_core.h       |   26 +-
 drivers/target/iscsi/iscsi_target_device.c     |    7 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   13 +-
 drivers/target/iscsi/iscsi_target_login.c      |  472 ++++--
 drivers/target/iscsi/iscsi_target_login.h      |    6 +
 drivers/target/iscsi/iscsi_target_nego.c       |  194 +--
 drivers/target/iscsi/iscsi_target_nego.h       |   11 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   87 +-
 drivers/target/iscsi/iscsi_target_parameters.h |   16 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_transport.c  |   55 +
 drivers/target/iscsi/iscsi_target_util.c       |   53 +-
 drivers/target/iscsi/iscsi_target_util.h       |    1 +
 drivers/target/target_core_file.c              |  122 ++-
 drivers/target/target_core_iblock.c            |  108 +-
 drivers/target/target_core_sbc.c               |   85 +
 drivers/target/target_core_transport.c         |   13 +-
 drivers/target/tcm_fc/tfc_io.c                 |    9 +-
 drivers/target/tcm_fc/tfc_sess.c               |    9 +-
 drivers/vhost/tcm_vhost.c                      |  262 +++-
 drivers/vhost/tcm_vhost.h                      |   13 +
 include/target/iscsi/iscsi_transport.h         |   83 +
 include/target/target_core_backend.h           |    4 +
 include/target/target_core_fabric.h            |    2 +-
 39 files changed, 4470 insertions(+), 1002 deletions(-)
 create mode 100644 drivers/infiniband/ulp/isert/Kconfig
 create mode 100644 drivers/infiniband/ulp/isert/Makefile
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.c
 create mode 100644 drivers/infiniband/ulp/isert/ib_isert.h
 create mode 100644 drivers/infiniband/ulp/isert/isert_proto.h
 create mode 100644 drivers/target/iscsi/iscsi_target_transport.c
 create mode 100644 include/target/iscsi/iscsi_transport.h
