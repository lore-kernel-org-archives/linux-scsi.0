From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v4.3-rc3
Date: Sat, 26 Sep 2015 15:16:01 -0700
Message-ID: <1443305761.7042.14.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the outstanding target-pending fixes for v4.3-rc3 code.

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git master

This includes a iser-target series from Jenny + Sagi @ Mellanox that
addresses the few remaining active I/O shutdown bugs, along with a patch
to support zero-copy for immediate data payloads that gives a nice
performance improvement for small block WRITEs. 

Also included are some recent >= v4.2 regression bug-fixes.  The most
notable is a RCU conversion regression for SPC-3 PR registrations, and
recent removal of obsolete RFC-3720 markers that introduced a login
regression bug with MSFT iSCSI initiators.

Thanks to everyone who has been testing + reporting bugs for v4.x.

--nab

Jenny Derzhavetz (7):
  iser-target: remove command with state ISTATE_REMOVE
  iser-target: Put the reference on commands waiting for unsol data
  iser-target: Remove unused variables
  iser-target: Remove np_ prefix from isert_np members
  iser-target: Fix pending connections handling in target stack shutdown
    sequnce
  iser-target: Change the recv buffers posting logic
  iser-target: Skip data copy if all the command data comes as immediate

Nicholas Bellinger (5):
  target: Fix PR registration + APTPL RCU conversion regression
  target: Propigate backend read-only to core_tpg_add_lun
  target: Fix target_sense_desc_format NULL pointer dereference
  target: Make TCM_WRITE_PROTECT failure honor D_SENSE bit
  iscsi-target: Avoid OFMarker + IFMarker negotiation

 drivers/infiniband/ulp/isert/ib_isert.c        | 293 ++++++++++++++++---------
 drivers/infiniband/ulp/isert/ib_isert.h        |  21 +-
 drivers/target/iscsi/iscsi_target_parameters.c |   5 +-
 drivers/target/target_core_device.c            |  45 ++--
 drivers/target/target_core_hba.c               |   2 +-
 drivers/target/target_core_iblock.c            |   2 +
 drivers/target/target_core_pr.c                |  91 ++++++--
 drivers/target/target_core_tpg.c               |   5 +-
 include/target/target_core_base.h              |   1 +
 9 files changed, 299 insertions(+), 166 deletions(-)
