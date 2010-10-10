From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] tcm: Unify virtual subsystem plugin emulation code
Date: Sat,  9 Oct 2010 20:48:18 -0700
Message-ID: <1286682498-4821-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <bharrosh@panasas.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

This series contains patches to unify TCM virtual subsystem plugin emulation
logic into generic TCM code, and to provide a method of emulation for control
CDBs that are emulated generically across subsystem plugin code or that may
require CDB specific context in the new struct se_subsystem_api_cdb set of
subsystem dependent CDB callers.

The first patch adds a generic function transport_emulate_control_cdb()
which is intended used by virtual subsystem plugin code.  This includes
the primary list of CDBs handled in this manner from existing IBLOCK,
FILEIO and RAMDISK *_emulate_scsi_cdb() subsystem dependent code, and the
struct se_subsystem_api_cdb define described above.

Thse second patch converts IBLOCK, FILEIO and RAMDISK subsystem code to use
the new ->emulate_inquiry(), ->emulate_read_cap(), ->emulate_read_cap16() and
->emulate_unmap() callers their respective existing subsystem dependent logic.

The third and forth patches move WRITE_SAME_* and SYNCHRONIZE_CACHE_* CDB
emulation logic into transport_emulate_control_cdb() for these two originally
specially handled cases with IBLOCK and FILEIO subsystem code.

So far this code has been tested on TCM_Loop SCSI LUN with IBLOCK, FILEIO and
IBLOCK backstores with TPU=1, TPWS=1 and WCE=1 on v2.6.36-rc6.

Many thanks go out to Christoph for a bit of friendly prodding to finally make
this conversion happen.  Thanks hch!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  tcm: Unify subsystem plugin control CDB emulation
  tcm: Convert IBLOCK, FILEIO and RAMDISK subsystem code to
    transport_emulate_control_cdb()
  tcm: Move WRITE_SAME_* emulation into transport_emulate_control_cdb()
  tcm: Move SYNCHRONIZE_CACHE_* emulation into
    transport_emulate_control_cdb()

 drivers/target/target_core_file.c      |  163 ++++++++------------------
 drivers/target/target_core_iblock.c    |  102 +++-------------
 drivers/target/target_core_rd.c        |   91 ++-------------
 drivers/target/target_core_transport.c |  200 ++++++++++++++++++++++----------
 include/target/target_core_base.h      |    4 +-
 include/target/target_core_transport.h |   26 +++-
 6 files changed, 237 insertions(+), 349 deletions(-)
