From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 17/21] libsas: sysfs phy control attributes should not be S_IWUGO
Date: Thu, 11 Jan 2007 14:15:35 -0800
Message-ID: <20070111221535.3543.1571.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:35575 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177AbXAKWPV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:21 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFKdX026455
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:20 -0500
Received: from d01av03.pok.ibm.com (d01av03.pok.ibm.com [9.56.224.217])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFF3q135342
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:15 -0500
Received: from d01av03.pok.ibm.com (loopback [127.0.0.1])
	by d01av03.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFErt003881
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:15 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Allowing the phy reset controls to be world-triggerable does not seem like
a terribly good idea because SAS devices can be disrupted (and ATA devices
are really disrupted) by a phy reset.  By default only root should be able
to do things like that.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/scsi_transport_sas.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
index e57b02e..bfbcf5f 100644
--- a/drivers/scsi/scsi_transport_sas.c
+++ b/drivers/scsi/scsi_transport_sas.c
@@ -1446,10 +1446,10 @@ #define SETUP_OPTIONAL_PHY_ATTRIBUTE(fie
 	SETUP_TEMPLATE(phy_attrs, field, S_IRUGO, i->f->func)
 
 #define SETUP_PHY_ATTRIBUTE_WRONLY(field)				\
-	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, 1)
+	SETUP_TEMPLATE(phy_attrs, field, S_IWUSR, 1)
 
 #define SETUP_OPTIONAL_PHY_ATTRIBUTE_WRONLY(field, func)		\
-	SETUP_TEMPLATE(phy_attrs, field, S_IWUGO, i->f->func)
+	SETUP_TEMPLATE(phy_attrs, field, S_IWUSR, i->f->func)
 
 #define SETUP_END_DEV_ATTRIBUTE(field)					\
 	SETUP_TEMPLATE(end_dev_attrs, field, S_IRUGO, 1)
