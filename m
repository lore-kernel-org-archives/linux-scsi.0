From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.15-rc1
Date: Sat, 12 Apr 2014 14:29:13 -0700
Message-ID: <1397338153.17547.20.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target pending updates for v3.15-rc1.  Apologies in advance
for waiting until the second to last day of the merge window to send
these out.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this round include:

  - iser-target support for T10 PI (DIF) offloads (Sagi + Or)
  - Fix Task Aborted Status (TAS) handling in target-core (Alex Leung)
  - Pass in transport supported PI at session initialization (Sagi + MKP + nab)
  - Add WRITE_INSERT + READ_STRIP T10 PI support in target-core (nab + Sagi)
  - Fix iscsi-target ERL=2 ASYNC_EVENT connection pointer bug (nab)
  - Fix tcm_fc use-after-free of ft_tpg (Andy Grover)
  - Use correct ib_sg_dma primitives in ib_isert (Mike Marciniszyn)

Also, note the virtio-scsi + vhost-scsi changes to expose T10 PI
metadata into KVM guest have been left-out for now, as there where a few
comments from MST + Paolo that where not able to be addressed in time
for v3.15.  Please expect this feature for v3.16-rc1.

Thank you,

--nab

Alex Leung (2):
  target: Fix Task Aborted Status (TAS) handling
  target: Add check to prevent Abort Task from aborting itself

Andy Grover (6):
  target/tcm_fc: Fix use-after-free of ft_tpg
  target/tcm_fc: Don't export ft_lport_list
  target/tcm_fc: Limit to 1 TPG per wwn
  target/tcm_fc: Rename structs and list members for clarity
  target/tcm_fc: Rename ft_{add,del}_lport to {add,del}_wwn
  target/tcm_fc: Rename ft_tport_create to ft_tport_get

Arshad Hussain (1):
  iscsi-target: Add missing NopOUT->flag (LMB) sanity check

Martin Svec (1):
  Target/sbc: Initialize COMPARE_AND_WRITE write_sg scatterlist

Mike Marciniszyn (1):
  ib_srpt: Use correct ib_sg_dma primitives

Nicholas Bellinger (13):
  iser-target: Match FRMR descriptors to available session tags
  target: Add TFO->abort_task for aborted task resources release
  iser-target: Add missing se_cmd put for WRITE_PENDING in tx_comp_err
  iscsi-target: Fix ERL=2 ASYNC_EVENT connection pointer bug
  target/iblock: Fix double bioset_integrity_free bug
  target: Pass in transport supported PI at session initialization
  target/spc: Only expose PI inquiry bits when supported by fabric
  target/spc: Only expose PI mode page bits when supported by fabric
  target/sbc: Only expose PI read_cap16 bits when supported by fabric
  target/sbc: Add sbc_dif_generate software emulation
  target: Enable WRITE_INSERT emulation in target_execute_cmd
  target/sbc: Add sbc_dif_read_strip software emulation
  target: Enable READ_STRIP emulation in target_complete_ok_work

Paul Bolle (1):
  target: silence GCC warning in target_alua_state_check

Quinn Tran (1):
  target/rd: T10-Dif: RAM disk is allocating more space than required.

Sagi Grimberg (17):
  Target/transport: Allocate protection sg if needed
  Target/sbc: Set protection operation and relevant checks
  Target/file: place escape values for protection information format
  Target/dif: Introduce protection-passthough-only mode
  Target/core: Remove prot_handover use for now
  Target/iscsi: Add T10-PI indication for iscsi_portal_group
  Target/configfs: Expose iSCSI network portal group T10-PI support
  Target/sbc: add debug print
  IB/isert: Introduce isert_map/unmap_data_buf
  IB/isert: Initialize T10-PI resources
  IB/isert: Accept RDMA_WRITE completions
  IB/isert: Support T10-PI protected transactions
  Target/iser: Fix signature work requests accounting
  Target/iser: Consider DIF and RDMA_READ completions when calculating
    post_send counter
  Target/iser: Move check signature status to a function
  Target/iser: Fail SCSI WRITE command if device detected integrity
    error
  Target/iser: Use Fastreg only if device supports signature

 drivers/infiniband/ulp/isert/ib_isert.c      |  828 ++++++++++++++++++++------
 drivers/infiniband/ulp/isert/ib_isert.h      |   38 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   27 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |   18 +-
 drivers/target/iscsi/iscsi_target.c          |   33 +-
 drivers/target/iscsi/iscsi_target_configfs.c |   14 +
 drivers/target/iscsi/iscsi_target_core.h     |    5 +-
 drivers/target/iscsi/iscsi_target_login.c    |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |   21 +
 drivers/target/iscsi/iscsi_target_tpg.h      |    1 +
 drivers/target/iscsi/iscsi_target_util.c     |    4 +-
 drivers/target/iscsi/iscsi_target_util.h     |    1 +
 drivers/target/loopback/tcm_loop.c           |   12 +-
 drivers/target/sbp/sbp_target.c              |    8 +-
 drivers/target/target_core_alua.c            |   95 ++-
 drivers/target/target_core_configfs.c        |    4 +
 drivers/target/target_core_file.c            |   40 +-
 drivers/target/target_core_iblock.c          |    5 +-
 drivers/target/target_core_rd.c              |   14 +-
 drivers/target/target_core_sbc.c             |  178 +++++-
 drivers/target/target_core_spc.c             |   49 +-
 drivers/target/target_core_tmr.c             |   23 +-
 drivers/target/target_core_transport.c       |   92 ++-
 drivers/target/tcm_fc/tcm_fc.h               |   13 +-
 drivers/target/tcm_fc/tfc_cmd.c              |    5 +
 drivers/target/tcm_fc/tfc_conf.c             |   76 +--
 drivers/target/tcm_fc/tfc_sess.c             |   10 +-
 drivers/usb/gadget/tcm_usb_gadget.c          |    8 +-
 drivers/vhost/scsi.c                         |    9 +-
 include/target/iscsi/iscsi_transport.h       |    2 +
 include/target/target_core_backend.h         |    2 +
 include/target/target_core_base.h            |   33 +-
 include/target/target_core_fabric.h          |    6 +-
 33 files changed, 1241 insertions(+), 437 deletions(-)
