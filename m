From: Michal Kalderon <michal.kalderon@marvell.com>
Subject: [PATCH net-next 00/10] qed*: Improve performance on 100G link for offload protocols
Date: Wed, 1 May 2019 12:57:12 +0300
Message-ID: <20190501095722.6902-1-michal.kalderon@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: michal.kalderon@marvell.com, ariel.elior@marvell.com, davem@davemloft.net
Cc: jgg@ziepe.ca, dledford@redhat.com, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This patch series modifies the current implementation of PF selection.
The refactoring of the llh code enables setting additional filters
(mac / protocol) per PF, and improves performance for offload protocols
(RoCE, iWARP, iSCSI, fcoe) on 100G link (was capped at 90G per single
PF).

Improved performance on 100G link is achieved by configuring engine
affinty to each PF.
The engine affinity is read from the Management FW and hw is configured accordingly.
A new hw resource called PPFID is exposed and an API is introduced to utilize
it. This additional resource enables setting the affinity of a PF and providing
more classification rules per PF.
qedr,qedi,qedf are also modified as part of the series. Without the
changes functionality is broken.


Chad Dupuis (1):
  qedf: Use hwfns and affin_hwfn_idx to get MSI-X vector index to use

Manish Rangankar (2):
  Revert "scsi: qedi: Allocate IRQs based on msix_cnt"
  qedi: Use hwfns and affin_hwfn_idx to get MSI-X vector index

Michal Kalderon (7):
  qed: Modify api for performing a dmae to another PF
  qed: Add llh ppfid interface and 100g support for offload protocols
  qed: Change hwfn used for sb initialization
  qed: Modify offload protocols to use the affined engine
  qedr: Change the MSI-X vectors selection to be based on affined engine
  qed: Set the doorbell address correctly
  qed*: Add iWARP 100g support

 drivers/infiniband/hw/qedr/main.c              |   34 +-
 drivers/infiniband/hw/qedr/qedr.h              |    2 +
 drivers/net/ethernet/qlogic/qed/qed.h          |   21 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c      |    5 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c    |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c      | 1275 +++++++++++++++++++-----
 drivers/net/ethernet/qlogic/qed/qed_dev_api.h  |  113 ++-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c     |   26 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h      |   16 +-
 drivers/net/ethernet/qlogic/qed/qed_hw.c       |   45 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c |   11 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c      |   12 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c    |   35 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c    |   24 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h    |    4 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c       |    6 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c      |  406 +++++---
 drivers/net/ethernet/qlogic/qed/qed_main.c     |   47 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c      |   65 ++
 drivers/net/ethernet/qlogic/qed/qed_mcp.h      |   16 +
 drivers/net/ethernet/qlogic/qed/qed_rdma.c     |   71 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h |    6 +
 drivers/net/ethernet/qlogic/qed/qed_sriov.c    |    4 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c   |    3 +-
 drivers/scsi/qedf/qedf_main.c                  |   39 +-
 drivers/scsi/qedi/qedi_main.c                  |   34 +-
 include/linux/qed/qed_if.h                     |   10 +-
 include/linux/qed/qed_rdma_if.h                |    2 +
 28 files changed, 1712 insertions(+), 622 deletions(-)

-- 
2.14.5
