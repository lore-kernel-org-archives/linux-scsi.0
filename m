From: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
Subject: [PATCH 00/11] mpt3sas: Enable scsi MQ & lockless command submission
Date: Thu, 21 Dec 2017 23:31:36 -0800
Message-ID: <1513927907-19735-1-git-send-email-suganath-prabu.subramani@broadcom.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34126 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751428AbdLVHcL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Dec 2017 02:32:11 -0500
Received: by mail-wm0-f65.google.com with SMTP id y82so23183838wmg.1
        for <linux-scsi@vger.kernel.org>; Thu, 21 Dec 2017 23:32:11 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org
Cc: Sathya.Prakash@broadcom.com, sreekanth.reddy@broadcom.com, Hannes Reinecke <hare@suse.de>

From: Hannes Reinecke <hare@suse.de>

Hi all,

This patch set is initially posted by Hannes Reinecke to enable scsi
multiqueue for the mpt3sas driver.
While the HBA only has a single mailbox register for submitting commands,
it does have individual receive queues per MSI-X interrupt and as such
does benefit from converting it to full multiqueue support. 

Suganath Prabu S (11):
  mpt3sas: set default value for cb_idx
  mpt3sas: use list_splice_init()
  mpt3sas: separate out _base_recovery_check()
  mpt3sas: open-code _scsih_scsi_lookup_get()
  mpt3sas: Introduce mpt3sas_get_st_from_smid()
  mpt3sas: check command status before attempting abort
  mpt3sas: always use first reserved smid for ioctl      passthrough
  mpt3sas: simplify task management functions
  mpt3sas: simplify mpt3sas_scsi_issue_tm()
  mpt3sas: simplify _wait_for_commands_to_complete()
  mpt3sas: lockless command submission

 drivers/scsi/mpt3sas/modules.order       |   2 +-
 drivers/scsi/mpt3sas/mpt3sas_base.c      | 199 +++++++++++----------
 drivers/scsi/mpt3sas/mpt3sas_base.h      |  29 ++-
 drivers/scsi/mpt3sas/mpt3sas_ctl.c       |  31 ++--
 drivers/scsi/mpt3sas/mpt3sas_scsih.c     | 292 +++++++------------------------
 drivers/scsi/mpt3sas/mpt3sas_warpdrive.c |  33 +---
 6 files changed, 192 insertions(+), 394 deletions(-)

Thanks,
Suganath Prabu S
-- 
2.5.5
