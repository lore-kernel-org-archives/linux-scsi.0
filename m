From: Uma Krishnan <ukrishn@linux.vnet.ibm.com>
Subject: [PATCH 00/14] cxlflash: Fixes, enhancements, cleanup and staging
Date: Tue, 15 Nov 2016 17:12:10 -0600
Message-ID: <1479251530-22573-1-git-send-email-ukrishn@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56850 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S932927AbcKOXMf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Nov 2016 18:12:35 -0500
Received: from pps.filterd (m0098416.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.17/8.16.0.17) with SMTP id uAFN92Gl141817
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:12:34 -0500
Received: from e19.ny.us.ibm.com (e19.ny.us.ibm.com [129.33.205.209])
        by mx0b-001b2d01.pphosted.com with ESMTP id 26qxsbv58e-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2016 18:12:34 -0500
Received: from localhost
        by e19.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <ukrishn@linux.vnet.ibm.com>;
        Tue, 15 Nov 2016 18:12:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>
Cc: Brian King <brking@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, Ian Munsie <imunsie@au1.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>

The first four patches in this patch series include fixes for command
room violation and lun table management.

The remaining patches remove the reliance upon an internally maintained
private command pool in favor of private commands being allocated
alongside the SCSI commands. Several cleanup opportunities were noticed
while removing the private command pool infrastructure and have been
included as well. Lastly, the final two patches provide staging for
supporting hardware with a different queuing model.

The series is based upon 4.9-rc5, intended for 4.10 and is bisectable.

Matthew R. Ochs (10):
  cxlflash: Remove unused buffer from AFU command
  cxlflash: Allocate memory instead of using command pool for AFU sync
  cxlflash: Use cmd_size for private commands
  cxlflash: Remove private command pool
  cxlflash: Wait for active AFU commands to timeout upon tear down
  cxlflash: Remove AFU command lock
  cxlflash: Cleanup send_tmf()
  cxlflash: Cleanup queuecommand()
  cxlflash: Migrate IOARRIN specific routines to function pointers
  cxlflash: Migrate scsi command pointer to AFU command

Uma Krishnan (4):
  cxlflash: Set sg_tablesize to 1 instead of SG_NONE
  cxlflash: Fix crash in cxlflash_restore_luntable()
  cxlflash: Improve context_reset() logic
  cxlflash: Avoid command room violation

 drivers/scsi/cxlflash/common.h  |  35 ++--
 drivers/scsi/cxlflash/lunmgt.c  |   6 +
 drivers/scsi/cxlflash/main.c    | 360 +++++++++++-----------------------------
 drivers/scsi/cxlflash/sislite.h |   2 +-
 4 files changed, 120 insertions(+), 283 deletions(-)

-- 
2.1.0

