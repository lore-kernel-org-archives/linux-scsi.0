From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-for-4.6 0/6] target: Introduce target_alloc_session helper
Date: Sun, 10 Jan 2016 20:44:22 +0000
Message-ID: <1452458668-11034-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi folks,

As per HCH, consolidating se_session init -> lookup -> register
into a single helper has a number of benefits.

This version of the target_alloc_session() helper supports
percpu-ida tag allocation, and a (*callback)() for allowing
fabric driver code to complete internal setup before target
calls transport_register_session() to complete the operation.

That said, here's a first shot for the tree wide-conversion,
which should be considered post v4.5 material at this point,
considering it's purely a mechanical change.

Please review,

--nab

Christoph Hellwig (1):
  target: Convert demo-mode only drivers to target_alloc_session

Nicholas Bellinger (5):
  target: Add target_alloc_session() helper function
  vhost/scsi: Convert to target_alloc_session usage
  tcm_qla2xxx: Convert to target_alloc_session usage
  tcm_fc: Convert to target_alloc_session usage
  ib_srpt: Convert to target_alloc_session usage

 drivers/infiniband/ulp/srpt/ib_srpt.c  | 23 +++-----
 drivers/scsi/qla2xxx/qla_target.c      |  8 +--
 drivers/scsi/qla2xxx/qla_target.h      |  2 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c     | 79 +++++++++++++--------------
 drivers/target/loopback/tcm_loop.c     | 35 +++---------
 drivers/target/sbp/sbp_target.c        | 33 +++---------
 drivers/target/target_core_transport.c | 55 +++++++++++++++++++
 drivers/target/tcm_fc/tfc_sess.c       | 47 ++++++++--------
 drivers/usb/gadget/function/f_tcm.c    | 45 +++++-----------
 drivers/vhost/scsi.c                   | 99 ++++++++++++++--------------------
 drivers/xen/xen-scsiback.c             | 51 +++++-------------
 include/target/target_core_fabric.h    |  6 +++
 12 files changed, 218 insertions(+), 265 deletions(-)

-- 
1.9.1
