From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 00/39] megaraid_sas: Updates for scsi-next
Date: Fri, 10 Feb 2017 00:59:00 -0800
Message-ID: <1486717179-23320-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f182.google.com ([209.85.192.182]:35688 "EHLO
        mail-pf0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751477AbdBJJ5c (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Feb 2017 04:57:32 -0500
Received: by mail-pf0-f182.google.com with SMTP id 202so5228819pfx.2
        for <linux-scsi@vger.kernel.org>; Fri, 10 Feb 2017 01:56:56 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Changes in v3:
Patch 21: Fix to pass rctx_g35 pointer to set/get_num_sge()
Move all v2 changelog descriptions beyond actual commit message body

Changes in v2:
Patch 3: Fix to update status and ex_status from failed r1_cmd
Patch 8: Split into two separate patches,
 1. megasas_get_request_descriptor will always return valid
    request descriptor
 2. With above changes, issue_dcmd always return DCMD_SUCCESS.
    Change return type to void and update all callers.
Patch 11: Update commit description, remove reference to dependent patch.
Patch 12: Update with correct commit description
Patch 14: Fix typo in commit description
Patch 19: Correction to commit description
Drop patch 33 of last patch series which added call for flush_scheduled_work

Shivasharan S (39):
  Revert "scsi: megaraid_sas: Enable or Disable Fast path based on the
    PCI Threshold Bandwidth"
  megaraid_sas: cpu select rework.
  megaraid_sas: raid 1 fast path code optimize
  megaraid_sas: 32 bit descriptor fire cmd optimization
  megaraid_sas: Refactor MEGASAS_IS_LOGICAL macro using sdev
  megaraid_sas: RAID map is accessed for SYS PDs when use_seqnum_jbod_fp
    is not set
  megaraid_sas: Use DID_REQUEUE
  megaraid_sas: megasas_get_request_descriptor always return valid desc
  megaraid_sas: change issue_dcmd to return void from int
  megaraid_sas: NVME Interface detection and prop settings
  megaraid_sas: NVME interface target prop added
  megaraid_sas: NVME fast path io support
  megaraid_sas: raid 1 write performance for large io
  megaraid_sas: set residual bytes count during IO completion
  megaraid_sas: enhance debug logs in OCR context
  megaraid_sas: add print in device removal path
  megaraid_sas: reduce size of fusion_context and use vmalloc if kmalloc
    fails
  megaraid_sas: In validate raid map, raid capability is not converted
    to cpu format for all lds
  megaraid_sas: MR_TargetIdToLdGet u8 to u16 and avoid invalid raid-map
    access
  megaraid_sas: Big endian RDPQ mode fix
  megaraid_sas: big endian support changes
  megaraid_sas: avoid unaligned access in ioctl path
  megaraid_sas: latest controller OCR capability from FW before sending
    shutdown DCMD
  megaraid_sas: set pd_after_lb from MR_BuildRaidContext and initialize
    pDevHandle to MR_DEVHANDLE_INVALID
  megaraid_sas: Change max_cmd from u32 to u16 in all functions
  megaraid_sas: update can_queue only if the new value is less
  megaraid_sas: max_fw_cmds are decremented twice, remove duplicate
  megaraid_sas: megasas_return_cmd does not memset IO frame to zero
  megaraid_sas: Remove unused pd_index from
    megasas_build_ld_nonrw_fusion
  megaraid_sas: Do not set fp_possible if TM capable for non-RW syspdIO,
    change fp_possible to bool
  megaraid_sas: During OCR, if get_ctrl_info fails do not continue with
    OCR
  megaraid_sas: Change build_mpt_mfi_pass_thru to return void
  megaraid_sas: Bail out the driver load if ld_list_query fails
  megaraid_sas: Use synchronize_irq to wait for IRQs to complete
  megaraid_sas: Increase internal command pool
  megaraid_sas: Cleanup VD_EXT_DEBUG and SPAN_DEBUG related debug prints
  megaraid_sas: Indentation and smatch warning fixes
  megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set
    value to 2
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   82 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  548 +++++++----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  427 ++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1352 ++++++++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  144 ++-
 5 files changed, 1434 insertions(+), 1119 deletions(-)

-- 
2.8.3
