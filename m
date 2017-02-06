From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH 00/39] megaraid_sas: Updates for scsi-next
Date: Mon,  6 Feb 2017 01:59:33 -0800
Message-ID: <1486375212-17329-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f50.google.com ([74.125.83.50]:32769 "EHLO
        mail-pg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750950AbdBFKBM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Feb 2017 05:01:12 -0500
Received: by mail-pg0-f50.google.com with SMTP id 204so27443122pge.0
        for <linux-scsi@vger.kernel.org>; Mon, 06 Feb 2017 02:01:12 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

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
  megaraid_sas: NVME Interface detection and prop settings
  megaraid_sas: NVME interface target prop added
  megaraid_sas: NVME interface target prop added
  megaraid_sas: raid 1 write performance for large io
  megaraid_sas : set residual bytes count during IO compeltion
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
  megaraid_sas: call flush_scheduled_work during controller
    shutdown/detach
  megaraid_sas: Use synchronize_irq to wait for IRQs to complete
  megaraid_sas: Increase internal command pool
  megaraid_sas: Cleanup VD_EXT_DEBUG and SPAN_DEBUG related debug prints
  megaraid_sas: Indentation and smatch warning fixes
  megaraid_sas: Change RAID_1_10_RMW_CMDS to RAID_1_PEER_CMDS and set
    value to 2
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   80 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  533 +++++++----
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  427 ++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1352 ++++++++++++++++-----------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  144 ++-
 5 files changed, 1422 insertions(+), 1114 deletions(-)

-- 
2.8.3
