From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 00/17]  cxlflash: Enhancements and miscellaneous fixes
Date: Wed, 12 Apr 2017 14:10:15 -0500
Message-ID: <1492024215-55579-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:50541 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754615AbdDLTLb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Apr 2017 15:11:31 -0400
Received: from pps.filterd (m0098410.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v3CJ99CW087895
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:11:28 -0400
Received: from e31.co.us.ibm.com (e31.co.us.ibm.com [32.97.110.149])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29sstv8yue-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2017 15:11:27 -0400
Received: from localhost
        by e31.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Wed, 12 Apr 2017 13:11:26 -0600
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>

This patch series contains miscellaneous patches and adds 4 port device
support. This series also includes patches to improve performance of the
driver in the legacy IO path.

This series is intended for 4.12 and is bisectable

Matthew R. Ochs (16):
  cxlflash: Separate RRQ processing from the RRQ interrupt handler
  cxlflash: Serialize RRQ access and support offlevel processing
  cxlflash: Implement IRQ polling for RRQ processing
  cxlflash: Update sysfs helper routines to pass config structure
  cxlflash: Support dynamic number of FC ports
  cxlflash: Remove port configuration assumptions
  cxlflash: Hide FC internals behind common access routine
  cxlflash: SISlite updates to support 4 ports
  cxlflash: Support up to 4 ports
  cxlflash: Fence EEH during probe
  cxlflash: Remove unnecessary DMA mapping
  cxlflash: Fix power-of-two validations
  cxlflash: Fix warnings/errors
  cxlflash: Improve asynchronous interrupt processing
  cxlflash: Add hardware queues attribute
  cxlflash: Introduce hardware queue steering

Uma Krishnan (1):
  cxlflash: Support multiple hardware queues

 Documentation/powerpc/cxlflash.txt |    5 +
 drivers/scsi/cxlflash/common.h     |  137 +++--
 drivers/scsi/cxlflash/lunmgt.c     |    4 +-
 drivers/scsi/cxlflash/main.c       | 1162 +++++++++++++++++++++++++++---------
 drivers/scsi/cxlflash/main.h       |    2 -
 drivers/scsi/cxlflash/sislite.h    |  124 ++--
 drivers/scsi/cxlflash/superpipe.c  |   16 +-
 drivers/scsi/cxlflash/superpipe.h  |   56 +-
 drivers/scsi/cxlflash/vlun.c       |   99 +--
 drivers/scsi/cxlflash/vlun.h       |    2 +-
 10 files changed, 1182 insertions(+), 425 deletions(-)

-- 
2.1.0
