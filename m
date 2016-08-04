From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [GIT PULL] target updates for v4.8-rc1
Date: Wed, 03 Aug 2016 21:34:13 -0700
Message-ID: <1470285253.7145.40.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

Hello Linus,

Here are the target-pending updates for v4.8-rc1.  Please go ahead and
pull from:

  git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next

The most notable item is IBM virtual SCSI target driver, that was
originally ported to target-core back in 2010 by Tomo-san, and has been
brought forward to v4.x code by Bryant Ly, Michael Cyr and Co. over the
last months.

Also included are two ORDERED task related bug-fixes Bryant + Michael
found along the way using ibmvscsis with AIX guests, plus a few
miscellaneous target-core + iscsi-target bug-fixes with associated
stable tags.

Thank you,

--nab

Bryant G. Ly (1):
  ibmvscsis: Initial commit of IBM VSCSI Tgt Driver

Colin Ian King (1):
  target: fix spelling mistake: "limitiation" -> "limitation"

Feng Li (1):
  iscsi-target: Fix panic when adding second TCP connection to iSCSI
    session

Hannes Reinecke (1):
  tcm_fc: set and unset FCP_SPPF_TARG_FCN

Mike Christie (1):
  target: Fix max_unmap_lba_count calc overflow

Nicholas Bellinger (4):
  target: Fix missing complete during ABORT_TASK + CMD_T_FABRIC_STOP
  target: Fix race between iscsi-target connection shutdown + ABORT_TASK
  target: Fix ordered task target_setup_cmd_from_cdb exception hang
  target: Fix ordered task CHECK_CONDITION early exception handling

Sumit Rai (1):
  target: Fix residual overflow handling in
    target_complete_cmd_with_length

 MAINTAINERS                               |   10 +-
 drivers/scsi/Kconfig                      |   17 +
 drivers/scsi/Makefile                     |    1 +
 drivers/scsi/ibmvscsi/ibmvfc.h            |    2 +-
 drivers/scsi/ibmvscsi/ibmvscsi.h          |    2 +-
 drivers/scsi/ibmvscsi/viosrp.h            |  225 --
 drivers/scsi/ibmvscsi_tgt/Makefile        |    3 +
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c  | 4087 +++++++++++++++++++++++++++++
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h  |  346 +++
 drivers/scsi/ibmvscsi_tgt/libsrp.c        |  427 +++
 drivers/scsi/ibmvscsi_tgt/libsrp.h        |  123 +
 drivers/target/iscsi/iscsi_target.c       |   22 +-
 drivers/target/iscsi/iscsi_target_login.c |    5 +-
 drivers/target/target_core_device.c       |    8 +-
 drivers/target/target_core_file.c         |    5 +-
 drivers/target/target_core_iblock.c       |    3 +-
 drivers/target/target_core_internal.h     |    1 +
 drivers/target/target_core_sbc.c          |    2 +-
 drivers/target/target_core_transport.c    |   94 +-
 drivers/target/tcm_fc/tfc_sess.c          |    2 +
 include/scsi/viosrp.h                     |  220 ++
 include/target/target_core_backend.h      |    2 +-
 include/target/target_core_base.h         |    1 +
 include/target/target_core_fabric.h       |    1 -
 24 files changed, 5326 insertions(+), 283 deletions(-)
 delete mode 100644 drivers/scsi/ibmvscsi/viosrp.h
 create mode 100644 drivers/scsi/ibmvscsi_tgt/Makefile
 create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c
 create mode 100644 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.h
 create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.c
 create mode 100644 drivers/scsi/ibmvscsi_tgt/libsrp.h
 create mode 100644 include/scsi/viosrp.h
