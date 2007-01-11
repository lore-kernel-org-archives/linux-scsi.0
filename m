From: "Darrick J. Wong" <djwong@us.ibm.com>
Subject: [PATCH 16/21] aic94xx: Lock DDB read/write accesses
Date: Thu, 11 Jan 2007 14:15:32 -0800
Message-ID: <20070111221532.3543.17094.stgit@elm3a70.beaverton.ibm.com>
References: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Content-Type: text/plain; charset=utf-8; format=fixed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e4.ny.us.ibm.com ([32.97.182.144]:57488 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932184AbXAKWPN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Jan 2007 17:15:13 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e4.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id l0BMFCmJ027702
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:12 -0500
Received: from d01av01.pok.ibm.com (d01av01.pok.ibm.com [9.56.224.215])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id l0BMFCVV199636
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:12 -0500
Received: from d01av01.pok.ibm.com (loopback [127.0.0.1])
	by d01av01.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id l0BMFCi9014412
	for <linux-scsi@vger.kernel.org>; Thu, 11 Jan 2007 17:15:12 -0500
In-Reply-To: <20070111221443.3543.95584.stgit@elm3a70.beaverton.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: djwong@us.ibm.com, linux-scsi@vger.kernel.org
Cc: alexisb@us.ibm.com


Extend the use of the DDB lock to include all DDB accesses, because
DDB updates now occur from multiple threads.  This fixes the SMP timeout
problems that we were occasionally seeing with a x260, because the
controller got confused when the DDBs got corrupted.

Signed-off-by: Darrick J. Wong <djwong@us.ibm.com>
---

 drivers/scsi/aic94xx/aic94xx_dev.c |   16 ++++++++--------
 drivers/scsi/aic94xx/aic94xx_seq.c |    3 +++
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/drivers/scsi/aic94xx/aic94xx_dev.c b/drivers/scsi/aic94xx/aic94xx_dev.c
index 6f8901b..c520e5b 100644
--- a/drivers/scsi/aic94xx/aic94xx_dev.c
+++ b/drivers/scsi/aic94xx/aic94xx_dev.c
@@ -37,18 +37,14 @@ #define CLEAR_DDB(_ddb, _ha) clear_bit(_
 
 static inline int asd_get_ddb(struct asd_ha_struct *asd_ha)
 {
-	unsigned long flags;
 	int ddb, i;
 
-	spin_lock_irqsave(&asd_ha->hw_prof.ddb_lock, flags);
 	ddb = FIND_FREE_DDB(asd_ha);
 	if (ddb >= asd_ha->hw_prof.max_ddbs) {
 		ddb = -ENOMEM;
-		spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
 		goto out;
 	}
 	SET_DDB(ddb, asd_ha);
-	spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
 
 	for (i = 0; i < sizeof(struct asd_ddb_ssp_smp_target_port); i+= 4)
 		asd_ddbsite_write_dword(asd_ha, ddb, i, 0);
@@ -77,14 +73,10 @@ #define ITNL_TIMEOUT    offsetof(struct 
 
 static inline void asd_free_ddb(struct asd_ha_struct *asd_ha, int ddb)
 {
-	unsigned long flags;
-
 	if (!ddb || ddb >= 0xFFFF)
 		return;
 	asd_ddbsite_write_byte(asd_ha, ddb, DDB_TYPE, DDB_TYPE_UNUSED);
-	spin_lock_irqsave(&asd_ha->hw_prof.ddb_lock, flags);
 	CLEAR_DDB(ddb, asd_ha);
-	spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
 }
 
 static inline void asd_set_ddb_type(struct domain_device *dev)
@@ -320,8 +312,11 @@ out:
 
 int asd_dev_found(struct domain_device *dev)
 {
+	unsigned long flags;
 	int res = 0;
+	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 
+	spin_lock_irqsave(&asd_ha->hw_prof.ddb_lock, flags);
 	switch (dev->dev_type) {
 	case SATA_PM:
 		res = asd_init_sata_pm_ddb(dev);
@@ -335,14 +330,18 @@ int asd_dev_found(struct domain_device *
 		else
 			res = asd_init_initiator_ddb(dev);
 	}
+	spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
+
 	return res;
 }
 
 void asd_dev_gone(struct domain_device *dev)
 {
 	int ddb, sister_ddb;
+	unsigned long flags;
 	struct asd_ha_struct *asd_ha = dev->port->ha->lldd_ha;
 
+	spin_lock_irqsave(&asd_ha->hw_prof.ddb_lock, flags);
 	ddb = (int) (unsigned long) dev->lldd_dev;
 	sister_ddb = asd_ddbsite_read_word(asd_ha, ddb, SISTER_DDB);
 
@@ -350,4 +349,5 @@ void asd_dev_gone(struct domain_device *
 		asd_free_ddb(asd_ha, sister_ddb);
 	asd_free_ddb(asd_ha, ddb);
 	dev->lldd_dev = NULL;
+	spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
 }
diff --git a/drivers/scsi/aic94xx/aic94xx_seq.c b/drivers/scsi/aic94xx/aic94xx_seq.c
index 0d343cf..2768fe4 100644
--- a/drivers/scsi/aic94xx/aic94xx_seq.c
+++ b/drivers/scsi/aic94xx/aic94xx_seq.c
@@ -1395,7 +1395,9 @@ void asd_update_port_links(struct asd_ha
 	u8  phy_is_up;
 	u8  mask;
 	int i, err;
+	unsigned long flags;
 
+	spin_lock_irqsave(&asd_ha->hw_prof.ddb_lock, flags);
 	for_each_phy(phy_mask, mask, i)
 		asd_ddbsite_write_byte(asd_ha, 0,
 				       offsetof(struct asd_ddb_seq_shared,
@@ -1415,6 +1417,7 @@ void asd_update_port_links(struct asd_ha
 			break;
 		}
 	}
+	spin_unlock_irqrestore(&asd_ha->hw_prof.ddb_lock, flags);
 
 	if (err)
 		asd_printk("couldn't update DDB 0:error:%d\n", err);
