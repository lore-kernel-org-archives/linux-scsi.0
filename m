From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target core updates for v3.1-rc1 (round 1)
Date: Fri, 22 Jul 2011 02:25:33 -0700
Message-ID: <1311326733.31450.120.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49597 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753493Ab1GVJe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jul 2011 05:34:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Roland Dreier <roland@kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Hannes Reinecke <hare@suse.de>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Madhu Iyengar <nkmi@yahoo.com>, Andrew Morton <akpm@linux-foundation.org>, Dan Carpenter <error27@gmail.com>, Jesper Juhl <jj@chaosbits.net>, Stephen Rothwell <sfr@canb.auug.org.au>

Hi Linus,

This the first update for v4.1 target core development series code that
has been a WIP over the spring and summer months within the LIO upstream
tree, and contains the rebased + squashed series for a mainline v3.1-rc1
merge to re-sync drivers/target/ with the latest lio-core-2.6.git code.

This includes the significant efforts driven by Andy Grover and
Christoph Hellwig to convert target core to use native struct
scatterlist from original pre .24 SGL link logic in target core (struct
se_mem), including the complete conversion of target control CDB
emulation to use a single page SGL, and the necessary rebased bugfixes
to address the various items of breakage encountered along the way..

Note this includes target core changes required by iscsi-target v4.1
code to use a streamlined method of I/O submission for SW target fabrics
as desired for v3.1 by Christoph and Andy.  It also contains Roland's
spinlock IRQ usage fixes to address interrupt context usage with
tcm_qla2xxx HW code currently in flight for v3.2, and even includes a
full CONFIG_DYNAMIC_DEBUG conversion from Andy for drivers/target/,
along with many more general cleanups, simplifications and improvements
to reduce the mainline code by > 1500 LOC!

Please go ahead and pull from the following:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-linus-core

The 'target-pending.git/for-linus-core' branch has been made against the
following upstream HEAD:

commit 02f8c6aee8df3cdc935e9bdd4f2d020306035dbe
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Jul 21 19:17:23 2011 -0700

    Linux 3.0

Finally, I want to mention that Andy did win this round in the target
patch count rankings with a pre-squashed count of 66 patches, together
with a large number of Reviewed-by assists from Christoph.  A exceeding
large thank you everyone who has contributed, and especially to those
who have been driving v4.1 code development. 

Thank you!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Andy Grover (8):
  target: Core cleanups from AGrover (round 1)
  target: More core cleanups from AGrover (round 2)
  target: Updates from AGrover and HCH (round 3)
  target: Make all control CDBs scatter-gather
  target: Enforce 1 page max for control cdb buffer sizes
  target: Pass 2nd param of transport_split_cdb by value
  target: Eliminate usage of struct se_mem
  target: Follow up core updates from AGrover and HCH (round 4)

Andy Shevchenko (2):
  target: fix typo Assoication -> Association
  target: remove custom hex2bin() implementation

Christoph Hellwig (3):
  target: remove the always-noop ->new_cmd_failure method
  target: remove the unused SCF_* flags
  target: merge release_cmd methods

Dan Carpenter (1):
  loopback: off by one in tcm_loop_make_naa_tpg()

Fubo Chen (1):
  target: Check LUN numbers in transport_get_lun_for_[cmd,tmr]

Jesper Juhl (2):
  loopback: Remove duplicate scsi/scsi_tcq.h include
  loopback: Fix memory leak in tcm_loop_make_scsi_hba()

Nicholas Bellinger (12):
  target: use MAINTENANCE_IN and MAINTENANCE_OUT definitions in scsi.h
  target: Remove unnecessary *cdb transport_get_lun_for_cmd parameter
  target: Remove unused su_group usage in fabric register/dergister
  target: Fix WRITE_SAME_16 t_task_lba assignment bug
  target: Fix WRITE_SAME_[16,32] number of blocks=0 case
  target: Add transport_handle_cdb_direct optimization
  target: Add SCF_EMULATE_QUEUE_FULL -> transport_handle_queue_full
  target/iblock: Use request_queue->nr_request for se_device defaults
  tcm_fc: Makefile cleanups
  tcm_fc: Convert to wake_up_process and schedule_timeout_interruptible
  target: ->map_task_SG conversion to ->map_control_SG and
    ->map_data_SG
  target: Update QUEUE ALGORITHM MODIFIER control page default
  target: Bump version to v4.1.0-rc1-ml

Roland Dreier (8):
  target: Fix double test of inquiry_prod
  target: Make transport_lookup_cmd_lun() locking IRQ-safe
  target: Make se_dev_check_online() locking IRQ-safe
  target: Make se_tmr_lock IRQ-safe
  target/iblock: Remove unused iblock_dev members
  target: Allow for built-in target modules
  target: Fix reporting of supported VPD pages
  target: Implement Block Device Characteristics VPD page

 drivers/target/loopback/Kconfig              |    6 -
 drivers/target/loopback/tcm_loop.c           |  207 +-
 drivers/target/loopback/tcm_loop.h           |    6 -
 drivers/target/target_core_alua.c            |  426 ++--
 drivers/target/target_core_cdb.c             |  457 ++--
 drivers/target/target_core_configfs.c        |  667 +++---
 drivers/target/target_core_device.c          |  819 +++---
 drivers/target/target_core_fabric_configfs.c |  122 +-
 drivers/target/target_core_fabric_lib.c      |   27 +-
 drivers/target/target_core_file.c            |  149 +-
 drivers/target/target_core_file.h            |    4 -
 drivers/target/target_core_hba.c             |   37 +-
 drivers/target/target_core_iblock.c          |  199 +-
 drivers/target/target_core_iblock.h          |    9 -
 drivers/target/target_core_pr.c              |  862 ++++---
 drivers/target/target_core_pr.h              |    2 +-
 drivers/target/target_core_pscsi.c           |  316 +--
 drivers/target/target_core_pscsi.h           |    4 +-
 drivers/target/target_core_rd.c              |  483 +---
 drivers/target/target_core_rd.h              |    4 -
 drivers/target/target_core_scdb.c            |   20 +-
 drivers/target/target_core_scdb.h            |   10 +-
 drivers/target/target_core_stat.c            |  112 +-
 drivers/target/target_core_tmr.c             |  185 +-
 drivers/target/target_core_tpg.c             |  206 +-
 drivers/target/target_core_transport.c       | 3688 ++++++++++----------------
 drivers/target/target_core_ua.c              |   62 +-
 drivers/target/tcm_fc/Makefile               |   17 +-
 drivers/target/tcm_fc/tcm_fc.h               |   25 -
 drivers/target/tcm_fc/tfc_cmd.c              |  114 +-
 drivers/target/tcm_fc/tfc_conf.c             |   47 +-
 drivers/target/tcm_fc/tfc_io.c               |  130 +-
 drivers/target/tcm_fc/tfc_sess.c             |   18 +-
 include/target/target_core_base.h            |  228 +-
 include/target/target_core_device.h          |    6 +-
 include/target/target_core_fabric_ops.h      |    9 +-
 include/target/target_core_transport.h       |   43 +-
 37 files changed, 4088 insertions(+), 5638 deletions(-)


