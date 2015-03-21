From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.0-rc5
Date: Fri, 20 Mar 2015 21:15:15 -0700
Message-ID: <1426911315.9176.39.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are current target-pending fixes for v4.0-rc5 code that have made
their way into the queue over the last weeks.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The fixes this round include:

  - Fix long-standing iser-target logout bug related to early conn_logout_comp
    completion, resulting in iscsi_conn use-after-tree OOpsen.  (Sagi + nab)

  - Fix long-standing tcm_fc bug in ft_invl_hw_context() failure handing
    for DDP hw offload.  (DanC)

  - Fix incorrect use of unprotected __transport_register_session() in
    tcm_qla2xxx + other single local se_node_acl fabrics.  (Bart)

  - Fix reference leak in target_submit_cmd() -> target_get_sess_cmd() for
    ack_kref=1 failure path.  (Bart)

  - Fix pSCSI backend ->get_device_type() statistics OOPs with un-configured
    device.  (Olaf + nab)

  - Fix virtual LUN=0 target_configure_device failure OOPs at modprobe time.
    (Claudio + nab)

  - Fix FUA write false positive failure regression in v4.0-rc1 code.
    (Christophe Vu-Brugier + HCH)

Thank you,

--nab

Bart Van Assche (3):
  tcm_qla2xxx: Fix incorrect use of __transport_register_session
  loop/usb/vhost-scsi/xen-scsiback: Fix use of
    __transport_register_session
  target: Fix reference leak in target_get_sess_cmd() error path

Christophe Vu-Brugier (1):
  target: do not reject FUA CDBs when write cache is enabled but
    emulate_write_cache is 0

Dan Carpenter (1):
  tcm_fc: missing curly braces in ft_invl_hw_context()

Nicholas Bellinger (5):
  target: Disallow changing of WRITE cache/FUA attrs after export
  Revert "iscsi-target: Avoid IN_LOGOUT failure case for iser-target"
  iscsi-target: Avoid early conn_logout_comp for iser connections
  target/pscsi: Fix NULL pointer dereference in get_device_type
  target: Fix virtual LUN=0 target_configure_device failure OOPs

 drivers/scsi/qla2xxx/tcm_qla2xxx.c         |  2 +-
 drivers/target/iscsi/iscsi_target.c        | 14 +++++++++----
 drivers/target/iscsi/iscsi_target_erl0.c   |  4 +---
 drivers/target/loopback/tcm_loop.c         |  7 ++-----
 drivers/target/target_core_device.c        | 32 +++++++++++++++++++++++++++---
 drivers/target/target_core_pscsi.c         |  2 +-
 drivers/target/target_core_sbc.c           |  3 +--
 drivers/target/target_core_spc.c           | 19 +++---------------
 drivers/target/target_core_transport.c     |  4 ++++
 drivers/target/tcm_fc/tfc_io.c             |  3 ++-
 drivers/usb/gadget/legacy/tcm_usb_gadget.c |  5 ++---
 drivers/vhost/scsi.c                       |  5 ++---
 drivers/xen/xen-scsiback.c                 |  7 ++-----
 include/target/target_core_backend.h       |  1 +
 14 files changed, 61 insertions(+), 47 deletions(-)
