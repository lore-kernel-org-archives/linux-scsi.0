From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.18-rc6
Date: Thu, 20 Nov 2014 21:18:57 -0800
Message-ID: <1416547137.27917.70.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending fixes queued for v3.18-rc6. Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

The highlights include:

  - target-core OOPs fix with tcm_qla2xxx + vxworks FC initiators + zero length
    SCSI commands having a transfer direction set. (Roland + Craig Watson)
  - vhost-scsi OOPs fix to explicitly prevent WWPN endpoint configfs group removal
    while qemu still has an active reference.  (Paolo + nab)
  - ib_srpt fix for RDMA hardware with lower srp_sq_size limits. (Bart)
  - Two ib_isert work-arounds for running on ocrdma hardware (Or + Sagi + Chris)
  - iscsi-target discovery portal typo + SPC-3 PR Preempt SA key matching fix (Steve)

Thank you,

--nab

Bart Van Assche (1):
  srp-target: Retry when QP creation fails with ENOMEM

Chris Moore (1):
  IB/isert: Adjust CQ size to HW limits

Nicholas Bellinger (1):
  vhost-scsi: Take configfs group dependency during
    VHOST_SCSI_SET_ENDPOINT

Or Gerlitz (1):
  ib_isert: Add max_send_sge=2 minimum for control PDU responses

Roland Dreier (1):
  target: Don't call TFO->write_pending if data_length == 0

Sagi Grimberg (1):
  iser-target: Handle DEVICE_REMOVAL event on network portal listener
    correctly

Steven Allen (2):
  iscsi-target: return the correct port in SendTargets
  target: return CONFLICT only when SA key unmatched

 drivers/infiniband/ulp/isert/ib_isert.c | 44 ++++++++++++++++++++++-----------
 drivers/infiniband/ulp/srpt/ib_srpt.c   |  8 ++++++
 drivers/target/iscsi/iscsi_target.c     |  2 +-
 drivers/target/target_core_pr.c         |  9 ++++---
 drivers/target/target_core_transport.c  |  2 +-
 drivers/vhost/scsi.c                    | 24 ++++++++++++++++++
 6 files changed, 69 insertions(+), 20 deletions(-)
