From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.16-rc1
Date: Thu, 12 Jun 2014 14:05:16 -0700
Message-ID: <1402607116.18202.46.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:52202 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751811AbaFLVFS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Jun 2014 17:05:18 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Stephen Rothwell <sfr@canb.auug.org.au>, Paolo Bonzini <pbonzini@redhat.com>, Quinn Tran <quinn.tran@qlogic.com>, "Michael S. Tsirkin" <mst@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, Christoph Hellwig <hch@lst.de>

Hello Linus,

Here are the target-pending updates for v3.16-rc1 code.  Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Note that you'll need to 'thread the needle' this time around, as there
are no less than four different merge conflicts / build breakages that
have been reported in linux-next (srf CC'ed) over the last weeks.

The first is with virtio-scsi between what has been merged in scsi.git
for "virtio_scsi: use cmd_size", and the "virtio-scsi: Enable DIF/DIX
modes in SCSI host LLD" below.  (Adding Paolo + hch CC')

http://marc.info/?l=linux-kernel&m=140083605208042&w=2

The second is with qla2xxx between what has been merged in scsi.git
for "qla2xxx: T10-Dif: add T10-PI support", and the "qla2xxx: Convert to
percpu_ida session tag pre-allocation" below.  (Adding Quinn CC')

http://marc.info/?l=linux-next&m=140109133803347&w=2

The third is with vhost-scsi between what has been merged in vhost.git
for "vhost: move acked_features to VQs", and the "vhost/scsi: Enable T10
PI IOV -> SGL memory mapping" below.  (Adding MST CC')
 
http://marc.info/?l=linux-next&m=140237354814532&w=2

And the last is with virtio-scsi between what has been merged in
virtio.git for "virtio_scsi: don't call virtqueue_add_sgs(... GFP_NOIO)
holding spinlock.", and the "virtio-scsi: Enable DIF/DIX modes in SCSI
host LLD" below.  (Adding Rusty CC')

http://marc.info/?l=linux-next&m=140254666208366&w=2

All the conflicts aside, the highlights this round include:

  - Add support for T10 PI pass-through between vhost-scsi + virtio-scsi
    (MST + Paolo + MKP + nab)
  - Add support for T10 PI in qla2xxx target mode (Quinn + MKP + hch + nab,
    merged through scsi.git)
  - Add support for percpu-ida pre-allocation in qla2xxx target code
    (Quinn + nab)
  - A number of iser-target fixes related to hardening the network portal
    shutdown path (Sagi + Slava)
  - Fix response length residual handling for a number of control CDBs
    (Roland + Christophe V.)
  - Various iscsi RFC conformance fixes in the CHAP authentication path
    (Tejas and Calsoft folks + nab)
  - Return TASK_SET_FULL status for tcm_fc(FCoE) DataIn + Response failures
    (Vasu + Jun + nab)
  - Fix long-standing ABORT_TASK + session reset hang (nab)
  - Convert iser-initiator + iser-target to include T10 bytes into EDTL
    (Sagi + Or + MKP + Mike Christie)
  - Fix NULL pointer dereference regression related to XCOPY introduced
    in v3.15 + CC'ed to v3.12.y (nab)

Thank you,

--nab

Christophe Vu-Brugier (4):
  target/spc: Simplify INQUIRY EVPD=0x80
  target: cleanup some boolean tests
  target/sbc: Remove sbc_check_valid_sectors()
  target/sbc: Check that the LBA and number of blocks are correct in
    VERIFY

Nicholas Bellinger (17):
  virtio-scsi.h: Add virtio_scsi_cmd_req_pi + VIRTIO_SCSI_F_T10_PI bits
  vhost/scsi: Move sanity check into vhost_scsi_map_iov_to_sgl
  vhost/scsi: Add preallocation of protection SGLs
  vhost/scsi: Add T10 PI IOV -> SGL memory mapping logic
  vhost/scsi: Enable T10 PI IOV -> SGL memory mapping
  virtio-scsi: Enable DIF/DIX modes in SCSI host LLD
  qla2xxx: Convert to percpu_ida session tag pre-allocation
  iscsi-target: Reject zero-length payloads during SecurityNegotiation
  iscsi-target: Remove no-op from iscsit_tpg_del_portal_group
  iscsi-target: Reject mutual authentication with reflected CHAP_C
  tcm_fc: Generate TASK_SET_FULL status for DataIN failures
  tcm_fc: Generate TASK_SET_FULL status for response failures
  target: Set CMD_T_ACTIVE bit for Task Management Requests
  target: Use complete_all for se_cmd->t_transport_stop_comp
  iscsi-target: Fix ABORT_TASK + connection reset iscsi_queue_req
    memory leak
  vhost-scsi: Include prot_bytes into expected data transfer length
  target: Fix NULL pointer dereference for XCOPY in target_put_sess_cmd

Roland Dreier (2):
  iscsi-target: Put length of failed allocation in error message
  target: Report correct response length for some commands

Sagi Grimberg (10):
  Target/iser: Bail from accept_np if np_thread is trying to close
  Target/iser: Fix hangs in connection teardown
  Target/iser: Improve cm events handling
  Target/iser: Wait for proper cleanup before unloading
  Target/iser: Gracefully reject T10-PI enabled connect request if not
    supported
  Target/iser: Fix a wrong dereference in case discovery session is
    over iser
  Target/iscsi: Fix sendtargets response pdu for iser transport
  scsi_cmnd: Introduce scsi_transfer_length helper
  libiscsi, iser: Adjust data_length to include protection information
  TARGET/sbc,loopback: Adjust command data length in case pi exists on
    the wire

Tejas Vaykole (1):
  iscsi-target: Fix CHAP_A parameter list handling

 drivers/infiniband/ulp/iser/iser_initiator.c   |   34 +--
 drivers/infiniband/ulp/isert/ib_isert.c        |   70 +++---
 drivers/infiniband/ulp/isert/ib_isert.h        |    2 +-
 drivers/scsi/Kconfig                           |    1 +
 drivers/scsi/libiscsi.c                        |   18 +-
 drivers/scsi/qla2xxx/qla_target.c              |  195 ++++++++++-----
 drivers/scsi/qla2xxx/qla_target.h              |    6 +
 drivers/scsi/qla2xxx/tcm_qla2xxx.c             |    6 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h             |    5 +
 drivers/scsi/virtio_scsi.c                     |   87 +++++--
 drivers/target/iscsi/iscsi_target.c            |   29 ++-
 drivers/target/iscsi/iscsi_target_auth.c       |   74 +++++-
 drivers/target/iscsi/iscsi_target_auth.h       |    1 +
 drivers/target/iscsi/iscsi_target_login.c      |    2 +-
 drivers/target/iscsi/iscsi_target_nego.c       |   12 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   14 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    8 +-
 drivers/target/iscsi/iscsi_target_tpg.h        |    1 -
 drivers/target/loopback/tcm_loop.c             |   15 +-
 drivers/target/target_core_sbc.c               |   68 ++----
 drivers/target/target_core_spc.c               |   18 +-
 drivers/target/target_core_transport.c         |   37 ++-
 drivers/target/target_core_xcopy.c             |   10 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   19 +-
 drivers/target/tcm_fc/tfc_io.c                 |   17 +-
 drivers/vhost/scsi.c                           |  308 ++++++++++++++++--------
 include/linux/virtio_scsi.h                    |   15 +-
 include/scsi/scsi_cmnd.h                       |   17 ++
 include/target/iscsi/iscsi_transport.h         |    3 +-
 include/target/target_core_backend.h           |    1 +
 30 files changed, 728 insertions(+), 365 deletions(-)

