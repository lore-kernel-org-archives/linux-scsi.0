From: Varun Prakash <varun@chelsio.com>
Subject: [PATCH v2 00/16] Chelsio iSCSI target offload driver
Date: Sat,  9 Apr 2016 18:41:10 +0530
Message-ID: <cover.1460204441.git.varun@chelsio.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: nab@linux-iscsi.org, swise@opengridcomputing.com, kxie@chelsio.com, indranil@chelsio.com, varun@chelsio.com
List-Id: linux-scsi@vger.kernel.org

This is v2 patch series for Chelsio iSCSI target offload
driver(cxgbit.ko).

cxgbit.ko registers with iSCSI target transport and
offloads multiple CPU intensive tasks to
Chelsio T5 adapters.

T5 adapters has following offload features for
iSCSI
-TCP/IP offload
-iSCSI PDU recovery by reassembling TCP segments.
-Header and Data Digest offload.
-iSCSI segmentation offload(ISO).
-Direct Data Placement(DDP).

-v2
 - added hw offload transport type (Nicholas).
 - added PDU alloc, free, xmit callbacks (Nicholas).
 - created single patch for all cxgbit.ko files (Nicholas).
 - merged definition and usage of int (*iscsit_validate_params)()
   in a single patch (Christoph).
 - merged definition and usage of void (*iscsit_release_cmd)()
   in a single patch (Christoph).
 - renamed void (*iscsit_rx_pdu)() to void (*iscsit_get_rx_pdu)() (Sagi).  
 - added dependency on INET in Kconfig (Arnd).
 - added check for NULL sg in cxgbit_set_one_ppod() (Dan Carpenter). 

Please review.

Thanks

Varun Prakash (16):
  iscsi-target: add callback to alloc and free PDU
  iscsi-target: add int (*iscsit_xmit_pdu)()
  iscsi-target: add int (*iscsit_xmit_datain_pdu)()
  iscsi-target: add void (*iscsit_release_cmd)()
  iscsi-target: add void (*iscsit_get_rx_pdu)()
  iscsi-target: split iscsi_target_rx_thread()
  iscsi-target: add int (*iscsit_validate_params)()
  iscsi-target: add void (*iscsit_get_r2t_ttt)()
  iscsi-target: move iscsit_thread_check_cpumask()
  iscsi-target: use conn->network_transport in text rsp
  iscsi-target: add new offload transport type
  iscsi-target: clear tx_thread_active
  iscsi-target: call complete on conn_logout_comp
  iscsi-target: export symbols
  iscsi-target: fix seq_end_offset calculation
  cxgbit: add files for cxgbit.ko

 drivers/infiniband/ulp/isert/ib_isert.c           |   10 +
 drivers/target/iscsi/Kconfig                      |    2 +
 drivers/target/iscsi/Makefile                     |    1 +
 drivers/target/iscsi/cxgbit/Kconfig               |    7 +
 drivers/target/iscsi/cxgbit/Makefile              |    6 +
 drivers/target/iscsi/cxgbit/cxgbit.h              |  358 ++++
 drivers/target/iscsi/cxgbit/cxgbit_cm.c           | 2086 +++++++++++++++++++++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c          |  325 ++++
 drivers/target/iscsi/cxgbit/cxgbit_lro.h          |   72 +
 drivers/target/iscsi/cxgbit/cxgbit_main.c         |  703 +++++++
 drivers/target/iscsi/cxgbit/cxgbit_target.c       | 1601 ++++++++++++++++
 drivers/target/iscsi/iscsi_target.c               |  740 +++-----
 drivers/target/iscsi/iscsi_target_configfs.c      |   76 +
 drivers/target/iscsi/iscsi_target_datain_values.c |    1 +
 drivers/target/iscsi/iscsi_target_erl0.c          |    6 +-
 drivers/target/iscsi/iscsi_target_login.c         |   13 +-
 drivers/target/iscsi/iscsi_target_nego.c          |    1 +
 drivers/target/iscsi/iscsi_target_parameters.c    |    1 +
 drivers/target/iscsi/iscsi_target_util.c          |    5 +
 include/target/iscsi/iscsi_target_core.h          |   27 +
 include/target/iscsi/iscsi_transport.h            |   45 +
 21 files changed, 5648 insertions(+), 438 deletions(-)
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
