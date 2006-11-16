From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Async scan changes -- now available as a git tree
Date: Wed, 15 Nov 2006 18:03:07 -0600
Message-ID: <1163635387.3524.20.camel@mulgrave.il.steeleye.com>
References: <20061115235324.GN19143@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:2532 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1162087AbWKPADO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Nov 2006 19:03:14 -0500
In-Reply-To: <20061115235324.GN19143@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

On Wed, 2006-11-15 at 16:53 -0700, Matthew Wilcox wrote:
> I've had a bug report about the aic94xx, but:
> <jejb> djwong, that can result because of the way libsas handles errors
> <jejb> I have a patch for that I should post
> 
> So I'm gleefully ignoring that problem for the moment.

OK, here's the error case fix I needed ... 

James

Index: BUILD-2.6/drivers/scsi/libsas/sas_expander.c
===================================================================
--- BUILD-2.6.orig/drivers/scsi/libsas/sas_expander.c	2006-11-10 07:13:13.000000000 -0600
+++ BUILD-2.6/drivers/scsi/libsas/sas_expander.c	2006-11-15 13:53:25.000000000 -0600
@@ -597,10 +597,15 @@ static struct domain_device *sas_ex_disc
 	child->iproto = phy->attached_iproto;
 	memcpy(child->sas_addr, phy->attached_sas_addr, SAS_ADDR_SIZE);
 	sas_hash_addr(child->hashed_sas_addr, child->sas_addr);
-	phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
-	BUG_ON(!phy->port);
-	/* FIXME: better error handling*/
-	BUG_ON(sas_port_add(phy->port) != 0);
+	if (!phy->port) {
+		phy->port = sas_port_alloc(&parent->rphy->dev, phy_id);
+		if (unlikely(!phy->port))
+			goto out_err;
+		if (unlikely(sas_port_add(phy->port) != 0)) {
+			sas_port_free(phy->port);
+			goto out_err;
+		}
+	}
 	sas_ex_get_linkrate(parent, child, phy);
 
 	if ((phy->attached_tproto & SAS_PROTO_STP) || phy->attached_sata_dev) {
@@ -615,8 +620,7 @@ static struct domain_device *sas_ex_disc
 			SAS_DPRINTK("report phy sata to %016llx:0x%x returned "
 				    "0x%x\n", SAS_ADDR(parent->sas_addr),
 				    phy_id, res);
-			kfree(child);
-			return NULL;
+			goto out_free;
 		}
 		memcpy(child->frame_rcvd, &child->sata_dev.rps_resp.rps.fis,
 		       sizeof(struct dev_to_host_fis));
@@ -627,14 +631,14 @@ static struct domain_device *sas_ex_disc
 				    "%016llx:0x%x returned 0x%x\n",
 				    SAS_ADDR(child->sas_addr),
 				    SAS_ADDR(parent->sas_addr), phy_id, res);
-			kfree(child);
-			return NULL;
+			goto out_free;
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
 
@@ -651,9 +655,7 @@ static struct domain_device *sas_ex_disc
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
@@ -663,6 +665,16 @@ static struct domain_device *sas_ex_disc
 
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


