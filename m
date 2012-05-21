From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target for-next v3.5-rc1 updates + new drivers merge
 status
Date: Sun, 20 May 2012 19:22:19 -0700
Message-ID: <1337566939.32217.667.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Chad Dupuis <chad.dupuis@qlogic.com>, James Bottomley <jbottomley@parallels.com>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Chris Boot <bootc@bootc.net>, Ted Ts'o <tytso@thunk.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus & Co,

With the v3.5 merge window now officially upon us, here is the first
pull request for the current set of target pending for-next core +
existing fabric module changes for the v3.5 round..

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next

Thank you to everyone who has contributed this round.

There has been lots of work in existing code in a number of areas this
past cycle.  The major highlights have been:

*) Removal of transport_do_task_sg_chain() from core + fabrics (Roland)
*) target-core: Removal of se_task abstraction from target-core and
   enforce hw_max_sectors for pSCSI backends (hch)
*) Re-factoring of iscsi-target tx immediate/response queues (agrover)
*) Conversion of iscsi-target back to using target core memory allocati=
on
   logic (agrover)

We've had one last minute iscsi-target patch go into for-next to addres=
s
a nasty regression bug related to the target core allocation logic
conversion from agrover that is not included in friday's linux-next
build, but has been included in this series.

On the new fabric module code front for-3.5, here is a brief status
update for the three currently in flight this round:

*) usb-gadget target driver:

Sebastian Siewior's driver for supporting usb-gadget target mode
operation.  This will be going out as a separate PULL request from
target-pending/usb-target-merge with subsystem maintainer ACKs.
There is one minor target-core patch in this series required to
function.

*) sbp ieee-1394/firewire target driver:

Chris Boot's driver for supportting the Serial Block Protocol (SBP)
across IEEE-1394 Firewire hardware.  This will be going out as a
separate PULL request from target-pending/sbp-target-merge with two
additional drivers/firewire/ patches w/ subsystem maintainer ACKs.

*) qla2xxx LLD target mode infrastructure changes + tcm_qla2xxx:

The Qlogic >=3D 24xx series HW target mode LLD infrastructure patch-set
and tcm_qla2xxx fabric driver.  Support for FC target mode using qla2xx=
x
LLD code has been officially submitted by Qlogic to James below, and is
currently outstanding but not yet merged into scsi.git/for-next..

[PATCH 00/22] qla2xxx: Updates for scsi "misc" branch
http://www.spinics.net/lists/linux-scsi/msg59350.html

Note there are *zero* direct dependencies upon this for-next series for
the qla2xxx LLD target + tcm_qla2xxx patches submitted above, and over
the last days the target mode team has been tracking down an tcm_qla2xx=
x
specific active I/O shutdown bug that appears to now be almost squashed
for 3.5-rc-fixes.

Please let us know if you have any concerns,

Thanks!

--nab

Andy Grover (13):
  target/iscsi: Rename iscsi_cmd.i_list to iscsi_cmd.i_conn_node
  target/iscsi: Misc cleanups from Agrover (round 1)
  target/iscsi: Remove unneeded locking from iscsi_target_tx_thread
  target/iscsi: Refactor target_tx_thread immediate+response queue
    loops
  target/iscsi: Misc cleanups from Agrover (round 2)
  target: Rename target_allocate_tasks to target_setup_cmd_from_cdb
  target: rewrite comment for generic_new_cmd
  target/iscsi: Inline iscsit_allocate_se_cmd and *_for_tmr
  target/iscsi: Move init_se_cmd closer to lookup_cmd_lun
  target/iscsi: Eliminate iscsi_cmd.data_length
  target/iscsi: Fold _decide_list_to_build into
    _build_pdu_and_seq_lists
  target: Call core_alua_check_nonop_delay in target_submit_cmd()
  target/iscsi: Go back to core allocating data buffer for cmd

Bernhard Kohl (1):
  target: add support for the WRITE_VERIFY command

Christoph Hellwig (16):
  target: misc ramdisk backend cleanups
  target: don't limit transfer sizes for the ramdisk backend
  target: stop splitting commands into multiple tasks
  target: remove the unused transport_limit_task_sectors helper
  target: remove target_get_task_cdb
  target: remove the task_lba field in struct se_task
  target: remove the task_size field in struct se_task
  target: remove the task_sectors field in struct se_task
  target: replace ->execute_task with ->execute_cmd
  target: always allocate a single task
  target: simplify command to task linkage
  target: move the state and execute lists to the command
  target: remove struct se_task
  target: remove the t_task_cdbs_left field in struct se_cmd
  target: remove the t_task_cdbs_ex_left field in struct se_cmd
  target: remove the t_se_count field in struct se_cmd

Dan Carpenter (3):
  target/iscsi: cleanup some allocation style issues
  target: lock =3D> unlock typo in transport_lun_wait_for_tasks
  iscsi-target: remove dead code in iscsi_check_valuelist_for_support

J=C3=B6rn Engel (2):
  target: cleanup transport_execute_tasks()
  target: make target_put_session void

Nicholas Bellinger (6):
  target: Remove obsolete DF_READ_ONLY usage
  target: Enforce hw_max_sectors for SCF_SCSI_DATA_SG_IO_CDB
  target: Remove max_sectors device attribute for modern se_task less
    code
  target: Fix MAINTENANCE_IN service action CDB checks to use lower 5
    bits
  target: Add MI_REPORT_TARGET_PGS ext. header + implict_trans_secs
    attribute
  iscsi-target: Fix iov_count calculation bug in iscsit_allocate_iovecs

Roland Dreier (3):
  tcm_fc: Remove use of transport_do_task_sg_chain()
  IB/srpt: Remove use of transport_do_task_sg_chain()
  target: Remove transport_do_task_sg_chain() and associated detritus

Sebastian Andrzej Siewior (1):
  target: add unknown size flag to target_submit_cmd()

Stefan Hajnoczi (1):
  target: Handle GET_EVENT_STATUS_NOTIFICATION passthrough

mengcong (1):
  target: Handle ATA_16 passthrough for pSCSI backend devices

 drivers/infiniband/ulp/srpt/ib_srpt.c             |   10 +-
 drivers/target/iscsi/iscsi_target.c               |  821 +++++++++----=
-----
 drivers/target/iscsi/iscsi_target.h               |    3 +-
 drivers/target/iscsi/iscsi_target_configfs.c      |    2 +-
 drivers/target/iscsi/iscsi_target_core.h          |   12 +-
 drivers/target/iscsi/iscsi_target_datain_values.c |   35 +-
 drivers/target/iscsi/iscsi_target_erl0.c          |   31 +-
 drivers/target/iscsi/iscsi_target_erl1.c          |   23 +-
 drivers/target/iscsi/iscsi_target_erl2.c          |   28 +-
 drivers/target/iscsi/iscsi_target_parameters.c    |   17 -
 drivers/target/iscsi/iscsi_target_seq_pdu_list.c  |  145 ++--
 drivers/target/iscsi/iscsi_target_seq_pdu_list.h  |    2 +-
 drivers/target/iscsi/iscsi_target_tmr.c           |   15 +-
 drivers/target/iscsi/iscsi_target_util.c          |  192 +----
 drivers/target/iscsi/iscsi_target_util.h          |    3 -
 drivers/target/loopback/tcm_loop.c                |    4 +-
 drivers/target/target_core_alua.c                 |  100 ++-
 drivers/target/target_core_alua.h                 |   14 +-
 drivers/target/target_core_cdb.c                  |  118 +--
 drivers/target/target_core_configfs.c             |   25 +-
 drivers/target/target_core_device.c               |   84 +--
 drivers/target/target_core_file.c                 |  131 +--
 drivers/target/target_core_file.h                 |    4 -
 drivers/target/target_core_iblock.c               |  152 ++--
 drivers/target/target_core_iblock.h               |    1 -
 drivers/target/target_core_internal.h             |   25 +-
 drivers/target/target_core_pr.c                   |   67 +-
 drivers/target/target_core_pr.h                   |    8 +-
 drivers/target/target_core_pscsi.c                |  179 ++---
 drivers/target/target_core_pscsi.h                |    1 -
 drivers/target/target_core_rd.c                   |  168 +---
 drivers/target/target_core_rd.h                   |   20 -
 drivers/target/target_core_tmr.c                  |   71 +-
 drivers/target/target_core_tpg.c                  |    5 +-
 drivers/target/target_core_transport.c            |  994 ++++++-------=
--------
 drivers/target/tcm_fc/tfc_cmd.c                   |   18 +-
 drivers/target/tcm_fc/tfc_conf.c                  |    3 -
 drivers/target/tcm_fc/tfc_io.c                    |    2 +-
 include/target/target_core_backend.h              |   16 +-
 include/target/target_core_base.h                 |   59 +-
 include/target/target_core_fabric.h               |   11 +-
 41 files changed, 1315 insertions(+), 2304 deletions(-)
