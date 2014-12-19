From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.19-rc1
Date: Fri, 19 Dec 2014 02:06:34 -0800
Message-ID: <1418983594.29647.150.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Greg KH <gregkh@linuxfoundation.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the target-pending updates for v3.19-rc1 code.  Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this merge window include:

  - Allow target fabric drivers to function as built-in. (Roland)
  - Fix tcm_loop multi-TPG endpoint nexus bug. (Hannes)
  - Move per device config_item_type into se_subsystem_api, allowing
    configfs attributes to be defined at module_init time. (Jerome + nab)
  - Convert existing IBLOCK/FILEIO/RAMDISK/PSCSI/TCMU drivers to use
    external configfs attributes. (nab)
  - A number of iser-target fixes related to active session + network portal
    shutdown stability during extended stress testing. (Sagi + Slava)
  - Dynamic allocation of T10-PI contexts for iser-target, fixing a potentially
    bogus iscsi_np->tpg_np pointer reference in >= v3.14 code. (Sagi)
  - iser-target performance + scalability improvements.  (Sagi) 
  - Fixes for SPC-4 Persistent Reservation AllRegistrants spec compliance.
    (Ilias + James + nab)
  - Avoid potential short kern_sendmsg() in iscsi-target for now until Al's
    conversion to use msghdr iteration is merged post -rc1. (Viro)

Also, Sagi has requested a number of iser-target patches (9) that
address stability issues he's encountered during extended stress testing
be considered for v3.10.y + v3.14.y code.  Given the amount of LOC
involved, it will certainly require extra backporting effort.

Apologies in advance to Greg-KH & Co on this.  Sagi and I will be
working post-merge to ensure they each get applied correctly.

Thank you,

--nab

Hannes Reinecke (1):
  tcm_loop: Fix wrong I_T nexus association

Julia Lawall (1):
  target: remove unneeded array

Kyle McMartin (1):
  uapi/linux/target_core_user.h: fix headers_install.sh badness

Lino Sanfilippo (1):
  iscsi-target: fix error path in iscsi_target_init_module()

Markus Elfring (1):
  target: Deletion of unnecessary checks before the function call
    "module_put"

Nicholas Bellinger (22):
  target: Move dev_cit to struct se_subsystem_api
  target: Move dev_attrib_cit to struct se_subsystem_api
  target: Move dev_pr_cit to struct se_subsystem_api
  target: Move dev_wwn_cit to struct se_subsystem_api
  target: Move dev_alua_tg_pt_gps_cit to struct se_subsystem_api
  target: Move dev_stat_cit to struct se_subsystem_api
  target: Add target_core_backend_configfs.h helper macros
  target: Add EXPORT_SYMBOL for existing se_dev_set_*
  target: Add DEF_TB_DEFAULT_ATTRIBS macro for virtual device attrs
  target/iblock: Convert to external iblock_backend_dev_attrs
  target/file: Convert to external fileio_backend_dev_attrs
  target/rd: Convert to external rd_mcp_backend_dev_attrs
  target/user: Convert to external tcmu_backend_dev_attrs
  target/pscsi: Convert to external pscsi_backend_dev_attrs
  target: Drop left-over internal dev attribute code
  target: Drop left-over PHBA_PDEV set attr checks
  iser-target: Fix wc->wr_id cast warning
  iscsi-target: Drop left-over bogus iscsi_np->tpg_np
  target: Fix R_HOLDER bit usage for AllRegistrants
  target: Avoid dropping AllRegistrants reservation during unregister
  iscsi-target: Fail connection on short sendmsg writes
  target: Allow AllRegistrants to re-RESERVE existing reservation

Roland Dreier (1):
  target: Fix target_core_register_fabric() for built-in fabric modules

Sagi Grimberg (25):
  iscsi,iser-target: Initiate termination only once
  iser-target: Fix flush + disconnect completion handling
  iser-target: Parallelize CM connection establishment
  iser-target: Fix connected_handler + teardown flow race
  iser-target: Handle ADDR_CHANGE event for listener cm_id
  iser-target: Fix implicit termination of connections
  iser-target: Allocate PI contexts dynamically
  iser-target: Fix NULL dereference in SW mode DIF
  iscsi,iser-target: Expose supported protection ops according to t10_pi
  iser-target: Work-around live target stack shutdown resource cleanup
  iser-target: Remove interrupt coalescing
  iser-target: Unite error completion handler for RX and TX
  iser-target: Cast wr_id with uintptr_t instead of unsinged long
  iser-target: Centralize completion elements to a context
  iser-target: Use single CQ for TX and RX
  iser-target: Remove redundant call to isert_conn_terminate
  iser-target: Remove an atomic operation from the IO path
  iser-target: Introduce isert_poll_budget
  iser-target: Reduce CQ lock contention by batch polling
  iser-target: Don't wait for session commands from completion context
  iser-target: Fix logout sequence
  iser-target: Use debug_level parameter to control logging level
  iser-target: Adjust log levels and prettify some prints
  iser-target: Remove code duplication
  iscsi-target: nullify session in failed login sequence

 drivers/infiniband/ulp/isert/ib_isert.c       | 1599 +++++++++++++------------
 drivers/infiniband/ulp/isert/ib_isert.h       |   80 +-
 drivers/target/iscsi/iscsi_target.c           |    1 +
 drivers/target/iscsi/iscsi_target_core.h      |    1 -
 drivers/target/iscsi/iscsi_target_login.c     |   11 +-
 drivers/target/iscsi/iscsi_target_tpg.c       |    1 -
 drivers/target/iscsi/iscsi_target_transport.c |    3 +-
 drivers/target/iscsi/iscsi_target_util.c      |   26 +-
 drivers/target/loopback/tcm_loop.c            |   66 +-
 drivers/target/loopback/tcm_loop.h            |    7 +-
 drivers/target/target_core_configfs.c         |  344 ++----
 drivers/target/target_core_device.c           |   90 +-
 drivers/target/target_core_file.c             |   42 +
 drivers/target/target_core_hba.c              |    7 +-
 drivers/target/target_core_iblock.c           |   42 +
 drivers/target/target_core_internal.h         |   28 -
 drivers/target/target_core_pr.c               |  125 +-
 drivers/target/target_core_pscsi.c            |   26 +
 drivers/target/target_core_rd.c               |   41 +
 drivers/target/target_core_user.c             |   42 +
 include/target/target_core_backend.h          |   43 +
 include/target/target_core_backend_configfs.h |  120 ++
 include/uapi/linux/target_core_user.h         |    4 -
 23 files changed, 1511 insertions(+), 1238 deletions(-)
 create mode 100644 include/target/target_core_backend_configfs.h 
