From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.11-rc1
Date: Wed, 10 Jul 2013 17:07:09 -0700
Message-ID: <1373501229.7397.242.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:60159 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755188Ab3GKACF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 10 Jul 2013 20:02:05 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Michael S. Tsirkin" <mst@redhat.com>

Hello Linus!

Here are the target pending patches for the v3.11-rc1 merge window.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next

Lots of activity this round on performance improvements in target-core
while benchmarking the prototype scsi-mq initiator code with vhost-scsi
fabric ports, along with a number of iscsi/iser-target improvements and
hardening fixes for exception path cases post v3.10 merge.

The highlights include:

  - Make persistent reservations APTPL buffer allocated on-demand, and =
drop
    per t10_reservation buffer. (grover)
  - Make virtual LUN=3D0 a NULLIO device, and skip allocation of NULLIO
    device pages (grover)
  - Add transport_cmd_check_stop write_pending bit to avoid extra acces=
s
    of ->t_state_lock is WRITE I/O submission fast-path. (nab)
  - Drop unnecessary CMD_T_DEV_ACTIVE check from transport_lun_remove_c=
md
    to avoid extra access of ->t_state_lock in release fast-path. (nab)
  - Avoid extra t_state_lock access in __target_execute_cmd fast-path (=
nab)
  - Drop unnecessary vhost-scsi wait_for_tasks=3Dtrue usage + ->t_state=
_lock
    access in release fast-path. (nab)
  - Convert vhost-scsi to use modern se_cmd->cmd_kref TARGET_SCF_ACK_KR=
EF
    usage (nab)
  - Add tracepoints for SCSI commands being processed (roland)
  - Refactoring of iscsi-target handling of ISCSI_OP_NOOP + ISCSI_OP_TE=
XT
    to be transport independent (nab)
  - Add iscsi-target SendTargets=3D$IQN support for in-band discovery (=
nab)
  - Add iser-target support for in-band discovery (nab + Or)
  - Add iscsi-target demo-mode TPG authentication context support (nab)
  - Fix isert_put_reject payload buffer post (nab)
  - Fix iscsit_add_reject* usage for iser (nab)
  - Fix iscsit_sequence_cmd reject handling for iser (nab)
  - Fix ISCSI_OP_SCSI_TMFUNC handling for iser (nab)
  - Fix session reset bug with RDMA_CM_EVENT_DISCONNECTED (nab)

The last five iscsi/iser-target items are CC'ed to stable, as they do
address issues present in v3.10 code.  They are certainly larger than
I'd like for stable patch set, but are important to ensure proper REJEC=
T
exception handling in iser-target for 3.10.y.

Also just a heads up to expect a minor conflict in drivers/vhost/scsi.c
when pulling vhost-next (MST CC'ed) that has come up recently in
linux-next testing here:

http://marc.info/?l=3Dlinux-next&m=3D137331470429528&w=3D2

Thank you,

--nab

Andy Grover (13):
  target: Add register_type and preempt_type enums to clarify code
  target: Alter core_pr_dump_initiator_port for ease of use
  target: Fix two debugprints that appear to be wrong
  target: Simplify metadata handling when clearing aptpl metadata
  target: Unify __core_scsi3_update_aptpl_buf and
    core_scsi3_update_aptpl_buf
  target: Remove t10_reservation.pr_aptpl_buf_len
  target: Remove unneeded param pr_aptpl_buf_len to
    write_aptpl_to_file()
  target: Delete incorrect comment
  target: Allocate aptpl_buf inside update_and_write_aptpl()
  target: Use if/else for sa_res_key conditional in
    emulate_pro_register()
  target: Further refactoring of core_scsi3_emulate_pro_register()
  target: Make virtual_lun0 a nullio device
  target: Don't allocate pages for NULLIO devices

Dan Carpenter (1):
  iscsi-target: missing kfree() on error path

Joern Engel (2):
  target: remove unused codes from enum tcm_tmrsp_table
  target: make queue_tm_rsp() return void

J=C3=B6rn Engel (3):
  qla_target: remove qlt_check_fcport_exist
  iscsi-target: Fix tfc_tpg_nacl_auth_cit configfs length overflow
  iscsi-target: kstrtou* configfs attribute parameter cleanups

Nicholas Bellinger (29):
  target: Add transport_cmd_check_stop write_pending bit
  target: Drop unnecessary CMD_T_DEV_ACTIVE check from
    transport_lun_remove_cmd
  target: Remove legacy t_fe_count + avoid t_state_lock access in
    transport_put_cmd
  target: Avoid extra t_state_lock access in __target_execute_cmd
  target: Drop unnecessary t_state_lock access for
    SCF_SUPPORTED_SAM_OPCODE assignment
  iscsi-target: Avoid unnecessary t_state_lock during unsolicited
    data-out check
  target: Drop legacy se_cmd->check_release bit
  vhost/scsi: Drop unnecessary wait_for_tasks=3Dtrue usage with
    transport_generic_free_cmd
  vhost/scsi: Convert to se_cmd->cmd_kref TARGET_SCF_ACK_KREF usage
  iscsi/isert-target: Refactor ISCSI_OP_NOOP RX handling
  iscsi-target: Refactor ISCSI_OP_TEXT RX handling
  iscsi-target: Refactor ISCSI_OP_TEXT_RSP TX handling
  iscsi-target: Allow ->MaxXmitDataSegmentLength assignment for iser
    discovery
  iscsi-target: Move sendtargets parsing into iscsit_process_text_cmd
  iscsi-target: Add IFC_SENDTARGETS_SINGLE support
  target: Add se_portal_group->tpg_auth_group
  iscsi-target: Add demo-mode TPG authentication context support
  target: Make core_scsi3_update_and_write_aptpl return sense_reason_t
  iscsi-target: Drop left-over iscsi_conn->bad_hdr
  iser-target: Fix isert_put_reject payload buffer post
  iscsi-target: Fix iscsit_add_reject* usage for iser
  iscsi-target: Fix iscsit_sequence_cmd reject handling for iser
  iscsi-target: Fix ISCSI_OP_SCSI_TMFUNC handling for iser
  iser-target: Fix session reset bug with RDMA_CM_EVENT_DISCONNECTED
  iser-target: Add vendor_err debug output
  iser-target: Rename sense_buf_[dma,len] to pdu_[dma,len]
  iser-target: Add support for ISCSI_OP_TEXT opcode + payload handling
  iscsi-target: Fix tfc_tpg_auth_cit configfs length overflow
  iser-target: Ignore non TEXT + LOGOUT opcodes for discovery

Roland Dreier (3):
  target: Add tracepoints for SCSI commands being processed
  target: Return correct sense data for IO past the end of a device
  target: Add (obsolete) checking for PMI/LBA fields in READ
    CAPACITY(10)

 drivers/infiniband/ulp/isert/ib_isert.c        |  268 +++++++--
 drivers/infiniband/ulp/isert/ib_isert.h        |    5 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c          |   27 +-
 drivers/scsi/qla2xxx/qla_target.c              |  151 +----
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |   10 +-
 drivers/target/iscsi/iscsi_target.c            |  768 ++++++++++++----=
--------
 drivers/target/iscsi/iscsi_target.h            |    2 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |  184 +++++-
 drivers/target/iscsi/iscsi_target_core.h       |   11 +-
 drivers/target/iscsi/iscsi_target_erl0.c       |    8 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |   26 +-
 drivers/target/iscsi/iscsi_target_nego.c       |   13 +-
 drivers/target/iscsi/iscsi_target_parameters.c |    3 -
 drivers/target/iscsi/iscsi_target_util.c       |   28 +-
 drivers/target/iscsi/iscsi_target_util.h       |    3 +-
 drivers/target/loopback/tcm_loop.c             |    3 +-
 drivers/target/sbp/sbp_target.c                |    3 +-
 drivers/target/target_core_configfs.c          |   13 +-
 drivers/target/target_core_device.c            |    5 +-
 drivers/target/target_core_fabric_configfs.c   |   21 +-
 drivers/target/target_core_pr.c                |  499 ++++++---------
 drivers/target/target_core_pr.h                |    2 +-
 drivers/target/target_core_rd.c                |    5 +
 drivers/target/target_core_sbc.c               |   18 +-
 drivers/target/target_core_tmr.c               |   12 +-
 drivers/target/target_core_transport.c         |   87 ++-
 drivers/target/tcm_fc/tcm_fc.h                 |    2 +-
 drivers/target/tcm_fc/tfc_cmd.c                |    8 +-
 drivers/usb/gadget/tcm_usb_gadget.c            |    3 +-
 drivers/vhost/scsi.c                           |   37 +-
 include/target/iscsi/iscsi_transport.h         |   21 +-
 include/target/target_core_base.h              |   23 +-
 include/target/target_core_configfs.h          |    1 +
 include/target/target_core_fabric.h            |    2 +-
 include/target/target_core_fabric_configfs.h   |   11 +
 include/trace/events/target.h                  |  214 +++++++
 36 files changed, 1413 insertions(+), 1084 deletions(-)
 create mode 100644 include/trace/events/target.h

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
