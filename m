From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.3-rc1
Date: Fri, 11 Sep 2015 14:07:56 -0700
Message-ID: <1442005676.19349.61.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

(RESENDING)

Hi Linus.

Here are the outstanding target-pending updates for v4.3-rc1 code.
Please go ahead and PULL from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

There are two small conflicts noted by SFR due to a revert in libata.git
code:

http://marc.info/?l=linux-kernel&m=143865933819312&w=2
http://marc.info/?l=linux-kernel&m=143865935919329&w=2

The resolution should be self explanatory.

Mostly bug-fixes and minor changes this round.  The fallout from the big
v4.2-rc1 RCU conversion have (thus far) been minimal.

The highlights this round include:

  - Move sense handling routines into scsi_common code (Sagi)
  - Return ABORTED_COMMAND sense key for PI errors (Sagi)
  - Add tpg_enabled_sendtargets attribute for disabled iscsi-target discovery (David)
  - Shrink target struct se_cmd by rearranging fields (Roland)
  - Drop iSCSI use of mutex around max_cmd_sn increment (Roland)
  - Replace iSCSI __kernel_sockaddr_storage with sockaddr_storage (Andy + Chris)
  - Honor fabric max_data_sg_nents I/O transfer limit (Arun + Himanshu + nab)
  - Fix EXTENDED_COPY >= v4.1 regression OOPsen (Alex + nab)

Thank you,

--nab

Alexei Potashnik (1):
  target/iscsi: Use proper SGL accessors for digest computation

Andy Grover (7):
  target/iscsi: Fix np_ip bracket issue by removing np_ip
  target/iscsi: Keep local_ip as the actual sockaddr
  target/iscsi: Replace conn->login_ip with login_sockaddr
  target/iscsi: Replace __kernel_sockaddr_storage with sockaddr_storage
  target/user: Remove unused variable
  target: Remove no-op conditional
  target/user: Fix UFLAG_UNKNOWN_OP handling

Bart Van Assche (3):
  target: Inline transport_get_sense_codes()
  target: Split transport_send_check_condition_and_sense()
  tcm_qla2xxx: Remove set-but-not-used variables

Brian Bunker (1):
  target: add support for START_STOP_UNIT SCSI opcode

Chris Zankel (2):
  target: remove unused lun_flags field from se_lun
  target: remove initiatorname field in se_acl_lun

David Disseldorp (3):
  target: check DPO/FUA usage for COMPARE AND WRITE
  iscsi-target: Add tpg_enabled_sendtargets for disabled discovery
  target: use stringify.h instead of own definition

Hannes Reinecke (2):
  tcm_loop: Remove SAS vestigies
  tcm_loop: Send I_T_NEXUS_LOSS_OCCURRED UA

Joern Engel (1):
  target: improve unsupported opcode message

Nicholas Bellinger (2):
  target/qla2xxx: Honor max_data_sg_nents I/O transfer limit
  target: Attach EXTENDED_COPY local I/O descriptors to xcopy_pt_sess

Roland Dreier (5):
  target: allow underflow/overflow for PR OUT etc. commands
  target: Remove cmd->se_ordered_id (unused except debug log lines)
  target: Shrink struct se_cmd by rearranging fields
  target: Drop iSCSI use of mutex around max_cmd_sn increment
  target: Fix max_cmd_sn increment w/o cmdsn mutex regressions

Sagi Grimberg (8):
  target: Use struct t10_pi_tuple
  scsi: Move sense handling routines to scsi_common
  target: Use scsi helpers to build the sense data correctly
  target: Return ABORTED_COMMAND sense key for PI errors
  scsi: Fix wrong additional sense length in descriptor format
  scsi: Protect against buffer possible overflow in
    scsi_set_sense_information
  target: Return descriptor format sense data in case the LU spans 64bit
    sectors
  libiscsi: Use scsi helper to set information descriptor

Sebastian Herbszt (1):
  qla2xxx: Update tcm_qla2xxx module description to 24xx+

Viresh Kumar (1):
  drivers: target: Drop unlikely before IS_ERR(_OR_NULL)

 drivers/ata/libata-scsi.c                    |   4 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |  29 +-
 drivers/scsi/libiscsi.c                      |   9 +-
 drivers/scsi/qla2xxx/Kconfig                 |   4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  13 +-
 drivers/scsi/scsi_common.c                   | 109 ++++++
 drivers/scsi/scsi_error.c                    |  99 +-----
 drivers/target/iscsi/iscsi_target.c          |  86 ++---
 drivers/target/iscsi/iscsi_target.h          |   6 +-
 drivers/target/iscsi/iscsi_target_configfs.c |  34 +-
 drivers/target/iscsi/iscsi_target_device.c   |  10 +-
 drivers/target/iscsi/iscsi_target_login.c    |  78 ++---
 drivers/target/iscsi/iscsi_target_login.h    |   4 +-
 drivers/target/iscsi/iscsi_target_nego.c     |   7 +-
 drivers/target/iscsi/iscsi_target_stat.c     |   2 +-
 drivers/target/iscsi/iscsi_target_tmr.c      |   2 +-
 drivers/target/iscsi/iscsi_target_tpg.c      |  38 +-
 drivers/target/iscsi/iscsi_target_tpg.h      |   3 +-
 drivers/target/iscsi/iscsi_target_util.c     |  39 ++-
 drivers/target/loopback/tcm_loop.c           |  22 +-
 drivers/target/target_core_device.c          |  11 +-
 drivers/target/target_core_fabric_configfs.c |   2 +-
 drivers/target/target_core_hba.c             |   5 +
 drivers/target/target_core_sbc.c             |  49 ++-
 drivers/target/target_core_spc.c             |  55 ++-
 drivers/target/target_core_tpg.c             |  17 +
 drivers/target/target_core_transport.c       | 507 ++++++++++++---------------
 drivers/target/target_core_user.c            |  14 +-
 drivers/target/target_core_xcopy.c           |   6 +-
 drivers/target/tcm_fc/tfc_cmd.c              |   2 +-
 include/scsi/scsi_common.h                   |   5 +
 include/scsi/scsi_eh.h                       |   7 +-
 include/target/iscsi/iscsi_target_core.h     |  15 +-
 include/target/iscsi/iscsi_target_stat.h     |   2 +-
 include/target/iscsi/iscsi_transport.h       |   2 +-
 include/target/target_core_backend.h         |   2 +
 include/target/target_core_base.h            |  27 +-
 include/target/target_core_fabric.h          |  14 +
 include/uapi/linux/target_core_user.h        |   4 -
 39 files changed, 678 insertions(+), 666 deletions(-)
