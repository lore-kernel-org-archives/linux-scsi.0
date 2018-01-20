From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: [PATCH 0/3] scsi: aacraid: Multi controller Kdump IOP reset handling
Date: Fri, 19 Jan 2018 17:01:54 -0800
Message-ID: <20180120010157.22674-1-RaghavaAditya.Renukunta@microsemi.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn3nam01on0048.outbound.protection.outlook.com ([104.47.33.48]:22642
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1754766AbeATBCD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 20:02:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: Scott.Benesh@microsemi.com, tom.white@microsemi.com, aacraid@microsemi.com, "Guilherme G . Piccoli" <gpiccoli@linux.vnet.ibm.com>, Bart Van Assche <Bart.VanAssche@wdc.com>

During Kdump aacraid controller IOP reset is invoked, IOP reset
takes approx 40 seconds to bring the controller back up and running.
with timeout of 120 seconds and anything more than 2 controllers
will cause kdump to timeout.

This patchset implements a new reset mechanism called DropIO, that
induces the fw to drop any pending IO in the fw and making the reset
process quicker.

Raghava Aditya Renukunta (3):
  scsi: aacraid: Implement DropIO sync command
  scsi: aacraid: Preserve MSIX mode in the OMR register
  scsi: aacraid: Auto detect INTx or MSIx mode during sync cmd
    processing

 drivers/scsi/aacraid/aacraid.h |   5 +
 drivers/scsi/aacraid/src.c     | 211 ++++++++++++++++++++++++++++++++++++++---
 2 files changed, 202 insertions(+), 14 deletions(-)

-- 
2.9.4
