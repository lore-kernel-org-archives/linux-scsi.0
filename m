From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: pending bugfixes + cleanups for v3.2-rc5
Date: Tue,  6 Dec 2011 06:46:47 +0000
Message-ID: <1323154007-32169-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

=46rom: Nicholas Bellinger <nab@linux-iscsi.org>

Hi Linus,

This series contains outstanding bugfixes+cleanups from target-pending
that have been testing in lio-core.git on v3.1 the last number of weeks=
,
and are ready to be pulled for v3.2 rc-fixes.

This includes the following changes:

- conversion of PYX_TRANSPORT_* sense payload handling to use explict
  se_cmd->scsi_sense_reason assignment to fix a number of cases where
  incorrect sense qualifier was being returned.
- bugfix for fileio and ramdisk backend to properly walk chained SGLs
  when using pre-allocated scsi_cmnd memory with loopback LUNs.
  (Sebastian)
- bugfixes for target CDB parsing with Solaris FC clients (Roland)
- removal of unused target code (Christoph + Joern)
- drop set_user_nice() usage with processing thread context (Bart)
- make unsupported backend configfs attributes return zero (Andy)

The series is based on -rc4, and available here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
3.2-rc-fixes

An extra thanks to Sebastian for catching the backend SGL chain bug,
and to everyone else who contributed to this series.

Thanks!

--nab

Andy Grover (1):
  target: Don't return an error if disabling unsupported features

Bart Van Assche (2):
  target: Improve system responsivity during I/O
  target: Avoid compiler warnings about signed one-bit bitfields

Christoph Hellwig (6):
  target: remove the se_obj_ptr and se_orig_obj_ptr se_cmd fields
  target: remove the se_ordered_node se_cmd field
  target: remove the t_tasks_fua se_cmd field
  target: remove the t_tasks_bidi se_cmd field
  target: remove the unused t_task_pt_sgl and t_task_pt_sgl_num se_cmd
    fields
  target: remove the unused se_dev_list

J=C3=B6rn Engel (1):
  target: remove unused struct fields

Nicholas Bellinger (7):
  target: Address legacy PYX_TRANSPORT_* return code breakage
  iscsi-target: Fix sess allocation leak in iscsi_login_zero_tsih_s1
  target: Drop config_item_name usage in fabric TFO->free_wwn()
  target: Reject SCSI data overflow for fabrics using
    transport_generic_map_mem_to_cmd
  iscsi-target: Fix residual count hanlding + remove
    iscsi_cmd->residual_count
  iscsi-target: Add missing F_BIT for iscsi_tm_rsp
  iscsi-target: Fix hex2bin warn_unused compile message

Roland Dreier (4):
  target: Get rid of unused se_cmd_cache
  target: Don't return an error status for 0-length READ and WRITE
  target: Handle 0 correctly in transport_get_sectors_6()
  target: Fix page length in emulated INQUIRY VPD page 86h

Sebastian Andrzej Siewior (3):
  target/file: walk properly over sg list
  target/rd: simplify the page/offset computation
  target/rd: fix or rewrite the copy routine

Thomas Meyer (1):
  iscsi-target: Use kmemdup rather than duplicating its implementation

 drivers/target/iscsi/iscsi_target.c       |   26 ++--
 drivers/target/iscsi/iscsi_target_auth.c  |    6 +-
 drivers/target/iscsi/iscsi_target_core.h  |    3 -
 drivers/target/iscsi/iscsi_target_erl1.c  |    3 +-
 drivers/target/iscsi/iscsi_target_login.c |   13 +-
 drivers/target/iscsi/iscsi_target_nego.c  |    3 +-
 drivers/target/loopback/tcm_loop.c        |   41 +----
 drivers/target/target_core_alua.c         |   27 ++--
 drivers/target/target_core_cdb.c          |   20 ++-
 drivers/target/target_core_configfs.c     |   11 --
 drivers/target/target_core_device.c       |   30 ++--
 drivers/target/target_core_file.c         |   20 ++-
 drivers/target/target_core_iblock.c       |   16 +-
 drivers/target/target_core_pr.c           |  240 ++++++++++++++++++---=
------
 drivers/target/target_core_pscsi.c        |   28 ++-
 drivers/target/target_core_rd.c           |  258 +++++----------------=
-------
 drivers/target/target_core_tmr.c          |    4 -
 drivers/target/target_core_transport.c    |  260 ++++++++++-----------=
--------
 drivers/target/tcm_fc/tfc_cmd.c           |    2 +-
 drivers/target/tcm_fc/tfc_conf.c          |    3 +-
 include/target/target_core_base.h         |   46 +-----
 include/target/target_core_transport.h    |   24 ---
 22 files changed, 425 insertions(+), 659 deletions(-)

--=20
1.7.2.3
