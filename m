From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.12-rc1
Date: Thu, 11 May 2017 11:42:55 -0700
Message-ID: <1494528175.14920.25.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

Here are the target-pending updates for v4.12-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

Things where alot more calm than previously expected.  It's primarily
fixes in various areas, with most of the new functionality centering
around TCMU backend driver work that Xiubo Li has been driving.

Here's the summary on the feature side:

  - Make T10-PI verify configurable for emulated (FILEIO + RD) backends 
    (Dmitry Monakhov)
  - Allow target-core/TCMU pass-through to use in-kernel SPC-PR logic
    (Bryant Ly + MNC)
  - Add TCMU support for growing ring buffer size (Xiubo Li + MNC)
  - Add TCMU support for global block data pool (Xiubo Li + MNC)

and on the bug-fix side:

  - Fix COMPARE_AND_WRITE non GOOD status handling for READ phase 
    failures (Gary Guo + nab)
  - Fix iscsi-target hang with explicitly changing per NodeACL
    CmdSN number depth with concurrent login driven session 
    reinstatement.  (Gary Guo + nab)
  - Fix ibmvscsis fabric driver ABORT task handling (Bryant Ly)
  - Fix target-core/FILEIO zero length handling (Bart Van Assche)

Also, there was an OOPs introduced with the WRITE_VERIFY changes that I
ended up reverting at the last minute, because as not unusual Bart and I
could not agree on the fix in time for -rc1.  Since it's specific to a
conformance test, it's been reverted for now.

There is a separate patch in the queue to address the underlying control
CDB write overflow regression in >= v4.3 separate from the WRITE_VERIFY
revert here, that will be pushed post -rc1.

Thank you,

--nab

Bart Van Assche (4):
  target: Fix VERIFY and WRITE VERIFY command parsing
  target/fileio: Fix zero-length READ and WRITE handling
  IB/srpt: Fix abort handling
  IB/srpt: Avoid that aborting a command triggers a kernel warning

Bryant G. Ly (3):
  target: Add WRITE_VERIFY_16
  target/user: PGR Support
  ibmvscsis: Do not send aborted task response

Christophe Vu-Brugier (1):
  Documentation/target: add an example script to configure an iSCSI
    target

Dmitry Monakhov (2):
  tcm_fileio: Prevent information leak for short reads
  tcm: make pi data verification configurable

Elena Reshetova (1):
  target/iblock: convert iblock_req.pending from atomic_t to refcount_t

Hannes Reinecke (2):
  target: fixup error message in
    target_tg_pt_gp_alua_access_type_store()
  target: fixup error message in target_tg_pt_gp_tg_pt_gp_id_store()

Markus Elfring (8):
  iscsi-target: Use kcalloc() in iscsit_allocate_iovecs()
  iscsi-target: Delete error messages for failed memory allocations
  iscsi-target: Improve size determinations in four functions
  target: Use kcalloc() in two functions
  target: Delete error messages for failed memory allocations
  target: Improve size determinations in two functions
  target: Use kmalloc_array() in compare_and_write_callback()
  target: Use kmalloc_array() in transport_kmap_data_sg()

Mike Christie (1):
  tcmu: fix module removal due to stuck thread

Nicholas Bellinger (4):
  target: Fix compare_and_write_callback handling for non GOOD status
  iscsi-target: Set session_fall_back_to_erl0 when forcing reinstatement
  target: Don't force session reset if queue_depth does not change
  Revert "target: Fix VERIFY and WRITE VERIFY command parsing"

Xiubo Li (3):
  tcmu: Add dynamic growing data area feature support
  tcmu: Add global data block pool support
  tcmu: Recalculate the tcmu_cmd size to save cmd area memories

Zhu Lingshan (1):
  target/pr: update PR out action code table

 Documentation/target/target-export-device    |  80 ++++
 drivers/infiniband/ulp/srpt/ib_srpt.c        |   9 +-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c     | 114 +++--
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h     |   2 +
 drivers/target/iscsi/iscsi_target.c          |  51 +--
 drivers/target/iscsi/iscsi_target_configfs.c |   1 +
 drivers/target/iscsi/iscsi_target_login.c    |   1 +
 drivers/target/target_core_configfs.c        |  54 ++-
 drivers/target/target_core_device.c          |  38 ++
 drivers/target/target_core_file.c            |  32 +-
 drivers/target/target_core_iblock.c          |  12 +-
 drivers/target/target_core_iblock.h          |   3 +-
 drivers/target/target_core_pr.c              |   2 +-
 drivers/target/target_core_pr.h              |   9 +-
 drivers/target/target_core_pscsi.c           |   3 +-
 drivers/target/target_core_rd.c              |  50 +--
 drivers/target/target_core_sbc.c             |  10 +-
 drivers/target/target_core_tpg.c             |   7 +
 drivers/target/target_core_transport.c       |   2 +-
 drivers/target/target_core_user.c            | 645 +++++++++++++++++++++------
 include/scsi/scsi_proto.h                    |   1 +
 include/target/target_core_backend.h         |   1 +
 include/target/target_core_base.h            |   1 +
 23 files changed, 859 insertions(+), 269 deletions(-)
 create mode 100755 Documentation/target/target-export-device
