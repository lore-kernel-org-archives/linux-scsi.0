From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: Updates for v3.2-rc1 (round one)
Date: Tue, 25 Oct 2011 02:00:36 -0700
Message-ID: <1319533236.17450.338.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@purestorage.com>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following is the first round of target updates for v3.2-rc1.  It's
available directly from kernel.org here:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git =
for-next

What can I say...?  Christoph really outdid himself this round with a
long list of cleanups culminating with the conversion to push the core
completion path out of transport_processing_thread() and into a separat=
e
target workqueue.   There are still a number of performance improvement=
s
in the works, most of which at this point will end up being v3.3 items.
Also included are a handful of bugfixes reported by various folks that
are marked for stable@kernel.org, and other various improvements +
removal of legacy code.

The bulk of this series has been posted for review in the last weeks
here:

[PATCH 00/37] target: Updates for v3.2-rc1 (round one)
http://marc.info/?l=3Dlinux-scsi&m=3D131855299419466&w=3D2

Unfortunately this code has only gotten minimal linux-next testing as
the target-pending.git tree did not return to kernel.org until last
week.  I've been able to verify it does not conflict with linux-next
from 20111014, and has been getting some testing in lio-core.git and I'=
m
content enough for an merge into v3.2-rc1.

=46or the second round of v3.2-rc1 changes, a new ib_srpt module will b=
e
merged once Roland is happy with the recent review cleanups.  There is
still some outstanding non-critical breakage with last rounds conversio=
n
to use errno.h in certain areas that still needs to be addressed, as
well as a active I/O shutdown refactoring that I=E2=80=99m also targeti=
ng for
v3.2-rc1.

Thank you,

--nab

Andy Shevchenko (3):
  target: simplify target_parse_naa_6h_vendor_specific()
  iscsi-target: use native hex2bin for chap_string_to_hex
  tcm_fc: remove custom hex_to_bin in ft_parse_wwn

Christoph Hellwig (39):
  tfm_fc: use transport_handle_cdb_direct
  iscsi-target: always call transport_handle_cdb_direct
  target: remove transport_generic_handle_cdb
  target: don't opencode transport_release_cmd in
    transport_release_fe_cmd
  target: remove transport_free_se_cmd
  target: simplify transport_generic_remove
  target: simplify transport_put_cmd
  target: remove transport_generic_remove
  target: push session reinstatement out of transport_generic_free_cmd
  target: cleanup iblock bio submission
  target: cleanup pscsi request submission
  target: remove unused se_subsystem_api methods
  target: Cleanup unused target_core_base.h bits
  target: Cleanup unused se_task bits
  target: make more use of the task_flags field in se_task
  target: Remove unnecessary se_task members
  target: pack struct se_task more tightly
  target: make the ->get_cdb method optional
  target: replace ->get_cdb with a target_get_task_cdb helper
  target: remove the ->transport_split_cdb callback in se_cmd
  target: make iblock_emulate_sync_cache asynchronous
  target: clean up the backend interface to caching parameters
  target: remove the transport_qf_callback se_cmd callback
  target: remove SCF_EMULATE_QUEUE_FULL
  target: do not pass the queue object to
    transport_remove_cmd_from_queue
  target: use transport_cmd_check_stop_to_fabric consistently
  target: fix list walking in transport_free_dev_tasks
  target: factor some duplicate code for stopping a task
  target: remove TF_TIMER_STOP
  target: stop task timers earlier
  target: move depth_left manipulation out of
    transport_generic_request_failure
  target: remove the TRANSPORT_REMOVE state
  target: remove TRANSPORT_DEFERRED_CMD state
  target: remove unused TRANSPORT_ states
  target: use a workqueue for I/O completions
  target: remove the task_sg_bidi field se_task and pSCSI BIDI support
  target: merge transport_new_cmd_obj into transport_generic_new_cmd
  target: remove transport_allocate_tasks
  target: re-use the command S/G list for single-task commands

Dan Carpenter (1):
  target: Make pscsi_create_virtdevice use ERR_CAST

Jesper Juhl (1):
  target: Remove unneeded version.h includes
Nicholas Bellinger (16):
  target: Re-org of core_tmr_lun_reset
  target: Prevent TRANSPORT_FREE_CMD_INTR processing in
    core_tmr_drain_cmd_list
  target: Fix transport_cmd_finish_abort queue removal bug
  target: Prevent transport_send_task_abort when CHECK_CONDITION status
  target: Remove session_reinstatement parameter from
    ->transport_wait_for_tasks
  target: Convert ->transport_wait_for_tasks usage to
    transport_generic_free_cmd
  iscsi-target: Remove SCF_SE_LUN_CMD flag abuses
  target: Merge transport_cmd_finish_abort_tmr into
    transport_cmd_finish_abort
  target: Remove legacy + unused device active I/O shutdown code
  loopback: Prevent uninitialized use of tl_tpg in
    tcm_loop_queuecommand
  target: Fix REPORT TARGET PORT GROUPS handling with small allocation
    length
  target: transport_subsystem_check_init cleanups
  target: Fix BIDI t_task_cdb handling in transport_generic_new_cmd
  target: Fix incorrect transport_sent usage
  target: Remove legacy se_task->task_timer and associated logic
  target: Fix compile warning w/ missing module.h include

Roland Dreier (2):
  target: Prevent cmd->se_queue_node double add
  target: Have core_tmr_alloc_req() take an explicit GFP_xxx flag

 drivers/target/Makefile                      |    1 -
 drivers/target/iscsi/iscsi_target.c          |   39 +-
 drivers/target/iscsi/iscsi_target_auth.c     |   34 +-
 drivers/target/iscsi/iscsi_target_core.h     |    4 +-
 drivers/target/iscsi/iscsi_target_erl2.c     |   49 +-
 drivers/target/iscsi/iscsi_target_tmr.c      |    6 +-
 drivers/target/iscsi/iscsi_target_util.c     |   20 +-
 drivers/target/iscsi/iscsi_target_util.h     |    1 +
 drivers/target/loopback/tcm_loop.c           |   18 +-
 drivers/target/target_core_alua.c            |   21 +-
 drivers/target/target_core_cdb.c             |   79 ++-
 drivers/target/target_core_configfs.c        |   16 +-
 drivers/target/target_core_device.c          |   70 +-
 drivers/target/target_core_fabric_configfs.c |    1 -
 drivers/target/target_core_file.c            |   56 +-
 drivers/target/target_core_file.h            |    4 +-
 drivers/target/target_core_iblock.c          |  274 ++----
 drivers/target/target_core_iblock.h          |    2 -
 drivers/target/target_core_pr.c              |    1 -
 drivers/target/target_core_pscsi.c           |  261 ++----
 drivers/target/target_core_pscsi.h           |    1 -
 drivers/target/target_core_rd.c              |   19 +-
 drivers/target/target_core_rd.h              |    2 -
 drivers/target/target_core_scdb.c            |  105 --
 drivers/target/target_core_scdb.h            |   10 -
 drivers/target/target_core_stat.c            |    1 -
 drivers/target/target_core_tmr.c             |  251 +++--
 drivers/target/target_core_transport.c       | 1477 ++++++++----------=
--------
 drivers/target/target_core_ua.c              |    1 -
 drivers/target/tcm_fc/tfc_cmd.c              |   18 +-
 drivers/target/tcm_fc/tfc_conf.c             |   13 +-
 drivers/target/tcm_fc/tfc_io.c               |    1 -
 drivers/target/tcm_fc/tfc_sess.c             |    1 -
 include/target/target_core_base.h            |   71 +-
 include/target/target_core_tmr.h             |    2 +-
 include/target/target_core_transport.h       |   75 +--
 36 files changed, 937 insertions(+), 2068 deletions(-)
 delete mode 100644 drivers/target/target_core_scdb.c
 delete mode 100644 drivers/target/target_core_scdb.h
