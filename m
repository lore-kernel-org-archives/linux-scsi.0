From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: [GIT PULL] target updates for v4.5-rc1
Date: Wed, 20 Jan 2016 13:16:12 -0800
Message-ID: <1453324572.27508.149.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are target-pending updates for v4.5-rc1 code.

Please go ahead and PULL from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note that Sagi + Jenny's series for iser target + initiator remote
invalidation is being merged via rdma.git, and Doug will be sending
in his rmda.git PULL request.

As per SFR, you'll (eventually) hit a minor iser-target merge conflict
vs. rdma.git once you PULL from Doug due to a ERR_PTR bug-fix:

http://marc.info/?l=linux-next&m=145222770105861&w=2

The highlights this round include:

 - Introduce configfs support for unlocked configfs_depend_item()
   (krzysztof + andrezej)
 - Conversion of usb-gadget target driver to new function registration 
   interface (andrzej + sebastian)
 - Enable qla2xxx FC target mode support for Extended Logins
   (himansu + giridhar)
 - Enable qla2xxx FC target mode support for Exchange Offload
   (himansu + giridhar)
 - Add qla2xxx FC target mode irq affinity notification +
   selective command queuing.  (quinn + himanshu)
 - Fix iscsi-target deadlock in se_node_acl configfs deletion
   (sagi + nab)
 - Convert se_node_acl configfs deletion + se_node_acl->queue_depth
   to proper se_session->sess_kref + target_get_session() usage.
   (hch + sagi + nab)
 - Fix long-standing race between se_node_acl->acl_kref get and
   get_initiator_node_acl() lookup.  (hch + nab)
 - Fix target/user block-size handling, and make sure netlink reaches
   all network namespaces (sheng + andy)

Note there is an outstanding bug-fix series for remote I_T nexus port
TMR LUN_RESET has been posted and still being tested, and will likely
become post -rc1 material at this point.

Thank you,

--nab

Alexei Potashnik (2):
  qla2xxx: Delete session if initiator is gone from FW
  qla2xxx: Wait for all conflicts before ack'ing PLOGI

Andrzej Pietrasiewicz (11):
  usb: gadget: tcm: split string definitions into function and device
  usb: gadget: tcm: follow naming conventions
  usb: gadget: tcm: use strtobool for a boolean value
  usb: gadget: tcm: simplify attribute store function
  usb: gadget: tcm: factor out f_tcm
  usb: gadget: f_tcm: convert to new function interface with backward
    compatibility
  usb: gadget: tcm: convert to use new function registration interface
  usb: gadget: f_tcm: remove compatibility layer
  usb: gadget: f_tcm: remove redundant singleton
  usb: gadget: f_tcm: use usb_gstrings_attach
  usb: gadget: f_tcm: add configfs support

Andy Grover (1):
  target/fcoe: Add tag support to tcm_fc

Arnd Bergmann (1):
  scsi: qla2xxxx: avoid type mismatch in comparison

Bart Van Assche (9):
  target: Fix spelling + remove set-but-not-used variables
  iscsi-target: Fix indentation + spelling + unreachable code
  sbp-target: Remove a superfluous forward declaration
  target: Fix indentation in target_core_configfs.c
  target: Remove an unused variable
  usb/gadget: Remove set-but-not-used variables
  target: Support aborting tasks with a 64-bit tag
  target: Fix a memory leak in target_dev_lba_map_store()
  tcm_fc: Wait for command completion before freeing a session

Christophe Vu-Brugier (1):
  target: fix deprecated attribute names in dmesg

Dilip Kumar Uppugandla (1):
  qla2xxx: Check for online flag instead of active reset when
    transmitting responses

Geliang Tang (1):
  target: use offset_in_page macro

Himanshu Madhani (4):
  qla2xxx: Enable Extended Logins support
  qla2xxx: Enable Exchange offload support.
  qla2xxx: Enable Target counters in DebugFS.
  qla2xxx: Added interface to send explicit LOGO.

Jamie Pocas (1):
  target/sbc: Add LBPRZ attribute + control CDB emulation

Krzysztof Opasiak (4):
  fs: configfs: Drop unused parameter from configfs_undepend_item()
  fs: configfs: Factor out configfs_do_depend_item()
  fs: configfs: Factor out configfs_find_subsys_dentry()
  fs: configfs: Add unlocked version of configfs_depend_item()

Nicholas Bellinger (9):
  tcm_usb_gadget: Don't strip off nexus WWPN prefix
  tcm_usb_gadget: Fix nexus leak
  tcm_usb_gadget: Fix enabled attribute failure
  iser-target: Fix non negative ERR_PTR isert_device_get usage
  tcm_fc: Convert acl lookup to modern get_initiator_node_acl usage
  ib_srpt: Convert acl lookup to modern get_initiator_node_acl usage
  iscsi-target: Fix potential dead-lock during node acl delete
  target: Convert ACL change queue_depth se_session reference usage
  target: Obtain se_node_acl->acl_kref during get_initiator_node_acl

Quinn Tran (8):
  qla2xxx: Add FW resource count in DebugFS.
  qla2xxx: Replace QLA_TGT_STATE_ABORTED with a bit.
  qla2xxx: Remove dependency on hardware_lock to reduce lock contention.
  qla2xxx: Add irq affinity notification
  qla2xxx: Add selective command queuing
  qla2xxx: Move atioq to a different lock to reduce lock contention
  qla2xxx: Disable ZIO at start time.
  qla2xxx: Set all queues to 4k

Sheng Yang (3):
  tcm_loop: Show address of tpg in configfs
  target/user: Allow user to set block size before enabling device
  target/user: Make sure netlink would reach all network namespaces

 Documentation/ABI/testing/configfs-usb-gadget-tcm  |    6 +
 drivers/infiniband/ulp/isert/ib_isert.c            |    7 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |  103 +-
 drivers/infiniband/ulp/srpt/ib_srpt.h              |    8 -
 drivers/scsi/qla2xxx/qla_attr.c                    |   36 +
 drivers/scsi/qla2xxx/qla_dbg.c                     |   19 +-
 drivers/scsi/qla2xxx/qla_def.h                     |   83 +-
 drivers/scsi/qla2xxx/qla_dfs.c                     |  106 +
 drivers/scsi/qla2xxx/qla_gbl.h                     |   18 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   58 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    2 +
 drivers/scsi/qla2xxx/qla_iocb.c                    |  188 ++
 drivers/scsi/qla2xxx/qla_isr.c                     |  126 +-
 drivers/scsi/qla2xxx/qla_mbx.c                     |  265 ++-
 drivers/scsi/qla2xxx/qla_os.c                      |  165 +-
 drivers/scsi/qla2xxx/qla_target.c                  |  645 ++++--
 drivers/scsi/qla2xxx/qla_target.h                  |   34 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                 |   38 +-
 drivers/target/iscsi/iscsi_target.c                |    7 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |   17 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |    7 +-
 drivers/target/iscsi/iscsi_target_parameters.c     |    2 +-
 drivers/target/iscsi/iscsi_target_tmr.c            |    2 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |   10 -
 drivers/target/iscsi/iscsi_target_tpg.h            |    2 -
 drivers/target/loopback/tcm_loop.c                 |   14 +
 drivers/target/sbp/sbp_target.c                    |    2 -
 drivers/target/target_core_configfs.c              |   47 +-
 drivers/target/target_core_device.c                |    2 +
 drivers/target/target_core_iblock.c                |    2 +
 drivers/target/target_core_pr.c                    |   11 +-
 drivers/target/target_core_sbc.c                   |   10 +-
 drivers/target/target_core_spc.c                   |   12 +
 drivers/target/target_core_tmr.c                   |    2 +-
 drivers/target/target_core_tpg.c                   |  197 +-
 drivers/target/target_core_transport.c             |   33 +-
 drivers/target/target_core_user.c                  |    9 +-
 drivers/target/tcm_fc/tcm_fc.h                     |    1 -
 drivers/target/tcm_fc/tfc_conf.c                   |   47 +-
 drivers/target/tcm_fc/tfc_io.c                     |    8 +-
 drivers/target/tcm_fc/tfc_sess.c                   |   42 +-
 drivers/usb/gadget/Kconfig                         |   17 +
 drivers/usb/gadget/function/Makefile               |    2 +
 drivers/usb/gadget/function/f_tcm.c                | 2381 ++++++++++++++++++++
 .../{legacy/tcm_usb_gadget.h => function/tcm.h}    |    9 +-
 drivers/usb/gadget/function/u_tcm.h                |   50 +
 drivers/usb/gadget/legacy/Kconfig                  |    1 +
 drivers/usb/gadget/legacy/tcm_usb_gadget.c         | 2165 +-----------------
 fs/configfs/dir.c                                  |  150 +-
 fs/ocfs2/cluster/nodemanager.c                     |    2 +-
 include/linux/configfs.h                           |   21 +-
 include/target/target_core_base.h                  |    6 +-
 include/target/target_core_fabric.h                |    9 +-
 53 files changed, 4507 insertions(+), 2699 deletions(-)
 create mode 100644 Documentation/ABI/testing/configfs-usb-gadget-tcm
 create mode 100644 drivers/usb/gadget/function/f_tcm.c
 rename drivers/usb/gadget/{legacy/tcm_usb_gadget.h => function/tcm.h} (95%)
 create mode 100644 drivers/usb/gadget/function/u_tcm.h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
