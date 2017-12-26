From: Tomer Tayar <Tomer.Tayar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v3 net-next 0/4] qed*: Advance to FW 8.33.1.0
Date: Tue, 26 Dec 2017 20:32:46 +0200
Message-ID: <1514313170-4403-1-git-send-email-Tomer.Tayar@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tomer Tayar <Tomer.Tayar-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This series advances all qed* drivers to use firmware 8.33.1.0 which brings
new capabilities and initial support of new HW. The changes are mostly in
qed, and include changes in the FW interface files, as well as updating the
FW initialization and debug collection code. The protocol drivers have
minor functional changes for this firmware.

Patch 1 Rearranges and refactors the FW interface files in preparation of
the new FW (no functional change).
Patch 2 Prepares the code for support of new HW (no functional change).
Patch 3 Actual utilization of the new FW.
Patch 4 Advances drivers' version.

v2->v3:
Resend the series with a fixed title in the cover letter.

v1->v2:
- Break the previous single patch into several patches.
- Fix compilation issues which were reported by krobot.

Tomer Tayar (4):
  qed*: Refactoring and rearranging FW API with no functional impact
  qed*: HSI renaming for different types of HW
  qed*: Utilize FW 8.33.1.0
  qed*: Advance drivers' version to 8.33.0.20

 drivers/infiniband/hw/qedr/main.c                  |     2 +-
 drivers/infiniband/hw/qedr/qedr_hsi_rdma.h         |   125 +-
 drivers/net/ethernet/qlogic/qed/qed.h              |    12 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.c          |    37 +-
 drivers/net/ethernet/qlogic/qed/qed_cxt.h          |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_dcbx.c         |     4 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |  1167 +-
 drivers/net/ethernet/qlogic/qed/qed_dev.c          |    15 +-
 drivers/net/ethernet/qlogic/qed/qed_fcoe.c         |    10 +-
 drivers/net/ethernet/qlogic/qed/qed_hsi.h          | 10603 ++++++++++---------
 drivers/net/ethernet/qlogic/qed/qed_hw.c           |    68 +
 drivers/net/ethernet/qlogic/qed/qed_hw.h           |     4 +
 .../net/ethernet/qlogic/qed/qed_init_fw_funcs.c    |  1091 +-
 drivers/net/ethernet/qlogic/qed/qed_init_ops.c     |    22 +-
 drivers/net/ethernet/qlogic/qed/qed_int.c          |     8 +-
 drivers/net/ethernet/qlogic/qed/qed_int.h          |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_iscsi.c        |    58 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.c        |    33 +-
 drivers/net/ethernet/qlogic/qed/qed_iwarp.h        |     3 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.c           |   118 +-
 drivers/net/ethernet/qlogic/qed/qed_l2.h           |    33 +-
 drivers/net/ethernet/qlogic/qed/qed_ll2.c          |    28 +-
 drivers/net/ethernet/qlogic/qed/qed_mcp.c          |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_rdma.c         |     2 +-
 drivers/net/ethernet/qlogic/qed/qed_reg_addr.h     |   190 +-
 drivers/net/ethernet/qlogic/qed/qed_sp_commands.c  |     8 +-
 drivers/net/ethernet/qlogic/qed/qed_spq.c          |     8 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.c        |    22 +-
 drivers/net/ethernet/qlogic/qed/qed_sriov.h        |    24 +
 drivers/net/ethernet/qlogic/qede/qede.h            |     6 +-
 drivers/net/ethernet/qlogic/qede/qede_filter.c     |    26 +-
 drivers/net/ethernet/qlogic/qede/qede_main.c       |     2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.c              |    35 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h              |     2 +-
 drivers/scsi/qedf/qedf.h                           |     4 +-
 drivers/scsi/qedf/qedf_els.c                       |     2 +-
 drivers/scsi/qedf/qedf_hsi.h                       |    68 -
 drivers/scsi/qedf/qedf_io.c                        |    35 +-
 drivers/scsi/qedf/qedf_main.c                      |    12 +-
 drivers/scsi/qedf/qedf_version.h                   |     8 +-
 drivers/scsi/qedi/qedi_debugfs.c                   |     4 +-
 drivers/scsi/qedi/qedi_fw.c                        |    59 +-
 drivers/scsi/qedi/qedi_fw_api.c                    |   139 +-
 drivers/scsi/qedi/qedi_fw_iscsi.h                  |     2 +-
 drivers/scsi/qedi/qedi_gbl.h                       |     5 +-
 drivers/scsi/qedi/qedi_iscsi.c                     |     9 +-
 drivers/scsi/qedi/qedi_iscsi.h                     |     2 +-
 drivers/scsi/qedi/qedi_main.c                      |    29 +-
 drivers/scsi/qedi/qedi_version.h                   |     8 +-
 include/linux/qed/common_hsi.h                     |  1264 ++-
 include/linux/qed/eth_common.h                     |   396 +-
 include/linux/qed/fcoe_common.h                    |   940 +-
 include/linux/qed/iscsi_common.h                   |  1585 +--
 include/linux/qed/iwarp_common.h                   |    17 +-
 include/linux/qed/qed_eth_if.h                     |    38 +-
 include/linux/qed/qed_if.h                         |    36 +-
 include/linux/qed/qed_iscsi_if.h                   |     2 -
 include/linux/qed/qed_ll2_if.h                     |     2 +-
 include/linux/qed/rdma_common.h                    |    25 +-
 include/linux/qed/roce_common.h                    |    15 +-
 include/linux/qed/storage_common.h                 |    91 +-
 include/linux/qed/tcp_common.h                     |   165 +-
 62 files changed, 10240 insertions(+), 8496 deletions(-)

-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
