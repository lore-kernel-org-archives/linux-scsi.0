From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH-v2 00/15] target: Add WRITE_STRIP + READ_INSERT support
Date: Mon, 30 Mar 2015 03:28:09 +0000
Message-ID: <1427686104-14231-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Sagi Grimberg <sagig@mellanox.com>, Quinn Tran <quinn.tran@qlogic.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi MKP, Sagi, Quinn, & Co,

Here is -v2 for adding target internal WRITE_STRIP + READ_INSERT
DIX emulation using target_core_sbc.c + crct10dif.ko code.

This mode is for allowing T10-PI capable fabrics to interoperate with
backend devices that have not yet had protection support enabled.
These operations can be done internally using target DIF emulation,
or by the fabric driver's own HBA/NIC hardware offloads.

This includes initial support for tcm_loop, vhost/scsi, tcm_qla2xxx
and iscsi/iser-target using a new endpoint 'fabric_prot_type' configfs
attribute, and associated changes to allow FILEIO + IBLOCK + RAMDISK
backends to function in fabric_prot_type > 0 mode.

The v2 changes include:
  - Allow iblock + ramdisk to function with fabric_prot_type
  - Add fabric_prot_type attributes for vhost/scsi + tcm_qla2xxx +
    iscsi/iser-target
  - Add missing TARGET_PROT_ALL for tcm_qla2xxx

Please review for v4.1 code.

Thank you,

--nab

Nicholas Bellinger (15):
  target: Convert DIF emulation to use cmd->prot_type
  target: Add protected fabric + unprotected device support
  target: Update SPC/SBC emulation for sess_prot_type
  target: Move cmd->prot_op check into target_check_write_prot
  target: Add internal WRITE_STRIP support
  target: Move cmd->prot_op check into target_check_read_prot
  target: Add internal READ_INSERT support
  target/file: Add checks for backend DIF emulation
  target/iblock: Add checks for backend DIF emulation
  target/rd: Add checks for backend DIF emulation
  loopback: Add fabric_prot_type attribute support
  vhost/scsi: Add fabric_prot_type attribute support
  tcm_qla2xxx: Set TARGET_PROT_ALL for sup_prot_ops
  tcm_qla2xxx: Add fabric_prot_type attribute support
  iscsi/iser-target: Add fabric_prot_type attribute support

 drivers/scsi/qla2xxx/tcm_qla2xxx.c           | 46 +++++++++++++++-
 drivers/scsi/qla2xxx/tcm_qla2xxx.h           |  1 +
 drivers/target/iscsi/iscsi_target_configfs.c | 22 ++++++++
 drivers/target/iscsi/iscsi_target_tpg.c      | 19 +++++++
 drivers/target/iscsi/iscsi_target_tpg.h      |  1 +
 drivers/target/loopback/tcm_loop.c           | 54 +++++++++++++++++-
 drivers/target/loopback/tcm_loop.h           |  1 +
 drivers/target/target_core_file.c            |  8 +--
 drivers/target/target_core_iblock.c          |  2 +-
 drivers/target/target_core_rd.c              |  6 +-
 drivers/target/target_core_sbc.c             | 73 ++++++++++++++++++-------
 drivers/target/target_core_spc.c             | 14 +++--
 drivers/target/target_core_transport.c       | 82 ++++++++++++++++++++++------
 drivers/vhost/scsi.c                         | 52 +++++++++++++++++-
 include/target/iscsi/iscsi_target_core.h     |  2 +
 include/target/target_core_base.h            |  1 +
 include/target/target_core_fabric.h          |  8 +++
 17 files changed, 340 insertions(+), 52 deletions(-)

-- 
1.9.1
