From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.7-rc1
Date: Fri, 05 Oct 2012 18:47:40 -0700
Message-ID: <1349488060.9312.117.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <mail@hannes-reinecke.de>, "Michael S. Tsirkin" <mst@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus!

Here are the target pending updates for v3.7-rc1 code.  Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Things have been calm for the most part with no new fabric drivers in
flight for v3.7 (we're up to eight now !), so this update is primarily
focused on addressing a few long-standing items within target-core and
iscsi-target fabric code.

The highlights include:

- target: Simplify fabric sense data length handling (roland)
- qla2xxx: Fix endianness of task management response code (roland)
- target: fix truncation of mode data, support zero allocation length (paolo)
- target: Properly support zero-length commands in normal processing path
          (paolo)
- iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT
                PDU (ronnie + nab)
- iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG demo-mode
                (ronnie + nab)
- target/file: Re-enable optional fd_buffered_io=1 operation (nab + hch)
- iscsi-target: Add MaxXmitDataSegmenthLength forr target -> initiator
                MDRSL declaration (nab)
- target: Add target_submit_cmd_map_sgls for SGL fabric memory
                 passthrough (nab + hch)
- tcm_loop: Convert I/O path to use target_submit_cmd_map_sgls (hch + nab)
- tcm_vhost: Convert I/O path to use target_submit_cmd_map_sgls (nab + hch)

The last series for adding a new target_submit_cmd_map_sgls() fabric
caller (as requested by hch) that accepts pre-allocated SGL memory
(using existing logic), along with converting tcm_loop + tcm_vhost has
only been in -next for the last days, but has gotten enough review
+testing and is clear enough a mechanical change that I think it's
reasonable to merge for -rc1 code.

Thanks again to everyone who contributed this round!  Extra special
thanks to Roland (PureStorage) for tracking down the qla2xxx target TMR
response code endian issue, and to Paolo (Redhat) for resolving the long
standing zero-length CDB issues within target-core between virtual and
pSCSI backends.

Thank you,

--nab

Andy Grover (3):
  target: Remove request_module for target_core_stgt
  target: Cleanup transport_subsystem_check_init
  target/sbp: Remove strict param from sbp_parse_wwn

Christoph Hellwig (5):
  iscsit: mark various functions static
  iscsit: remove incorrect unlock in iscsit_build_sendtargets_resp
  iscsit: add missing endianess conversion in iscsit_check_inaddr_any
  iscsit: use the itt_t abstract type
  iscsit: proper endianess conversions

Dan Carpenter (3):
  target/usb-gadget: remove duplicate initialization
  target/usb-gadget: strlen() doesn't count the terminator
  target/iscsi: precedence bug in iscsit_set_dataout_sequence_values()

Masanari Iida (1):
  target: Fix minor spelling typos in drivers/target

Nicholas Bellinger (16):
  target/iblock: Use match_strlcpy for Opt_udev_path string assignment
  target/rd: Allow WriteCacheEnabled=1 operation with rd_mcp backends
  target: Drop se_subsystem_api->[write_cache,fua_write]_emulated flags
  iscsi-target: Correctly set 0xffffffff field within ISCSI_OP_REJECT
    PDU
  target/file: Re-enable optional fd_buffered_io=1 operation
  iscsi-target: Add base MaxXmitDataSegmentLength code
  iscsi-target: Enable MaxXmitDataSegmentLength operation in login path
  iscsi-target: Convert incoming PDU payload checks to
    MaxXmitDataSegmentLength
  iscsi-target: Add MaxXmitDataSegmentLength connection recovery check
  iscsi-target: Change iscsi_target_seq_pdu_list.c to honor
    MaxXmitDataSegmentLength
  iscsi-target: Add explicit set of cache_dynamic_acls=1 for TPG
    demo-mode
  target: Add target_submit_cmd_map_sgls for SGL fabric memory
    passthrough
  tcm_loop: Convert I/O path to use target_submit_cmd_map_sgls
  target: Add control CDB READ payload zero work-around
  tcm_vhost: Convert I/O path to use target_submit_cmd_map_sgls
  iscsi-target: Bump defaults for nopin_timeout +
    nopin_response_timeout values

Paolo Bonzini (5):
  target: support zero allocation length in INQUIRY
  target: fix truncation of mode data, support zero allocation length
  target: support zero allocation length in SBC commands
  target: do not submit a zero-bio I/O request
  target: go through normal processing for all zero-length commands

Peter Senna Tschudin (1):
  target: fix return code in target_core_init_configfs error path

Roland Dreier (4):
  target: Remove unused target_core_fabric_ops.get_fabric_sense_len
    method
  target: Simplify fabric sense data length handling
  target/iscsi: Don't log "iSCSI Login negotiation failed." twice
  qla2xxx: Fix endianness of task management response code

Wei Yongjun (6):
  tcm_fc: remove unused including <generated/utsrelease.h>
  target: remove unused including <generated/utsrelease.h>
  target: use list_move_tail instead of list_del/list_add_tail
  tcm_fc: move the dereference below the NULL test
  target: move the dereference below the NULL test
  sbp-target: fix return value check in sbp_register_configfs()

 Documentation/target/tcm_mod_builder.py          |   16 --
 drivers/infiniband/ulp/srpt/ib_srpt.c            |   12 -
 drivers/scsi/qla2xxx/qla_target.c                |    2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c               |   15 --
 drivers/target/iscsi/iscsi_target.c              |  196 ++++++++---------
 drivers/target/iscsi/iscsi_target.h              |    5 +
 drivers/target/iscsi/iscsi_target_configfs.c     |   42 +---
 drivers/target/iscsi/iscsi_target_core.h         |   15 +-
 drivers/target/iscsi/iscsi_target_erl0.c         |   94 ++++----
 drivers/target/iscsi/iscsi_target_erl1.c         |    4 +-
 drivers/target/iscsi/iscsi_target_erl1.h         |    4 +-
 drivers/target/iscsi/iscsi_target_erl2.c         |    9 +-
 drivers/target/iscsi/iscsi_target_erl2.h         |    2 +-
 drivers/target/iscsi/iscsi_target_login.c        |   20 +--
 drivers/target/iscsi/iscsi_target_nego.c         |   31 +--
 drivers/target/iscsi/iscsi_target_parameters.c   |   71 +++++-
 drivers/target/iscsi/iscsi_target_parameters.h   |    7 +-
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c |   61 +++---
 drivers/target/iscsi/iscsi_target_tmr.c          |   31 ++-
 drivers/target/iscsi/iscsi_target_tpg.c          |   12 +
 drivers/target/iscsi/iscsi_target_tq.c           |    6 +-
 drivers/target/iscsi/iscsi_target_tq.h           |    1 -
 drivers/target/iscsi/iscsi_target_util.c         |   16 +-
 drivers/target/iscsi/iscsi_target_util.h         |    8 +-
 drivers/target/loopback/tcm_loop.c               |   74 +------
 drivers/target/sbp/sbp_target.c                  |   27 +--
 drivers/target/target_core_alua.c                |    2 +-
 drivers/target/target_core_configfs.c            |   18 +-
 drivers/target/target_core_device.c              |   16 +-
 drivers/target/target_core_fabric_configfs.c     |    1 -
 drivers/target/target_core_fabric_lib.c          |    8 +-
 drivers/target/target_core_file.c                |   43 +++-
 drivers/target/target_core_file.h                |    1 +
 drivers/target/target_core_iblock.c              |   17 +-
 drivers/target/target_core_pr.c                  |   14 +-
 drivers/target/target_core_pscsi.c               |    2 +-
 drivers/target/target_core_sbc.c                 |   23 ++-
 drivers/target/target_core_spc.c                 |   48 +---
 drivers/target/target_core_stat.c                |    1 -
 drivers/target/target_core_tpg.c                 |    2 +-
 drivers/target/target_core_transport.c           |  268 ++++++++++++---------
 drivers/target/tcm_fc/tfc_cmd.c                  |    1 -
 drivers/target/tcm_fc/tfc_conf.c                 |   12 -
 drivers/target/tcm_fc/tfc_io.c                   |    4 +-
 drivers/target/tcm_fc/tfc_sess.c                 |    1 -
 drivers/usb/gadget/tcm_usb_gadget.c              |   15 +--
 drivers/vhost/tcm_vhost.c                        |   81 ++------
 drivers/vhost/tcm_vhost.h                        |    8 +
 include/target/target_core_backend.h             |    3 -
 include/target/target_core_fabric.h              |    5 +-
 50 files changed, 640 insertions(+), 735 deletions(-)
