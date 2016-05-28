From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.7-rc1
Date: Fri, 27 May 2016 20:11:08 -0700
Message-ID: <1464405068.22249.204.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target pending updates for v4.7-rc1.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this round include:

- Allow external PR/ALUA metadata path be defined at runtime via
  top level configfs attribute. (Lee)
- Fix target session shutdown bug for ib_srpt multi-channel. (hch)
- Make TFO close_session() and shutdown_session() optional. (hch)
- Drop se_sess->sess_kref + convert tcm_qla2xxx to internal kref. (hch)
- Add tcm_qla2xxx endpoint attribute for basic FC jammer. (Laurence)
- Refactor iscsi-target RX/TX PDU encode/decode into common code. (Varun)
- Extend iscsit_transport with xmit_pdu, release_cmd, get_rx_pdu,
  validate_parameters, and get_r2t_ttt for generic ISO offload. (Varun)
- Initial merge of cxgb iscsi-segment offload target driver. (Varun)

The bulk of the changes are Chelsio's new driver, along with a number of
iscsi-target common code improvements made by Varun + Co along the way.

Thank you,

--nab

Christoph Hellwig (7):
  target: consolidate and fix session shutdown
  target: remove acl_stop
  target: make ->shutdown_session optional
  target: make close_session optional
  tcm_qla2xxx: introduce a private sess_kref
  iscsi-target: remove usage of ->shutdown_session
  target: remove sess_kref and ->shutdown_session

Colin Ian King (1):
  target: need_to_release is always false, remove redundant check and
    kfree

Imran Haider (1):
  iscsi-target: graceful disconnect on invalid mapping to iovec

Laurence Oberman (1):
  tcm_qla2xxx Add SCSI command jammer/discard capability

Lee Duncan (2):
  target: make target db location configurable
  target: use new "dbroot" target attribute

Nicholas Bellinger (4):
  iscsi-target: Make iscsi_tpg_np driver show/store use generic code
  iscsi-target: Convert transport drivers to signal rdma_shutdown
  cxgbit: Use type ISCSI_CXGBIT + cxgbit tpg_np attribute
  iscsi-target: Fix early sk_data_ready LOGIN_FLAGS_READY race

Varun Prakash (13):
  iscsi-target: add int (*iscsit_xmit_pdu)()
  iscsi-target: add void (*iscsit_release_cmd)()
  iscsi-target: add void (*iscsit_get_rx_pdu)()
  iscsi-target: split iscsi_target_rx_thread()
  iscsi-target: add int (*iscsit_validate_params)()
  iscsi-target: add void (*iscsit_get_r2t_ttt)()
  iscsi-target: move iscsit_thread_check_cpumask()
  iscsi-target: use conn_transport->transport_type in text rsp
  iscsi-target: add new offload transport type
  iscsi-target: clear tx_thread_active
  iscsi-target: call complete on conn_logout_comp
  iscsi-target: export symbols
  cxgbit: add files for cxgbit.ko

 Documentation/scsi/tcm_qla2xxx.txt                |   22 +
 Documentation/target/tcm_mod_builder.py           |   16 -
 drivers/infiniband/ulp/isert/ib_isert.c           |   11 +
 drivers/infiniband/ulp/srpt/ib_srpt.c             |    9 -
 drivers/scsi/qla2xxx/Kconfig                      |    9 +
 drivers/scsi/qla2xxx/qla_target.c                 |   56 +-
 drivers/scsi/qla2xxx/qla_target.h                 |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c                |   59 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h                |    1 +
 drivers/target/iscsi/Kconfig                      |    2 +
 drivers/target/iscsi/Makefile                     |    1 +
 drivers/target/iscsi/cxgbit/Kconfig               |    7 +
 drivers/target/iscsi/cxgbit/Makefile              |    6 +
 drivers/target/iscsi/cxgbit/cxgbit.h              |  353 ++++
 drivers/target/iscsi/cxgbit/cxgbit_cm.c           | 2086 +++++++++++++++++++++
 drivers/target/iscsi/cxgbit/cxgbit_ddp.c          |  325 ++++
 drivers/target/iscsi/cxgbit/cxgbit_lro.h          |   72 +
 drivers/target/iscsi/cxgbit/cxgbit_main.c         |  702 +++++++
 drivers/target/iscsi/cxgbit/cxgbit_target.c       | 1561 +++++++++++++++
 drivers/target/iscsi/iscsi_target.c               |  701 +++----
 drivers/target/iscsi/iscsi_target_configfs.c      |  158 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |    1 +
 drivers/target/iscsi/iscsi_target_erl0.c          |    2 +-
 drivers/target/iscsi/iscsi_target_login.c         |   17 +-
 drivers/target/iscsi/iscsi_target_nego.c          |   19 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |    1 +
 drivers/target/iscsi/iscsi_target_util.c          |    5 +
 drivers/target/loopback/tcm_loop.c                |   12 -
 drivers/target/sbp/sbp_target.c                   |   12 -
 drivers/target/target_core_alua.c                 |    6 +-
 drivers/target/target_core_configfs.c             |   70 +-
 drivers/target/target_core_internal.h             |    6 +
 drivers/target/target_core_pr.c                   |    2 +-
 drivers/target/target_core_rd.c                   |    4 -
 drivers/target/target_core_tpg.c                  |   83 +-
 drivers/target/target_core_transport.c            |   26 +-
 drivers/target/tcm_fc/tcm_fc.h                    |    1 -
 drivers/target/tcm_fc/tfc_conf.c                  |    1 -
 drivers/target/tcm_fc/tfc_sess.c                  |   12 -
 drivers/usb/gadget/function/f_tcm.c               |   11 -
 drivers/vhost/scsi.c                              |   12 -
 drivers/xen/xen-scsiback.c                        |   11 -
 include/target/iscsi/iscsi_target_core.h          |   27 +
 include/target/iscsi/iscsi_transport.h            |   41 +
 include/target/target_core_base.h                 |    2 -
 include/target/target_core_fabric.h               |    6 -
 46 files changed, 5737 insertions(+), 814 deletions(-)
 create mode 100644 Documentation/scsi/tcm_qla2xxx.txt
 create mode 100644 drivers/target/iscsi/cxgbit/Kconfig
 create mode 100644 drivers/target/iscsi/cxgbit/Makefile
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_cm.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_ddp.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_lro.h
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_main.c
 create mode 100644 drivers/target/iscsi/cxgbit/cxgbit_target.c
