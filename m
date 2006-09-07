From: malahal@us.ibm.com
Subject: [PATCH] aic94xx: Fix incorrect memory allocation size
Date: Thu, 7 Sep 2006 11:39:36 -0700
Message-ID: <20060907183936.GA3713@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.150]:38344 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751679AbWIGSjj
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Sep 2006 14:39:39 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e32.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k87Idc5C031128
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 14:39:38 -0400
Received: from d03av04.boulder.ibm.com (d03av04.boulder.ibm.com [9.17.195.170])
	by westrelay02.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k87Idcht327036
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 12:39:38 -0600
Received: from d03av04.boulder.ibm.com (loopback [127.0.0.1])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k87Idc0v014532
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 12:39:38 -0600
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d03av04.boulder.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k87IdbPs014516
	for <linux-scsi@vger.kernel.org>; Thu, 7 Sep 2006 12:39:38 -0600
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This patch corrects the size passed to kmalloc in asd_register_sas_ha()

Signed-off-by: Malahal Naineni <malahal@us.ibm.com>


diff -r 134012c83658 drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c	Thu Aug 31 13:03:38 2006 -0700
+++ b/drivers/scsi/aic94xx/aic94xx_init.c	Wed Sep 06 23:40:29 2006 -0700
@@ -481,9 +481,9 @@ static int asd_register_sas_ha(struct as
 {
 	int i;
 	struct asd_sas_phy   **sas_phys =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy), GFP_KERNEL);
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy *), GFP_KERNEL);
 	struct asd_sas_port  **sas_ports =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port), GFP_KERNEL);
+		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port *), GFP_KERNEL);
 
 	if (!sas_phys || !sas_ports) {
 		kfree(sas_phys);
