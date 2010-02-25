From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [PATCH 0/4] Generic target fabric configfs NodeACL and MappedLUN logic
Date: Thu, 25 Feb 2010 06:05:18 -0800
Message-ID: <1267106718-7006-1-git-send-email-nab@linux-iscsi.org>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Sender: linux-fsdevel-owner@vger.kernel.org
To: LIO-Target devel <linux-iscsi-target-dev@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Greetings again folks,

This is the second patch series to lio-core-2.6.git/lio-4.0 for enabling a generic target fabric
module independent configfs infrastructure.  It contains the changes necessary to use generic
struct config_item_types in target_core_fabric_configfs.c for reproducing existing v3.x configfs
layout of NodeACL base, NodeACL attribute, NodeACL parameters, NodeACL authentication and MappedLUN
groups.

As with the previous patch series for generic WWN, TPG and LUN struct config_item_types, the new NodeACL
and MappedLUN 'cits' have been added to struct target_fabric_configfs_template along with matching
struct config_group_operations and struct config_item_operation handlers living in target_core_fabric_configfs.c 
As before, fabric modules are allowed to hang fabric dependent attributes from these generic cits
using the CONFIGFS_EATTR() style macros in include/target/target_core_fabric_configfs.c:TF_NACL_*() for
existing attribute code.

With these second series of patches, the 4.0 generic fabric configfs code is now able to reproduce the
entire existing configfs layout and functionality in /sys/kernel/config/target/iscsi for the LIO-Target v3.x
fabric module using the existing fabric dependent attributes..  Which means that existing v3.x userspace
code should be working as expected with the v4.0 code..!

As before, any comments, suggestions, questions are welcome,

Thanks!

Signed-off-by: Nicholas A. Bellinger <nab@linux-iscsi.org>

Nicholas Bellinger (4):
  [TCM/ConfigFS]: Add generic tfc_discovery_cit to
    target_core_register_fabric()
  [TCM/ConfigFS]: Add generic NodeACL and MappedLUN configfs logic
  [LIO-Target/ConfigFS]: Convert NodeACl and MappedLUNs to use generic
    configfs struct config_item_types
  [TCM_Loop]: Update virtual SAS NodeACL allocation handling for v4.0

 drivers/target/lio-target/iscsi_auth_kernel.h      |    5 +-
 drivers/target/lio-target/iscsi_target_configfs.c  |  956 ++++----------------
 drivers/target/lio-target/iscsi_target_core.h      |    6 +-
 .../target/lio-target/iscsi_target_nodeattrib.c    |    2 +-
 drivers/target/lio-target/iscsi_target_tpg.c       |   58 +-
 drivers/target/lio-target/iscsi_target_tpg.h       |    4 +-
 drivers/target/target_core_configfs.c              |   25 +-
 drivers/target/target_core_fabric_configfs.c       |  381 ++++++++-
 drivers/target/target_core_tpg.c                   |   54 +-
 drivers/target/tcm_loop/tcm_loop_configfs.c        |    5 +-
 drivers/target/tcm_loop/tcm_loop_core.h            |    2 +-
 drivers/target/tcm_loop/tcm_loop_fabric.c          |   10 +-
 drivers/target/tcm_loop/tcm_loop_fabric.h          |    3 +-
 include/target/target_core_base.h                  |    4 +-
 include/target/target_core_configfs.h              |   11 +-
 include/target/target_core_fabric_configfs.h       |   56 ++
 include/target/target_core_fabric_ops.h            |    8 +-
 include/target/target_core_tpg.h                   |    6 +-
 18 files changed, 715 insertions(+), 881 deletions(-)

