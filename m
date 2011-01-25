From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL for 38-rc3]  target updates for v4.0.0-rc7
Date: Mon, 24 Jan 2011 16:14:15 -0800
Message-ID: <1295914455.24778.115.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Christoph Hellwig <hch@lst.de>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Stephen Rothwell <sfr@canb.auug.org.au>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi James and Co,

Here are the latest v4.0.0-rc7 updates for mainline drivers/target/ code
rebased against linux-2.6.git -> .38-rc2.  These individual patches have
been reviewed on linux-scsi and commited into the upstream LIO kernel
tree, so please consider pulling for .38-rc3:

   git://git.kernel.org/pub/scm/linux/kernel/git/nab/scsi-post-merge-2.6.git for-38-rc3

Also at this point, having Linus pull directly from
scsi-post-merge-2.6.git/for-38-rcX for mainline target bugfixes +
improvements may make more sense.

Linus/Andrew/James, please let me know which you prefer here.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Christoph Hellwig (2):
  target: do not include target_core_mib.h under include/target
  target: remove EXTRA_CFLAGS

Dan Carpenter (2):
  target: iblock/pscsi claim checking for NULL instead of IS_ERR
  target: fix dubious one-bit signed bitfield

Fubo Chen (3):
  target: Drop nacl->device_list_lock on
    core_update_device_list_for_node failure
  target: Reaquire hba_lock + se_port_lock during se_clear_dev_ports
    continue
  target: Minor sparse warning fixes and annotations

Jesper Juhl (1):
  target/file: Fix memory leak in fd_set_configfs_dev_params().

Nicholas Bellinger (13):
  target/iblock: Fix failed bd claim NULL pointer dereference
  target/iblock: Fix memory leak in iblock_set_configfs_dev_params
  target: Fix memory leaks in
    target_core_dev_pr_store_attr_res_aptpl_metadata
  target: Fix demo-mode MappedLUN shutdown UA/PR breakage
  target: Release left-over demo-mode NodeACLs w/
    tfo->tpg_check_demo_mode_cache()=1
  target: Convert tcm_mod_builder.py from Kbuild -> Makefile
  target: Fix tcm_mod_builder.py default EXTRA_CFLAGS
  target: Remove unnecessary tcm_mod_builder.py kbuild EXTRA_CFLAGS
  target: Call missing list_del() for demo-mode MappedLUN disable
  target: Call proc_mkdir + remove_proc_entry with NULL parameter
  target: Convert backend ->create_virtdevice() call to return ERR_PTR
  target: Remove spurious double cast from structure macro accessors
  target core v4.0.0-rc7

Roland Dreier (2):
  target: Fix memory leak on error path
  target: Remove unneeded test of se_cmd

 Documentation/target/tcm_mod_builder.py |   17 +++++------
 drivers/target/Makefile                 |    1 -
 drivers/target/target_core_configfs.c   |   44 +++++++++++++++++++++++++----
 drivers/target/target_core_device.c     |   37 +++++++++++++------------
 drivers/target/target_core_fabric_lib.c |    1 +
 drivers/target/target_core_file.c       |   26 ++++++++++++++---
 drivers/target/target_core_hba.c        |    1 +
 drivers/target/target_core_iblock.c     |   34 ++++++++++++++---------
 drivers/target/target_core_mib.c        |   20 +++++++++++++
 drivers/target/target_core_mib.h        |    7 -----
 drivers/target/target_core_pscsi.c      |   26 ++++++++++-------
 drivers/target/target_core_rd.c         |    8 +++--
 drivers/target/target_core_rd.h         |    2 -
 drivers/target/target_core_tpg.c        |   23 +++++++++++++++
 drivers/target/target_core_transport.c  |    5 +--
 include/target/target_core_base.h       |   46 +++++++++++++++++-------------
 include/target/target_core_fabric_ops.h |    2 +-
 include/target/target_core_transport.h  |    4 +++
 18 files changed, 205 insertions(+), 99 deletions(-)
