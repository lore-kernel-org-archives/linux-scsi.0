From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 11/12] mptfusion: Proper error handling is added after mpt_config timeout
Date: Thu, 18 Mar 2010 19:24:57 +0530
Message-ID: <20100318135447.GL22510@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog106.obsmtp.com ([74.125.149.77]:50102 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751803Ab0CRO0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 10:26:05 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

Added proper error handling after mpt_config.
Now check of MPI_IOCSTATUS_CONFIG_INVALID_PAGE is added.
If error is MPI_IOCSTATUS_CONFIG_INVALID_PAGE, driver will return -ENODEV.

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
---
diff --git a/drivers/message/fusion/mptsas.c b/drivers/message/fusion/mptsas.c
index dd10a82..0ac3881 100644
--- a/drivers/message/fusion/mptsas.c
+++ b/drivers/message/fusion/mptsas.c
@@ -2522,6 +2522,12 @@ mptsas_sas_device_pg0(MPT_ADAPTER *ioc, struct mptsas_devinfo *device_info,
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
 	error = mpt_config(ioc, &cfg);
+
+	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
+		error = -ENODEV;
+		goto out_free_consistent;
+	}
+
 	if (error)
 		goto out_free_consistent;
 
@@ -2598,14 +2604,14 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc, struct mptsas_portinfo *port_info,
 	cfg.action = MPI_CONFIG_ACTION_PAGE_READ_CURRENT;
 
 	error = mpt_config(ioc, &cfg);
-	if (error)
-		goto out_free_consistent;
-
-	if (!buffer->NumPhys) {
+	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
 		error = -ENODEV;
 		goto out_free_consistent;
 	}
 
+	if (error)
+		goto out_free_consistent;
+
 	/* save config data */
 	port_info->num_phys = (buffer->NumPhys) ? buffer->NumPhys : 1;
 	port_info->phy_info = kcalloc(port_info->num_phys,
@@ -2681,7 +2687,7 @@ mptsas_sas_expander_pg1(MPT_ADAPTER *ioc, struct mptsas_phyinfo *phy_info,
 
 	if (error == MPI_IOCSTATUS_CONFIG_INVALID_PAGE) {
 		error = -ENODEV;
-		goto out;
+		goto out_free_consistent;
 	}
 
 	if (error)
