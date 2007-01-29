From: Eric Moore <eric.moore@lsi.com>
Subject: [PATCH 7/9] - fusion - report wide port sas address's for hba phys
Date: Mon, 29 Jan 2007 09:47:08 -0700
Message-ID: <20070129164708.GA1917@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:60690 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752519AbXA2Qqc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Jan 2007 11:46:32 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com

Return proper sas address to sas transport layer for parent phys that
form a wide port. Current implementation returns a different address
for each phy, incremented by one from the base address.

Signed-off-by: Eric Moore <Eric.Moore@lsi.com>

diff -uarpN b/drivers/message/fusion/mptsas.c a/drivers/message/fusion/mptsas.c
--- b/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
+++ a/drivers/message/fusion/mptsas.c	2007-01-28 12:57:29.000000000 -0700
@@ -169,6 +169,7 @@ struct mptsas_portinfo_details{
 };
 
 struct mptsas_phyinfo {
+	u16	handle;			/* unique id to address this */
 	u8	phy_id; 		/* phy index */
 	u8	port_id; 		/* firmware port identifier */
 	u8	negotiated_link_rate;	/* nego'd link rate for this phy */
@@ -184,7 +185,6 @@ struct mptsas_phyinfo {
 
 struct mptsas_portinfo {
 	struct list_head list;
-	u16		handle;		/* unique id to address this */
 	u16		num_phys;	/* number of phys */
 	struct mptsas_phyinfo *phy_info;
 };
@@ -1387,9 +1387,6 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc,
 		goto out_free_consistent;
 	}
 
-	if (port_info->num_phys)
-		port_info->handle =
-		    le16_to_cpu(buffer->PhyData[0].ControllerDevHandle);
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_print_phy_data(&buffer->PhyData[i]);
 		port_info->phy_info[i].phy_id = i;
@@ -1398,6 +1395,8 @@ mptsas_sas_io_unit_pg0(MPT_ADAPTER *ioc,
 		port_info->phy_info[i].negotiated_link_rate =
 		    buffer->PhyData[i].NegotiatedLinkRate;
 		port_info->phy_info[i].portinfo = port_info;
+		port_info->phy_info[i].handle =
+		    le16_to_cpu(buffer->PhyData[i].ControllerDevHandle);
 	}
 
  out_free_consistent:
@@ -1599,7 +1598,6 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
 
 	/* save config data */
 	port_info->num_phys = buffer->NumPhys;
-	port_info->handle = le16_to_cpu(buffer->DevHandle);
 	port_info->phy_info = kcalloc(port_info->num_phys,
 		sizeof(*port_info->phy_info),GFP_KERNEL);
 	if (!port_info->phy_info) {
@@ -1607,8 +1605,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
 		goto out_free_consistent;
 	}
 
-	for (i = 0; i < port_info->num_phys; i++)
+	for (i = 0; i < port_info->num_phys; i++) {
 		port_info->phy_info[i].portinfo = port_info;
+		port_info->phy_info[i].handle =
+		    le16_to_cpu(buffer->DevHandle);
+	}
 
  out_free_consistent:
 	pci_free_consistent(ioc->pcidev, hdr.ExtPageLength * 4,
@@ -1976,7 +1977,6 @@ static int
 mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 {
 	struct mptsas_portinfo *port_info, *hba;
-	u32 handle = 0xFFFF;
 	int error = -ENOMEM, i;
 
 	hba = kzalloc(sizeof(*port_info), GFP_KERNEL);
@@ -1988,34 +1988,36 @@ mptsas_probe_hba_phys(MPT_ADAPTER *ioc)
 		goto out_free_port_info;
 
 	mutex_lock(&ioc->sas_topology_mutex);
-	ioc->handle = hba->handle;
-	port_info = mptsas_find_portinfo_by_handle(ioc, hba->handle);
+	ioc->handle = hba->phy_info[0].handle;
+	port_info = mptsas_find_portinfo_by_handle(ioc, ioc->handle);
 	if (!port_info) {
 		port_info = hba;
 		list_add_tail(&port_info->list, &ioc->sas_topology);
 	} else {
-		port_info->handle = hba->handle;
-		for (i = 0; i < hba->num_phys; i++)
+		for (i = 0; i < hba->num_phys; i++) {
 			port_info->phy_info[i].negotiated_link_rate =
 				hba->phy_info[i].negotiated_link_rate;
+			port_info->phy_info[i].handle =
+				hba->phy_info[i].handle;
+			port_info->phy_info[i].port_id =
+				hba->phy_info[i].port_id;
+		}
 		kfree(hba->phy_info);
 		kfree(hba);
 		hba = NULL;
 	}
 	mutex_unlock(&ioc->sas_topology_mutex);
-
 	for (i = 0; i < port_info->num_phys; i++) {
 		mptsas_sas_phy_pg0(ioc, &port_info->phy_info[i],
 			(MPI_SAS_PHY_PGAD_FORM_PHY_NUMBER <<
 			 MPI_SAS_PHY_PGAD_FORM_SHIFT), i);
 
 		mptsas_sas_device_pg0(ioc, &port_info->phy_info[i].identify,
-			(MPI_SAS_DEVICE_PGAD_FORM_GET_NEXT_HANDLE <<
-			 MPI_SAS_DEVICE_PGAD_FORM_SHIFT), handle);
+			(MPI_SAS_DEVICE_PGAD_FORM_HANDLE <<
+			 MPI_SAS_DEVICE_PGAD_FORM_SHIFT),
+			 port_info->phy_info[i].handle);
 		port_info->phy_info[i].identify.phy_id =
-		    port_info->phy_info[i].phy_id;
-		handle = port_info->phy_info[i].identify.handle;
-
+		    port_info->phy_info[i].phy_id = i;
 		if (port_info->phy_info[i].attached.handle)
 			mptsas_sas_device_pg0(ioc,
 				&port_info->phy_info[i].attached,
@@ -2051,12 +2053,12 @@ mptsas_probe_expander_phys(MPT_ADAPTER *
 		goto out;
 
 	error = mptsas_sas_expander_pg0(ioc, ex,
-		(MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
-		 MPI_SAS_EXPAND_PGAD_FORM_SHIFT), *handle);
+	    (MPI_SAS_EXPAND_PGAD_FORM_GET_NEXT_HANDLE <<
+	     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), *handle);
 	if (error)
 		goto out_free_port_info;
 
-	*handle = ex->handle;
+	*handle = ex->phy_info[0].handle;
 
 	mutex_lock(&ioc->sas_topology_mutex);
 	port_info = mptsas_find_portinfo_by_handle(ioc, *handle);
@@ -2064,7 +2066,12 @@ mptsas_probe_expander_phys(MPT_ADAPTER *
 		port_info = ex;
 		list_add_tail(&port_info->list, &ioc->sas_topology);
 	} else {
-		port_info->handle = ex->handle;
+		for (i = 0; i < ex->num_phys; i++) {
+			port_info->phy_info[i].handle =
+				ex->phy_info[i].handle;
+			port_info->phy_info[i].port_id =
+				ex->phy_info[i].port_id;
+		}
 		kfree(ex->phy_info);
 		kfree(ex);
 		ex = NULL;
@@ -2156,7 +2163,8 @@ mptsas_delete_expander_phys(MPT_ADAPTER 
 
 		if (mptsas_sas_expander_pg0(ioc, &buffer,
 		     (MPI_SAS_EXPAND_PGAD_FORM_HANDLE <<
-		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT), port_info->handle)) {
+		     MPI_SAS_EXPAND_PGAD_FORM_SHIFT),
+		     port_info->phy_info[0].handle)) {
 
 			/*
 			 * Obtain the port_info instance to the parent port
