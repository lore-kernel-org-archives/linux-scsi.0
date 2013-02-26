From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v3.9-rc1
Date: Mon, 25 Feb 2013 17:37:29 -0800
Message-ID: <1361842649.16778.67.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Asias He <asias@redhat.com>, Roland Dreier <roland@kernel.org>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target pending updates for v3.9-rc1 code.  Please go ahead
and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The highlights in this series include:

- Improve sg_table lookup scalability in RAMDISK_MCP (martin)
- Add device attribute to expose config name for INQUIRY model (tregaron)
- Convert tcm_vhost to use lock-less list for cmd completion (asias)
- Add tcm_vhost support for multiple target's per endpoint (asias)
- Add tcm_vhost support for multiple queues per vhost (asias)
- Add missing mapped_lun bounds checking during make_mappedlun
  setup in generic fabric configfs code (jan engelhardt + nab)
- Enforce individual iscsi-target network portal export once per
  TargetName endpoint (grover + nab)
- Add WRITE_SAME w/ UNMAP=0 emulation to FILEIO backend (nab)

Things have been mostly quiet this round, with majority of the work
being done on the iser-target WIP driver + associated iscsi-target
refactoring patches currently in flight for v3.10 code.

At this point there is one patch series left outstanding from Asias to
add support for UNMAP + WRITE_SAME w/ UNMAP=1 to FILEIO awaiting
feedback from hch & Co, that will likely be included in a post v3.9-rc1
PULL request if there are no objections.

Also, there is a regression bug recently reported off-list that seems to
be effecting v3.5 and v3.6 kernels with MSFT iSCSI initiators that is
still being tracked down.  No word if this effects >= v3.7 just yet, but
if so there will likely another PULL request coming your way..

Thank you,

--nab

Asias He (6):
  tcm_vhost: Use llist for cmd completion list
  tcm_vhost: Introduce iov_num_pages
  tcm_vhost: Use iov_num_pages to calculate sgl_count
  tcm_vhost: Optimize gup in vhost_scsi_map_to_sgl
  tcm_vhost: Multi-target support
  tcm_vhost: Multi-queue support

Dan Carpenter (4):
  target: change sprintf to snprintf in transport_dump_vpd_ident
  iscsi-target: make some temporary buffers larger
  target: don't always say "ipv6" as address type
  target: don't truncate the fail intr address

Hannes Reinecke (2):
  target: Export SPC inquiry emulation
  target_core_rd: break out unterminated loop during copy

Martin Svec (1):
  target/rd: improve sg_table lookup scalability

Nicholas Bellinger (6):
  target/iblock: Use backend REQ_FLUSH hint for WriteCacheEnabled
    status
  target: Fix lookup of dynamic NodeACLs during cached demo-mode
    operation
  target: Add missing mapped_lun bounds checking during make_mappedlun
    setup
  iscsi-target: Refactor iscsit_get_np sockaddr matching into
    iscsit_check_np_match
  iscsi-target: Enforce individual network portal export once per
    TargetName
  target/file: Add WRITE_SAME w/ UNMAP=0 emulation support

Roland Dreier (6):
  target: Remove useless if statement
  target: Remove never-used TMR_FABRIC_TMR enum value
  target: Fix sense data for out-of-bounds IO operations
  target: Fix error checking for UNMAP commands
  target: Fix parameter list length checking in MODE SELECT
  target: Rename spc_get_write_same_sectors ->
    sbc_get_write_same_sectors

Tregaron Bayly (1):
  target: Add device attribute to expose config_item_name for INQUIRY
    model

 drivers/target/iscsi/iscsi_target.c            |   65 ++++---
 drivers/target/iscsi/iscsi_target.h            |    2 +
 drivers/target/iscsi/iscsi_target_parameters.c |    8 +-
 drivers/target/iscsi/iscsi_target_stat.c       |   25 ++-
 drivers/target/iscsi/iscsi_target_tpg.c        |   39 ++++
 drivers/target/target_core_configfs.c          |    4 +
 drivers/target/target_core_device.c            |   58 ++++-
 drivers/target/target_core_fabric_configfs.c   |   12 +-
 drivers/target/target_core_file.c              |  114 ++++++++++
 drivers/target/target_core_iblock.c            |   46 +++-
 drivers/target/target_core_internal.h          |    3 +-
 drivers/target/target_core_rd.c                |   18 ++-
 drivers/target/target_core_sbc.c               |    8 +-
 drivers/target/target_core_spc.c               |   42 +++-
 drivers/target/target_core_tmr.c               |   12 -
 drivers/target/target_core_tpg.c               |   10 +-
 drivers/target/target_core_transport.c         |   19 ++-
 drivers/vhost/tcm_vhost.c                      |  287 +++++++++++++-----------
 drivers/vhost/tcm_vhost.h                      |    8 +-
 include/target/target_core_backend.h           |    5 +-
 include/target/target_core_base.h              |    7 +-
 21 files changed, 563 insertions(+), 229 deletions(-)
