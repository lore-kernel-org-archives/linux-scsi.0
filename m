From: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
Subject: [PATCH v3 00/14] megaraid_sas: Updates for scsi-next
Date: Wed, 23 Aug 2017 04:46:54 -0700
Message-ID: <1503488828-2242-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34333 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753768AbdHWLr2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Aug 2017 07:47:28 -0400
Received: by mail-pf0-f172.google.com with SMTP id h75so5825940pfh.1
        for <linux-scsi@vger.kernel.org>; Wed, 23 Aug 2017 04:47:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com, sumit.saxena@broadcom.com, hare@suse.com, hch@lst.de, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

Changes from v2:
- Patch 9: Updated patch description
- Dropped patch 11 of the last series. As per discussion
  with Christoph Hellwig, there was concern over the blk-mq
  specific hack in the changes. Also this needs to be tested with
  latest blk-mq performance improvements patchset from Ming.
  We will follow up on this patch during next phase submission.
- Rebased all patches to latest scsi/for-next branch.

Changes from v1:
- Patch 4: Updated patch description
- Patch 9: Cleanup ld_drv_map in case ld_map allocation fails

Shivasharan S (14):
  megaraid_sas: mismatch of allocated MFI frame size and length exposed
    in MFI MPT pass through command
  megaraid_sas: set minimum value of resetwaittime to be 1 secs
  megaraid_sas: Use synchronize_irq in target reset case
  megaraid_sas: Call megasas_complete_cmd_dpc_fusion every 1 second
    while there are pending commands
  megaraid_sas: Do not re-fire shutdown DCMD after OCR
  megaraid_sas: Fix endianness issues in DCMD handling
  megaraid_sas: Check valid aen class range to avoid kernel panic
  megaraid_sas: Use SMID for Task abort case only
  megaraid_sas: use vmalloc for crash dump buffers and driver's local
    RAID map
  megaraid_sas: Return pended IOCTLs with cmd_status
    MFI_STAT_WRONG_STATE in case adapter is dead
  megaraid_sas: replace internal FALSE/TRUE definitions with false/true
  megaraid_sas: modified few prints in OCR and IOC INIT path
  megaraid_sas: call megasas_dump_frame with correct IO frame size
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |   5 +-
 drivers/scsi/megaraid/megaraid_sas_base.c   |  39 +++++--
 drivers/scsi/megaraid/megaraid_sas_fp.c     |  40 +++----
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 170 ++++++++++++++++++----------
 4 files changed, 154 insertions(+), 100 deletions(-)

-- 
1.8.3.1
