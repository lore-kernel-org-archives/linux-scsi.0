From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH v2 0/3] scsi: aacraid: Multi controller Kdump IOP reset handling
Date: Wed, 7 Feb 2018 08:40:55 -0800
Message-ID: <20180207164058.29598-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-cys01nam02on0041.outbound.protection.outlook.com ([104.47.37.41]:10320
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754378AbeBGQlM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 7 Feb 2018 11:41:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, esc-teamarcdriversvl@microsemi.com

During Kdump aacraid controller IOP reset is invoked, IOP reset
takes approx 40 seconds to bring the controller back up and running.
with timeout of 120 seconds and anything more than 2 controllers
will cause kdump to timeout.

This patchset implements a new reset mechanism called DropIO, that
induces the fw to drop any pending IO in the fw and making the reset
process quicker.

Changes in v2:
Respun patchset against Linus Master
Added Dave Carroll's reviewed-by tags

Raghava Aditya Renukunta (3):
  scsi: aacraid: Implement DropIO sync command
  scsi: aacraid: Preserve MSIX mode in the OMR register
  scsi: aacraid: Auto detect INTx or MSIx mode during sync cmd
    processing

 drivers/scsi/aacraid/aacraid.h |   5 +
 drivers/scsi/aacraid/src.c     | 205 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 198 insertions(+), 12 deletions(-)

-- 
2.9.4
