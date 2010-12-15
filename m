From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [RFC 0/3] target: qla2xxx LLD target mode and tcm_qla2xxx fabric module
Date: Wed, 15 Dec 2010 12:33:35 -0800
Message-ID: <1292445218-15005-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Ra
Cc: Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

Attached is the initial RFC series for adding QLA2XXX LLD target mode support
against v8.03.04-k0 on .37-rc3, along a new tcm_qla2xxx.ko fabric module in
complete (eg: non incremental) form in order to add a bit more context for review.
At this point this code should be considered a 'for-39' item, and is being posted
for early review now in order to get the discussion rolling on necessary changes
required to enable target mode within the mainline qla2xxx LLD.

An overview of the current status and mini-howto is available here:

http://www.linux-iscsi.org/index.php/Qlogic

The series has been broken up into three individual patches:

This qla2xxx LLD changes in patch #1 and #2 are based on qla2x00t v8.02.01-k4 /
.26 and qla2x00t-target.ko from the SCST project, and are a modern refactoring ->
forward port of this logic to mainline qla2xxx code.

Patch #1 adds the main qla2x_target.c logic and associated headers into the
qla2xxx LLD, including the main struct qla_target_template API for interaction
with tcm_qla2xxx.

Patch #2 adds the various callbacks into struct qla_hw_data->qla2x_tmpl and
qla2x_target.c logic within qla2xxx proper.

Patch #3 adds the seperate tcm_qla2xxx fabric module using a generic configfs
control plane on modern v4 target mode code.  This module defines it's own set
of struct qla_target_template callers for interaction with qla2x_target.c ->
qla2xxx LLD code.

The LLD changes and tcm_qla2xxx should currently be considered ALPHA -> BETA
status, and thus far has been run exclusively using PCIe device passthrough
with MSI-X interrupts into KVM guest.  Large block I/O is stable, and is able
to run for sustained periods at line-rate (1000 MB/sec) in non NPIV mode.
The FC nexus handling in qla2x_target.c is stable and able to pass initial
testing (shutdown, cable pull, etc).  This also includes being able to shutdown
tcm_qla2xx and disable target mode on an individual struct qla_hw_data, and
then reload tcm_qla2xxx and recreate the configfs groups, re-enable target
mode on the same qla_hw_data and everything work as expected w/o shutting
down qla2xxx LLD.

There will be ongoing work to continue to improve and stabilize this code
for future mainline acceptance.  Code review and feedback are welcome.

Best Regards,

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  qla2xxx: Add target mode support into 2xxx series LLD code
  qla2xxx: Enable 2xxx series LLD target mode support
  tcm_qla2xxx: Add HW target mode I/O, control and TMR path code

 drivers/scsi/qla2xxx/Makefile                     |    4 +-
 drivers/scsi/qla2xxx/qla2x_target.c               | 5060 +++++++++++++++++++++
 drivers/scsi/qla2xxx/qla2x_target.h               |  290 ++
 drivers/scsi/qla2xxx/qla2x_tgt.h                  |  140 +
 drivers/scsi/qla2xxx/qla2x_tgt_def.h              |  717 +++
 drivers/scsi/qla2xxx/qla_attr.c                   |   14 +-
 drivers/scsi/qla2xxx/qla_def.h                    |   68 +-
 drivers/scsi/qla2xxx/qla_fw.h                     |   10 +
 drivers/scsi/qla2xxx/qla_gbl.h                    |   11 +
 drivers/scsi/qla2xxx/qla_gs.c                     |   14 +-
 drivers/scsi/qla2xxx/qla_init.c                   |  329 ++-
 drivers/scsi/qla2xxx/qla_iocb.c                   |  105 +-
 drivers/scsi/qla2xxx/qla_isr.c                    |  232 +-
 drivers/scsi/qla2xxx/qla_mbx.c                    |  172 +-
 drivers/scsi/qla2xxx/qla_mid.c                    |   35 +-
 drivers/scsi/qla2xxx/qla_os.c                     |  250 +-
 drivers/target/tcm_qla2xxx/Kbuild                 |    6 +
 drivers/target/tcm_qla2xxx/Kconfig                |    6 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h     |   91 +
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c | 1319 ++++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c   |  766 ++++
 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h   |   48 +
 22 files changed, 9631 insertions(+), 56 deletions(-)
 create mode 100644 drivers/scsi/qla2xxx/qla2x_target.c
 create mode 100644 drivers/scsi/qla2xxx/qla2x_target.h
 create mode 100644 drivers/scsi/qla2xxx/qla2x_tgt.h
 create mode 100644 drivers/scsi/qla2xxx/qla2x_tgt_def.h
 create mode 100644 drivers/target/tcm_qla2xxx/Kbuild
 create mode 100644 drivers/target/tcm_qla2xxx/Kconfig
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_base.h
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_configfs.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.c
 create mode 100644 drivers/target/tcm_qla2xxx/tcm_qla2xxx_fabric.h

-- 
1.7.3.3
