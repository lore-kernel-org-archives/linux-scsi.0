From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 3/4] aic94xx: cleanup after a discovery error
Date: Fri, 10 Nov 2006 16:48:24 -0800
Message-ID: <45551DD8.3090703@us.ibm.com>
References: <1163102636.6521.19.camel@localhost.localdomain>
Reply-To: "Darrick J. Wong" <djwong@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:1693 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S1424470AbWKKAs0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Nov 2006 19:48:26 -0500
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e33.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id kAB0mPxA025900
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 19:48:25 -0500
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id kAB0mPAa332726
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:48:25 -0700
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id kAB0mPP0028707
	for <linux-scsi@vger.kernel.org>; Fri, 10 Nov 2006 17:48:25 -0700
In-Reply-To: <1163102636.6521.19.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexis Bruemmer <alexisb@us.ibm.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

This patch applies the same cleanups to sas_discover_sata.
Note that this is against aic94xx-sas, not scsi-misc.

--

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>

diff --git a/drivers/scsi/libsas/sas_discover.c b/drivers/scsi/libsas/sas_discover.c
index 23461dc..dcd0461 100644
--- a/drivers/scsi/libsas/sas_discover.c
+++ b/drivers/scsi/libsas/sas_discover.c
@@ -552,7 +552,7 @@ int sas_discover_sata(struct domain_devi
 
 	res = sas_notify_lldd_dev_found(dev);
 	if (res)
-		return res;
+		goto out_err2;
 
 	switch (dev->dev_type) {
 	case SATA_DEV:
@@ -564,12 +564,25 @@ int sas_discover_sata(struct domain_devi
 	default:
 		break;
 	}
+	if (res)
+		goto out_err;
 
 	sas_notify_lldd_dev_gone(dev);
-	if (!res) {
-		sas_notify_lldd_dev_found(dev);
-		res = sas_rphy_add(dev->rphy);
-	}
+	res = sas_notify_lldd_dev_found(dev);
+	if (res)
+		goto out_err2;
+
+	res = sas_rphy_add(dev->rphy);
+	if (res)
+		goto out_err;
+
+	return res;
+
+out_err:
+	sas_notify_lldd_dev_gone(dev);
+out_err2:
+	sas_rphy_free(dev->rphy);
+	dev->rphy = NULL;
 	return res;
 }
 
