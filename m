From: Varun Prakash <varun@chelsio.com>
Subject: [RFC 00/34] Chelsio iSCSI target offload driver
Date: Sun, 14 Feb 2016 23:00:35 +0530
Message-ID: <cover.1455467089.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, roland@kernel.org, davem@davemloft.net, dledford@redhat.com, swise@opengridcomputing.com, indranil@chelsio.com, kxie@chelsio.com, hariprasad@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

This RFC series is for Chelsio iSCSI target offload
driver(cxgbit.ko).

cxgbit.ko registers with iSCSI target transport
and offloads multiple CPU intensive tasks to
Chelsio T5 adapters.

Chelsio T5 adapter series has following offload
features for iSCSI -
-TCP/IP offload.
-iSCSI PDU recovery by reassembling TCP segments.
-Header and Data Digest offload.
-iSCSI segmentation offload(ISO).
-Direct Data Placement(DDP).

Please review this series.

Thanks

Varun Prakash (34):
  cxgb4: add new ULD type CXGB4_ULD_ISCSIT
  cxgb4: allocate resources for CXGB4_ULD_ISCSIT
  cxgb4: large receive offload support
  cxgb4, iw_cxgb4: move definitions to common header file
  cxgb4, iw_cxgb4, cxgb4i: remove duplicate definitions
  cxgb4, cxgb4i: move struct cpl_rx_data_ddp definition
  cxgb4: add definitions for iSCSI target ULD
  cxgb4: update struct cxgb4_lld_info definition
  cxgb4: move VLAN_NONE macro definition
  cxgb4, iw_cxgb4: move delayed ack macro definitions
  cxgb4: add iSCSI DDP page pod manager
  cxgb4: update Kconfig and Makefile
  iscsi-target: add new transport type
  iscsi-target: export symbols
  iscsi-target: export symbols from iscsi_target.c
  iscsi-target: split iscsit_send_r2t()
  iscsi-target: split iscsit_send_conn_drop_async_message()
  iscsi-target: call complete on conn_logout_comp
  iscsi-target: clear tx_thread_active
  iscsi-target: update struct iscsit_transport definition
  iscsi-target: release transport driver resources
  iscsi-target: call Rx thread function
  iscsi-target: split iscsi_target_rx_thread()
  iscsi-target: validate conn operational parameters
  iscsi-target: move iscsit_thread_check_cpumask()
  iscsi-target: fix seq_end_offset calculation
  cxgbit: add cxgbit.h
  cxgbit: add cxgbit_lro.h
  cxgbit: add cxgbit_main.c
  cxgbit: add cxgbit_cm.c
  cxgbit: add cxgbit_target.c
  cxgbit: add cxgbit_ddp.c
  cxgbit: add Kconfig and Makefile
  iscsi-target: update Kconfig and Makefile

 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h          |   99 -
 drivers/infiniband/ulp/isert/ib_isert.c            |   10 +
 drivers/net/ethernet/chelsio/Kconfig               |   11 +
 drivers/net/ethernet/chelsio/cxgb4/Makefile        |    1 +
 drivers/net/ethernet/chelsio/cxgb4/cxgb4.h         |   27 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   34 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   97 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ppm.c     |  464 +++++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ppm.h     |  310 +++
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_uld.h     |   11 +
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |    2 -
 drivers/net/ethernet/chelsio/cxgb4/l2t.h           |    2 +
 drivers/net/ethernet/chelsio/cxgb4/sge.c           |   13 +-
 drivers/net/ethernet/chelsio/cxgb4/t4_msg.h        |  217 +++
 drivers/net/ethernet/chelsio/cxgb4/t4fw_api.h      |    7 +
 drivers/scsi/cxgbi/cxgb4i/cxgb4i.h                 |   17 -
 drivers/target/iscsi/Kconfig                       |    2 +
 drivers/target/iscsi/Makefile                      |    1 +
 drivers/target/iscsi/cxgbit/Kconfig                |    7 +
 drivers/target/iscsi/cxgbit/Makefile               |    6 +
 drivers/target/iscsi/cxgbit/cxgbit.h               |  363 ++++
 drivers/target/iscsi/cxgbit/cxgbit_cm.c            | 1893 ++++++++++++++++++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c           |  374 ++++
 drivers/target/iscsi/cxgbit/cxgbit_lro.h           |   70 +
 drivers/target/iscsi/cxgbit/cxgbit_main.c          |  719 +++++++
 drivers/target/iscsi/cxgbit/cxgbit_target.c        | 2027 ++++++++++++++++++++
 drivers/target/iscsi/iscsi_target.c                |  184 +-
 drivers/target/iscsi/iscsi_target_configfs.c       |   79 +
 drivers/target/iscsi/iscsi_target_datain_values.c  |    3 +
 drivers/target/iscsi/iscsi_target_erl0.c           |    7 +-
 drivers/target/iscsi/iscsi_target_erl1.c           |    1 +
 drivers/target/iscsi/iscsi_target_login.c          |   13 +-
 drivers/target/iscsi/iscsi_target_nego.c           |    1 +
 drivers/target/iscsi/iscsi_target_parameters.c     |    1 +
 drivers/target/iscsi/iscsi_target_util.c           |    7 +
 include/target/iscsi/iscsi_target_core.h           |   27 +
 include/target/iscsi/iscsi_transport.h             |   52 +
 37 files changed, 6928 insertions(+), 231 deletions(-)
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ppm.c
 create mode 100644 drivers/net/ethernet/chelsio/cxgb4/cxgb4_ppm.h
 create mode 100644 drivers/target/iscsi/cxgbit/Kconfig
 create mode 100644 drivers/target/iscsi/cxgbit/Makefile
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_cm.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_ddp.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_lro.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_main.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_target.c

-- 
2.0.2
