From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v4 00/14] target: alloc_session w/ percpu_ida+ACK_KREF conversions
Date: Fri, 11 Mar 2016 06:29:56 +0000
Message-ID: <1457677810-2478-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Mike Christie <mchristi@redhat.com>, Sagi Grimberg <sagig@mellanox.com>, Andy Grover <agrover@redhat.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Juergen Gross <jgross@suse.com>, Andrzej Pietrasiewicz <andrzej.p@samsung.com>, Chris Boot <bootc@bootc.net>, Felipe Balbi <felipe.balbi@linux.intel.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Here is -v4 series code to add target_alloc_session() helper
support using existing percpu-ida tag pre-allocation logic,
along with a new (*callback)() for allowing fabric driver
code to finish setup ahead of transport_register_session()
I_T nexus creation completion.

This includes a tree-wide fabric driver conversion to use
target_alloc_session() + associated (*callback)() within
common code.  It updates lookback, vhost/iscsi, tcm_qla2xxx,
tcm_fc, usb-gadget, ib_srpt, sbp-target, and xen-scsiback
to use the new alloc_session callback for internal nexus
related assignments.

As per HCH, it also updates sbp-target, usb-gadget, ib_srpt
and xen-scsiback to support modern percpu_ida pre-allocation
ot se_cmd tags, along with TARGET_SCF_ACK_KREF conversions
of tcm_fc, sbp-target, usb-gadget, and xen-scsiback for
v4.6-rc1 code.

v4 changes:

  - usb-gadget: Add alloc_session callback for fabric nexus assignment
    (Andrzej Pietrasiewicz)
  - usb-gadget: Add USB_G_DEFAULT_SESSION_TAGS=128
  - usb-gadget: Fix missing percpu_ida tag memset
    (Andrzej Pietrasiewicz + nab)
  - sbp-target: Add missing percpu_ida tag memset (Chris Boot)
  - sbp-target: Drop debug from mgmt request alloc (Chris Boot)
  - loopback: Convert nexus assignments to alloc_session callback
  - usb-gadget: Convert nexus assignments to alloc_session callback
    (Andrzej Pietrasiewicz)
  - xen-scsiback: Convert nexus assignments to alloc_session callback
  - xen-scsiback: Add VSCSI_DEFAULT_SESSION_TAGS=128 
 
Thank you,

--nab

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

 drivers/infiniband/ulp/srpt/ib_srpt.c  |  76 +++------
 drivers/infiniband/ulp/srpt/ib_srpt.h  |   2 -
 drivers/scsi/qla2xxx/qla_target.c      |   8 +-
 drivers/scsi/qla2xxx/qla_target.h      |   2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     |  79 ++++-----
 drivers/target/loopback/tcm_loop.c     |  46 +++---
 drivers/target/sbp/sbp_target.c        |  95 ++++++-----
 drivers/target/target_core_transport.c |  56 +++++++
 drivers/target/tcm_fc/tfc_cmd.c        |  20 ++-
 drivers/target/tcm_fc/tfc_sess.c       |  44 +++---
 drivers/usb/gadget/function/f_tcm.c    | 193 ++++++++++------------
 drivers/usb/gadget/function/tcm.h      |   2 +
 drivers/vhost/scsi.c                   |  99 +++++-------
 drivers/xen/xen-scsiback.c             | 281 ++++++++++++++++-----------------
 include/target/target_core_fabric.h    |   6 +
 15 files changed, 504 insertions(+), 505 deletions(-)

-- 
1.9.1
