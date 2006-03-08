From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH] aic94xx nexus loss time value
Date: Tue, 7 Mar 2006 16:57:05 -0800
Message-ID: <20060308005705.GA1516@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:64163 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1751951AbWCHA5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2006 19:57:08 -0500
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k280v6jH005207
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 19:57:06 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k280v6TQ099128
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 19:57:06 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k280v6cU018724
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 19:57:06 -0500
Received: from hmsbounty.us.ibm.com (sig-9-65-4-120.mts.ibm.com [9.65.4.120])
	by d01av03.pok.ibm.com (8.12.11/8.12.11) with ESMTP id k280v6YG018690
	for <linux-scsi@vger.kernel.org>; Tue, 7 Mar 2006 19:57:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

The nexus loss time value should not be used for an upper level timeout
value. The nexus loss time is for connection request retries. The usage of
the nexus loss time value + HZ (3 seconds) for sdev->timeout leads to
timeouts under load (Bug 6046).

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/sas/sas_scsi_host.c |    4 ----
 1 files changed, 4 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/sas/sas_scsi_host.c	2006-03-06 10:42:59.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/sas/sas_scsi_host.c	2006-03-07 15:42:07.000000000 -0800
@@ -585,10 +585,6 @@ int sas_slave_configure(struct scsi_devi
 		scsi_deactivate_tcq(scsi_dev, 1);
 	}
 
-	if (rdev->I_T_nexus_loss_timeout > 0)
-		scsi_dev->timeout = HZ +
-			msecs_to_jiffies(rdev->I_T_nexus_loss_timeout);
-
 	return 0;
 }
 
