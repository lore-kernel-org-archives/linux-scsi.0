From: "Dupuis, Chad" <chad.dupuis@cavium.com>
Subject: [PATCH V2 00/15] qedf: Update driver to version 8.18.22.0.
Date: Wed, 31 May 2017 06:33:47 -0700
Message-ID: <20170531133402.16629-1-chad.dupuis@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0085.outbound.protection.outlook.com ([104.47.42.85]:24950
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1750904AbdEaNeJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 May 2017 09:34:09 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com, QLogic-Storage-Upstream@cavium.com

Hi Martin,

Please apply the following patches to the scsi tree at your earliest convenience.

Thanks,
Chad

Change from V1 -> V2:

- Use fc_host attributes directly instead of using fc_host_* macros when setting FDMI attributes
- Fix typos in patch descriptions
- Implement suggested code refactoring for fka_period sysfs attribute
- Keep newly introduced error message strings on one line

Dupuis, Chad (15):
  qedf: Enable basic FDMI information.
  qedf: Update copyright to 2017.
  qedf: Honor qed_ops->common->set_fp_int() return code.
  qedf: Look at all descriptors when processing a clear virtual link.
  qedf: Check that fcport is offloaded before dereferencing pointers in
    initiate_abts|cleanup.
  qedf: Add fka_period SCSI host attribute to show fip keep alive
    period.
  qedf: Set qed logging level to QED_LEVEL_NOTICE.
  qedf: Use same logic for SCSI host reset and FC lip_reset.
  qedf: Add bus_reset No-op.
  qedf: Add non-offload receive filters.
  qedf: Fixup unnecessary parantheses around test_bit operations.
  qedf: Move some prints to a debug level so they do not print when no
    debugging is enabled.
  qedf: Change cmd_per_lun in scsi_host_template to 32 to increase
    performance.
  qedf: Add change_queue_depth member to scsi_host_template().
  qedf: Update version number to 8.18.22.0.

 drivers/scsi/qedf/drv_fcoe_fw_funcs.c |   2 +-
 drivers/scsi/qedf/drv_fcoe_fw_funcs.h |   2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.c |   2 +-
 drivers/scsi/qedf/drv_scsi_fw_funcs.h |   2 +-
 drivers/scsi/qedf/qedf.h              |   2 +-
 drivers/scsi/qedf/qedf_attr.c         |  59 +++++++-----
 drivers/scsi/qedf/qedf_dbg.h          |   2 +-
 drivers/scsi/qedf/qedf_debugfs.c      |   2 +-
 drivers/scsi/qedf/qedf_els.c          |   8 +-
 drivers/scsi/qedf/qedf_fip.c          |  22 +++--
 drivers/scsi/qedf/qedf_hsi.h          |   2 +-
 drivers/scsi/qedf/qedf_io.c           |  26 ++++--
 drivers/scsi/qedf/qedf_main.c         | 163 +++++++++++++++++++++++++++++-----
 drivers/scsi/qedf/qedf_version.h      |   8 +-
 14 files changed, 226 insertions(+), 76 deletions(-)

-- 
1.8.5.6
