From: "Nicholas A. Bellinger" <nab@daterainc.com>
Subject: [PATCH 00/16] target: Use external CITs for backend devices
Date: Fri, 28 Nov 2014 09:06:26 +0000
Message-ID: <1417165602-32359-1-git-send-email-nab@daterainc.com>
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Douglas Gilbert <dgilbert@interlog.com>, Jerome Martin <tramjoe.merin@gmail.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

From: Nicholas Bellinger <nab@linux-iscsi.org>

Hi all,

This series addresses a long standing limitation going back to early
LIO v3.x days, where all TCM backend devices originally used local
scope struct config_item_types in target_core_configfs.c code that
resulted in same /sys/kernel/config/target/core/$HBA/$DEV/attrib/*
for all se_subsystem_api flavors, regardless of ->transport_type.

This has made user-space complexity grow slightly over the years,
causing rtslib + friends to have to determine which device attributes
can be changed at run-time for pSCSI vs. other backend drivers.

On the other hand, existing target_core_fabric_configfs.c logic in
LIO v4.0 has used a method that lets fabric drivers populate their
own driver dependent attributes using struct config_item_type members
within struct target_fabric_configfs->tf_cit_tmpl.  This allows for
config_item_type (CITs) to live within external modules, so fabric
drivers can add new attributes without breaking existing configfs
user-space ABI.

To that end, this series exposes the 6 existing se_device CITs from
target_core_configfs.c externally to backend drivers, and using a
new set of helper macros in target_core_backend_configfs.h converts
existing IBLOCK, FILEIO, RAMDISK, TCM-USER, and PSCSI to populate
their own set of backend device attributes.

Post conversion, IBLOCK, FILEIO, RAMDISK, and TCM-USER device attrs
remain unchanged to user-space via the DEF_TB_DEFAULT_ATTRIBS CPP
magic, and PSCSI now exposes 4 read-only attributes: hw_pi_prot_type,
hw_block_size, hw_max_sectors and hw_queue_depth.

Thanks!

--nab

Nicholas Bellinger (16):
  target: Move dev_cit to struct se_subsystem_api
  target: Move dev_attrib_cit to struct se_subsystem_api
  target: Move dev_pr_cit to struct se_subsystem_api
  target: Move dev_wwn_cit to struct se_subsystem_api
  target: Move dev_alua_tg_pt_gps_cit to struct se_subsystem_api
  target: Move dev_stat_cit to struct se_subsystem_api
  target: Add target_core_backend_configfs.h helper macros
  target: Add EXPORT_SYMBOL for existing se_dev_set_*
  target: Add DEF_TB_DEFAULT_ATTRIBS macro for virtual device attrs
  target/iblock: Convert to external iblock_backend_dev_attrs
  target/file: Convert to external fileio_backend_dev_attrs
  target/rd: Convert to external rd_mcp_backend_dev_attrs
  target/user: Convert to external tcmu_backend_dev_attrs
  target/pscsi: Convert to external pscsi_backend_dev_attrs
  target: Drop left-over internal dev attribute code
  target: Drop left-over PHBA_PDEV set attr checks

 drivers/target/target_core_configfs.c         | 269 +++++---------------------
 drivers/target/target_core_device.c           |  90 ++++-----
 drivers/target/target_core_file.c             |  42 ++++
 drivers/target/target_core_hba.c              |   1 +
 drivers/target/target_core_iblock.c           |  42 ++++
 drivers/target/target_core_internal.h         |  28 ---
 drivers/target/target_core_pscsi.c            |  26 +++
 drivers/target/target_core_rd.c               |  41 ++++
 drivers/target/target_core_user.c             |  42 ++++
 include/target/target_core_backend.h          |  43 ++++
 include/target/target_core_backend_configfs.h | 120 ++++++++++++
 11 files changed, 442 insertions(+), 302 deletions(-)
 create mode 100644 include/target/target_core_backend_configfs.h

-- 
1.9.1
