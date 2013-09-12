From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.12-rc1
Date: Thu, 12 Sep 2013 14:36:34 -0700
Message-ID: <1379021794.32763.555.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, nab@daterainc.com, kmo@daterainc.com, Vu Pham <vuhuong@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Zach Brown <zab@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target updates for the v3.12-rc1 merge window.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Lots of activity again this round for I/O performance optimizations
(per-cpu IDA pre-allocation for vhost + iscsi/target), and the addition
of new fabric independent features to target-core (COMPARE_AND_WRITE +
EXTENDED_COPY).

The main highlights include:

 - Support for iscsi-target login multiplexing across individual network
   portals
 - Generic Per-cpu IDA logic (kent + akpm + clameter)
 - Conversion of vhost to use per-cpu IDA pre-allocation for descriptors,
   SGLs and userspace page pointer list
 - Conversion of iscsi-target + iser-target to use per-cpu IDA pre-allocation
   for descriptors
 - Add support for generic COMPARE_AND_WRITE (AtomicTestandSet) emulation for
   virtual backend drivers
 - Add support for generic EXTENDED_COPY (CopyOffload) emulation for virtual
   backend drivers.
 - Add support for fast memory registration mode to iser-target (Vu)

The patches to add COMPARE_AND_WRITE and EXTENDED_COPY support are of
particular significance, which make us the first and only open source
target to support the full set of VAAI primitives.

Currently Linux clients are lacking upstream support to actually utilize
these primitives.  However, with server side support now in place for
folks like MKP + ZAB working on the client, this logic once reserved for
the highest end of storage arrays, can now be run in VMs on their
laptops.

:-)

Thank you,

--nab

Andy Grover (1):
  target/qla2xxx: Make demo_mode_login_only modifiable

Chris Leech (1):
  iscsi-target: ST response on IN6ADDR_ANY socket

Dan Carpenter (1):
  target/pscsi: remove an unneeded check

Gera Kazakov (1):
  target: Fix >= v3.9+ regression in PR APTPL + ALUA metadata write-out

Jingoo Han (1):
  target: replace strict_strto*() with kstrto*()

Kent Overstreet (1):
  idr: Percpu ida

Nicholas Bellinger (40):
  iscsi-target: Prepare login code for multi-plexing support
  iscsi-target: Add login negotiation multi-plexing support
  iscsi-target: Add sk->sk_state_change to cleanup after TCP failure
  iscsi-target: Remove left-over iscsi_target_do_login_io
  iser-target: Updates for login negotiation multi-plexing support
  target: Add transport_init_session_tags using per-cpu ida
  vhost/scsi: Convert to per-cpu ida_alloc + ida_free command map
  vhost/scsi: Add pre-allocation for tv_cmd SGL + upages memory
  iscsi/iser-target: Convert to command priv_size usage
  iscsi-target: Convert to per-cpu ida_alloc + ida_free command map
  scsi: Add CDB definition for COMPARE_AND_WRITE
  target: Add return for se_cmd->transport_complete_callback
  target: Add TCM_MISCOMPARE_VERIFY sense handling
  target: Allow sbc_ops->execute_rw() to accept SGLs + data_direction
  target: Convert se_cmd->t_bidi_data_sg checks to use SCF_BIDI
  target: Refactor transport_generic_get_mem to target_alloc_sgl
  target: Do memory allocation for bidi commands using target_alloc_sgl
  target: Add transport_reset_sgl_orig() for COMPARE_AND_WRITE
  target: Make __target_execute_cmd() available as extern
  target: Add MAXIMUM COMPARE AND WRITE LENGTH in Block Limits VPD
  target: Add support for COMPARE_AND_WRITE emulation
  target: Add compare_and_write_post() completion callback fall through
  target: Release COMPARE_AND_WRITE mutex in generic failure path
  target/tcm_qla2xxx: Add/use target_reverse_dma_direction() in
    target_core_fabric.h
  target: Make target_core_subsystem defined as non static
  target: Make spc_parse_naa_6h_vendor_specific non static
  target: Make helpers non static for EXTENDED_COPY command setup
  target: Add global device list for EXTENDED_COPY
  target: Avoid non-existent tg_pt_gp_mem in target_alua_state_check
  target: Add support for EXTENDED_COPY copy offload emulation
  target: Enable EXTENDED_COPY setup in spc_parse_cdb
  target: Add Third Party Copy (3PC) bit in INQUIRY response
  target: Enable global EXTENDED_COPY setup/release
  iscsi-target: Fix race with thread_pre_handler flush_signals +
    ISCSI_THREAD_SET_DIE
  iscsi-target: Add thread_set->ts_activate_sem + use common deallocate
  iscsi-target: Remove unnecessary wait_for_completion in
    iscsi_get_thread_set
  iscsi-target; Bump default CmdSN Depth to 64
  iscsi-target: Bump default TCP listen backlog to 256
  target: Update copyright ownership/year information to 2013
  target/iscsi: Bump versions to v4.1.0

Vu Pham (3):
  iser-target: move rdma wr processing to a shared function
  iser-target: generalize rdma memory registration and cleanup
  iser-target: introduce fast memory registration mode (FRWR)

Wei Yongjun (1):
  target: remove unused including <linux/version.h>

 drivers/infiniband/ulp/isert/ib_isert.c           |  747 +++++++++-----
 drivers/infiniband/ulp/isert/ib_isert.h           |   26 +-
 drivers/scsi/qla2xxx/qla_target.c                 |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |   59 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                |    1 +
 drivers/target/Makefile                           |    3 +-
 drivers/target/iscsi/iscsi_target.c               |   83 +-
 drivers/target/iscsi/iscsi_target.h               |    7 +-
 drivers/target/iscsi/iscsi_target_auth.c          |    4 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |   16 +-
 drivers/target/iscsi/iscsi_target_core.h          |   26 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |    4 +-
 drivers/target/iscsi/iscsi_target_device.c        |    4 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |    4 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |    4 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |    4 +-
 drivers/target/iscsi/iscsi_target_login.c         |  186 ++--
 drivers/target/iscsi/iscsi_target_login.h         |    3 +
 drivers/target/iscsi/iscsi_target_nego.c          |  367 ++++++-
 drivers/target/iscsi/iscsi_target_nodeattrib.c    |    4 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |    6 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |    4 +-
 drivers/target/iscsi/iscsi_target_stat.c          |   14 +-
 drivers/target/iscsi/iscsi_target_tmr.c           |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c           |   29 +-
 drivers/target/iscsi/iscsi_target_tpg.h           |    4 +-
 drivers/target/iscsi/iscsi_target_tq.c            |  167 ++--
 drivers/target/iscsi/iscsi_target_tq.h            |    5 +-
 drivers/target/iscsi/iscsi_target_util.c          |   45 +-
 drivers/target/loopback/tcm_loop.c                |    2 +-
 drivers/target/target_core_alua.c                 |   39 +-
 drivers/target/target_core_configfs.c             |   60 +-
 drivers/target/target_core_device.c               |   44 +-
 drivers/target/target_core_fabric_configfs.c      |   18 +-
 drivers/target/target_core_fabric_lib.c           |    2 +-
 drivers/target/target_core_file.c                 |   12 +-
 drivers/target/target_core_hba.c                  |    2 +-
 drivers/target/target_core_iblock.c               |   12 +-
 drivers/target/target_core_internal.h             |    2 +
 drivers/target/target_core_pr.c                   |    4 +-
 drivers/target/target_core_pscsi.c                |    7 +-
 drivers/target/target_core_rd.c                   |    8 +-
 drivers/target/target_core_sbc.c                  |  257 ++++-
 drivers/target/target_core_spc.c                  |   27 +-
 drivers/target/target_core_stat.c                 |    2 +-
 drivers/target/target_core_tmr.c                  |    2 +-
 drivers/target/target_core_tpg.c                  |    2 +-
 drivers/target/target_core_transport.c            |  170 +++-
 drivers/target/target_core_ua.c                   |    2 +-
 drivers/target/target_core_xcopy.c                | 1081 +++++++++++++++++++++
 drivers/target/target_core_xcopy.h                |   62 ++
 drivers/target/tcm_fc/tfc_conf.c                  |    6 +-
 drivers/vhost/scsi.c                              |  136 ++-
 include/linux/percpu_ida.h                        |   60 ++
 include/scsi/scsi.h                               |    1 +
 include/target/iscsi/iscsi_transport.h            |    8 +-
 include/target/target_core_backend.h              |    7 +-
 include/target/target_core_base.h                 |   26 +-
 include/target/target_core_fabric.h               |   30 +
 lib/Makefile                                      |    5 +-
 lib/percpu_ida.c                                  |  335 +++++++
 61 files changed, 3487 insertions(+), 776 deletions(-)
 create mode 100644 drivers/target/target_core_xcopy.c
 create mode 100644 drivers/target/target_core_xcopy.h
 create mode 100644 include/linux/percpu_ida.h
 create mode 100644 lib/percpu_ida.c
