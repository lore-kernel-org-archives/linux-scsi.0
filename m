From: <nagalakshmi.nandigama@lsi.com>
Subject: [PATCH 08/12] [SCSI] mpt2sas : While enabling phy, read the
 current port number from sas iounit page 0 instead of page 1
Date: Tue, 20 Mar 2012 12:08:11 +0530
Message-ID: <201203200637.q2K6bdFN032691@milmhbs0.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35281 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030265Ab2CTGho (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Mar 2012 02:37:44 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Nagalakshmi.Nandigama@lsi.com, Sathya.Prakash@lsi.com, Eric.Moore@lsi.com
Cc: jejb@kernel.org

While enabling phy, read the current port number from sas iounit page 0
instead of page 1.

The port number is changing after disabling/enabling phys using the SysFS interface
This is because the firmware behavour changed where it would read the the port number 
then set it to some different value even though Auto Port Config is turned on.  
With this change of behavour in FW, it is possible that the expanders are moved
from one port to another after disabling /enabling phys. This is occuring because
the port number in sas iounit page 1 is not matching up to the current port in 
page 0. In order to fix this the driver is modified to read the current 
port number from sas iounit page 0 instead of page 1.  Also copy the
port and phy flags over from page 0 to page 1.

Signed-off-by: Nagalakshmi Nandigama <nagalakshmi.nandigama@lsi.com>
---

diff --git a/drivers/scsi/mpt2sas/mpt2sas_transport.c b/drivers/scsi/mpt2sas/mpt2sas_transport.c
index ffadc75..3d04aca 100644
--- a/drivers/scsi/mpt2sas/mpt2sas_transport.c
+++ b/drivers/scsi/mpt2sas/mpt2sas_transport.c
@@ -1641,11 +1641,13 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 {
 	struct MPT2SAS_ADAPTER *ioc = phy_to_ioc(phy);
 	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 = NULL;
+	Mpi2SasIOUnitPage0_t *sas_iounit_pg0 = NULL;
 	Mpi2ConfigReply_t mpi_reply;
 	u16 ioc_status;
 	u16 sz;
 	int rc = 0;
 	unsigned long flags;
+	int i, discovery_active;
 
 	spin_lock_irqsave(&ioc->sas_node_lock, flags);
 	if (_transport_sas_node_find_by_sas_address(ioc,
@@ -1663,7 +1665,50 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 
 	/* handle hba phys */
 
-	/* sas_iounit page 1 */
+	/* read sas_iounit page 0 */
+	sz = offsetof(Mpi2SasIOUnitPage0_t, PhyData) + (ioc->sas_hba.num_phys *
+	    sizeof(Mpi2SasIOUnit0PhyData_t));
+	sas_iounit_pg0 = kzalloc(sz, GFP_KERNEL);
+	if (!sas_iounit_pg0) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		rc = -ENOMEM;
+		goto out;
+	}
+	if ((mpt2sas_config_get_sas_iounit_pg0(ioc, &mpi_reply,
+	    sas_iounit_pg0, sz))) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		rc = -ENXIO;
+		goto out;
+	}
+	ioc_status = le16_to_cpu(mpi_reply.IOCStatus) &
+	    MPI2_IOCSTATUS_MASK;
+	if (ioc_status != MPI2_IOCSTATUS_SUCCESS) {
+		printk(MPT2SAS_ERR_FMT "failure at %s:%d/%s()!\n",
+		    ioc->name, __FILE__, __LINE__, __func__);
+		rc = -EIO;
+		goto out;
+	}
+
+	/* unable to enable/disable phys when when discovery is active */
+	for (i = 0, discovery_active = 0; i < ioc->sas_hba.num_phys ; i++) {
+		if (sas_iounit_pg0->PhyData[i].PortFlags &
+		    MPI2_SASIOUNIT0_PORTFLAGS_DISCOVERY_IN_PROGRESS) {
+			printk(MPT2SAS_ERR_FMT "discovery is active on "
+			    "port = %d, phy = %d: unable to enable/disable "
+			    "phys, try again later!\n", ioc->name,
+			    sas_iounit_pg0->PhyData[i].Port, i);
+			discovery_active = 1;
+		}
+	}
+
+	if (discovery_active) {
+		rc = -EAGAIN;
+		goto out;
+	}
+
+	/* read sas_iounit page 1 */
 	sz = offsetof(Mpi2SasIOUnitPage1_t, PhyData) + (ioc->sas_hba.num_phys *
 	    sizeof(Mpi2SasIOUnit1PhyData_t));
 	sas_iounit_pg1 = kzalloc(sz, GFP_KERNEL);
@@ -1688,7 +1733,18 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 		rc = -EIO;
 		goto out;
 	}
-
+	/* copy Port/PortFlags/PhyFlags from page 0 */
+	for (i = 0; i < ioc->sas_hba.num_phys ; i++) {
+		sas_iounit_pg1->PhyData[i].Port =
+		    sas_iounit_pg0->PhyData[i].Port;
+		sas_iounit_pg1->PhyData[i].PortFlags =
+		    (sas_iounit_pg0->PhyData[i].PortFlags &
+		    MPI2_SASIOUNIT0_PORTFLAGS_AUTO_PORT_CONFIG);
+		sas_iounit_pg1->PhyData[i].PhyFlags =
+		    (sas_iounit_pg0->PhyData[i].PhyFlags &
+		    (MPI2_SASIOUNIT0_PHYFLAGS_ZONING_ENABLED +
+		    MPI2_SASIOUNIT0_PHYFLAGS_PHY_DISABLED));
+	}
 	if (enable)
 		sas_iounit_pg1->PhyData[phy->number].PhyFlags
 		    &= ~MPI2_SASIOUNIT1_PHYFLAGS_PHY_DISABLE;
@@ -1704,6 +1760,7 @@ _transport_phy_enable(struct sas_phy *phy, int enable)
 
  out:
 	kfree(sas_iounit_pg1);
+	kfree(sas_iounit_pg0);
 	return rc;
 }
 
