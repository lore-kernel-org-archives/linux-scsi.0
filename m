From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: Updates for v3.3-rc1 (round 1)
Date: Tue, 10 Jan 2012 10:56:49 -0800
Message-ID: <1326221809.14089.23.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@purestorage.com>, Bart Van Assche <bvanassche@acm.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following are the v3.3-rc1 merge window updates for the target
subsystem.  The series has been in linux-next since before the holiday
break, and can be pulled directly from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next-merge

The series has been cut against the following mainline commit:

commit dc47ce90c3a822cd7c9e9339fe4d5f61dcb26b50
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Fri Dec 9 15:09:32 2011 -0800

    Linux 3.2-rc5

The main highlights include:

*) Initial merge for the SRP target (ib_srpt) fabric module (bart)
*) Restructuring of target private + public target headers (hch)
*) Addition of target_submit_cmd() for fabrics (hch + nab)
*) Conversion of tcm_fc to use target_submit_cmd() (nab)
*) Remove legacy se_device TCQ depth handling (nab)
*) Remove extra se_device->execute_task_lock is fast path (nab)
*) Set missing additional sense length field (roland)

Please let us know if you have any questions.

Thanks!

--nab

Bart Van Assche (1):
  ib_srpt: Initial SRP Target merge for v3.3-rc1

Christoph Hellwig (7):
  target: reshuffle headers
  target: header reshuffle, part2
  target: fold se_task.task_sense into task_flags
  target: remove the se_task task_error_status field
  target: make the se_task task_state_active a normal bool
  tcm_loop: bump max_sectors
  target: remove overagressive ____cacheline_aligned annoations

J=C3=B6rn Engel (3):
  target: Move core_scsi3_check_cdb_abort_and_preempt
  target: simplify target_check_cdb_and_preempt
  target: remove useless casts

Nicholas Bellinger (11):
  iscsi-target: fix chap identifier simple_strtoul usage
  Documentation/target: Fix tcm_mod_builder.py build breakage
  target: Make target_put_sess_cmd use target_release_cmd_kref
  target: Add target_submit_cmd() for process context fabric submission
  tcm_fc: Convert ft_send_work to use target_submit_cmd
  target: Remove TFO->check_release_cmd() fabric API caller
  target: Fix possible NULL pointer with __transport_execute_tasks
  target: Drop se_device TCQ queue_depth usage from I/O path
  target: Remove extra se_device->execute_task_lock access in fast path
  target: Remove __transport_execute_tasks() for each processing
    context
  target: Remove legacy device status check from
    transport_execute_tasks

Roland Dreier (2):
  target: Set response format in INQUIRY response
  target: Set additional sense length field in sense data

Sebastian Andrzej Siewior (3):
  target: use \n as a separator for configuration
  target/configs: remove trailing newline from udev_path and alias
  target: tcm_mod_builder: small fixups

 Documentation/target/tcm_mod_builder.py        |   60 +-
 drivers/infiniband/Kconfig                     |    1 +
 drivers/infiniband/Makefile                    |    1 +
 drivers/infiniband/ulp/srpt/Kconfig            |   12 +
 drivers/infiniband/ulp/srpt/Makefile           |    2 +
 drivers/infiniband/ulp/srpt/ib_dm_mad.h        |  139 +
 drivers/infiniband/ulp/srpt/ib_srpt.c          | 4073 ++++++++++++++++=
++++++++
 drivers/infiniband/ulp/srpt/ib_srpt.h          |  444 +++
 drivers/target/iscsi/iscsi_target.c            |   19 +-
 drivers/target/iscsi/iscsi_target_auth.c       |   36 +-
 drivers/target/iscsi/iscsi_target_configfs.c   |   11 +-
 drivers/target/iscsi/iscsi_target_device.c     |    3 +-
 drivers/target/iscsi/iscsi_target_erl0.c       |    2 +-
 drivers/target/iscsi/iscsi_target_erl1.c       |    2 +-
 drivers/target/iscsi/iscsi_target_erl2.c       |    2 +-
 drivers/target/iscsi/iscsi_target_login.c      |   23 +-
 drivers/target/iscsi/iscsi_target_nego.c       |    4 +-
 drivers/target/iscsi/iscsi_target_nodeattrib.c |    3 +-
 drivers/target/iscsi/iscsi_target_stat.c       |   17 +-
 drivers/target/iscsi/iscsi_target_tmr.c        |    2 +-
 drivers/target/iscsi/iscsi_target_tpg.c        |    6 +-
 drivers/target/iscsi/iscsi_target_util.c       |    8 +-
 drivers/target/loopback/tcm_loop.c             |   33 +-
 drivers/target/loopback/tcm_loop.h             |   11 +-
 drivers/target/target_core_alua.c              |    7 +-
 drivers/target/target_core_cdb.c               |   39 +-
 drivers/target/target_core_cdb.h               |   14 -
 drivers/target/target_core_configfs.c          |   34 +-
 drivers/target/target_core_device.c            |   15 +-
 drivers/target/target_core_fabric_configfs.c   |    8 +-
 drivers/target/target_core_fabric_lib.c        |   13 +-
 drivers/target/target_core_file.c              |   15 +-
 drivers/target/target_core_hba.c               |    7 +-
 drivers/target/target_core_hba.h               |    7 -
 drivers/target/target_core_iblock.c            |    7 +-
 drivers/target/target_core_internal.h          |  123 +
 drivers/target/target_core_pr.c                |   24 +-
 drivers/target/target_core_pr.h                |    2 -
 drivers/target/target_core_pscsi.c             |   20 +-
 drivers/target/target_core_rd.c                |    6 +-
 drivers/target/target_core_stat.c              |    9 +-
 drivers/target/target_core_stat.h              |    8 -
 drivers/target/target_core_tmr.c               |   36 +-
 drivers/target/target_core_tpg.c               |    9 +-
 drivers/target/target_core_transport.c         |  343 ++-
 drivers/target/target_core_ua.c                |    6 +-
 drivers/target/tcm_fc/tfc_cmd.c                |   57 +-
 drivers/target/tcm_fc/tfc_conf.c               |    6 +-
 drivers/target/tcm_fc/tfc_io.c                 |    5 +-
 drivers/target/tcm_fc/tfc_sess.c               |    5 +-
 include/target/target_core_backend.h           |   65 +
 include/target/target_core_base.h              |  169 +-
 include/target/target_core_device.h            |   63 -
 include/target/target_core_fabric.h            |  187 ++
 include/target/target_core_fabric_lib.h        |   28 -
 include/target/target_core_fabric_ops.h        |  105 -
 include/target/target_core_tmr.h               |   35 -
 include/target/target_core_tpg.h               |   35 -
 include/target/target_core_transport.h         |  287 --
 59 files changed, 5600 insertions(+), 1113 deletions(-)
 create mode 100644 drivers/infiniband/ulp/srpt/Kconfig
 create mode 100644 drivers/infiniband/ulp/srpt/Makefile
 create mode 100644 drivers/infiniband/ulp/srpt/ib_dm_mad.h
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.c
 create mode 100644 drivers/infiniband/ulp/srpt/ib_srpt.h
 delete mode 100644 drivers/target/target_core_cdb.h
 delete mode 100644 drivers/target/target_core_hba.h
 create mode 100644 drivers/target/target_core_internal.h
 delete mode 100644 drivers/target/target_core_stat.h
 create mode 100644 include/target/target_core_backend.h
 delete mode 100644 include/target/target_core_device.h
 create mode 100644 include/target/target_core_fabric.h
 delete mode 100644 include/target/target_core_fabric_lib.h
 delete mode 100644 include/target/target_core_fabric_ops.h
 delete mode 100644 include/target/target_core_tmr.h
 delete mode 100644 include/target/target_core_tpg.h
 delete mode 100644 include/target/target_core_transport.h
