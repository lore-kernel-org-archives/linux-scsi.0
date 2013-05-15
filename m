From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target fixes for v3.10-rc2
Date: Wed, 15 May 2013 14:50:07 -0700
Message-ID: <1368654607.6899.16.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Shlomo Pongratz <shlomop@mellanox.com>, =?ISO-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>, Chris Boot <bootc@bootc.net>
List-Id: linux-scsi@vger.kernel.org

Hi Linus,

The following are target fixes currently in the queue for v3.10-rc2.  

Please go ahead and pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git queue

A handful of fixes + minor changes this time around, along with one
important >= v3.9 regression fix for IBLOCK backends.  The highlights
include:

 - Use FD_MAX_SECTORS in FILEIO for block_device as well as files (agrover)
 - Fix processing of out-of-order CmdSNs with iSBD driver (shlomo)
 - Close long-standing target_put_sess_cmd() vs. core_tmr_abort_task() race
   with the addition of kref_put_spinlock_irqsave() (joern + greg-kh)
 - Fix IBLOCK WCE=1 + DPOFUA=1 backend WRITE regression in >= v3.9 (nab + bootc)

Note these four patches are CC'ed to stable.

Also, there is still some work left to be done on the active I/O
shutdown path in target_wait_for_sess_cmds() used by tcm_qla2xxx +
ib_isert fabrics that is still being discussed on the list, and will
hopefully be resolved soon.

Thank you,

--nab

Andy Grover (3):
  target: Remove unused struct members in se_dev_entry
  target: Use FD_MAX_SECTORS/FD_BLOCKSIZE for blockdevs using fileio
  target: Have dev/enable show if TCM device is configured

Geert Uytterhoeven (1):
  iscsi-target: Make buf param of iscsit_do_crypto_hash_buf() const
    void *

Joern Engel (2):
  target: removed unused transport_state flag
  target: close target_put_sess_cmd() vs. core_tmr_abort_task() race

Nicholas Bellinger (5):
  iscsi-target: Fix NULL pointer dereference in iscsit_send_reject
  target/rd: Add ramdisk bit for NULLIO operation
  iscsi-target: Fix typos in RDMAEXTENSIONS macro usage
  MAINTAINERS: Update target git tree URL
  target/iblock: Fix WCE=1 + DPOFUA=1 backend WRITE regression

Shlomo Pongratz (1):
  iscsi-target: Fix processing of OOO commands

 MAINTAINERS                                    |    2 +-
 drivers/target/iscsi/iscsi_target.c            |   63 ++++++++++--------------
 drivers/target/iscsi/iscsi_target_erl1.c       |    7 ++-
 drivers/target/iscsi/iscsi_target_parameters.c |    8 ++--
 drivers/target/iscsi/iscsi_target_parameters.h |    4 +-
 drivers/target/target_core_configfs.c          |   11 +++-
 drivers/target/target_core_device.c            |   14 -----
 drivers/target/target_core_file.c              |    9 +---
 drivers/target/target_core_iblock.c            |    2 +
 drivers/target/target_core_internal.h          |    1 -
 drivers/target/target_core_rd.c                |   21 +++++++-
 drivers/target/target_core_rd.h                |    1 +
 drivers/target/target_core_transport.c         |   13 ++---
 include/linux/kref.h                           |   33 ++++++++++++
 include/target/target_core_base.h              |    5 --
 15 files changed, 107 insertions(+), 87 deletions(-)

-- 
1.7.2.5
