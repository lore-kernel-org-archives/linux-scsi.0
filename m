From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] aic94xx: fix routing algorithms
Date: Sun, 09 Jul 2006 15:41:23 -0500
Message-ID: <1152477683.784.14.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:50909 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161134AbWGIUlZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 9 Jul 2006 16:41:25 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k69KfOY19616
	for <linux-scsi@vger.kernel.org>; Sun, 9 Jul 2006 16:41:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

I've been trying to work out for a while why certain cascaded expander
configurations work with the mptsas, but don't with the aic94xx.
Eventually I discovered that the non-functional configurations are the
ones where the cascaded expander is connected to the parent on table
routed ports.  The problem is that the aic94xx routing algorithms never
seem to consider the necessity of a route back to the HBA.  This patch
adds such a routing configuration, and now (at least for all my
configurations) the hitherto unseen disks become visible.

James

diff --git a/drivers/scsi/sas/sas_expander.c b/drivers/scsi/sas/sas_expander.c
index 10e0879..0dbeca5 100644
--- a/drivers/scsi/sas/sas_expander.c
+++ b/drivers/scsi/sas/sas_expander.c
@@ -33,6 +33,8 @@ #include "../scsi_sas_internal.h"
 
 static int sas_discover_expander(struct domain_device *dev);
 static int sas_configure_routing(struct domain_device *dev, u8 *sas_addr);
+static int sas_configure_phy(struct domain_device *dev, int phy_id,
+			     u8 *sas_addr, int include);
 static int sas_disable_routing(struct domain_device *dev,  u8 *sas_addr);
 
 #if 0
@@ -723,6 +725,8 @@ static int sas_ex_discover_dev(struct do
 	if (dev->parent && (SAS_ADDR(ex_phy->attached_sas_addr) ==
 			    SAS_ADDR(dev->parent->sas_addr))) {
 		sas_add_parent_port(dev, phy_id);
+		if (ex_phy->routing_attr == TABLE_ROUTING)
+			sas_configure_phy(dev, phy_id, dev->port->sas_addr, 1);
 		return 0;
 	}
 


