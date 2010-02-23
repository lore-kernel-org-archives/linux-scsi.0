From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/3] Generic v4.0 fabric module configfs infrastructure
Date: Mon, 22 Feb 2010 17:03:57 -0800
Message-ID: <1266887037-3803-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings SCSI and virtual filesystem folks,

This patch series contains the initial commits to lio-core-2.6.git/lio-4.0 to
support the new generic fabric module configfs infrastructure for TCM, and
the subsequent changes to drivers/target/lio-target and drivers/target/tcm_loop
to use generic configfs infrastructure from drivers/target/target_core_fabric_configfs.c.

The main idea behind the 4.0 configfs code is that fabric modules can use a generic
set of struct config_item_types and struct config_groups hanging off fabric dependent
structures, without having to explictly define a configfs layout of
/sys/kernel/config/target/$FABRIC themselves.  This allows a generic layout to be used with
fabric dependent attributes using struct config_item_type context specific macros in
include/target/target_core_fabric_configfs.h.

This is still a WIP, and this first series allows both lio-target and tcm_loop
fabric modules to run in demo mode (eg: no ACLs) using the generic configfs code.

I am hoping to get some feedback on the current work and any thoughts on possible improvements..

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (3):
  [TCM/Configfs]: Generic fabric module configfs infrastructure WIP
  [LIO-Target/ConfigFS]: Convert layout to use generic configfs struct
    config_item_types WIP
  [TCM_Loop/ConfigFS]: Convert layout to use generic configfs struct
    config_item_types

 drivers/target/Kbuild                             |    1 +
 drivers/target/lio-target/iscsi_target.c          |    4 +-
 drivers/target/lio-target/iscsi_target_configfs.c | 1010 +++------------------
 drivers/target/lio-target/iscsi_target_core.h     |   15 +-
 drivers/target/lio-target/iscsi_target_erl0.c     |    4 +-
 drivers/target/lio-target/iscsi_target_login.c    |   10 +-
 drivers/target/lio-target/iscsi_target_nego.c     |    2 +-
 drivers/target/lio-target/iscsi_target_tpg.c      |   39 +-
 drivers/target/lio-target/iscsi_target_version.h  |    2 +-
 drivers/target/target_core_configfs.c             |   24 +-
 drivers/target/target_core_fabric_configfs.c      |  612 +++++++++++++
 drivers/target/target_core_tpg.c                  |   18 +-
 drivers/target/tcm_loop/tcm_loop_configfs.c       |  435 ++++------
 drivers/target/tcm_loop/tcm_loop_core.h           |   18 +-
 drivers/target/tcm_loop/tcm_loop_fabric_scsi.c    |    2 +-
 include/target/target_core_base.h                 |   22 +-
 include/target/target_core_configfs.h             |   20 +-
 include/target/target_core_fabric_configfs.h      |   50 +
 include/target/target_core_fabric_ops.h           |   19 +
 include/target/target_core_tpg.h                  |    6 +-
 20 files changed, 1079 insertions(+), 1234 deletions(-)
 create mode 100644 drivers/target/target_core_fabric_configfs.c
 create mode 100644 include/target/target_core_fabric_configfs.h

