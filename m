From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: [PATCH v2 00/15] megaraid_sas: Updates for scsi-next
Date: Thu, 28 Jan 2016 21:04:21 +0530
Message-ID: <1453995276-24955-1-git-send-email-sumit.saxena@avagotech.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f54.google.com ([209.85.220.54]:34082 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755592AbcA1Pe6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2016 10:34:58 -0500
Received: by mail-pa0-f54.google.com with SMTP id uo6so25308383pac.1
        for <linux-scsi@vger.kernel.org>; Thu, 28 Jan 2016 07:34:58 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jbottomley@parallels.com, hch@infradead.org, martin.petersen@oracle.com, thenzl@redhat.com
Cc: linux-scsi@vger.kernel.org, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com

Changes between v1 and v2:
-Addressed comments provided by Tomas Henzl.
-Return MFI frame used for task management(TM) in case of TM timeout and 
 error cases.
-Fixed few error handling cases inside functions- megasas_alloc_cmdlist_fusion()
 and megasas_alloc_cmds_fusion(), fix typo- disable(old- disbale) in rdpq_enable
 module parameter's description, modify print to reflect RDPQ support statement
 correctly.
-Used atomic_inc_return instead of using atomic_read() and atomic_inc()
 separately inside function- megasas_build_and_issue_cmd_fusion(). 
-Removed the un-necessary code of throttling of IOs against can_queue inside
 function- megasas_build_and_issue_cmd_fusion() as SCSI mid layer will anyways
 does this.
-Removed redundant checks when label- kill_hba_and_failed is being called.
-Removed one patch- *[PATCH 15/15] megaraid_sas: SPERC boot driver reorder*
 from v2 patchset as that was rejected.
-Added one new patch for driver version upgrade.

Sumit Saxena (15):
  megaraid_sas: Do not allow PCI access during OCR
  megaraid_sas: MFI IO timeout handling
  megaraid_sas: Syncing request flags macro names with firmware
  megaraid_sas: Task management support
  megaraid_sas: Update device Queue depth based on interface type
  megaraid_sas: Fastpath region lock bypass
  megaraid_sas: Reply Descriptor Post Queue(RDPQ) support
  megaraid_sas: Code optimization build_and_issue_cmd return-type
  megaraid_sas: Dual Queue depth support
  megaraid_sas: IO throttling support
  megaraid_sas: Make adprecovery variable atomic
  megaraid_sas: MFI adapter's OCR changes
  megaraid_sas: Introduce module parameter for SCSI command-timeout
  megaraid_sas: SPERC OCR changes
  megaraid_sas: driver version upgrade

 drivers/scsi/megaraid/megaraid_sas.h        |  338 +++++++-
 drivers/scsi/megaraid/megaraid_sas_base.c   | 1034 ++++++++++++++--------
 drivers/scsi/megaraid/megaraid_sas_fp.c     |    2 +
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 1244 ++++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  136 ++-
 5 files changed, 2027 insertions(+), 727 deletions(-)

-- 
1.8.3.1

