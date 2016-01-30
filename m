From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v3 00/14] target_alloc_session w/ percpu_ida+ACK_KREF conversion
Date: Sat, 30 Jan 2016 07:05:44 +0000
Message-ID: <1454137558-30396-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

Here is -v3 series code for target_alloc_session() helper
support using existing percpu-ida tag pre-allocation, along
with a new (*callback)() for allowing fabric driver code
setup to complete ahead of transport_register_session()
completing I_T nexus setup.

This includes a tree-wide fabric driver conversion to use
use target_alloc_session() + associated (*callback)() with
common code.  It updates vhost/iscsi and tcm_qla2xxx code
to use the new callback to finish their internal driver
setup for se_session.

As per HCH, it also contains sbp-target, usb-gadget/tcm,
xen-scsiback, tcm_fc and ib_srpt driver percpu_ida tag
pre-allocation conversions, along with TARGET_SCF_ACK_KREF
changes for v4.6-rc code.

Please review.

--nab

v3 changes:

  - Add xen-scsiback wrapper for handling pending_req tag failure
  - Add tcm_fc conversion to TARGET_SCF_ACK_KREF
  - Add ib_srpt conversion to percpu_ida tag allocation

Christoph Hellwig (1):
  target: Convert demo-mode only drivers to target_alloc_session

Nicholas Bellinger (13):
  target: Add target_alloc_session() helper function
  vhost/scsi: Convert to target_alloc_session usage
  tcm_qla2xxx: Convert to target_alloc_session usage
  tcm_fc: Convert to target_alloc_session usage
  ib_srpt: Convert to target_alloc_session usage
  sbp-target: Conversion to percpu_ida tag pre-allocation
  sbp-target: Convert to TARGET_SCF_ACK_KREF I/O krefs
  usb-gadget/tcm: Conversion to percpu_ida tag pre-allocation
  usb-gadget/tcm: Convert to TARGET_SCF_ACK_KREF I/O krefs
  xen-scsiback: Convert to percpu_ida tag allocation
  xen-scsiback: Convert to TARGET_SCF_ACK_KREF I/O krefs
  tcm_fc: Convert to TARGET_SCF_ACK_KREF I/O + TMR krefs
  ib_srpt: Convert to percpu_ida tag allocation

 drivers/infiniband/ulp/srpt/ib_srpt.c  |  76 +++-------
 drivers/infiniband/ulp/srpt/ib_srpt.h  |   2 -
 drivers/scsi/qla2xxx/qla_target.c      |   8 +-
 drivers/scsi/qla2xxx/qla_target.h      |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  79 +++++-----
 drivers/target/loopback/tcm_loop.c     |  35 +----
 drivers/target/sbp/sbp_target.c        |  97 ++++++------
 drivers/target/target_core_transport.c |  56 +++++++
 drivers/target/tcm_fc/tfc_cmd.c        |  15 +-
 drivers/target/tcm_fc/tfc_sess.c       |  44 +++---
 drivers/usb/gadget/function/f_tcm.c    | 181 ++++++++++------------
 drivers/vhost/scsi.c                   |  99 +++++-------
 drivers/xen/xen-scsiback.c             | 265 ++++++++++++++++-----------------
 include/target/target_core_fabric.h    |   6 +
 14 files changed, 467 insertions(+), 498 deletions(-)

-- 
1.9.1
