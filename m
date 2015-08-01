From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH v2 0/6] scsi: ufs: fix several issues caused by driver reloading
Date: Sun,  2 Aug 2015 02:19:14 +0900
Message-ID: <1438449560-4106-1-git-send-email-akinobu.mita@gmail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:33639 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751015AbbHARTi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 1 Aug 2015 13:19:38 -0400
Received: by pdbnt7 with SMTP id nt7so56628125pdb.0
        for <linux-scsi@vger.kernel.org>; Sat, 01 Aug 2015 10:19:37 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Akinobu Mita <akinobu.mita@gmail.com>

This patch set addresses several issues caused by driver reloading in
ufs driver.  The first version of this series was sent on March 28.
This version gained three more fixes.

* Changes from v1
- Call pm_runtime_put_noidle() where idle callback shouldn't be called
- Prevent IRQ handler accessing already freed hostdata
- Fix unloading module while runtime suspended
- Fix module reference for scsi host

Akinobu Mita (6):
  scsi: ufs: avoid using hostdata after scsi_host_put()
  scsi: ufs: fix unbalanced power.usage_count after reloading driver
  scsi: ufs: fix unbalanced power.disable_depth after reloading driver
  scsi: ufs: prevent IRQ handler accessing already freed hostdata
  scsi: ufs: fix unloading module while runtime suspended
  scsi: ufs: fix module reference for scsi host

 drivers/scsi/ufs/ufshcd-pci.c    | 19 ++++++++++++--
 drivers/scsi/ufs/ufshcd-pltfrm.c | 24 ++++++++++++++++--
 drivers/scsi/ufs/ufshcd.c        | 54 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h        |  5 +++-
 4 files changed, 72 insertions(+), 30 deletions(-)

-- 
1.9.1

