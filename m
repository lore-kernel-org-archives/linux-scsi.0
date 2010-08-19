From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] tcm: More cleanups for v4.0.0-rc3
Date: Thu, 19 Aug 2010 15:12:52 -0700
Message-ID: <1282255972-12850-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings all,

Here are few more TCM cleanups that are being pushed to lio-core-2.6.git/lio-4.0.

Patch #1 removes an unused struct se_mem -> struct se_mem w/ task_offset
mapping function, patch #2 was recommended by hch now that se_obj_lun_type_t
no longer exists, and patch #3 removes legacy usage of type 'void *' for
struct se_lun->lun_type_ptr, and instead uses a easily grokable struct se_lun->lun_se_dev
member for existing all struct se_lun -> struct se_device references.

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  tcm: Remove legacy transport_map_mem_to_mem()
  tcm: Remove remaining code out of target_core_seobj.c
  tcm: Remove legacy struct se_lun->lun_type_ptr

 drivers/target/Kbuild                        |    1 -
 drivers/target/lio-target/iscsi_target_mib.c |    8 +-
 drivers/target/target_core_alua.c            |    6 +-
 drivers/target/target_core_configfs.c        |    1 -
 drivers/target/target_core_device.c          |   86 +++++-
 drivers/target/target_core_fabric_configfs.c |    3 +-
 drivers/target/target_core_mib.c             |    8 +-
 drivers/target/target_core_seobj.c           |  214 ---------------
 drivers/target/target_core_seobj.h           |   47 ----
 drivers/target/target_core_tpg.c             |   15 +-
 drivers/target/target_core_transport.c       |  379 +++++++++++++-------------
 include/target/target_core_base.h            |    5 +-
 include/target/target_core_device.h          |    6 +
 include/target/target_core_transport.h       |   11 +-
 14 files changed, 286 insertions(+), 504 deletions(-)
 delete mode 100644 drivers/target/target_core_seobj.c
 delete mode 100644 drivers/target/target_core_seobj.h
