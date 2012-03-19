From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target-pending updates for v3.4-rc1 (round 1)
Date: Mon, 19 Mar 2012 15:09:02 -0700
Message-ID: <1332194942.1612.177.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Andy Grover <agrover@redhat.com>, Christoph Hellwig <hch@lst.de>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Roland Dreier <roland@kernel.org>, James Bottomley <jbottomley@parallels.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

The following pull request contains the first series of target-pending
patches destined for v3.4-rc1.  It contains the usual set of updates an=
d
bugfixes to target-core + existing fabric module code, along with a
handful of the patches destined for v3.3 stable.=20

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next

It also contains the necessary target-core infrastructure pieces
required to run using tcm_qla2xxx.ko WWPNs with the new Qlogic Fibre
Channel fabric module currently queued in target-pending/for-next-merge=
,
and coming for round 2.

The highlights for this series include:

*) Add target_submit_tmr() helper function for fabric task management (=
andy)
*) Convert tcm_fc to use target_submit_tmr() (andy)
*) Replace target core various cmd flags with a transport state (hch)
*) Convert loopback to use workqueue submission (hch)
*) Convert target core to use array_zalloc for tpg_lun_list (joern)
*) Convert target core to use array_zalloc for device_list (joern)
*) Add target core support for TMR_ABORT_TASK (nab)
*) Add target core se_sess->sess_kref + get/put helpers (nab)
*) Add target core se_node_acl->acl_kref for ->acl_free_comp usage (nab=
)
*) Convert iscsi-target to use target_put_session + sess_kref (nab)
*) Fix tcm_fc fc_exch memory leak in ft_send_resp_status (nab)
*) Fix ib_srpt srpt_handle_cmd send_ioctx->ioctx_kref leak on exception=
 (nab)
*) Fix target core up handling of short INQUIRY buffers (roland)
*) Untangle target-core front-end and back-end meanings of max_sectors
   attribute (roland)
*) Set loopback residual field for SCSI commands (roland)
*) Fix target-core 16-bit target ports for SET TARGET PORT GROUPS emula=
tion (roland)

Thanks again to Andy, Christoph, Joern, Roland, and everyone who has co=
ntributed
this round!

--nab+

Andy Grover (15):
  scsi: update scsi.h with SYNCHRONIZE_CACHE_16
  target: Use #define for SYNCHRONIZE_CACHE_16
  scsi: Use struct scsi_lun in fc/fcp.h
  target: fix comment typos
  target: Remove unused struct se_queue_req
  target/iscsi: Remove unneeded wrapper functions
  tcm_fc: Simplify ft_send_work for tmr path
  tcm_fc: Remove cmd->cdb data member
  target: Add SCF_SCSI_TMR_CDB usage and drop se_tmr_req_cache
  tcm_fc: Move core->fc code conversion earlier in ft_send_tm()
  tcm_fc: Call lookup_tmr_lun() for all TM types
  tcm_fc: Use transport_generic_free_cmd for ft_sess_put in ft_send_tm
  target: Add target_submit_tmr helper function
  tcm_fc: Convert ft_send_tm to use target_submit_tmr
  target: Cleanup transport_kunmap_data_sg()

Christoph Hellwig (7):
  target: replace various cmd flags with a transport state
  target: remove the transport_lun_active field in struct se_cmd
  target: remove the unused struct iblock_hba
  target: increase iblock task sizes
  tcm_loop: kill tcm_loop_allocate_core_cmd
  tcm_loop: defer all command submissions to workqueue
  tcm_loop: switch to using transport_handle_cdb_direct

Dan Carpenter (1):
  iscsi-target: remove improper externs

J=C3=B6rn Engel (7):
  target: fix use after free in target_report_luns
  target: prevent NULL pointer dereference in target_report_luns
  target: Fix off-by-seven in target_report_luns
  target: Use array_zalloc for tpg_lun_list
  target: Use array_zalloc for device_list
  target: remove obvious warnings
  iscsi-target: Remove unused variables in iscsi_target_parameters.c

Masanari Iida (1):
  target: Fix typo in drivers/target

Nicholas Bellinger (22):
  target: Export transport_generic_request_failure symbol
  target: Add SCF_ACK_KREF flag for acknowledgement kref
  target: Make target_release_cmd_kref release on empty list
  target: Add TMR_ABORT_TASK task management support
  iscsi-target: Fix iscsit_alloc_buffs() failure cases
  target: Fix target_submit_tmr LUN lookup failures
  target: Fix target_submit_tmr se_tmr_req allocation failures
  tcm_fc: Handle target_submit_tmr allocation failure
  target: Push target_submit_tmr LUN lookup failure to system_wq
    context
  target: Allow target_submit_tmr interrupt context + pass ABORT_TASK
    tag
  iscsi-target: Fix dynamic -> explict NodeACL pointer reference
  target: Convert session_lock to irqsave
  target: Add se_sess->sess_kref + get/put helpers
  target: Add se_node_acl->acl_free_comp for NodeACL release path
  target: Add se_node_acl->acl_kref for ->acl_free_comp usage
  target: Convert se_node_acl->acl_group removal to use ->acl_kref
  iscsi-target: Convert to use target_put_session + sess_kref
  target: Drop unused legacy target_core_fabric_ops API callers
  tcm_fc: Fix fc_exch memory leak in ft_send_resp_status
  target: Bump core version to v4.1.0-rc2-ml + fabric versions
  loopback: Fix transport_generic_allocate_tasks error handling
  ib_srpt: Fix srpt_handle_cmd send_ioctx->ioctx_kref leak on exception

Roland Dreier (9):
  target: Use LIST_HEAD()/DEFINE_MUTEX() for static objects
  target: Fix up handling of short INQUIRY buffers
  target: Set peripheral device type consistently in INQUIRY response
  target: Don't set WBUS16 or SYNC bits in INQUIRY response
  target: Untangle front-end and back-end meanings of max_sectors
    attribute
  tcm_loop: Set residual field for SCSI commands
  target: Fix 16-bit target ports for SET TARGET PORT GROUPS emulation
  target: Remove hack to make READ CAPACITY(10) lie if thin
    provisioning is enabled
  target: Fix sense code for unsupported SERVICE ACTION IN

Spencer O Krum (1):
  Documentation/target: Minor spelling typo

Stefan Hajnoczi (1):
  target/pscsi: fix PHV_VIRUTAL_HOST_ID typo

 Documentation/target/tcm_mod_builder.py        |    2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   64 ++---
 drivers/scsi/bnx2fc/bnx2fc_io.c                |    4 +-
 drivers/scsi/libfc/fc_fcp.c                    |    5 +-
 drivers/target/iscsi/iscsi_target.c            |   41 +--
 drivers/target/iscsi/iscsi_target_configfs.c   |   53 +----
 drivers/target/iscsi/iscsi_target_core.h       |    2 +-
 drivers/target/iscsi/iscsi_target_device.c     |   19 --
 drivers/target/iscsi/iscsi_target_device.h     |    2 -
 drivers/target/iscsi/iscsi_target_erl0.c       |    2 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |    2 +-
 drivers/target/iscsi/iscsi_target_login.c      |   10 +-
 drivers/target/iscsi/iscsi_target_nego.c       |   10 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c |   16 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   19 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    6 +-
 drivers/target/iscsi/iscsi_target_tq.c         |    6 -
 drivers/target/iscsi/iscsi_target_util.c       |    7 +-
 drivers/target/loopback/tcm_loop.c             |  363 ++++++++++------=
-------
 drivers/target/loopback/tcm_loop.h             |    4 +-
 drivers/target/target_core_alua.c              |    7 +-
 drivers/target/target_core_cdb.c               |  177 +++---------
 drivers/target/target_core_configfs.c          |   30 +--
 drivers/target/target_core_device.c            |  107 +++++--
 drivers/target/target_core_fabric_configfs.c   |    6 +-
 drivers/target/target_core_iblock.c            |   78 +++---
 drivers/target/target_core_iblock.h            |    7 +-
 drivers/target/target_core_internal.h          |    3 +
 drivers/target/target_core_pr.c                |   23 +-
 drivers/target/target_core_pscsi.c             |   18 +-
 drivers/target/target_core_pscsi.h             |    2 +-
 drivers/target/target_core_stat.c              |   48 ++--
 drivers/target/target_core_tmr.c               |  103 ++++++--
 drivers/target/target_core_tpg.c               |  115 +++++---
 drivers/target/target_core_transport.c         |  367 +++++++++++++++-=
--------
 drivers/target/target_core_ua.c                |    8 +-
 drivers/target/tcm_fc/tcm_fc.h                 |    8 +-
 drivers/target/tcm_fc/tfc_cmd.c                |  147 +++-------
 drivers/target/tcm_fc/tfc_conf.c               |    4 -
 drivers/target/tcm_fc/tfc_sess.c               |   21 --
 include/scsi/fc/fc_fcp.h                       |    6 +-
 include/scsi/scsi.h                            |    1 +
 include/target/target_core_backend.h           |    2 +
 include/target/target_core_base.h              |   85 +++---
 include/target/target_core_fabric.h            |   14 +-
 45 files changed, 962 insertions(+), 1062 deletions(-)
