From: James Bottomley <James.Bottomley@suse.de>
Subject: [GIT PULL] final SCSI updates for the merge window
Date: Fri, 25 Mar 2011 13:27:50 -0500
Message-ID: <1301077670.4073.28.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

This is mostly patches which were under active review at the time the
merge window opened: the tranche of target updates, qla4xxx, aacraid and
lpfc.  There's also some bnx2fc fixes and a few other assorted bug fixes
which shook out.

The patch is available here:

master.kernel.org:/pub/scm/linux/kernel/git/jejb/scsi-misc-2.6.git

The short changelog is:

Axel Lin (1):
      target: Add __init/__exit annotation for target_core_[init,exit]_configfs

Bhanu Gollapudi (5):
      bnx2fc: IO completion not processed due to missed wakeup
      bnx2fc: Remove unnecessary module state checks
      bnx2fc: Fix MTU issue by using static MTU
      bnx2fc: common free list for cleanup commands
      bnx2fc: Avoid holding cq_lock when iounmap() is called

Christoph Hellwig (1):
      target: remove EXTRA_CFLAGS

Dan Carpenter (2):
      target: Convert rd_build_device_space() to use errno
      target: Minor sparse warning fixes and annotations

Fubo Chen (2):
      tcm_mod_builder.py: Fix generated *_drop_nodeacl() handler
      target: Remove unnecessary hba_dev_list walk and se_clear_dev_ports legacy code

HighPoint Linux Team (1):
      mvsas: Add support for HighPoint RR27xx series HBA

James Bottomley (2):
      Revert "[SCSI] Retrieve the Caching mode page"
      ses: add subenclosure support

James Smart (6):
      lpfc 8.3.22: Update driver version to 8.3.22
      lpfc 8.3.22: Update Copyright Dates
      lpfc 8.3.22: FC Discovery fixes
      lpfc 8.3.22: Add support for PCI Adapter Failure
      lpfc 8.3.22: T10-DIF corrections
      lpfc 8.3.22: Add new mailbox command and new BSG fix

Jesper Juhl (2):
      target: Avoid mem leak and needless work in transport_generic_get_mem
      target: Fix match_strdup() memory leaks

John Hughes (1):
      ses: show devices for enclosures with no page 7

Karen Higgins (2):
      qla4xxx: Prevent other port reinitialization during remove_adapter
      qla4xxx: cleanup DDB relogin logic during initialization

Kashyap, Desai (1):
      mpt2sas : Added customer specific display support

Krishnasamy, Somasundaram (1):
      ses: Avoid kernel panic when lun 0 is not mapped

Mahesh Rajashekhara (1):
      aacraid: Add new code for PMC-Sierra's SRC based controller family

Michael Chan (1):
      bnx2fc: Remove network bonding checking

Mike Christie (1):
      libiscsi_tcp: use kmap in xmit path

Nicholas Bellinger (9):
      tcm_loop: Add multi-fabric Linux/SCSI LLD fabric module
      target: add initial statistics
      target: update version to v4.0.0-rc7-ml
      target: Fix FILEIO fd_buffered_io= token typo
      target: Fix bogus return in transport_add_device_to_core_hba failure path
      target: Convert TMR REQ/RSP definitions to target namespace
      target: Remove spurious double cast from structure macro accessors
      target: Convert backend ->create_virtdevice() call to return ERR_PTR
      target: tcm_mod_builder.py generated Makefile cleanups

Nithin Sujir (3):
      bnx2fc: Bump version to 1.0.1
      bnx2fc: Call bnx2fc_return_rqe and bnx2fc_get_next_rqe with tgt lock held
      bnx2fc: Remove rtnl_trylock/restart_syscall checks

Prasanna Mumbai (3):
      qla4xxx: masking required bits of add_fw_options during initialization
      qla4xxx: Do not retry ISP82XX initialization if H/W state is failed
      qla4xxx: Do not send mbox command if FW is in failed state

Roland Dreier (1):
      target: Fix memory leak on error path in pscsi_alloc_task

Sarang Radke (1):
      qla4xxx: Use polling mode for disable interrupt mailbox completion

Vasiliy Kulikov (1):
      scsi_transport_iscsi: make priv_sess file writeable only by root

Vikas Chaudhary (7):
      qla4xxx: Update driver version to 5.02.00-k6
      qla4xxx: added new function qla4xxx_relogin_all_devices
      qla4xxx: add support for ql4xsess_recovery_tmo cmd line param
      qla4xxx: Add support for ql4xmaxqdepth command line parameter
      qla4xxx: cleanup function qla4xxx_process_ddb_changed
      qla4xxx: remove unused ddb flag DF_NO_RELOGIN
      qla4xxx: cleanup qla4xxx_initialize_ddb_list()

And the diffstat:

 Documentation/target/tcm_mod_builder.py      |   18 +-
 drivers/scsi/aacraid/Makefile                |    2 +-
 drivers/scsi/aacraid/aachba.c                |    7 +-
 drivers/scsi/aacraid/aacraid.h               |  106 ++-
 drivers/scsi/aacraid/commctrl.c              |    3 +-
 drivers/scsi/aacraid/comminit.c              |   58 +-
 drivers/scsi/aacraid/commsup.c               |   41 +-
 drivers/scsi/aacraid/dpcsup.c                |   85 ++-
 drivers/scsi/aacraid/linit.c                 |   15 +-
 drivers/scsi/aacraid/nark.c                  |    3 +-
 drivers/scsi/aacraid/rkt.c                   |    3 +-
 drivers/scsi/aacraid/rx.c                    |   33 +-
 drivers/scsi/aacraid/sa.c                    |    7 +-
 drivers/scsi/aacraid/src.c                   |  594 +++++++++
 drivers/scsi/bnx2fc/bnx2fc.h                 |   22 +-
 drivers/scsi/bnx2fc/bnx2fc_fcoe.c            |   98 +--
 drivers/scsi/bnx2fc/bnx2fc_hwi.c             |   15 +-
 drivers/scsi/bnx2fc/bnx2fc_io.c              |   73 +-
 drivers/scsi/bnx2fc/bnx2fc_tgt.c             |    4 +-
 drivers/scsi/libiscsi_tcp.c                  |   15 +-
 drivers/scsi/lpfc/Makefile                   |    2 +-
 drivers/scsi/lpfc/lpfc.h                     |   27 +-
 drivers/scsi/lpfc/lpfc_attr.c                |   14 +-
 drivers/scsi/lpfc/lpfc_bsg.c                 |   36 +-
 drivers/scsi/lpfc/lpfc_crtn.h                |    6 +-
 drivers/scsi/lpfc/lpfc_els.c                 |    3 +-
 drivers/scsi/lpfc/lpfc_hw.h                  |   15 +-
 drivers/scsi/lpfc/lpfc_hw4.h                 |  113 ++-
 drivers/scsi/lpfc/lpfc_init.c                |   41 +-
 drivers/scsi/lpfc/lpfc_scsi.c                |   43 +-
 drivers/scsi/lpfc/lpfc_sli.c                 |  513 +++++---
 drivers/scsi/lpfc/lpfc_sli4.h                |    2 +-
 drivers/scsi/lpfc/lpfc_version.h             |    2 +-
 drivers/scsi/mpt2sas/mpt2sas_base.c          |   49 +
 drivers/scsi/mpt2sas/mpt2sas_base.h          |   20 +
 drivers/scsi/mvsas/mv_init.c                 |    7 +
 drivers/scsi/qla4xxx/ql4_def.h               |   12 +-
 drivers/scsi/qla4xxx/ql4_fw.h                |    1 +
 drivers/scsi/qla4xxx/ql4_glbl.h              |    1 -
 drivers/scsi/qla4xxx/ql4_init.c              |  207 +---
 drivers/scsi/qla4xxx/ql4_isr.c               |   31 +-
 drivers/scsi/qla4xxx/ql4_mbx.c               |   34 +-
 drivers/scsi/qla4xxx/ql4_nx.c                |    3 +-
 drivers/scsi/qla4xxx/ql4_os.c                |  146 ++-
 drivers/scsi/qla4xxx/ql4_version.h           |    2 +-
 drivers/scsi/scsi_transport_iscsi.c          |    2 +-
 drivers/scsi/sd.c                            |   63 +-
 drivers/scsi/ses.c                           |   48 +-
 drivers/target/Kconfig                       |    2 +
 drivers/target/Makefile                      |    7 +-
 drivers/target/loopback/Kconfig              |   11 +
 drivers/target/loopback/Makefile             |    1 +
 drivers/target/loopback/tcm_loop.c           | 1579 ++++++++++++++++++++++
 drivers/target/loopback/tcm_loop.h           |   77 ++
 drivers/target/target_core_configfs.c        |  117 ++-
 drivers/target/target_core_device.c          |   40 +-
 drivers/target/target_core_fabric_configfs.c |  209 +++-
 drivers/target/target_core_fabric_lib.c      |    1 +
 drivers/target/target_core_file.c            |   28 +-
 drivers/target/target_core_hba.c             |   15 +-
 drivers/target/target_core_iblock.c          |   28 +-
 drivers/target/target_core_pscsi.c           |   22 +-
 drivers/target/target_core_rd.c              |   15 +-
 drivers/target/target_core_rd.h              |    2 -
 drivers/target/target_core_stat.c            | 1810 ++++++++++++++++++++++++++
 drivers/target/target_core_stat.h            |    8 +
 drivers/target/target_core_transport.c       |   37 +-
 include/scsi/libiscsi_tcp.h                  |    1 +
 include/scsi/scsi_device.h                   |    2 +-
 include/target/target_core_base.h            |   73 +-
 include/target/target_core_configfs.h        |    4 +
 include/target/target_core_fabric_ops.h      |    2 +-
 include/target/target_core_tmr.h             |   52 +-
 include/target/target_core_transport.h       |    4 +
 74 files changed, 5830 insertions(+), 962 deletions(-)
 create mode 100644 drivers/scsi/aacraid/src.c
 create mode 100644 drivers/target/loopback/Kconfig
 create mode 100644 drivers/target/loopback/Makefile
 create mode 100644 drivers/target/loopback/tcm_loop.c
 create mode 100644 drivers/target/loopback/tcm_loop.h
 create mode 100644 drivers/target/target_core_stat.c
 create mode 100644 drivers/target/target_core_stat.h

James
