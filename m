From: "Kashyap, Desai" <kashyap.desai@lsi.com>
Subject: [PATCH 2/9] mpt2sas: Expander Add oops saying "Already part of another port"
Date: Fri, 7 Aug 2009 19:34:26 +0530
Message-ID: <20090807140420.GC5807@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod7og116.obsmtp.com ([64.18.2.219]:47807 "EHLO
	exprod7og116.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754811AbZHGO0c (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 7 Aug 2009 10:26:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com, stable@kernel.org


Kernel panic is seen because driver did not tear down the port which should
be dnoe using mpt2sas_transport_port_remove(). without this fix When expander
is added back we would oops inside sas_port_add_phy.
---

Signed-off-by: Kashyap Desai <kashyap.desai@lsi.com>
Signed-off-by: Eric Moore <Eric.moore@lsi.com>
---
diff --git a/drivers/scsi/mpt2sas/mpt2sas_scsih.c b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
index b1326bf..918445e 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_scsih.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_scsih.c
@@ -3426,7 +3426,7 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 	__le64 sas_address;
 	int i;
 	unsigned long flags;
-	struct _sas_port *mpt2sas_port;
+	struct _sas_port *mpt2sas_port = NULL;
 	int rc = 0;
 
 	if (!handle)
@@ -3518,12 +3518,20 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 		    &expander_pg1, i, handle))) {
 			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
 			    ioc->name, __FILE__, __LINE__, __func__);
-			continue;
+			rc = -1;
+			goto out_fail;
 		}
 		sas_expander->phy[i].handle = handle;
 		sas_expander->phy[i].phy_id = i;
-		mpt2sas_transport_add_expander_phy(ioc, &sas_expander->phy[i],
-		    expander_pg1, sas_expander->parent_dev);
+
+		if ((mpt2sas_transport_add_expander_phy(ioc,
+		    &sas_expander->phy[i], expander_pg1,
+		    sas_expander->parent_dev))) {
+			printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+			    ioc->name, __FILE__, __LINE__, __func__);
+			rc = -1;
+			goto out_fail;
+		}
 	}
 
 	if (sas_expander->enclosure_handle) {
@@ -3540,8 +3548,9 @@ _scsih_expander_add(struct MPT2SAS_ADAPTER *ioc, u16 handle)
 
  out_fail:
 
-	if (sas_expander)
-		kfree(sas_expander->phy);
+	if (mpt2sas_port)
+		mpt2sas_transport_port_remove(ioc, sas_expander->sas_address,
+		    sas_expander->parent_handle);
 	kfree(sas_expander);
 	return rc;
 }
