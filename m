From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target: pending updates for v3.3-rc3
Date: Tue, 07 Feb 2012 10:58:04 -0800
Message-ID: <1328641084.2904.90.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following series contains pending target bug-fixes and cleanups for
v3.3-rc3 that have been addressed the past weeks in lio-core.git.

Some of the highlights include:

- Fix handling for control CDBs with data greater than PAGE_SIZE (andy)
- Use IP_FREEBIND for iscsi-target to address network portal creation
  issues with systemd (dax)
- Allow PERSISTENT RESERVE IN for non-reservation holder (marco)
- Fix iblock se_dev_attrib.unmap_granularity (marco)
- Fix unsupported WRITE_SAME sense payload handling (martin)
- Add workaround for zero-length control CDB handling (nab)
- Fix discovery with INADDR_ANY and IN6ADDR_ANY_INIT (nab)
- Fix target_submit_cmd() exception handling (nab)
- Return correct ASC for unimplemented VPD pages (roland)
- Don't zero pages used for data buffers (roland)
- Fix return code of core_tpg_.*_lun (sebastian)

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git 3.3-rc-fixes

Thanks!

--nab

Andy Grover (2):
  target: Allow control CDBs with data > 1 page
  target: Change target_submit_cmd() to return void

Christoph Hellwig (2):
  target: don't allocate bio headroom in iblock
  iblock: fix handling of large requests

Dan Carpenter (2):
  iscsi-target: make one-bit bitfields unsigned
  target: handle empty string writes in sysfs

Dax Kelson (1):
  iscsi: use IP_FREEBIND socket option

Jesper Juhl (1):
  iscsi-target: Fix up a few assignments

Marco Sanvido (3):
  target: Use correct preempted registration sense code
  target: Allow PERSISTENT RESERVE IN for non-reservation holder
  target: Fix iblock se_dev_attrib.unmap_granularity

Martin Svec (1):
  target: Fix unsupported WRITE_SAME sense payload

Nicholas Bellinger (5):
  target: Add workaround for zero-length control CDB handling
  iscsi-target: Fix reject release handling in iscsit_free_cmd()
  iscsi-target: Fix double list_add with iscsit_alloc_buffs reject
  iscsi-target: Fix discovery with INADDR_ANY and IN6ADDR_ANY_INIT
  target: Fix target_submit_cmd() exception handling

Roland Dreier (3):
  target: Correct sense key for INVALID FIELD IN {PARAMETER LIST,CDB}
  target: Return correct ASC for unimplemented VPD pages
  target: Fail INQUIRY commands with EVPD==0 but PAGE CODE!=0

Sebastian Andrzej Siewior (4):
  target: avoid multiple outputs in scsi_dump_inquiry()
  target: use save/restore lock primitive in core_dec_lacl_count()
  target: fix return code of core_tpg_.*_lun
  target: accept REQUEST_SENSE with 18bytes

Stephen Rothwell (1):
  iscsi_target: in_aton needs linux/inet.h

roland@purestorage.com (1):
  target: Don't zero pages used for data buffers

 drivers/target/iscsi/iscsi_target.c          |   39 +++++++-
 drivers/target/iscsi/iscsi_target_configfs.c |    1 +
 drivers/target/iscsi/iscsi_target_core.h     |    6 +-
 drivers/target/iscsi/iscsi_target_erl1.c     |    4 +-
 drivers/target/iscsi/iscsi_target_login.c    |   39 +++++++-
 drivers/target/iscsi/iscsi_target_util.c     |   11 +++
 drivers/target/target_core_alua.c            |    8 +-
 drivers/target/target_core_cdb.c             |   51 ++++++-----
 drivers/target/target_core_configfs.c        |   12 ++-
 drivers/target/target_core_device.c          |   28 +++---
 drivers/target/target_core_fabric_configfs.c |    4 +-
 drivers/target/target_core_iblock.c          |   11 ++-
 drivers/target/target_core_internal.h        |    2 +-
 drivers/target/target_core_pr.c              |   43 +++++-----
 drivers/target/target_core_pscsi.c           |    4 +-
 drivers/target/target_core_tpg.c             |    3 +-
 drivers/target/target_core_transport.c       |  124 +++++++++++++++++---------
 drivers/target/tcm_fc/tfc_cmd.c              |    9 +--
 include/target/target_core_backend.h         |    4 +-
 include/target/target_core_base.h            |    1 +
 include/target/target_core_fabric.h          |    2 +-
 21 files changed, 266 insertions(+), 140 deletions(-)

-- 
