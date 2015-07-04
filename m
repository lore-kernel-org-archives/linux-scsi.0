From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.2-rc1
Date: Sat, 04 Jul 2015 12:29:47 -0700
Message-ID: <1436038187.23713.83.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target-pending updates for v4.2-rc1.  Please go
ahead and pull from:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

It's been a busy development cycle for target-core in a number of
different areas.

The fabric API usage for se_node_acl allocation is now within
target-core code, dropping the external API callers for all fabric
drivers tree-wide.

There is a new conversion to RCU hlists for se_node_acl and
se_portal_group LUN mappings, that turns fast-past LUN lookup into a
completely lock-less code-path.  It also removes the original hard-coded
limitation of 256 LUNs per fabric endpoint.  

The configfs attributes for backends can now be shared between core and
driver code, allowing existing drivers to use common code while still
allowing flexibility for new backend provided attributes. 

The highlights include:

  - Merge sbc_verify_dif_* into common code (sagi)
  - Remove iscsi-target support for obsolete IFMarker/OFMarker
    (Christophe Vu-Brugier)
  - Add bidi support in target/user backend (ilias + vangelis + agover)
  - Move se_node_acl allocation into target-core code (hch)
  - Add crc_t10dif_update common helper (akinobu + mkp)
  - Handle target-core odd SGL mapping for data transfer memory (akinobu)
  - Move transport ID handling into target-core (hch)
  - Move task tag into struct se_cmd + support 64-bit tags (bart)
  - Convert se_node_acl->device_list[] to RCU hlist (nab + hch + paulmck)
  - Convert se_portal_group->tpg_lun_list[] to RCU hlist (nab + hch + paulmck)
  - Simplify target backend driver registration (hch)
  - Consolidate + simplify target backend attribute implementations (hch + nab)
  - Subsume se_port + t10_alua_tg_pt_gp_member into se_lun (hch)
  - Drop lun_sep_lock for se_lun->lun_se_dev RCU usage (hch + nab)
  - Drop unnecessary core_tpg_register TFO parameter (nab)
  - Use 64-bit LUNs tree-wide (hannes)
  - Drop left-over TARGET_MAX_LUNS_PER_TRANSPORT limit (hannes)

Thank you,

--nab

Akinobu Mita (4):
  target: Fix inconsistent address passed to kunmap_atomic() in
    sbc_dif_copy_prot()
  target: ensure se_cmd->t_prot_sg is allocated when required
  lib: introduce crc_t10dif_update()
  target: handle odd SG mapping for data transfer memory

Bart Van Assche (5):
  target: Remove first argument of target_{get,put}_sess_cmd()
  target: Move task tag into struct se_cmd + support 64-bit tags
  ib_srpt: Remove set-but-not-used variables
  target: Remove set-but-not-used-variables
  target: Simplify LUN shutdown code

Christoph Hellwig (31):
  target: fix DPO and FUA bit checks
  tcm_loop: remove struct tcm_loop_nacl
  tcm_usb: remove struct usbg_nacl
  sbp_target: remove struct sbp_nacl
  vhost/scsi: remove struct vhost_scsi_nacl
  target: make the tpg_get_default_depth method optional
  target: refactor init/drop_nodeacl methods
  target: refactor node ACL allocation
  target: move node ACL allocation to core code
  target/iscsi: stop using se_tpg_fabric_ptr
  tcm_loop: stop using se_tpg_fabric_ptr
  tcm_fc: stop using se_tpg_fabric_ptr
  target: change core_tpg_register prototype
  target: remove the get_fabric_proto_ident method
  target: move transport ID handling to the core
  target: don't copy fabric ops
  target: put struct target_fabric_configfs on a diet
  target: remove struct target_fabric_configfs_template
  target: target_core_configfs.h is not needed in fabric drivers
  target: remove ->put_session method
  target/pr: cleanup core_scsi3_pr_seq_non_holder
  target: simplify backend driver registration
  target: consolidate backend attribute implementations
  target: simplify backend attribute implementation
  target: Subsume se_port + t10_alua_tg_pt_gp_member into se_lun
  target: replace se_cmd->execute_rw with a protocol_data field
  target: simplify UNMAP handling
  target: implement WRITE_SAME with UNMAP bit using ->execute_unmap
  target: consolidate version defines
  target: remove unused TARGET_CORE_CONFIG_ROOT define
  target: remove target_core_configfs.h

Christophe Vu-Brugier (3):
  iscsi-target: remove support for obsolete markers
  target: fix a log message in se_dev_set_emulate_rest_reord()
  iscsi-target: fix variable name typo in iscsi_check_acceptor_state()

Hannes Reinecke (8):
  target: use 64-bit LUNs
  target: Remove TARGET_MAX_LUNS_PER_TRANSPORT
  target_core_alua: Correct UA handling when switching states
  target: Remove 'ua_nacl' pointer from se_ua structure
  target: use 'se_dev_entry' when allocating UAs
  target: Send UA on ALUA target port group change
  target: Send UA upon LUN RESET tmr completion
  target: Send UA when changing LUN inventory

Ilias Tsitsimpis (5):
  driver/user: Don't warn for DMA_NONE data direction
  target/loop: Enable VARLEN CDB support
  target/transport: Always initialize bidi fields in se_cmd
  target/user: Refactor data area allocation code
  target/user: Add support for bidirectional commands

Nicholas Bellinger (16):
  target: Convert se_node_acl->device_list[] to RCU hlist
  target/pr: Use atomic bitop for se_dev_entry->deve_flags reservation
    check
  target/pr: Change alloc_registration to avoid pr_reg_tg_pt_lun
  target: Convert se_portal_group->tpg_lun_list[] to RCU hlist
  target: Convert se_tpg->acl_node_lock to ->acl_node_mutex
  target: Convert core_tpg_deregister to use list splice
  target: Drop unused se_lun->lun_acl_list
  target: Only reset specific dynamic entries during lun_group creation
  target: Drop left-over se_lun->lun_status
  target: Drop lun_sep_lock for se_lun->lun_se_dev RCU usage
  target: Drop se_lun->lun_active for existing percpu lun_ref
  target: Drop unnecessary core_tpg_register TFO parameter
  target: Drop duplicate + unused se_dev_check_wce
  xen-scsiback: Fix compile warning for 64-bit LUN
  target: Convert se_lun->lun_deve_lock to normal spinlock
  target: Bump core version to v5.0

Sagi Grimberg (4):
  target: Merge sbc_verify_dif_read|write
  target/file: Remove fd_prot bounce buffer
  target/sbc: Fix sbc_dif_verify inconsistent map/unmap
  target/user: Fix inconsistent kmap_atomic/kunmap_atomic

 Documentation/target/tcm_mod_builder.py        |  277 +----
 Documentation/target/tcm_mod_builder.txt       |    4 +-
 Documentation/target/tcmu-design.txt           |    2 +-
 drivers/infiniband/ulp/isert/ib_isert.c        |    6 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |  183 +---
 drivers/infiniband/ulp/srpt/ib_srpt.h          |   23 +-
 drivers/scsi/qla2xxx/qla_target.c              |   52 +-
 drivers/scsi/qla2xxx/qla_target.h              |    1 -
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |  227 +----
 drivers/scsi/qla2xxx/tcm_qla2xxx.h             |    6 +-
 drivers/target/iscsi/iscsi_target.c            |   38 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |  137 +--
 drivers/target/iscsi/iscsi_target_erl0.c       |   53 -
 drivers/target/iscsi/iscsi_target_erl0.h       |    1 -
 drivers/target/iscsi/iscsi_target_login.c      |   58 +-
 drivers/target/iscsi/iscsi_target_login.h      |    1 -
 drivers/target/iscsi/iscsi_target_parameters.c |  275 +----
 drivers/target/iscsi/iscsi_target_parameters.h |   11 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    4 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |   12 +-
 drivers/target/iscsi/iscsi_target_util.c       |   53 +-
 drivers/target/iscsi/iscsi_target_util.h       |    1 -
 drivers/target/loopback/tcm_loop.c             |  182 +---
 drivers/target/loopback/tcm_loop.h             |    9 -
 drivers/target/sbp/sbp_target.c                |  275 +----
 drivers/target/sbp/sbp_target.h                |   11 +-
 drivers/target/target_core_alua.c              |  463 ++++-----
 drivers/target/target_core_alua.h              |   14 +-
 drivers/target/target_core_configfs.c          |  758 ++++++++++++--
 drivers/target/target_core_device.c            | 1289 ++++++------------------
 drivers/target/target_core_fabric_configfs.c   |  230 ++---
 drivers/target/target_core_fabric_lib.c        |  283 +++---
 drivers/target/target_core_file.c              |  235 +----
 drivers/target/target_core_file.h              |    6 -
 drivers/target/target_core_hba.c               |   97 +-
 drivers/target/target_core_iblock.c            |   96 +-
 drivers/target/target_core_internal.h          |  103 +-
 drivers/target/target_core_pr.c                |  379 +++----
 drivers/target/target_core_pr.h                |    6 +-
 drivers/target/target_core_pscsi.c             |   55 +-
 drivers/target/target_core_rd.c                |   90 +-
 drivers/target/target_core_sbc.c               |  285 +++---
 drivers/target/target_core_spc.c               |   90 +-
 drivers/target/target_core_stat.c              |  608 +++++------
 drivers/target/target_core_tmr.c               |   24 +-
 drivers/target/target_core_tpg.c               |  574 ++++-------
 drivers/target/target_core_transport.c         |  249 ++---
 drivers/target/target_core_ua.c                |   81 +-
 drivers/target/target_core_ua.h                |    6 +-
 drivers/target/target_core_user.c              |  266 ++---
 drivers/target/target_core_xcopy.c             |   25 +-
 drivers/target/tcm_fc/tcm_fc.h                 |    3 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   11 +-
 drivers/target/tcm_fc/tfc_conf.c               |  112 +-
 drivers/target/tcm_fc/tfc_io.c                 |    1 -
 drivers/target/tcm_fc/tfc_sess.c               |    1 -
 drivers/usb/gadget/legacy/tcm_usb_gadget.c     |  192 +---
 drivers/usb/gadget/legacy/tcm_usb_gadget.h     |   11 -
 drivers/vhost/scsi.c                           |  219 +---
 drivers/xen/xen-scsiback.c                     |  191 +---
 include/linux/crc-t10dif.h                     |    1 +
 include/target/iscsi/iscsi_target_core.h       |   12 +-
 include/target/target_core_backend.h           |   72 +-
 include/target/target_core_backend_configfs.h  |  118 ---
 include/target/target_core_base.h              |  186 ++--
 include/target/target_core_configfs.h          |   48 -
 include/target/target_core_fabric.h            |   71 +-
 lib/crc-t10dif.c                               |   12 +-
 68 files changed, 3163 insertions(+), 6312 deletions(-)
 delete mode 100644 include/target/target_core_backend_configfs.h
 delete mode 100644 include/target/target_core_configfs.h
