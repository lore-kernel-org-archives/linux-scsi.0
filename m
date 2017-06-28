From: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>
Subject: [PATCH 1/3] cxlflash: Avoid double free of character device
Date: Wed, 28 Jun 2017 12:14:21 -0500
Message-ID: <1498670061-39766-1-git-send-email-mrochs@linux.vnet.ibm.com>
References: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:45078 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1751516AbdF1ROe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jun 2017 13:14:34 -0400
Received: from pps.filterd (m0098419.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v5SHDmcw093052
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:14:33 -0400
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2bcf4ammqy-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2017 13:14:33 -0400
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mrochs@linux.vnet.ibm.com>;
        Wed, 28 Jun 2017 13:14:33 -0400
In-Reply-To: <1498669929-39684-1-git-send-email-mrochs@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Uma Krishnan <ukrishn@linux.vnet.ibm.com>, "Manoj N. Kumar" <manoj@linux.vnet.ibm.com>, Hannes Reinecke <hare@suse.com>
Cc: Frederic Barrat <fbarrat@linux.vnet.ibm.com>, Andrew Donnellan <andrew.donnellan@au1.ibm.com>, Christophe Lombard <clombard@linux.vnet.ibm.com>, linuxppc-dev@lists.ozlabs.org, "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>

The device_unregister() service used when cleaning up the character
device is already responsible for the internal state associated with
the device upon successful creation. As the cxlflash driver does not
obtain a second reference to the character device, the explicit call
to put_device() is not required and can lead to an inconsistent sysfs
among other issues as the reference is no longer valid after the first
put_device() is performed.

Remove the unnecessary put_device() to remedy this issue.

Fixes: a834a36b57d9 ("scsi: cxlflash: Create character device to provide host management interface")
Signed-off-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
---
 drivers/scsi/cxlflash/main.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/scsi/cxlflash/main.c b/drivers/scsi/cxlflash/main.c
index 7a787b6..455564f 100644
--- a/drivers/scsi/cxlflash/main.c
+++ b/drivers/scsi/cxlflash/main.c
@@ -923,7 +923,6 @@ static void cxlflash_put_minor(int minor)
  */
 static void cxlflash_release_chrdev(struct cxlflash_cfg *cfg)
 {
-	put_device(cfg->chardev);
 	device_unregister(cfg->chardev);
 	cfg->chardev = NULL;
 	cdev_del(&cfg->cdev);
-- 
2.1.0
