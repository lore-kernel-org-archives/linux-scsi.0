From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: [PATCH] libsas: better error handling
Date: Mon, 16 Oct 2006 10:57:05 -0500
Message-ID: <1161014226.3433.16.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:45771 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161012AbWJPP5H (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Oct 2006 11:57:07 -0400
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com [172.17.6.40])
	by hancock.sc.steeleye.com (8.11.6/8.11.6) with ESMTP id k9GFv6118590
	for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2006 11:57:06 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi <linux-scsi@vger.kernel.org>

This replaces a few BUG_ON() statements with the correct failure error
handling.  There are still many more to do.

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-09-07 15:59:21.000000000 -0500
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-09-07 16:33:22.000000000 -0500
@@ -631,9 +631,12 @@ static struct domain_device *sas_ex_disc
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
 	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	BUG_ON(!phy->port);
-	/* FIXME: better error handling*/
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (unlikely(!phy->port))
+		goto out_err;
+	if (unlikely(sas_port_add(phy->port) != 0)) {
+		sas_port_free(phy->port);
+		goto out_err;
+	}
 	sas_ex_get_linkrate(parent, child, phy);
 
 	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
@@ -648,15 +651,14 @@ static struct domain_device *sas_ex_disc
 			SAS_DPRINTK("report phy sata to %016llx:0x%x returned "
 				    "0x%x\n", SAS_ADDR(parent->sas_addr),
 				    phy_id, res);
-			kfree(child);
-			return NULL;
+			goto out_free;
 		}
 		memcpy(child->frame_rcvd, &child->sata_dev.rps_resp.rps.fis,
 		       sizeof(struct dev_to_host_fis));
 
 		rphy = sas_end_device_alloc(phy->port);
-		/* FIXME: error handling */
-		BUG_ON(!rphy);
+		if (unlikely(!rphy))
+			goto out_free;
 
 		sas_init_dev(child);
 
@@ -672,16 +674,14 @@ static struct domain_device *sas_ex_disc
 				    "%016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
-			sas_rphy_free(rphy);
-			list_del(&child->dev_list_node);
-			kfree(child);
-			return NULL;
+			goto out_list_del;
 		}
 	} else if (phy->attached_tproto & SAS_PROTO_SSP) {
 		child->dev_type = SAS_END_DEV;
 		rphy = sas_end_device_alloc(phy->port);
 		/* FIXME: error handling */
-		BUG_ON(!rphy);
+		if (unlikely(!rphy))
+			goto out_free;
 		child->tproto = phy->attached_tproto;
 		sas_init_dev(child);
 
@@ -698,9 +698,7 @@ static struct domain_device *sas_ex_disc
 				    "at %016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
-			/* FIXME: this kfrees list elements without removing them */
-			//kfree(child);
-			return NULL;
+			goto out_list_del;
 		}
 	} else {
 		SAS_DPRINTK("target proto 0x%x at %016llx:0x%x not handled\n",
@@ -710,6 +708,16 @@ static struct domain_device *sas_ex_disc
 
 	list_add_tail(&child->siblings, &parent_ex->children);
 	return child;
+
+ out_list_del:
+	list_del(&child->dev_list_node);
+	sas_rphy_free(rphy);
+ out_free:
+	sas_port_delete(phy->port);
+ out_err:
+	phy->port = NULL;
+	kfree(child);
+	return NULL;
 }
 
 static struct domain_device *sas_ex_discover_expander(


