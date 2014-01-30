From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.14-rc1
Date: Thu, 30 Jan 2014 11:25:48 -0800
Message-ID: <1391109948.2599.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40950 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbaA3TXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jan 2014 14:23:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>

Hi Linus!

Here are the target-pending updates for the v3.14-rc1 merge window.

Please pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights this round include:

  - Add support for SCSI Referrals (Hannes)
  - Add support for T10 DIF into target core (nab + mkp)
  - Add support for T10 DIF emulation in FILEIO + RAMDISK backends (Sagi + nab)
  - Add support for T10 DIF -> bio_integrity passthrough in IBLOCK backend (nab)
  - Prep changes to iser-target for >= v3.15 T10 DIF support (Sagi)
  - Add support for qla2xxx N_Port ID Virtualization - NPIV (Saurav + Quinn)
  - Allow percpu_ida_alloc() to receive task state bitmask (Kent)
  - Fix >= v3.12 iscsi-target session reset hung task regression (nab)
  - Fix >= v3.13 percpu_ref se_lun->lun_ref_active race (nab)
  - Fix a long-standing network portal creation race (Andy)

Just a heads up that you'll encounter two merge conflicts in
target_core_tpg.c + qla_target.c due to upstream v3.13 bugfixes.  The
resolutions are straightforward enough, but please yell if something
doesn't look right.

Also, Stephen is carrying one extra target_core_iblock.c patch to
address the immutable bio_vec changes that are currently outstanding in
Jens block PULL request.  That patch is here:

linux-next: build failure after merge of the target-updates tree
http://marc.info/?l=linux-next&m=139019553616605&w=2

Thank you,

--nab

Andy Grover (7):
  target: Remove unused ua_dev_list member in struct se_ua
  target: Allocate more room for port default groups
  target: Fix sizeof in kmalloc for some default_groups arrays
  target: Refer to u32 luns as unpacked_lun
  target: Rename core_tpg_{pre,post}_addlun for clarity
  target: Don't use void* when passing dev in core_tpg_add_lun
  target/iscsi: Fix network portal creation race

Hannes Reinecke (9):
  target_core_alua: validate ALUA state transition
  target_core_alua: Allocate ALUA metadata on demand
  target_core_alua: store old and pending ALUA state
  target_core_alua: Use workqueue for ALUA transitioning
  target_core: simplify scsi_name_len calculation
  target_core_spc: Include target device descriptor in VPD page 83
  target_core_alua: Referrals infrastructure
  target_core_alua: Referrals configfs integration
  target_core_alua: check for buffer overflow

Kent Overstreet (1):
  percpu_ida: Make percpu_ida_alloc + callers accept task state bitmask

Nicholas Bellinger (24):
  target: Convert inquiry temporary buffer to heap memory
  target: Add DIF related base definitions
  target: Add DIF CHECK_CONDITION ASC/ASCQ exception cases
  target/sbc: Add DIF setup in sbc_check_prot + sbc_parse_cdb
  target/sbc: Add DIF TYPE1+TYPE3 read/write verify emulation
  target/spc: Add protection bit to standard INQUIRY output
  target/spc: Add protection related bits to INQUIRY EVPD=0x86
  target/sbc: Add P_TYPE + PROT_EN bits to READ_CAPACITY_16
  target/spc: Expose ATO bit in control mode page
  target/configfs: Expose protection device attributes
  target: Add protection SGLs to target_submit_cmd_map_sgls
  target/iblock: Add blk_integrity + BIP passthrough support
  target/file: Add DIF protection init/format support
  target/file: Add DIF protection support to fd_execute_rw
  target/rd: Refactor rd_build_device_space + rd_release_device_space
  target/rd: Add support for protection SGL setup + release
  target/rd: Add DIF protection into rd_execute_rw
  tcm_loop: Enable DIF/DIX modes in SCSI host LLD
  qla2xxx: Fix scsi_host leak on qlt_lport_register callback failure
  qla2xxx: Configure NPIV fc_vport via tcm_qla2xxx_npiv_make_lport
  iscsi-target: Pre-allocate more tags to avoid ack starvation
  iscsi-target: Fix connection reset hang with percpu_ida_alloc
  iscsi-target: Convert gfp_t parameter to task state bitmask
  target: Fix percpu_ref_put race in transport_lun_remove_cmd

Rashika Kheria (4):
  drivers: target: Move prototype declaration of function to header
    file target_core_pr.h
  drivers: target: Mark function as static in target_core_iblock.c
  drivers: target: Mark functions as static in tcm_loop.c
  drivers: target: Mark functions and structures as static in
    tfc_conf.c

Sagi Grimberg (5):
  IB/isert: seperate connection protection domains and dma MRs
  IB/isert: Avoid frwr notation, user fastreg
  IB/isert: Move fastreg descriptor creation to a function
  IB/isert: pass scatterlist instead of cmd to fast_reg_mr routine
  target: Report bad sector in sense data for DIF errors

Saurav Kashyap (1):
  qla2xxx: Enhancements to enable NPIV support for QLOGIC ISPs with
    TCM/LIO.

 block/blk-mq-tag.c                           |    6 +-
 drivers/infiniband/ulp/isert/ib_isert.c      |  222 +++++-----
 drivers/infiniband/ulp/isert/ib_isert.h      |   10 +-
 drivers/scsi/qla2xxx/qla_attr.c              |    2 +
 drivers/scsi/qla2xxx/qla_def.h               |   12 +-
 drivers/scsi/qla2xxx/qla_target.c            |  170 ++++----
 drivers/scsi/qla2xxx/qla_target.h            |    4 +-
 drivers/scsi/qla2xxx/tcm_qla2xxx.c           |  180 ++++++---
 drivers/scsi/qla2xxx/tcm_qla2xxx.h           |    4 -
 drivers/target/Kconfig                       |    2 +
 drivers/target/iscsi/iscsi_target.c          |   48 ++-
 drivers/target/iscsi/iscsi_target_nego.c     |    2 +-
 drivers/target/iscsi/iscsi_target_util.c     |    9 +-
 drivers/target/iscsi/iscsi_target_util.h     |    2 +-
 drivers/target/loopback/tcm_loop.c           |   20 +-
 drivers/target/target_core_alua.c            |  558 +++++++++++++++++++++-----
 drivers/target/target_core_alua.h            |   15 +-
 drivers/target/target_core_configfs.c        |  194 ++++++++-
 drivers/target/target_core_device.c          |  108 ++++-
 drivers/target/target_core_fabric_configfs.c |    2 +-
 drivers/target/target_core_file.c            |  256 +++++++++++-
 drivers/target/target_core_file.h            |    9 +
 drivers/target/target_core_iblock.c          |   93 ++++-
 drivers/target/target_core_internal.h        |    8 +-
 drivers/target/target_core_pr.h              |    5 +
 drivers/target/target_core_rd.c              |  252 +++++++++---
 drivers/target/target_core_rd.h              |    4 +
 drivers/target/target_core_sbc.c             |  252 +++++++++++-
 drivers/target/target_core_spc.c             |  114 +++++-
 drivers/target/target_core_tpg.c             |   10 +-
 drivers/target/target_core_transport.c       |   95 ++++-
 drivers/target/target_core_ua.c              |    1 -
 drivers/target/target_core_xcopy.c           |    4 -
 drivers/target/tcm_fc/tfc_cmd.c              |    2 +-
 drivers/target/tcm_fc/tfc_conf.c             |    6 +-
 drivers/vhost/scsi.c                         |    4 +-
 include/linux/percpu_ida.h                   |    3 +-
 include/scsi/scsi.h                          |    1 +
 include/target/iscsi/iscsi_transport.h       |    2 +-
 include/target/target_core_backend.h         |    7 +
 include/target/target_core_base.h            |   82 +++-
 include/target/target_core_fabric.h          |    3 +-
 lib/percpu_ida.c                             |   21 +-
 43 files changed, 2300 insertions(+), 504 deletions(-)

