From: Mike Anderson <andmike@us.ibm.com>
Subject: [PATCH 1/2] sas transport: ref count update
Date: Wed, 22 Mar 2006 13:42:21 -0800
Message-ID: <20060322214221.GB661@us.ibm.com>
References: <20060322214119.GA661@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e36.co.us.ibm.com ([32.97.110.154]:50578 "EHLO
	e36.co.us.ibm.com") by vger.kernel.org with ESMTP id S1751224AbWCVVmX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 22 Mar 2006 16:42:23 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e36.co.us.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLgMuP019033
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 16:42:22 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.12.10/NCO/VER6.8) with ESMTP id k2MLjOOu184338
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:45:24 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id k2MLgMU6001944
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:42:22 -0700
Received: from hmsbounty.us.ibm.com (sig-9-76-215-94.mts.ibm.com [9.76.215.94])
	by d03av03.boulder.ibm.com (8.12.11/8.12.11) with ESMTP id k2MLgLMF001922
	for <linux-scsi@vger.kernel.org>; Wed, 22 Mar 2006 14:42:21 -0700
Content-Disposition: inline
In-Reply-To: <20060322214119.GA661@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Fix puts so that release functions will be called.

Signed-off-by: Mike Anderson <andmike@us.ibm.com>

 drivers/scsi/scsi_transport_sas.c |    6 ++----
 1 files changed, 2 insertions(+), 4 deletions(-)

Index: aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c
===================================================================
--- aic94xx-sas-2.6-patched.orig/drivers/scsi/scsi_transport_sas.c	2006-03-22 13:22:22.000000000 -0800
+++ aic94xx-sas-2.6-patched/drivers/scsi/scsi_transport_sas.c	2006-03-22 13:24:27.000000000 -0800
@@ -406,8 +406,6 @@ struct sas_phy *sas_phy_alloc(struct dev
 	if (!phy)
 		return NULL;
 
-	get_device(parent);
-
 	phy->number = number;
 
 	device_initialize(&phy->dev);
@@ -484,7 +482,7 @@ sas_phy_delete(struct sas_phy *phy)
 	transport_remove_device(dev);
 	device_del(dev);
 	transport_destroy_device(dev);
-	put_device(dev->parent);
+	put_device(dev);
 }
 EXPORT_SYMBOL(sas_phy_delete);
 
@@ -990,7 +988,7 @@ sas_rphy_delete(struct sas_rphy *rphy)
 
 	parent->rphy = NULL;
 
-	put_device(&parent->dev);
+	put_device(dev);
 }
 EXPORT_SYMBOL(sas_rphy_delete);
 
