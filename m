From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: [patch 4/4] zfcp: fix return code of zfcp_scsi_slave_alloc
Date: Thu, 1 Dec 2005 02:49:29 +0100
Message-ID: <20051201014929.GA13086@lion28.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:28814 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP
	id S1751623AbVLABum (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Nov 2005 20:50:42 -0500
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.12.10/8.12.10) with ESMTP id jB11ooBN186718
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 01:50:50 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id jB11oe9Z217114
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:50:40 +0100
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id jB11oebd009447
	for <linux-scsi@vger.kernel.org>; Thu, 1 Dec 2005 02:50:40 +0100
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jejb@steeleye.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>

From: Andreas Herrmann <aherrman@de.ibm.com>

[patch 4/4] zfcp: fix return code of zfcp_scsi_slave_alloc

Change return code in slave_alloc to avoid irritating error message from
scsi_alloc_sdev() when scsi stack tries target scan.

Signed-off-by: Andreas Herrmann <aherrman@de.ibm.com>

diff -Nurp linux-2.6.15-rc3/drivers/s390/scsi/zfcp_scsi.c linux-2.6.x/drivers/s390/scsi/zfcp_scsi.c
--- linux-2.6.15-rc3/drivers/s390/scsi/zfcp_scsi.c	2005-10-28 02:02:08.000000000 +0200
+++ linux-2.6.x/drivers/s390/scsi/zfcp_scsi.c	2005-12-01 01:18:54.000000000 +0100
@@ -179,7 +179,7 @@ zfcp_scsi_slave_alloc(struct scsi_device
 	struct zfcp_adapter *adapter;
 	struct zfcp_unit *unit;
 	unsigned long flags;
-	int retval = -ENODEV;
+	int retval = -ENXIO;
 
 	adapter = (struct zfcp_adapter *) sdp->host->hostdata[0];
 	if (!adapter)
